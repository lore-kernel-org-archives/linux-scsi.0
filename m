Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A581AC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 07:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4375564E79
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 07:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhBHH5w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 02:57:52 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:54324 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhBHH5w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 02:57:52 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 573232ABF5;
        Mon,  8 Feb 2021 02:57:10 -0500 (EST)
Date:   Mon, 8 Feb 2021 18:57:12 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Xiaofei Tan <tanxiaofei@huawei.com>
cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@openeuler.org
Subject: Re: [PATCH for-next 00/32] spin lock usage optimization for SCSI
 drivers
In-Reply-To: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com>
Message-ID: <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 7 Feb 2021, Xiaofei Tan wrote:

> Replace spin_lock_irqsave with spin_lock in hard IRQ of SCSI drivers. 
> There are no function changes, but may speed up if interrupt happen too 
> often.

This change doesn't necessarily work on platforms that support nested 
interrupts.

Were you able to measure any benefit from this change on some other 
platform?

Please see also,
https://lore.kernel.org/linux-scsi/89c5cb05cb844939ae684db0077f675f@h3c.com/
