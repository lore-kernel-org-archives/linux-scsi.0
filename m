Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C0D7C00140
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Aug 2022 18:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbiHBSMX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Aug 2022 14:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237518AbiHBSML (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2022 14:12:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D1450071
        for <linux-scsi@vger.kernel.org>; Tue,  2 Aug 2022 11:12:04 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 272HwcWH007013;
        Tue, 2 Aug 2022 18:12:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ESUGVqO/TPPw+kbKBBF+k4+1gszDmhWmlU8nexuvul0=;
 b=NDaEOE6w5ZL5EP5k+wvC7hs/Nig3w3CASC+/bjXYx6FxLagwlYb2TBUExeYMqseTPFpy
 USWQ7ymR/iZ4wH77TLCAvPeSAwRAoOU9WQyWkwxpXQfYWXC7H8IxgBzgHJavUq6OUK1T
 Rs8odyjLg6sl4sMwt0XrXfSeVaDCMFbkntD+kGUmg8rXEMEx9AaXPvUGw1fztWaWrVRv
 5wFWbHGCvQT2ftV9cT/04SPIa5TRak5G1HS0otWSd06p+hPLS/AnAG1J7jgtwrpCD3/e
 WgVBxgiZyL37ISeNewgelxAr6RxvoR65+SzUMO/AtpNo6hWVoojeALodr6s2D/d4skvu bw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmue2qus1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Aug 2022 18:12:02 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 272HTvQd010938;
        Tue, 2 Aug 2022 18:12:01 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu32gxuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Aug 2022 18:12:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/dRQ3Jh4MixUg8bW4N+N/CsaKhrRwTkIZjPNyEu3m/6PWoOyNEkLBwwk8NW7alMcA7+EV1F52O0aVSShtGWgnLMzZmrjlAEv8K/kBrXg7JrMkUUXKsW5hXBpaQCwlwdE0OwRmuiUDUwA/G84KNO6GWYM4cj92MfOW/FP8iy12lVnL6odyD8rZe27HoF0czFhOAfLzxLCLbb3S5gA4cbcQ5i7FaEGqs90vdotTaOuHotwbm/KJDeIQRXAu3tn2D8Wj/pdKYag6sWMwHBr2ivMedpdvjXVghqbQN7H02v/RrKPclfun90/0gEkAb7DUnEL8Qvk78faxX0UQmPD+wigQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ESUGVqO/TPPw+kbKBBF+k4+1gszDmhWmlU8nexuvul0=;
 b=FeqgIBqc8X+hhc5xAkDBtjA7Q0D6fAZL1twLeeA4cbFcB/ZSyfndlEhwt3gblr9o8yJBYkKsAezbkG/LZdrYE61XAeTOSiVoMPVMm4ej3neyF12PAUIjVuanx3y2GiQyUGR3ij/mRnl2AK25ozNFe68r/cwgsiFk0B0yYjLziRSTzTq1gd3154p2Jh7mkUGVYTnmonr+WobGH3Ttm8Sbz5cjtVd5dFhR2w60s7HLbb1g2xVDVH01saRFDt98ud4kOr41H4egmMzA+st88r7guu7WyZDuaCMABc7+iWtRaGAGNhf2Oa6/CSzAd1pncUcybAvyA/7J4+eABnxcVuHLig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESUGVqO/TPPw+kbKBBF+k4+1gszDmhWmlU8nexuvul0=;
 b=BcVu3MrHy+9NZSiN2JeFbsM5Kh2FyvKfuUBfK0sD3Yx3K9v0az0zoY4R2KEtCEsyH5Hv9NF23Suy4P0qo80XzfGZGv3sZjVcl1/3Z0kvOSlK7Hfxgesk/FqDKJdmGpTf3DR/1gBaFIn8NvobtRWCxV50OhimW3zzryqsBa7wTzI=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by PH7PR10MB6058.namprd10.prod.outlook.com (2603:10b6:510:1fe::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Tue, 2 Aug
 2022 18:11:58 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3%3]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 18:11:58 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [PATCH 13/15] mpi3mr: Support sas transport class callbacks
Thread-Topic: [PATCH 13/15] mpi3mr: Support sas transport class callbacks
Thread-Index: AQHYo0wPMK2NFCdSLk2kk3BeIWGlEa2b8ByA
Date:   Tue, 2 Aug 2022 18:11:57 +0000
Message-ID: <C05A63FC-2A52-4969-98E8-50558123D42C@oracle.com>
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
 <20220729131627.15019-14-sreekanth.reddy@broadcom.com>
In-Reply-To: <20220729131627.15019-14-sreekanth.reddy@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 607161c1-3935-4a8c-de9f-08da74b27d32
x-ms-traffictypediagnostic: PH7PR10MB6058:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UrPqpBmNubgwXBsrjVKYBSY8K+vhY3GaXu7d5LGsQSM+YHxqtbMxfqroGm1/Th03hKe5o2wNb7ZMX4/Fp8/cxyQWiy5GPLD12wrMPmvuwt6YupLDFwSc6+3W7R393JLpN9tnbJlgoC+scQsfMMwH6npTmiUSojmyRcQLHTD1YZGYjTHInobF287pgowTtRp8/W0cbfovbtFXEQ07cOM0CGuO9mfQIh+v9xIfonwgC2co4cjtVZNL8E7gXLY5n/e3Z9aU+nma+AxXE/qdP+Bnm11XPOUK8YhQURqA6Qj5ToVTN5Nzr339zGUjzy+OoWULcLFQrCHADO0aBsPwmd2BcuNgBUIdG5m9fuvbkI4pAS1N4z93hOM0ugtzMlqyaDS1D7OoKo1Ks+LIFfxaAj9e//1nq++POzsDmncl2LlyfFRWce4rsl7JN2D7NNpeUADsCO0z87WGOk0iMOimdwYngcn3/S0THkv90XvY5IJAlYeJ1HnRp1S/cR5ju1eA2GlTXyq5nlgudACLxfkU61CINWsPk8P9ZUToWj5SV/otsyJ6tQLqqyME4y4xRyvyieJeeVq+jvHOUr9dz0quxtbDqntg4WmfPwy0LEf0bUpN0meImmfGoxpwNymVzA+owF3jWqOLMjNOaiAVvYvrSpC2CyvRIjsuVCKVLfbkagRXMsh+ozNH8wnl19cyLQWrTSlcRjyjMW/1237t7nSsKHbvPUTxHbYTkDcSUDgWIl32az22YQJmSi/rFQUdC4FTFBZUVEI/BMsWeL54slN+iktda80YgCIIaQZMwsgIT9YKdMLyGtZh6rPmNngXcgNQtBXPD56+nQSwZHDwGhkBo4PW+w/erpFh4b/kIy2jEdyDDic=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(366004)(346002)(376002)(396003)(71200400001)(83380400001)(91956017)(38070700005)(30864003)(66946007)(76116006)(44832011)(6486002)(66476007)(4326008)(66556008)(8676002)(64756008)(66446008)(5660300002)(33656002)(8936002)(2616005)(6512007)(478600001)(107886003)(26005)(186003)(86362001)(38100700002)(316002)(6916009)(54906003)(2906002)(6506007)(36756003)(122000001)(53546011)(41300700001)(32563001)(45980500001)(559001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QeqCOJw7vf5FP4HYQim8TQZxZDZgVKrECAMcO66O4JFKpgV0SQ/ET772F9xv?=
 =?us-ascii?Q?JyEadmAFhywt352XxKVjR5+7n8yOF8Qb/9vrkr6WMuTkAvN0EgQH/12FgLVO?=
 =?us-ascii?Q?vvhW1Fc6NRfUm4TnPZS+jleC40szMK3BwzjmcP07QHwjPbcFTwe+u0YFGPTd?=
 =?us-ascii?Q?TqQs000zub6ph8zp3EUTc2QaxtHJO3V8whCs8tVNtUbdg5OzdNFOBDSCp4km?=
 =?us-ascii?Q?v8bgeSxQ18HnlPZvYUdGSISJqf3ocXIZDIQKijO+do4w5usz3CmvR5PNIwJa?=
 =?us-ascii?Q?5nuVYX1jvmmqn0mZL+WPhYs9yeW63Sb06XXAUp+b4Cfx3/6odiMKrkLTDBA+?=
 =?us-ascii?Q?Lup3u/IjQwGmxgGizCrjsfj7ZBRuYGDw4AdZ1LS1HSwvWLYvoHaxvWCO/ODb?=
 =?us-ascii?Q?0NzbNCODBtmjtDS5EzUT5f1FtcwnJ4w1TBbMdErTxXrF+OT+7YezywU+Wzyl?=
 =?us-ascii?Q?piK1LxO1XhSAv+AGJC5Xv7AcT4ZE2alb4Ku4HFPAkZwljUnRap7jCBQk8vUq?=
 =?us-ascii?Q?oiAtFA9/8DKQ4NQCrB6fSq5/KPviGtAwiCLq4jtl5uxd/Yu1XuFDXK6xJMPb?=
 =?us-ascii?Q?8sTk3AGqiyXvpobnRpK0PEse97mZQSTsmWUrgbsnwlgUYaF/QMiGsbKp7Wj+?=
 =?us-ascii?Q?2GwIbrNb1H/rWhipbR+rkNZkRJEyM//3nvfYrZQl5OXZBa8APWYlM6pKL7U5?=
 =?us-ascii?Q?ZVgwiFMDvmB+EGdkTznjDNBvXR7vnnMKvq/aF6i93+Pq7U4HJ2mccrDiHh2s?=
 =?us-ascii?Q?8rJeOQR6STxuXYlVdJIu2DCWiW+zSZRWUe8PB/PaZXrzZZYj0HD3yfl6fb3K?=
 =?us-ascii?Q?ySy754fJqJxgakDC/IxVLn1LKCoSuOEefmTE7duENXvl7AB9C295T35YsVMn?=
 =?us-ascii?Q?t+7EQTW4fsISR5b/JgdEAYTFBpgY9VrmCI31jdI25kRMc31nH3vu+43nJRXo?=
 =?us-ascii?Q?YiZnWuge7ixLiIi7ANRFGsYL7mVGJGbietrHUSoC9iLnFOxZHcDpypYQAxZ/?=
 =?us-ascii?Q?1+perI2XsheZXUmsQQ78o+iCvxog135+b4cM9ISWdD7BV80THWlTDUGQKu1u?=
 =?us-ascii?Q?EQuJCCXtG1+MK7jBawsteuaSd0MeYOPjfxuQU5xehe4TbB2++FeuFYnVHrRV?=
 =?us-ascii?Q?PP9/IfXSXpc1ecp+RlA+XDlw/hgClmFfCkZ6stCgMX7QfqEDYnIRwO7I5tYR?=
 =?us-ascii?Q?/pHJWo7DY8PjuKcWGwk4ZLhhvCj3ahoNEX4KnDi3nToxgYNiN0Cz79yHUxlZ?=
 =?us-ascii?Q?vfdL9llbEsURnik1XMKFWD+C23OmJqOtz6lAvuAJkB2rx0xUCjxOlxzHswao?=
 =?us-ascii?Q?0EU0jPF3SkNPobFW+hWvKMHrgHFQ1GPRpt6JvtxgxSLAEeWB/yA2ydbPcnC/?=
 =?us-ascii?Q?sLrPn10+Ne+mqRScCYIhGQx2dtxyMIjkzUi3fvFw1pHMbUn1a/dQ4JSmZ/C9?=
 =?us-ascii?Q?UfIFz5OChlSJlt+W0CLP1xMQElzXnb23hxCNYkdjllbyAY39kkewweRSO7eA?=
 =?us-ascii?Q?X8gBY7MzQCxW+nsGcuoHXchtJkNxe2hlFs6ruVKRdu3qQAb46w/vbS0ejU/Z?=
 =?us-ascii?Q?l7tMfJG7uE5dqDS8MO8SkB5RqVI3sseTLe30ag+ixpXL4Cdkxn2pWADNmepM?=
 =?us-ascii?Q?eA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <54A1655FF712B44C8EB3AFF5DA6977F9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 607161c1-3935-4a8c-de9f-08da74b27d32
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2022 18:11:57.9520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JL4keDt7y2CX2KWDCx4YpJlBN69P1Wvuwn5t7Ebxp5A1q8WgoL+VCI/4PALXPwa3enKneiGFtsel205A5TMt8C4WR+nk9tDAZvkN9+CEzFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6058
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-02_14,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208020086
X-Proofpoint-ORIG-GUID: rlBLhR3MfgtFbXrC4YTyUXH6D29XzGqN
X-Proofpoint-GUID: rlBLhR3MfgtFbXrC4YTyUXH6D29XzGqN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 29, 2022, at 6:16 AM, Sreekanth Reddy <sreekanth.reddy@broadcom.co=
m> wrote:
>=20
> Added support for below sas transport class callbacks,
> - get_linkerrors
> - get_enclosure_identifier
> - get_bay_identifier
> - phy_reset
> - phy_enable
> - set_phy_speed
> - smp_handler
>=20
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
> drivers/scsi/mpi3mr/mpi3mr.h           |   3 +
> drivers/scsi/mpi3mr/mpi3mr_fw.c        |   1 +
> drivers/scsi/mpi3mr/mpi3mr_os.c        |  20 +-
> drivers/scsi/mpi3mr/mpi3mr_transport.c | 917 +++++++++++++++++++++++++
> 4 files changed, 939 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index a6c880c..d203167 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -1326,6 +1326,9 @@ struct mpi3mr_enclosure_node *mpi3mr_enclosure_find=
_by_handle(
> extern const struct attribute_group *mpi3mr_host_groups[];
> extern const struct attribute_group *mpi3mr_dev_groups[];
>=20
> +extern struct sas_function_template mpi3mr_transport_functions;
> +extern struct scsi_transport_template *mpi3mr_transport_template;
> +
> int mpi3mr_cfg_get_dev_pg0(struct mpi3mr_ioc *mrioc, u16 *ioc_status,
> 	struct mpi3_device_page0 *dev_pg0, u16 pg_sz, u32 form, u32 form_spec);
> int mpi3mr_cfg_get_sas_phy_pg0(struct mpi3mr_ioc *mrioc, u16 *ioc_status,
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 1bf3cae..59ef373 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -3757,6 +3757,7 @@ retry_init:
> 		mrioc->sas_transport_enabled =3D 1;
> 		mrioc->scsi_device_channel =3D 1;
> 		mrioc->shost->max_channel =3D 1;
> +		mrioc->shost->transportt =3D mpi3mr_transport_template;
> 	}
>=20
> 	mrioc->reply_sz =3D mrioc->facts.reply_sz;
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 3b20096..139c164 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -5168,18 +5168,33 @@ static int __init mpi3mr_init(void)
> 	pr_info("Loading %s version %s\n", MPI3MR_DRIVER_NAME,
> 	    MPI3MR_DRIVER_VERSION);
>=20
> +	mpi3mr_transport_template =3D
> +	    sas_attach_transport(&mpi3mr_transport_functions);
> +	if (!mpi3mr_transport_template) {
> +		pr_err("%s failed to load due to sas transport attach failure\n",
> +		    MPI3MR_DRIVER_NAME);
> +		return -ENODEV;
> +	}
> +
> 	ret_val =3D pci_register_driver(&mpi3mr_pci_driver);
> 	if (ret_val) {
> 		pr_err("%s failed to load due to pci register driver failure\n",
> 		    MPI3MR_DRIVER_NAME);
> -		return ret_val;
> +		goto err_pci_reg_fail;
> 	}
>=20
> 	ret_val =3D driver_create_file(&mpi3mr_pci_driver.driver,
> 				     &driver_attr_event_counter);
> 	if (ret_val)
> -		pci_unregister_driver(&mpi3mr_pci_driver);
> +		goto err_event_counter;
> +
> +	return ret_val;
> +
> +err_event_counter:
> +	pci_unregister_driver(&mpi3mr_pci_driver);
>=20
> +err_pci_reg_fail:
> +	sas_release_transport(mpi3mr_transport_template);
> 	return ret_val;
> }
>=20
> @@ -5196,6 +5211,7 @@ static void __exit mpi3mr_exit(void)
> 	driver_remove_file(&mpi3mr_pci_driver.driver,
> 			   &driver_attr_event_counter);
> 	pci_unregister_driver(&mpi3mr_pci_driver);
> +	sas_release_transport(mpi3mr_transport_template);
> }
>=20
> module_init(mpi3mr_init);
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index 44a30d7..e8a9a76 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> @@ -2046,3 +2046,920 @@ void mpi3mr_remove_tgtdev_from_sas_transport(stru=
ct mpi3mr_ioc *mrioc,
> 	    hba_port);
> 	tgtdev->host_exposed =3D 0;
> }
> +
> +/**
> + * mpi3mr_get_port_id_by_sas_phy -  Get port ID of the given phy
> + * @phy: SAS transport layer phy object
> + *
> + * Return: Port number for valid ID else 0xFFFF
> + */
> +static inline u8 mpi3mr_get_port_id_by_sas_phy(struct sas_phy *phy)
> +{
> +	u8 port_id =3D 0xFF;
> +	struct mpi3mr_hba_port *hba_port =3D phy->hostdata;
> +
> +	if (hba_port)
> +		port_id =3D hba_port->port_id;
> +
> +	return port_id;
> +}
> +
> +/**
> + * mpi3mr_get_port_id_by_rphy - Get Port number from SAS rphy
> + *
> + * @mrioc: Adapter instance reference
> + * @rphy: SAS transport layer remote phy object
> + *
> + * Retrieves HBA port number in which the device pointed by the
> + * rphy object is attached with.
> + *
> + * Return: Valid port number on success else OxFFFF.
> + */
> +static u8 mpi3mr_get_port_id_by_rphy(struct mpi3mr_ioc *mrioc, struct sa=
s_rphy *rphy)
> +{
> +	struct mpi3mr_sas_node *sas_expander;
> +	struct mpi3mr_tgt_dev *tgtdev;
> +	unsigned long flags;
> +	u8 port_id =3D 0xFF;
> +
> +	if (!rphy)
> +		return port_id;
> +
> +	if (rphy->identify.device_type =3D=3D SAS_EDGE_EXPANDER_DEVICE ||
> +	    rphy->identify.device_type =3D=3D SAS_FANOUT_EXPANDER_DEVICE) {
> +		spin_lock_irqsave(&mrioc->sas_node_lock, flags);
> +		list_for_each_entry(sas_expander, &mrioc->sas_expander_list,
> +		    list) {
> +			if (sas_expander->rphy =3D=3D rphy) {
> +				port_id =3D sas_expander->hba_port->port_id;
> +				break;
> +			}
> +		}
> +		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> +	} else if (rphy->identify.device_type =3D=3D SAS_END_DEVICE) {
> +		spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> +
> +		tgtdev =3D __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
> +			    rphy->identify.sas_address, rphy);
> +		if (tgtdev) {
> +			port_id =3D
> +				tgtdev->dev_spec.sas_sata_inf.hba_port->port_id;
> +			mpi3mr_tgtdev_put(tgtdev);
> +		}
> +		spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> +	}
> +	return port_id;
> +}
> +
> +static inline struct mpi3mr_ioc *phy_to_mrioc(struct sas_phy *phy)
> +{
> +	struct Scsi_Host *shost =3D dev_to_shost(phy->dev.parent);
> +
> +	return shost_priv(shost);
> +}
> +
> +static inline struct mpi3mr_ioc *rphy_to_mrioc(struct sas_rphy *rphy)
> +{
> +	struct Scsi_Host *shost =3D dev_to_shost(rphy->dev.parent->parent);
> +
> +	return shost_priv(shost);
> +}
> +
> +/* report phy error log structure */
> +struct phy_error_log_request {
> +	u8 smp_frame_type; /* 0x40 */
> +	u8 function; /* 0x11 */
> +	u8 allocated_response_length;
> +	u8 request_length; /* 02 */
> +	u8 reserved_1[5];
> +	u8 phy_identifier;
> +	u8 reserved_2[2];
> +};
> +
> +/* report phy error log reply structure */
> +struct phy_error_log_reply {
> +	u8 smp_frame_type; /* 0x41 */
> +	u8 function; /* 0x11 */
> +	u8 function_result;
> +	u8 response_length;
> +	__be16 expander_change_count;
> +	u8 reserved_1[3];
> +	u8 phy_identifier;
> +	u8 reserved_2[2];
> +	__be32 invalid_dword;
> +	__be32 running_disparity_error;
> +	__be32 loss_of_dword_sync;
> +	__be32 phy_reset_problem;
> +};
> +
> +
> +/**
> + * mpi3mr_get_expander_phy_error_log - return expander counters:
> + * @mrioc: Adapter instance reference
> + * @phy: The SAS transport layer phy object
> + *
> + * Return: 0 for success, non-zero for failure.
> + *
> + */
> +static int mpi3mr_get_expander_phy_error_log(struct mpi3mr_ioc *mrioc,
> +	struct sas_phy *phy)
> +{
> +	struct mpi3_smp_passthrough_request mpi_request;
> +	struct mpi3_smp_passthrough_reply mpi_reply;
> +	struct phy_error_log_request *phy_error_log_request;
> +	struct phy_error_log_reply *phy_error_log_reply;
> +	int rc;
> +	void *psge;
> +	void *data_out =3D NULL;
> +	dma_addr_t data_out_dma, data_in_dma;
> +	u32 data_out_sz, data_in_sz, sz;
> +	u8 sgl_flags =3D MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST;
> +	u16 request_sz =3D sizeof(struct mpi3_smp_passthrough_request);
> +	u16 reply_sz =3D sizeof(struct mpi3_smp_passthrough_reply);
> +	u16 ioc_status;
> +
> +
> +	if (mrioc->reset_in_progress) {
> +		ioc_err(mrioc, "%s: host reset in progress!\n", __func__);
> +		return -EFAULT;
> +	}
> +
> +
Remove extra newline

> +	data_out_sz =3D sizeof(struct phy_error_log_request);
> +	data_in_sz =3D sizeof(struct phy_error_log_reply);
> +	sz =3D data_out_sz + data_in_sz;
> +	data_out =3D dma_alloc_coherent(&mrioc->pdev->dev, sz, &data_out_dma,
> +	    GFP_KERNEL);
> +	if (!data_out) {
> +		rc =3D -ENOMEM;
> +		goto out;
> +	}
> +
> +	data_in_dma =3D data_out_dma + data_out_sz;
> +	phy_error_log_reply =3D data_out + data_out_sz;
> +
> +	rc =3D -EINVAL;
> +	memset(data_out, 0, sz);
> +	phy_error_log_request =3D data_out;
> +	phy_error_log_request->smp_frame_type =3D 0x40;
> +	phy_error_log_request->function =3D 0x11;
> +	phy_error_log_request->request_length =3D 2;
> +	phy_error_log_request->allocated_response_length =3D 0;
> +	phy_error_log_request->phy_identifier =3D phy->number;
> +
> +	memset(&mpi_request, 0, request_sz);
> +	memset(&mpi_reply, 0, reply_sz);
> +	mpi_request.host_tag =3D cpu_to_le16(MPI3MR_HOSTTAG_TRANSPORT_CMDS);
> +	mpi_request.function =3D MPI3_FUNCTION_SMP_PASSTHROUGH;
> +	mpi_request.io_unit_port =3D (u8) mpi3mr_get_port_id_by_sas_phy(phy);
> +	mpi_request.sas_address =3D cpu_to_le64(phy->identify.sas_address);
> +
> +	psge =3D &mpi_request.request_sge;
> +	mpi3mr_add_sg_single(psge, sgl_flags, data_out_sz, data_out_dma);
> +
> +	psge =3D &mpi_request.response_sge;
> +	mpi3mr_add_sg_single(psge, sgl_flags, data_in_sz, data_in_dma);
> +
> +	dprint_transport_info(mrioc,
> +	    "sending phy error log SMP request to sas_address(0x%016llx), phy_i=
d(%d)\n",
> +	    (unsigned long long)phy->identify.sas_address, phy->number);
> +
> +	if (mpi3mr_post_transport_req(mrioc, &mpi_request, request_sz,
> +	    &mpi_reply, reply_sz, MPI3MR_INTADMCMD_TIMEOUT, &ioc_status))
> +		goto out;
> +
> +	dprint_transport_info(mrioc,
> +	    "phy error log SMP request completed with ioc_status(0x%04x)\n",
> +	    ioc_status);
> +
> +
Ditto here remove extra newline

> +	if (ioc_status =3D=3D MPI3_IOCSTATUS_SUCCESS) {
> +		dprint_transport_info(mrioc,
> +		    "phy error log - reply data transfer size(%d)\n",
> +		    le16_to_cpu(mpi_reply.response_data_length));
> +
> +		if (le16_to_cpu(mpi_reply.response_data_length) !=3D
> +		    sizeof(struct phy_error_log_reply))
> +			goto out;
> +
> +
Same here remove extra newline

> +		dprint_transport_info(mrioc,
> +		    "phy error log - function_result(%d)\n",
> +		    phy_error_log_reply->function_result);
> +
> +		phy->invalid_dword_count =3D
> +		    be32_to_cpu(phy_error_log_reply->invalid_dword);
> +		phy->running_disparity_error_count =3D
> +		    be32_to_cpu(phy_error_log_reply->running_disparity_error);
> +		phy->loss_of_dword_sync_count =3D
> +		    be32_to_cpu(phy_error_log_reply->loss_of_dword_sync);
> +		phy->phy_reset_problem_count =3D
> +		    be32_to_cpu(phy_error_log_reply->phy_reset_problem);
> +		rc =3D 0;
> +	}
> +
> +out:
> +	if (data_out)
> +		dma_free_coherent(&mrioc->pdev->dev, sz, data_out,
> +		    data_out_dma);
> +
> +	return rc;
> +}
> +
> +
Remove extra newline
> +/**
> + * mpi3mr_transport_get_linkerrors - return phy error counters
> + * @phy: The SAS transport layer phy object
> + *
> + * This function retrieves the phy error log information of the
> + * HBA or expander for which the phy belongs to
> + *
> + * Return: 0 for success, non-zero for failure.
> + *
remove extra newline in comment.
> + */
> +static int mpi3mr_transport_get_linkerrors(struct sas_phy *phy)
> +{
> +	struct mpi3mr_ioc *mrioc =3D phy_to_mrioc(phy);
> +	struct mpi3_sas_phy_page1 phy_pg1;
> +	int rc =3D 0;
> +	u16 ioc_status;
> +
> +	rc =3D mpi3mr_parent_present(mrioc, phy);
> +	if (rc)
> +		return rc;
> +
> +	if (phy->identify.sas_address !=3D mrioc->sas_hba.sas_address)
> +		return mpi3mr_get_expander_phy_error_log(mrioc, phy);
> +
> +	memset(&phy_pg1, 0, sizeof(struct mpi3_sas_phy_page1));
> +	/* get hba phy error logs */
> +	if ((mpi3mr_cfg_get_sas_phy_pg1(mrioc, &ioc_status, &phy_pg1,
> +	    sizeof(struct mpi3_sas_phy_page1),
> +	    MPI3_SAS_PHY_PGAD_FORM_PHY_NUMBER, phy->number))) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		return -ENXIO;
> +	}
> +
> +	if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		return -ENXIO;
> +	}
> +	phy->invalid_dword_count =3D le32_to_cpu(phy_pg1.invalid_dword_count);
> +	phy->running_disparity_error_count =3D
> +		le32_to_cpu(phy_pg1.running_disparity_error_count);
> +	phy->loss_of_dword_sync_count =3D
> +		le32_to_cpu(phy_pg1.loss_dword_synch_count);
> +	phy->phy_reset_problem_count =3D
> +		le32_to_cpu(phy_pg1.phy_reset_problem_count);
> +	return 0;
> +}
> +
> +
Another one, remove extra newline
> +/**
> + * mpi3mr_transport_get_enclosure_identifier - Get Enclosure ID
> + * @rphy: The SAS transport layer remote phy object
> + * @identifier: Enclosure identifier to be returned
> + *
> + * Returns the enclosure id for the device pointed by the remote
> + * phy object.
> + *
> + * Return: 0 on success or -ENXIO
> + */
> +static int
> +mpi3mr_transport_get_enclosure_identifier(struct sas_rphy *rphy,
> +	u64 *identifier)
> +{
> +	struct mpi3mr_ioc *mrioc =3D rphy_to_mrioc(rphy);
> +	struct mpi3mr_tgt_dev *tgtdev =3D NULL;
> +	unsigned long flags;
> +	int rc;
> +
> +	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> +	tgtdev =3D __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
> +	    rphy->identify.sas_address, rphy);
> +	if (tgtdev) {
> +		*identifier =3D
> +			tgtdev->enclosure_logical_id;
> +		rc =3D 0;
> +		mpi3mr_tgtdev_put(tgtdev);
> +	} else {
> +		*identifier =3D 0;
> +		rc =3D -ENXIO;
> +	}
> +	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> +
> +	return rc;
> +}
> +
> +/**
> + * mpi3mr_transport_get_bay_identifier - Get bay ID
> + * @rphy: The SAS transport layer remote phy object
> + *
> + * Returns the slot id for the device pointed by the remote phy
> + * object.
> + *
> + * Return: Valid slot ID on success or -ENXIO
> + */
> +static int
> +mpi3mr_transport_get_bay_identifier(struct sas_rphy *rphy)
> +{
> +
Remove newline here

> +	struct mpi3mr_ioc *mrioc =3D rphy_to_mrioc(rphy);
> +	struct mpi3mr_tgt_dev *tgtdev =3D NULL;
> +	unsigned long flags;
> +	int rc;
> +
> +	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> +	tgtdev =3D __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
> +	    rphy->identify.sas_address, rphy);
> +	if (tgtdev) {
> +		rc =3D tgtdev->slot;
> +		mpi3mr_tgtdev_put(tgtdev);
> +	} else
> +		rc =3D -ENXIO;
> +	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> +
> +	return rc;
> +}
> +
> +/* phy control request structure */
> +struct phy_control_request {
> +	u8 smp_frame_type; /* 0x40 */
> +	u8 function; /* 0x91 */
> +	u8 allocated_response_length;
> +	u8 request_length; /* 0x09 */
> +	u16 expander_change_count;
> +	u8 reserved_1[3];
> +	u8 phy_identifier;
> +	u8 phy_operation;
> +	u8 reserved_2[13];
> +	u64 attached_device_name;
> +	u8 programmed_min_physical_link_rate;
> +	u8 programmed_max_physical_link_rate;
> +	u8 reserved_3[6];
> +};
> +
> +/* phy control reply structure */
> +struct phy_control_reply {
> +	u8 smp_frame_type; /* 0x41 */
> +	u8 function; /* 0x11 */
> +	u8 function_result;
> +	u8 response_length;
> +};
> +
> +#define SMP_PHY_CONTROL_LINK_RESET	(0x01)
> +#define SMP_PHY_CONTROL_HARD_RESET	(0x02)
> +#define SMP_PHY_CONTROL_DISABLE		(0x03)
> +
> +/**
> + * mpi3mr_expander_phy_control - expander phy control
> + * @mrioc: Adapter instance reference
> + * @phy: The SAS transport layer phy object
> + * @phy_operation: The phy operation to be executed
> + *
> + * Issues SMP passthru phy control request to execute a specific
> + * phy operation for a given expander device.
> + *
> + * Return: 0 for success, non-zero for failure.
> + *
remove extra newline in comment.=20

> + */
> +static int
> +mpi3mr_expander_phy_control(struct mpi3mr_ioc *mrioc,
> +	struct sas_phy *phy, u8 phy_operation)
> +{
> +	struct mpi3_smp_passthrough_request mpi_request;
> +	struct mpi3_smp_passthrough_reply mpi_reply;
> +	struct phy_control_request *phy_control_request;
> +	struct phy_control_reply *phy_control_reply;
> +	int rc;
> +	void *psge;
> +	void *data_out =3D NULL;
> +	dma_addr_t data_out_dma;
> +	dma_addr_t data_in_dma;
> +	size_t data_in_sz;
> +	size_t data_out_sz;
> +	u8 sgl_flags =3D MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST;
> +	u16 request_sz =3D sizeof(struct mpi3_smp_passthrough_request);
> +	u16 reply_sz =3D sizeof(struct mpi3_smp_passthrough_reply);
> +	u16 ioc_status;
> +	u16 sz;
> +
> +	if (mrioc->reset_in_progress) {
> +		ioc_err(mrioc, "%s: host reset in progress!\n", __func__);
> +		return -EFAULT;
> +	}
> +
> +
Remove extra newline

> +	data_out_sz =3D sizeof(struct phy_control_request);
> +	data_in_sz =3D sizeof(struct phy_control_reply);
> +	sz =3D data_out_sz + data_in_sz;
> +	data_out =3D dma_alloc_coherent(&mrioc->pdev->dev, sz, &data_out_dma,
> +	    GFP_KERNEL);
> +	if (!data_out) {
> +		rc =3D -ENOMEM;
> +		goto out;
> +	}
> +
> +	data_in_dma =3D data_out_dma + data_out_sz;
> +	phy_control_reply =3D data_out + data_out_sz;
> +
> +	rc =3D -EINVAL;
> +	memset(data_out, 0, sz);
> +
> +	phy_control_request =3D data_out;
> +	phy_control_request->smp_frame_type =3D 0x40;
> +	phy_control_request->function =3D 0x91;
> +	phy_control_request->request_length =3D 9;
> +	phy_control_request->allocated_response_length =3D 0;
> +	phy_control_request->phy_identifier =3D phy->number;
> +	phy_control_request->phy_operation =3D phy_operation;
> +	phy_control_request->programmed_min_physical_link_rate =3D
> +	    phy->minimum_linkrate << 4;
> +	phy_control_request->programmed_max_physical_link_rate =3D
> +	    phy->maximum_linkrate << 4;
> +
> +	memset(&mpi_request, 0, request_sz);
> +	memset(&mpi_reply, 0, reply_sz);
> +	mpi_request.host_tag =3D cpu_to_le16(MPI3MR_HOSTTAG_TRANSPORT_CMDS);
> +	mpi_request.function =3D MPI3_FUNCTION_SMP_PASSTHROUGH;
> +	mpi_request.io_unit_port =3D (u8) mpi3mr_get_port_id_by_sas_phy(phy);
> +	mpi_request.sas_address =3D cpu_to_le64(phy->identify.sas_address);
> +
> +	psge =3D &mpi_request.request_sge;
> +	mpi3mr_add_sg_single(psge, sgl_flags, data_out_sz, data_out_dma);
> +
> +	psge =3D &mpi_request.response_sge;
> +	mpi3mr_add_sg_single(psge, sgl_flags, data_in_sz, data_in_dma);
> +
> +	dprint_transport_info(mrioc,
> +	    "sending phy control SMP request to sas_address(0x%016llx), phy_id(=
%d) opcode(%d)\n",
> +	    (unsigned long long)phy->identify.sas_address, phy->number,
> +	    phy_operation);
> +
> +	if (mpi3mr_post_transport_req(mrioc, &mpi_request, request_sz,
> +	    &mpi_reply, reply_sz, MPI3MR_INTADMCMD_TIMEOUT, &ioc_status))
> +		goto out;
> +
> +	dprint_transport_info(mrioc,
> +	    "phy control SMP request completed with ioc_status(0x%04x)\n",
> +	    ioc_status);
> +
> +
Remove extra newline

