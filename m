From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 00/19, v5] Make ib_srp better suited for H.A. purposes
Date: Fri, 26 Oct 2012 14:44:43 +0200
Message-ID: <508A85BB.1000505@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This patch series makes the ib_srp driver better suited for use in a
H.A. setup because:
- multipathd is notified faster about transport layer failures.
- Transport layer failures reliably result in SCSI host removal.
- Switchover can be triggered explicitly by deleting an initiator
   device.
- Disconnecting from a target without unloading ib_srp is now possible.

This patch series is also available here:
http://github.com/bvanassche/linux/commits/srp-ha
And a backport of this patch series to kernels 3.6 and before is 
available here: http://github.com/bvanassche/ib_srp-backport.

Changes since v4:
- Added a patch for removing SCSI devices upon a port down event

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
0001-ib_srp-Enlarge-block-layer-timeout.patch
0002-ib_srp-Eliminate-state-SRP_TARGET_CONNECTING.patch
0003-ib_srp-Introduce-srp_handle_qp_err.patch
0004-ib_srp-Suppress-superfluous-error-messages.patch
0005-ib_srp-Avoid-that-SCSI-error-handling-causes-trouble.patch
0006-ib_srp-Introduce-the-helper-function-srp_remove_targ.patch
0007-ib_srp-Eliminate-state-SRP_TARGET_DEAD.patch
0008-ib_srp-Keep-processing-commands-during-host-removal.patch
0009-ib_srp-Make-srp_disconnect_target-wait-for-IB-comple.patch
0010-ib_srp-Document-sysfs-attributes.patch
0011-srp_transport-Fix-atttribute-registration.patch
0012-srp_transport-Simplify-attribute-initialization-code.patch
0013-srp_transport-Document-sysfs-attributes.patch
0014-ib_srp-Allow-SRP-disconnect-through-sysfs.patch
0015-ib_srp-Maintain-a-single-connection-per-I_T-nexus.patch
0016-srp_transport-Add-transport-layer-error-handling.patch
0017-ib_srp-Add-dev_loss_tmo-support.patch
0018-ib_srp-Remove-SCSI-devices-upon-port-down-event.patch
0019-scsi_transport_srp-Fail-I-O-faster.patch

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
