Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D5FAC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 14:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76CFC60F8F
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 14:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346604AbhIMPAn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 11:00:43 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:36942 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347606AbhIMO74 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 10:59:56 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DETnRl019780;
        Mon, 13 Sep 2021 14:58:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+W8bve8yMXLauSvweF5g+CtTHvR+u5eD5ZOsGB3Kjfk=;
 b=wWaqbOA1XNxBhi4HeXUotYAboHVwFkPNLnYtQ4hXyeBvHYItekXSvbGuljV8J0BJD8jM
 we9APXpk9vKStA3GaPqOJ66HnZagugJhvYcwRLaxqC8yyKUdZ5QetX37bCvBbfvKcLu8
 BIXKf5nir7q2Dr23gutf29Aw4jjbLySvuJCI0fN3k35UjutGMMZRyi/uXj0CNIM/8HY+
 I2rdkPpcTZNE95HHZQ1esKxOxnaoYwNI6Hvj/5v8JYDb12Teye2HwcBJUI+cQ1FSZpAS
 gWag2yPX18GVhnMmvjIXprz93tmQrzy5R4snpSbAfxN54ZmkMIbdI2LDguSNee1XQyIt cQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=+W8bve8yMXLauSvweF5g+CtTHvR+u5eD5ZOsGB3Kjfk=;
 b=PEwUSEH5KnILIHFdTAZWgg1/XhyiQ7Yz2os0UkT4wzb+kDK68R1PxqaqwwdYtw9h/SvI
 Qm/SBjXGH98lpL9LAcevo51Rx44dOs247vpsWMvpUeVzMcZrK28S3vqmRDrR2xpgbEWM
 NyHdWddl1B046uti+CIABcmuwZ6KS7rfM7IRGyi2cQcRn/FJOe+PI9Z6nvLNhoDGHLuX
 BUWZfnSCeVeVmYt+Gh+7CRelRmABNQvm8C0X/v3NDPlSQxdEHfaGZxNR83pTOa65MxO8
 3fqRe61GIQnhNMlAHxbW6+BUqlGKghmChYSn5wGHpFiVLnAvxMuAu01yA/Kc1+JSN7ZF Hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k8sawy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 14:58:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18DEuLrx010222;
        Mon, 13 Sep 2021 14:58:26 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3020.oracle.com with ESMTP id 3b0m94tuyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 14:58:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dfdzCFR+QymsLd1YTBPMLnjNaN6jvWBhfIsZ8Lm7t9sjWqDIi1hwk+mKDZQhmFD7Ien+TFAP8JWoT9HzbKQjjoXel8ZXtiUD1PQy3YqBRJ6DaoqKf2IeX+IMV5vfDC6ca68OiSetVqqjDlJnsn0TRCIBfWI68ntciUCMErJgNmddvOOVWQ7DTkIXTLup4eAIdkWPR3L2sfyEOhEHm0YJtjkcJYr+dgx/dJlL5zqzsigztUO3riVwBYsi77ww0cToqGs6tCCFFaJdO8GNZMjbglz1FmQwZoL1Gcoq/vvwUCL/86mBjh04UZoo2BRd+9QzgDfuXkAZ22WMVerQlhXR8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+W8bve8yMXLauSvweF5g+CtTHvR+u5eD5ZOsGB3Kjfk=;
 b=fnO1TjbYE3AW/gV0E6EmrThkJSSj4dlT/KsBXYNNjokiUrP0DcHhdjqDllYjyiI3LMppbHy29sA0Q3ytu9aN/9+5AKeT04KpjvID7T/GV2RMmcOC7zglaFc5BtQnKkJO+hTjJq4VxIYmxR1JNpuf7DGxOy246QnETcapQWPN0OwyDGj/nG8X0S4rsrDC6pdRJPItpD/fUwxjqaFKvtI9ViY+4ofBZAiL6VE5ceDcEbhrQ8Vp2FaaCOw9Hw34CD1fUlc18ZufrzthMBx1Sacm/Jv67iywv7zQrUfLUTy8g4IEU96sBq1HpeoBjs8oiMqbzNhFCabBg0hEuNvsoHg5+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+W8bve8yMXLauSvweF5g+CtTHvR+u5eD5ZOsGB3Kjfk=;
 b=J4hIr4AvhNKjyunvuWmZJiDmb4vpjpMlFI6Q+NJFf3PZ51T7PVT/Vz9Aj1Syfa9fZyHr6lk84sMlM4vA7Ru34HEtJm1VIVBpHEsd4gneaNyuHXsXuwIS6EBGc4dot/G/oangIj4Omq5zQFIwC/x+DS+uc8iqCYR5Bx0mthI1gis=
