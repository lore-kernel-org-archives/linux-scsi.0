From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC]: Mainline of TCM Core and TCM_Loop for v2.6.35
Date: Wed, 19 May 2010 18:09:52 -0700
Message-ID: <1274317792.30733.59.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:26525 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752967Ab0ETBKL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 May 2010 21:10:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Douglas
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Greetings James and Co,

I would like to formally request the inclusion of TCM Core v4 codebase
containing the fabric independent configfs infrastructure design and
TCM_Loop SCSI LLD fabric module supporting multi-fabric I_T Nexus and
Port emulation for SAS, FC and iSCSI into mainline for v2.6.35

The plan is to push TCM Core and the TCM_Loop LLD module for use with
existing userspace applications into mainline first, and then focus on
extending the upstream fabric libraries (libiscsi, libfc, libsas) for
new and future TCM modules to support a common set of kernel-level
target mode infrastructure for HW and SW fabric engines once the main
target pieces are in place.

On the userspace fabric <-> kernel backstore side, the TCM_Loop fabric
module is currently running with full SPC-3 PR and ALUA support using
fabric-independent virtual SCSI target port emulation with the STGT
iSCSI userspace fabric code and SG_IO backstores.  TCM_Loop is also
being used with SG_IO for QEMU-KVM megasas HBA emulation into Linux and
MSFT x86 guests and is able to run at sustained 10 Gb/sec throughput
into KVM guest.

For the kernelspace fabric <-> userspace backstore side for v2.6.35, the
plan is to extend the existing drivers/scsi/scsi_tgt_[lib,if].c direct
mapped ring interface to the WIP kernel level TCM/STGT subsystem
backstore plugin mentioned in previously on linux-scsi.  This will allow
projects presenting a userspace block device to access existing TCM
kernel level target module fabric drivers.

For the LIO-Target iSCSI fabric module, I would like to move in the
direction of extending libiscsi to support kernel-level software iSCSI
target logic.  We will be supporting an out of tree build package for
LIO-Target on top of mainline v2.6.35, until such time libiscsi can be
extended and the LIO-Target fabric module merged into mainline.  For the
TCM_FC + Open-FCoE.org module, extending the libfc module to support
explict FC lport configuration for both HW and SW FCoE target mode is
what I would like to see implemented.

Note that we do intended to support existing target mode HBAs as
seperate TCM fabric modules that use self-contained and vendir/driver
specific target infrastructure, and convert these over to use yet-to-be
determined target mode capaible libsas, libfc and libiscsi as interest
dictates.  Supporting these HBAs will also include a set patches to
support target port config-time allocation of scatterlist memory for use
with existing TCM v4.0 struct scatterlist -> se_mem_t zero-copy memory
mapping logic.  I will also be including existing standalone vendor
target mode driver code into branches on lio-core-2.6.git, and
maintaining these drivers and intending to get these merged as well in
the post v2.6.35 timeframe.

In the mean time, I will prepare a mainline branch containg TCM Core and
TCM_Loop and would be happy to re-post the v4 code in it's entirety for
review, but AFAIK all of the important v4 patches have already been
posted (with minimal feedback) to linux-scsi and the configfs related to
linux-fsdevel.

As always, I am open to constructive suggestions,

Best,

--nab

