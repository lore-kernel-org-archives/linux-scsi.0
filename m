From: FUJITA Tomonori <tomof@acm.org>
Subject: RE: [PATCH 0/5] mpt fusion: Add logging support
Date: Tue, 31 Jul 2007 07:31:50 +0900
Message-ID: <20070731005521U.tomof@acm.org>
References: <1185644421.11492.32.camel@localhost.localdomain>
	<664A4EBB07F29743873A87CF62C26D708B3F1D@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:48161 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968902AbXG3WcI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jul 2007 18:32:08 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D708B3F1D@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: James.Bottomley@SteelEye.com, Sathya.Prakash@lsi.com, linux-scsi@vger.kernel.org, tomof@acm.org, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp

From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 0/5] mpt fusion: Add logging support
Date: Mon, 30 Jul 2007 12:33:00 -0600

> On Saturday, July 28, 2007 11:40 AM,  James Bottomley wrote: 
> > 
> > I tell you what, let me just show you the actual patch.  This 
> > allows you
> > to write to the 
> > /sys/module/mptbase/parameters/mpt_debug_level and have
> > it take effect in every ioc.
> > 
> 
> ACK,  If possible, I would like this patch thrown in with the other
> fusion logging patchs you added over the weekend to the
> scsi-rc-fixes-2.6 stream. Thanks.
> 
> On another note, while unloading the driver, and I get an following opps
> from bsg in the context of scsi_remove_host.   This is w/o the "SMP
> passthrough" patch, so why would fusion drivers be linked to bsg?
> Woudn't this break mptspi and mptfc, since they will not be working with
> bsg.
> 
> 
> Call Trace:
>  [<ffffffff881f519c>] :scsi_transport_sas:sas_bsg_remove+0x27/0x32
>  [<ffffffff881f6349>] :scsi_transport_sas:sas_host_remove+0x30/0x34
>  [<ffffffff80375326>] transport_remove_classdev+0x1d/0x4c
>  [<ffffffff80375001>] attribute_container_device_trigger+0x69/0xa7
>  [<ffffffff8803778b>] :scsi_mod:scsi_remove_host+0xcd/0xfa
>  [<ffffffff883461ac>] :mptscsih:mptscsih_remove+0x32/0xae
>  [<ffffffff8031416d>] pci_device_remove+0x24/0x48
>  [<ffffffff803720ed>] __device_release_driver+0x91/0xb3
>  [<ffffffff80372631>] driver_detach+0xd6/0x115
>  [<ffffffff80371ba3>] bus_remove_driver+0x6d/0x90
>  [<ffffffff803143f4>] pci_unregister_driver+0x17/0x6b
>  [<ffffffff88355044>] :mptsas:mptsas_exit+0x10/0x5f
>  [<ffffffff80252afb>] sys_delete_module+0x1b1/0x1e0
>  [<ffffffff80307d9c>] __up_write+0x21/0x10d
>  [<ffffffff8020bc4e>] system_call+0x7e/0x83

This patch fix the problem?

---
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi_transport_sas: initialize sas_host_attrs->q

fix the bug to call bsg_unregister_queue for an uninitialized queue.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_transport_sas.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 3120f4b..b0a21a2 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -270,6 +270,7 @@ static int sas_host_setup(struct transport_container *tc, struct device *dev,
 	sas_host->next_target_id = 0;
 	sas_host->next_expander_id = 0;
 	sas_host->next_port_id = 0;
+	sas_host->q = NULL;
 
 	if (sas_bsg_initialize(shost, NULL))
 		dev_printk(KERN_ERR, dev, "fail to a bsg device %d\n",
-- 
1.5.2.4

