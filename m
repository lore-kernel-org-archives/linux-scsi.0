Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA131C83014
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 15:22:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7049520719
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 15:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgK3PWE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 10:22:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:33040 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728081AbgK3PWE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Nov 2020 10:22:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 04144AF0E;
        Mon, 30 Nov 2020 15:21:23 +0000 (UTC)
Date:   Mon, 30 Nov 2020 16:21:22 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-scsi@vger.kernel.org,
        Finn Thain <fthain@telegraphics.com.au>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>,
        linux-m68k@lists.linux-m68k.org,
        Manish Rangankar <mrangankar@marvell.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Nilesh Javali <njavali@marvell.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vikram Auradkar <auradkar@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Xiaofei Tan <tanxiaofei@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>
Subject: Re: [PATCH 10/14] scsi: myrb: Remove WARN_ON(in_interrupt()).
Message-ID: <20201130152122.ewa6pcbtcxnsplic@beryllium.lan>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
 <20201126132952.2287996-11-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126132952.2287996-11-bigeasy@linutronix.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 26, 2020 at 02:29:48PM +0100, Sebastian Andrzej Siewior wrote:
> From: "Ahmed S. Darwish" <a.darwish@linutronix.de>
> 
> The in_interrupt() macro is ill-defined and does not provide what the
> name suggests. The usage especially in driver code is deprecated and a
> tree-wide effort to clean up and consolidate the (ab)usage of
> in_interrupt() and related checks is happening.
> 
> In this case the check covers only parts of the contexts in which these
> functions cannot be called. It fails to detect preemption or interrupt
> disabled invocations.
> 
> As wait_for_completion() already contains a broad variety of checks
> (always enabled or debug option dependent) which cover all invalid
> conditions already, there is no point in having extra inconsistent
> warnings in drivers.
> 
> Just remove it.
> 
> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Hannes Reinecke <hare@kernel.org>

Reviewed-by: Daniel Wagner <dwagner@suse.de>
