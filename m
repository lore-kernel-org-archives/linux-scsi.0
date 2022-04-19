Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8802AC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 19:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355981AbiDSTlD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 15:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354245AbiDSTlC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 15:41:02 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7E241326
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 12:38:19 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23JIPdqa024809;
        Tue, 19 Apr 2022 19:37:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=2m33RPYguTw389zJiu7Hi+WxMHcrzThOg0hVQVsJVV8=;
 b=0tkKcLg0xytxFftzNI6x0dkT17RRedO58jVuLteXv7C/831YX/AbLpPMLkKZ5ZVHLwFQ
 kXFa28vYLqHJ2FYIj+1qlr8wQCdIfYquM5y29iOM/X91WmT4gXhYwVRlh5YkdxcQ7qNV
 WhZfZkQJiNbOSXAjjEPdDOOyQmoLDI7vcDCcHC2S5ypWVwjzWopSwV30eQw25V1RhL0+
 slwTJfUlaTQj8/4os5zZyyHRtfOrMmAh4YnOBDa2UNlMhWdnJgSykKo1wpQKgPOs4PbQ
 IGVStPJN9zMkrf3B6ylOsPPTM5WE8eg68YKDeONHBtARR7NBISZyaXc5avviwLTNAoTr MA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffnp9ewww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 19:37:53 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23JJQdAd005760;
        Tue, 19 Apr 2022 19:37:52 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm83d8pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 19:37:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4HWiVpWZsq0LJJiZVrtTHfudHhg3t8ZU/5Lx/4gLVdncVjPFd9E/dTW05CaeTobOG+e2JxZK8d7OzAV+eZ1ZAAlnARolmylTLB9yAzuNpVVmJID7jy3UQ3xKigOQ0Ml76Ma/VA+Erhf5ck5dPMBN7jlHVflbemK4Oms239ha8NFvDbFjyJmu3ZGogvRx8ZDKWiFaGcC3HqbRjDvwrrAfm5JcM3pFKjPi68pa4iDlwLj9dGTa7pno1j8nk7Qz30FaDH1Zg9EeS9R87VUY5sfEWtmqYh3nWQn2Z75/JIjIVds9wttWNyIZSIO6VpeMuOtXmJxRRSnenZ+OIa9HXOwGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2m33RPYguTw389zJiu7Hi+WxMHcrzThOg0hVQVsJVV8=;
 b=dfDIL0Yu4KEyzwgQDcQRJQi/QibcNzigxsyelFS7LNo2kq1GQNirUA7Sghcz0ry9QOUDEV5dUHUHjOHMVx9ixKcXM9Os32KfqWHyt2V8MW5xx6RXPKz7RdKuYyP9rUc/xT/FE9+0b97Cv2NxPYe5Mu8O+v94qficl4ZFqZl9fdbqgcWz6Cu0NGAqnzS8cy7fOQCxEoLKwq+vc5Cua1kJtgoMNLEb4GmXttFeRowrVNzcJ58Cj+x3v4PGFdUPMuHgcp+PYBVZY0tn/lN4L6KZ26z6E2cPQB379GSFF3PT4lmvfyAhV/7H21skvyJpv7R17i9sICAFGietwiO78C+Ayw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2m33RPYguTw389zJiu7Hi+WxMHcrzThOg0hVQVsJVV8=;
 b=YQ7+tkeG9oG60nPLeUDznA2RoFf8NaBwXQMl3BIbtflXZyLgJt4mbfJJP0BtzYCPqi1VwntNpajUZPQK7NI9eKBakRtIRgiJXZF+Teps+ynfkgN1RaUyC8tHfxJ4ZiydY/6noqd1+FDQRi0z7FUWk8x71p5Ra3TICZv6L+s3mHU=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN0PR10MB5336.namprd10.prod.outlook.com (2603:10b6:408:114::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Tue, 19 Apr
 2022 19:37:50 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c%7]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 19:37:50 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Chesnokov Gleb <Chesnokov.G@raidix.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/2] qla2xxx: Remove free_sg command flag
