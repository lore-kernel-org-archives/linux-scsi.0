Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C3C8C64E7B
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 11:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40C172084C
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 11:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgK3LAk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 06:00:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:55464 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727656AbgK3LAj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Nov 2020 06:00:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 54E9CAC6A;
        Mon, 30 Nov 2020 10:59:57 +0000 (UTC)
Date:   Mon, 30 Nov 2020 11:59:56 +0100
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
Subject: Re: [PATCH 04/14] scsi: qla2xxx: qla82xx: Remove in_interrupt().
Message-ID: <20201130105956.t4qlyumcfwnsby2r@beryllium.lan>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
 <20201126132952.2287996-5-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126132952.2287996-5-bigeasy@linutronix.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 26, 2020 at 02:29:42PM +0100, Sebastian Andrzej Siewior wrote:
> From: "Ahmed S. Darwish" <a.darwish@linutronix.de>
> 
> qla82xx_idc_lock() spins on a certain hardware state until it's updated. At
> the end of each spin, if in_interrupt() is true, it does 20 loops of
> cpu_relax(). Otherwise, it yields the CPU.
> 
> While in_interrupt() is ill-defined and does not provide what the name
> suggests, it is not needed here: qla82xx_idc_lock() is always called
> from process context. Below is an analysis of its callers, in order of
> appearance:
> 
>   - qla_nx.c: qla82xx_device_bootstrap(), only called by
>     qla82xx_device_state_handler(), has multiple msleep()s.
> 
>   - qla_nx.c: qla82xx_need_qsnt_handler(), has one second msleep()
> 
>   - qla_nx.c: qla82xx_wait_for_state_change(), one second msleep()
> 
>   - qla_nx.c: qla82xx_need_reset_handler(), can sleep up to 10 seconds
> 
>   - qla_nx.c: qla82xx_device_state_handler(), has multiple msleep()s
> 
>   - qla_nx.c: qla82xx_abort_isp(), if it's a qla82xx controller, calls
>     qla82xx_device_state_handler(), which sleeps. It's also bound to
>     isp_operations ->abort_isp() hook, where all the callers are in
>     process context.
> 
>   - qla_nx.c: qla82xx_beacon_on(), bound to isp_operations ->beacon_on()
>     hook.  That hook is only called once, in a mutex locked context,
>     from qla2x00_beacon_store().
> 
>   - qla_nx.c: qla82xx_beacon_off(), bound to isp_operations
>     ->beacon_off() hook.  Like ->beacon_on(), it's only called once, in
>     a mutex locked context, from qla2x00_beacon_store().
> 
>   - qla_nx.c: qla82xx_fw_dump(), calls qla2x00_wait_for_chip_reset(),
>     which has msleep() in a loop. It is bound to isp_operations
>     ->fw_dump() hook. That hook *is* called from atomic context at
>     qla_isr.c by multiple interrupt handlers. Nonetheless, it's other
>     controllers interrupt handlers, and not the qla82xx.

qla82xx_msix_default() and qla82xx_msix_rsp_q() call
qla24xx_process_response_queue() which doesn't implement the firmware
dumping.

>   - qla_attr.c: qla2x00_sysfs_write_fw_dump(), and
>     qla2x00_sysfs_write_reset(), process-context sysfs ->write() hooks.
> 
>   - qla_os.c: qla2x00_probe_one(). PCI ->probe(), process context.
> 
>   - qla_os.c: qla2x00_clear_drv_active(), called solely from
>     qla2x00_remove_one(), which is PCI ->remove() hook, process context.
> 
>   - qla_os.c: qla2x00_do_dpc(), kthread function, process context.
> 
> Remove the in_interrupt() check. Change qla82xx_idc_lock() specification
> to a purely process-context function. Mark it with "Context: task, might
> sleep".
> 
> Change qla82xx_idc_lock() implementation to sleep 100ms, instead of a
> schedule(), for each spin. This is more deterministic, and it matches
> the other qla models idc_lock() functions.
> 
> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: <GR-QLogic-Storage-Upstream@marvell.com>

Reviewed-by: Daniel Wagner <dwagner@suse.de>
