From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 0/15] IB SRP initiator patches for kernel 3.11
Date: Fri, 28 Jun 2013 14:45:30 +0200
Message-ID: <51CD856A.3010102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The purpose of this InfiniBand SRP initiator patch series is as follows:
- Make the SRP initiator driver better suited for use in a H.A. setup.
   Speed up failover by reducing the IB RC retry count and by notifying
   multipathd faster about transport layer failures by adding
   fast_io_fail_tmo and dev_loss_tmo parameters.
- Make the SRP initiator better suited for use on NUMA systems by
   making the HCA completion vector configurable.

Changes since the v1 of the "IB SRP initiator patches for kernel 3.11" 
patch series:
- scsi_transport_srp: Allowed both fast_io_fail and dev_loss timeouts
   to be disabled.
- scsi_transport_srp, srp_reconnect_rport(): switched from
   scsi_block_requests() to scsi_target_block() for blocking SCSI command
   processing temporarily.
- scsi_transport_srp, srp_start_tl_fail_timers(): only block SCSI device
   command processing if the fast_io_fail timer is enabled.
- Changed srp_abort() such that upon transport offline the value
   FAST_IO_FAIL is returned instead of SUCCESS.
- Fixed a race condition in the "maintain single connection" patch: a
   new login after removal had started but before removal had finished
   still could create a duplicate connection. Fixed this by deferring
   removal from the target list until removal has finished.
- Modified the error message in the same patch for reporting that a
   duplicate connection has been rejected.
- Modified patch 2/15 such that all possible race conditions with
   srp_claim_req() are addressed.
- Documented the comp_vector and tl_retry_count login string parameters.
- Updated dev_loss_tmo and fast_io_fail_tmo documentation - mentioned
   "off" is a valid choice.

Changes compared to v5 of the "Make ib_srp better suited for H.A. 
purposes" patch series:
- Left out patches that are already upstream.
- Made it possible to set dev_loss_tmo to "off". This is useful in a
   setup using initiator side mirroring to avoid that new /dev/sd* names
   are reassigned after a failover or cable pull and reinsert.
- Added kernel module parameters to ib_srp for configuring default
   values of the fast_io_fail_tmo and dev_loss_tmo parameters.
- Added a patch from Dotan Barak that fixes a kernel oops during rmmod
   triggered by resource allocation failure at module load time.
- Avoid duplicate connections by refusing relogins instead of dropping
   duplicate connections, as proposed by Sebastian Riemer.
- Added a patch from Sebastian Riemer for failing SCSI commands
   silently.
- Added a patch from Vu Pham to make the transport layer (IB RC) retry
   count configurable.
- Made HCA completion vector configurable.

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

The individual patches in this series are as follows:
0001-IB-srp-Fix-remove_one-crash-due-to-resource-exhausti.patch
0002-IB-srp-Fix-race-between-srp_queuecommand-and-srp_cla.patch
0003-IB-srp-Avoid-that-srp_reset_host-is-skipped-after-a-.patch
0004-IB-srp-Fail-I-O-fast-if-target-offline.patch
0005-IB-srp-Skip-host-settle-delay.patch
0006-IB-srp-Maintain-a-single-connection-per-I_T-nexus.patch
0007-IB-srp-Keep-rport-as-long-as-the-IB-transport-layer.patch
0008-scsi_transport_srp-Add-transport-layer-error-handlin.patch
0009-IB-srp-Add-srp_terminate_io.patch
0010-IB-srp-Use-SRP-transport-layer-error-recovery.patch
0011-IB-srp-Start-timers-if-a-transport-layer-error-occur.patch
0012-IB-srp-Fail-SCSI-commands-silently.patch
0013-IB-srp-Make-HCA-completion-vector-configurable.patch
0014-IB-srp-Make-transport-layer-retry-count-configurable.patch
0015-IB-srp-Bump-driver-version-and-release-date.patch
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
