From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] scsi_error fix
Date: Fri, 07 Mar 2003 18:22:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E6929C0.6040703@splentec.com>
References: <UTC200303072019.h27KJXX12872.aeb@smtp.cwi.nl> <20030307211732.GA1148@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Andries.Brouwer@cwi.nl, linux-scsi@vger.kernel.org

Mike Anderson wrote:
> Andries.Brouwer@cwi.nl [Andries.Brouwer@cwi.nl] wrote:
> 
>>
>>    Your change effectively disables that support - we never hit the code in
>>    scsi_eh_get_sense() to request sense. It would be very nice if we could
>>    fix (or audit) all the scsi drivers, apply your change and remove
>>    scsi_eh_get_sense, but AFAIK that has not and is not happening.
>>
>>No. What happened before was that we got into an infinite loop.
>>The right action is to read the code, understand why it gets
>>into a loop, and fix it. Once that has happened we may decide
>>to undo my change. Or we may decide to ask for sense at that very spot.

``at that very spot'' or at a lower level (but not LLDD).

Yes, I agree with Andries here, and my reasoning follows:

> The loop problem is related to scsi error handling using the common code
> of scsi_queue_insert / scsi_requesT_fn . When a command gets started the
> scsi_init_cmd_errh function is called which sets retries to 0.

Ultimately the solution is fixing the LLDD.  Drawing from my own experience:
a quick and dirty way of simulating Autosense is to do it
*right in the scsi_done() fn* .

Add a flag sense_reqd:1 :: struct scsi_cmnd (stands for ``sense requested''),
which is normally 0, and at scsi_done() if we got CHECK CONDITION without
Sense Data, we (for older 2.4 kernels, NOT REAL C CODE):

    if we got CHECK COND and NO SENSE and SCpnt->sense_reqd == 0 then
	/* the original command is in the backup fields already */
	memcpy(SCpnt->cmnd, generic_sense, sizeof(generic_sense));
	memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
	SCpnt->sc_data_direction = SCSI_DATA_READ;
	SCpnt->request_buffer = &SCpnt->sense_buffer;
	SCpnt->request_bufflen = SCSI_SENSE_BUFFERSIZE;
	SCpnt->use_sg = 0;
	SCpnt->cmd_len = COMMAND_SIZE(SCpnt->cmnd[0]);
	SCpnt->result = 0;
	SCpnt->sense_reqd = 1;
	
	enqueue the command to be sent back to the LLDD.
  	(i.e. from pending_q to incoming_q at front -- the only instance of
	backwardness which I spoke of in an older email...)
   else
	/* normal process */
	enqueue the command into the done_q;
	schedule scsi soft irq;
   fi

The only problem with this solution is that if the driver does it's own
queuing and NACA = 0 (normally) in the CONTROL BYTE of the CDB, then
the Sense Data gets wiped out* at the recept of the next command by the Device
Server (unless it's REQUEST SENSE).  Thus, the only true solution is to fix
it at LLDD level, but with the above solution we get as close to it,
but no closer. :-)

* CA (Contingent Allegiance), now obsolete as of SAM-3r05, since Autosense
is mandatory.

> There maybe another issue with the scsi_eh_get_sense function, but I am
> still looking at it.

I have a problem with fixing Autosense at such higher level in SCSI Core.
I.e. having its own function and going through the normal path of SCSI Commands.
It should be a hack, since this is what Non-Autosense is.

I.e. SCSI Core itself should *not* know about Autosense and Non-Autosense
complient drivers.  Thus, this is best fixed at scsi_done() fn.

I.e. the workings of SCSI Core should assume Autosense -- first because
it makes sense, and secondly because it's mandatory as of SAM-3r05.

And if the Sense Data got back nil, i.e. it got wiped out, then we just bubble up
the command (since sense_reqd would == 1).

At this (low) level there's no need to count retries.  At higher level in
SCSI Core, it's ok, but for Autosense we just have to be as quiet as possible.

Note: there are devices which will report CHECK CONDITION but will
never give a valid Sense Data -- those are the ones which could
really break a shaky recovery logic (normally infinite loop).

I've also gotten into an infinite loop in simulating Autosense in my own
mini-scsi-core, but this was resolved by following more or less the
aforementioned framework.

-- 
Luben


