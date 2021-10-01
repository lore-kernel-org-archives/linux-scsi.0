Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA450C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 17:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC87B6126A
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 17:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355347AbhJARX2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Oct 2021 13:23:28 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:47196 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354507AbhJARXO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2021 13:23:14 -0400
Received: from mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19])
        by mail-1.ca.inter.net (Postfix) with ESMTP id BB4A82EA9EC;
        Fri,  1 Oct 2021 13:21:26 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19]) (amavisd-new, port 10024)
        with ESMTP id LjGWOt4lj-jX; Fri,  1 Oct 2021 13:21:26 -0400 (EDT)
Received: from [192.168.48.23] (host-23-91-187-47.dyn.295.ca [23.91.187.47])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id EA0922EA7B3;
        Fri,  1 Oct 2021 13:21:25 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 2/2] scsi: ufs: Stop clearing unit attentions
To:     Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Bart Van Assche <bvanassche@google.com>
References: <20210930195237.1521436-1-jaegeuk@kernel.org>
 <20210930195237.1521436-2-jaegeuk@kernel.org>
 <12ba3462-ac6b-ef35-4b5e-e0de6086ab51@intel.com>
 <f2436720-16d5-58da-abcc-20fa1ed01fb9@intel.com>
 <5e087a0f-7ae0-41d1-c1f1-e5cc0ad2d38f@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <f4f81b75-9b0b-7734-ebfa-14bd1b935c54@interlog.com>
Date:   Fri, 1 Oct 2021 13:21:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5e087a0f-7ae0-41d1-c1f1-e5cc0ad2d38f@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-10-01 12:59 p.m., Bart Van Assche wrote:
> On 9/30/21 11:52 PM, Adrian Hunter wrote:
>> Finally, there is another thing to change.  The reason
>> ufshcd_suspend_prepare() does a runtime resume of sdev_rpmb is because the
>> UAC clear would wait for an async runtime resume, which will never happen
>> during system suspend because the PM workqueue gets frozen.  So with the
>> removal of UAC clear, ufshcd_suspend_prepare() and ufshcd_resume_complete()
>> should be updated also, to leave rpmb alone.

Somewhat related ...

Since there was some confusion among the members of T10 of what precisely
the RPM bit meant, in SPC-6 revision (draft), a new "HOT PLUGGABLE" two
bit field was introduced into the standard INQUIRY response:

                 Table 151 — HOT PLUGGABLE field

Code   Description
00b    No information is provided regarding whether SCSI target device is hot
        pluggable.
01b    The SCSI target device is designed to be removed from a SCSI domain as
        a single object (i.e., concurrent removal of the SCSI target ports,
        logical units, and all other objects contained in that SCSI target
        device (see SAM-6)) while that SCSI domain continues to operate for
        all other SCSI target devices, if any, in that SCSI domain.
10b    The SCSI target device is not designed to be removed from a SCSI
        domain while that SCSI domain continues to operate.
11b    Reserved

That field is bits 5 and 4 of byte 1 of the response.

Perhaps we should be adding provision for this new field.

Doug Gilbert

> 
> Is the following change what you have in mind?
> 
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 0a28cc4c09d8..0743f54e55f9 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -9648,10 +9648,6 @@ void ufshcd_resume_complete(struct device *dev)
>           ufshcd_rpm_put(hba);
>           hba->complete_put = false;
>       }
> -    if (hba->rpmb_complete_put) {
> -        ufshcd_rpmb_rpm_put(hba);
> -        hba->rpmb_complete_put = false;
> -    }
>   }
>   EXPORT_SYMBOL_GPL(ufshcd_resume_complete);
> 
> @@ -9674,10 +9670,6 @@ int ufshcd_suspend_prepare(struct device *dev)
>           }
>           hba->complete_put = true;
>       }
> -    if (hba->sdev_rpmb) {
> -        ufshcd_rpmb_rpm_get_sync(hba);
> -        hba->rpmb_complete_put = true;
> -    }
>       return 0;
>   }
>   EXPORT_SYMBOL_GPL(ufshcd_suspend_prepare);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 86b615023ecb..5ecfcd8cae0a 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -921,7 +921,6 @@ struct ufs_hba {
>   #endif
>       u32 luns_avail;
>       bool complete_put;
> -    bool rpmb_complete_put;
>   };
> 
>   /* Returns true if clocks can be gated. Otherwise false */
> 
> 
> 
> Thanks,
> 
> Bart.

