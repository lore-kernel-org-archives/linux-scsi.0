Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9086C4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 20:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9409323B70
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 20:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387675AbgLRUpI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 15:45:08 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54790 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgLRUpI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 15:45:08 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608324265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=98adWOsfLr+hSn2jJKTMnAiX6dlxgrFL6Q+KkrxeV2w=;
        b=VUf5HJJWF0xqOXWV5WPhIPTeisRmb4goftxKvC15RIDIv/8BTrGU9YMAKgcFU8uDUjU6KZ
        LjMLHtLV2BlkJ2qp39VsCO0tFhwl/7fvTI3iR+wkwBJMDyLYOF5cu0DSGUJxqnLXKFmQWB
        ZuehE37VPrEqXcUhprflgmL15K1V3WEYDnfbt3armb15jN+gLGPsEzeXrM3EKioeo7afUr
        JPtVkAz/vmKjPWFptlD33aMZKTD/ZGY6ylPAvn+5G8KKhOhUuxS8I9vqNWfW3GAcdQJh+s
        fC59XQm/PyY7KCmflkj+Zl5mtpwS+uIL8kWNW6taUoWHOQ2x4TdgtjuKWhJ1BQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608324265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=98adWOsfLr+hSn2jJKTMnAiX6dlxgrFL6Q+KkrxeV2w=;
        b=6wVDG2L/dANMNP6tVpXHvV5aUOdi7BdaxWwtqY0ooK5KhnkftLEuhbSmWeplN12yfUCRjN
        iyN3+lJvHC+HO0Ag==
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
Subject: [PATCH 06/11] scsi: isci: port: broadcast change: Pass gfp_t flags
Date:   Fri, 18 Dec 2020 21:43:49 +0100
Message-Id: <20201218204354.586951-7-a.darwish@linutronix.de>
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
isci_port_bc_change_received(). Below is the context analysis for all of
its call chains:

host.c: sci_controller_error_handler(): atomic, irq handler     (*)
OR host.c: sci_controller_completion_handler(), atomic, tasklet (*)
  -> sci_controller_process_completions()
    -> sci_controller_event_completion()
      -> phy.c: sci_phy_event_handler()
        -> port.c: sci_port_broadcast_change_received()
          -> isci_port_bc_change_received()

host.c: isci_host_init()                                        (@)
spin_lock_irq(isci_host::scic_lock)
  -> sci_controller_initialize(), atomic                        (*)
    -> port_config.c: sci_port_configuration_agent_initialize()
      -> sci_mpc_agent_validate_phy_configuration()
        -> port.c: sci_port_add_phy()
          -> sci_port_set_phy()
            -> phy.c: sci_phy_set_port()
              -> port.c: sci_port_broadcast_change_received()
                -> isci_port_bc_change_received()

port_config.c: apc_agent_timeout(), atomic, timer callback      (*)
  -> sci_apc_agent_configure_ports()
    -> port.c: sci_port_add_phy()
      -> sci_port_set_phy()
        -> phy.c: sci_phy_set_port()
          -> port.c: sci_port_broadcast_change_received()
            -> isci_port_bc_change_received()

phy.c: enter SCI state: *SCI_PHY_STOPPED*                       # Cont. from [1]
  -> sci_phy_stopped_state_enter()
    -> host.c: sci_controller_link_down()
      -> ->link_down_handler()
      == port_config.c: sci_apc_agent_link_down()
        -> port.c: sci_port_remove_phy()
          -> sci_port_clear_phy()
            -> phy.c: sci_phy_set_port()
              -> port.c: sci_port_broadcast_change_received()
                -> isci_port_bc_change_received()

phy.c: enter SCI state: *SCI_PHY_STARTING*                      # Cont. from [2]
  -> sci_phy_starting_state_enter()
    -> host.c: sci_controller_link_down()
      -> ->link_down_handler()
      == port_config.c: sci_apc_agent_link_down()
        -> port.c: sci_port_remove_phy()
          -> sci_port_clear_phy()
            -> phy.c: sci_phy_set_port()
              -> port.c: sci_port_broadcast_change_received()
                -> isci_port_bc_change_received()

[1] Call chains for entering state: *SCI_PHY_STOPPED*
-----------------------------------------------------

