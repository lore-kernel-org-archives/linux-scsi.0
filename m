Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B31CEC3526C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 20:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A99C23B70
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 20:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387661AbgLRUpD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 15:45:03 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54776 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387659AbgLRUpC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 15:45:02 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608324260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Phxs3nhTQCA161gYyAdd8PFDfeymbesq1r2GRKF7wjA=;
        b=NvXmXRL9rKNj43+OLHjx5imThFW/lYXiD2Yy6yT3dlqfbuFHzh8i55C9UPkGcPUCfPS0ki
        0tCtqXDZtn4vjTYSdjAYWCdESVqRKSVjn1HuahZ4K47NcaP+hF6fvLRuQ4wwZPZEa0lVjA
        CK627BNUJJcILxZZd5XvezVV+q3KmILLvK88Ump1JTGLtLY1UqVE3MUZSN9ZzzbmH32xjt
        a8U7Ok82ICrwbUuvzwmWNJBhmWA1jeWwv5SP3ax0OCAoiBssEkkEW9R7YL8RZG3VL8FCip
        bO5FVdJZ4N0X8ndClctmgRvECq50O/udO7KK7mp7Vm4KysF+2Tz5w0aVfzFYew==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608324260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Phxs3nhTQCA161gYyAdd8PFDfeymbesq1r2GRKF7wjA=;
        b=Z8ddYskANnPyvVd64IGDc2sS2k7FvSEG0qnBjjMuXMae39WYDgoWuqKM7pcALOQCJvikRa
        6OSBKgBZYweid3BA==
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Jason Yan <yanaijie@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH 05/11] scsi: isci: port: link up: Pass gfp_t flags
Date:   Fri, 18 Dec 2020 21:43:48 +0100
Message-Id: <20201218204354.586951-6-a.darwish@linutronix.de>
In-Reply-To: <20201218204354.586951-1-a.darwish@linutronix.de>
References: <20201218204354.586951-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the new libsas event notifiers API, which requires callers to
explicitly pass the gfp_t memory allocation flags.

The libsas ->notify_port_event() hook is called from
isci_port_link_up().  Below is the context analysis for all of its call
chains:

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

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: stable@vger.kernel.org
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/scsi/isci/port.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index c3a8c84b19a2..69684c80c407 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -223,8 +223,9 @@ static void isci_port_link_up(struct isci_host *isci_host,
 	/* Notify libsas that we have an address frame, if indeed
 	 * we've found an SSP, SMP, or STP target */
 	if (success)
-		isci_host->sas_ha.notify_port_event(&iphy->sas_phy,
-						    PORTE_BYTES_DMAED);
+		isci_host->sas_ha.notify_port_event_gfp(&iphy->sas_phy,
+							PORTE_BYTES_DMAED,
+							GFP_ATOMIC);
 }
 
 
-- 
2.29.2

