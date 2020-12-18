Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D917C2D0E4
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 18:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25F8423B83
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 18:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgLRS6j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 13:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgLRS6j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 13:58:39 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF83C0617B0;
        Fri, 18 Dec 2020 10:57:58 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id cm17so3424734edb.4;
        Fri, 18 Dec 2020 10:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VOfVRVMXwaXp0O1enJ1Uc/kEDU32Y6Pd6RfXGnyTX4g=;
        b=GEQUloU9U6KVXvW91AE/nU8qp/mVq/ws7uB9dVDDGiEHZrbdwGSVZNHU+Z5sMm8FTs
         Otz6qNQ3cjr9tedVRZ0pIp4iYL/6HOem2AIiFNx1Z1RknncF1axW+20Yytsqj1TOitzP
         +PleIqQeQC3rTVDYgL/S2WUxsIyYtYfzxP841dPGAYPh6PNcBRi7MqwaqQ/1nLQWNnvS
         2zt1vkJeCrc+klSbsW6aR7NxHv+Iy24dLFNTD+cTVuoFA3bkvxrIv0/+vllk6f2DAlmB
         WxBob2LccXlm0wYFsqxQkV7RMgQIP+JcM9VmgQAQcgrSqxwdwWus3t5OqJZtj/nipl8p
         nskQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VOfVRVMXwaXp0O1enJ1Uc/kEDU32Y6Pd6RfXGnyTX4g=;
        b=bFhapuQHt1ADDlVE/AtVNumXreceJILjKU9JWRs5ntbczhk/IW3Tu2lDGzRvEENrHc
         QkLAnHYRRQeKIcistu/Sn3VtlxjbOPm3MWPxeLbeoYoWulskq6SmBo2K1vNXwwjxhA+9
         mj5Pv8DofOtn7KC3Qa1kkLjjEeotjJe5FeV+E//i2tDOKeglpbKKitA27PoDFtencijT
         h95Yav914MuwjG70G9k0xDEydtgGfHfiRmpOj5V9wN6dvksVSbR9ZkoB7bFTorUtDsxt
         VJzCRQex6YGBIwnWCWSjSCmqEKRiKv6PdMbHGFpi1qM8PcQkAa0gFmMWQ/cLdbhnfC/1
         BLOg==
X-Gm-Message-State: AOAM533zHczBf4EFAIqMAlu65/MFVj4MV8jTHqmLHwf7SWqcTDqabDOQ
        hpjTFKYPNqZi3BtYJxiSyJg=
X-Google-Smtp-Source: ABdhPJwL8283ctIIVrS2b6Qfps7n3aFVkr06KgaBJ/VzCZ7VgoRtsT/Dnczuzj1CCTKaAuTvtOEJbw==
X-Received: by 2002:a50:a6c2:: with SMTP id f2mr5816028edc.7.1608317877019;
        Fri, 18 Dec 2020 10:57:57 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id v18sm5738048ejw.18.2020.12.18.10.57.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 18 Dec 2020 10:57:56 -0800 (PST)
Message-ID: <2ce8e183f03855af6c16b2a555473cca3fbbfef6.camel@gmail.com>
Subject: Re: [PATCH V3] scsi: ufs-debugfs: Add error counters
From:   Bean Huo <huobean@gmail.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Date:   Fri, 18 Dec 2020 19:57:55 +0100
In-Reply-To: <17957d71-d45b-d5f6-8ef2-453402a23268@intel.com>
References: <20201218122027.27472-1-adrian.hunter@intel.com>
         <de305f4d6034950908e8e889c4af5442431e7d15.camel@gmail.com>
         <17957d71-d45b-d5f6-8ef2-453402a23268@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-12-18 at 20:34 +0200, Adrian Hunter wrote:
> It is OK to pass NULL or error codes as parent dentry to
> debugfs_create_...
> functions.
> 
> If ufs_debugfs_root is NULL (which won't happen) then the directory
> will be
> created in debugfs root i.e. /sys/kernel/debug, using the device
> name.
> 
> If ufs_debugfs_root is an error code, then debugfs_create_dir will
> return an
> error code, and following debugfs_create_file() will return an error
> code.
> 
> > 
> > > +    debugfs_create_file("stats", 0400, hba->debugfs_root, hba,
> > > &ufs_debugfs_stats_fops);
> > 
> >        if (!debugfs_create_file("stats", 0400, hba->debugfs_root,
> > hba,
> >                &ufs_debugfs_stats_fops)) {
> >                debugfs_remove(hba->debugfs_root);
> >                return -ENOMEM;
> 
> Being without debugfs files is not a problem, so there is no reason
> to
> return an error.  It is relatively rare in the kernel that code
> checks the
> return value of debugfs_create_file().  We really don't want to fail
> probing
> just because of debugfs.
> 
> However, because debugfs' only real resource is a small amount of
> memory, it
> is extremely unlikely it will fail in that sense.  Although you can
> force it
> to fail by adding the kernel command line parameter debugfs=off

Adrian
Sounds your choice is correct. thanks.

Reviewed-by: Bean Huo <beanhuo@micron.com>

 