> +	if (ioc_status =3D=3D MPI3_IOCSTATUS_SUCCESS) {
> +		dprint_transport_info(mrioc,
> +		    "phy control - reply data transfer size(%d)\n",
> +		    le16_to_cpu(mpi_reply.response_data_length));
> +
> +		if (le16_to_cpu(mpi_reply.response_data_length) !=3D
> +		    sizeof(struct phy_control_reply))
> +			goto out;
> +		dprint_transport_info(mrioc,
> +		    "phy control - function_result(%d)\n",
> +		    phy_control_reply->function_result);
> +		rc =3D 0;
> +	}
> + out:
> +	if (data_out)
> +		dma_free_coherent(&mrioc->pdev->dev, sz, data_out,
> +		    data_out_dma);
> +
> +	return rc;
> +}
> +
> +/**
> + * mpi3mr_transport_phy_reset - Reset a given phy
> + * @phy: The SAS transport layer phy object
> + * @hard_reset: Flag to indicate the type of reset
> + *
> + * Return: 0 for success, non-zero for failure.
> + */
> +static int
> +mpi3mr_transport_phy_reset(struct sas_phy *phy, int hard_reset)
> +{
> +	struct mpi3mr_ioc *mrioc =3D phy_to_mrioc(phy);
> +	struct mpi3_iounit_control_request mpi_request;
> +	struct mpi3_iounit_control_reply mpi_reply;
> +	u16 request_sz =3D sizeof(struct mpi3_iounit_control_request);
> +	u16 reply_sz =3D sizeof(struct mpi3_iounit_control_reply);
> +	int rc =3D 0;
> +	u16 ioc_status;
> +
> +	rc =3D mpi3mr_parent_present(mrioc, phy);
> +	if (rc)
> +		return rc;
> +
> +	/* handle expander phys */
> +	if (phy->identify.sas_address !=3D mrioc->sas_hba.sas_address)
> +		return mpi3mr_expander_phy_control(mrioc, phy,
> +		    (hard_reset =3D=3D 1) ? SMP_PHY_CONTROL_HARD_RESET :
> +		    SMP_PHY_CONTROL_LINK_RESET);
> +
> +	/* handle hba phys */
> +	memset(&mpi_request, 0, request_sz);
> +	mpi_request.host_tag =3D cpu_to_le16(MPI3MR_HOSTTAG_TRANSPORT_CMDS);
> +	mpi_request.function =3D MPI3_FUNCTION_IO_UNIT_CONTROL;
> +	mpi_request.operation =3D MPI3_CTRL_OP_SAS_PHY_CONTROL;
> +	mpi_request.param8[MPI3_CTRL_OP_SAS_PHY_CONTROL_PARAM8_ACTION_INDEX] =
=3D
> +		(hard_reset ? MPI3_CTRL_ACTION_HARD_RESET :
> +		 MPI3_CTRL_ACTION_LINK_RESET);
> +	mpi_request.param8[MPI3_CTRL_OP_SAS_PHY_CONTROL_PARAM8_PHY_INDEX] =3D
> +		phy->number;
> +
> +	dprint_transport_info(mrioc,
> +	    "sending phy reset request to sas_address(0x%016llx), phy_id(%d) ha=
rd_reset(%d)\n",
> +	    (unsigned long long)phy->identify.sas_address, phy->number,
> +	    hard_reset);
> +
> +	if (mpi3mr_post_transport_req(mrioc, &mpi_request, request_sz,
> +	    &mpi_reply, reply_sz, MPI3MR_INTADMCMD_TIMEOUT, &ioc_status)) {
> +		rc =3D -EAGAIN;
> +		goto out;
> +	}
> +
> +	dprint_transport_info(mrioc,
> +	    "phy reset request completed with ioc_status(0x%04x)\n",
> +	    ioc_status);
> +out:
> +	return rc;
> +}
> +
> +/**
> + * mpi3mr_transport_phy_enable - enable/disable phys
> + * @phy: The SAS transport layer phy object
> + * @enable: flag to enable/disable, enable phy when true
> + *
> + * This function enables/disables a given by executing required
> + * configuration page changes or expander phy control command
> + *
> + * Return: 0 for success, non-zero for failure.
> + */
> +static int
> +mpi3mr_transport_phy_enable(struct sas_phy *phy, int enable)
> +{
> +	struct mpi3mr_ioc *mrioc =3D phy_to_mrioc(phy);
> +	struct mpi3_sas_io_unit_page0 *sas_io_unit_pg0 =3D NULL;
> +	struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1 =3D NULL;
> +	u16 sz;
> +	int rc =3D 0;
> +	int i, discovery_active;
> +
> +	rc =3D mpi3mr_parent_present(mrioc, phy);
> +	if (rc)
> +		return rc;
> +
> +	/* handle expander phys */
> +	if (phy->identify.sas_address !=3D mrioc->sas_hba.sas_address)
> +		return mpi3mr_expander_phy_control(mrioc, phy,
> +		    (enable =3D=3D 1) ? SMP_PHY_CONTROL_LINK_RESET :
> +		    SMP_PHY_CONTROL_DISABLE);
> +
> +	/* handle hba phys */
> +
> +	/* read sas_iounit page 0 */
> +	sz =3D offsetof(struct mpi3_sas_io_unit_page0, phy_data) +
> +		(mrioc->sas_hba.num_phys *
> +		 sizeof(struct mpi3_sas_io_unit0_phy_data));
> +	sas_io_unit_pg0 =3D kzalloc(sz, GFP_KERNEL);
> +	if (!sas_io_unit_pg0) {
> +		rc =3D -ENOMEM;
> +		goto out;
> +	}
> +	if (mpi3mr_cfg_get_sas_io_unit_pg0(mrioc, sas_io_unit_pg0, sz)) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		rc =3D -ENXIO;
> +		goto out;
> +	}
> +
> +	/* unable to enable/disable phys when discovery is active */
> +	for (i =3D 0, discovery_active =3D 0; i < mrioc->sas_hba.num_phys ; i++=
) {
> +		if (sas_io_unit_pg0->phy_data[i].port_flags &
> +		    MPI3_SASIOUNIT0_PORTFLAGS_DISC_IN_PROGRESS) {
> +			ioc_err(mrioc,
> +			    "discovery is active on port =3D %d, phy =3D %d\n"
> +			    "\tunable to enable/disable phys, try again later!\n",
> +			    sas_io_unit_pg0->phy_data[i].io_unit_port, i);
> +			discovery_active =3D 1;
> +		}
> +	}
> +
> +	if (discovery_active) {
> +		rc =3D -EAGAIN;
> +		goto out;
> +	}
> +
> +	if ((sas_io_unit_pg0->phy_data[phy->number].phy_flags &
> +	     (MPI3_SASIOUNIT0_PHYFLAGS_HOST_PHY |
> +	      MPI3_SASIOUNIT0_PHYFLAGS_VIRTUAL_PHY))) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		rc =3D -ENXIO;
> +		goto out;
> +	}
> +
> +
Remove newline

