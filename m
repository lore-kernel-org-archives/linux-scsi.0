From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH 03/15] mpt3sas: Add sanity checks for scsi tracker before
 accessing it.
Date: Wed, 4 Apr 2018 17:58:14 +0530
Message-ID: <CAK=zhgo+hDuOrjspWzw56+OObLDe0XvNRUURxLHJZTftkK2q0A@mail.gmail.com>
References: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
 <1522402644-3016-4-git-send-email-chaitra.basappa@broadcom.com>
 <20180330115917.GA30423@infradead.org> <CAK=zhgosiBbQbdn2xnAffgRtzMEzp8_FLpSmY3m+XxwHuBCwNg@mail.gmail.com>
 <a4ec673d5dbd62e05bbc8c777de5e4a080c62336.camel@wdc.com> <CAK=zhgqoJW0ASfQv4C4J=X9zXyuUhVdk-68xv=vFfHA_NSmLTg@mail.gmail.com>
 <b0c9d6448cd7f47536a86d0608a2a0dde1715573.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <b0c9d6448cd7f47536a86d0608a2a0dde1715573.camel@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "hch@infradead.org" <hch@infradead.org>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "Sathya.Prakash@broadcom.com" <Sathya.Prakash@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 3, 2018 at 9:26 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Tue, 2018-04-03 at 10:11 +0530, Sreekanth Reddy wrote:
>> [SR] No, driver calls _scsih_flush_running_cmds during Host reset time
>> and during host reset time driver will set 'ioc->shost_recovery' flag.
>> So in the scsih_qcmd() driver will return the incoming SCSI cmds with
>> "SCSI_MLQUEUE_HOST_BUSY" whenever 'ioc->shost_recovery' flag is set as
>> shown below,
>>
>> /* host recovery or link resets sent via IOCTLs */
>>         if (ioc->shost_recovery || ioc->ioc_link_reset_in_progress)
>>                 return SCSI_MLQUEUE_HOST_BUSY;
>
> The ioc->shost_recovery flag is involved in at least the following race:
> * From one context a SCSI command is submitted and scsih_qcmd() gets called.
> * At the same time sg_reset is invoked from a shell and triggers a call to
>   scsih_host_reset(). That function in turn will call
>   mpt3sas_base_hard_reset_handler().
>
> I think this scenario can cause ioc->shost_recovery to be set by the mpt3sas
> driver after it has been checked by the scsih_qcmd() function.

Then these outstanding commands will be get flush by the driver in
_scsih_flush_running_cmds() function which we call as a part of host
reset operation.

>
> Anyway, let's get back to patch 03/15 at the start of this e-mail thread.
> That patch looks to me like an incomplete attempt to work around a race
> condition in the mpt3sas driver. I don't expect that anyone will trust that
> patch without further explanation. Which race condition does that patch
> address? And why do the mpt3sas maintainers believe that this patch is
> sufficient to address that race condition?

Sure Bart, we will add proper description with the information which I
explained in this mail thread on how this patch will fix below issue,

During Host reset operation time driver will
flush out all the outstanding IO's to the SML in below function,

static void
_scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
{
        struct scsi_cmnd *scmd;
        struct scsiio_tracker *st;
        u16 smid;
        int count = 0;

[SR] Here driver is looping starting from smid one to HBA queue depth.
        for (smid = 1; smid <= ioc->scsiio_depth; smid++) {

[SR] Some times it is possible that scsi_cmnd might have created at
SML but it might not be issued to the driver as host reset operation
is going on, So here we will get non-NULL scmd.
                scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
                if (!scmd)
                        continue;
                count++;
                _scsih_set_satl_pending(scmd, false);
[SR] Here we are trying to get the scsi tracker 'st' for the above
scmd (which is not received by the driver) and so fields of this 'st'
are uninitialized.
                st = scsi_cmd_priv(scmd);
[SR] And here we are trying to clear the scsi tracker 'st' which is
not yet all initialized by the driver, in other terms we are trying to
flush out the scmd command which is not yet all received by the
driver.
                mpt3sas_base_clear_st(ioc, st);
                scsi_dma_unmap(scmd);
                if (ioc->pci_error_recovery || ioc->remove_host)
                        scmd->result = DID_NO_CONNECT << 16;
                else
                        scmd->result = DID_RESET << 16;
                scmd->scsi_done(scmd);
        }
        dtmprintk(ioc, pr_info(MPT3SAS_FMT "completing %d cmds\n",
            ioc->name, count));
}

>
> Thanks,
>
> Bart.
>
