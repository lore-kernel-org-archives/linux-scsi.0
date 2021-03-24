Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D627BC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 16:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A286461A0F
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 16:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbhCXQY5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 12:24:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56260 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbhCXQY1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 12:24:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OGFd4o036729;
        Wed, 24 Mar 2021 16:24:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/IJODKdWLfl/bF4ZxEEtAPg+WKfItuMphz4sXdIToFA=;
 b=NTUptCmC/GUYt/XbhjWEVA0GvcqYsx197m4pGPMaZFdCHox3dcHuN2uq12hH0SWU4Adh
 SDENqBlkLESOQwTBB3wSw+0k9JbKh4FsGT2MmLgT+vIZ3dXhIxx26GhlSso+x+44xFvM
 EKf4mrN/huqUVjetLIVin6mvz7rwieWjFZs2SoqdZFatumhgT1q4sqf6XcCscF3j/8gs
 t1DH15w6nhvjiP4LDmglb57QcpN4+S+Nv2ldRg3xUhKWcKQ7g+Rrmb5ror8Jn/bf6/2V
 Zv1Dgm+1rpJ3Hu4BDgoQEsX0trSyEEBJNGwQC61OD4q4VT/vdEIBAwTCGBh3H12r1fHZ HA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37d90mkbwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 16:24:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OGGTVZ195828;
        Wed, 24 Mar 2021 16:24:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3020.oracle.com with ESMTP id 37dttth2wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 16:24:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jk96z1t/SMOdh+BIKEJZ1CsbqvWPtcKIEuQzbGAXrW6gMyw6OI/F8GJfAHVPFiIBVx/RlKI0nReHv2M0KIFyhjbxG8X/nUg12fgu5IsncggNyxFka0sHiXFQb+tjuS3uGgZvVDzMjIHO9zMnPWVRBFn2hziHVDaKRyTtkpPgV64Q4C4/tuAvZxsNZFVEqMUcjOzJeDfkhm0SwqQxKqy+jf5FJowcoALI57d1jkWiulhH4i8tg9QS6AwtVZKsb7Q/7K+LmiMTABJM6wtjjB3UnbzYX4ho24Vlx5HkbVocjoZWqD4ajxvnZA43xcCVoKK2dSrmM8AZ/p88+/JAlPx+yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IJODKdWLfl/bF4ZxEEtAPg+WKfItuMphz4sXdIToFA=;
 b=Ys77m6BFAiT94QTsT1INTdfk/yMVnyBtYtNVN0BPNB3t+5b+E5e5KmAKp+8fi6LtNKFd4tdYM1H/jBoyYpDlnm5ZXBSv/l6iSIPS8Vo6S2fM06fF33IBjAdCKaYsp6zl/DALKeNlgstgG2UEU7q2NFanQ5fAWBhKe/dieZaqy0tghtp4zg/3mWYCRG+WfNIExmBFs96NUcH4erEl+0tDYjPA/zI/Vupy/f0QfWaq5baX+iUqGSbgizzZAwLM2jgZinJAMzvvpMvL+b55JrAGRxcic/FSPk84cs3YYGDUTF9/PZIy82Q4flcyCah2XgGVIY3NGMSZpDMVlSZ5L8xCjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IJODKdWLfl/bF4ZxEEtAPg+WKfItuMphz4sXdIToFA=;
 b=DvXsz5csGAzeSD+tGrzUMNdsjHHtIpvDmlN67jxPWga433lSSX91Uw/BQodC9+JbeJz2xkHEIArzKTKyUcNLiFtMq4ucEd/Y+COM+PDBQ97Ul3E5hphX6qROdwbX5ZaNk4xvNTvTOkF0MNb0LtiuGKI9LF0rJlVI6n4Dl04tVj8=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 16:24:23 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3977.024; Wed, 24 Mar 2021
 16:24:23 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 10/11] qla2xxx: include AER debug mask to default
