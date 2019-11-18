Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CCBFC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 13:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D37F22089D
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 13:10:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fqB5MnuD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfKRNKU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 08:10:20 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:40758 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfKRNKU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 08:10:20 -0500
Received: by mail-io1-f68.google.com with SMTP id p6so18645718iod.7;
        Mon, 18 Nov 2019 05:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mr9WfdYenNY5j6q7FL+eHIEixX6YeeRurCUnT8vUnEs=;
        b=fqB5MnuDAxJO3/DiqejJmL5scs9pBMIq5XTY1NeMgvv58+6kp89L0dKnOjrWNtfTJg
         p70M1sYCh3VS4qTCizRbeoIS/4jvVPWvELlHstpA0nw9GEVek6BlAP5v1uvnHDK/ojbK
         cevJLmUyCIQ5qg+J8NqpwEJ+dULhmAckc+7xBvVV/JFpUDaE7iBBKuiScgD3yD3jveTt
         rjPvXohLFrIr0t1SnljYMG0wTN82t1yE46Ng9rqGEgz7jgyOoUMXls+ddmuQKb5pVTkX
         iGRU6HQ5lz/4oH5eoKImGXsyPGr0M2qd8Ya4MwAvpQThhKZV3KSKgNLEck7KD9tMu+Q7
         dAxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mr9WfdYenNY5j6q7FL+eHIEixX6YeeRurCUnT8vUnEs=;
        b=jL2/m1tokODl8qXThbdH3Um/CDXaS58mC6IJd/qQCcobgbsHeR4ILxZ56AEqWhMfEZ
         rQYpjsmxfdR/cJ8cghWFgC7Ee3+CUXEnzQaxl3Gj2mdyEGv3QT7XM1NmD7jof5LDMTh4
         iDJcAyWIO19lLXZkkfmqH6yNO6TCe4NMfxxVngSFSRIpfl66O3UPryKLa/J8ovDUzz/2
         lWJv4vtUBTjb9YhWNDAdFhJOT7jMNjN2E1NHAicHvusRd8uIkhzQD5No6p3yahIO3TRX
         eolB7HJJEn8nVatTOoorrMW/M/jVJTcoMvlnnb1YZxyi7hm9UwbAg4786DiIMHuIZ0pI
         hdKQ==
X-Gm-Message-State: APjAAAWeJWFIvIWzuPUWSCe6yDdV491XZnlFkxSLwKDVB595MXxlI5JI
        u7o8T8lJLlZ/t2P1BeqTpJ86AnvVJvJuoQ2NiJ8=
X-Google-Smtp-Source: APXvYqzMWwRt3LsZ3Wc4TX0zDV2JaPQ1dgITFcbslb0uvtzmnIqb6OrDdYxptOIB1WM3szTirFd5cdKiPG7vFgQHLeE=
X-Received: by 2002:a5d:9547:: with SMTP id a7mr13306711ios.198.1574082619341;
 Mon, 18 Nov 2019 05:10:19 -0800 (PST)
MIME-Version: 1.0
References: <1574049061-11417-1-git-send-email-cang@qti.qualcomm.com> <1574049061-11417-2-git-send-email-cang@qti.qualcomm.com>
In-Reply-To: <1574049061-11417-2-git-send-email-cang@qti.qualcomm.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Mon, 18 Nov 2019 18:39:43 +0530
Message-ID: <CAGOxZ51ddstawjBryo92+6Qhgy8g+ZU2PorUNguwv_d8n5Yj6Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] scsi: ufs: Recheck bkops level if bkops is disabled
To:     Can Guo <cang@qti.qualcomm.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com,
        Mark Salyzyn <salyzyn@google.com>,
        Can Guo <cang@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Can

On Mon, Nov 18, 2019 at 9:21 AM Can Guo <cang@qti.qualcomm.com> wrote:
>
> From: Asutosh Das <asutoshd@codeaurora.org>
>
> Bkops level should be rechecked upon receiving an exception.
> Currently the bkops level is being cached and never updated.
>
> Update the same each time the level is checked.
> Also do not use the cached bkops level value if it is disabled
> and then enabled.
>
> Fixes: afdfff59a0e0 (scsi: ufs: handle non spec compliant bkops behaviour by device)
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> ---
Feel free to add
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Ran these patches on exynos7 platfrom, and no regression observed,
basic read/write works, so
Tested-by: Alim Akhtar <alim.akhtar@samsung.com
>
>  drivers/scsi/ufs/ufshcd.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 3910c58..8e7c362 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5099,6 +5099,7 @@ static int ufshcd_disable_auto_bkops(struct ufs_hba *hba)
>
>         hba->auto_bkops_enabled = false;
>         trace_ufshcd_auto_bkops_state(dev_name(hba->dev), "Disabled");
> +       hba->is_urgent_bkops_lvl_checked = false;
>  out:
>         return err;
>  }
> @@ -5123,6 +5124,7 @@ static void ufshcd_force_reset_auto_bkops(struct ufs_hba *hba)
>                 hba->ee_ctrl_mask &= ~MASK_EE_URGENT_BKOPS;
>                 ufshcd_disable_auto_bkops(hba);
>         }
> +       hba->is_urgent_bkops_lvl_checked = false;
>  }
>
>  static inline int ufshcd_get_bkops_status(struct ufs_hba *hba, u32 *status)
> @@ -5169,6 +5171,7 @@ static int ufshcd_bkops_ctrl(struct ufs_hba *hba,
>                 err = ufshcd_enable_auto_bkops(hba);
>         else
>                 err = ufshcd_disable_auto_bkops(hba);
> +       hba->urgent_bkops_lvl = curr_status;
>  out:
>         return err;
>  }
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>


-- 
Regards,
Alim
