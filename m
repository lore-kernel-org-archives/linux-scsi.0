From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [LSF/MM TOPIC] NVMe target support
Date: Wed, 27 Jan 2016 20:41:43 -0800
Message-ID: <1453956103.6746.195.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54432 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967825AbcA1Elp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2016 23:41:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc <lsf-pc@lists.linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, linux-nvme@lists.infradead.org
Cc: Christoph Hellwig <hch@lst.de>, "Minturn, Dave B" <dave.b.minturn@intel.com>, Sagi Grimberg <sagig@mellanox.com>, Ming Lin <mlin@kernel.org>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@kernel.org>, Mike Christie <mchristi@redhat.com>

Hi lsf-pc & Co,

I'd like to propose a NVMe target discussion topic for LSF/MM 2016.

My interest wrt NVMe target drivers is specifically around using shared
infrastructure with existing TCM backend drivers (IBLOCK, FILEIO,
RAMDISK), and how se_device->dev_group configfs symlinks can be
associated with NVMe target driver ports following HCH's WIP code.
Also, there is still a vendor need around some type of NVMe backend
driver (eg: target_core_nvme) for exposing + mapping NVMe-HI queues to
front-end fabric driver RDMA queues.

Beyond the back-end driver discussion, our target_core_fabric_configfs.c
logic for exposing a common user-space ABI has served LIO target drivers
well over the last 10 upstream fabrics, plus other out-of-tree and WIP
drivers.  The design has never once had to break userspace ABI
compatibility, and the only user-visible addition to original design
was allowing network portal attributes to be exposed by fabrics for
iser-target + iscsit_transport friends.

I think one of the more interesting questions is going to be around how
NVMe-over-Fabrics (NVMe_OF) + vhost-nvme will end up using
target_core_fabric_configfs.c code.  What struct config_groups from
target_core_fabric_configfs.c can be common across both SCSI target and
NVMe controller export..?

The folks for such a discussion would include:

   Christoph Hellwig, Hannes Reinecke, Dave Minturn, Sagi Grimberg,
   Ming Lin, Roland Dreier and Mike Christie.

Thank you,

--nab

