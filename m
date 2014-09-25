From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: Re: [PATCH V5 11/17] scsi: ufs: add UFS power management support
Date: Thu, 25 Sep 2014 10:35:09 -0000
Message-ID: <d230f9619ff72cc21f14fb687e40d3f1.squirrel@www.codeaurora.org>
References: <1411571653-22729-1-git-send-email-draviv@codeaurora.org>
    <1411571653-22729-12-git-send-email-draviv@codeaurora.org>
    <CAC5umyidmPpq4r3J5yj3K1jTZdxoM_BO=ZxrLbA7Y2YoXpbHfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <CAC5umyidmPpq4r3J5yj3K1jTZdxoM_BO=ZxrLbA7Y2YoXpbHfw@mail.gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dolev Raviv <draviv@codeaurora.org>, Jej B <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Thanks Mita,
You are right these are careless mistakes.
I will fix all of them and upload a new version shortly.

> __ufshcd_send_uic_cmd() is called with host_lock held here, but
> host_lock is acquired again in __ufshcd_send_uic_cmd().  So it causes
> recursive deadlock.

Correct I forgot to complete the fix.

>
> ufshcd_wait_for_uic_cmd() is already called in the previous
> __ufshcd_send_uic_cmd() call.
>
> These two issues don't exist in v3.

Same fix I forgot to complete from earlier comment.

>
> I was still seeing null pointer derefence with v4 which I was reported
> (http://marc.info/?l=linux-scsi&m=141087506802548) and nothing
> changed in v5.  Could you check if the fix is needed?
>
Sure, my mistake. I'll defiantly add a null pointer check in
ufshcd_config_vreg_hpm & ufshcd_config_vreg_lpm, to reduce overhead when
vregs are not initialized.

Thanks,
Dolev

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
