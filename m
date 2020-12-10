Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8930DC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 17:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3034F23DE3
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 17:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392022AbgLJRfs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 12:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392789AbgLJRfc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 12:35:32 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159DFC0613CF;
        Thu, 10 Dec 2020 09:34:52 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id c7so6402793edv.6;
        Thu, 10 Dec 2020 09:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FEqXylzJnhyP5wm7scZDvKf6/krakNPXkfWkNPRzS5k=;
        b=RZ6uskt9xr3e73phy2hVIm7xogs/sSJRj9aVgfwfKPhUQiuCuQxKV+lrv4qyAADMgN
         e4KLOrS3fuIIbeKqYGrWJCpNoVVU/M5AkqA5Y3A6XbRcaP4cuHr9m7T2BVULH/Rw4KnP
         9KADwlRA0XcyPhIbn54RJ1kN6vaq4n2111LKBqJPiKZI289JbjEWv7Dyq4y922uQqY8D
         EDJO//nfZPUg7XFoAdGEXuNCq024czb7PBKhN9N1GowqxgE+4TG0KnExr240VdAl6noy
         cnUCp+yOG6km+gLW3KWTFgSpBvvAJuaTRlrfmudTxaq0bt49kgNoba/08VTn4vXkXArO
         mddQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FEqXylzJnhyP5wm7scZDvKf6/krakNPXkfWkNPRzS5k=;
        b=GELAmEGPgMZyF6wWykNrIiEICc5cHKtXOirOVDq8RYkE4+av2AbjbcT8RhLF+xmCAv
         5lu5kX5NpFho5D9DPq/ANuiPNNNhb7JTY/JToOCgmedCIS1QR1f3My2TJyMMJA4WLIaG
         6nC5Ak6axfI805PhHJtTxmFgz+k5w0zEupu30Isf41HQWFWOtRZGKryC5aQP2hMghc7i
         gWIDzcLZfAeErj4EjQY1SWRFuqDQjYZxeQCMLArwBEoqVUsfEIAeVDPbo0Lts9Sf1WSZ
         TfslMmOrYMnDrfoD/TNWz4SFsNc8InvSmhXnRWa0fxmtCRpfRG9ahaCbiuuqTNmlrUlT
         sPIQ==
X-Gm-Message-State: AOAM531kkBwSpCQxKhn0/Rx0BZb0CTwFB5OHc56qtFxj+I21RvdSBL1g
        uC+2UvNrE0Rcih7KsIXKqmU=
X-Google-Smtp-Source: ABdhPJzhqxHn3kSMYX44//PlBagQ9Lhsmdn9y9AGxfdDap1WzxVwB0J8uXiRwMNX4FaZW2VB0EXJNQ==
X-Received: by 2002:a50:8741:: with SMTP id 1mr7971377edv.349.1607621690847;
        Thu, 10 Dec 2020 09:34:50 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id 2sm4883388ejw.65.2020.12.10.09.34.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Dec 2020 09:34:50 -0800 (PST)
Message-ID: <a2338ef6da3d4ed4093547ba87e13e94d8dd2a45.camel@gmail.com>
Subject: Re: [PATCH 1/2] scsi: ufs: Protect some contexts from unexpected
 clock scaling
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Thu, 10 Dec 2020 18:34:49 +0100
In-Reply-To: <1607520942-22254-2-git-send-email-cang@codeaurora.org>
References: <1607520942-22254-1-git-send-email-cang@codeaurora.org>
         <1607520942-22254-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Can

On Wed, 2020-12-09 at 05:35 -0800, Can Guo wrote:
> 
>  
> @@ -1160,6 +1166,7 @@ static void
> ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
>  {
>  	up_write(&hba->clk_scaling_lock);
>  	ufshcd_scsi_unblock_requests(hba);
> +	ufshcd_release(hba);
>  }
>  
>  /**
> @@ -1175,12 +1182,9 @@ static int ufshcd_devfreq_scale(struct ufs_hba
> *hba, bool scale_up)
>  {
>  	int ret = 0;
>  
> -	/* let's not get into low power until clock scaling is
> completed */
> -	ufshcd_hold(hba, false);
> -
>  	ret = ufshcd_clock_scaling_prepare(hba);
>  	if (ret)
> -		goto out;
> +		return ret;
>  
>  	/* scale down the gear before scaling down clocks */
>  	if (!scale_up) {
> @@ -1212,8 +1216,6 @@ static int ufshcd_devfreq_scale(struct ufs_hba
> *hba, bool scale_up)
>  
>  out_unprepare:
>  	ufshcd_clock_scaling_unprepare(hba);
> -out:
> -	ufshcd_release(hba);
>  	return ret;
>  }

I didn't understand why moving ufshcd_hold/ufshcd_release into
ufshcd_clock_scaling_prepare()/ufshcd_clock_scaling_unprepare().


>  
> @@ -1294,15 +1296,8 @@ static int ufshcd_devfreq_target(struct device
> *dev,
>  	}
>  	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
>  
> -	pm_runtime_get_noresume(hba->dev);
> -	if (!pm_runtime_active(hba->dev)) {
> -		pm_runtime_put_noidle(hba->dev);
> -		ret = -EAGAIN;
> -		goto out;
> -	}
>  	start = ktime_get();
>  	ret = ufshcd_devfreq_scale(hba, scale_up);
> -	pm_runtime_put(hba->dev);
>  

which branch are you working on?  I didn't see this part codes in the
branch 5.11/scsi-queue and 5.11/scsi-staging.

Bean


