Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67788C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:19:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239519AbiBISTi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:19:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239483AbiBISTa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:19:30 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95ED5C05CBAB
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:18:40 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HLbd4013346;
        Wed, 9 Feb 2022 18:18:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=vIiwQldpYzzT+uqoeLljxHQWaTyrtQ1LGvQ7NOYuSvw=;
 b=CPSfy9Wh75rjl4ZwoS0xgZOskaH41CK3nDxUCRGuts4YGooOR/bDgxpBVDjeH6E1CBR1
 Cbn6rJ13WD8NRuLCoEHEihWodW+ELMnaf9c4wtJ7uwTDggwYN23v0h5x3yoZU0vIOts8
 /E0nm2H4pF/Yl6fqYkmh5fpgMhc8jX/E6OqDsC2oQdjprzFv3+uMeZD4uH+DxY8rn+Ls
 DgZkbS67Wq7aGMRMLGVAfVngYZyhnRvWXd2/f1MNFjhPuL83UmX4w6hViUNQBl/7rr2l
 mSteGU1pZZWmWrVj5HOZS9jF7o57/eq+zshW5S5Gv/jLJ/7M7WpAmUT7RQ4iEeLhdAEo 8w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e368txmbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:18:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219I29ba066987;
        Wed, 9 Feb 2022 18:18:10 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3030.oracle.com with ESMTP id 3e1f9htbxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:18:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bW1ta5Gm0tne3DYC5vllEpcWCYl8cmIaqtzYotWsR41UCbntINZOB6IjzHCgIlEdTFeCc5Z2D5ensd6hjJDk5Uj11NUxRfdW2zlFLtSYraIb2QRdhwy4V2+nMDiuA9a1t8cl8FI46kryHNL+M68tRuqHNv8dCyQr7KPF5d+4xi6Vl3b3yOLKum0mLY+n4zD3CIfGQZ9SpU/d8zoDDA8bp+Na7VU5ptGArYp0dYJ7OJmN0EsYLJmrXH3tVV+/H48l18tBhui8N3578U65VWTlou5qv7eUSAgJHWsjRmrR3zEfei2CwO37utPkVsrHnw8gkZDFC+ZH9dYsU5VCViLGmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vIiwQldpYzzT+uqoeLljxHQWaTyrtQ1LGvQ7NOYuSvw=;
 b=dcLIywx9R9SfWPOgI0rcfzl64V2w6hrP5Tvqd2iYgTAKRXHDrvJUOPL6ecEupPxAoscf0iw02YDGbWlSFY9HDKiSs5BtAfwaUUiPqqg1HYZezv9GHmZi9CwpVTtR7yAIhzvPJxSTZDPGkZQ8hc2S/5o7e+D8YX1tfdJsptjC7GQZ7T337ZKGASdnyqXqFt7gWet0s8vwQu7fA/ipFt+kOxjbqEVyuZ65L4UuR1qBA764BoC/7XbpRKQyLANYDZwYD+uSBNdF1hjHOl3w45Z6Z3UhXmUeq2YR7NknkmObyeetn5nIpzZfuIKVcyesZ0A3mIMW38/Iuq0GmjbUWilhfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vIiwQldpYzzT+uqoeLljxHQWaTyrtQ1LGvQ7NOYuSvw=;
 b=QPWFRXteiUgVkKFPCD3gp7P04vM5XEw4YK9eCMfwVomyGSZ36PnnJvg0OODWl+1TR93sdUN//LdqHdJi8yhca4XdW6GnHpF48AqKCB7lxekmO5L/Zlv47B9YO30D9121Yqo25k2IY0E3LK9ra2L4Sv7Yw23dyYwxaDLQ6xRBilY=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN8PR10MB3252.namprd10.prod.outlook.com (2603:10b6:408:ca::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 18:18:08 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:18:08 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 20/44] hptiop: Stop using the SCSI pointer
