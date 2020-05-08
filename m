Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B36FC38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 14:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77D052173E
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 14:45:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XGvWQE9v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgEHOpB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 10:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbgEHOpA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 10:45:00 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E87C061A0C;
        Fri,  8 May 2020 07:45:00 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id y24so10930573wma.4;
        Fri, 08 May 2020 07:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s/MYZPlVUlnns2iya4LFQ4TyS82AWS2Uxnpk3t09sYA=;
        b=XGvWQE9vdi094WQCIZix9amQXx9sbULFi+inl9n2v/5QeS8IrV64WF5s+Ma+RRTp6f
         Bia5lRq3lnQIiRlY5artBL4CfIaErNpjrAhxq8Tl0zK4pKzAZ+jwpGUE8Iktoq4AhqM6
         i/M1WS2ce+A98wdyEznAwrB7wXh9Uq8z0K3/jLM5pUky60bdvJ3ZuXpCUe4WbGofsHCl
         mPCtIU3P3uLtlE++L6LkJPAsvEnspZALLZdKFQqBrBxDjrbY2ZyP7cye7vl34DOf0H3u
         AeuWKU2WyK605Qamy8n/pknjJPCCpMHouFIvil1PFhcFsh6QNG4Nwys6V3RYf99SE+sD
         kacw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s/MYZPlVUlnns2iya4LFQ4TyS82AWS2Uxnpk3t09sYA=;
        b=YreENlGgSt69r+WHV2S8gb1qEVuZEU86SLcD65d/Q1H9g4JcWeGisqr4p9oUAMvX40
         +eIP7viJZfpL6SjYUwRa0V2L6PPODs7MDIbJHy/4WJ4esENi2NdGvxx5RYeqYpBgJLvZ
         w5LSrm7dXOG3cSetmDJR00fwotBcv0ei2gVRb4kLCHvFBOra/VelQEcJ2WbB3rFJgX8b
         ZCZGvzKq4nNIaLPgg4ZIvppmvD9DwCXg32UhOHrChAlPRwIUT/V/6y6bO34Zwp/Yio/1
         zJYKJyORcxdCtYEQyxu4owRTxLfhdNqxzGnnnfL3JNolRJLdJZbY72q8dhnZXgKknjq/
         Iw/g==
X-Gm-Message-State: AGi0PuYuSjRiKtHLYbFsr8Ip5hubTsLNnoR8HiI+2nyZs138uyl66/Cp
        n3ynAw1Qyh6ceuJ0z2edBeM=
X-Google-Smtp-Source: APiQypJT0D+r37v+q2xNWxpq6zD8tCQligqHPEKvlLGJkVkp8JUs6F8UVBtD2TzPaS0F51K/F6N32g==
X-Received: by 2002:a1c:4b15:: with SMTP id y21mr16603953wma.150.1588949099163;
        Fri, 08 May 2020 07:44:59 -0700 (PDT)
Received: from ubuntu-G3 (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.googlemail.com with ESMTPSA id d15sm3107347wrs.38.2020.05.08.07.44.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 May 2020 07:44:58 -0700 (PDT)
Message-ID: <1edda80d569a53e0af28fbe30a367d84f099f8fe.camel@gmail.com>
Subject: Re: [RESENT PATCH RFC v3 5/5] scsi: ufs: UFS Host Performance
 Booster(HPB) driver
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org,
        rdunlap@infradead.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
Date:   Fri, 08 May 2020 16:44:57 +0200
In-Reply-To: <7b3e127f-a25f-e821-6704-2680ea619c6d@acm.org>
References: <20200504142032.16619-1-beanhuo@micron.com>
         <20200504142032.16619-6-beanhuo@micron.com>
         <7b3e127f-a25f-e821-6704-2680ea619c6d@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-05-07 at 20:21 -0700, Bart Van Assche wrote:
> On 2020-05-04 07:20, huobean@gmail.com wrote:
> > +config SCSI_UFSHPB
> > +	bool "UFS Host Performance Booster (EXPERIMENTAL)"
> > +	depends on SCSI_UFSHCD
> > +	[ ... ]
> > +
> > +config UFSHPB_MAX_MEM_SIZE
> > +	int "UFS HPB maximum memory size per controller (in MiB)"
> > +	depends on SCSI_UFSHPB
> > +	default 128
> > +	range 0 65536
> > +	[ ... ]
> 
> Kernel module parameters are an inflexible mechanism because the
> value
> of these parameters cannot be changed without rebuilding the kernel
> followed by a reboot. Has it been considered to make these two
> parameters configurable through sysfs? Has it been considered to make
> these parameters UFS device parameters instead of global parameters
> that
> apply to all UFS devices?
> 
> 
Hi Bart
I ever tried these two approaches. let me explain why I finally choose
kernel module "make menuconfig" way.

1: driver module parameter, while system booting, specify maximum HPB
cache size in kernel boot Parameters:

   	static int max_hpb_mem = 128;
   	module_param(max_hpb_mem,int,0444);

but this paramter is added in the ufshcd.c since the ufshpb.c is not a 
independent module. looks not very natural.


2: sysfs parameters

This is a feasible option. we can enable HPB after system boot up,
also, change the HPB cache maximum size.
this is the same with the current way, moreover, we don't want user to
change HPB cache size while HPB is running.


If you prefer to convert current HPB driver to be a kernel module
driver, I prefer first apporach.


thanks,

Bean






