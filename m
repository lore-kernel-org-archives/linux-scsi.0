From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 0/2] ISCSID: Added vlan field to the iface struct
Date: Thu, 10 Mar 2011 18:21:11 -0800
Message-ID: <1299810073-7339-1-git-send-email-eddie.wai@broadcom.com>
References: <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3453 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab1CKCVa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2011 21:21:30 -0500
In-Reply-To: <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Hello,

This patch adds the iface.vlan field to the iface struct so that it
can be defined in the iface file.  This vlan field will then propagate
to both brcm_iscsiuio for nic_iface creation and bnx2i via the
iscsi_host_set_net_param path for ep_connect usage.

Another way is to do without the iscsi_host_set_net_param augmentation
and just keep track of it in brcm_iscsiuio.  So when the path req comes
through, brcm_iscsiuio will not need to search and just key off of the
current nic_iface.  But this approach might present a danger if we ever
goto separate out the threads in iscsid; hence losing synchronization.

For this, bnx2i will also need to be changed to accept set_host_param
callback for proper handling of the vlan message.

Please let me know what you think.  Thanks.

Eddie


Eddie Wai (2):
  ISCSID: Added vlan field to the iface struct
  ISCSID: Added ISCSI_HOST_PARAM_VLAN setting

 include/iscsi_if.h     |    1 +
 usr/config.h           |    4 ++++
 usr/iface.c            |   19 +++++++++++++++++--
 usr/iface.h            |    1 +
 usr/initiator_common.c |   10 ++++++++++
 usr/iscsi_settings.h   |    1 +
 6 files changed, 34 insertions(+), 2 deletions(-)


