Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB92C388F7
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 14:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C31B2224B
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 14:19:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R99yggxx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407960AbgJTOTd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 10:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407945AbgJTOTd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Oct 2020 10:19:33 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1747C061755;
        Tue, 20 Oct 2020 07:19:32 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id a3so2957993ejy.11;
        Tue, 20 Oct 2020 07:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:message-id:subject:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VkBORFPNXe+Ux1rw19W4FVF2VgTXnsWZfD7tOHA0CGc=;
        b=R99yggxxgvtF5j4HMPiZ6N+cwMn+3K2IAh2z4OY1Zo6OQ/eh4nNMIyJ268+ABXqlPD
         6FLfTXOSaf4hufSxUTlg3yrgS8oYriergiwf8z0XuQ50Y6GRYomYNa+Zy01quUUPFpd/
         ClHk3LPIcopFE77ZsJB7vvR+iWjngTjgskYigrIPTE6sDUQyrDhjsO3ZkRX+z7dmyt5I
         ZMzAR8rkoy/sTu3eRqeIIAiMOYt9Mm0Oz7BwJFl4tcnvT4KP3A9cM8TqGiuiD9YaR9gn
         tTFgiD376hPaLoWxAKrez/M17F6f6h+qnQVSmuhOXsLImkh4xjJgQEd9DlErR967CNht
         T8PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:subject:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VkBORFPNXe+Ux1rw19W4FVF2VgTXnsWZfD7tOHA0CGc=;
        b=PMweg9PWR/odC8lsN7hfTKqmWbq/XWH+hdnuaxk476K7W2DeRWCGJxGChdyEXo9Lnc
         +Kp6HIc5UQpk/Ak3OA3YXBlBG5e6IIa8QUb5iqL4HWS0PTvQt8kX7nMF2QjGMnkJ8IqT
         +2dBFecOTIh1sasjIS6X8d600+/dkG5WRnlTYlNKA0ZEfxNB/vwE0h2H7xDrIh/o1ta/
         RIiUhPu1DL5eEydQLjks0QDBX3nqhT5s/SeLo5atYt7N9La5x2zqGu6j2aMY8IdANWSg
         M8cJrH73yETp2UFar6BvGTr2eZTA1TNSqy3CFDGc0Rggm2ClU8z0uBsEBE9ZT1UZ43Cz
         1qpw==
X-Gm-Message-State: AOAM533TALd/rp9w6wQGcnetvEpCkTMBbd+xJJkthWwUX2MD7s26HKng
        +MUXrp8p8bcGaPUMDLmfktU=
X-Google-Smtp-Source: ABdhPJyz58DFJZDWH7kXJJ8v/MmRBRCNYgKlviCUNByxhXTO8uqQgkuk3E7POiqrX6ymzjRz9wu70g==
X-Received: by 2002:a17:906:557:: with SMTP id k23mr3276237eja.425.1603203571743;
        Tue, 20 Oct 2020 07:19:31 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:b900:df40:185:7e9a:74c:2d13])
        by smtp.googlemail.com with ESMTPSA id i5sm2772979ejs.121.2020.10.20.07.19.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 20 Oct 2020 07:19:30 -0700 (PDT)
From:   Bean Huo <beanhuo.cn@gmail.com>
X-Google-Original-From: Bean Huo <Beanhuo.cn@gmail.com>
Message-ID: <e2976fe3f85c2625e42dbddbf61faed651caa5c0.camel@gmail.com>
Subject: Re: [PATCH v1 1/2] scsi: ufs: Serialize eh_work with system PM
 events and async scan
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
Date:   Tue, 20 Oct 2020 16:19:18 +0200
In-Reply-To: <1600752747-31881-2-git-send-email-cang@codeaurora.org>
References: <1600752747-31881-1-git-send-email-cang@codeaurora.org>
         <1600752747-31881-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On Mon, 2020-09-21 at 22:32 -0700, Can Guo wrote:
> Serialize eh_work with system PM events and async scan to make sure
> eh_work
> does not run in parallel with them.
> 
> Change-Id: I33012c68e2ea443950313c59a4a46ad88cf3c82d
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 64 +++++++++++++++++++++++++++++------
> ------------
>  drivers/scsi/ufs/ufshcd.h |  1 +
>  2 files changed, 41 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 1d8134e..7e764e8 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5597,7 +5597,9 @@ static inline void
> ufshcd_schedule_eh_work(struct ufs_hba *hba)
>  static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>  {
>  	pm_runtime_get_sync(hba->dev);
> -	if (pm_runtime_suspended(hba->dev)) {
> +	if (pm_runtime_status_suspended(hba->dev) || hba-
> >is_sys_suspended) {

Hi Can

I curiously want to know how this can be produced in real system.

IMO, The system has been in system PM suspeded mode, how can trigger
error handler? because the tasks have been freezed, the device
interrupts disabled, before entering system PM suspended mode, the
tasks in the queue should be completed, otherwises, there is bug in the
whole flow.


thanks,
Bean

