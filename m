Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E1FC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 14:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09C6861186
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 14:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbhKJOfs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 09:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbhKJOfr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2021 09:35:47 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281E9C061764
        for <linux-scsi@vger.kernel.org>; Wed, 10 Nov 2021 06:33:00 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id ee33so11329742edb.8
        for <linux-scsi@vger.kernel.org>; Wed, 10 Nov 2021 06:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=tZGBi8SzUs+nTCkXAkbEXeB8WapfDAJ2ywqTs87TVro=;
        b=B2ApFHTFapiGbt8lmVMc4dHsKaau6gk208gcIWTU5HjTNIhGFuMY87DS3kN+RJkYyO
         5q8Br4pxxYVKNEHUFo5hZMiBZDxsA3cq2ZQLOKkw0iJlNZvHr4cfaLYUKhUaWw5PoK4Y
         nVWDOoaNhc/Al7x67Sy3GUshKu7Y67ehxIIGMXTQR7cacbELvUD3qmu8GZP5qilwpB+K
         zXNOftadYgc3/HE41IVvhbnD8OLpJZ25mYra+OzKHV7w/36UIr6HBwTw7oEUkjigUH7j
         v/X6eVQbeq+tpFSNaKKwHa3H1J91MPHJSd33Oso4BPVwi52K5V1mhUdxIXx0avfKwxWu
         dUfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=tZGBi8SzUs+nTCkXAkbEXeB8WapfDAJ2ywqTs87TVro=;
        b=Ebji/Rpx/jiMmsrK/ipAXC66jVU2S//9jA9ma92CODdhOs3cn/Wyr8tY3qbsgKH75f
         J2+U+ovqRUayHbBRXQy4CQ0Z9rt7KTgKHUKUe89CNZGUfANJdakF5waU6A7wr+HujkRb
         fke47rBHl1u6hkWvdQDvBQV/vSNSFNObw4QjdcB5D1j6PZmNM7h86MYH33TKzandOvAA
         EFNWyJPwQ4jHM2ELiS9JLbPwMLp67rit5qEm2nWoG4cwTk2ILANw+3BXTzuRctZCUl34
         jeW5XdbFNqE4oJBf4aW7KQjEv2Ag8L1FgmEsxCRD/05ee8sX5egeNkJ7gT2fC2U/ECLx
         yYCA==
X-Gm-Message-State: AOAM531L8msEj9b2lJ/IF0PWYSM8/h7rxYK58rk92b5moeEeMgxO7f9X
        KJxdFt6ff2z6oBa6diCYqraMwfrIsA==
X-Google-Smtp-Source: ABdhPJxCaladc0dHBAiiTp7Cu5nHgZxLjvojGLpWke3aEj3XMOzzDJdANWezPtd2gGNZep0gS9GlXg==
X-Received: by 2002:a05:6402:430a:: with SMTP id m10mr21570119edc.273.1636554778724;
        Wed, 10 Nov 2021 06:32:58 -0800 (PST)
Received: from localhost.localdomain ([46.53.254.6])
        by smtp.gmail.com with ESMTPSA id b11sm13634649ede.52.2021.11.10.06.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 06:32:58 -0800 (PST)
Date:   Wed, 10 Nov 2021 17:32:56 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com
Cc:     linux-scsi@vger.kernel.org
Subject: ufs: setting "hba" private pointer too late -- oops in
 ufshcd_devfreq_get_dev_status()
Message-ID: <YYvYGBuzZzAuNzxp@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I've stumbled into a race while working on an earlier kernel,
but it looks like mainline is affected as well.

        err = ufshcd_init(hba, mmio_base, irq);
		async_schedule(ufshcd_async_scan, hba);
		ufshcd_add_lus(hba);
		if (ufshcd_is_clkscaling_supported(hba)) {
			[enable devfreq]

        platform_set_drvdata(pdev, hba);

Device's private pointer is set too late, as devfreq hook get HBA
pointer from private data and uses it:

	static int ufshcd_devfreq_get_dev_status(struct device *dev, struct devfreq_dev_status *stat)
	{
	        struct ufs_hba *hba = dev_get_drvdata(dev);
		if (!ufshcd_is_clkscaling_supported(hba))
			return -EINVAL;

Unable to handle kernel NULL pointer dereference at virtual address ...0f10
pc :	ufshcd_devfreq_get_dev_status
lr :	devfreq_simple_ondemand_func
	update_devfreq
	devfreq_monitor


I reproduced it by turning async LU scan into sync, so it is easier to
trigger.
