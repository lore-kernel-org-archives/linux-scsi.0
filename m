Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED586EB64D7
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 16:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbjF1QUo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 12:20:44 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:45230 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231648AbjF1QUl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2023 12:20:41 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35SBT8W8024948;
        Wed, 28 Jun 2023 16:20:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=qR1kwhAGHcA+o3GNuNOvjWuxJGjpFQF+3RuDpOCa3cA=;
 b=cXQDKaqDerDSEA4PXNQyVppdrs+Wa7er/+ZH/usNF7cKQ4FF8paI2ocPuJBvD5Y2Zy7G
 +I4SYn2qjvtzgIe5zu1ROTvAuHs4b1ok4OiYyp3xY54g/Xq7j2bd3QW79wvvf5XhTFcS
 rMnDqI9u8sNkfr+AcM30QpmfLh/DNFif3Dw0PXyhsHuodPPZgPXljF570Ud8e9l13pR0
 TXHtAxQZFYHd/LBCvPhtXxunKgd7CtIW8EKBgEbyQTAlQB/vINKscl8NIyTPzl0/1Wab
 7ilpePa5jBhoa7ej/zqaobz+hsbXUQHfYYIzKTAEjIFFXa9/mbIc51yfye4CM7QtsJfz lA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rf40e68me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jun 2023 16:20:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35SGG4O3020148;
        Wed, 28 Jun 2023 16:20:13 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rdpxc0hud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jun 2023 16:20:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMsn0D388VT7YaetK1dk2ZTmcd+c7yrS/OMQkLvtztuTm4plPdH2c9aEsyxgDp6efUF3Pv4PgaAcfuAMlzEVNRfBAcMpae68D1DYPqVYk7z3C6Tu41NBqDlnySOXuYLPAedaw77gWIIC8Wsc/JFaHnj7qZpi+hCi3MfQD8RY1azW4UfLBDD4fRagmW6TfLcakA4vqcd1xXW047johBzXrFBh0MsNiYc06y68uDvDn02EuVsw3vHkOZYcAjLQmw3l9DMTm0/KVgi0Q0cqyVjvm11MCqp+Awzm6bRC1KPs3aOIMGwqyqqsu4zM8Ug3D8O+Ypt66lRE/94OrP0FezituA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qR1kwhAGHcA+o3GNuNOvjWuxJGjpFQF+3RuDpOCa3cA=;
 b=a81XWcR5zbopMjrqCia/tVCZTLD7ifRigmEhhz859GC1SJIZAunuJjd/jI8MV0eyakzgJXgNCWL4CcxsZ4Pxj+nBje6dK7HHMVaqpo+6HmBXvoY9rn5uBbe4zy/q5EyxXn+Z4uKjnLqprYoOsWaUrBrwcdc+MF4uJHmI0llc4XH0OI5kFeTgy38ByRBxzh/YrAhpMewVr5l7AstV33tyupsgfc3q1NumWjXk/uXzzU0Af+lvHYv6DBHmQRK2ZyDV+hlfe5CEzlhleJG57gLWpMeXhA/fCUV2C82QPcC5Ms2v/ukJh5s7hbXMKv4umhnaZB1TxH956Qoo8ywPzfQ0+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qR1kwhAGHcA+o3GNuNOvjWuxJGjpFQF+3RuDpOCa3cA=;
 b=sOigzuXd3tSgXuhHtIGgOsaQXNUl54xnPc8ZfNKIT78/lgnWicthMsLD0gwJwfpJ4y//eCG44w8ct0pAOiNsbCyXJ9uqhZwFy0f5RCkJdgZc2LgoyvxQ1EyprMCot/0kqd73vCl5TKSQsIxVFSK+788/SvsDvu/IJN0/e1+mTNs=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SJ0PR10MB5568.namprd10.prod.outlook.com (2603:10b6:a03:3d3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Wed, 28 Jun
 2023 16:20:10 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::d634:f050:9501:46dd]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::d634:f050:9501:46dd%3]) with mapi id 15.20.6521.024; Wed, 28 Jun 2023
 16:20:07 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Laurence Oberman <loberman@redhat.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "djeffery@redhat.com" <djeffery@redhat.com>,
        "emilne@redhat.com" <emilne@redhat.com>,
        "jpittman@redhat.com" <jpittman@redhat.com>
Subject: Re: [PATCH] scsi: qla2xxx avoid a panic due to BUG() if a WRITE_SAME
 command  is sent to a device that has no protection