host.c: isci_host_init()                                        (@)
spin_lock_irq(isci_host::scic_lock)
  -> sci_controller_initialize(), atomic                        (*)
      -> phy.c: sci_phy_initialize()
        -> phy.c: sci_phy_link_layer_initialization()
          -> phy.c: sci_change_state(SCI_PHY_STOPPED)

init.c: PCI ->remove() || PM_OPS ->suspend,  process context    (+)
  -> host.c: isci_host_deinit()
    -> sci_controller_stop_phys()
      -> phy.c: sci_phy_stop()
	-> sci_change_state(SCI_PHY_STOPPED)

phy.c: isci_phy_control()
spin_lock_irqsave(isci_host::scic_lock, )
  -> sci_phy_stop(), atomic                                     (*)
    -> sci_change_state(SCI_PHY_STOPPED)

[2] Call chains for entering state: *SCI_PHY_STARTING*
------------------------------------------------------

phy.c: phy_sata_timeout(), atimer, timer callback               (*)
spin_lock_irqsave(isci_host::scic_lock, )
  -> sci_change_state(SCI_PHY_STARTING)

host.c: phy_startup_timeout(), atomic, timer callback           (*)
spin_lock_irqsave(isci_host::scic_lock, )
  -> sci_controller_start_next_phy()
    -> sci_phy_start()
      -> sci_change_state(SCI_PHY_STARTING)

host.c: isci_host_start()                                       (@)
spin_lock_irq(isci_host::scic_lock)
  -> sci_controller_start(), atomic                             (*)
    -> sci_controller_start_next_phy()
      -> sci_phy_start()
        -> sci_change_state(SCI_PHY_STARTING)

phy.c: Enter SCI state *SCI_PHY_SUB_FINAL*                      # Cont. from [2A]
  -> sci_change_state(SCI_PHY_SUB_FINAL)
    -> sci_phy_starting_final_substate_enter()
      -> sci_change_state(SCI_PHY_READY)
        -> Enter SCI state: *SCI_PHY_READY*
          -> sci_phy_ready_state_enter()
            -> host.c: sci_controller_link_up()
              -> sci_controller_start_next_phy()
                -> sci_phy_start()
                  -> sci_change_state(SCI_PHY_STARTING)

phy.c: sci_phy_event_handler(), atomic, discussed earlier       (*)
  -> sci_change_state(SCI_PHY_STARTING), 11 instances

port.c: isci_port_perform_hard_reset()
spin_lock_irqsave(isci_host::scic_lock, )
  -> port.c: sci_port_hard_reset(), atomic                      (*)
    -> phy.c: sci_phy_reset()
      -> sci_change_state(SCI_PHY_RESETTING)
        -> enter SCI PHY state: *SCI_PHY_RESETTING*
          -> sci_phy_resetting_state_enter()
            -> sci_change_state(SCI_PHY_STARTING)

[2A] Call chains for entering SCI state: *SCI_PHY_SUB_FINAL*
------------------------------------------------------------

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

As can be seen from the "(*)" markers above, almost all the call-chains
are atomic. The only exception, marked with "(+)", is a PCI ->remove()
and PM_OPS ->suspend() cold path. Thus, pass GFP_ATOMIC to the libsas
port event notifier.

Note, the now-replaced libsas APIs used in_interrupt() to implicitly
decide which memory allocation type to use.  This was only partially
correct, as it fails to choose the correct GFP flags when just
preemption or interrupts are disabled. Such buggy code paths are marked
with "(@)" in the call chains above.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: stable@vger.kernel.org
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/scsi/isci/port.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 69684c80c407..6244981a3ebf 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -164,7 +164,9 @@ static void isci_port_bc_change_received(struct isci_host *ihost,
 		"%s: isci_phy = %p, sas_phy = %p\n",
 		__func__, iphy, &iphy->sas_phy);
 
-	ihost->sas_ha.notify_port_event(&iphy->sas_phy, PORTE_BROADCAST_RCVD);
+	ihost->sas_ha.notify_port_event_gfp(&iphy->sas_phy,
+					    PORTE_BROADCAST_RCVD,
+					    GFP_ATOMIC);
 	sci_port_bcn_enable(iport);
 }
 
-- 
2.29.2

