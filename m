From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH 03/15] mpt3sas: Add sanity checks for scsi tracker before
 accessing it.
Date: Tue, 3 Apr 2018 10:11:18 +0530
Message-ID: <CAK=zhgqoJW0ASfQv4C4J=X9zXyuUhVdk-68xv=vFfHA_NSmLTg@mail.gmail.com>
References: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
 <1522402644-3016-4-git-send-email-chaitra.basappa@broadcom.com>
 <20180330115917.GA30423@infradead.org> <CAK=zhgosiBbQbdn2xnAffgRtzMEzp8_FLpSmY3m+XxwHuBCwNg@mail.gmail.com>
 <a4ec673d5dbd62e05bbc8c777de5e4a080c62336.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <a4ec673d5dbd62e05bbc8c777de5e4a080c62336.camel@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "Sathya.Prakash@broadcom.com" <Sathya.Prakash@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 2, 2018 at 8:55 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Mon, 2018-04-02 at 11:53 +0530, Sreekanth Reddy wrote:
>> On Fri, Mar 30, 2018 at 5:29 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> > On Fri, Mar 30, 2018 at 03:07:12PM +0530, Chaitra P B wrote:
>> > > Check scsi tracker for NULL before accessing it.
>> > > And in some places there are possibilities for getting valid st
>> > > but still other fields are not set.
>> >
>> > Please explain how that could ever happen.  You should never see
>> > a scsi_cmnd without the device pointer.
>>
>> Chris,
>>
>> Here is one example, During Host reset operation time driver will
>> flush out all the outstanding IO's to the SML in below function,
>>
>> static void
>> _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
>> {
>>         struct scsi_cmnd *scmd;
>>         struct scsiio_tracker *st;
>>         u16 smid;
>>         int count = 0;
>>
>> [SR] Here driver is looping starting from smid one to HBA queue depth.
>>         for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
>>
>> [SR] Some times it is possible that scsi_cmnd might have created at
>> SML but it might not be issued to the driver as host reset operation
>> is going on, So here we will get non-NULL scmd.
>>                 scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
>>                 if (!scmd)
>>                         continue;
>>                 count++;
>>                 _scsih_set_satl_pending(scmd, false);
>> [SR] Here we are trying to get the scsi tracker 'st' for the above
>> scmd (which is not received by the driver) and so fields of this 'st'
>> are uninitialized.
>>                 st = scsi_cmd_priv(scmd);
>> [SR] And here we are trying to clear the scsi tracker 'st' which is
>> not yet all initialized by the driver, in other terms we are trying to
>> flush out the scmd command which is not yet all received by the
>> driver.
>>                 mpt3sas_base_clear_st(ioc, st);
>>                 scsi_dma_unmap(scmd);
>>                 if (ioc->pci_error_recovery || ioc->remove_host)
>>                         scmd->result = DID_NO_CONNECT << 16;
>>                 else
>>                         scmd->result = DID_RESET << 16;
>>                 scmd->scsi_done(scmd);
>>         }
>>         dtmprintk(ioc, pr_info(MPT3SAS_FMT "completing %d cmds\n",
>>             ioc->name, count));
>> }
>
> Hello Sreekanth,
>
> From mpt3sas_scsih_scsi_lookup_get():
>
>                         st = scsi_cmd_priv(scmd);
>                         if (st->cb_idx == 0xFF)
>                                 scmd = NULL;
>
> From mpt3sas_base_get_smid(), mpt3sas_base_get_smid_scsiio() and
> mpt3sas_base_get_smid_hpr():
>
>         request->cb_idx = cb_idx;
>
> Can _scsih_flush_running_cmds() be executed concurrently with scsih_qcmd()?

[SR] No, driver calls _scsih_flush_running_cmds during Host reset time
and during host reset time driver will set 'ioc->shost_recovery' flag.
So in the scsih_qcmd() driver will return the incoming SCSI cmds with
"SCSI_MLQUEUE_HOST_BUSY" whenever 'ioc->shost_recovery' flag is set as
shown below,

/* host recovery or link resets sent via IOCTLs */
        if (ioc->shost_recovery || ioc->ioc_link_reset_in_progress)
                return SCSI_MLQUEUE_HOST_BUSY;

> In other words, can it happen that mpt3sas_scsih_scsi_lookup_get() sees that
> st->cb_idx == 0xff just before scsih_qcmd() assigns a value to .cb_idx? Can
> this cause _scsih_flush_running_cmds() to skip commands that it shouldn't
> skip?
[SR] No, it won't happen. as I explained above during host reset time
driver return the incoming SCSI commands with host busy status and
_scsih_flush_running_cmds called during the host reset time.

>
> Can it happen that _scsih_flush_running_cmds() calls .scsi_done() for a SCSI
> command just after scsih_qcmd() transferred control for that command to the
> firmware? Can that cause .scsi_done() to be called twice for the same command?
[SR] No, while _scsih_flush_running_cmds() function is getting
executed no SCSI commands are issued to the firmware.

>
> Thanks,
>
> Bart.
>
>
