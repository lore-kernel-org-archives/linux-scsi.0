Return-Path: <SRS0=brni=B7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URI_NOVOWEL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD7DC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 13:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37AB020578
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 13:50:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ae8rXIzb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgHUNuH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Aug 2020 09:50:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45462 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgHUNuC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Aug 2020 09:50:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07LDlXGf066650;
        Fri, 21 Aug 2020 13:49:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=CusIfXbXpXJp/Q7ciSzYaxIFOwIzvot6FH9tisw6RiI=;
 b=Ae8rXIzbEgcntZKhLA+RGCcgwvZy6gz6jLvpdmKOx2xb/WhXyigWCBEfPu9pvKvS6KgV
 ipfJ9OfXAM0AUHHyRUBtD0g//yypkIWPkOaihN2z9NgqT8wduWiEqaxBE40f9lp5m30U
 B95Vp+dwuxuRSBmndMft/2QqCmxFnAkv6EVYk5mReh9/jURSV/gas3pdXej2AZYBW2gB
 qqF+Tz80Aksnlv1ITNLixHxSAGOc7hlbHMawyOLm51ezjLV8BE+g/I8kXn+c5NU95urb
 rAL7QFrmPm/XG5bhC5LveGdMoawIgEZD+mTPf+Xa4Lc1RyuhmYPLk1f6fkZQdhL63v53 RA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3322bjjngq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Aug 2020 13:49:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07LDn5np045515;
        Fri, 21 Aug 2020 13:49:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 32xsn2k7wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 13:49:46 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07LDniFS018918;
        Fri, 21 Aug 2020 13:49:45 GMT
Received: from [192.168.1.5] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Aug 2020 13:49:44 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] fix qla2xxx regression on sparc64
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200821.142814.268140009249624430.rene@exactcode.com>
Date:   Fri, 21 Aug 2020 08:49:43 -0500
Cc:     linux-scsi@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <153E6E8E-1C07-42C5-B847-010DA7B12206@oracle.com>
References: <20200821.142814.268140009249624430.rene@exactcode.com>
To:     Rene Rebe <rene@exactcode.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 clxscore=1011 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210127
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Rene,


> On Aug 21, 2020, at 7:28 AM, Rene Rebe <rene@exactcode.com> wrote:
>=20
>=20
> Commit 9a50aaefc1b896e734bf7faf3d085f71a360ce97 in 2014 broke
> qla2xxx on sparc64, e.g. as in the Sun Blade 1000 / 2000.
> Unbreak by fixing endianess in nvram firmware defaults
> initialization.
>=20

I could not find this commit 9a50aaefc1b896e734bf7faf3d085f71a360ce97 in =
Linus or SCSI tree.=20
Can you please provide details of the commit which introduced this =
regression. Also when you
resubmit this patch please use Fixes tag. See documentation here for the =
correct format.

=
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst

> Signed-off-by: Ren=C3=A9 Rebe <rene@exactcode.de>
>=20
> --- linux-5.8/drivers/scsi/qla2xxx/qla_init.c.vanilla	2020-08-21 =
09:55:18.600926737 +0200
> +++ linux-5.8/drivers/scsi/qla2xxx/qla_init.c	2020-08-21 =
09:57:35.992926885 +0200
> @@ -4603,18 +4603,18 @@
> 			nv->firmware_options[1] =3D BIT_7 | BIT_5;
> 			nv->add_firmware_options[0] =3D BIT_5;
> 			nv->add_firmware_options[1] =3D BIT_5 | BIT_4;
> -			nv->frame_payload_size =3D 2048;
> +			nv->frame_payload_size =3D cpu_to_le16(2048);
> 			nv->special_options[1] =3D BIT_7;
> 		} else if (IS_QLA2200(ha)) {
> 			nv->firmware_options[0] =3D BIT_2 | BIT_1;
> 			nv->firmware_options[1] =3D BIT_7 | BIT_5;
> 			nv->add_firmware_options[0] =3D BIT_5;
> 			nv->add_firmware_options[1] =3D BIT_5 | BIT_4;
> -			nv->frame_payload_size =3D 1024;
> +			nv->frame_payload_size =3D cpu_to_le16(1024);
> 		} else if (IS_QLA2100(ha)) {
> 			nv->firmware_options[0] =3D BIT_3 | BIT_1;
> 			nv->firmware_options[1] =3D BIT_5;
> -			nv->frame_payload_size =3D 1024;
> +			nv->frame_payload_size =3D cpu_to_le16(1024);
> 		}
>=20
> 		nv->max_iocb_allocation =3D cpu_to_le16(256);
>=20
> --=20
>  Ren=C3=A9 Rebe, ExactCODE GmbH, Lietzenburger Str. 42, DE-10789 =
Berlin
>  =
https://urldefense.com/v3/__https://exactcode.com__;!!GqivPVa7Brio!KU2euUg=
VJIRXqzU0RdhkxvMdgtotnSUfdk9KmK73n26lyGlTMhmSvyadcgXXxI-1EV4u$  | =
https://urldefense.com/v3/__https://t2sde.org__;!!GqivPVa7Brio!KU2euUgVJIR=
XqzU0RdhkxvMdgtotnSUfdk9KmK73n26lyGlTMhmSvyadcgXXxAAjd8CY$  | =
https://urldefense.com/v3/__https://rene.rebe.de__;!!GqivPVa7Brio!KU2euUgV=
JIRXqzU0RdhkxvMdgtotnSUfdk9KmK73n26lyGlTMhmSvyadcgXXxDUjMdad$=20

--
Himanshu Madhani	 Oracle Linux Engineering

