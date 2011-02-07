From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [LSF/MM TOPIC] Target fabric module for SCSI para-virtualization
Date: Sun, 06 Feb 2011 23:57:15 -0800
Message-ID: <1297065435.13752.173.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54555 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab1BGH52 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2011 02:57:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linuxfoundation.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Stefan Hajnoczi <stefanha@gmail.com>, Anthony Liguori <anthony@codemonkey.ws>, Christoph Hellwig <hch@lst.de>

Greetings all,

[Topic]

A hybrid target fabric module for QEMU/KVM SCSI para-virtualization

[Abstract]

Currently we use the TCM_Loop v4 fabric module with mainline .38 target
code to present SCSI LUNs with high level multi-fabric (iSCSI, FC, SAS)
SPC-3 port WWN emulation into KVM guests using two different forms of
QEMU HBA hardware emulation.  However both of these currently require
interaction with the QEMU block layer and extra overhead of OS
independent code running in user-space connected to our existing
SG_IO/BSG interfaces.  This also has the limitiation that we currently
cannot perform explict SCSI Initiator Port access management for LUNs
also present via TCM_Loop SCSI LLD driver on the KVM host.

Recently there has been an off-list discussion between myself and
members of the QEMU/KVM community, and they have expressed an interest
in seeing a native paravirtualized SCSI passthrough available to QEMU
guests with direct interaction into TCM fabric module code running on
KVM host.  This would be using existing CDB level port emulation code in
target_core_fabric_lib.c, and (mostly) generic fabric control plane in
target_core_fabric_configfs.c..  Beyond the TCM fabric module specifics,
this will require:

*) An asynchronous I/O capable virtio interface for KVM that does not
require direct QEMU block-layer interaction

*) A multi-fabric WWN naming capable TCM fabric module using native
virtio-scsi connections to individual KVM guests for kernel-level
passthrough into TCM backend storage.  (eg: similar to TCM_Loop, but w/o
the Linux/SCSI LLD frontend, and full explict Initiator port NodeACL +
MappedLUN control abstraction)

*) Guest OS specific para-virtualized SCSI driver packages (similar to
virtio-blk) performing SCSI I/O handoff into passthrough interface via
SCSI I_T nexues, with proper T10 WWN Port and LUN naming provided from
underlying TCM v4.x infrastructure  (eg: full compat w/ existing SPC-3
capable cluster clients)

--nab