Thread-Topic: [PATCH] scsi: qla2xxx avoid a panic due to BUG() if a WRITE_SAME
 command  is sent to a device that has no protection
Thread-Index: AQHZqbUBPRAEBNHQzU+RuGgcxZcuea+gZVYA
Date:   Wed, 28 Jun 2023 16:20:07 +0000
Message-ID: <7342E3C9-F034-4FC2-AF97-CD1209D5C332@oracle.com>
References: <77f405a048b07e4451b7d7adaeba7ce4a00b7efb.camel@redhat.com>
In-Reply-To: <77f405a048b07e4451b7d7adaeba7ce4a00b7efb.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|SJ0PR10MB5568:EE_
x-ms-office365-filtering-correlation-id: d2db9f0b-029a-455e-4ea4-08db77f389ac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0PWwkM7RUVniwWBhxELm2fY7nRdRLYe3CpvP3DBjUrOkF97TPtCM+Obgp37K5VrWu5SxC882NpWVwDy220Kagm6Yyv4/8HrI3Q8KCwjUz9dwF6D5Q+rf2FUq/1WGifSisLWTdyD5Wid3KHilyjSiLcj0HcMdZzSMICCkP1/USo+28hum/WOdL1O+fduh9yMStLVL35xLpvUFT6sVSbkmSSO2p+m4jUJquyOQmQnGp63HW1x9hiLzegAXZgj54st0PFSygow/pBI6+kCrCzDvNiD6q19yrFEEAvt/1vw5K3WaA4mXalH7rHTssl5Wq9gE0QhtESIZHwa/NjJRjqUDrJq8LWzm0W/iq5U9ulf4ooVlYNqVmUUz7L9NJcB+7oBXVu5hamaOw1Vbx6uChQXXIWViPPtZEtKmczkI3ikKLl6S1MRaPqM4Ihtj8ic3YMphSYMbKzGRoPEYXFwNP9JUrdy2mIWSIfpmsPTtHP/1XSmAfn8FUymlTRmzQ12EtDG0VCResKPjl3Y5OJEQuTD9gn9+GpESGXsJcfS9IBbiR0NCPZ3qAz3xs4BZBaAOn8EoLwkN8Bimo1QUwRV2OE+nGGy/0d39EDHnKqlBXaWwYti927KxIbwJzoijLCx5hErtpfmbH3R3NPipHAsb4i5yEw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199021)(66446008)(53546011)(36756003)(33656002)(5660300002)(44832011)(64756008)(38070700005)(86362001)(91956017)(8936002)(66556008)(8676002)(6916009)(41300700001)(66476007)(122000001)(76116006)(4326008)(316002)(38100700002)(66946007)(2906002)(26005)(478600001)(6506007)(186003)(2616005)(6512007)(71200400001)(83380400001)(6486002)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DtzQJcKxOwDS6YuyH5vW14JSt7INe9Vv5Pgr8yK3/U2i2pyYLgveUsQ+omu1?=
 =?us-ascii?Q?Lf/sv3VJwY0G2KbB2gGFgDUD1MwdClehWAkxRVnfXuXKSQQwZprInVl59jyU?=
 =?us-ascii?Q?KqnaxGWKLL7vKjyMbiFa9EwCZ3MZ8Ef1ePmDaenxQY4EK8P6QMgSXbBJLPlF?=
 =?us-ascii?Q?wJctMgSwdzT77oxT8I47mywRNgzJuiDeFHYymg0QGnTpWPd3R7RkOozUBBkS?=
 =?us-ascii?Q?pH1RiWnG/jGoOwLdUQjqy8WhyITGv8g6lt4ZfJxytKdrDML8+QMuLCRYjCQC?=
 =?us-ascii?Q?DqoNuGw/hLuM8dEqmS446VmWl8N8xk0Gb5svw6+D8yFuwJa6ssoOFBMYIohT?=
 =?us-ascii?Q?sp91wBDLga+B6bAe2JGRBky+ScyEbKQusLOG/u5VbYSteVmqSHGCkF21Ek7n?=
 =?us-ascii?Q?4z8vBzJy/Nto7NL+xxjlSuH8YciLreSQ309GWoHxRue9uVTSsXWfc/JBxi6W?=
 =?us-ascii?Q?2Kshz5WeeS4YAYerJMNxAloQLTw3E5rvjr7Sn9VCH3E3R/IUQ5bXl+7wKIlV?=
 =?us-ascii?Q?YLyT9nj1sF9JAL3KDvbna0qda+DndbOyGlTP1V3C54APTIiQY1S7Xt4oq10D?=
 =?us-ascii?Q?MqthytH+uW12EDLyM6ekqGj9zSV9P4lomkUocwcIFWJOrS2aFxBfazY+NrCi?=
 =?us-ascii?Q?5tE1mh2wS8QhlDTNs4DWLqwih28dUrb4GeeeH3NDwA4yU9/lQ0iDc6X1jLBf?=
 =?us-ascii?Q?P0t9HRQDodlK63IDbONVmQo6Nq3vEeRD+c4002O3OMwFwtbFtXKpyr3QogeJ?=
 =?us-ascii?Q?D5mr+dG2TCBV9oonAAsIGdkcxvDuYT+VqSE8myBiSULt+IwXUVTqpzPC5ASq?=
 =?us-ascii?Q?jDlYyIrvKvH7kvYzuE9lDlLU4np82fyeRVbqzFU3B85IX6wcjjLVz7PNxZr+?=
 =?us-ascii?Q?ubzLpSQiIGYj/5eDulk2GdQ3GLRclAbToAZiouKNh7KjIl8Kx5AW2KgNST91?=
 =?us-ascii?Q?9nw6cJvs7Kvm6GkM+GI4Pos7dGWllwiMRIUNoPcj+oCb+1wTR9wpkEDXwoQC?=
 =?us-ascii?Q?4zC9Um5vxzJXKrd4nfI+Nj3FSKM2+FTtwYbHOoOulhkiynGJSxfG/7laVZ0V?=
 =?us-ascii?Q?Pyv2aG3GCnUb35UiXRZQZ2DBpC2dwMIPxYWVDosi0rilRIXIbzmN5WPVKx0y?=
 =?us-ascii?Q?y7dNx7CqbTZX4Pt21UYgh/s4O2y98A3aSQV8Q2l9dstagaH9m16Trfou4TI+?=
 =?us-ascii?Q?IfMa7GFqPmvoZfJlNID4rZxmb71IGY7d7pnHi8ErZ35vxM2FGVXh1Tw9wU7C?=
 =?us-ascii?Q?4FkUHuGU1qdasmIkHDt4TZEZA5fAPFEai9lOFB+L9Uu+nfV52miTNzWx2xOI?=
 =?us-ascii?Q?0WPt1tFGN06ffk024DtoYj2SiZnn4WoIUUWj6hkq6LxaADne1IPQSvF4/glA?=
 =?us-ascii?Q?pDcZSQN1nS0H/paJ9UDfYzpT4L0gVZjAondHVo+pb6VPN7idBIgKdjM+PTqz?=
 =?us-ascii?Q?/q+k5qbOKBhkHhbIuB/SwItvcezzm1m59oO5iuXzhIq57aK9GDy7H/3eADVD?=
 =?us-ascii?Q?y2xd2thJyRixGyEUlFPvr4nWJ4Dh2wIw+rFq4zO8UHIplDf46lcoKRiH/EIx?=
 =?us-ascii?Q?P4scayh3+lEtSSG0eF9Dz1aVjWchuqw//WjcWBwsg+Vm+fu2jXR+76JDF8Ff?=
 =?us-ascii?Q?/z3Vzh4ZkC/ksL5bMVCYnrE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <04547A24A4B06A44AFFF67F19739BD40@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: MmL/3dwdJ2y3LTypNKIxBf1UskWnkl0eN+xfNyeX/g9B9C/yaxqBSYPOphx7d+nmWXjJoPJhe9maXv3tZgOFlnIh6Tqn+gonZWxOrNzCUDcey8kEFCnfAVXp3vMFASUSCNfOcoz2TF6sE1hjMxr9v2UDO3jp1PkxXvzhrz0IhRMvZM+TFxdYFAl5gUuJY5xgHH3PbbKS8jshbn4OvwrQ0OfSPcxgCKZ503XWihQYZwr+Z5xOYK4ChqawhvjwGJ1nRPPQSBX9SM0l2kXf6SMhhPxF8pQeFChV0DbtqoEk2JVi4RBfnmaZ+x6uOD51ZssgUYI3an/fJoMqklbOT2igIEPclRxwe/1g9u6l1SG5ip1ANMGUxQF9YpDax8Fbzx41KZAcX9ob7z5Dh7r4jQRpWqkoYczE7nKoxN2NrArFLmxX9R20LBYe/T4EsDDX3IN84zZCD+yT9gpbR1irCxBpRDStmPmi+tHa0YbFw0RP+uth0sbjUMk4RuKHeICJLifMooeiMXeOzo/lNo3Sb+udxBt9uTeFiiPMcCY1VkFeWfXOhxHJljCYXeInuRafz92Qcss7Vu2GJUVJEHFkr8cwaei5x5MXHNSr1aCaURtXWVPxLcS9G2q0xmwr+AF6jP+p2XtDiKi7zESGshVtHF94oxAM/3fB7MuXbugsui+x1m3B4JVMlTtQgAwMPT7m4mnCd/uDp/5PY1fw2LhAokHFQTQMsWpVewa8aRf2KIb2IDbjvPSitf2k2gl1ZehobU+KcaX40ASmgIn87kbYTlnKbeYig4zWB49fKNuK7Sxq903DCr8P3nDnrKK+2bEpdby8
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2db9f0b-029a-455e-4ea4-08db77f389ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2023 16:20:07.3256
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L1Be8XtKTZpnkAjHy6QzJ+ObdixOiyjn8/0/Tcdq8MaFQgsxxaTNXMn9JtKmNMX/AoMezNK9f/LFxWYJBBmZ+S4CePP0qlh7wv2lqClob2U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5568
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-28_11,2023-06-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306280144
X-Proofpoint-GUID: 9LqHf30Qapae0okJ1zQD8IDDaHQAH-Uc
X-Proofpoint-ORIG-GUID: 9LqHf30Qapae0okJ1zQD8IDDaHQAH-Uc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Laurence,