Thread-Topic: [PATCH 1/2] qla2xxx: Remove free_sg command flag
Thread-Index: AQHYUMYWYkt1LwLtU0eGmzdW21PURKz3qFkA
Date:   Tue, 19 Apr 2022 19:37:50 +0000
Message-ID: <D1DE07AE-7851-4413-B95E-CB35D156F42B@oracle.com>
References: <AS8PR10MB4952747D20B76DC8FE793CCA9DEE9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To: <AS8PR10MB4952747D20B76DC8FE793CCA9DEE9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61205ef6-d73d-406b-a3f9-08da223c16bd
x-ms-traffictypediagnostic: BN0PR10MB5336:EE_
x-microsoft-antispam-prvs: <BN0PR10MB53364E91138E94C47CE78792E6F29@BN0PR10MB5336.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W/gJk8ACBJRYB6TZ168D50VzO0+fxE+cZfJw/czs4jr5VTdbCISsa9KkYa0QXh2dvv5ewbqULxLoQx5zLy7cUPqZZfYzcCmPkBvE6ge15hs5gn2ntqyzBQJk589V9srxbbkG/sYNi2LJQ3XKyWgaiDAN/I6uTVtwZ24Icgnw+WQMWFSWatui/KaeljpWwq2Tv0KFXQln+VBJ5xXETcZMqcRqoQTQw+wTPApb6REZ7IoPs2ZLzuVUrAkxT1HIYORhywkXmVAC+MAStYQQZGHuwoAd0jK5cEqSGHJ7GZ57vWJcxFgczqYlKlyVOL6vPpnMDWOuffEfczY0mFJO/irNJRliH0HWpjWNue8JKxUKHdoV0XN3Q6/5qzRaZR4kMCUZWF7/aRFfmmGknpahg5b2v8Epb+wTm4XsERv4TI1g4APzI6PdbXnW8KqXoPKrYrcn+YhAYLdaaOfCm1lJOSRdIz5VzMgUnugzJFgJectSTXy10Boc6COgavgvOXiwR86s+rEvUhOxggW2aAZdmQatj1rLiudwvneEotT5SjtduymiQh0iZz6s8NsaziTjm63OTQvWAyvpk9cnRiJuF4ZPLsGV5w/uBV76ZbErwXRzEpEIk8TYLqWCtUpFXt6eq/Id1rpkgnNLimcTyRsYuN2GJylc31FNCfQkXP3LhQ85rj7HGHXOtbh7n0RXCVffT4zFWID1Qxib4jqjfHVwQu7Zm5DVIziAe07dSIJfmNsL+VbuO8qKqrhjLiNKZBwt4lAB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(33656002)(6506007)(6512007)(8936002)(2906002)(5660300002)(91956017)(66556008)(6486002)(64756008)(76116006)(66946007)(86362001)(66446008)(508600001)(2616005)(66476007)(4326008)(8676002)(186003)(53546011)(44832011)(26005)(38100700002)(122000001)(316002)(83380400001)(36756003)(6916009)(71200400001)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sCSRUzcNwF79Fz7hYqGw85g7dOsX5A7yl/YiXM9X1t6/WxgBKRoAfiMK2teI?=
 =?us-ascii?Q?b9WX3+hcmzpwkecKDtHVUyexpKFfNM1tJ7660K8xJZqUNzRQmr/al5agTOvn?=
 =?us-ascii?Q?P9bYOEu6fjps92vPwBZsfxqDR10tsV6pqFi9ZoZ0hTsDqzEVROPaj6z/cYph?=
 =?us-ascii?Q?B/4xblEgmSLOHfcdheRMojmLKppYQ68WUsUR+yHijerzlaZ4EBd08WuI2jY/?=
 =?us-ascii?Q?49d2G3sO58oZ+jt9mg/Li7IUr2jj9SHXjswUZGo3atnw2LPTpkJbkI16iBnr?=
 =?us-ascii?Q?YEGUfwa+/4E8O9Wc16cQ9Wkj0SWfD1jmeJq4QWvpHpxOj/NUkPBv/HzKKhOc?=
 =?us-ascii?Q?CNZRGAgTX4vxqluETxMcfysroFE8AIHPfXdQaHxktpbtREjp/YgBnQODV7ed?=
 =?us-ascii?Q?fWCjHgKs4090MPoIAwh/IwR6pZYLwxMhSSjHjFybbnG4qT+G3KqpPklhHwGf?=
 =?us-ascii?Q?ri/I9j39qVURVsxn9w2gzsv06B/BOTJOKFIjtXTZ2QzbZ4/IP9yNMgFDgdIv?=
 =?us-ascii?Q?7lrnWGI/fepnOCd71nCY6haoXUsMXisq5kQqDecsA5JtwpILA3smQd1XVnHZ?=
 =?us-ascii?Q?pJO5sipx1k7Sik+XwCWDgoBfBeC2aYJ5JhZpLfQO0rWMk1i+bFVv12OqZSLj?=
 =?us-ascii?Q?R/FzJ7kT00le3ciEGtFPP86u0QnEURS2ZZivgcXD3RRguqaqleLHogXTvN3e?=
 =?us-ascii?Q?UIQNtAMeknBKrk4Lqw/TqhFqUkxFqS63hbUULIN58abcGDSFzqDQTqQqr/d2?=
 =?us-ascii?Q?wRy4mvBm3lmYXqR5W2wcLpvPuEOlUFmO63F7XHpL+bGSn4U6bZiyQRz4D98N?=
 =?us-ascii?Q?bxwo9V/39Kr2wtvtGS1rymaa1wWAYK+F1AEhC3Jax0AM4m1s9q7Jx2KAe4qj?=
 =?us-ascii?Q?ufvnxalQ9Laze8rGpyzdgYCAThbkvS3L2APnEI1KxpDp2GQFgd3WfYrrXJdl?=
 =?us-ascii?Q?DNEP4Z3/1NxBP9ORvt77mC00CfyEbYnSXGcQ+/YdbsxGwivD+fnJ4UG2biut?=
 =?us-ascii?Q?OI8H9OBp3I7ojOOmd3KljzNtQBFCU/q26TaYxXZ7kbkuVmBo/8AuN7lyMTWx?=
 =?us-ascii?Q?BOEw0dXWP6ZrCXJYfStq58BoOyT6hdNGbT9x/wPYGCzSLftoUGOtWjm/DcjG?=
 =?us-ascii?Q?gyaFcFSd/1Cm0Sc7rmU031FITFMYeYk/lNfYm+77jEyj7rTFzaIbdKiQLa85?=
 =?us-ascii?Q?CzXiITdn8IlZ9hu8JXRo9JvwfPWeNgYvqokLDgG2KwEejZPzQJVqqyoE5ADY?=
 =?us-ascii?Q?1/99P2yOUAYRENJ3bHavGkdzkgdKB4gTKC8Vom9Fv9m/+Ji9jzdnjKtR2dN9?=
 =?us-ascii?Q?Bcyc+9I+DTCCLSB5MxnpSPqGj66f+2Z/dpUYFduid6IBvLT1x+oKARzu06D8?=
 =?us-ascii?Q?/ePm432qkdes6+KsILUeKIsBvMthMNjUB0Cik4K5YqIQIq3mjrsVU5I/PVHP?=
 =?us-ascii?Q?LvRzeyaOyU3uLzrLfJrjYMsMAi2TS0NCBzQDwjticVQvNZibCJiGtbgoPXrK?=
 =?us-ascii?Q?N7asKVwMbqdaqHqzGAg8NrbN8Dk3zs08SJIk9lr5GeyTuHAOTr5kLWQP0XYe?=
 =?us-ascii?Q?lnJRY/I++rVmFnqTLHCVlR5fbq5zvwU7/n6t7jezXmfA/fcFCUfQ1OJRlNED?=
 =?us-ascii?Q?QXYXjAUlZtlpnDwO1q2CDoUKLHNfYK5Fne3uNWA9PvIQEpyozGBA+Sqt0X2a?=
 =?us-ascii?Q?cBma/9gTPtl1stgwFqPvH7hJ2W3u/gQwqJizr48HOHiKvkkXLfYlw+38WcfY?=
 =?us-ascii?Q?gEmxLxB0LUBXDaRGcW4K+WoeWgBJ6r+b8osICucJN2DOIoZOeGMH?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4BE4BB2CE6C2394D935A88C975B92CD0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61205ef6-d73d-406b-a3f9-08da223c16bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 19:37:50.0630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7GnAAoXHIs6docXmrCbdj74iL4mf1EIqE3GLP+/k6Etd5/aQNYRDYswMH7osHDC4Lx+n6dqmGn4c3A7UBN2iGrsMobC8X+oAZA5LpvtKw6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5336
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-19_07:2022-04-15,2022-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204190110
X-Proofpoint-ORIG-GUID: Ermz_iNPLUGDzc-oHq1Ac47xC4sPcvXU
X-Proofpoint-GUID: Ermz_iNPLUGDzc-oHq1Ac47xC4sPcvXU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 15, 2022, at 5:42 AM, Chesnokov Gleb <Chesnokov.G@raidix.com> wrot=
e:
>=20
> The use of the free_sg command flag was dropped in 2c39b5ca2a8c
> ("qla2xxx: Remove SRR code"). Hence remove this flag and its check.
>=20
> Signed-off-by: Gleb Chesnokov <Chesnokov.G@raidix.com>
> ---
> drivers/scsi/qla2xxx/qla_target.c | 2 --
> drivers/scsi/qla2xxx/qla_target.h | 1 -
> 2 files changed, 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> index 85dbf81f3204..2d30578aebcf 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -3863,8 +3863,6 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
>=20
> 	BUG_ON(cmd->sg_mapped);
> 	cmd->jiffies_at_free =3D get_jiffies_64();
> -	if (unlikely(cmd->free_sg))
> -		kfree(cmd->sg);
>=20
> 	if (!sess || !sess->se_sess) {
> 		WARN_ON(1);
> diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla=
_target.h
> index 156b950ca7e7..de3942b8efc4 100644
> --- a/drivers/scsi/qla2xxx/qla_target.h
> +++ b/drivers/scsi/qla2xxx/qla_target.h
> @@ -883,7 +883,6 @@ struct qla_tgt_cmd {
> 	/* to save extra sess dereferences */
> 	unsigned int conf_compl_supported:1;
> 	unsigned int sg_mapped:1;
> -	unsigned int free_sg:1;
> 	unsigned int write_data_transferred:1;
> 	unsigned int q_full:1;
> 	unsigned int term_exchg:1;
> --=20
> 2.35.1

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

