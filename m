Return-Path: <SRS0=EFIP=2S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8ABBC2D0C8
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Dec 2019 05:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F2C72168B
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Dec 2019 05:54:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W9LjOA2F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfL1Fy3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Dec 2019 00:54:29 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42525 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfL1Fy2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Dec 2019 00:54:28 -0500
Received: by mail-pf1-f194.google.com with SMTP id 4so15706642pfz.9;
        Fri, 27 Dec 2019 21:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=WWR7SGf2+LO4akfQvAbba7ngIx/rb/3/oUv3fCaDixM=;
        b=W9LjOA2FOyJIjXOqaZmQe1JAD8L4ggppYN4k/s5+8rAkewUTa2YlXOZolYsMLrQv8A
         krD6H9D/JGqT1BoXZbvYxQDv6N8tOc7qt5gDy/0JT0BmvDLnpHiZs1Vv2R5jNYEWbPx8
         ybdb5yTVCj65Kq35IxYohP9U7CDeT/DmN2eh+gr2RK7G/oAwxdW9V7MzUYOyvtcU0qgu
         JolJz3Pr7pTv4GSgcVviXgMOffJocKlllUon2BL6xEjUZtb7gEsRlLUeo7IkBpkkwA5v
         DXSsd4MsJqqSqmYAh5fKGbBwMLFGuIRDgIxwvk6mJA981y8VOMiMbaZgT5/wn1uUSS2H
         PXvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=WWR7SGf2+LO4akfQvAbba7ngIx/rb/3/oUv3fCaDixM=;
        b=QFejRKmSPreZhe7Qz1ogCqY1VrURHO8EQYkp/aE52YY97l60QSXKN7kPJDxR3xByjV
         rxsTDQyDnbE3WtOk+3HqVp/XZMD1GDshHlXwhMw4+qZ8DI89XBol6P7w11yxfQ6AH8Pb
         +qlWwOpEhMCgVBrDPXih+V4KDf39fFdURwY2X24qW5LBl/o1U3HDLudrgcXtjmaI53FJ
         7WR40sDhWRmloBYe4MVGZvWBMzajU8UBplCHkpgXqteWi7VsVRH+GLf5xYosGub2GXw/
         dxlgiODWP2kaNFW+Z2gTcm4OgDPv+ddtJf32xHVmnOfVGWl6fUDub3iFpJNCwoaGR8ru
         6jug==
X-Gm-Message-State: APjAAAXYWkXOmGUtHcmNSVyNAWcgTW2U5f1K92AYTYVKPlzT2MtXvsZV
        V8kpzkatHxZxxifvJgnw6sk=
X-Google-Smtp-Source: APXvYqxS5J+kysqajIskQ2YaVc355yfr5j3suKWQajNd/pGZVpqT2sTNsqpRfvOsKm6+TmVlDfzoZw==
X-Received: by 2002:a65:4d46:: with SMTP id j6mr60042098pgt.63.1577512467995;
        Fri, 27 Dec 2019 21:54:27 -0800 (PST)
Received: from nishad ([106.51.232.103])
        by smtp.gmail.com with ESMTPSA id e25sm39144415pge.64.2019.12.27.21.54.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 27 Dec 2019 21:54:27 -0800 (PST)
Date:   Sat, 28 Dec 2019 11:24:20 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     Hannes Reinecke <hare@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] scsi: Use the correct style for SPDX License Identifier
Message-ID: <cover.1577511720.git.nishadkamdar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch corrects the SPDX License Identifier style
in the scsi driver related files.

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46

Nishad Kamdar (2):
  scsi: mylex: Use the correct style for SPDX License Identifier
  scsi: ufs: sysfs: Use the correct style for SPDX License Identifier

 drivers/scsi/myrb.h          | 4 ++--
 drivers/scsi/myrs.h          | 4 ++--
 drivers/scsi/ufs/ufs-sysfs.h | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.17.1