Received: from BL0PR10MB2932.namprd10.prod.outlook.com (2603:10b6:208:30::16)
 by BLAPR10MB5233.namprd10.prod.outlook.com (2603:10b6:208:328::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Mon, 13 Sep
 2021 14:58:24 +0000
Received: from BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::f5e3:a62d:908c:e976]) by BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::f5e3:a62d:908c:e976%7]) with mapi id 15.20.4500.016; Mon, 13 Sep 2021
 14:58:24 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Colin King <colin.king@canonical.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla2xxx: Remove redundant initialization of pointer
 req
Thread-Topic: [PATCH] scsi: qla2xxx: Remove redundant initialization of
 pointer req
Thread-Index: AQHXpjl3+ykTyZf5YkeOSBBjktfF2auiEyWA
Date:   Mon, 13 Sep 2021 14:58:24 +0000
Message-ID: <071BFAD4-9821-4027-9E3A-39D60A2FD4E7@oracle.com>
References: <20210910114610.44752-1-colin.king@canonical.com>
In-Reply-To: <20210910114610.44752-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6dbca4bb-95f0-4bd3-120f-08d976c6ef6d
x-ms-traffictypediagnostic: BLAPR10MB5233:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BLAPR10MB523317C45AE558004ED96082E6D99@BLAPR10MB5233.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:359;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pFrDY40MKcTU6lpvGzJi+lkR0WN8CNUgoKel8ueMhax7A2GXU6WMnXu5ezMVWqKdlw92JhpV7L3p9rQ6+YdRAK4fWGPQew7bG3Ot/hqByEtzzn3/TvJd/dOnWVsvAZOHC4brKwo7A4z84Qb+0Zi+4/BmTJ/jZao4z90wuUaOg946nHcRggbxN+i22E0qgqXL9U56V6thx5QWklDM0pwJCN65aPlsAKq3sA4XerAMY4AepoLAoKHepM5BVHVJ5tYSPjvpAtcQtTQGqc/jRmBxyeBkJJGA/n2CXawsmJ6qo6yvNgFs9qPrIetBV1UUSv02ZFb/Z0Zfz88hEZOPxLFS22s1Rgfr6etfPGsEHhPHKMr1hBFL2YFTy+EHAmI642cLBr0WmtvT2JlHiuai1Q+pyuIFKonQTqMG+sBtqwb994VT2O0M6hA5T+XLB4Nt5NKvCkOfeo66g6NOwWkgZn/P5jEHxNH1xifUbT/YbSI2jAspJFVpNIAEt163zRsqK5NKInhIPN2PwwetVoUtpw9oUXj67TZQBZPKlWv5gT1DKWe929yUhtWmi9Axqnoi7pzHRdzSD+24K3RnFWoS8Pz8rP7H9edKr8TVD4rOHhyqa01I6W8iGuVnNN8CvIhdDwV8zjSaLgR6WND4pGz2xOgjugLNJdBJyuhBoF8HZf7hwcJ4ZJXz9VLy5FJ5Nfa3P1VpjaFAJlS6P+Qk9wcVMDv2lIsR1Lq/cRdeUR0jNXdRwPoicifa1UZq/+OGRTaSInAs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR10MB2932.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(396003)(376002)(39860400002)(38100700002)(86362001)(6486002)(122000001)(83380400001)(38070700005)(2906002)(66446008)(64756008)(26005)(186003)(5660300002)(66946007)(2616005)(4326008)(66556008)(6916009)(71200400001)(8676002)(8936002)(53546011)(91956017)(6506007)(76116006)(478600001)(6512007)(66476007)(316002)(54906003)(36756003)(33656002)(44832011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AJ97LeIz7JcsegSBodEU8wyAPpzU5Tg8Bhos+YJVCRcvxZ6tQl+jZ6XL+m3n?=
 =?us-ascii?Q?bIuRJOG07N+RZT3mfcQT046IM1zpoUgETZHyatR/BMtL2iw2kYV1+XqMMp83?=
 =?us-ascii?Q?OtZsUWtValppUaVRY1kNq2hy+KmBeIP4UpwLDZimqqXywWxIpTsHdo/W/5cr?=
 =?us-ascii?Q?FkiCb2fAX7azs0Itp1JmKKytIAsMcujNKPaoHfAtLxL4VmMLSE++YrMgPFwA?=
 =?us-ascii?Q?yFkKJSZEGeSLHWY1+Yvwq5jNvihtUqjpyKiDU26IIWUireu3EiKoXzTai6J9?=
 =?us-ascii?Q?jZ3N/xX0CE+0S/mda/nWSZELq3wVIu0FusElB9CTjedvGaHB/WQKDq8BDCUu?=
 =?us-ascii?Q?3JZYgjXikqVKkymuu3E047+k4EqdNliQNnWWZF5efJTZw7x+DDJ+j1xZ7C4G?=
 =?us-ascii?Q?O6M/Hls43pVC852ojHPLVEpPRJl//Uf7IBBQzUEjE/+ioaRl3zSviZr7D/++?=
 =?us-ascii?Q?WrcnhRw4WxkanyOhYNovndUn0aMlZG013fmVgoZuiGBPzglCk9pdEAUAO3Rw?=
 =?us-ascii?Q?zJlCE37kTlmPkVCuG8usz4S5wgNjn5OZ5Db4LOribh43iKaxivfQxa2oFJJa?=
 =?us-ascii?Q?gUhWjbvfTK8ujb4SBleinytwCNijQkn2U/mBvrkgcT+mTwDP842VDEqUFlKp?=
 =?us-ascii?Q?5XVH6G6+n2w1bdzGfbhkn6H4V3+8tpE8VPScE17kvracWaODPvUyz3V6sJMO?=
 =?us-ascii?Q?6PIClXP+QUmFKwO9bnJTiVSQiI47yh8TOBdKoXIY5HBkfPf82sEdUBQREE+3?=
 =?us-ascii?Q?fozA+PAhKtz+6gHTE8I0kUx6lgbAHAtOWeT6ULuRDkGaTQw47BZuDOp7jQqG?=
 =?us-ascii?Q?vVPZeOLDe5JOB1zcmH7zg7jwGk4kLUBWhx9WYI2NW/5/uxGt4tNnRXM2A6zy?=
 =?us-ascii?Q?jXtZEHrQYZvtvxxp6vcMP6/yOaKrcueImHBFt2pu6M72wj3J8EOIvT1MsTo9?=
 =?us-ascii?Q?04Jx2LJoXTDEiMOZHVOzA/SkZg0/H0EW05/0aI1hidKe4tZvKXuVBeB4AVhv?=
 =?us-ascii?Q?Fiwdtea4FF99G680qZ1BWA2ZjWU+Anli5YyV6z6NEW7dYAYTFEf6uTiu+oY4?=
 =?us-ascii?Q?gaCZXx74VwqWMjoLi+DUbMrAs1mICIlEYD3kKgSseoby90zEyp1FXEQRB9EF?=
 =?us-ascii?Q?R0CDZ5Ig3tuvvruSioc/SmW6DTxXuZZcxElnMllNcGlAXwvUa53aLlIvVD9e?=
 =?us-ascii?Q?Ltz2NZyuCm/4In4AiOgesx500UD3EcvI9Y/ioj+oX65i9wFU1fnhSlIisBia?=
 =?us-ascii?Q?rrFnYaNEHN+S6STEGXWO+qY9J1jK9mIiGKSBFwBD5BSqy2sFVp4rVu1LoAUy?=
 =?us-ascii?Q?0DNadYD9l0pD+tla9o2yNedX4X9ReG+n0vUu/pCWir0CYA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15A3A521029DA743BC4CD22EEA325BA0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR10MB2932.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dbca4bb-95f0-4bd3-120f-08d976c6ef6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2021 14:58:24.0761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v62eKS+SMOieBqW8t/WcFOge7QcpG+KIN9JCQMV68nhjhgJ2SeCtt4nIb6mFj3u5A+1uMMvbUpM8DeWnYneABu4JdyL5KV0mGms9V8T0PNQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5233
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10105 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109130099
X-Proofpoint-GUID: -W5IYuGTGopyIjehQUCG2AKk_C6z7nIq
X-Proofpoint-ORIG-GUID: -W5IYuGTGopyIjehQUCG2AKk_C6z7nIq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 10, 2021, at 6:46 AM, Colin King <colin.king@canonical.com> wrote:
>=20
> From: Colin Ian King <colin.king@canonical.com>
>=20
> The pointer req is being initialized with a value that is never read, it
> is being updated later on. The assignment is redundant and can be removed=
.
>=20
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
> drivers/scsi/qla2xxx/qla_mbx.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 7811c4952035..b5e21fad9551 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -3236,7 +3236,7 @@ qla24xx_abort_command(srb_t *sp)
> 	fc_port_t	*fcport =3D sp->fcport;
> 	struct scsi_qla_host *vha =3D fcport->vha;
> 	struct qla_hw_data *ha =3D vha->hw;
> -	struct req_que *req =3D vha->req;
> +	struct req_que *req;
> 	struct qla_qpair *qpair =3D sp->qpair;
>=20
> 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x108c,
> --=20
> 2.32.0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

