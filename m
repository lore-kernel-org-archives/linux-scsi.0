From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: Re: [PATCH V3 10/16] scsi: ufs: add UFS power management support
Date: Mon, 15 Sep 2014 11:09:57 -0000
Message-ID: <f3b54dbf779aec8a7481f85514abe535.squirrel@www.codeaurora.org>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
    <1410350063-23267-11-git-send-email-draviv@codeaurora.org>
    <CAC5umyiXWw6n3Dd+cngHmrXsZEsc8_Vfg9Yp22cMy_MQ0uZrLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:36846 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbaIOLJ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Sep 2014 07:09:58 -0400
In-Reply-To: <CAC5umyiXWw6n3Dd+cngHmrXsZEsc8_Vfg9Yp22cMy_MQ0uZrLw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dolev Raviv <draviv@codeaurora.org>, Jej B <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>


> 2014-09-10 20:54 GMT+09:00 Dolev Raviv <draviv@codeaurora.org>:
>> +static inline void ufshcd_enable_irq(struct ufs_hba *hba)
>> +{
>> +       if (!hba->is_irq_enabled) {
>> +               enable_irq(hba->irq);
>> +               hba->is_irq_enabled = true;
>> +       }
>> +}
>> +
>> +static inline void ufshcd_disable_irq(struct ufs_hba *hba)
>> +{
>> +       if (hba->is_irq_enabled) {
>> +               disable_irq(hba->irq);
>> +               hba->is_irq_enabled = false;
>> +       }
>> +}
>
> This IRQ could be shared among several devices because it is requested
> with IRQF_SHARED.  So enable_irq()/disable_irq() should be replaced with
> request_irq()/free_irq()?  Otherwise other devices which share the same
> IRQ will be malfunction while disabling IRQ.

Thanks, I will test your suggestion.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation


