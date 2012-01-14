From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 00/18, v2] Make ib_srp better suited for H.A. purposes
Date: Sat, 14 Jan 2012 12:36 +0000
Message-ID: <3109536.qySrY1Ts3e@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This patch series makes the ib_srp driver better suited for use in a H.A.
setup because:
- Switchover without triggering read or write errors become possible. Such
  errors are bad because these can make a filesystem switch to read-only
  mode.
- A ping mechanism has been added that allows to reduce the switch-over
  time.
- Disconnecting from a target without unloading ib_srp becomes possible.
- Switchover can be triggered explicitly by deleting an initiator device.

Changes since v1:
- Switched from iSCSI-style sysfs parameters to FC-style sysfs parameters
  (fast_io_fail_tmo and dev_loss_tmo).
- Restored the original behavior of "add_target": a second login to a target
  is again allowed and also stops error recovery for previously created
  sessions.
- Changed srp_disconnect_target() such that it waits for the last completion
  after a disconnect.
- Moved code for enlarging block layer timeout from srp_slave_alloc() to
  srp_slave_configure(), and moved that function to after srp_reset_host().
  Also addressed Dave's other comments to the code for enlarging the
  timeout value.
- Split the "ib_srp: Rework error handling" patch in three separate patches to
  make reviewing easier.
- Added a patch that slightly improves ib_srp performance.
- Made comment more detailed of patch 09/14 "srp_transport: Fix attribute
  registration"
- Merged multiline log strings into a single line.
- Dropped patch 05/14 "ib_srp: Avoid that late SRP replies cause trouble".
- Implemented several other small changes.

The individual patches are:
0001-ib_srp-Introduce-pr_fmt.patch
0002-ib_srp-Consolidate-repetitive-sysfs-code.patch
0003-ib_srp-Enlarge-block-layer-timeout.patch
0004-ib_srp-Micro-optimize-completion-handlers.patch
0005-ib_srp-Separate-connection-and-host-state.patch
0006-ib_srp-Wait-for-last-completion-when-disconnecting.patch
0007-ib_srp-Introduce-three-helper-functions.patch
0008-ib_srp-Eliminate-state-SRP_TARGET_DEAD.patch
0009-srp_transport-Fix-atttribute-registration.patch
0010-srp_transport-Simplify-attribute-initialization-code.patch
0011-srp_transport-Document-sysfs-attributes.patch
0012-ib_srp-Document-sysfs-attributes.patch
0013-ib_srp-Allow-SRP-disconnect-through-sysfs.patch
0014-ib_srp-Move-target-port-removal-code.patch
0015-ib_srp-Maintain-a-single-connection-per-I_T-nexus.patch
0016-scsi-Add-scsi_host_template.slave_delete-callback.patch
0017-srp_transport-Add-transport-layer-recovery-support.patch
0018-ib_srp-Rework-error-handling.patch

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
