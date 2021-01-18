Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA86EC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7198722D6F
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437765AbhARVXc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 16:23:32 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54990 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389624AbhARKLN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 05:11:13 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610964630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oXp58ztUPQpe2lDu9I5bDZMNMwvtBAwE8TiJPqiuvCM=;
        b=KrSbafBpEUMukNZoCo4iLwtn95xctagBaRD/HSr5feTNfOn7KLbwrHQqjTzQR84N+KTSko
        s95Oal9oII21QPhvSXPL7AelUYlvcKmPgSpksPsPtjHcCWv1Wxgp3rlVHpmxTusyOhn/XR
        0IoOILhijnnmmcLMR8GgttkaBK+n4nzhqCp2UcOx94fiT3vdGWTQsj08ocAvd5vgGALRUQ
        dpW2Yg7hYNVz0FtPl/6XPdKdlZUGITctRz/PY8AdGtpHQ7G5PIPKsAB4TQ5YbGiRPpocU9
        kFRFo9UuVMYzuYZ/cyxZyr6K8MpCNZVmuyJv5LDVnoiR06l1zWldNSR9bs148w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610964630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oXp58ztUPQpe2lDu9I5bDZMNMwvtBAwE8TiJPqiuvCM=;
        b=y80DiuCzoMP2vvuroUZW8RgJS3b2cd3CVH8tx8q46jJbDovhohn/sWj1R5KxP1I7Fut3qc
        OSWN+UH19RlWPxBQ==
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH v3 06/19] scsi: isci: port: link up: Pass gfp_t flags
Date:   Mon, 18 Jan 2021 11:09:42 +0100
Message-Id: <20210118100955.1761652-7-a.darwish@linutronix.de>
In-Reply-To: <20210118100955.1761652-1-a.darwish@linutronix.de>
References: <20210118100955.1761652-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the new libsas event notifiers API, which requires callers to
explicitly pass the gfp_t memory allocation flags.

libsas sas_notify_port_event() is called from isci_port_link_up().
Below is the context analysis for all of its call chains:

host.c: isci_host_init()                                        (@)
spin_lock_irq(isci_host::scic_lock)
  -> sci_controller_initialize(), atomic                        (*)
    -> port_config.c: sci_port_configuration_agent_initialize()
      -> sci_mpc_agent_validate_phy_configuration()
        -> port.c: sci_port_add_phy()
          -> sci_port_general_link_up_handler()
            -> sci_port_activate_phy()
              -> isci_port_link_up()

port_config.c: apc_agent_timeout(), atomic, timer callback      (*)
  -> sci_apc_agent_configure_ports()
    -> port.c: sci_port_add_phy()
      -> sci_port_general_link_up_handler()
        -> sci_port_activate_phy()
          -> isci_port_link_up()

phy.c: enter SCI state: *SCI_PHY_SUB_FINAL*                     # Cont. from [1]
  -> phy.c: sci_phy_starting_final_substate_enter()
    -> phy.c: sci_change_state(SCI_PHY_READY)
      -> enter SCI state: *SCI_PHY_READY*
        -> phy.c: sci_phy_ready_state_enter()
          -> host.c: sci_controller_link_up()
            -> .link_up_handler()
            == port_config.c: sci_apc_agent_link_up()
              -> port.c: sci_port_link_up()
                -> (continue at [A])
            == port_config.c: sci_mpc_agent_link_up()
	      -> port.c: sci_port_link_up()
                -> (continue at [A])

port_config.c: mpc_agent_timeout(), atomic, timer callback      (*)
spin_lock_irqsave(isci_host::scic_lock, )
  -> ->link_up_handler()
  == port_config.c: sci_apc_agent_link_up()
    -> port.c: sci_port_link_up()
      -> (continue at [A])
  == port_config.c: sci_mpc_agent_link_up()
    -> port.c: sci_port_link_up()
      -> (continue at [A])

[A] port.c: sci_port_link_up()
  -> sci_port_activate_phy()
    -> isci_port_link_up()
  -> sci_port_general_link_up_handler()
    -> sci_port_activate_phy()
      -> isci_port_link_up()

[1] Call chains for entering SCI state: *SCI_PHY_SUB_FINAL*
-----------------------------------------------------------

host.c: power_control_timeout(), atomic, timer callback         (*)
spin_lock_irqsave(isci_host::scic_lock, )
  -> phy.c: sci_phy_consume_power_handler()
    -> phy.c: sci_change_state(SCI_PHY_SUB_FINAL)

host.c: sci_controller_error_handler(): atomic, irq handler     (*)
OR host.c: sci_controller_completion_handler(), atomic, tasklet (*)
  -> sci_controller_process_completions()
    -> sci_controller_unsolicited_frame()
      -> phy.c: sci_phy_frame_handler()
        -> sci_change_state(SCI_PHY_SUB_AWAIT_SAS_POWER)
          -> sci_phy_starting_await_sas_power_substate_enter()
            -> host.c: sci_controller_power_control_queue_insert()
              -> phy.c: sci_phy_consume_power_handler()
                -> sci_change_state(SCI_PHY_SUB_FINAL)
        -> sci_change_state(SCI_PHY_SUB_FINAL)
    -> sci_controller_event_completion()
      -> phy.c: sci_phy_event_handler()
        -> sci_phy_start_sata_link_training()
          -> sci_change_state(SCI_PHY_SUB_AWAIT_SATA_POWER)
            -> sci_phy_starting_await_sata_power_substate_enter
              -> host.c: sci_controller_power_control_queue_insert()
                -> phy.c: sci_phy_consume_power_handler()
                  -> sci_change_state(SCI_PHY_SUB_FINAL)

As can be seen from the "(*)" markers above, all the call-chains are
atomic.  Pass GFP_ATOMIC to libsas port event notifier.

Note, the now-replaced libsas APIs used in_interrupt() to implicitly
decide which memory allocation type to use.  This was only partially
correct, as it fails to choose the correct GFP flags when just
preemption or interrupts are disabled. Such buggy code paths are marked
with "(@)" in the call chains above.

Fixes: 1c393b970e0f ("scsi: libsas: Use dynamic alloced work to avoid sas event lost")
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Reviewed-by: John Garry <john.garry@huawei.com>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/scsi/isci/port.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index a3c58718c260..10136ae466e2 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -223,7 +223,8 @@ static void isci_port_link_up(struct isci_host *isci_host,
 	/* Notify libsas that we have an address frame, if indeed
 	 * we've found an SSP, SMP, or STP target */
 	if (success)
-		sas_notify_port_event(&iphy->sas_phy, PORTE_BYTES_DMAED);
+		sas_notify_port_event_gfp(&iphy->sas_phy,
+					  PORTE_BYTES_DMAED, GFP_ATOMIC);
 }
 
 
-- 
2.30.0

