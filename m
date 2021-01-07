Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C99AEC433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 15:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86D2123435
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 15:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbhAGPs7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 10:48:59 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40080 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbhAGPs7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 10:48:59 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107FdsMl049661;
        Thu, 7 Jan 2021 15:48:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : sender : to : cc : subject : references :
 in-reply-to : content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HEo/4+hyn0YdKS47Mma7PweDhqDTetKtGjZMclPyJlA=;
 b=WsNcydjIkkTEdC5F5oJdJyvybRtXGs5cpQU0XE8B77aY6O5Sf39BEJbqN7mF9hPeDu4L
 6kuIbZZ/XNtX8Lg0b2eTDsjrRmGeo1i/oaZfprUUBe0S/cNNMkJtFFN1Jpq8Vf0ZILEL
 Bk/fLnBKyxq2XP0DZObWlz5FqH659JEAtL1VooCOuOxcDqmuZQXQxEdfvpDzkrSTbiMW
 ZGJGR/ctsg1eckWzGNXLSS9hY52XqCcbqwfXR3W5SMBkKVTI9yNZx2SKa5eFUthnOzek
 zDxiyw70/JdJO3w1bvaGsLVOmPD0bP2cKhpe1cXlJVDE979Aq4RuZSysxDsfGzdlQWrE ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35wepmcxk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 07 Jan 2021 15:48:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107FVjkM115576;
        Thu, 7 Jan 2021 15:48:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 35w3g2w6sb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jan 2021 15:48:07 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 107Fm52W012821;
        Thu, 7 Jan 2021 15:48:06 GMT
MIME-Version: 1.0
Message-ID: <0abfcf5b-5ab8-4968-bf6d-eb4dee32e2f4@default>
Date:   Thu, 7 Jan 2021 15:48:02 +0000 (UTC)
From:   Gulam Mohamed <gulam.mohamed@oracle.com>
Sender: Gulam Mohamed <gulam.mohamed@oracle.com>
To:     Michael Christie <michael.christie@oracle.com>
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junxiao Bi <junxiao.bi@oracle.com>
Subject: RE: [PATCH] iscsi: Do Not set param when sock is NULL
References: <1a8aaa17-b1a3-4d6a-b87a-ff49d61a0d0b@default>
 <9df96d73-015c-4de6-96fa-2f315b066909@default>
 <05277786-2E1F-432D-AE73-F39565C6BEA4@oracle.com>
