Return-Path: <SRS0=ULGd=EP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C837C2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 04:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B28F02084C
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 04:57:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ew2VBRlp";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="Wd+N6tVY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgKIE5e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Nov 2020 23:57:34 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64670 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728038AbgKIE5d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Nov 2020 23:57:33 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A94rCLw015108;
        Sun, 8 Nov 2020 20:56:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=13DjEgYtNijdBjDuD8MAiJ8OyiqtMH3YWuHp6Ah0g14=;
 b=ew2VBRlpJsuGIKjB+8hr9yzfUHEvIVmAlS3JDPBnJUKOMaJSJIjS8k8U1IwUPA9aWvsM
 /pA6dEi3K78b/GewNhRFE9NalEIdQLFpCeSI0wyG9vT96ncvXb4yrp9s4k88DqAMPzLb
 36H/CdweCChQyBdDC9FCvThbkigAXABV3cd6rntWcPxPC8koDILp59Sz/EgCe0D4mfdW
 YTlLfUJm5pCJ0IbRMUAHk3NP1u8r5XlqmavcnPo0fv5x9RcmC6bQBDOnS9+xczakBKLr
 lbZxeYBpcwds6n0vAo/3q2Hui0x+8S7J9Wp+L8tLKKl2HEWSSF9FI1Xojz+fiJNNYbvu EQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34nuys8gg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 08 Nov 2020 20:56:45 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 8 Nov
 2020 20:56:43 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 8 Nov
 2020 20:56:43 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.58) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 8 Nov 2020 20:56:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eilm3HFVfgAXoEj8S0kiCHZLK9Kbo7mkbQX4o4n7lWKL8rMqTPeqcarilwfixqxmZjgRr/kDUS/+NOclIqZ2xdEs5Q2xw1Emq7xcBTEBJh0Wfdo+kvV76bJYsxFbdXLnlZpiEetU527mcIM6zDX936U+TX2UN45qDepgEHPN+ObKe31R0oravZjNZddgxco4Vbj0jKu5YYin+j2YfpghQw8qFReGHWyRkGGhu0djhPjH5Jd7cdbXedFKSYdiEFFU+cwY4w7X8IKRg5DoS7/dARnHPlJiOugjbb5/HJSNncbpQQkkAv+MB9g44X3phKzxGkvAdDdKAaKpzXi3oohBnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13DjEgYtNijdBjDuD8MAiJ8OyiqtMH3YWuHp6Ah0g14=;
 b=Zal4WkaNxEimAiJ64t0wmIji66+dAVey4rk9QXqJsO3qXfqmazlGctBM79YktyGSGqknwwGJWpVUYbnYV5LzZyUDKV9Z9LFemKIgtaJqgz2jQjsosa7eA4eAoBkL+y8b7G3RkML9EEX2f4A1Mv4YS7ebvSRhqZ/QtwFbSh0Uj8dENg2IDOL1XaAFueoCxj43Dyup5+M4M5hTCXEONUhnKAE1TI2E86Yr9V5/uoqgxoKWFF4lKUmUHpWTWbWdKv6AQ9aPLnbTM6asnzszRoMSMn2xQTl28abVIl+FyGw/ENNaUvVuW8TU1zEqQ7JvMI3FgkQ2NMbjKPees73XQ2x8JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13DjEgYtNijdBjDuD8MAiJ8OyiqtMH3YWuHp6Ah0g14=;
 b=Wd+N6tVY5xoDrnLR24ZNsnbBPbgta7ksUb2cL6W15PR8LPV5bpcKxL1i8yXc8dYWDUSs5ntX6qE32rdi9mr7L6IrzWLxoLoxpG4/sFMCGOFG0cbQ0Dwjd+M9U+j02Bff4zi3cwN7pj+kDPSGyxGHKemTyTEvNx+JOsDZZdNJdmk=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM6PR18MB2602.namprd18.prod.outlook.com (2603:10b6:5:15d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Mon, 9 Nov
 2020 04:56:40 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::a087:2131:1284:66e7]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::a087:2131:1284:66e7%7]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 04:56:40 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     "xiakaixu1987@gmail.com" <xiakaixu1987@gmail.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: RE: [PATCH] scsi: bnx2fc: fix comparison to bool warning
