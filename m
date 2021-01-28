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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDE3C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 06:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4317464DC4
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 06:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhA1GTC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:19:02 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44778 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhA1GSy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 01:18:54 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S69w9T186542;
        Thu, 28 Jan 2021 06:18:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=Mc1i/ax003g0FQu6rF7SmKlMPG5/9JB5Naj8R1YOrDU=;
 b=agt2Ex4yJq199Yod+Wx3LaK+csonW1tSTtsZDmihuG/RvhnbeTRt1mARS6mhVrvI6W7R
 D0AXux0HRBjzVnT9DWOViYm5Ca0r0SAw5rHo7jtQgFcdETGA3Alxf+v0vpRE+293Ij21
 WiI8Rc6FhwziejJPid2Ec6s47PsoXaUv/7zghMQvSie5B6D1EcPM9WHwcU/c7HO6TFA0
 RL9tDJRW/k1aYojhUvFPXKaWaop+pxbGvifuyvCLeWiM6yQWmJa2pStrOeAO3FxXTAA1
 aY8D52nNPZZcV6GyVi0XrMFU9/pjqfQV/KUGM77WAuZKYKVrM7yrn4s6JwO4e41GAxFe hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 3689aatq8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 06:18:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S6AccL195667;
        Thu, 28 Jan 2021 06:18:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 368wq177cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 06:18:05 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10S6I28X022449;
        Thu, 28 Jan 2021 06:18:03 GMT
Received: from gms-ol8-2.osdevelopmeniad.oraclevcn.com (/100.100.234.63)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 Jan 2021 22:18:02 -0800
From:   Gulam Mohamed <gulam.mohamed@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH V3] iscsi: Do Not set param when sock is NULL
Date:   Thu, 28 Jan 2021 06:17:53 +0000
Message-Id: <20210128061753.1206620-1-gulam.mohamed@oracle.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280031
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280031
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Description
===========
1. This Kernel panic could be due to a timing issue when there is a race
   between the sync thread and the initiator was processing of a login r
   esponse from the target. The session re-open can be invoked from two
   places
     a. Sessions sync thread when the iscsid restart b. From iscsid thro
        ugh iscsi error handler 2. The session reopen sequence is as fol
        lows in user-space (iscsi-initiator-utils) a. Disconnect the con
        nection b. Then send the stop connection request to the kernel w
        hich releases the connection (releases the socket) c. Queues the
        reopen for 2 seconds delay d. Once the delay expires, create the
        TCP connection again by calling the connect() call e. Poll for t
        he connection f. When poll is successful i.e when the TCP connec
        tion is established, it performs i. Creation of session and conn
        ection data structures ii. Bind the connection to the session. T
        his is the place where we assign the sock to tcp_sw_conn->sock i
     ii. Sets the parameters like target name, persistent address etc. i
     v. Creates the login pdu v. Sends the login pdu to kernel vi. Retur
        ns to the main loop to process further events. The kernel then s
        ends the login request over to the target node g. Once login res
        ponse with success is received, it enters into full feature phas
        e and sets the negotiable parameters like max_recv_data_length,m
        ax_transmit_length, data_digest etc. 3. While setting the negoti
        a ble parameters by calling "iscsi_session_set_neg_params()", ke
        rn el panicked as sock was NULL

What happened here is
---------------------
1. Before initiator received the login response mentioned in above point
    2.f.v, another reopen request was sent from the error handler/sync s
    ession for the same session, as the initiator utils was in main loop
    to process further events (as mentioned in point 2.f.vi above). 2. W
    hile processing this reopen, it stopped the connection which release
    d the socket and queued this connection and at this point of time th
    e login response was received for the earlier on

Fix
---
1. Add a new connection state ISCSI_CONN_BOUND in "enum iscsi_connection
   _state" 2. Set the connection state value to ISCSI_CONN_DOWN upon isc
   si_if_ep_disconnect() and iscsi_if_stop_conn() 3. Set the connection 
   state to the newly created value ISCSI_CONN_BOUND after bind connecti
   on (transport->bind_conn()) 4. In iscsi_set_param, return -ENOTCONN i
   f the connection state is not ISCSI_CONN_BOUND

Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 9 ++++++++-
 include/scsi/scsi_transport_iscsi.h | 1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2e68c0a87698..555fdcf5a3ae 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2474,6 +2474,7 @@ static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
 	 */
 	mutex_lock(&conn_mutex);
 	conn->transport->stop_conn(conn, flag);
+	conn->state = ISCSI_CONN_DOWN;
 	mutex_unlock(&conn_mutex);
 
 }
@@ -2895,6 +2896,8 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 			session->recovery_tmo = value;
 		break;
 	default:
+		if (conn->state != ISCSI_CONN_BOUND)
+			return -ENOTCONN;
 		err = transport->set_param(conn, ev->u.set_param.param,
 					   data, ev->u.set_param.len);
 	}
@@ -2956,6 +2959,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 		mutex_lock(&conn->ep_mutex);
 		conn->ep = NULL;
 		mutex_unlock(&conn->ep_mutex);
+		conn->state = ISCSI_CONN_DOWN;
 	}
 
 	transport->ep_disconnect(ep);
@@ -3716,6 +3720,8 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 		ev->r.retcode =	transport->bind_conn(session, conn,
 						ev->u.b_conn.transport_eph,
 						ev->u.b_conn.is_leading);
+		if (!ev->r.retcode)
+			conn->state = ISCSI_CONN_BOUND;
 		mutex_unlock(&conn_mutex);
 
 		if (ev->r.retcode || !transport->ep_connect)
@@ -3947,7 +3953,8 @@ iscsi_conn_attr(local_ipaddr, ISCSI_PARAM_LOCAL_IPADDR);
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