> On Jun 28, 2023, at 4:34 AM, Laurence Oberman <loberman@redhat.com> wrote=
:
>=20
> In the current code, If a device does not have protection, qla2xx will
> land up defaulting to a BUG() and will panic the system when
> sg_write_same is sent.This is because SCSI_PROT_NORMAL is matched and
> falls through to the BUG() call.
> The write_same command to a device without protection is not handled
> safely.
>=20
> Fix this by making two changes:
> Set the bundling variable also to 0 for SCSI_PROT_NORMAL
> Modify the switch statement to match on SCSI_PROT_NORMAL and handle it
> appropriately removing the call to BUG()
>=20

This should go to stable kernel as well.=20

Cc: stable@vger.kernel.org <mailto:stable@vger.kernel.org>

> Supersedes prior suggested patch.
>=20
> Suggested-by: David Jeffery <djeffery@redhat.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> ---
> drivers/scsi/qla2xxx/qla_iocb.c | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c
> b/drivers/scsi/qla2xxx/qla_iocb.c
> index b9b3e6f80ea9..82a5d195e401 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -1381,7 +1381,8 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct
> cmd_type_crc_2 *cmd_pkt,
> if ((scsi_get_prot_op(cmd) =3D=3D SCSI_PROT_READ_INSERT) ||
>    (scsi_get_prot_op(cmd) =3D=3D SCSI_PROT_WRITE_STRIP) ||
>    (scsi_get_prot_op(cmd) =3D=3D SCSI_PROT_READ_STRIP) ||
> -    (scsi_get_prot_op(cmd) =3D=3D SCSI_PROT_WRITE_INSERT))
> +    (scsi_get_prot_op(cmd) =3D=3D SCSI_PROT_WRITE_INSERT) ||
> +    (scsi_get_prot_op(cmd) =3D=3D SCSI_PROT_NORMAL))
> bundling =3D 0;
>=20
> /* Allocate CRC context from global pool */
> @@ -1443,6 +1444,9 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct
> cmd_type_crc_2 *cmd_pkt,
> dif_bytes =3D (data_bytes / blk_size) * 8;
>=20
> switch (scsi_get_prot_op(GET_CMD_SP(sp))) {
> + case SCSI_PROT_NORMAL:
> + total_bytes =3D data_bytes;
> + break;
> case SCSI_PROT_READ_INSERT:
> case SCSI_PROT_WRITE_STRIP:
> total_bytes =3D data_bytes;
> --=20
> 2.39.3

The change itself looks good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com <mailto:himanshu=
.madhani@oracle.com>>

--=20
Himanshu Madhani Oracle Linux Engineering