Thread-Topic: [PATCH] scsi: bnx2fc: fix comparison to bool warning
Thread-Index: AQHWtSZXw7LwU+PJ/EKQqIb/yr/v3am/PtBw
Date:   Mon, 9 Nov 2020 04:56:40 +0000
Message-ID: <DM6PR18MB3034D9FD587A112D92062257D2EA0@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <1604767920-8361-1-git-send-email-kaixuxia@tencent.com>
In-Reply-To: <1604767920-8361-1-git-send-email-kaixuxia@tencent.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [117.211.149.245]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f4b65ea-04e4-45b5-a27d-08d8846bd880
x-ms-traffictypediagnostic: DM6PR18MB2602:
x-microsoft-antispam-prvs: <DM6PR18MB2602E5DA2F70930EE8F94D10D2EA0@DM6PR18MB2602.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DtUL7nckaPcHksa4wkZYTeZjMbl2lRnjcZwg+z2xBPFltCbhOkX9/Hr3V6lU7VY/2q62/023IopVtmgwVEw/uE9WbcNxZgHgke1MewhuhN3LCRLeMgEDOI3Jt9rrz6sQ2GhoVmrAeA+EG0Rh+38gXwM3mLAzAnC1RsaS6IEqDMCvwnpthIWAzxt0u2J1r7fCW3nc7g1NamrygbuylSJN3gx9T201gd2TpRKPiAP+hpLyQ1p/i8+Zxw8GFng+YUZT566gcgArjcj/yeduoUzx+PH4SCMh4Sd6TUofX8ytgMZhheMPIE6rUMVeNLIGuHdWt9QKbUGsDJD4tDsUxxO3xg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39850400004)(366004)(376002)(83380400001)(9686003)(8936002)(4326008)(8676002)(2906002)(55016002)(478600001)(316002)(110136005)(54906003)(86362001)(6506007)(26005)(186003)(52536014)(7696005)(53546011)(33656002)(66946007)(66446008)(66556008)(76116006)(64756008)(66476007)(5660300002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: mz1DgVr9Jx9kNCD2KCalt9Tt1C6r91wdu41l6XeEEyr5hJOypbFL76AV00vuHM0BJBxRukg3PRUJHTph3fCaIOPRenJfv7W1OZRnqXOq6u6oZDCr+qeNyG+sjc/8qLrKdX2vAzJaVwBtBRdMuwtmURJW7fgPEW7YBpo/bd8HbXC9T4FHsUOFBWcmO2XyoNFRXr9M2hJipkTaodtRyxBcFKN2hGIGP2ItFElEmrwEnN7psyq+VVk0vKpgbs+pcc97nyeNQ7kU8+vqWrYgorwHF3yrnx43vS575eMxv2xXHcWl4Yz/T8I6a1aiLobBsvVT8rmLyos73a80wXTI7bLraey0gkygLQYLSRzu6UFyJ9HzsUlvwSvon8wxVPCa+CzzPWoe1IAg0q442W7Gf6Es1O9WwQYGLu3qo5W/zYFEPXXtZpYl9XVV+siutySw7vih3Vw1XDCl51y7hXXOdL6Z22v7pgHkMYvG9CQSGcuvZn5kFSIdJIPi/dx6s74yQsjV/OS8mQWTO+4y6xp9LoAlvQP0lMKiaJdS3DLIggZPMuDVcpmmblFZQGWldIc6490ZC3f8NWbsS5FlIDEvtoQwsuK0i3/G/44393+wtXjfzuSbPXYM7ocKqxbjGJ1c7y1gXobyqMUdyGl9Rr+9Y9S0HQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f4b65ea-04e4-45b5-a27d-08d8846bd880
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2020 04:56:40.0621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NbkymrKcudEENrSKJFcdKi0ISBhqZ4FgvF15UkDTJQ/8L48dq5wV4XYOTV7AnC15IAOjCAq83k/UBgHY8s2Gjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2602
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-09_01:2020-11-05,2020-11-09 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,


> -----Original Message-----
> From: xiakaixu1987@gmail.com <xiakaixu1987@gmail.com>
> Sent: Saturday, November 7, 2020 10:22 PM
> To: jejb@linux.ibm.com; martin.petersen@oracle.com
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Kaixu Xia
> <kaixuxia@tencent.com>
> Subject: [PATCH] scsi: bnx2fc: fix comparison to bool warning
>=20
> From: Kaixu Xia <kaixuxia@tencent.com>
>=20
> Fix the following coccicheck warning:
>=20
> ./drivers/scsi/bnx2fc/bnx2fc_fcoe.c:2089:5-23: WARNING: Comparison to boo=
l
> ./drivers/scsi/bnx2fc/bnx2fc_fcoe.c:2187:5-23: WARNING: Comparison to boo=
l
>=20
> Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> index 6890bbe04a8c..b612f5ea647e 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -2086,7 +2086,7 @@ static int __bnx2fc_disable(struct fcoe_ctlr *ctlr)
>  {
>  	struct bnx2fc_interface *interface =3D fcoe_ctlr_priv(ctlr);
>=20
> -	if (interface->enabled =3D=3D true) {
> +	if (interface->enabled) {
>  		if (!ctlr->lp) {
>  			pr_err(PFX "__bnx2fc_disable: lport not found\n");
>  			return -ENODEV;
> @@ -2184,7 +2184,7 @@ static int __bnx2fc_enable(struct fcoe_ctlr *ctlr)
>  	struct cnic_fc_npiv_tbl *npiv_tbl;
>  	struct fc_lport *lport;
>=20
> -	if (interface->enabled =3D=3D false) {
> +	if (!interface->enabled) {
>  		if (!ctlr->lp) {
>  			pr_err(PFX "__bnx2fc_enable: lport not found\n");
>  			return -ENODEV;
>
Thanks for a patch.

Acked-by: Saurav Kashyap <skashyap@marvell.com>

Thanks,
~Saurav
 --
> 2.20.0


