From: "Kleber S. Souza" <klebers@linux.vnet.ibm.com>
Subject: [PATCH] ipr: fix debug macro call in ipr_reset_restore_cfg_space()
Date: Mon, 20 Apr 2009 16:23:53 -0300
Message-ID: <1240255436.7458.145.camel@zeppelin.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:53813 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168AbZDTTYg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2009 15:24:36 -0400
Received: from mailhub1.br.ibm.com (mailhub1.br.ibm.com [9.18.232.109])
	by e24smtp05.br.ibm.com (8.13.1/8.13.1) with ESMTP id n3KJJqjv022704
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 16:19:52 -0300
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.18.232.47])
	by mailhub1.br.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3KJOr8N1335638
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 16:24:54 -0300
Received: from d24av02.br.ibm.com (loopback [127.0.0.1])
	by d24av02.br.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3KJOX4d027542
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 16:24:33 -0300
Received: from [9.18.200.203] ([9.18.200.203])
	by d24av02.br.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id n3KJOWTH027529
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 16:24:32 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The key functions of the ipr driver call two macros defined in 'ipr.h',
'ENTER' and 'LEAVE', upon entering and leaving the functions, in order
to print debug messages when the driver is loaded with the option
'debug=1'. Before returning, ipr_reset_restore_cfg_space() calls 'ENTER'
where it should call 'LEAVE'. This patch calls the right macro before
returning from the function.



Signed-off-by: Kleber S. Souza <klebers@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index c09d775..23f4af2 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6522,7 +6522,7 @@ static int ipr_reset_restore_cfg_space(struct
ipr_cmnd *ipr_cmd)
                }
        }

-       ENTER;
+       LEAVE;
        return IPR_RC_JOB_CONTINUE;
 }

--


-- 
Kleber S. Souza
IBM Linux Technology Center

