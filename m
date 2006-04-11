From: Or Gerlitz <ogerlitz@voltaire.com>
Subject: [RFC] iSER (iSCSI Extensions for RDMA)
Date: Tue, 11 Apr 2006 16:45:59 +0300 (IDT)
Message-ID: <Pine.LNX.4.44.0604111644140.18200-100000@zuben>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from taurus.voltaire.com ([193.47.165.240]:46246 "EHLO
	taurus.voltaire.com") by vger.kernel.org with ESMTP
	id S1750914AbWDKNqA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Apr 2006 09:46:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The patch series that follows is sent to the linux-scsi community asking
for comments on the iSER (iSCSI Extensions for RDMA) code, toward upstream
submission for 2.6.18 .

This driver is an iSER transport implementation for the Open iSCSI initiator
which is merged in the kernel as of 2.6.15.

Hence iSER (as iscsi_tcp) is both a provider of the Linux iSCSI transport api 
and a SCSI LLD (Low Level Driver) of the Linux SCSI midlayer api. 

iSER is dependent on three new changesets/functionalities which are expected 
in 2.6.18, two in iscsi and one in infiniband.

+1 libiscsi - a kernel library (module) implementing lots of common code to
   iscsi_tcp and iscs_iser

+2 iscsi transport ep callbacks - the first patch in this RFC, which enables
   an iscsi transport to establish/disconnect its connection from the kernel

+3 the rdma cm (CMA) - a module that implements RDMA transport neutral Address
   Translation and Communication Management (CM). iSER as most of the inwork 
   IB RC ULPs (eg SDP, NFSoRDMA, Lustre, etc) are coded to the CMA api.

To compile the code you would need to patch 2.6.17-rc1 with the 5 iscsi patches
sent by Mike Christie this week to linux-scsi and the sixth iscsi patch embedded 
in this RFC. Also you would need to replace include/rdma with this dir copy in
the rdma_cm branch of Roland Dreier's git tree (*)

I will ask Roland and James to exchange the iscsi and rdma changes st both 
changesets will appear on both the scsi-misc and infiniband git trees at the 
for-2.6.18 branch.

The code has been tested with 2.6.17-rc1 patched with the six iscsi patches
and having include/rdma and drivers/infiniband replaced by the latest copy
of the openib svn (*). The open iscsi user space code was based on the latest trunk
with 3 patches which are now approved and wait to be merged by the maintainers.
On the target side, we are testing with Voltaire's iSER target.

Or Gerlitz.

(*)  openib svn is accessible at https://openib.org/svn/ where

     include/rdma <--> https://openib.org/svn/gen2/trunk/src/linux-kernel/infiniband/include/rdma
     drivers/infiniband <--> https://openib.org/svn/gen2/trunk/src/linux-kernel/infiniband/

(**) open iscsi svn is accessible at svn://svn.berlios.de/open-iscsi


