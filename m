Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E0D2C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jan 2021 16:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2528C229C6
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jan 2021 16:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbhAJQSw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jan 2021 11:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbhAJQSw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jan 2021 11:18:52 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F01C061786;
        Sun, 10 Jan 2021 08:18:11 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id g20so21369016ejb.1;
        Sun, 10 Jan 2021 08:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O6wD1nNt0PNVbfvKXZ84PNRKQg+59KWjjSHlKIR8nqc=;
        b=XCdtIZkpWsVx3yECy1NV9GsqgwYPM6RD4jgmwLA3ig1Kkz2ycf/6DMJ4IA8g7Bab+E
         ehmKpCyZVk+BkU9GvKyccOoiHmpFmOeU5N53h328hGGmdvW9qJp7EDdbh87FfLKcgADT
         8yCeDn089v5rDEktNu8nh/GkzXe1oLUlSd86s5WRt/yGlWPgbDcGKZHVQSyoYB5KZ+p/
         f3fjQOp73Fz7u3ohi7Ql3IF5RMfdtYJbEJJyOu+hhbMIjhyHEUEDZopuRkKDUOnFYoru
         EHZvLWdZgbugdaYIWLTpRQ8613td36TY/65lj/cdI3A4NE7siGDQqo2QvaOxTx818Ohr
         naZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O6wD1nNt0PNVbfvKXZ84PNRKQg+59KWjjSHlKIR8nqc=;
        b=IMLtu1Cpd5H/oqOvI1uRsWHmzQhoVA/y78ShwBZxHANxIASbnMNd71sJjUUO80I4Qy
         m0aE9Trn8ar4OybDgfIqzj6Y6mIbwpxWVQmsJ0rLU/aCgWZ0pRHZO+pCrJmxWNMPaCYs
         chW3L4J4h3puuLDdqz+F4fTP7HtFyCZKumrJmNBP9klYKxEMBiNOGHgvGMDv+s8YCyNg
         R/NR9Pjol723cKGnKmM5wUW8Ojti6wnVS/ippc8bNotbaNn9u36p24xNWNUUNuYpFSmd
         k1ZNRuV2UWhNtrV6tlpPEQhFPNe3xWSIyvqQ7rj0MrETc/5svgvtgHWzxbDJxPyLGXO1
         5SYg==
X-Gm-Message-State: AOAM530eqbLH9MLyb2y+M+lih3gBzcdsNB0bZRBLlup0kRu1c0PZ4+EM
        yfbJ/MlXvi8dnXevI3i6/gM=
X-Google-Smtp-Source: ABdhPJzjCML38NF0c3b41Rc5jd6o3tuorl1j/1IuvsGGCTrzHDwGZ5KSnE47mrdKAAOHj89eGoL/cg==
X-Received: by 2002:a17:906:26d7:: with SMTP id u23mr8155623ejc.210.1610295490235;
        Sun, 10 Jan 2021 08:18:10 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.googlemail.com with ESMTPSA id ot18sm5851290ejb.54.2021.01.10.08.18.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 10 Jan 2021 08:18:09 -0800 (PST)
Message-ID: <0ad818b10110c4c383afbc2c39235a4f7f17f4c7.camel@gmail.com>
Subject: Re: [PATCH 2/2] scsi: ufs: Protect PM ops and err_handler from user
 access through sysfs
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Sun, 10 Jan 2021 17:18:05 +0100
In-Reply-To: <1609595975-12219-3-git-send-email-cang@codeaurora.org>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
         <1609595975-12219-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2021-01-02 at 05:59 -0800, Can Guo wrote:
> + * @shutting_down: flag to check if shutdown has been invoked
> + * @host_sem: semaphore used to serialize concurrent contexts
>   * @eh_wq: Workqueue that eh_work works on
>   * @eh_work: Worker to handle UFS errors that require s/w attention
>   * @eeh_work: Worker to handle exception events
> @@ -751,7 +753,8 @@ struct ufs_hba {
>         u32 intr_mask;
>         u16 ee_ctrl_mask;
>         bool is_powered;
> -       struct semaphore eh_sem;
> +       bool shutting_down;
> +       struct semaphore host_sem;
>  
>         /* Work Queues */
>         struct workqueue_struct *eh_wq;
> @@ -875,6 +878,11 @@ static inline bool ufshcd_is_wb_allowed(struct
> ufs_hba *hba)
>         return hba->caps & UFSHCD_CAP_WB_EN;
>  }
>  
> +static inline bool ufshcd_is_sysfs_allowed(struct ufs_hba *hba)
> +{
> +       return !hba->shutting_down;
> +}
> +


Can,

Instead adding new shutting_down flag, can we use availible variable
system_state?

Thanks,
Bean

