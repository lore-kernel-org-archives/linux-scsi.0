From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH 03/15] mpt3sas: Add sanity checks for scsi tracker before
 accessing it.
Date: Mon, 2 Apr 2018 11:53:07 +0530
Message-ID: <CAK=zhgosiBbQbdn2xnAffgRtzMEzp8_FLpSmY3m+XxwHuBCwNg@mail.gmail.com>
References: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
 <1522402644-3016-4-git-send-email-chaitra.basappa@broadcom.com> <20180330115917.GA30423@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180330115917.GA30423@infradead.org>
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sathya Prakash <Sathya.Prakash@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 30, 2018 at 5:29 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Mar 30, 2018 at 03:07:12PM +0530, Chaitra P B wrote:
>> Check scsi tracker for NULL before accessing it.
>> And in some places there are possibilities for getting valid st
>> but still other fields are not set.
>
> Please explain how that could ever happen.  You should never see
> a scsi_cmnd without the device pointer.

Chris,

Here is one example, During Host reset operation time driver will
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

Thanks,
Sreekanth
