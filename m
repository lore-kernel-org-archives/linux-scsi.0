Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89ABCC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 15:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5736D61A0F
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 15:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236767AbhCXPso (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 11:48:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53242 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236775AbhCXPsS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 11:48:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OFZ8kR043555;
        Wed, 24 Mar 2021 15:48:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=mXvhiSDHhnFgq2uX9nBbzFKBf7uSRyIMSoHBYaNJz/w=;
 b=o8fGgVWvB6CV1iveTe8BZtL+TvInL1Yrt8egBTA4f/Bs0xtMET9u0QCdjNo3ivn+Rn+Z
 VB4Yx05jJp7jRDPpWOteBIlyXesndAEkpU8g7dHlLl82wpulRvYf1Kdbt+bBFd1AOWsP
 BIywCJFttVkvrd+wliMqsqxfXi1d0b01KaRSpOHhkNIZqzJhHsaX1gBLahyysbL0xx9Y
 USyS9hnD+lJ81wBoK2/SKgHDBHPKoQS58cxM1uFPyXN2Zux8kVxAz0uFLCIW/80ktxst
 m8C5J0e4bl7UIhzKzhCR9tJI7Oo3sJjQxG7JDmqifXACrZnwCTIfD8wCNNwSlcocFIPE HA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37d8frb8tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 15:48:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OFaDjX019451;
        Wed, 24 Mar 2021 15:48:16 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by userp3020.oracle.com with ESMTP id 37dtttfhcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 15:48:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+ADNgfQZXPxw8au3z20gV9OYSSq0S0piJ/HmRGv4r6Yxu6rufxjGkM8WC8iyhgrXNh/burHk+cQwlASLOjVIJznCG7Mg10mQhAirvjqzAMjE4nnIq+HGCEGA4wzBovpht3nnKg3IAljeovNzCfMIiJRuVXI9fOb/PEChv7flkXRvBggvaPBhyxuF8QWnekh/WkCPD6XYc8V0RoZaBYMiW9cBLT0Iy9XuUTw4Pi1n2RwAlJxWBvg1pOAQHyXl/46B/vL6frbwN18aSmhTAsxmMucx3s5L4tBrHQq80WN6ImC59P+2wKVlqHDSwlUc6CeSZfpDJhHVmjlX4yd1jQ/vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXvhiSDHhnFgq2uX9nBbzFKBf7uSRyIMSoHBYaNJz/w=;
 b=IBgtaLaVJgUN1RsEwszy9Yz5LwkZVGMo8sBN2+FPZ5K6Yh/nMQOQtClVsSetY5yPslkmO8WKubO/Ld7rbs9pPGn8YsdQAr5NTqeiul98F0/sb4/1JqPsRUXu9hrdP3473r8YF6kqwVEhWQU0d5UsLIUWmKodJGH3zjLdaZKd2FT6vj6hxdkYngymT63UHf9ZPZwWNcGZV2GlinpJDmO8Rg2U+5kKsHcJUl75yIGjSTjLJZPP64UGhaHdWjRwWfsDEa02uuIPVpkeZiiWhe4F7eu7nu04tF1gTRsUfgOjuQ7Bx+gL8bPRhZ0Ohrao/Q0820o5jMfYghySYWWFeego1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXvhiSDHhnFgq2uX9nBbzFKBf7uSRyIMSoHBYaNJz/w=;
 b=sPJYAQAf5fqYwfecSYcSVUACYsj3uWRApPfgFTlJ8IHDKFuHnznCJN/CKyv0rFoTeK92hG6UQ7kPjBfLwMoyMSa2GOArS9Sq1/eu8icwo43FAjGclxZBm2ogl4rlerCUMyfwySa3DHPcSCN/CvQ0MlK7m30nWibvsjfSGs3zVac=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 15:48:14 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3977.024; Wed, 24 Mar 2021
 15:48:14 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 02/11] qla2xxx: Add H:C:T info in the log message for fc
 ports
Thread-Topic: [PATCH 02/11] qla2xxx: Add H:C:T info in the log message for fc
 ports
