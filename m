Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7CDCDB474
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 13:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343926AbjJQNyu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 09:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343894AbjJQNyu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 09:54:50 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63984ED
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 06:54:48 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-32d895584f1so4864984f8f.1
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 06:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697550887; x=1698155687; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NXoGddXmEFzuK/enWH5UzA4ExBiuDwed1JkLCf0KQbA=;
        b=Lm1R1ORgF1TCOH7lILP3EbhXKbtjns/YzWje7LSvVz90C1LlBQ5KeroJ3m4Ui/nQ48
         yp4HG9SWC/0HcLWwsB5dgjtxzdW32rFol/rlwNbZhWOiQnxLX6/3kBWfYybWuCbngMfh
         eWKuwdtXsq9GfXafZp2MVSYIlk7oDXy7fIeX3cueerZ5LJ9o0vS29oCr9onsCS0QgiRh
         7ZEqgSnv8XkE/aqBONb6VfpCKuxgKpIecV+zGIJm6MV+8Imtfv/XxNc9Oj5ISzWb56XH
         xgtx7VHf0I0YJmWkBdpIn4k9nb+ZfQzPH+kkzLwpS7wqACW3og4PCAvYVl8hCqH5uobG
         oSWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697550887; x=1698155687;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NXoGddXmEFzuK/enWH5UzA4ExBiuDwed1JkLCf0KQbA=;
        b=SS+S2Vzc59wr1FzT0PFv9AUM+Nx89ZeOzUA5Fxvu+hiBD6m9z5i59g3yicoJ+8qxfC
         hboPOdBzZHFfweYb960H+WO5yzNoN71B3qJZcqw6XWJj3z7ak5FXwKorusn2dRdI1u4J
         El99JPo6jI+wQIFxu8NHlpx+S+fRIucLwcRrsgrm4kc5wkQgBmlZl8z8SViYGFz/EBbi
         rViKfNKZfIDXv5OJBGcKR2sW29YYsOR2AHOmkgdWDXrFNdaq8hUy2TtuvB0rMRbaANNg
         uYKZLWVmelNFephjQvkwEoMKMaVgMN8kZfxa4ivJrk53QoEkXXvE2AExFWf/Amd4FWym
         bjhA==
X-Gm-Message-State: AOJu0YzRSXd3dE6m5zfRGKTa8pCrb/eJaZQlPai8UBriyHA2O5UBS19S
        X95ZmRlnUsH0FKpV1APjmBiOVqYHx9cG8MHbp1c=
X-Google-Smtp-Source: AGHT+IELMMdfLkWkDiMfwhr5F40DIHUTH3HAZDJte0/N61XDAS8ktpnczaG0FhJ6cwKnP32L/dRJdA==
X-Received: by 2002:adf:e3cf:0:b0:319:71be:9248 with SMTP id k15-20020adfe3cf000000b0031971be9248mr2280628wrm.19.1697550886904;
        Tue, 17 Oct 2023 06:54:46 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id k2-20020a5d4282000000b0032daf848f68sm1731969wrq.59.2023.10.17.06.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 06:54:46 -0700 (PDT)
Date:   Tue, 17 Oct 2023 16:54:42 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     peter.wang@mediatek.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: ufs: core: Only suspend clock scaling if scaling
 down
Message-ID: <e29271ad-5339-407f-ae33-99f3c3d1047e@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Peter Wang,

The patch 1d969731b87f: "scsi: ufs: core: Only suspend clock scaling
if scaling down" from Aug 31, 2023 (linux-next), leads to the
following Smatch static checker warning:

	drivers/ufs/core/ufshcd.c:1440 ufshcd_devfreq_target()
	error: uninitialized symbol 'scale_up'.

drivers/ufs/core/ufshcd.c
    1382 static int ufshcd_devfreq_target(struct device *dev,
    1383                                 unsigned long *freq, u32 flags)
    1384 {
    1385         int ret = 0;
    1386         struct ufs_hba *hba = dev_get_drvdata(dev);
    1387         ktime_t start;
    1388         bool scale_up, sched_clk_scaling_suspend_work = false;
    1389         struct list_head *clk_list = &hba->clk_list_head;
    1390         struct ufs_clk_info *clki;
    1391         unsigned long irq_flags;
    1392 
    1393         if (!ufshcd_is_clkscaling_supported(hba))
    1394                 return -EINVAL;
    1395 
    1396         clki = list_first_entry(&hba->clk_list_head, struct ufs_clk_info, list);
    1397         /* Override with the closest supported frequency */
    1398         *freq = (unsigned long) clk_round_rate(clki->clk, *freq);
    1399         spin_lock_irqsave(hba->host->host_lock, irq_flags);
    1400         if (ufshcd_eh_in_progress(hba)) {
    1401                 spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
    1402                 return 0;
    1403         }
    1404 
    1405         /* Skip scaling clock when clock scaling is suspended */
    1406         if (hba->clk_scaling.is_suspended) {
    1407                 spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
    1408                 dev_warn(hba->dev, "clock scaling is suspended, skip");
    1409                 return 0;
    1410         }
    1411 
    1412         if (!hba->clk_scaling.active_reqs)
    1413                 sched_clk_scaling_suspend_work = true;
    1414 
    1415         if (list_empty(clk_list)) {
    1416                 spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
    1417                 goto out;

scale_up not initialized here.

    1418         }
    1419 
    1420         /* Decide based on the rounded-off frequency and update */
    1421         scale_up = *freq == clki->max_freq;
    1422         if (!scale_up)
    1423                 *freq = clki->min_freq;
    1424         /* Update the frequency */
    1425         if (!ufshcd_is_devfreq_scaling_required(hba, scale_up)) {
    1426                 spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
    1427                 ret = 0;
    1428                 goto out; /* no state change required */
    1429         }
    1430         spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
    1431 
    1432         start = ktime_get();
    1433         ret = ufshcd_devfreq_scale(hba, scale_up);
    1434 
    1435         trace_ufshcd_profile_clk_scaling(dev_name(hba->dev),
    1436                 (scale_up ? "up" : "down"),
    1437                 ktime_to_us(ktime_sub(ktime_get(), start)), ret);
    1438 
    1439 out:
--> 1440         if (sched_clk_scaling_suspend_work && !scale_up)
    1441                 queue_work(hba->clk_scaling.workq,
    1442                            &hba->clk_scaling.suspend_work);
    1443 
    1444         return ret;
    1445 }

regards,
dan carpenter
