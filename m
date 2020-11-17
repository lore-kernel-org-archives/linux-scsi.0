Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9026C2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 05:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E08224686
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 05:09:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="y31QKlvU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgKQFJD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 00:09:03 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55782 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgKQFJC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2020 00:09:02 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH543Qe103066;
        Tue, 17 Nov 2020 05:08:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : sender : to : cc : subject : references :
 in-reply-to : content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=JPFAvW3nwCtBjHj95lKDgrg4Zm+QWmvC+LDlS0/00vw=;
 b=y31QKlvUzrn25sVA1aRn/t40CHbjKiqW7XG0rdE9WcCFwV+gncPj5B5G352Z6k704Gn7
 V7KvIhFWqtZVl+YzyX4O3P8Gz75JSntv2/O78xfVONnHZy+W7dMqhl2gs8MUi+I/93oe
 Ye91eElxDmLGy0HoWEp5h3J9ihZLsXxcqlNhBxVU/W2dyyuxGK9hnF/aae6UIOgU3/nZ
 x2TgnGh8ig7FTIy6nGO1pAa4VHgDu9NYKCcOhPvexzoBzNCUoM8w+hW/EmqJiCJGO2pV
 xCy4I6PnaQqrnUWU7vmJDmI4qTchVRoEz+1j99rS2DdoVxdl7AbUMqsxDcMfKg2FDFKb iA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34t7vn0gqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 05:08:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH51Rcc110521;
        Tue, 17 Nov 2020 05:08:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34ts0qcuhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 05:08:52 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AH58p0I010793;
        Tue, 17 Nov 2020 05:08:51 GMT
MIME-Version: 1.0
Message-ID: <48883f4d-edfa-4a8d-9d45-aa5225f82e57@default>
Date:   Mon, 16 Nov 2020 21:08:45 -0800 (PST)
From:   Gulam Mohamed <gulam.mohamed@oracle.com>
Sender: Gulam Mohamed <gulam.mohamed@oracle.com>
To:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Junxiao Bi <junxiao.bi@oracle.com>
Subject: RE: [PATCH] iscsi: Do Not set param when sock is NULL
References: <1a8aaa17-b1a3-4d6a-b87a-ff49d61a0d0b@default>
 <9df96d73-015c-4de6-96fa-2f315b066909@default>
In-Reply-To: <9df96d73-015c-4de6-96fa-2f315b066909@default>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.9.1  (1003210) [OL
 16.0.5056.0 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170036
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170036
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Gentle reminder.

Regards,
Gulam Mohamed.

-----Original Message-----
From: Gulam Mohamed=20
Sent: Thursday, November 5, 2020 11:11 AM
To: Lee Duncan <lduncan@suse.com>; Chris Leech <cleech@redhat.com>; James E=
.J. Bottomley <jejb@linux.ibm.com>; Martin K. Petersen <martin.petersen@ora=
cle.com>; open-iscsi@googlegroups.com; linux-scsi@vger.kernel.org; linux-ke=
rnel@vger.kernel.org
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Subject: [PATCH] iscsi: Do Not set param when sock is NULL

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
x_transmit_length, data_digest etc . 3. While setting the negotiable parame=
ters by calling "iscsi_session_set_neg_params()", kernel panicked as sock w=
as NULL

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
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c index df47=
557a02a3..fd668a194053 100644
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
--
2.18.4
