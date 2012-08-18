From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Remove unused se_cmd.cmd_spdtl
Date: Fri, 17 Aug 2012 18:02:12 -0700
Message-ID: <1345251732.25161.284.camel@haakon2.linux-iscsi.org>
References: <1345091092-4539-1-git-send-email-roland@kernel.org>
	 <CAL1RGDVOdPCOv-frz6UkD9DKp_DW10MmWyWQA7CnyDeGqSQ6=Q@mail.gmail.com>
	 <1345155175.25161.85.camel@haakon2.linux-iscsi.org>
	 <CAG4TOxNfzdSKUcB0sEb_WnaBeOUOiSms0hkX3NiY6GShrvuXjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAG4TOxNfzdSKUcB0sEb_WnaBeOUOiSms0hkX3NiY6GShrvuXjA@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <mail@hannes-reinecke.de>, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-08-17 at 11:46 -0700, Roland Dreier wrote:
> On Thu, Aug 16, 2012 at 3:12 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> > index 0eaae23..63b3594 100644
> > --- a/drivers/target/target_core_transport.c
> > +++ b/drivers/target/target_core_transport.c
> > @@ -1183,15 +1183,20 @@ int target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
> >                         /* Returns CHECK_CONDITION + INVALID_CDB_FIELD */
> >                         goto out_invalid_cdb_field;
> >                 }
> > -
> > +               /*
> > +                * For the overflow case keep the existing fabric provided
> > +                * ->data_length.  Otherwise for the underflow case, reset
> > +                * ->data_length to the smaller SCSI expected data transfer
> > +                * length.
> > +                */
> >                 if (size > cmd->data_length) {
> >                         cmd->se_cmd_flags |= SCF_OVERFLOW_BIT;
> >                         cmd->residual_count = (size - cmd->data_length);
> >                 } else {
> >                         cmd->se_cmd_flags |= SCF_UNDERFLOW_BIT;
> >                         cmd->residual_count = (cmd->data_length - size);
> > +                       cmd->data_length = size;
> >                 }
> > -               cmd->data_length = size;
> >         }
> >
> >         return 0;
> 
> I don't think this can work... if my memory of the code is right, if we do this,
> then the target core will only allocate the smaller (fabric) data length worth
> of buffer space, but then it will actually execute whatever the CDB says to
> do. 

No, or at least that is not what happens anymore with current target
core + iscsi-target code..

The se_cmd->data_length re-assignment here is what will be used by
iscsi-target fabric code for all iSCSI descriptor related allocations
+ransfer, instead of the original fabric 'expected transfer length' that
declares the size of the SCSI initiator's available buffer at the other
end.

At one point in v4.0 code iscsi-target had it's own
iscsi_cmd->data_length (which might be what your thinking of), but this
was removed during 3.4 by Agrover in favor of just using
se_cmd->data_length from the possibly underflow adjusted value.

>  So in my original example we're probably OK because we'll allocate a
> full page anyway, but I think something like:
> 
> # sg_raw -r512 /dev/sda 28 0 0 0 0 0 0 0 9 0
> 
> would cause the target core to allocate 1 page but then read 9 sectors.
> 

With the patch above to target_cmd_size_check() in place to skip
re-assignment of se_cmd->data_length for the overflow case, it appears
the target (at least) is doing the right thing now with your test case:

[root@initiator ~]# sg_raw -r512 /dev/sdi 28 0 0 0 0 0 0 0 9 0
sg_raw -r512 /dev/sdi 28 0 0 0 0 0 0 0 9 0
SCSI Status: Good 

Sense Information:
sense buffer empty

Received -3584 bytes of data:

Target side:

[82582.697668] Got SCSI Command, ITT: 0x7e000040, CmdSN: 0x000002d9, ExpXferLen: 512, Length: 0, CID: 0
[82582.697673] TARGET_CORE[iSCSI]: Expected Transfer Length: 512 does not match SCSI CDB Length: 4608 for SAM Opcode: 0x28
[82582.709696] Received CmdSN matches ExpCmdSN, incremented ExpCmdSN to: 0x000002da
[82582.709876] Updated MaxCmdSN to 0x000002f9
[82582.709881] Built DataIN ITT: 0x7e000040, StatSN: 0x905625fd, DataSN: 0x00000000, Offset: 0, Length: 512, CID: 0

So aside from the open-iscsi client bugs that Boaz has pointed out wrt
to overflow/underflow handling, I'll verify over the weekend with
loopback + tcm_qla2xxx fabrics and if everything looks fine will plan to
include this patch into master -> for next week's 3.6-rc-fixes PULL
request.

Thanks Roland!

--nab
