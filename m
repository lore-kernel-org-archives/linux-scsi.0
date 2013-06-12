From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/14] IB SRP initiator patches for kernel 3.11
Date: Wed, 12 Jun 2013 15:17:53 +0200
Message-ID: <51B87501.4070005@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:57009 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3FLNR4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jun 2013 09:17:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, David Dillow <dillowda@ornl.gov>, Vu Pham <vuhuong@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>

The purpose of this InfiniBand SRP initiator patch series is as follows:
- Make the SRP initiator driver better suited for use in a H.A. setup.
   Speed up failover by reducing the IB RC retry count and by notifying
   multipathd faster about transport layer failures by adding
   fast_io_fail_tmo and dev_loss_tmo parameters.
- Make the SRP initiator better suited for use on NUMA systems by
   making the HCA completion vector configurable.

Some of the patches in this patch series were posted previously as "Make 
ib_srp better suited for H.A. purposes". The changes compared to version 
five of that patch series are:
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
0004-IB-srp-Skip-host-settle-delay.patch
0005-IB-srp-Maintain-a-single-connection-per-I_T-nexus.patch
0006-IB-srp-Keep-rport-as-long-as-the-IB-transport-layer.patch
0007-scsi_transport_srp-Add-transport-layer-error-handlin.patch
0008-IB-srp-Add-srp_terminate_io.patch
0009-IB-srp-Use-SRP-transport-layer-error-recovery.patch
0010-IB-srp-Start-timers-if-a-transport-layer-error-occur.patch
0011-IB-srp-Fail-SCSI-commands-silently.patch
0012-IB-srp-Make-HCA-completion-vector-configurable.patch
0013-IB-srp-Make-transport-layer-retry-count-configurable.patch
0014-IB-srp-Bump-driver-version-and-release-date.patch

