Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6335C6379F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 23:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FBEF208DB
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 23:08:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jLoLuYGo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732855AbgKWXHz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 18:07:55 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52770 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388349AbgKWXHc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 18:07:32 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ANMsX12113282;
        Mon, 23 Nov 2020 23:07:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=K1DhUzzU97l1ZYnVyDXejVMftTY19HzCvuzkVYTz7Co=;
 b=jLoLuYGoQeMBwNNeudTLvENPLFjZX4LmmEiA+dIQ2RXGU30zFRfeBrQYXEnO3BnQrWh5
 JVq4YblQP7ELJfBx7Jac087pgmduut9MfaODb6rm7BJv0yIBTRPRbf6f6l781knwH3my
 XNWSmckz4RexxfOeehqUzTX4TDR2F8418LbcLlx7o+aiUcmOUWQONUq2EeqzHFwnpxpB
 ChFTI3CjgBUpdZJE/8rFGqFfgZAsmYwbvBe0X8Tmfs5NfAvHblbE1ujIsO+JkKknp1S9
 lPx3tnIq9ULMtkKnWdJokSgb2qmUHmq+zaTWIUJ8PJFTovDBh/zq8z25SCYNNOZ9sH1c mQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34xrdar0cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 23 Nov 2020 23:07:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ANMnoSS171914;
        Mon, 23 Nov 2020 23:07:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34ycnrkp0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 23:07:17 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0ANN7GpE028459;
        Mon, 23 Nov 2020 23:07:16 GMT
Received: from [20.15.0.5] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 15:07:15 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] iscsi: Do Not set param when sock is NULL
From:   Michael Christie <michael.christie@oracle.com>
X-Priority: 3
In-Reply-To: <9df96d73-015c-4de6-96fa-2f315b066909@default>
Date:   Mon, 23 Nov 2020 17:07:14 -0600
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junxiao Bi <junxiao.bi@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <05277786-2E1F-432D-AE73-F39565C6BEA4@oracle.com>
References: <1a8aaa17-b1a3-4d6a-b87a-ff49d61a0d0b@default>
 <9df96d73-015c-4de6-96fa-2f315b066909@default>
To:     Gulam Mohamed <gulam.mohamed@oracle.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=2
 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011230147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 clxscore=1011 malwarescore=0
 lowpriorityscore=0 adultscore=0 suspectscore=2 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011230147
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Nov 4, 2020, at 11:40 PM, Gulam Mohamed <gulam.mohamed@oracle.com> =
wrote:
>=20
> Description
> =3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1. This Kernel panic could be due to a timing issue when there is a =
race between the sync thread and the initiator was processing of a login =
response from the target. The session re-open can be invoked from two =
places
>          a.	Sessions sync thread when the iscsid restart
>          b.	=46rom iscsid through iscsi error handler
> 2. The session reopen sequence is as follows in user-space =
(iscsi-initiator-utils)
>          a.	Disconnect the connection
>          b.	Then send the stop connection request to the kernel =
which releases the connection (releases the socket)
>          c.	Queues the reopen for 2 seconds delay
>         d.	Once the delay expires, create the TCP connection again =
by calling the connect() call
>         e.	Poll for the connection
>          f.	When poll is successful i.e when the TCP connection is =
established, it performs
> 	i. Creation of session and connection data structures
> 	ii. Bind the connection to the session. This is the place where =
we assign the sock to tcp_sw_conn->sock
> 	iii. Sets the parameters like target name, persistent address =
etc .
> 	iv. Creates the login pdu
> 	v. Sends the login pdu to kernel
> 	vi. Returns to the main loop to process further events. The =
kernel then sends the login request over to the target node
> 	g. Once login response with success is received, it enters into =
full feature phase and sets the negotiable parameters like =
max_recv_data_length, max_transmit_length, data_digest etc .
> 3. While setting the negotiable parameters by calling =
"iscsi_session_set_neg_params()", kernel panicked as sock was NULL
>=20
> What happened here is
> --------------------------------
> 1.	Before initiator received the login response mentioned in above =
point 2.f.v, another reopen request was sent from the error handler/sync =
session for the same session, as the initiator utils was in main loop to =
process further events (as=20
> 	mentioned in point 2.f.vi above).=20
> 2.	While processing this reopen, it stopped the connection which =
released the socket and queued this connection and at this point of time =
the login response was received for the earlier one


To make sure I got this you are saying before iscsi_sw_tcp_conn_stop =
calls iscsi_sw_tcp_release_conn that the recv path has called =
iscsi_recv_pdu right?


> 3.	The kernel passed over this response to user-space which then =
sent the set_neg_params request to kernel
> 4.	As the connection was stopped, the sock was NULL and hence while =
the kernel was processing the set param request from user-space, it =
panicked
>=20
> Fix
> ----
> 1.	While setting the set_param in kernel, we need to check if sock =
is NULL
> 2.	If the sock is NULL, then return EPERM (operation not permitted)
> 3.	Due to this error handler will be invoked in user-space again to =
recover the session
>=20
> Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
> Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index df47557a02a3..fd668a194053 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -711,6 +711,12 @@ static int iscsi_sw_tcp_conn_set_param(struct =
iscsi_cls_conn *cls_conn,
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

1. It only fixes iscsi_tcp. What about other drivers that free/null =
resources/fields in ep_disconnect that we layer need to access in the =
set_param callback (the cxgbi drivers)?

2. What about drivers that do not free/null fields (be2iscsi, bnx2i, =
ql4xxx and qedi) so the set_param calls end up just working. What state =
will userspace be in where we have logged in, but iscsid also thinks we =
are in the middle of trying to login?

I think we could do:

1. On ep_disconnect and stop_conn set some iscsi_cls_conn bit that =
indicates set_param calls for connection level settings should fail. =
scsi_transport_iscsi could set and check this bit for all drivers.
2. On bind_conn clear the bit.=