Thread-Topic: [PATCH v2 20/44] hptiop: Stop using the SCSI pointer
Thread-Index: AQHYHRE4nr7LbnXbMECQclwHYSJuQKyLiKOA
Date:   Wed, 9 Feb 2022 18:18:08 +0000
Message-ID: <0C681D90-7B63-4CC8-8C55-BD9352189BD2@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-21-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-21-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77f76394-4c15-4ab4-ec55-08d9ebf8862c
x-ms-traffictypediagnostic: BN8PR10MB3252:EE_
x-microsoft-antispam-prvs: <BN8PR10MB3252D9D61CD9A108392F2190E62E9@BN8PR10MB3252.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1VX1ked9SSJcWrY4+ijE035dm1S3UpN0OVwUziTQ/kOvahXTGwiGAA+fkAq6qtU6Zd6wsQOJmdZL1CFAW9JnOUdtPifpPdEDBAMEtT88+McGcQwUumGwg9h0Aj7domh0sXL06WSeASVXrxvi0iv/KcWKxEffV13ChFTkP+B7auopfnksHXAKlgpnmO51JXFj3oQQRAHy3n/oaYvAQrVw4K0w3LJs9fh/Dw3J4Z90IGgzoRqWQarrLvmNv8qZn/LoUH7alA879nGp7FL+dgPIzfQGqNZIEnhZgYu3PTo/7HPZfipoVMfPn7bjsRrnDFHHIq11hOGjF91MhEYSrr7B7Gq/iqQ27RNSRzYKhW93Ng2bm8mQlTHiHOEQC83RercJl2QeoiLMBh/Eorl/dCnhlXcIlr5jZvg7RRCkBRDBHFZiUlZPXWeZ3yokiUFzJONcEt807p5ABd8EwLCEyRyYD35wJrr4uirOpsdfRSv6AAO1nJTbMRx/G3dhHgEGm3tHkZrwz8MJIJamKPpvZwC+SbO3HEC8B8t8rUkzpFotZPUG1tSBUvhIxhkerv+bd33cCS7+be6oVgIZvjxHpv1VDWCcgds0EY5le7kxGSyHxLO8/vH501Pt9tbfpAtCKqiG/vKMbARlatHuVxsS09U1r7usyNgpbSLXhTBJCL5HGa/H4pgOC9VhOJv5xfjvDkuzBKEMmcHAi1xorHmpXrNBz6tEahhGcaebK7dOpTdD8m9rzPylqMir6oqDkfnMooBY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(33656002)(38100700002)(86362001)(122000001)(71200400001)(8936002)(44832011)(5660300002)(53546011)(6512007)(508600001)(6916009)(54906003)(91956017)(6486002)(4326008)(64756008)(66446008)(66476007)(66556008)(8676002)(76116006)(66946007)(83380400001)(186003)(36756003)(2906002)(6506007)(316002)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DJuZuRPyuY1WLoqIsQIPCa3r1GgE3e9VeIQTF+mUhGqGBmtzPVeMUQfhDh29?=
 =?us-ascii?Q?xhP0YMBih8Jkt5OMQB6qXCxUl4xht/wCtGz0APsI4nxJOxEYQf5l9a/gHp4a?=
 =?us-ascii?Q?I17LoDEueIj+ztxXD4rcZofgdXF+/HWvhv3NPwZLmWejdG2iCGXl4DpwQWpI?=
 =?us-ascii?Q?hFirDtOzKZ6vZ/+tOo4dnxPukQCKf0TBVNzdEHLDlSiL7FM5qIQPgACtFQmL?=
 =?us-ascii?Q?nLYwe0y/1xm6TNs1DSJKek3NPoSxODqqytr9BqF2iMU1JgYtHZpte2yayP7t?=
 =?us-ascii?Q?nKwOReu2CFcXb2UvsO3wpkzYpK02ouH46YFKfC94kdOR+ligXPg5USoGgEXR?=
 =?us-ascii?Q?pU8yOB7hxd1j0oqsw/yrjpDkqYoilsQiU9vaoBFy9T72wP51BOUAbNhQLWjg?=
 =?us-ascii?Q?mSUUmy6ZhW1pNg4WtiuZ1UYPOXuR5gm7gPS6KLovwmnq9DxltEa1d8H4j25E?=
 =?us-ascii?Q?tAHo7Z6uvvNo2Hupny4EuzgIxZ/DacfvnQS1QawFBjGTyXQ8olcv0TztLhou?=
 =?us-ascii?Q?Yewryfudf1Om2CZUp0yqxQmyKGC7mGdyw9bHksLbzfQtylTOBuFxX3prQsnK?=
 =?us-ascii?Q?pADaCndBJsI8zAUWBgBGzdlONqdwda+F+OGOvGN+WAk9pyEyImj+6CAzx0sE?=
 =?us-ascii?Q?eCfzqNxcNxxVvwDrZuGAwj0C/R0VKqDo0bD9VuPFhgBzQGrqIXqZUWToD+By?=
 =?us-ascii?Q?ZNfg4/M8GwW410Wk4qlsnJwPCtkyftxbxvkfzKiT9J6lug8lyxuiKRixSJtU?=
 =?us-ascii?Q?RHYsJ9dQW2WDcKLESezL/rxgkEZHS02e6UB74s8FQZc3NbIMLgpG31aM6j8k?=
 =?us-ascii?Q?0ZdDTIOW89/LISMA0uVbhY+mvBBikdIMJE3BCtJWxDpYSDS3HQn0uscKL7Qo?=
 =?us-ascii?Q?ptxpi2iFLufU1mkcCcyQ/I72sMhhdRNjXduW58ruGLsna/aQcFWOV+T1J7Kz?=
 =?us-ascii?Q?yNbEwId0oF0S6/zSdpV+z16bOC8ziEr1x8UXZ9moR3jswI33I7gMNExRZC4i?=
 =?us-ascii?Q?A00yAUWnENUvW8i5Lj3ab1zTliWiNDM+sO1M9t9rXErg55cg9Z9DBzAtl0kU?=
 =?us-ascii?Q?XUHdEDPlms8AxN8gOpsRKKrDfA3mD0sQxEjkAYGZIRUuTqJ4CY+UbtDldx0x?=
 =?us-ascii?Q?YXWGNfu1yKrzu+jczsMDcdthdBXAS7JmMZuHGZXZfqSoemD2d041w3zhWXoC?=
 =?us-ascii?Q?fxZq7jbKSEEp8yP4au4A+7A9PLrsBtPqFEqfAMMmAAWyktbPKLZMSBG6ydhk?=
 =?us-ascii?Q?CWloc84IEzuOrCWJCFHCi0LupTjY1xTVW+2aNuE7wjFTSDZvTFZTmQ3zZh0g?=
 =?us-ascii?Q?P9dWa9KrC3Jfx6TkNTHTdLMzC/TvNeCC77ANMF/6j05gi10wta6pK9ifQtha?=
 =?us-ascii?Q?TvJuvhqLOcHkI7MVGYGzKsF/pyxyBxEx5auMIC3xMm9TisXrf+f0pLr0iAZM?=
 =?us-ascii?Q?QxCjh713AEaeiJ9P5CdaR8U5s+1onsw395NH+rmhCwd6gRVYRQu0A0CeZHoE?=
 =?us-ascii?Q?qyXyIIBa05WXP27rN6pxRGIg7kGX6VFyWBOXOjpUDrCjXw7g8MUJFCi8PBj4?=
 =?us-ascii?Q?PJdYkzRfqnxuDVdCHRnM2ym/48k5oroRZtkKrccxmPGAc8GUqhm0uX7UqtSp?=
 =?us-ascii?Q?bABSNWB/VCNXaHuEzrH6r2Af2t+Hf4EIE7H9u7s4KgKk899C7gmWmOzSwX4y?=
 =?us-ascii?Q?jQRwLgm/77iHtGCj9F42XlyeNarDTFlqe2wCpXZ98xJf/aK1?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B7DE71230792374A957A2AAA70970CF5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77f76394-4c15-4ab4-ec55-08d9ebf8862c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:18:08.3893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9zHRoH0gwyzRxPQtDjWRklRp+y1LM/tJyBjY4O+y6iF6wub3meGl9bTBsCSLVGyoMbsJqDMzS4gfvwV2m8GNpSs6F3Feh+CzZGuFC1yqFzQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3252
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090097
X-Proofpoint-ORIG-GUID: t7Fvl-4WvB62ducnCPzlNAV7mIy9m0cQ
X-Proofpoint-GUID: t7Fvl-4WvB62ducnCPzlNAV7mIy9m0cQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd. This patch prepares for removal of the SCSI pointe=
r
> from struct scsi_cmnd.
>=20
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/hptiop.c | 1 +
> drivers/scsi/hptiop.h | 4 ++--
> 2 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
> index d04245e379d7..f18b770626e6 100644
> --- a/drivers/scsi/hptiop.c
> +++ b/drivers/scsi/hptiop.c
> @@ -1174,6 +1174,7 @@ static struct scsi_host_template driver_template =
=3D {
> 	.slave_configure            =3D hptiop_slave_config,
> 	.this_id                    =3D -1,
> 	.change_queue_depth         =3D hptiop_adjust_disk_queue_depth,
> +	.cmd_size		    =3D sizeof(struct hpt_cmd_priv),
> };
>=20
> static int hptiop_internal_memalloc_itl(struct hptiop_hba *hba)
> diff --git a/drivers/scsi/hptiop.h b/drivers/scsi/hptiop.h
> index 35184c2008af..363d5a16243f 100644
> --- a/drivers/scsi/hptiop.h
> +++ b/drivers/scsi/hptiop.h
> @@ -251,13 +251,13 @@ struct hptiop_request {
> 	int                   index;
> };
>=20
> -struct hpt_scsi_pointer {
> +struct hpt_cmd_priv {
> 	int mapped;
> 	int sgcnt;
> 	dma_addr_t dma_handle;
> };
>=20
> -#define HPT_SCP(scp) ((struct hpt_scsi_pointer *)&(scp)->SCp)
> +#define HPT_SCP(scp) ((struct hpt_cmd_priv *)scsi_cmd_priv(scp))
>=20
> enum hptiop_family {
> 	UNKNOWN_BASED_IOP,

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

