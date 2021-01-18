Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C5CC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65AD4229C6
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389156AbhARVOE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 16:14:04 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55204 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389241AbhARKN3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 05:13:29 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610964640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gbXhDEm5dffvxx8AZ+A+3u00ECm1mCEGs+Prvbg6XQA=;
        b=DpK3rxBrd1ifqK7oZeafbZgJWLNs/l/pNvQTvOknTTdTEBl28gv4haA4qplz4XowoDNV+w
        YdZuFZkSojY1jP/I6zCeBba55K3f/h94cvEjprdKThZgjsTO7K/9lzwo7OStxIO+sYDbnX
        IXSb+VHgh7l/OvPXsVy40KbW6lY/2c6ckyvi/8EFjkp9zDv5J38t5CBZj5OD/1uKthPx/5
        +PsUtPegdMj28NjJH5W9+aqFFFRyzpbmBsLu3NekBXpcc8WzkRTAEOmZiGBOws8SToc2Yc
        mLJLDRoXrwIC02L4cX+vLv+cwSckFfnOosV08GvbsA1Eh/m8thZktRLo9shJ4g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610964640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gbXhDEm5dffvxx8AZ+A+3u00ECm1mCEGs+Prvbg6XQA=;
        b=xEyN1C1Ii8D5wEqUvVYksrUOBrRDCys6cDV70QX0LziqyIAG2kb7ftllfqAOpNmjEyoLFz
        51sgPeKViov8O9Dw==
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
Subject: [PATCH v3 07/19] scsi: isci: port: broadcast change: Pass gfp_t flags
Date:   Mon, 18 Jan 2021 11:09:43 +0100
Message-Id: <20210118100955.1761652-8-a.darwish@linutronix.de>
In-Reply-To: <20210118100955.1761652-1-a.darwish@linutronix.de>
References: <20210118100955.1761652-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the new libsas event notifiers API, which requires callers to
explicitly pass the gfp_t memory allocation flags.

libsas sas_notify_port_event() is called from
isci_port_bc_change_received(). Below is the context analysis for all
of its call chains:

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

Fixes: 1c393b970e0f ("scsi: libsas: Use dynamic alloced work to avoid sas event lost")
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Reviewed-by: John Garry <john.garry@huawei.com>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/scsi/isci/port.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 10136ae466e2..e50c3b0deeb3 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -164,7 +164,8 @@ static void isci_port_bc_change_received(struct isci_host *ihost,
 		"%s: isci_phy = %p, sas_phy = %p\n",
 		__func__, iphy, &iphy->sas_phy);
 
-	sas_notify_port_event(&iphy->sas_phy, PORTE_BROADCAST_RCVD);
+	sas_notify_port_event_gfp(&iphy->sas_phy,
+				  PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 	sci_port_bcn_enable(iport);
 }
 
-- 
2.30.0

