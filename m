From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 00/11] T10-PI Initial support for iSER initiator
Date: Sun, 23 Feb 2014 14:19:23 +0200
Message-ID: <1393157974-24931-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:57174 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751237AbaBWMTg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Feb 2014 07:19:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: roland@kernel.org, nab@linux-iscsi.org
Cc: oren@mellanox.com, martin.petersen@oracle.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org

Hey Roland, Nic and Co

This patchset adds T10 protection information offload support over
RDMA signature verbs API. This set, along with the iSER target set,
allow end-to-end protection information passthrough and validation.
The patchset was tested against Linux SCSI target with iSER DIF
support applied.

The enablement of iSER DIF support is currently controlled with
module parameters (similar to lpfc for example) which make them
global. In the next phase we can consider passing these parameters
from iscsid nl messages, which would make them per-connection.

The approach I took with respect to escelating protection information
errors was minimal iSCSI intervention in protection information affairs.
I added libiscsi a hook asking the transport to check the protection
information status, and construct the proper sense data in case of errors
(the alternative of letting the transport to construct sense data seemed
much less appealing).

Note that this patchset comes on top of a pending patch for iSER to suppress
fastreg completions (http://marc.info/?l=linux-rdma&m=139047309831997&w=2).

Roland, I would like to hear your feedback on this.

Nic, You can go ahead and place this set on rdma-dif and start playing
with it (I can also gain some 0-DAY static checks).

The set is ordered by the following:
- Preperation patches (non/minor functionality changes).
- Add protection information execution support.
- Add protection information status check facilities.
- Publish T10-DIF support to SCSI midlayer according to
  IB device capabilities.

Sagi Grimberg (11):
  IB/iser: Avoid FRWR notation, use fastreg instead
  IB/iser: Push the desicion what memory key to use into fast_reg_mr
    routine
  IB/iser: Move fast_reg_descriptor initialization to a function
  IB/iser: Keep IB device attributes under iser_device
  IB/iser: Replace fastreg descriptor valid bool with indicators
    container
  IB/iser: Introduce pi_enable, pi_guard module parameters
  IB/iser: Initialize T10-PI resources
  IB/iser: Support T10-PI operations
  SCSI/libiscsi: Add check_protection callback for transports
  IB/iser: Implement check_protection
  IB/iser: Publish T10-PI support to SCSI midlayer

 drivers/infiniband/ulp/iser/iscsi_iser.c     |   46 ++++-
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   59 ++++-
 drivers/infiniband/ulp/iser/iser_initiator.c |   49 ++++-
 drivers/infiniband/ulp/iser/iser_memory.c    |  348 +++++++++++++++++++++-----
 drivers/infiniband/ulp/iser/iser_verbs.c     |  273 +++++++++++++++------
 drivers/scsi/libiscsi.c                      |   32 +++
 include/scsi/libiscsi.h                      |    4 +
 include/scsi/scsi_transport_iscsi.h          |    1 +
 8 files changed, 666 insertions(+), 146 deletions(-)

