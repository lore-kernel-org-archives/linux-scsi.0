Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C28BC388F9
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 05:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0A322151B
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 05:41:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nnJBTOrX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730833AbgKEFlH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Nov 2020 00:41:07 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41144 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbgKEFlH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2020 00:41:07 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A55SvfB162524;
        Thu, 5 Nov 2020 05:40:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : sender : to : cc : subject : references :
 in-reply-to : content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=K8Kl2iHpO5POu3iueaA7vs9t7V/Id+v7k4XyYIiSXvY=;
 b=nnJBTOrXuQKPplubPvStO8yPl1tsO8Li6N9yt3qDJ8zPUJGA0mYNt4vWS2mmjmROIjBS
 SeTWpM5ri54wsfhRvVWbYke/zpqomFrjqED7YgoQnqpbidhQ+cj2h8q8ceRNCcBnKXTf
 Tv8QvOtX/pI6JAvbY+tLDmUwZJ+9V25Hwz9YmslWWhxVqESgM7FVF32dsDUeIZY+E1gY
 LM/F79CZ//WDO1miwPv9JyHvurZL8+jdqf3elfvCrsmqwRK7jYRWaNyZq3pK+qzqT1xA
 qqIQMKtSsOxJRGyy/bzdRyS14Yq2fSiW+JNZHImHRHLTKcgNfSpAdQlCRSORvaR59eL3 8w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34hhw2t3kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 05 Nov 2020 05:40:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A55UYKg008905;
        Thu, 5 Nov 2020 05:40:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34hw0m4e8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Nov 2020 05:40:57 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A55euWr018275;
        Thu, 5 Nov 2020 05:40:56 GMT
MIME-Version: 1.0
Message-ID: <9df96d73-015c-4de6-96fa-2f315b066909@default>
Date:   Wed, 4 Nov 2020 21:40:54 -0800 (PST)
From:   Gulam Mohamed <gulam.mohamed@oracle.com>
Sender: Gulam Mohamed <gulam.mohamed@oracle.com>
To:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Junxiao Bi <junxiao.bi@oracle.com>
Subject: [PATCH] iscsi: Do Not set param when sock is NULL
References: <1a8aaa17-b1a3-4d6a-b87a-ff49d61a0d0b@default>
In-Reply-To: <1a8aaa17-b1a3-4d6a-b87a-ff49d61a0d0b@default>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.9.1  (1003210) [OL
 16.0.5056.0 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 clxscore=1011 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050041
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Description
=3D=3D=3D=3D=3D=3D=3D=3D=3D
1. This Kernel panic could be due to a timing issue when there is a race be=
tween the sync thread and the initiator was processing of a login response =
from the target. The session re-open can be invoked from two places
          a.=09Sessions sync thread when the iscsid restart
          b.=09From iscsid through iscsi error handler
2. The session reopen sequence is as follows in user-space (iscsi-initiator=
-utils)
          a.=09Disconnect the connection
          b.=09Then send the stop connection request to the kernel which re=
leases the connection (releases the socket)
          c.=09Queues the reopen for 2 seconds delay
         d.=09Once the delay expires, create the TCP connection again by ca=
lling the connect() call
         e.=09Poll for the connection
          f.=09When poll is successful i.e when the TCP connection is estab=
lished, it performs
=09i. Creation of session and connection data structures
=09ii. Bind the connection to the session. This is the place where we assig=
n the sock to tcp_sw_conn->sock
=09iii. Sets the parameters like target name, persistent address etc .
=09iv. Creates the login pdu
=09v. Sends the login pdu to kernel
=09vi. Returns to the main loop to process further events. The kernel then =
sends the login request over to the target node
=09g. Once login response with success is received, it enters into full fea=
ture phase and sets the negotiable parameters like max_recv_data_length, ma=
x_transmit_length, data_digest etc .
3. While setting the negotiable parameters by calling "iscsi_session_set_ne=
g_params()", kernel panicked as sock was NULL

What happened here is
--------------------------------
1.=09Before initiator received the login response mentioned in above point =
2.f.v, another reopen request was sent from the error handler/sync session =
for the same session, as the initiator utils was in main loop to process fu=
rther events (as=20
=09mentioned in point 2.f.vi above).=20
2.=09While processing this reopen, it stopped the connection which released=
 the socket and queued this connection and at this point of time the login =
response was received for the earlier one
3.=09The kernel passed over this response to user-space which then sent the=
 set_neg_params request to kernel
4.=09As the connection was stopped, the sock was NULL and hence while the k=
ernel was processing the set param request from user-space, it panicked

Fix
----
1.=09While setting the set_param in kernel, we need to check if sock is NUL=
L
2.=09If the sock is NULL, then return EPERM (operation not permitted)
3.=09Due to this error handler will be invoked in user-space again to recov=
er the session

Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
---
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index df47557a02a3..fd668a194053 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -711,6 +711,12 @@ static int iscsi_sw_tcp_conn_set_param(struct iscsi_cl=
s_conn *cls_conn,
        struct iscsi_tcp_conn *tcp_conn =3D conn->dd_data;
        struct iscsi_sw_tcp_conn *tcp_sw_conn =3D tcp_conn->dd_data;

+       if (!tcp_sw_conn->sock) {
+               iscsi_conn_printk(KERN_ERR, conn,
+                               "Cannot set param as sock is NULL\n");
+               return -ENOTCONN;
+       }
+
        switch(param) {
        case ISCSI_PARAM_HDRDGST_EN:
                iscsi_set_param(cls_conn, param, buf, buflen);
--=20
2.18.4
