Return-Path: <SRS0=5MTk=YA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BD9ECE58C
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 19:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 664EF206C2
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 19:10:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ucr.edu header.i=@ucr.edu header.b="GtANARkG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbfJGTKd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Oct 2019 15:10:33 -0400
Received: from mx5.ucr.edu ([138.23.62.67]:12675 "EHLO mx5.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728079AbfJGTKc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Oct 2019 15:10:32 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Oct 2019 15:10:32 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1570475432; x=1602011432;
  h=mime-version:from:date:message-id:subject:to;
  bh=qKkd59j86O9FUZiM0WpoYxgW00QFfLIb89TLtsimzfI=;
  b=GtANARkGeL4nlVSKwNs7TlcjSuQJaJQqWRNY+p9xEnWdf+8jJZ81OP1H
   EcBH9anzGQG+oE4AxPhEGqoHMX61HGq9xPOdt2gBSdctLsitfzWl/kqlE
   sRWllIgpGK02iv4tDtdXMhCzHVBJj6mgL176sqUcQSGst8K+3Gpt6K84M
   RVwww68Xm8cAiHGcBg9usdhr7N2FC6s5PkAwjrR6BiCF3R1KH1kOlC8Sp
   qiZl9Xh33csoR5tYJJHC6pyM14iqq2ROcl9j93EF1pXWrk3PZgl9NcdMY
   Ia9Gou9GHtyGJTVmW2C4EEaitJ8j6lGHQdAAhzhZlQR8WxnuPeww6negb
   g==;
IronPort-SDR: rm7OcD8FIN1FH2eCIB0RqzMSO8dQT1bPsxWbE/u6P0ihaQ97aondxKCgR2iZpznIb05tN44kwz
 nra+Nc+4mqYK08oE8ZC5amlnSw5cid/QyA8yxm3cxIfTvsEe5LHadfp/C4LmftF1kcpkC8Ealm
 Jjv8EfnI7OY9dXYLdY490Fmke5lT7uMn4/V72oklZ084FLg6FNLhhP2mjflBLwDyoocvtyHlmy
 JnyJHxfZCQzu4r2BKbwdgQMayp5C9l9DO0lJ8LZ0l3TIMjWAFGC/I2yM3vHPZD3kHcEn758RBY
 Oe4=
IronPort-PHdr: =?us-ascii?q?9a23=3AwtREphPJj9Ntm5hNlNgl6mtUPXoX/o7sNwtQ0K?=
 =?us-ascii?q?IMzox0K/37r8bcNUDSrc9gkEXOFd2Cra4d0KyL7Ou5AD1IyK3CmUhKSIZLWR?=
 =?us-ascii?q?4BhJdetC0bK+nBN3fGKuX3ZTcxBsVIWQwt1Xi6NU9IBJS2PAWK8TW94jEIBx?=
 =?us-ascii?q?rwKxd+KPjrFY7OlcS30P2594HObwlSizexfL1/IA+2oAjTucUanJZuJ6IswR?=
 =?us-ascii?q?bVv3VEfPhby3l1LlyJhRb84cmw/J9n8ytOvv8q6tBNX6bncakmVLJUFDspPX?=
 =?us-ascii?q?w7683trhnDUBCA5mAAXWUMkxpHGBbK4RfnVZrsqCT6t+592C6HPc3qSL0/RD?=
 =?us-ascii?q?qv47t3RBLulSwKLCAy/n3JhcNsjaJbuBOhqAJ5w47Ie4GeKf5ycrrAcd8GWW?=
 =?us-ascii?q?ZNW8BcXDFDDIyhdYsCF+UOM+ZWoYf+ulUAswexCBKwBO/z0DJEmmP60bE43u?=
 =?us-ascii?q?knDArI3BYgH9ULsHnMrtr1NaYTUeCozKnP0D7MbPNW1i386IPVdR0gofCNXb?=
 =?us-ascii?q?JqfsrQ1UUjCw3Ig06NqYP5JTOZzPoCvHWG7+d5U++klm0pqxlprzSx2sshjp?=
 =?us-ascii?q?PFi4EVx1ze6Cl0wYQ4Kce6RUJmZ9OvDYFeuDuAN4RsR8MvW2RouCEnxbIYoZ?=
 =?us-ascii?q?O7Zy0KyIg/xx7YdvyHb5CE4hL9W+aVJjd1nHdld6i+hxa26ESgzuP8WtSt3F?=
 =?us-ascii?q?ZErCdJj8PAtn8K1xzU5ciHTuVy8l291jaI0gDf8uBEIUYqmqrHM5Mt3KI8m5?=
 =?us-ascii?q?4JvUnAHiL6glj6ga6Ue0k++OWk9vzrYrD8qZ+dM490hBv+MqMrmsGnAeU5Mw?=
 =?us-ascii?q?gOUHKa+eigyLHu81b0QKhWgf0siKXWro3VJdkDqq6jHwBVypoj6wq4Dzq+1N?=
 =?us-ascii?q?QYnH8HLE9KeR6elIjmJ0rOIPHjAPehjFSjji1ry+rFPrL/GJXNKGbMkLP7cb?=
 =?us-ascii?q?Z68U5cx1l78dcK4ptOFrAHZur+RkLrr9HeJhgjOgewzqDsD9A5nqAXRW/HOb?=
 =?us-ascii?q?OUL6rIrRfc5fkzLvaFfpM9vDf7Nugr4OPogXYlmFgbO66z0s1TIEy4GfFvOA?=
 =?us-ascii?q?22ZXftktEMCy9eogU6XMTuiVufTSRUYXeiGa4xsHVzIYaiDJzEQMiXibqN1S?=
 =?us-ascii?q?PzSpRSYmFdDVakFXDoapmDWLEKZT7EZod/myYZU5CqS4IlzhCp8gT9zv4vA+?=
 =?us-ascii?q?zO+yYf/a3u1dd44/GbwRA0+ztcCsmBznHLSWxoyCdATSE/2qlkukd9x3+K2q?=
 =?us-ascii?q?0+hOZXUZRX5vVUQkIhPoXd5/J1Bsq0WQ/beNqNDlG8TZHuHTgrQd8thtMDfU?=
 =?us-ascii?q?t5M8utgwqF3CewBbIR0buRC9h89qPawmi0JMtnzXvC/LcugkNgQcZVM2CiwK?=
 =?us-ascii?q?ll+EybNY7Iglif35+rfKJUiDzN9Xaey3Omt1oeTQVqF6jJQCZbLmDWoNL291?=
 =?us-ascii?q?6KdLioBvxzORBGz8GqIbAMd9bzy1hKWaGwFs7ZZjeAmnWwGBHA9LOFbcK+an?=
 =?us-ascii?q?cd1SSFUBMsjgsJu3uKKF5tVW+av2vCAWk2RhrUaET2/Lw78SvjQw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2HFAgCgi5tdhkenVdFmDoIQhBCETY5?=
 =?us-ascii?q?hgw2CCgGGd4VZgRiKNAEIAQEBDi8BAYcfIzcGDgIDCQEBBQEBAQEBBQQBAQI?=
 =?us-ascii?q?QAQEBCAsLCCmFQII6KQGDVRF8DwImAiQSAQUBIgE0gwCCCwWiZIEDPIsmgTK?=
 =?us-ascii?q?ECwGEWQEJDYFIEnoojA6CF4ERgl0HiD2CWASBOAEBAZUsllQBBgKCEBSMVIh?=
 =?us-ascii?q?EG4IqAZcUjiyZSw8jgUWBfDMaJX8GZ4FPTxAUgWmNcQRXJJIcAQE?=
X-IPAS-Result: =?us-ascii?q?A2HFAgCgi5tdhkenVdFmDoIQhBCETY5hgw2CCgGGd4VZg?=
 =?us-ascii?q?RiKNAEIAQEBDi8BAYcfIzcGDgIDCQEBBQEBAQEBBQQBAQIQAQEBCAsLCCmFQ?=
 =?us-ascii?q?II6KQGDVRF8DwImAiQSAQUBIgE0gwCCCwWiZIEDPIsmgTKECwGEWQEJDYFIE?=
 =?us-ascii?q?noojA6CF4ERgl0HiD2CWASBOAEBAZUsllQBBgKCEBSMVIhEG4IqAZcUjiyZS?=
 =?us-ascii?q?w8jgUWBfDMaJX8GZ4FPTxAUgWmNcQRXJJIcAQE?=
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="81190840"
Received: from mail-lf1-f71.google.com ([209.85.167.71])
  by smtpmx5.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Oct 2019 12:03:08 -0700
Received: by mail-lf1-f71.google.com with SMTP id g24so1669788lfh.4
        for <linux-scsi@vger.kernel.org>; Mon, 07 Oct 2019 12:03:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ESofDjYlaGWbuPOVSuea9qOggnj5mZzg5iY6K5NGehg=;
        b=UXLN+4cuZJ8tj6nT7qUrYBcU4HZVjcX4LAyGn0lcK1qb2n3uOEw7n3i079K9iuV9Ll
         NKI3y/fZf9V+k55VxnUp7YSawDAuGsUi8d2f1nWhZwLWyRDim6y02t/tEFegQF6NZ6wE
         sVP09n4WtEv9H4+4+QkEgQqnlhVzs6KAS3feZi1VVnDxxze3iR25Lb/geBMULm8xfZUL
         2XsEiaOwQk9zaTZhBGJHLx4mhf+WqnmbaJ7/8lOaelz+g8F092w1lqpInXencl008geq
         ley20YeAGxpd6oZ3oCHBIL5w9icmDBBq68E+o0P8XeZe+y+R93JkeWxd12bAGV4RiNwF
         Kkog==
X-Gm-Message-State: APjAAAUzO1vIRwJ8DBcCBG1pqoNau4YB/X62FqoIRg1+o8jRHKSvRrqV
        83vl+kqWOph0f9IrrjBg8meLkW2+hRj/GqfoJ+7LGblVJ5gGVu0SwCEbM3IuZzcMTOCbCvaWPkm
        NmCpiqFJZJmn4GGKMiG2jWrzCTlSz5mKDDEBoDe4=
X-Received: by 2002:a2e:89cd:: with SMTP id c13mr19382934ljk.92.1570474987341;
        Mon, 07 Oct 2019 12:03:07 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxPt2y/kkUfF2dViia+Gw42gIv9azn/ATOBEVLWWAlSLPnIIR6FYLzrKHUfg/QEdwY0P6m32CFv87gaTDTQITI=
X-Received: by 2002:a2e:89cd:: with SMTP id c13mr19382924ljk.92.1570474987121;
 Mon, 07 Oct 2019 12:03:07 -0700 (PDT)
MIME-Version: 1.0
From:   Yizhuo Zhai <yzhai003@ucr.edu>
Date:   Mon, 7 Oct 2019 12:03:50 -0700
Message-ID: <CABvMjLQxcV5UE3_j84SV3u2LxJKVoQ2G+5CZCuKtAd6A_6FDNw@mail.gmail.com>
Subject: Potential NULL pointer deference in cxgbit
To:     martin.petersen@oracle.com,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>, varun@chelsio.com,
        Enrico Weigelt <info@metux.net>, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhiyun Qian <zhiyunq@cs.ucr.edu>,
        Chengyu Song <csong@cs.ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi All:

drivers/target/iscsi/cxgbit/cxgbit_ddp.c:

Inside function cxgbit_ddp_sgl_check(), sg_next() could return NULL,
however, the return value of sg_next() is not checked and get
dereferenced. This could potentially be unsafe.

-- 
Kind Regards,

Yizhuo Zhai

Computer Science, Graduate Student
University of California, Riverside
