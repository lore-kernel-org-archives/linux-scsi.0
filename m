Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A0FC433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 14:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E34E4208CA
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 14:36:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GZaIUvG0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgIAOgm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 10:36:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41914 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgIAOge (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2020 10:36:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081EYwGo147244;
        Tue, 1 Sep 2020 14:36:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=i8qrvVbixd5yCAGTgMrx2ucns1izcE3HbqEKtRJ5fa8=;
 b=GZaIUvG0Knv2+b1Me/AYVWjnvInkhDxXLL9wbktrysKiI70tnh0vyEflK9Hgg5RYCzJl
 uijbvhku7sljmqbeXPSjg+nTZzmc0FtJwbdCqbE3OvhWlaJr5yEB3Ai/KV+ZDTSMXpzh
 mwl85HpXBpSg8Orh/hOWsgL0NukmYM2Vvz3ZR5S0uDXh+bHUhlEWX9nk7Og2y10NJhmW
 PgTVjDRhMgkf3YtQ2hR8y1IUCMcaHr91K2THCgjEZhRQPapE/aeAfnRJCHNW8poLQkld
 i4HcvIQQTwqYPmVSfCV43tmwwSUvfFw0+nU8SRJFhn0E0yfNHxfBoal5AX6Ej4x0zteA rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 337eeqvr96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Sep 2020 14:36:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081EVAlf118549;
        Tue, 1 Sep 2020 14:36:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3380kna3h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Sep 2020 14:36:31 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 081EaTvI007957;
        Tue, 1 Sep 2020 14:36:29 GMT
Received: from [192.168.1.5] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 07:36:29 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] scsi: add 256GBit speed setting to scsi fc transport
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200831213518.48409-1-james.smart@broadcom.com>
Date:   Tue, 1 Sep 2020 09:36:29 -0500
Cc:     linux-scsi@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2D332F74-8A8A-4A6B-92D2-78AFE7F4727D@oracle.com>
References: <20200831213518.48409-1-james.smart@broadcom.com>
To:     James Smart <james.smart@broadcom.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009010122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009010122
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 31, 2020, at 4:35 PM, James Smart <james.smart@broadcom.com> =
wrote:
>=20
> Add 256GBit speed setting to the scsi fc transport.  This speed can be
> reached via FC trunking techniques.
>=20
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
> drivers/scsi/scsi_transport_fc.c | 1 +
> include/scsi/scsi_transport_fc.h | 1 +
> 2 files changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/scsi_transport_fc.c =
b/drivers/scsi/scsi_transport_fc.c
> index 2732fa65119c..2ff7f06203da 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -253,6 +253,7 @@ static const struct {
> 	{ FC_PORTSPEED_25GBIT,		"25 Gbit" },
> 	{ FC_PORTSPEED_64GBIT,		"64 Gbit" },
> 	{ FC_PORTSPEED_128GBIT,		"128 Gbit" },
> +	{ FC_PORTSPEED_256GBIT,		"256 Gbit" },
> 	{ FC_PORTSPEED_NOT_NEGOTIATED,	"Not Negotiated" },
> };
> fc_bitfield_name_search(port_speed, fc_port_speed_names)
> diff --git a/include/scsi/scsi_transport_fc.h =
b/include/scsi/scsi_transport_fc.h
> index 7db2dd783834..1c7dd35cb7a0 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -124,6 +124,7 @@ enum fc_vport_state {
> #define FC_PORTSPEED_25GBIT		0x800
> #define FC_PORTSPEED_64GBIT		0x1000
> #define FC_PORTSPEED_128GBIT		0x2000
> +#define FC_PORTSPEED_256GBIT		0x4000
> #define FC_PORTSPEED_NOT_NEGOTIATED	(1 << 15) /* Speed not =
established */
>=20
> /*
> --=20
> 2.26.2
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

