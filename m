Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B26C64E90
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 13:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AEA1206F9
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 13:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgK3N1Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 08:27:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:39242 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgK3N1Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Nov 2020 08:27:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EC535ABD2;
        Mon, 30 Nov 2020 13:26:33 +0000 (UTC)
Date:   Mon, 30 Nov 2020 14:26:33 +0100
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
Subject: Re: [PATCH 06/14] scsi: qla2xxx: init/os: Remove in_interrupt().
Message-ID: <20201130132633.ikv7vgoh64bagf4u@beryllium.lan>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
 <20201126132952.2287996-7-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126132952.2287996-7-bigeasy@linutronix.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 26, 2020 at 02:29:44PM +0100, Sebastian Andrzej Siewior wrote:
> From: "Ahmed S. Darwish" <a.darwish@linutronix.de>
> 
> qla83xx_wait_logic() is used to control the frequency of device IDC lock
> retries. If in_interrupt() is true, it does 20 loops of cpu_relax().
> Otherwise, it sleeps for 100ms and yields the CPU.
> 
> While in_interrupt() is ill-defined and does not provide what the name
> suggests, it is not needed here: that qla83xx_wait_logic() is exclusively
> called by qla83xx_idc_lock() / unlock(), and they always run from
> process context. Below is an analysis of all the idc lock/unlock callers,
> in order of appearance:
> 
>   - qla_os.c:
>       qla83xx_nic_core_unrecoverable_work(),
>       qla83xx_idc_state_handler_work(),
>       qla83xx_nic_core_reset_work(),
>       qla83xx_service_idc_aen(), all workqueue context
> 
>   - qla_os.c: qla83xx_check_nic_core_fw_alive(), has msleep()
> 
>   - qla_os.c: qla83xx_set_drv_presence(), called once from
>     qla2x00_abort_isp(), which is bound to process-context ->abort_isp()
>     hook. It also invokes wait_for_completion_timeout() through the
>     chain qla2x00_configure_hba() => qla24xx_link_initialize() =>
>     qla2x00_mailbox_command().
> 
>   - qla_os.c: qla83xx_clear_drv_presence(), which is called from
>     qla2x00_abort_isp() discussed above, and from qla2x00_remove_one()
>     which is PCI process-context ->remove() hook.
> 
>   - qla_os.c: qla83xx_need_reset_handler(), has a one second msleep() in
>     a loop.
> 
>   - qla_os.c: qla83xx_device_bootstrap(), called only by
>     qla83xx_idc_state_handler(), which has multiple msleep()
>     invocations.
> 
>   - qla_os.c: qla83xx_idc_state_handler(), multiple msleep()
>     invocations.
> 
>   - qla_attr.c: qla2x00_sysfs_write_reset(), sysfs bin_attribute
>     ->write() hook, process context
> 
>   - qla_init.c: qla83xx_nic_core_fw_load()
>       => qla_init.c: qla2x00_initialize_adapter()
>         => bound to isp_operations ->initialize_adapter() hook
>         ** => qla_os.c: qla2x00_probe_one(), PCI ->probe() process ctx
> 
>   - qla_init.c: qla83xx_initiating_reset(), msleep() in a loop.
> 
>   - qla_init.c: qla83xx_nic_core_reset(), called by
>     qla83xx_nic_core_reset_work(), workqueue context.
> 
> Remove the in_interrupt() check, and thus replace the entirety of
> qla83xx_wait_logic() with an msleep(QLA83XX_WAIT_LOGIC_MS).
> 
> Mark qla83xx_idc_lock() / unlock() with "Context: task, can sleep".
> 
> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: GR-QLogic-Storage-Upstream@marvell.com

Reviewed-by: Daniel Wagner <dwagner@suse.de>
