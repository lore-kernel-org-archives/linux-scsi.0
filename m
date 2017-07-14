From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH 02/13] mpt3sas: SGL to PRP Translation for I/Os to NVMe devices
Date: Fri, 14 Jul 2017 18:57:33 +0530
Message-ID: <CA+RiK67fK5MRxm=Cg4Ymy4us2j27N3aXU1AMpOo0iHsiM_-a8g@mail.gmail.com>
References: <1499763313-7214-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1499763313-7214-3-git-send-email-suganath-prabu.subramani@broadcom.com> <20170712000402.GA27718@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:32835 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754546AbdGNN1f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2017 09:27:35 -0400
Received: by mail-wr0-f177.google.com with SMTP id u110so3003708wrb.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2017 06:27:34 -0700 (PDT)
In-Reply-To: <20170712000402.GA27718@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: "JBottomley@Parallels.com" <JBottomley@parallels.com>, "jejb@kernel.org" <jejb@kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sathya.Prakash@broadcom.com" <Sathya.Prakash@broadcom.com>, "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

Hi Keith,
We have made change and submitted V2 of patch set.

Thanks,
Suganath Prabu S

On Wed, Jul 12, 2017 at 5:34 AM, Keith Busch <keith.busch@intel.com> wrote:
> On Tue, Jul 11, 2017 at 01:55:02AM -0700, Suganath Prabu S wrote:
>> +/**
>> + * _base_check_pcie_native_sgl - This function is called for PCIe end devices to
>> + * determine if the driver needs to build a native SGL.  If so, that native
>> + * SGL is built in the special contiguous buffers allocated especially for
>> + * PCIe SGL creation.  If the driver will not build a native SGL, return
>> + * TRUE and a normal IEEE SGL will be built.  Currently this routine
>> + * supports NVMe.
>> + * @ioc: per adapter object
>> + * @mpi_request: mf request pointer
>> + * @smid: system request message index
>> + * @scmd: scsi command
>> + * @pcie_device: points to the PCIe device's info
>> + *
>> + * Returns 0 if native SGL was built, 1 if no SGL was built
>> + */
>> +static int
>> +_base_check_pcie_native_sgl(struct MPT3SAS_ADAPTER *ioc,
>> +     Mpi25SCSIIORequest_t *mpi_request, u16 smid, struct scsi_cmnd *scmd,
>> +     struct _pcie_device *pcie_device)
>> +{
>
> <snip>
>
>> +     /* Return 0, indicating we built a native SGL. */
>> +     return 1;
>> +}
>
> This function doesn't return 0 ever. Not sure why it's here.
>
> Curious about your device, though, if a nvme native SGL can *not* be
> built, does the HBA firmware then buffer it in its local memory before
> sending/receiving to/from the host?
>
> And if a native SGL can be built, does the NVMe target DMA directly
> to/from host memory, giving a performance boost?
