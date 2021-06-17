Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A13A8C48BE5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 02:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68EC4613DE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 02:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhFQCVi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 22:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbhFQCVi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 22:21:38 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D02C061574
        for <linux-scsi@vger.kernel.org>; Wed, 16 Jun 2021 19:19:30 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id u20so3590144qtx.1
        for <linux-scsi@vger.kernel.org>; Wed, 16 Jun 2021 19:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iy5C7hcf0cMzrIVqMW9NSGi5Cx6ItJvZH5bdY1dU6BU=;
        b=Hs9e1sX5EuOIGBrbgRwghIpqGlOMWpTVi0cZ+N/OwZVernL9U5zIZRt3s3p/xfjhu3
         bnuCZYmhCFlfqbtxjXgAA9lWhgZ15F9uwFJAY6LneL2HKo5LGqaYwesADieOXI8Paz5c
         6akt/8Z9+3qeOrz7coB47tVeI7f40xn4Q+E6t8KwMy58LLLbZiaflvVJQk8EWQ67PGj4
         Jtfnjeawt63gskiusPbrj0JN0hiqTgmMCOmPzgFEzzS4Gs9NqTIWKoPQmxqE9ujuAE/O
         vqwTq4Hhv2cvqnotUJ24zxGdqWbdsRGs1tYuwUwJJWm47cq0AOCuKhVnvNwU4JBgncNt
         Seiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iy5C7hcf0cMzrIVqMW9NSGi5Cx6ItJvZH5bdY1dU6BU=;
        b=jHdH2LpGii6U42i87W7MJMSA1C/cUPJXE22Adzjx3TF4WAAi0A02BG4zz42aXdvrXd
         AKcl/HZysWWSEXsIb0mug8djdwMmHBDPhU1aZq+xvCegFjlGkuPCOwBeg4TC1p8mMWZh
         Msc1032mVbZXKPz9UdxbO5HYQAqUQR2+k+/ytzMCn3wzrgxpfliEP3a+YnfzIV8omZaa
         mP377PyUjwY+Ep9C4ZyO/Yb1AhtAMVDqImRUg7cctIEbEpVvIUcz1d/LofcmIHDBKaaf
         aHChexMD8hjlTLFcuZbJYICv8wpsjS/YjjfVvkP6OTVPLxNK6PQj0Iimtz7BpocZI/hj
         TwYw==
X-Gm-Message-State: AOAM530r6cp1WDg7WD0AYCz1jKfIQKUMDI6kxUI6+L4oq5CK/yZw60gw
        Ru5yLDlgyR+sxQ0kz10c6MH1Wbdh2uA=
X-Google-Smtp-Source: ABdhPJzh6r7qLSXNYnNqiphMS5mklKq02lxthyjxfHV/KJ48G0IwoaSWP5s/PMaSnlHg22M7Cy+YAw==
X-Received: by 2002:ac8:45c2:: with SMTP id e2mr2854414qto.331.1623896368960;
        Wed, 16 Jun 2021 19:19:28 -0700 (PDT)
Received: from david-pc (c-73-82-11-57.hsd1.ga.comcast.net. [73.82.11.57])
        by smtp.gmail.com with ESMTPSA id d16sm2365875qtj.69.2021.06.16.19.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 19:19:28 -0700 (PDT)
Date:   Wed, 16 Jun 2021 22:19:26 -0400
From:   David Sebek <dasebek@gmail.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Set BLIST_TRY_VPD_PAGES for WD Black P10 external
 HDD
Message-ID: <YMqxLleq6LQP1Ecv@david-pc>
References: <YLVThaYJ0cXzy57D@david-pc>
 <yq1czt5q8wu.fsf@ca-mkp.ca.oracle.com>
 <yq17djdq8ly.fsf@ca-mkp.ca.oracle.com>
 <YLejIoBJ8YJuonVZ@david-pc>
 <yq135tpcfv1.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="aXzYa47ee+jTEFI3"
Content-Disposition: inline
In-Reply-To: <yq135tpcfv1.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--aXzYa47ee+jTEFI3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Here is the output you requested.

Thank you,
David

--aXzYa47ee+jTEFI3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bhd3.txt"

sudo sg_inq /dev/sda

standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  LU_CONG=0  version=0x06  [SPC-4]
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=1  Resp_data_format=2
  SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  [BQue=0]
  EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  [Linked=0]  [TranDis=0]  CmdQue=0
  [SPI: Clocking=0x0  QAS=0  IUS=0]
    length=96 (0x60)   Peripheral device type: disk
 Vendor identification: WD      
 Product identification: Game Drive      
 Product revision level: 5002
 Unit serial number: WXF2E20DKCFL    


sudo sg_readcap -l /dev/sda

Read Capacity results:
   Protection: prot_en=0, p_type=0, p_i_exponent=0
   Logical block provisioning: lbpme=1, lbprz=0
   Last LBA=9767475199 (0x2462fd7ff), Number of logical blocks=9767475200
   Logical block length=512 bytes
   Logical blocks per physical block exponent=3 [so physical block length=4096 bytes]
   Lowest aligned LBA=0
Hence:
   Device size: 5000947302400 bytes, 4769275.0 MiB, 5000.95 GB, 5.00 TB


sudo sg_vpd -p bl /dev/sda

Block limits VPD page (SBC):
  Write same non-zero (WSNZ): 0
  Maximum compare and write length: 0 blocks [Command not implemented]
  Optimal transfer length granularity: 8 blocks
  Maximum transfer length: 2048 blocks
  Optimal transfer length: 2048 blocks
  Maximum prefetch transfer length: 65535 blocks
  Maximum unmap LBA count: -1 [unbounded]
  Maximum unmap block descriptor count: 31
  Optimal unmap granularity: 0 blocks [not reported]
  Unmap granularity alignment valid: false
  Unmap granularity alignment: 0 [invalid]
  Maximum write same length: 0 blocks [not reported]
  Maximum atomic transfer length: 0 blocks [not reported]
  Atomic alignment: 0 [unaligned atomic writes permitted]
  Atomic transfer length granularity: 0 [no granularity requirement
  Maximum atomic transfer length with atomic boundary: 0 blocks [not reported]
  Maximum atomic boundary size: 0 blocks [can only write atomic 1 block]


sudo sg_vpd -p lbpv /dev/sda

Logical block provisioning VPD page (SBC):
  Unmap command supported (LBPU): 1
  Write same (16) with unmap bit supported (LBPWS): 0
  Write same (10) with unmap bit supported (LBPWS10): 0
  Logical block provisioning read zeros (LBPRZ): 0
  Anchored LBAs supported (ANC_SUP): 1
  Threshold exponent: 0 [threshold sets not supported]
  Descriptor present (DP): 0
  Minimum percentage: 0 [not reported]
  Provisioning type: 1 (resource provisioned)
  Threshold percentage: 0 [percentages not supported]

--aXzYa47ee+jTEFI3--