> +	/* read sas_iounit page 1 */
> +	sz =3D offsetof(struct mpi3_sas_io_unit_page1, phy_data) +
> +		(mrioc->sas_hba.num_phys *
> +		 sizeof(struct mpi3_sas_io_unit1_phy_data));
> +	sas_io_unit_pg1 =3D kzalloc(sz, GFP_KERNEL);
> +	if (!sas_io_unit_pg1) {
> +		rc =3D -ENOMEM;
> +		goto out;
> +	}
> +
> +	if (mpi3mr_cfg_get_sas_io_unit_pg1(mrioc, sas_io_unit_pg1, sz)) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		rc =3D -ENXIO;
> +		goto out;
> +	}
> +
> +	if (enable)
> +		sas_io_unit_pg1->phy_data[phy->number].phy_flags
> +		    &=3D ~MPI3_SASIOUNIT1_PHYFLAGS_PHY_DISABLE;
> +	else
> +		sas_io_unit_pg1->phy_data[phy->number].phy_flags
> +		    |=3D MPI3_SASIOUNIT1_PHYFLAGS_PHY_DISABLE;
> +
> +	mpi3mr_cfg_set_sas_io_unit_pg1(mrioc, sas_io_unit_pg1, sz);
> +
> +	/* link reset */
> +	if (enable)
> +		mpi3mr_transport_phy_reset(phy, 0);
> +
> + out:
> +	kfree(sas_io_unit_pg1);
> +	kfree(sas_io_unit_pg0);
> +	return rc;
> +}
> +
> +/**
> + * mpi3mr_transport_phy_speed - set phy min/max speed
> + * @phy: The SAS transport later phy object
> + * @rates: Rates defined as in sas_phy_linkrates
> + *
> + * This function sets the link rates given in the rates
> + * argument to the given phy by executing required configuration
> + * page changes or expander phy control command
> + *
> + * Return: 0 for success, non-zero for failure.
> + */
> +static int
> +mpi3mr_transport_phy_speed(struct sas_phy *phy, struct sas_phy_linkrates=
 *rates)
