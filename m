From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH 10/20] [SCSI] mpt3sas: Add branding string support for
 OEM's HBA
Date: Thu, 18 Jun 2015 15:21:31 +0530
Message-ID: <CAK=zhgo_Fk9cEYiyc5ZuB=2rcmgtzV04e6-yzCR--GBK_nrG5w@mail.gmail.com>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1434102153-38581-11-git-send-email-Sreekanth.Reddy@avagotech.com>
	<20150615094654.GA5660@c203.arch.suse.de>
	<CAK=zhgpZ7mBoUCARfE96LkdahVUfCk3ULw-yYZ-8YDFbq24y6Q@mail.gmail.com>
	<20150615115358.GB10429@c203.arch.suse.de>
	<CAK=zhgqeff3bhdyw5QAA-3mbmyDqTrdrsY1-x1TBq-+oRBDF-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35468 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbbFRJvd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2015 05:51:33 -0400
Received: by wiga1 with SMTP id a1so165612186wig.0
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2015 02:51:32 -0700 (PDT)
In-Reply-To: <CAK=zhgqeff3bhdyw5QAA-3mbmyDqTrdrsY1-x1TBq-+oRBDF-A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi,

Any review comments on this patch. please let us known if any changes
are required.

Thanks,
Sreekanth


On Mon, Jun 15, 2015 at 5:30 PM, Sreekanth Reddy
<sreekanth.reddy@avagotech.com> wrote:
> On Mon, Jun 15, 2015 at 5:23 PM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
>> On Mon, Jun 15, 2015 at 04:41:56PM +0530, Sreekanth Reddy wrote:
>>> On Mon, Jun 15, 2015 at 3:16 PM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
>>> > On Fri, Jun 12, 2015 at 03:12:22PM +0530, Sreekanth Reddy wrote:
>>> >> Added the following Dell branding to the mpt3sas driver.
>>> >>
>>> >> "VendorID"   "DeviceID"  "SubsystemVendor ID"  "SubsystemDevice ID"  Dell Branding String
>>> >> 0x1000        0x0097          0x1028                 0x1F46            DELL 12Gbps HBA
>>> >>
>>> >> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
>>> >> ---
>>> >>  drivers/scsi/mpt3sas/mpt3sas_base.c | 36 ++++++++++++++++++++++++++++++++++++
>>> >>  drivers/scsi/mpt3sas/mpt3sas_base.h | 11 +++++++++++
>>> >>  2 files changed, 47 insertions(+)
>>> >>
>>> >> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
>>> >> index 6739c0a..db362cb 100644
>>> >> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>>> >> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>>> >> @@ -2345,6 +2345,41 @@ _base_display_intel_branding(struct MPT3SAS_ADAPTER *ioc)
>>> >>
>>> >>
>>> >>  /**
>>> >> + * _base_display_dell_branding - Display branding string
>>> >> + * @ioc: per adapter object
>>> >> + *
>>> >> + * Return nothing.
>>> >> + */
>>> >> +static void
>>> >> +_base_display_dell_branding(struct MPT3SAS_ADAPTER *ioc)
>>> >> +{
>>> >> +     if (ioc->pdev->subsystem_vendor != PCI_VENDOR_ID_DELL)
>>> >> +             return;
>>> >> +
>>> >> +     switch (ioc->pdev->device) {
>>> >> +     case MPI25_MFGPAGE_DEVID_SAS3008:
>>> >> +             switch (ioc->pdev->subsystem_device) {
>>> >> +             case MPT3SAS_DELL_12G_HBA_SSDID:
>>> >> +                     pr_info(MPT3SAS_FMT "%s\n", ioc->name,
>>> >> +                             MPT3SAS_DELL_12G_HBA_BRANDING);
>>> >> +                     break;
>>> >> +             default:
>>> >> +                     pr_info(MPT3SAS_FMT
>>> >> +                        "Dell 12Gbps HBA: Subsystem ID: 0x%X\n", ioc->name,
>>> >> +                        ioc->pdev->subsystem_device);
>>> >> +                     break;
>>> >> +             }
>>> >> +             break;
>>> >> +     default:
>>> >> +             pr_info(MPT3SAS_FMT
>>> >> +                     "Dell 12Gbps HBA: Subsystem ID: 0x%X\n", ioc->name,
>>> >> +                     ioc->pdev->subsystem_device);
>>> >> +             break;
>>> >> +     }
>>> >> +}
>>> >> +
>>> >> +
>>> >> +/**
>>> >>   * _base_display_ioc_capabilities - Disply IOC's capabilities.
>>> >>   * @ioc: per adapter object
>>> >>   *
>>> >> @@ -2374,6 +2409,7 @@ _base_display_ioc_capabilities(struct MPT3SAS_ADAPTER *ioc)
>>> >>           bios_version & 0x000000FF);
>>> >>
>>> >>       _base_display_intel_branding(ioc);
>>> >> +     _base_display_dell_branding(ioc);
>>> >>
>>> >>       pr_info(MPT3SAS_FMT "Protocol=(", ioc->name);
>>> >>
>>> >> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
>>> >> index 2318ef8..c4780c7 100644
>>> >> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
>>> >> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
>>> >> @@ -152,6 +152,17 @@
>>> >>  #define MPT3SAS_INTEL_RS3UC080_SSDID    0x3524
>>> >>
>>> >>  /*
>>> >> + * Dell HBA branding
>>> >> + */
>>> >> +#define MPT3SAS_DELL_12G_HBA_BRANDING       \
>>> >> +     "Dell 12Gbps HBA"
>>> >> +
>>> >> +/*
>>> >> + * Dell HBA SSDIDs
>>> >> + */
>>> >> +#define MPT3SAS_DELL_12G_HBA_SSDID   0x1F46
>>> >> +
>>> >> +/*
>>> >>   * status bits for ioc->diag_buffer_status
>>> >>   */
>>> >>  #define MPT3_DIAG_BUFFER_IS_REGISTERED       (0x01)
>>> >> --
>>> >> 2.0.2
>>> >>
>>> >> --
>>> >> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>> >> the body of a message to majordomo@vger.kernel.org
>>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> >
>>> > This might be something you might consider re-organizing for your code-base
>>> > merge as well, as it leads to a lot of code duplication the more OEMs you have.
>>>
>>> May I know which hunk of this patch may leads to code duplication for
>>> more OEMs we add? Whether declaring individual function for each OEMs
>>> leads to this code duplication.
>>
>> Hi Sreekanth,
>>
>> In
>> [PATCH 11/20] [SCSI] mpt3sas: Add branding string support for OEM custom HBA
>> you add _base_display_cisco_branding(). In
>> [PATCH 10/20] [SCSI] mpt3sas: Add branding string support for OEM's HBA
>> you add _base_display_dell_branding(). You already have
>> _base_display_intel_branding().
>>
>> Each of them follows the pattern:
>> 1) Check if it is a OEM device for XXX
>> 2) Check witch OEM device for XXX it is
>> 3) Display a string based on that specific OEM device
>> 4) Return
>
> Johannes,
>
> Thanks for detail explanation. I will take of this while merging the
> drivers code.
>
> Thanks a lot,
> Sreekanth
>>
>> Johannes
>
>
>
> --
>
> Regards,
> Sreekanth



-- 

Regards,
Sreekanth
