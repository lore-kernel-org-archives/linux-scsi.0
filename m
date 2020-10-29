Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABDDAC2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 20:24:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44A5920728
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 20:24:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HwwERDOX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgJ2UYo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 16:24:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60048 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgJ2UYn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 16:24:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKOfKd088319;
        Thu, 29 Oct 2020 20:24:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=lKI36PUWPtrgfAmvumLtPuJkY6gHocCexq0kp/4nrJs=;
 b=HwwERDOXWr4lXF8FJfdDYPXYML6XufpkYuDXEyTk9dyC3spgnQOle21523riEs6zKdzF
 b6ZSQcIt4KNu2KLuSsQ36wqAm0H3XYoNuUqfIi6bB7MHa2Vv9LPEQ7DkT9s2rR9/SEmn
 0n98/ui0muer5UYf6aFdL6C8CGwcTgkW5yXyIZSZsH2cT2q0abekHAj0qykhedtKI2bB
 WBK4p8dU0HSpHIjwyACkV/6FPpQe6t39T4yth+n4VKZNtdMZHSI30vfcVPexEqGadiuX
 oWC8KUHlyB/w5XwK5wRDneM0RPQLo4HppzUKjOMMGWDB/ExgC5TjfT0lz/aEfC/tEop3 mQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34dgm4cfvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 20:24:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKKPeE070622;
        Thu, 29 Oct 2020 20:22:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34cx1tn5du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 20:22:40 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TKMdIJ005058;
        Thu, 29 Oct 2020 20:22:39 GMT
Received: from dhcp-10-154-184-179.vpn.oracle.com (/10.154.184.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 13:22:39 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 2/8] target: fix cmd_count ref leak
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <1603954171-11621-3-git-send-email-michael.christie@oracle.com>
Date:   Thu, 29 Oct 2020 15:22:38 -0500
Cc:     Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <2E86A3B3-9BE5-492D-AAA8-065BB072635D@oracle.com>
References: <1603954171-11621-1-git-send-email-michael.christie@oracle.com>
 <1603954171-11621-3-git-send-email-michael.christie@oracle.com>
To:     Mike Christie <michael.christie@oracle.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=3 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=3 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290141
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 29, 2020, at 1:49 AM, Mike Christie =
<michael.christie@oracle.com> wrote:
>=20
> percpu_ref_init sets the refcount to 1 and percpu_ref_kill drops it.
> Drivers like iscsi and loop do not call =
target_sess_cmd_list_set_waiting
> during session shutdown though, so they have been calling
> percpu_ref_exit
> with a refcount still taken and leaking the cmd_counts memory.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
> drivers/target/target_core_transport.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
>=20
> diff --git a/drivers/target/target_core_transport.c =
b/drivers/target/target_core_transport.c
> index ff26ab0..d47619a 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -238,6 +238,14 @@ int transport_init_session(struct se_session =
*se_sess)
>=20
> void transport_uninit_session(struct se_session *se_sess)
> {
> +	/*
> +	 * Drivers like iscsi and loop do not call
> +	 * target_sess_cmd_list_set_waiting during session shutdown so =
we
> +	 * have to drop the ref taken at init time here.
> +	 */
> +	if (!se_sess->sess_tearing_down)
> +		percpu_ref_put(&se_sess->cmd_count);
> +
> 	percpu_ref_exit(&se_sess->cmd_count);
> }
>=20
> --=20
> 1.8.3.1
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

