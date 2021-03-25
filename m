Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87093C433C1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 09:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48E9D61A05
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 09:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhCYJdR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 05:33:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53170 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhCYJdI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2021 05:33:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P9T1QN112263;
        Thu, 25 Mar 2021 09:33:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=GP/0+7iH1OVg4K3NGJGBI0zKn96ce9VqlPr4KNAGDjc=;
 b=WnGxNlG8Dh9iAjR5KkmtRdSDcMs83rtVbK/F/cAoXqb4s4MibVTPAQ9JNFSuIsJH1Iof
 pRtLX3f/xW+218znwCEfPk3RcFOCGQGHsh7npHenCU41sRzsjU3FZztmaRRHoLfkHYGa
 9bfWW116BoqGxQNN7pz9RpHegC4/q51ncr/oRzefieD4OUpPeS7v+38cj2uZmHaPkpxA
 F3WkhNkMTD71yFHVPDbDTas7axMErjoBN6CHSpGBHwY/wf1a33n2uk64KKb0nQb57wmk
 EyKkpYFgk2yQ3GhC/ayb0DxA0z3JXF8CAGnF5lSj33vneivfrnpm/UZQqYo1NLfcwGFa Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37d8frdndt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 09:33:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P9UHZZ121663;
        Thu, 25 Mar 2021 09:33:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 37dttuee5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 09:33:00 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 12P9WwcI022201;
        Thu, 25 Mar 2021 09:32:58 GMT
Received: from gms-ol8-2.osdevelopmeniad.oraclevcn.com (/100.100.234.63)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Mar 2021 02:32:58 -0700
From:   Gulam Mohamed <gulam.mohamed@oracle.com>
To:     michael.christie@oracle.com, lduncan@suse.com, cleech@redhat.com,
        martin.petersen@oracle.com, junxiao.bi@oracle.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH V5] iscsi: Do Not set param when sock is NULL
Date:   Thu, 25 Mar 2021 09:32:48 +0000
Message-Id: <20210325093248.284678-1-gulam.mohamed@oracle.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250072
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250072
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Description
===========
1. This Kernel panic could be due to a timing issue when there is a
   race between the sync thread and the initiator was processing of
   a login response from the target. The session re-open can be invoked
   from two places:
    a. Sessions sync thread when the iscsid restart
    b. From iscsid through iscsi error handler
2. The session reopen sequence is as follows in user-space
        a. Disconnect the connection
        b. Then send the stop connection request to the kernel
           which releases the connection (releases the socket)
        c. Queues the reopen for 2 seconds delay
        d. Once the delay expires, create the TCP connection again by
           calling the connect() call
        e. Poll for the connection
        f. When poll is successful i.e when the TCP connection is
           established, it performs:
               i. Creation of session and connection data structures
              ii. Bind the connection to the session. This is the place
                  where we assign the sock to tcp_sw_conn->sock
             iii. Sets parameters like target name, persistent address
              iv. Creates the login pdu
               v. Sends the login pdu to kernel
              vi. Returns to the main loop to process further events.
                  The kernel then sends the login request over to the
                  target node
        g. Once login response with success is received, it enters full
           feature phase and sets the negotiable parameters like
           max_recv_data_length,max_transmit_length, data_digest etc.
3. While setting the negotiable parameters by calling
   "iscsi_session_set_neg_params()", kernel panicked as sock was NULL

What happened here is
---------------------
1. Before initiator received the login response mentioned in above
   point 2.f.v, another reopen request was sent from the error
   handler/sync session for the same session, as the initiator utils
   was in main loop to process further events (as mentioned in point
   2.f.vi above).
2. While processing this reopen, it stopped the connection which
   released the socket and queued this connection and at this point
   of time the login response was received for the earlier one

Fix
---
1. Add new connection state ISCSI_CONN_BOUND in "enum iscsi_connection
   _state"
2. Set the connection state value to ISCSI_CONN_DOWN upon
   iscsi_if_ep_disconnect() and iscsi_if_stop_conn()
3. Set the connection state to the newly created value ISCSI_CONN_BOUND
   after bind connection (transport->bind_conn())
4. In iscsi_set_param, return -ENOTCONN if the connection state is not
   either ISCSI_CONN_BOUND or ISCSI_CONN_UP

Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
---

Changes in V5:
- Corrected the indentation and included the brackets for the else
  block in iscsi_set_param() function

Changes in V4:
- Included ISCSI_CONN_UP check in the if condition when the function
  iscsi_set_param() checks to see if iscsi parameter can be set or 
  not to make it work for offload drivers also. Earlier version use
  to check only the ISCSI_CONN_BOUND

Changes in V3:
- Changed the approach from creating and checking a flag in
  iscsi_cls_conn structure, to a new connection state ISCSI_CONN_BOUND
  and checking it while setting the iscsi parameters
  
 drivers/scsi/scsi_transport_iscsi.c | 14 +++++++++++++-
 include/scsi/scsi_transport_iscsi.h |  1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 91074fd97f64..f4bf62b007a0 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2475,6 +2475,7 @@ static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
 	 */
 	mutex_lock(&conn_mutex);
 	conn->transport->stop_conn(conn, flag);
+	conn->state = ISCSI_CONN_DOWN;
 	mutex_unlock(&conn_mutex);
 
 }
@@ -2901,6 +2902,13 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 	default:
 		err = transport->set_param(conn, ev->u.set_param.param,
 					   data, ev->u.set_param.len);
+		if ((conn->state == ISCSI_CONN_BOUND) ||
+			(conn->state == ISCSI_CONN_UP)) {
+			err = transport->set_param(conn, ev->u.set_param.param,
+					data, ev->u.set_param.len);
+		} else {
+			return -ENOTCONN;
+		}
 	}
 
 	return err;
@@ -2960,6 +2968,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 		mutex_lock(&conn->ep_mutex);
 		conn->ep = NULL;
 		mutex_unlock(&conn->ep_mutex);
+		conn->state = ISCSI_CONN_DOWN;
 	}
 
 	transport->ep_disconnect(ep);
@@ -3727,6 +3736,8 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 		ev->r.retcode =	transport->bind_conn(session, conn,
 						ev->u.b_conn.transport_eph,
 						ev->u.b_conn.is_leading);
+		if (!ev->r.retcode)
+			conn->state = ISCSI_CONN_BOUND;
 		mutex_unlock(&conn_mutex);
 
 		if (ev->r.retcode || !transport->ep_connect)
@@ -3966,7 +3977,8 @@ iscsi_conn_attr(local_ipaddr, ISCSI_PARAM_LOCAL_IPADDR);
 static const char *const connection_state_names[] = {
 	[ISCSI_CONN_UP] = "up",
 	[ISCSI_CONN_DOWN] = "down",
-	[ISCSI_CONN_FAILED] = "failed"
+	[ISCSI_CONN_FAILED] = "failed",
+	[ISCSI_CONN_BOUND] = "bound"
 };
 
 static ssize_t show_conn_state(struct device *dev,
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 8a26a2ffa952..fc5a39839b4b 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -193,6 +193,7 @@ enum iscsi_connection_state {
 	ISCSI_CONN_UP = 0,
 	ISCSI_CONN_DOWN,
 	ISCSI_CONN_FAILED,
+	ISCSI_CONN_BOUND,
 };
 
 struct iscsi_cls_conn {
-- 
2.27.0

