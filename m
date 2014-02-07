From: michaelc@cs.wisc.edu
Subject: [PATCH 6/6] iscsi_tcp: check for valid session before accessing
Date: Fri,  7 Feb 2014 00:41:42 -0600
Message-ID: <1391755302-57206-7-git-send-email-michaelc@cs.wisc.edu>
References: <1391755302-57206-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40280 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbaBGGl6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Feb 2014 01:41:58 -0500
Received: from localhost.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id s176fqtc015126
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 7 Feb 2014 00:41:57 -0600
In-Reply-To: <1391755302-57206-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

Check that the session is setup before accessing its
connection. This fixes a oops where userspace tries
to get the ip address before the session is bound to
a host.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 12b3512..bfb6d07 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -759,6 +759,9 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 
 	switch (param) {
 	case ISCSI_HOST_PARAM_IPADDRESS:
+		if (!session)
+			return -ENOTCONN;
+
 		spin_lock_bh(&session->frwd_lock);
 		conn = session->leadconn;
 		if (!conn) {
-- 
1.7.1