In-Reply-To: <05277786-2E1F-432D-AE73-F39565C6BEA4@oracle.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.9.1  (1003210) [OL
 16.0.5095.0 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070097
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Michael,

             As per your suggestions in below mail, I have completed the su=
ggested changes and tested them. Can you please review and let me know your=
 comments? Here is the patch:

Description
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
1. This Kernel panic could be due to a timing issue when there is a race be=
tween the sync thread and the initiator was processing of a login response =
from the target. The session re-open can be invoked from two places
  a. Sessions sync thread when the iscsid restart
  b. From iscsid through iscsi error handler 2. The session reopen sequence=
 is as follows in user-space (iscsi-initiator-utils)
   a. Disconnect the connection
   b. Then send the stop connection request to the kernel which releases th=
e connection (releases the socket)
   c. Queues the reopen for 2 seconds delay
   d. Once the delay expires, create the TCP connection again by calling th=
e connect() call
   e. Poll for the connection
   f. When poll is successful i.e when the TCP connection is established, i=
t performs
      i. Creation of session and connection data structures
      ii. Bind the connection to the session. This is the place where we as=
sign the sock to tcp_sw_conn->sock
      iii. Sets the parameters like target name, persistent address etc .
      iv. Creates the login pdu
       v. Sends the login pdu to kernel
      vi. Returns to the main loop to process further events. The kernel th=
en sends the login request over to the target node
   g. Once login response with success is received, it enters into full fea=
ture phase and sets the negotiable parameters like max_recv_data_length, ma=
x_transmit_length, data_digest etc .
3. While setting the negotiable parameters by calling "iscsi_session_set_ne=
g_params()", kernel panicked as sock was NULL

What happened here is
---------------------
1. Before initiator received the login response mentioned in above point 2.=
f.v, another reopen request was sent from the error handler/sync session fo=
r the same session, as the initiator utils was in main loop to process furt=
her events (as mentioned in point 2.f.vi above).
2. While processing this reopen, it stopped the connection which released t=
he socket and queued this connection and at this point of time the login re=
sponse was received for the earlier on

Fix
---

1. Create a flag "set_param_fail" in iscsi_cls_conn structure 2. On ep_disc=
onnect and stop_conn set this flag to indicate set_param calls for connecti=
on level settings should fail 3. This way, scsi_transport_iscsi can set and=
 check this bit for all drivers 2. On bind_conn clear the bit

Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 6 ++++++  include/scsi/scsi_transpor=
t_iscsi.h | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transp=
ort_iscsi.c
index 2e68c0a87698..15c5a7223a40 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2473,6 +2473,8 @@ static void iscsi_if_stop_conn(struct iscsi_cls_conn =
*conn, int flag)
 =09 * it works.
 =09 */
 =09mutex_lock(&conn_mutex);
+=09if (!test_bit(ISCSI_SET_PARAM_FAIL_BIT, &conn->set_param_fail))
+=09=09set_bit(ISCSI_SET_PARAM_FAIL_BIT, &conn->set_param_fail);
 =09conn->transport->stop_conn(conn, flag);
 =09mutex_unlock(&conn_mutex);
=20
@@ -2895,6 +2897,8 @@ iscsi_set_param(struct iscsi_transport *transport, st=
ruct iscsi_uevent *ev)
 =09=09=09session->recovery_tmo =3D value;
 =09=09break;
 =09default:
+=09=09if (test_bit(ISCSI_SET_PARAM_FAIL_BIT, &conn->set_param_fail))
+=09=09=09return -ENOTCONN;
 =09=09err =3D transport->set_param(conn, ev->u.set_param.param,
 =09=09=09=09=09   data, ev->u.set_param.len);
 =09}
@@ -2956,6 +2960,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transp=
ort *transport,
 =09=09mutex_lock(&conn->ep_mutex);
 =09=09conn->ep =3D NULL;
 =09=09mutex_unlock(&conn->ep_mutex);
+=09=09set_bit(ISCSI_SET_PARAM_FAIL_BIT, &conn->set_param_fail);
 =09}
=20
 =09transport->ep_disconnect(ep);
@@ -3716,6 +3721,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghd=
r *nlh, uint32_t *group)
 =09=09ev->r.retcode =3D=09transport->bind_conn(session, conn,
 =09=09=09=09=09=09ev->u.b_conn.transport_eph,
 =09=09=09=09=09=09ev->u.b_conn.is_leading);
+=09=09clear_bit(ISCSI_SET_PARAM_FAIL_BIT, &conn->set_param_fail);
 =09=09mutex_unlock(&conn_mutex);
=20
 =09=09if (ev->r.retcode || !transport->ep_connect) diff --git a/include/sc=
si/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 8a26a2ffa952..71b1952b913b 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -29,6 +29,8 @@ struct bsg_job;
 struct iscsi_bus_flash_session;
 struct iscsi_bus_flash_conn;
=20
+#define ISCSI_SET_PARAM_FAIL_BIT=091
+
 /**
  * struct iscsi_transport - iSCSI Transport template
  *
@@ -206,6 +208,7 @@ struct iscsi_cls_conn {
=20
 =09struct device dev;=09=09/* sysfs transport/container device */
 =09enum iscsi_connection_state state;
+=09unsigned long set_param_fail; /* set_param for connection should fail=
=20
+*/
 };
=20
 #define iscsi_dev_to_conn(_dev) \
--
2.27.0

Regards,
Gulam Mohamed.

-----Original Message-----
From: Michael Christie=20
Sent: Tuesday, November 24, 2020 4:37 AM
To: Gulam Mohamed <gulam.mohamed@oracle.com>
Cc: Lee Duncan <lduncan@suse.com>; Chris Leech <cleech@redhat.com>; James E=
.J. Bottomley <jejb@linux.ibm.com>; Martin K. Petersen <martin.petersen@ora=
cle.com>; open-iscsi@googlegroups.com; linux-scsi@vger.kernel.org; linux-ke=
rnel@vger.kernel.org; Junxiao Bi <junxiao.bi@oracle.com>
Subject: Re: [PATCH] iscsi: Do Not set param when sock is NULL



