From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [ATTEND] target + scsi mixed mode interaction, scsi IOPs
 performance limitations, tcm_vhost shared storage ALUA multipath
Date: Sun, 17 Jun 2012 17:56:50 -0700
Message-ID: <1339981010.12064.412.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60910 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab2FRA4x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Jun 2012 20:56:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KS-2012-discuss <ksummit-2012-discuss@lists.linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

Hello KS-2012 PCs,

I would like to attend KS-2012 this year in San Diego, and think I can
benefit the discussion in the following ways..

I'm maintainer of the target storage subsystem merged in .38 code using
the first fabric independent inter-module configfs control plane.  With
lots of help of target developers (hch, agrover, hannes), other
subsystem maintainers (roland, greg-kh, james, felipe, stefan), and new
devels (bart, bootc, sebastian) the team has manage to merge seven
fabric drivers, including three new drivers this round for v3.5 code
(usb-gadget, sbp-target, tcm_qla2xxx). 

For the 3.6 -> 3.7 time frame, one of the bigger items still on the TODO
list is how collectively the scsi <-> target subsystems are going to be
able to support "hot" target/initiator mixed-mode operation.  There has
been some discussion on this topic on linux-scsi + target-devel, but
we've not decided on a path forward here yet.. 

Also, another important topic for scsi that will need to eventually be
addressed is the per-lun performance limitations / bottleneck currently
present with v3.x Linux/SCSI clients for random small block IOPs
workloads.  Even after SCSI tree wide host-lock less conversion starting
in .38 code, Linux/SCSI client LUNs (regardless of fabric / LLD) are
still well behind what a raw block client is capable for 1 million IOPs
machine.  The Linux/SCSI client is also behind (on the order of ~25%) of
what certain non Linux client can achieve connected to the same Linux
target using raw block backends in an apples-to-apples comparison.

Finally on the new target fabric driver front, we're currently expecting
the tcm_vhost driver to be a merge candidate in the v3.6 -> v3.6 time
frame. This driver provides high performance backend (pSCSI, IBLOCK,
FILEIO) device access using existing vhost infrastructure for connecting
para-virtualized virtio-scsi guest code directly to the in-kernel target
infrastructure.

This is some really pretty exciting code, and I'll be sending time on
virto-scsi <-> tcm_vhost performance profiling using raw block flash
backends to get a rough idea of where things currently stand..  Also by
the time KS/LC comes around in August, we expect to have the first
shared-storage host virtualized ALUA multipath prototype up and running
on mainline target code..

Thank you!

--nab

