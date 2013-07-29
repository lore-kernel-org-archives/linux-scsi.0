From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60649] New: mpt3sas/mpt3sas_scsih.c: mem leak on error path
Date: Mon, 29 Jul 2013 20:18:11 +0000
Message-ID: <bug-60649-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41011 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754239Ab3G2USQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jul 2013 16:18:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 140D52039A
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 20:18:15 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 5BD5C203AF
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 20:18:12 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60649

            Bug ID: 60649
           Summary: mpt3sas/mpt3sas_scsih.c: mem leak on error path
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.11rc2
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: mikko.rapeli@iki.fi
        Regression: No

Coverity reports in CID 751482:

2510mpt3sas_send_trigger_data_event(struct MPT3SAS_ADAPTER *ioc,
2511        struct SL_WH_TRIGGERS_EVENT_DATA_T *event_data)
2512{
2513        struct fw_event_work *fw_event;
2514
        1. Condition "ioc->is_driver_loading", taking false branch
2515        if (ioc->is_driver_loading)
2516                return;
        2. alloc_fn: Storage is returned from allocation function
"kzalloc(size_t, gfp_t)". [show details]
        3. var_assign: Assigning: "fw_event" = storage returned from
"kzalloc(352UL, 32U)".
2517        fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
        4. Condition "!fw_event", taking false branch
2518        if (!fw_event)
2519                return;
2520        fw_event->event_data = kzalloc(sizeof(*event_data), GFP_ATOMIC);
        5. Condition "!fw_event->event_data", taking true branch
2521        if (!fw_event->event_data)

CID 751482 (#1 of 1): Resource leak (RESOURCE_LEAK)
6. leaked_storage: Variable "fw_event" going out of scope leaks the storage it
points to.
2522                return;

Fix should be something like:

--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2518,8 +2518,10 @@ mpt3sas_send_trigger_data_event(struct MPT3SAS_ADAPTER
*ioc,
        if (!fw_event)
                return;
        fw_event->event_data = kzalloc(sizeof(*event_data), GFP_ATOMIC);
-       if (!fw_event->event_data)
+       if (!fw_event->event_data) {
+               kfree(fw_event);
                return;
+       }
        fw_event->event = MPT3SAS_PROCESS_TRIGGER_DIAG;
        fw_event->ioc = ioc;
        memcpy(fw_event->event_data, event_data, sizeof(*event_data));

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
