Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BB14C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jun 2022 18:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238137AbiFBSUQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jun 2022 14:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238218AbiFBSUD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2022 14:20:03 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF4D66AF7
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 11:19:31 -0700 (PDT)
Date:   Thu, 2 Jun 2022 20:19:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654193969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1XuDDRg2dH+R5Xxazle86pFNfiu1pe7OcD0NLwonodw=;
        b=ZhYsvABSPhM7yT1FRMIxxXYPMKiHf2uYpP2xaKiv2t3GKbbxrelqLsW9WanDARayUlC5u6
        yN36BT1haKvTGZ5vJ3H4gWHPPZq+sBZbUM8R6b46fHDExHHWTqTfH6BMWIJGHta7drHa/I
        73YtDPiBi/ICh0YTdURxNrQm+ROGJCh0p50hjgsdYbcnMySBg/oGden6bo1uCkEG6Vn5sd
        QSxca4g84kbr2Tb8vdg/ZJFPqWfpW/xre5wKxBfYqzjEnGin4Ki0dB8UHW7/EKslA+VM57
        nQ7/wvob4o1UkOp8zNEYaY19H5/emGHbZano06S3qHXC5L+XWYVuG0Yrld4Csg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654193969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1XuDDRg2dH+R5Xxazle86pFNfiu1pe7OcD0NLwonodw=;
        b=YAQE+yEfPfX+almCfwUulmh3iTSJSQP8UwcL6B6l7FluRpl3qx0OH2VFSRxu8ngsSymltg
        Zq+zJLMTSiNGZXCw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        ejb@linux.ibm.com, tglx@linutronix.de,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH 05/10] scsi/isci: Replace completion_tasklet with
 threaded irq
Message-ID: <Ypj/L3ySOSWqQUNu@linutronix.de>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-6-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220530231512.9729-6-dave@stgolabs.net>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-05-30 16:15:07 [-0700], Davidlohr Bueso wrote:
> Tasklets have long been deprecated as being too heavy on the system
> by running in irq context - and this is not a performance critical
> path. If a higher priority process wants to run, it must wait for
> the tasklet to finish before doing so. A more suitable equivalent
> is to converted to threaded irq instead and run in regular task
> context.

The convert looks okay. This driver even disables the interrupt source
before scheduling the tasklet :) However the whole routine
(sci_controller_completion_handler()) runs with disabled interrupt so it
makes no sense to use tasklets for completion or threaded interrupts=E2=80=
=A6

> Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>

Sebastian