> +{
> +
Remove newline here=20
=20
> +	struct mpi3mr_ioc *mrioc =3D phy_to_mrioc(phy);
> +	struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1 =3D NULL;
> +	struct mpi3_sas_phy_page0 phy_pg0;
> +	u16 sz, ioc_status;
> +	int rc =3D 0;
> +
> +	rc =3D mpi3mr_parent_present(mrioc, phy);
> +	if (rc)
> +		return rc;
> +
> +	if (!rates->minimum_linkrate)
> +		rates->minimum_linkrate =3D phy->minimum_linkrate;
> +	else if (rates->minimum_linkrate < phy->minimum_linkrate_hw)
> +		rates->minimum_linkrate =3D phy->minimum_linkrate_hw;
> +
> +	if (!rates->maximum_linkrate)
> +		rates->maximum_linkrate =3D phy->maximum_linkrate;
> +	else if (rates->maximum_linkrate > phy->maximum_linkrate_hw)
> +		rates->maximum_linkrate =3D phy->maximum_linkrate_hw;
> +
> +	/* handle expander phys */
> +	if (phy->identify.sas_address !=3D mrioc->sas_hba.sas_address) {
> +		phy->minimum_linkrate =3D rates->minimum_linkrate;
> +		phy->maximum_linkrate =3D rates->maximum_linkrate;
> +		return mpi3mr_expander_phy_control(mrioc, phy,
> +		    SMP_PHY_CONTROL_LINK_RESET);
> +	}
> +
> +	/* handle hba phys */
> +
Looks like missing code chunk or stray comment.=20

> +	/* sas_iounit page 1 */
> +	sz =3D offsetof(struct mpi3_sas_io_unit_page1, phy_data) +
> +		(mrioc->sas_hba.num_phys *
> +		 sizeof(struct mpi3_sas_io_unit1_phy_data));
> +	sas_io_unit_pg1 =3D kzalloc(sz, GFP_KERNEL);
> +	if (!sas_io_unit_pg1) {
> +		rc =3D -ENOMEM;
> +		goto out;
> +	}
> +
> +	if (mpi3mr_cfg_get_sas_io_unit_pg1(mrioc, sas_io_unit_pg1, sz)) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		rc =3D -ENXIO;
> +		goto out;
> +	}
> +
> +	sas_io_unit_pg1->phy_data[phy->number].max_min_link_rate =3D
> +		(rates->minimum_linkrate + (rates->maximum_linkrate << 4));
> +
> +	if (mpi3mr_cfg_set_sas_io_unit_pg1(mrioc, sas_io_unit_pg1, sz)) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		rc =3D -ENXIO;
> +		goto out;
> +	}
> +
> +	/* link reset */
> +	mpi3mr_transport_phy_reset(phy, 0);
> +
> +	/* read phy page 0, then update the rates in the sas transport phy */
> +	if (!mpi3mr_cfg_get_sas_phy_pg0(mrioc, &ioc_status, &phy_pg0,
> +	    sizeof(struct mpi3_sas_phy_page0),
> +	    MPI3_SAS_PHY_PGAD_FORM_PHY_NUMBER, phy->number) &&
> +	    (ioc_status =3D=3D MPI3_IOCSTATUS_SUCCESS)) {
> +		phy->minimum_linkrate =3D mpi3mr_convert_phy_link_rate(
> +		    phy_pg0.programmed_link_rate &
> +		    MPI3_SAS_PRATE_MIN_RATE_MASK);
> +		phy->maximum_linkrate =3D mpi3mr_convert_phy_link_rate(
> +		    phy_pg0.programmed_link_rate >> 4);
> +		phy->negotiated_linkrate =3D
> +			mpi3mr_convert_phy_link_rate(
> +			    (phy_pg0.negotiated_link_rate &
> +			    MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK)
> +			    >> MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT);
> +	}
> +
> +out:
> +	kfree(sas_io_unit_pg1);
> +	return rc;
> +}
> +
> +
remove extra newline
> +/**
> + * mpi3mr_map_smp_buffer - map BSG dma buffer
> + * @dev: Generic device reference
> + * @buf: BSG buffer pointer
> + * @dma_addr: Physical address holder
> + * @dma_len: Mapped DMA buffer length.
> + * @p: Virtual address holder
> + *
> + * This function maps the DMAable buffer
> + *
> + * Return: 0 on success, non-zero on failure
> + */
> +
remove extra newline
> +static int
> +mpi3mr_map_smp_buffer(struct device *dev, struct bsg_buffer *buf,
> +		dma_addr_t *dma_addr, size_t *dma_len, void **p)
> +{
> +	/* Check if the request is split across multiple segments */
> +	if (buf->sg_cnt > 1) {
> +		*p =3D dma_alloc_coherent(dev, buf->payload_len, dma_addr,
> +				GFP_KERNEL);
> +		if (!*p)
> +			return -ENOMEM;
> +		*dma_len =3D buf->payload_len;
> +	} else {
> +		if (!dma_map_sg(dev, buf->sg_list, 1, DMA_BIDIRECTIONAL))
> +			return -ENOMEM;
> +		*dma_addr =3D sg_dma_address(buf->sg_list);
> +		*dma_len =3D sg_dma_len(buf->sg_list);
> +		*p =3D NULL;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * mpi3mr_unmap_smp_buffer - unmap BSG dma buffer
> + * @dev: Generic device reference
> + * @buf: BSG buffer pointer
> + * @dma_addr: Physical address to be unmapped
> + * @p: Virtual address
> + *
> + * This function unmaps the DMAable buffer
> + */
> +
> +static void
> +mpi3mr_unmap_smp_buffer(struct device *dev, struct bsg_buffer *buf,
> +		dma_addr_t dma_addr, void *p)
> +{
> +	if (p)
> +		dma_free_coherent(dev, buf->payload_len, p, dma_addr);
> +	else
> +		dma_unmap_sg(dev, buf->sg_list, 1, DMA_BIDIRECTIONAL);
> +}
> +
> +/**
> + * mpi3mr_transport_smp_handler - handler for smp passthru
> + * @job: BSG job reference
> + * @shost: SCSI host object reference
> + * @rphy: SAS transport rphy object pointing the expander
> + *
> + * This is used primarily by smp utils for sending the SMP
> + * commands to the expanders attached to the controller
> + */
> +static void
> +mpi3mr_transport_smp_handler(struct bsg_job *job, struct Scsi_Host *shos=
t,
> +	struct sas_rphy *rphy)
> +{
> +
Remove extra newline

> +	struct mpi3mr_ioc *mrioc =3D shost_priv(shost);
> +	struct mpi3_smp_passthrough_request mpi_request;
> +	struct mpi3_smp_passthrough_reply mpi_reply;
> +	int rc;
> +	void *psge;
> +	dma_addr_t dma_addr_in;
> +	dma_addr_t dma_addr_out;
> +	void *addr_in =3D NULL;
> +	void *addr_out =3D NULL;
> +	size_t dma_len_in;
> +	size_t dma_len_out;
> +	unsigned int reslen =3D 0;
> +	u16 request_sz =3D sizeof(struct mpi3_smp_passthrough_request);
> +	u16 reply_sz =3D sizeof(struct mpi3_smp_passthrough_reply);
> +	u8 sgl_flags =3D MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST;
> +	u16 ioc_status;
> +
> +
Ditto remove extra newline

> +	if (mrioc->reset_in_progress) {
> +		ioc_err(mrioc, "%s: host reset in progress!\n", __func__);
> +		rc =3D -EFAULT;
> +		goto out;
> +	}
> +
> +	rc =3D mpi3mr_map_smp_buffer(&mrioc->pdev->dev, &job->request_payload,
> +	    &dma_addr_out, &dma_len_out, &addr_out);
> +	if (rc)

> +		goto out;
> +
> +	if (addr_out)
> +		sg_copy_to_buffer(job->request_payload.sg_list,
> +		    job->request_payload.sg_cnt, addr_out,
> +		    job->request_payload.payload_len);
> +
> +	rc =3D mpi3mr_map_smp_buffer(&mrioc->pdev->dev, &job->reply_payload,
> +			&dma_addr_in, &dma_len_in, &addr_in);
> +	if (rc)
> +		goto unmap_out;
> +
> +	memset(&mpi_request, 0, request_sz);
> +	memset(&mpi_reply, 0, reply_sz);
> +	mpi_request.host_tag =3D cpu_to_le16(MPI3MR_HOSTTAG_TRANSPORT_CMDS);
> +	mpi_request.function =3D MPI3_FUNCTION_SMP_PASSTHROUGH;
> +	mpi_request.io_unit_port =3D (u8) mpi3mr_get_port_id_by_rphy(mrioc, rph=
y);
> +	mpi_request.sas_address =3D ((rphy) ?
> +	    cpu_to_le64(rphy->identify.sas_address) :
> +	    cpu_to_le64(mrioc->sas_hba.sas_address));
> +	psge =3D &mpi_request.request_sge;
> +	mpi3mr_add_sg_single(psge, sgl_flags, dma_len_out - 4, dma_addr_out);
> +
> +	psge =3D &mpi_request.response_sge;
> +	mpi3mr_add_sg_single(psge, sgl_flags, dma_len_in - 4, dma_addr_in);
> +
> +
remove newline

> +	dprint_transport_info(mrioc, "sending SMP request\n");
> +
> +	if (mpi3mr_post_transport_req(mrioc, &mpi_request, request_sz,
> +	    &mpi_reply, reply_sz, MPI3MR_INTADMCMD_TIMEOUT, &ioc_status))
> +		goto unmap_in;
> +
> +	dprint_transport_info(mrioc,
> +	    "SMP request completed with ioc_status(0x%04x)\n", ioc_status);
> +
> +
Ditto same here ... remove newline

> +	dprint_transport_info(mrioc,
> +		    "SMP request - reply data transfer size(%d)\n",
> +		    le16_to_cpu(mpi_reply.response_data_length));
> +
> +	memcpy(job->reply, &mpi_reply, reply_sz);
> +	job->reply_len =3D reply_sz;
> +	reslen =3D le16_to_cpu(mpi_reply.response_data_length);
> +
> +	if (addr_in)
> +		sg_copy_from_buffer(job->reply_payload.sg_list,
> +				job->reply_payload.sg_cnt, addr_in,
> +				job->reply_payload.payload_len);
> +
> +	rc =3D 0;
> +unmap_in:
> +	mpi3mr_unmap_smp_buffer(&mrioc->pdev->dev, &job->reply_payload,
> +			dma_addr_in, addr_in);
> +unmap_out:
> +	mpi3mr_unmap_smp_buffer(&mrioc->pdev->dev, &job->request_payload,
> +			dma_addr_out, addr_out);
> +out:
> +	bsg_job_done(job, rc, reslen);
> +
remove newline

> +}
> +
> +struct sas_function_template mpi3mr_transport_functions =3D {
> +	.get_linkerrors		=3D mpi3mr_transport_get_linkerrors,
> +	.get_enclosure_identifier =3D mpi3mr_transport_get_enclosure_identifier=
,
> +	.get_bay_identifier	=3D mpi3mr_transport_get_bay_identifier,
> +	.phy_reset		=3D mpi3mr_transport_phy_reset,
> +	.phy_enable		=3D mpi3mr_transport_phy_enable,
> +	.set_phy_speed		=3D mpi3mr_transport_phy_speed,
> +	.smp_handler		=3D mpi3mr_transport_smp_handler,
> +};
> +
> +struct scsi_transport_template *mpi3mr_transport_template;
> --=20
> 2.27.0
>=20

After fixing all nits of formatting, you can add=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

