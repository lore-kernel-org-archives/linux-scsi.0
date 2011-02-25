From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 0/5]: Proposal for iSCSI Network Configuration
Date: Fri, 25 Feb 2011 03:05:17 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8722624A352@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:35521
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932442Ab1BYLFc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 06:05:32 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>, Manish Rangankar <manish.rangankar@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

These are set of patches for  configuring network setting for iSCSI adapter (qla4xxx) that use private IP address.
Please review  proposal/implementation and let us know  the feedback.

iscsiadm part of proposal is submitted at open-iscsi group.
http://groups.google.com/group/open-iscsi/browse_thread/thread/2924e8d871233436

1. Current status:
Using iscsiadm one cannot do any network configuration for qla4xxx adapters.
However an iface is created for the qla4xxx ports using the hwaddress.

\# ls /etc/iscsi/ifaces/
iface.example  iface0  qla4xxx.00:0e:1e:04:8b:2a  qla4xxx.00:0e:1e:04:8b:2e. This allows user to issue sendtargets via the qla4xxx iscsi offload.

2. Current Proposal:
Current proposal is to allow iscsiadm to configure the network settings for qla4xxx ports.

This implementation is based on discussions at
http://marc.info/?l=linux-scsi&m=127066184916180&w=2
http://groups.google.com/group/open-iscsi/browse_thread/thread/d8e8c2df71c95d69/8f731d95d46141a0?lnk=gst&q=iscsi+hba#

Lalit Chandivade (2):
      [RFC] iscsi_transport: add set_net_config
      [RFC] qla4xxx: add support for set_net_config

Vikas Chaudhary (3):
      qla4xxx: Added new "struct ipaddress_config"
      [RFC] iscsi_transport: show network configuration in sysfs
      [RFC] qla4xxx: added support to show multiple iface in sysfs

drivers/scsi/qla4xxx/ql4_def.h      |   50 +++--
drivers/scsi/qla4xxx/ql4_fw.h       |  102 +++++++++
drivers/scsi/qla4xxx/ql4_glbl.h     |   13 +-
drivers/scsi/qla4xxx/ql4_init.c      |   51 +++--
drivers/scsi/qla4xxx/ql4_mbx.c    |  188 +++++++++++++---
drivers/scsi/qla4xxx/ql4_os.c        |  422 ++++++++++++++++++++++++++++++++++-
drivers/scsi/scsi_transport_iscsi.c |  246 ++++++++++++++++++++-
include/scsi/iscsi_if.h             |   53 +++++
include/scsi/scsi_transport_iscsi.h |   25 ++
9 files changed, 1073 insertions(+), 77 deletions(-)


Thanks,
Vikas.


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

