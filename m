From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Fix failed request error code
Date: Wed, 4 Apr 2018 09:35:51 +0200
Message-ID: <20180404093551.52d322db@pentland.suse.de>
References: <20180404065138.25534-1-damien.lemoal@wdc.com>
        <20180404085730.2df015c3@pentland.suse.de>
        <2726d8cc-6661-9934-cca4-abcdaa2199ba@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <2726d8cc-6661-9934-cca4-abcdaa2199ba@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, Hannes Reinecke <hare@suse.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 4 Apr 2018 07:06:58 +0000
Damien Le Moal <Damien.LeMoal@wdc.com> wrote:

> Hannes,
> 
> On 4/4/18 15:57, Hannes Reinecke wrote:
> > On Wed,  4 Apr 2018 15:51:38 +0900
> > Damien Le Moal <damien.lemoal@wdc.com> wrote:
> >   
> >> With the introduction of commit e39a97353e53 ("scsi: core: return
> >> BLK_STS_OK for DID_OK in __scsi_error_from_host_byte()"), a command
> >> that failed with hostbyte=DID_OK and driverbyte=DRIVER_SENSE but
> >> lacking additional sense information will have a return code set to
> >> BLK_STS_OK. This results in the request issuer to see successful
> >> request execution despite the failure. An example of such case is
> >> an unaligned write on a host managed ZAC disk connected to a SAS
> >> HBA with a malfunctioning SAT. The unaligned write command gets
> >> aborted but has no additional sense information.
> >>
> >> sd 10:0:0:0: [sde] tag#3905 FAILED Result: hostbyte=DID_OK
> >> driverbyte=DRIVER_SENSE sd 10:0:0:0: [sde] tag#3905 Sense Key :
> >> Aborted Command [current] sd 10:0:0:0: [sde] tag#3905 Add. Sense:
> >> No additional sense information sd 10:0:0:0: [sde] tag#3905 CDB:
> >> Write(16) 8a 00 00 00 00 00 02 0c 00 01 00 00 00 01 00 00
> >> print_req_error: I/O error, dev sde, sector 274726920
> >>
> >> In scsi_io_completion(), sense key handling to not change the
> >> request error code and success being reported to the issuer.
> >>
> >> Fix this by making sure that the error code always indicates an
> >> error if scsi_io_completion() decide that the action to be taken
> >> for a failed command is to not retry it and terminate it
> >> immediately (ACTION_FAIL) .
> >>
> >> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> >> Fixes: e39a97353e53 ("scsi: core: return BLK_STS_OK for DID_OK in
> >> __scsi_error_from_host_byte()") Cc: Hannes Reinecke <hare@suse.com>
> >> Cc: <stable@vger.kernel.org>
> >> ---
> >>  drivers/scsi/scsi_lib.c | 9 +++++++++
> >>  1 file changed, 9 insertions(+)
> >>
> >> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> >> index c84f931388f2..87579bfcc186 100644
> >> --- a/drivers/scsi/scsi_lib.c
> >> +++ b/drivers/scsi/scsi_lib.c
> >> @@ -1002,6 +1002,15 @@ void scsi_io_completion(struct scsi_cmnd
> >> *cmd, unsigned int good_bytes) scsi_print_command(cmd);
> >>  			}
> >>  		}
> >> +		/*
> >> +		 * The command failed and should not be retried.
> >> If the host
> >> +		 * byte is DID_OK, then
> >> __scsi_error_from_host_byte() returned
> >> +		 * BLK_STS_OK and error indicates a success. Make
> >> sure to not
> >> +		 * use that as the completion code and always
> >> return an
> >> +		 * I/O error.
> >> +		 */
> >> +		if (error == BLK_STS_OK)
> >> +			error = BLK_STS_IOERR;
> >>  		if (!scsi_end_request(req, error,
> >> blk_rq_err_bytes(req), 0)) return;
> >>  		/*FALLTHRU*/  
> > 
> > That looks wrong.
> > Shouldn't __scsi_error_from_host_byte() return the correct status
> > here?  
> 
> My drive said:
> 
> sd 10:0:0:0: [sde] tag#3905 FAILED Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> sd 10:0:0:0: [sde] tag#3905 Sense Key : Aborted Command [current]
> sd 10:0:0:0: [sde] tag#3905 Add. Sense: No additional sense
> information sd 10:0:0:0: [sde] tag#3905 CDB: Write(16) 8a 00 00 00 00
> 00 02 0c 00 01 00 00 00 01 00 00
> 
> Since hostbyte is DID_OK, __scsi_error_from_host_byte() returns
> BLK_STS_OK. The HBA fails to give sense data, so the ABORTED_COMMAND
> case in scsi_io_completion() "switch (sshdr.sense_key)" does nothing
> and error stays equal to success. scsi_end_request() gets called with
> that and dd sees a success...
> 
> There are also plenty of other sense keys cases where error is not
> changed despite the fact that error can be BLK_STS_SUCCESS (in fact, I
> think this is likely the most common case since an command failure
> with hostbyte=DID_OK and driverbyte=DRIVER_SENSE is probably the most
> common one.
> 
> My patch is a bit of a hammer and makes sure that an ACTION_FAIL
> request is completed as a failure... Am I getting all this wrong ?
> 

Just checked with the code, and send a new patch.
Which I find a bit clearer.

Fact is that __scsi_error_from_host_byte() is not sufficient to
evaluate the return code, so taking its return value with any further
checks is indeed wrong.
But then it never said so on the boilerplate of
__scsi_error_from_host_byte() ...

So please do check the 'v2' version of the patch.

Cheers,

Hannes