> On Nov 4, 2020, at 11:40 PM, Gulam Mohamed <gulam.mohamed@oracle.com> wro=
te:
>=20
> Description
> =3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1. This Kernel panic could be due to a timing issue when there is a race =
between the sync thread and the initiator was processing of a login respons=
e from the target. The session re-open can be invoked from two places
>          a.=09Sessions sync thread when the iscsid restart
>          b.=09From iscsid through iscsi error handler
> 2. The session reopen sequence is as follows in user-space (iscsi-initiat=
or-utils)
>          a.=09Disconnect the connection
>          b.=09Then send the stop connection request to the kernel which r=
eleases the connection (releases the socket)
>          c.=09Queues the reopen for 2 seconds delay
>         d.=09Once the delay expires, create the TCP connection again by c=
alling the connect() call
>         e.=09Poll for the connection
>          f.=09When poll is successful i.e when the TCP connection is esta=
blished, it performs
> =09i. Creation of session and connection data structures
> =09ii. Bind the connection to the session. This is the place where we ass=
ign the sock to tcp_sw_conn->sock
> =09iii. Sets the parameters like target name, persistent address etc .
> =09iv. Creates the login pdu
> =09v. Sends the login pdu to kernel
> =09vi. Returns to the main loop to process further events. The kernel the=
n sends the login request over to the target node
> =09g. Once login response with success is received, it enters into full f=
eature phase and sets the negotiable parameters like max_recv_data_length, =
max_transmit_length, data_digest etc .
> 3. While setting the negotiable parameters by calling=20
> "iscsi_session_set_neg_params()", kernel panicked as sock was NULL
>=20
> What happened here is
> --------------------------------
> 1.=09Before initiator received the login response mentioned in above poin=
t 2.f.v, another reopen request was sent from the error handler/sync sessio=
n for the same session, as the initiator utils was in main loop to process =
further events (as=20
> =09mentioned in point 2.f.vi above).=20
> 2.=09While processing this reopen, it stopped the connection which releas=
ed the socket and queued this connection and at this point of time the logi=
n response was received for the earlier one


To make sure I got this you are saying before iscsi_sw_tcp_conn_stop calls =
iscsi_sw_tcp_release_conn that the recv path has called iscsi_recv_pdu righ=
t?


> 3.=09The kernel passed over this response to user-space which then sent t=
he set_neg_params request to kernel
> 4.=09As the connection was stopped, the sock was NULL and hence while the=
 kernel was processing the set param request from user-space, it panicked
>=20
> Fix
> ----
> 1.=09While setting the set_param in kernel, we need to check if sock is N=
ULL
> 2.=09If the sock is NULL, then return EPERM (operation not permitted)
> 3.=09Due to this error handler will be invoked in user-space again to rec=
over the session
>=20
> Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
> Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c index=20
> df47557a02a3..fd668a194053 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -711,6 +711,12 @@ static int iscsi_sw_tcp_conn_set_param(struct iscsi_=
cls_conn *cls_conn,
>        struct iscsi_tcp_conn *tcp_conn =3D conn->dd_data;
>        struct iscsi_sw_tcp_conn *tcp_sw_conn =3D tcp_conn->dd_data;
>=20
> +       if (!tcp_sw_conn->sock) {
> +               iscsi_conn_printk(KERN_ERR, conn,
> +                               "Cannot set param as sock is NULL\n");
> +               return -ENOTCONN;
> +       }
> +

I think this might have 2 issues:

1. It only fixes iscsi_tcp. What about other drivers that free/null resourc=
es/fields in ep_disconnect that we layer need to access in the set_param ca=
llback (the cxgbi drivers)?

2. What about drivers that do not free/null fields (be2iscsi, bnx2i, ql4xxx=
 and qedi) so the set_param calls end up just working. What state will user=
space be in where we have logged in, but iscsid also thinks we are in the m=
iddle of trying to login?

I think we could do:

1. On ep_disconnect and stop_conn set some iscsi_cls_conn bit that indicate=
s set_param calls for connection level settings should fail. scsi_transport=
_iscsi could set and check this bit for all drivers.
2. On bind_conn clear the bit.
