From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 00/20, v4] Make ib_srp better suited for H.A. purposes
Date: Thu, 09 Aug 2012 15:41:45 +0000
Message-ID: <5023DA39.7020000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This patch series makes the ib_srp driver better suited for use in a
H.A. setup because:
- multipathd is notified faster about transport layer failures.
- Transport layer failures reliably result in a reconnect.
- Switchover can be triggered explicitly by deleting an initiator
  device.
- Disconnecting from a target without unloading ib_srp is now possible.

Changes since v3:
- Restored the dev_loss_tmo and fast_io_fail_tmo sysfs attributes.
- Included a patch to fix an ib_srp crash that could be triggered by
  cable pulling.

Changes since v2:
- Addressed the v2 review comments.
- Dropped the patches that have already been merged.
- Dropped the patches for integration with multipathd.
- Dropped the micro-optimization of the IB completion handlers.

The individual patches are:
0001-ib_srp-Fix-a-race-condition.patch
0002-ib_srp-Enlarge-block-layer-timeout.patch
0003-ib_srp-Move-QP-state-check-into-srp_send_tsk_mgmt.patch
0004-ib_srp-Stop-queueing-if-QP-in-error.patch
0005-ib_srp-Eliminate-state-SRP_TARGET_CONNECTING.patch
0006-ib_srp-Suppress-superfluous-error-messages.patch
0007-ib_srp-Avoid-that-SCSI-error-handling-triggers-a-cra.patch
0008-ib_srp-Introduce-the-helper-function-srp_remove_targ.patch
0009-ib_srp-Eliminate-state-SRP_TARGET_DEAD.patch
0010-ib_srp-Keep-processing-commands-during-scsi_remove_h.patch
0011-ib_srp-Make-srp_disconnect_target-wait-for-IB-comple.patch
0012-ib_srp-Document-sysfs-attributes.patch
0013-srp_transport-Fix-atttribute-registration.patch
0014-srp_transport-Simplify-attribute-initialization-code.patch
0015-srp_transport-Document-sysfs-attributes.patch
0016-ib_srp-Allow-SRP-disconnect-through-sysfs.patch
0017-ib_srp-Introduce-a-temporary-variable-in-srp_remove_.patch
0018-ib_srp-Maintain-a-single-connection-per-I_T-nexus.patch
0019-srp_transport-Add-transport-layer-error-handling.patch
0020-ib_srp-Add-dev_loss_tmo-support.patch

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
