From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: tcm_qla2xxx: Add >= 24xx series fabric module for target-core
Date: Tue, 13 Mar 2012 20:19:48 +0300
Message-ID: <20120313171948.GB31808@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:18661 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758394Ab2CMRT7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Mar 2012 13:19:59 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, linux-driver@qlogic.com

Hello Nicholas,

The patch b3fd3cce29bb: "tcm_qla2xxx: Add >= 24xx series fabric 
module for target-core" from Mar 8, 2012, leads to the following Sparse
warning:

drivers/scsi/qla2xxx/tcm_qla2xxx.c:843:37: warning: right shift by
	bigger than source value

+       domain = (nacl->nport_id >> 16) & 0xff;
                        ^^^^^^^^
nport_id is a u16 so this is always zero.

+       area = (nacl->nport_id >> 8) & 0xff;
+       al_pa = nacl->nport_id & 0xff;

[snip]

+struct tcm_qla2xxx_nacl {
+       /* From libfc struct fc_rport->port_id */
+       u16 nport_id;

fc_rport->port_id is a u32.


regards,
dan carpenter