Thread-Index: AQHXH59LXV0ZLB3Y1UqmH3LJv4lcxKqTSvQA
Date:   Wed, 24 Mar 2021 15:48:14 +0000
Message-ID: <68472D73-7DAD-4FAD-9869-70AB54FD601E@oracle.com>
References: <20210323044257.26664-1-njavali@marvell.com>
 <20210323044257.26664-3-njavali@marvell.com>
In-Reply-To: <20210323044257.26664-3-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [71.42.68.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dbf1ce31-530e-45b8-05c7-08d8eedc3c5f
x-ms-traffictypediagnostic: SN6PR10MB3022:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB3022E50F0FD267EFC2F4F72AE6639@SN6PR10MB3022.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:529;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j1UBUWWvhsZxXSCVqYGG3gMy/0HEtMjhT7l4TqK0jiVmLe4vwpvqtlrXeaZlNLxFF6kXCxY4n8e4WLnifuSqNhPoNDn3mPRbMfLOTeRtwxDp/C6vEYg9GPrSLHEK02xx72Hl7S94ff4P1REHNkAeRZPdSmWOLGpunHyLxXJhHDTMW6OzFd6+O6miin03kRowiuUiU7ms4NSCvPqhWlNHQW8fgvJuoJrNlRm+IKhb4eqE+lVRedoia/QrA7MxAs7r1blYiqcjU4PP7apNnNv8RBbYP5R69tlU5GmzSjrV1/mpgEH6uuHwKWFocTvW5N6jSAPouFkqgfPu8w25CbJGvx6PdxH+asY2N3Yyll/JtaDApmRjwCDJlFk9/2DElPGWmqJKDa8CFVucFwCy4fLHv+qUlmApiAZZzyZehp83DsB1iUwyeR8sMvF0LfzIsklPuN97qNhMANvGIe+MGFBJ/7f+9RpnR9x4/irfRDV97/pKkjvbfg5IPQky357VrBhiBruLCovG8+WRSJY+N4sp7fdLc/vdLLUOyoWJLgjQAerv/Lt4SMjWpgpW90Im9pMk2u2y9C7g2Z3XLb6vI8ocG2udNXuVQIIvJBAXO1741Kb+fzBBn3R/LmGTRm+WIXx5nSt7kxgWSSZ+fMbUkJt857gK51STYKsnbf9Z2CFxf9Bim6BHXeqfU06/0fzyksiS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(136003)(376002)(396003)(53546011)(6486002)(478600001)(71200400001)(4326008)(38100700001)(36756003)(6512007)(5660300002)(6506007)(26005)(186003)(6916009)(64756008)(8936002)(54906003)(2616005)(8676002)(66556008)(76116006)(66446008)(66476007)(86362001)(2906002)(44832011)(83380400001)(33656002)(316002)(66946007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?5oKZiVVFNZJQwrggliyXFSsdnSR36wmXk6mKyS3EYoNVIwppM1zTb+V1w7jn?=
 =?us-ascii?Q?amcIbkk/yABgyNiF6OLaIk5jBBkcKfx3HgmGk2Hm2MW+Clkp68l/JYaqB//8?=
 =?us-ascii?Q?Ltakn/Cn/D7KAGziS/TIpInBzDxjGAn0AsEEMnfsaifmLuFGd4u+0U1aUJ8v?=
 =?us-ascii?Q?+euiK7XbimHMkxasezml1sYc+/YWKNEYXW8dX/3GZZOdSHL0UHUPPAlp+Bjb?=
 =?us-ascii?Q?4Qqk9JYn8Y++qGzO3BMFwYtsLcLoDycphNMYMg5vBdvob3/5dK1iBXUua3vL?=
 =?us-ascii?Q?W2Ak6HiaG/LmAyiBm96ohyMPXm0rvDpq4cQpaaSwcH019M6RQ9V3rmsYEjNP?=
 =?us-ascii?Q?RHIK0sUPlpW2G5qGvjB6g39TgpmDSHk34Thtq765j0oJWIU3QczDzwnwDmnZ?=
 =?us-ascii?Q?oZuX0HckNf1kLSt/ce3SeRaq62jTna0JcvnPwk7JbQMKDOt99T4FwaXh/K47?=
 =?us-ascii?Q?RJ0+GIPEleOfgwrT6biV4zbbfIv/CCWbaZX7raxDjJ//+AOSqietvY38aRpS?=
 =?us-ascii?Q?gS9Xz5trSMJ3uS7YuYrIMsmYGPv1GzORjGdfabFYe1qme9Gdlzkd9wqMV7HR?=
 =?us-ascii?Q?XPnz8a66Kzxoa8GcM8B9dzLQLfVEXTGeqCitlVp/vYEpZG9BHAv44ycMnQit?=
 =?us-ascii?Q?dUsGnU46t1kCWc3m7pj+UoyruKzHigTkj06OAwr67Fm+sD3lGvTVGDOneZYL?=
 =?us-ascii?Q?fmYfAiRpdPrEuN6siiVAFphUv+l0ZDYf6GFO3KfPjG7Q6NQ40351ok9GDwU7?=
 =?us-ascii?Q?4cS4EZ8k06BaDPaWudqIgOSsAH4XTWiS5SInSnmir9D+3sDELMETcETDBntQ?=
 =?us-ascii?Q?VnBQ3Yo/EdPuHIfQBwXOl3ONG5Z3icqlUkh+TQRHK4vn7q3z/PI7rj5rHkV8?=
 =?us-ascii?Q?GFqPK0ZytS04MoBWmyioMd/c9OsU4qiZ948DZ+mXDmlC4EVBGABSETxCrZF5?=
 =?us-ascii?Q?5wNgyD3xb/G0eCDuAXKlif+IJe14TazuhMP7r3zgabqq9dAvClE5sitaU5aa?=
 =?us-ascii?Q?mdcX7ptq2G6HMq/qRTRUzfyh1GdD/hV2AAISv0345ARMRNtcUCNum7esDiD5?=
 =?us-ascii?Q?Zqk3ehyOTMCfNvWMl/KWJeanxASKXmgY7F5VRgVqV0Y6BlEbRTyt6rC0haMF?=
 =?us-ascii?Q?Fsk3f+i2jOveJtaiY/Z/rEKk+eFwrwJXR19KoDjuNeIzDq2iaEkbXxz5IhOY?=
 =?us-ascii?Q?+ewEYHJTWwSZP94aXuYrxMiKnMjWSf7GdHV7M0Szksm9W4u6RJCHJa19LS25?=
 =?us-ascii?Q?caA3VORbvrQs4cFNRIg9+lrsLRVBZnALeGvSfdmSyOh5bNAQ/dxqewUnQU0q?=
 =?us-ascii?Q?4SWfoAn/bkYu55VYWCpOE6CF?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D5B1DED35A68524AAEF32370B7517363@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbf1ce31-530e-45b8-05c7-08d8eedc3c5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 15:48:14.5071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xyQGtvhtI/GXwTaI1DfwJiece5Z6pdFUmIuhS/ZooXeQ54kfZEqd8QN2M3s/Nm05WtCWqZzXFx8T/B/dOFeQPQe8cOYQiRf7kfxhdgPa+hE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3022
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240116
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240116
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 22, 2021, at 11:42 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> The host:channel:scsi_target_id information is helpful in matching
> an fc port with a scsi device, so add it. For initiator fc ports,
> a -1 would be displayed for "target" part.
>=20
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 9 +++++----
> 1 file changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index f01f07116bd3..af237c485389 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -5512,13 +5512,14 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_=
port_t *fcport)
> 	if (fcport->port_type & FCT_NVME_DISCOVERY)
> 		rport_ids.roles |=3D FC_PORT_ROLE_NVME_DISCOVERY;
>=20
> +	fc_remote_port_rolechg(rport, rport_ids.roles);
> +
> 	ql_dbg(ql_dbg_disc, vha, 0x20ee,
> -	    "%s %8phN. rport %p is %s mode\n",
> -	    __func__, fcport->port_name, rport,
> +	    "%s: %8phN. rport %ld:0:%d (%p) is %s mode\n",
> +	    __func__, fcport->port_name, vha->host_no,
> +	    rport->scsi_target_id, rport,
> 	    (fcport->port_type =3D=3D FCT_TARGET) ? "tgt" :
> 	    ((fcport->port_type & FCT_NVME) ? "nvme" : "ini"));
> -
> -	fc_remote_port_rolechg(rport, rport_ids.roles);
> }
>=20
> /*
> --=20
> 2.19.0.rc0
>=20

Looks good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

