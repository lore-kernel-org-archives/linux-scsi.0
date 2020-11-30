Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B19B7C8300F
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 14:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D7D92084C
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 14:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgK3OVF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 09:21:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:38732 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbgK3OVF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Nov 2020 09:21:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 54AECAD6B;
        Mon, 30 Nov 2020 14:20:23 +0000 (UTC)
Date:   Mon, 30 Nov 2020 15:20:22 +0100
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
Subject: Re: [PATCH 07/14] scsi: qla4xxx: qla4_82xx_idc_lock(): Remove
 in_interrupt().
Message-ID: <20201130142022.c564ssrgaugmq5qw@beryllium.lan>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
 <20201126132952.2287996-8-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126132952.2287996-8-bigeasy@linutronix.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 26, 2020 at 02:29:45PM +0100, Sebastian Andrzej Siewior wrote:
> From: "Ahmed S. Darwish" <a.darwish@linutronix.de>
> 
> qla4_82xx_idc_lock() spins on a certain hardware state until it is
> updated. At the end of each spin, if in_interrupt() is true, it does 20
> loops of cpu_relax(). Otherwise, it yields the CPU.
> 
> While in_interrupt() is ill-defined and does not provide what the name
> suggests, it is not needed here: qla4_82xx_idc_lock() is always called
> from process context. Below is an analysis of its callers:
> 
>   - ql4_nx.c: qla4_82xx_need_reset_handler(), 1-second msleep() in a
>     loop.
> 
>   - ql4_nx.c: qla4_82xx_isp_reset(), calls
>     qla4_8xxx_device_state_handler(), which has multiple msleep()s.
> 
> Beside direct calls, qla4_82xx_idc_lock() is also bound to
> isp_operations ->idc_lock() hook. Other functions which are bound to the
> same hook, e.g. qla4_83xx_drv_lock(), also have an msleep(). For
> completeness, below is an analysis of all callers of that hook:
> 
>   - ql4_83xx.c: qla4_83xx_need_reset_handler(), has an msleep()
> 
>   - ql4_83xx.c: qla4_83xx_isp_reset(), calls
>     qla4_8xxx_device_state_handler(), which has multiple msleep()s.
> 
>   - ql4_83xx.c: qla4_83xx_disable_pause(), all process context callers:
>     => ql4_mbx.c: qla4xxx_mailbox_command(), msleep(), mutex_lock()
>     => ql4_os.c: qla4xxx_recover_adapter(), schedule_timeout() in loop
>     => ql4_os.c: qla4xxx_do_dpc(), workqueue context
> 
>   - ql4_attr.c: qla4_8xxx_sysfs_write_fw_dump(), sysfs bin_attribute
>     ->write() hook, process context
> 
>   - ql4_mbx.c: qla4xxx_mailbox_command(), earlier discussed
> 
>   - ql4_nx.c: qla4_8xxx_device_bootstrap(), callers:
>     => ql4_83xx.c: qla4_83xx_need_reset_handler(), process, msleep()
>     => ql4_nx.c: qla4_8xxx_device_state_handler(), earlier discussed
> 
>   - ql4_nx.c: qla4_8xxx_need_qsnt_handler(), callers:
>     => ql4_nx.c: qla4_8xxx_device_state_handler(), multipe msleep()s
>     => ql4_os.c: qla4xxx_do_dpc(), workqueue context
> 
>   - ql4_nx.c: qla4_8xxx_update_idc_reg(), callers:
>     => ql4_nx.c: qla4_8xxx_device_state_handler(), earlier discussed
>     => ql4_os.c: qla4_8xxx_error_recovery(), only called by
>     qla4xxx_pci_slot_reset(), which is bound to PCI ->slot_reset()
>     process-context hook
> 
>   - ql4_nx.c: qla4_8xxx_device_state_handler(), earlier discussed
> 
>   - ql4_os.c: qla4xxx_recover_adapter(), earlier discussed
> 
>   - ql4_os.c: qla4xxx_do_dpc(), earlier discussed
> 
> Remove the in_interrupt() check. Mark, qla4_82xx_idc_lock(), and the
> ->idc_lock() hook itself, with "Context: task, can sleep".
> 
> Change qla4_82xx_idc_lock() implementation to sleep 100ms, instead of a
> schedule(), for each spin. This is more deterministic, and it matches
> other PCI HW locking functions in the driver.
> 
> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Manish Rangankar <mrangankar@marvell.com>
> Cc: <GR-QLogic-Storage-Upstream@marvell.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Reviewed-by: Daniel Wagner <dwagner@suse.de>