Thread-Topic: [PATCH 10/11] qla2xxx: include AER debug mask to default
Thread-Index: AQHXH5/EnO9EtKwC9Uelru7XyAJch6qTVQ2A
Date:   Wed, 24 Mar 2021 16:24:23 +0000
Message-ID: <EA7AD62F-D090-401B-91AF-5879D144A11B@oracle.com>
References: <20210323044257.26664-1-njavali@marvell.com>
 <20210323044257.26664-11-njavali@marvell.com>
In-Reply-To: <20210323044257.26664-11-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [71.42.68.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3c931e5-30e8-4df3-b423-08d8eee1491d
x-ms-traffictypediagnostic: SA2PR10MB4795:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB47952B274C8A2B96B357BC20E6639@SA2PR10MB4795.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:541;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7q8vdwyHkXNca2mdl8o1/JyQaeGs/2PUbdanUIt/yK2b6xcZS8bz6c7ANvWgG3BtXQPWrwlgf2l5YZNj+iq5E0GRuM2/e1kPonYA1+BSQinRRc/DgaObDgCuF9kFEiKy8zxiVpCciJXOGEvRmtoblTi/CVIk43+lLlpDyy1eaYpq84jwpNVxjNyQJ5EdXijR2K1NG3B7aRTHujsn6BkvqjNZgIFLkqHlzSSX9YZksZz8YDENjhSf/fRwuIW0Qm1MHLyWudGm/IZ2z0KXScneZcwteTz0eS5F6VWzycFHg6RDZe72XSzaeL0siAyWNVYql3v+MAGb+Id6EA8OpYNtDBC/fjBrIVnM5uH441LBot3/ZtElbgILiO+abR7QhzY7vFxA+Z3mQPHkqiGdK7wBT75GOgRfhvRYVjQG2hLVuw/1FFaNYtWsJFQBjvRpZsInXmOUx75eXjzJIM/reiK4JoZfe+xjjdHIYCqzQ2VXG3Ue1aNA1TTisKqRFTaEphkcZ4cbXAj5s30huKNYQwN+Jb6p+8dcsCvDNvpKxy2YS1cuTVROe/TZN6rA9m5PoPAe9CyyVI4SSFotB7sI1+UAUz4WWM7F7ST0bnsiF7Rb0HR3kQS7RbP1YbdkWcy2FH8wHk7MJwtlwcFq1Wkr/rzQOhtWX5/Ubk6HAJBe3AXQLizCNdE0vvtSuvTsyzK2oqCV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(366004)(396003)(136003)(26005)(54906003)(186003)(33656002)(316002)(478600001)(38100700001)(6506007)(2906002)(53546011)(6486002)(83380400001)(6512007)(6916009)(8936002)(86362001)(66446008)(66476007)(66556008)(8676002)(64756008)(66946007)(4326008)(76116006)(44832011)(36756003)(5660300002)(4744005)(2616005)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?o+Xzo51H6EUr1JjyCXoTz2ne5kWpGOONWlNX+uCnzO6CbpmSpnIcjj5EPgwB?=
 =?us-ascii?Q?aMutbhfCeHLLAzXyxtQ8w3KtUVngmZWAmwSnoCnn8Iyr3/ygGI80cmpRAlts?=
 =?us-ascii?Q?tCG+TR1kzsoIXGPPcGZm0lnJraC9tIcMywAa+ovRycI2uyu5d58GaUzZJ/85?=
 =?us-ascii?Q?et7mwHcNngdY/p5kNu1ag9NaSilBi09NiLI+pTPdgvCyxU+MYAfG8xUNQQft?=
 =?us-ascii?Q?XIa7Wc7EZQJo97GSIV9XdAhjPkEOnhdYmYdaQnnCKDXZMqFH5501smX/ZZU2?=
 =?us-ascii?Q?QtIGhmHoF7IHthw3+FndI1OILAFghVP3a88HrmbgKdeYaoRa3KgWZMA4NAIL?=
 =?us-ascii?Q?gAb1PvXwk/LBdPmU0UhXq7A3MN+uwq1+xFSCZMepi4/P9ZLejahyfaXoxbwt?=
 =?us-ascii?Q?F/xCQ4zEb9ErAIcW7pTYiY83S4EtDXaxSobu3Qpdmsdef5G2gMU1kmwoZXpJ?=
 =?us-ascii?Q?vXUFu1/oKfFOrxCNg/VZxKwNZ9k43rP4T0mBAOT2ttwR4zqWyCG4hUJGLaPQ?=
 =?us-ascii?Q?8hpN7LFNXww7Wx5JVxR45dxl+YnoX3kVCSMUvpNe5AJZiRx2JoQdaM+57dBy?=
 =?us-ascii?Q?KaFzCJUl0od4ixvrxVyAqqwAsu6FwPyqvli97M1ygwsmCZC2zAHGOcCunccI?=
 =?us-ascii?Q?DngYHTn+y8wez7wgXYvAI8GeYP0sfxlGhXK78IG4YgJkzC1Spq35QlXK9jVf?=
 =?us-ascii?Q?hr7CyeviV19tXyRcpksd6Trff3aHRLUS7ujO7N6XzYwnxIWqpJbf+qG+kkR2?=
 =?us-ascii?Q?3Q9KVOlZ8yrEZSW3PuEv5aVYmkRbOHpkKbV9hJCRq5Xhm6cM5nrP96rRakBr?=
 =?us-ascii?Q?LuS5o7YG9mOQyRgOTy00yk5oSgyYojtBxnlpmZIZratUURTzNxrp32s+Nbp/?=
 =?us-ascii?Q?Lt57341tNV/sXS7Ba4hA53Nc+sGj4J2l3FXzJOkZftxLpJGxAVnjBgJEWd0f?=
 =?us-ascii?Q?ILaNHabWYxoDlFX7d5HS0o+2W1DoqEekYJa3OFQfjwQd176ZiHfxhYjj+Xem?=
 =?us-ascii?Q?i0dtNAt/sEi1wSLLaBFa5+s93OZ9Yg1KfDs121UlZ0mIv0+sLh8WDBapDeKL?=
 =?us-ascii?Q?lXGiNeLUqWSuujxIYBdyNE4u24rtWIUClWIoqsNylp24yC99raGO8GJVByLY?=
 =?us-ascii?Q?V2XC6rW4+axzslQDhvmcrvIPiKnTzLPAZmFaPk3AKSXhJJzx35YsezVbyNVD?=
 =?us-ascii?Q?aLdo3aGj7M6kIkb4NRJT/VtWo1SGauQz0fsBor4fFIicKsvtFS+LN0nD7wCy?=
 =?us-ascii?Q?DABdrXbB8edq3Cf/DfkjgPaC696CsGdzcnl4Pp7Azj96zVr9M3K8w1EGWDJB?=
 =?us-ascii?Q?pwn5xEo2dZ1RZpKqvDpuDNNl?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AAF80DABE2AED1479ADC06068DA8531E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3c931e5-30e8-4df3-b423-08d8eee1491d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 16:24:23.3911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IC/b/Fs7n2YsG3HBZQfsje/+EZOg2Ci8Ysf4qGjISq3fcveN1yqtTp36N8+mdvNQrQNUj7v/a/Mk9tVQZsZ3a4JkgO4jfq0EIayXitnE+ds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240118
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240118
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 22, 2021, at 11:42 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Use PCIe AER debug mask as default.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_dbg.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_db=
g.h
> index 2e59e75c62b5..9eb708e5e22e 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.h
> +++ b/drivers/scsi/qla2xxx/qla_dbg.h
> @@ -308,7 +308,7 @@ struct qla2xxx_fw_dump {
> };
>=20
> #define QL_MSGHDR "qla2xxx"
> -#define QL_DBG_DEFAULT1_MASK    0x1e400000
> +#define QL_DBG_DEFAULT1_MASK    0x1e600000
>=20
> #define ql_log_fatal		0 /* display fatal errors */
> #define ql_log_warn		1 /* display critical errors */
> --=20
> 2.19.0.rc0
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

