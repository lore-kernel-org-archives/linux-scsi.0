Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B29C00144
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 18:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238168AbiG2SN2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 14:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbiG2SN0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 14:13:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A3D61D62
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 11:13:25 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26THx1uF008321;
        Fri, 29 Jul 2022 18:13:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Ch3Pu+YuCSCYUezj2gZ5I9/Mcl1ZQUeJJTeYL5EQNpI=;
 b=Arg+VkOA1MtZFQWH4VaOVgWgJqNtGiso4y+JLii6T2OqyhKLUvxSGLmULYgTOmbjN57R
 qg+mWsuHuaFz/D2qNWZBsDZK8Eip6y3rdy6rtr+gPYIIMF9jq3Pec9x7X/f9TOHhvNgV
 p36xgxy2+kk3yZ0YM2648tnX5kEI+VuyuBf/qXtoFF+FfJ7aMIvmWqbPBeN+SYhJE65C
 8iZSzCtkH9yK/oVFMeOXolew3Fw9jDGlahq6ezIGLL/tsA41LGqYvFo7K73YcQQMwveu
 ZRA7XveT9Tw44+EdrgyhQ5bAzd7G5+FivqSCM9DWpRJcB7f8KjcCuVCA2KyUWqTZtItG yg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg940ykf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 18:13:23 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26THiaxw022985;
        Fri, 29 Jul 2022 18:13:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hh5yyr9pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 18:13:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LF/lLj/Ah7JTQgnvVcndpZbUaJ1zA3IxsDfRT0ZcMkKIhYB82bWlQqZwyTCT6UDNcg43Qou1eWitklI3mDcMdsAOLBh2nlpLqvdWiO7lnBvnQAN+9180H7h7MhA0ifK3eOS4wBF2zYL1QB2hK1HymjNfb/F9hZKLJELLUHcULOA0RY99C6m+tNjnMXU1bO8ShaTiZ7sece0u9gvsfRVJ1sOLN0kRT9D2BqSZ6PzQFKFnxlWBS8b9icFKPu+cAJ3fe6plwtYemWF6i6UAqqH8Iuci4KsvudUJ+q15dRYz3mGRtMcv8JYhFVYkw7cwkAUGMRbyxfkqtCJfd5l2lgJLKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ch3Pu+YuCSCYUezj2gZ5I9/Mcl1ZQUeJJTeYL5EQNpI=;
 b=AADK8a3iS2cIJvOk/Me+0qGj8yyQ+T5GKk4Ex7Syup7X8XnDlW7cyLBc0rGVJrBt8xO/z2ry85uvIwKnVqRmag0qDt0iqbeSDyOUprEqOQceFZVHXLmySKLZDexwDgRuQyswQW2+/IxNh5URvTjC3tqWUCJsokx+XD/qjB0ZrCa4YpQQTmoxksVPMUnprO1u28xnvvNvqOG88c7a6ybNfihvaVogdScNhFu59bzJhxnWbwWSGWi5nBe6niISrcaloxsfE+/0bauTXuW1SobG+ig1PI+1dlZsFFYfVTc2J7RA0+83ALTX0LuBr5mnKhnGyHd8JOhRcfNJsgETB7nR0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ch3Pu+YuCSCYUezj2gZ5I9/Mcl1ZQUeJJTeYL5EQNpI=;
 b=TawIY9zo0jY2UOY6JWYfkKqGSqwJ2cTHwNTC8BorU4AQZFvII0jFCviIpfcS6zXMtilBM3tYjPt41NRzo4trRZ7K5JV1n2baHCfOfQ+F45IIZhmixeR7/vGwSYrpzG+CTwJAchfqvxLCsbx+0FudvFd47Kp3bpzjZkJJujCoqoI=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by PH7PR10MB5855.namprd10.prod.outlook.com (2603:10b6:510:13f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Fri, 29 Jul
 2022 18:13:20 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a99d:1057:f4ba:a4eb]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a99d:1057:f4ba:a4eb%3]) with mapi id 15.20.5458.025; Fri, 29 Jul 2022
 18:13:20 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [PATCH 03/15] mpi3mr: Added helper functions to retrieve cnfg
 pages
Thread-Topic: [PATCH 03/15] mpi3mr: Added helper functions to retrieve cnfg
 pages
Thread-Index: AQHYo0vg9PCHP9s+TECSdsFMeuvtyK2VpyqA
Date:   Fri, 29 Jul 2022 18:13:20 +0000
Message-ID: <90108689-ED5C-48EB-A287-3534364C42CA@oracle.com>
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
 <20220729131627.15019-4-sreekanth.reddy@broadcom.com>
In-Reply-To: <20220729131627.15019-4-sreekanth.reddy@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14d981be-a9d4-49ca-d6db-08da718e0476
x-ms-traffictypediagnostic: PH7PR10MB5855:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qMznFTL00slVIl3I6V71+cn/rmK3riGaBAel6muUkyk7y4LxRFFZDCbNRR7RWEu9808dymWYnk2PEYAFnXfL8SEzh0zbEAujPtWBe4UFhyt0J2qOxH+/iC2p3wzYK+u+bknq9r4IhQTu8TrhfF1wulc4Chap4TdMRYQ6zXHRowKclkYfxWlrlYKoLI+JCuQWxbccWl8yAD5A0w+OoKf0wm66KUgdVn22f5hj/T1/lJNROFoB7wR0ukPybjpthTUJOgZKBmLlMer2DrnP6t8jU2gOrBvC6kTlS3EJnyromHulqefAVSWQWSMaKSR6hK2OcN7uIi5+ZWEVNqjlI0ditE3986vVNu3MgKUAKVTHx2LRs4bbNdhGFLC1IVNyXhElxzXTaeAeFfKl8clvhyuroqFbbCp9vgQ73rI2Crd0Rm/sGrnX67SWY9TMn3HvCIAE7PrjXyV0tAFdG7KxHgRCcRy2T9FdeFoUsL2x/cOu8mee1eH2YxDvKHwOBVIKGh2/tMlOnlKOzpDp3hEkvkGOaNY2RRycno8bUuusf4+dJUsiFUjrtq0n0T+a82zDD8nTadSJTxf6ecbhRDblkwcJQ3EW+QfYG8L6Kw8mOCGdndejAH/Au4ZaQH9XNrWW+HKoKFRstTIeQp6RIeNL80I96y1kj+iRQnLtWXTXmQExMG4VARwrwIpXCc46RcuChlBcUMKxLPpPhcX1oHuHWrO6RnL9jO6MN5v0qYimmxymHPXrnQNbtNESCVtM7tKLX8CMzMcB0gslF5llIWrYBSuXB9Z7mN8Se3TZfTgHUdp7S6FvrQfyw1EG/kplA1xsu2XNenOWOsrXl4wnFeNI1X+DIbRAm9SPRdlhmvYo7a1bQA0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(39860400002)(136003)(376002)(346002)(186003)(107886003)(83380400001)(54906003)(6916009)(316002)(53546011)(26005)(6512007)(6506007)(36756003)(2616005)(33656002)(30864003)(44832011)(41300700001)(2906002)(38070700005)(86362001)(8936002)(8676002)(64756008)(38100700002)(91956017)(66476007)(5660300002)(66446008)(6486002)(66556008)(4326008)(122000001)(66946007)(76116006)(478600001)(71200400001)(32563001)(45980500001)(559001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HC3Ro+CSOvNgr7JflOMaT2CwI2E5AHuf0fRohH/ENEgBDA3IgLkeQLG/BO9M?=
 =?us-ascii?Q?H1aH4dFOw8b9S/LHXej2mbJgh2isq7pWSjMbgQX7QmlGcoBcOHKAR5ooTvq9?=
 =?us-ascii?Q?AMVXZMQmPtF6qa7wE8bzAHbGWHy91c5Qj9Xo9AujQ496CNxQz57rmYkcyj2p?=
 =?us-ascii?Q?46mWYVwE3Qnc56suJXNjrY2kyKbX+KQEY/4gvrziK+KlzR1R5xg58Y9/HTY/?=
 =?us-ascii?Q?ulVQmup6knbJSAddVlJJ9Hbsd3AZbTd5FP7huyy5SIJiWf9pApHkd0GJGyMt?=
 =?us-ascii?Q?fEJ64y3h4v6dJ9X1dVX8vJRo2wsPMSVwKZuxFBdsjNTklt4yaybZ6ZtVBbJn?=
 =?us-ascii?Q?eSfWY85EPaQ+ESDsfh6VMaUG1gaBePS3GaKCfhyuQyUOWiIkG9jy4EaSlUig?=
 =?us-ascii?Q?8X/pc3z4KuivdtIKof51qrj6vryezB7eKXgNIvOeNt1C6TLdMBbdhHtXQfmt?=
 =?us-ascii?Q?q7rAG8WhyoqrfZmaf+kVpY1zG1apST6KboqoJLCRXCbiFA0AzR91TJ4vWAs8?=
 =?us-ascii?Q?8gcW/k1amN8jsg89seEYWLOEO0eB9faHTVv68eHRlDk+PDsCWPL/YZvxNyJw?=
 =?us-ascii?Q?aLoamBBvzUZED8fhF0OYrcyuloAt1I5q/9bvbhkxol619+7Ww7+OL8LdQGYq?=
 =?us-ascii?Q?LKQ1DoMYEI1122MpT50hNj0OZiJveBNIayrvLZVCaAA3/bL5fkog8Wms6Z3T?=
 =?us-ascii?Q?Ou6iMd5ilLlT2zfBNnmUF9Oa745JXOyBVjzTudqoUtgYAhyIFhpjS7DpOD4M?=
 =?us-ascii?Q?iiarkp9H54q5YcycWGAGZN2OgQDKdKTHjc7mTB+qKEi1HokYn+kSGlUYxNRp?=
 =?us-ascii?Q?GL6GnVNbZ19msNR3pvhsIy15arF5egXqh3KXO9dPoyb68qY69psN7OibZ2Jv?=
 =?us-ascii?Q?DuvjVE5AwEjpTmCBJSil2Ktzma4a/9wj1L4g9abYbwn5pp+kOruylh0DphNS?=
 =?us-ascii?Q?ER9UL0/3Zr0o8fo/49SrrFTcyRMn2DWEeq+SAEDJJNAlSqghrf+3ELJJcCEX?=
 =?us-ascii?Q?3Ap0d38zRmIP5GbJv8TJsF+zvS1p1B+v94gAzZUkkJvdPN30WdS26xwMlQ39?=
 =?us-ascii?Q?HNgEtjd4zwEP3d3eFMxNT0eVo3QP7DnD7AxFke+zE/2BoP2ZBoRGwxPxHuC8?=
 =?us-ascii?Q?oRv2ZfzBC8JReVpxB6cHMrduTZm0KjeCqFCcxgL9eU42RVeSEJH7LYxDeJz2?=
 =?us-ascii?Q?d33sK++jwuyfYCBBnOoLFXxoFOiJdMCR2Q1CvykDm7L8MNse4QVNxS+W3Vpt?=
 =?us-ascii?Q?XBhEFTwREa5SoFIJ9HyL2zkdB2VsRXOsYDwIYOsU/mQw4QW70lelD3DhpVJV?=
 =?us-ascii?Q?wsQoqESdVaSCCIHbbPU/jGOIwSgie6y6f3O9oy7eiHIuSNlJgh6pQTmzYb3I?=
 =?us-ascii?Q?3QqC4CkcmJNohGWadOEGyFnfETgq0tmw8tuTvnoA15mUUvXsozmvqr3ZXGLh?=
 =?us-ascii?Q?D+SX+gSOkVvbzB/KFrGuiW0LOVayu512ryWHSvm0XKqBgXbtQXKuKGDBzBWK?=
 =?us-ascii?Q?2GOvHKkLWlPYjUy4JiPMFApphqySz2w/ZB6Vk5d2jS9S8qa9Evbme40vLVPK?=
 =?us-ascii?Q?SWYoqB2PYJpP+aPktwm3CdF9Tz4PL1On3gbIRxVs6XYCE8ClrRzi7uonkXbt?=
 =?us-ascii?Q?hw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D3CE1893D476D440927229B25D024785@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14d981be-a9d4-49ca-d6db-08da718e0476
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 18:13:20.0225
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EpzOBMsiVXeBy/Xl20ZK0rL+UxkhjsAZagLQY2Zzq2NkOrJxPpOjg7omkwcy3kjacJT+PSiBA8tC/InEXmrdDtvEPxuG1Yn2ckChYRYL3Eo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5855
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-29_19,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207290076
X-Proofpoint-GUID: SzdNeON-G5Nrq5LqEuf_r_k18z4qZJp1
X-Proofpoint-ORIG-GUID: SzdNeON-G5Nrq5LqEuf_r_k18z4qZJp1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 29, 2022, at 6:16 AM, Sreekanth Reddy <sreekanth.reddy@broadcom.co=
m> wrote:
>=20
> Added helper functions to retrieve below controller's
> config pages,
> - SAS IOUnit Page0
> - SAS IOUnit Page1
> - Driver Page1
> - Device Page0
> - SAS Phy Page0
> - SAS Phy Page1
> - SAS Expander Page0
> - SAS Expander Page1
> - Enclosure Page0
>=20
> Also added the helper function to set the SAS IOUnit Page1.
>=20
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
> drivers/scsi/mpi3mr/mpi3mr.h    |  26 ++
> drivers/scsi/mpi3mr/mpi3mr_fw.c | 595 ++++++++++++++++++++++++++++++++
> 2 files changed, 621 insertions(+)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index e15ad0e..8af94d3 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -1179,4 +1179,30 @@ void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mr=
ioc, char *event_data,
> 	u16 event_data_size);
> extern const struct attribute_group *mpi3mr_host_groups[];
> extern const struct attribute_group *mpi3mr_dev_groups[];
> +
> +int mpi3mr_cfg_get_dev_pg0(struct mpi3mr_ioc *mrioc, u16 *ioc_status,
> +	struct mpi3_device_page0 *dev_pg0, u16 pg_sz, u32 form, u32 form_spec);
> +int mpi3mr_cfg_get_sas_phy_pg0(struct mpi3mr_ioc *mrioc, u16 *ioc_status=
,
> +	struct mpi3_sas_phy_page0 *phy_pg0, u16 pg_sz, u32 form,
> +	u32 form_spec);
> +int mpi3mr_cfg_get_sas_phy_pg1(struct mpi3mr_ioc *mrioc, u16 *ioc_status=
,
> +	struct mpi3_sas_phy_page1 *phy_pg1, u16 pg_sz, u32 form,
> +	u32 form_spec);
> +int mpi3mr_cfg_get_sas_exp_pg0(struct mpi3mr_ioc *mrioc, u16 *ioc_status=
,
> +	struct mpi3_sas_expander_page0 *exp_pg0, u16 pg_sz, u32 form,
> +	u32 form_spec);
> +int mpi3mr_cfg_get_sas_exp_pg1(struct mpi3mr_ioc *mrioc, u16 *ioc_status=
,
> +	struct mpi3_sas_expander_page1 *exp_pg1, u16 pg_sz, u32 form,
> +	u32 form_spec);
> +int mpi3mr_cfg_get_enclosure_pg0(struct mpi3mr_ioc *mrioc, u16 *ioc_stat=
us,
> +	struct mpi3_enclosure_page0 *encl_pg0, u16 pg_sz, u32 form,
> +	u32 form_spec);
> +int mpi3mr_cfg_get_sas_io_unit_pg0(struct mpi3mr_ioc *mrioc,
> +	struct mpi3_sas_io_unit_page0 *sas_io_unit_pg0, u16 pg_sz);
> +int mpi3mr_cfg_get_sas_io_unit_pg1(struct mpi3mr_ioc *mrioc,
> +	struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1, u16 pg_sz);
> +int mpi3mr_cfg_set_sas_io_unit_pg1(struct mpi3mr_ioc *mrioc,
> +	struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1, u16 pg_sz);
> +int mpi3mr_cfg_get_driver_pg1(struct mpi3mr_ioc *mrioc,
> +	struct mpi3_driver_page1 *driver_pg1, u16 pg_sz);
> #endif /*MPI3MR_H_INCLUDED*/
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index da6eceb..50e88d4 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -5042,3 +5042,598 @@ out:
> 	mpi3mr_free_config_dma_memory(mrioc, &mem_desc);
> 	return retval;
> }
> +
> +/**
> + * mpi3mr_cfg_get_dev_pg0 - Read current device page0
> + * @mrioc: Adapter instance reference
> + * @ioc_status: Pointer to return ioc status
> + * @dev_pg0: Pointer to return device page 0
> + * @pg_sz: Size of the memory allocated to the page pointer
> + * @form: The form to be used for addressing the page
> + * @form_spec: Form specific information like device handle
> + *
> + * This is handler for config page read for a specific device
> + * page0. The ioc_status has the controller returned ioc_status.
> + * This routine doesn't check ioc_status to decide whether the
> + * page read is success or not and it is the callers
> + * responsibility.
> + *
> + * Return: 0 on success, non-zero on failure.
> + */
> +int mpi3mr_cfg_get_dev_pg0(struct mpi3mr_ioc *mrioc, u16 *ioc_status,
> +	struct mpi3_device_page0 *dev_pg0, u16 pg_sz, u32 form, u32 form_spec)
> +{
> +	struct mpi3_config_page_header cfg_hdr;
> +	struct mpi3_config_request cfg_req;
> +	u32 page_address;
> +
> +	memset(dev_pg0, 0, pg_sz);
> +	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
> +	memset(&cfg_req, 0, sizeof(cfg_req));
> +
> +	cfg_req.function =3D MPI3_FUNCTION_CONFIG;
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_PAGE_HEADER;
> +	cfg_req.page_type =3D MPI3_CONFIG_PAGETYPE_DEVICE;
> +	cfg_req.page_number =3D 0;
> +	cfg_req.page_address =3D 0;
> +
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
> +	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
> +		ioc_err(mrioc, "device page0 header read failed\n");
> +		goto out_failed;
> +	}
> +	if (*ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "device page0 header read failed with ioc_status(0x%04x=
)\n",
> +		    *ioc_status);
> +		goto out_failed;
> +	}
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_READ_CURRENT;
> +	page_address =3D ((form & MPI3_DEVICE_PGAD_FORM_MASK) |
> +	    (form_spec & MPI3_DEVICE_PGAD_HANDLE_MASK));
> +	cfg_req.page_address =3D cpu_to_le32(page_address);
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
> +	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, dev_pg0, pg_sz)) {
> +		ioc_err(mrioc, "device page0 read failed\n");
> +		goto out_failed;
> +	}
> +	return 0;
> +out_failed:
> +	return -1;
> +}
> +
> +
> +/**
> + * mpi3mr_cfg_get_sas_phy_pg0 - Read current SAS Phy page0
> + * @mrioc: Adapter instance reference
> + * @ioc_status: Pointer to return ioc status
> + * @phy_pg0: Pointer to return SAS Phy page 0
> + * @pg_sz: Size of the memory allocated to the page pointer
> + * @form: The form to be used for addressing the page
> + * @form_spec: Form specific information like phy number
> + *
> + * This is handler for config page read for a specific SAS Phy
> + * page0. The ioc_status has the controller returned ioc_status.
> + * This routine doesn't check ioc_status to decide whether the
> + * page read is success or not and it is the callers
> + * responsibility.
> + *
> + * Return: 0 on success, non-zero on failure.
> + */
> +int mpi3mr_cfg_get_sas_phy_pg0(struct mpi3mr_ioc *mrioc, u16 *ioc_status=
,
> +	struct mpi3_sas_phy_page0 *phy_pg0, u16 pg_sz, u32 form,
> +	u32 form_spec)
> +{
> +	struct mpi3_config_page_header cfg_hdr;
> +	struct mpi3_config_request cfg_req;
> +	u32 page_address;
> +
> +	memset(phy_pg0, 0, pg_sz);
> +	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
> +	memset(&cfg_req, 0, sizeof(cfg_req));
> +
> +	cfg_req.function =3D MPI3_FUNCTION_CONFIG;
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_PAGE_HEADER;
> +	cfg_req.page_type =3D MPI3_CONFIG_PAGETYPE_SAS_PHY;
> +	cfg_req.page_number =3D 0;
> +	cfg_req.page_address =3D 0;
> +
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
> +	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
> +		ioc_err(mrioc, "sas phy page0 header read failed\n");
> +		goto out_failed;
> +	}
> +	if (*ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "sas phy page0 header read failed with ioc_status(0x%04=
x)\n",
> +		    *ioc_status);
> +		goto out_failed;
> +	}
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_READ_CURRENT;
> +	page_address =3D ((form & MPI3_SAS_PHY_PGAD_FORM_MASK) |
> +	    (form_spec & MPI3_SAS_PHY_PGAD_PHY_NUMBER_MASK));
> +	cfg_req.page_address =3D cpu_to_le32(page_address);
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
> +	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, phy_pg0, pg_sz)) {
> +		ioc_err(mrioc, "sas phy page0 read failed\n");
> +		goto out_failed;
> +	}
> +	return 0;
> +out_failed:
> +	return -1;
> +}
> +
> +/**
> + * mpi3mr_cfg_get_sas_phy_pg1 - Read current SAS Phy page1
> + * @mrioc: Adapter instance reference
> + * @ioc_status: Pointer to return ioc status
> + * @phy_pg1: Pointer to return SAS Phy page 1
> + * @pg_sz: Size of the memory allocated to the page pointer
> + * @form: The form to be used for addressing the page
> + * @form_spec: Form specific information like phy number
> + *
> + * This is handler for config page read for a specific SAS Phy
> + * page1. The ioc_status has the controller returned ioc_status.
> + * This routine doesn't check ioc_status to decide whether the
> + * page read is success or not and it is the callers
> + * responsibility.
> + *
> + * Return: 0 on success, non-zero on failure.
> + */
> +int mpi3mr_cfg_get_sas_phy_pg1(struct mpi3mr_ioc *mrioc, u16 *ioc_status=
,
> +	struct mpi3_sas_phy_page1 *phy_pg1, u16 pg_sz, u32 form,
> +	u32 form_spec)
> +{
> +	struct mpi3_config_page_header cfg_hdr;
> +	struct mpi3_config_request cfg_req;
> +	u32 page_address;
> +
> +	memset(phy_pg1, 0, pg_sz);
> +	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
> +	memset(&cfg_req, 0, sizeof(cfg_req));
> +
> +	cfg_req.function =3D MPI3_FUNCTION_CONFIG;
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_PAGE_HEADER;
> +	cfg_req.page_type =3D MPI3_CONFIG_PAGETYPE_SAS_PHY;
> +	cfg_req.page_number =3D 1;
> +	cfg_req.page_address =3D 0;
> +
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
> +	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
> +		ioc_err(mrioc, "sas phy page1 header read failed\n");
> +		goto out_failed;
> +	}
> +	if (*ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "sas phy page1 header read failed with ioc_status(0x%04=
x)\n",
> +		    *ioc_status);
> +		goto out_failed;
> +	}
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_READ_CURRENT;
> +	page_address =3D ((form & MPI3_SAS_PHY_PGAD_FORM_MASK) |
> +	    (form_spec & MPI3_SAS_PHY_PGAD_PHY_NUMBER_MASK));
> +	cfg_req.page_address =3D cpu_to_le32(page_address);
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
> +	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, phy_pg1, pg_sz)) {
> +		ioc_err(mrioc, "sas phy page1 read failed\n");
> +		goto out_failed;
> +	}
> +	return 0;
> +out_failed:
> +	return -1;
> +}
> +
> +
> +/**
> + * mpi3mr_cfg_get_sas_exp_pg0 - Read current SAS Expander page0
> + * @mrioc: Adapter instance reference
> + * @ioc_status: Pointer to return ioc status
> + * @exp_pg0: Pointer to return SAS Expander page 0
> + * @pg_sz: Size of the memory allocated to the page pointer
> + * @form: The form to be used for addressing the page
> + * @form_spec: Form specific information like device handle
> + *
> + * This is handler for config page read for a specific SAS
> + * Expander page0. The ioc_status has the controller returned
> + * ioc_status. This routine doesn't check ioc_status to decide
> + * whether the page read is success or not and it is the callers
> + * responsibility.
> + *
> + * Return: 0 on success, non-zero on failure.
> + */
> +int mpi3mr_cfg_get_sas_exp_pg0(struct mpi3mr_ioc *mrioc, u16 *ioc_status=
,
> +	struct mpi3_sas_expander_page0 *exp_pg0, u16 pg_sz, u32 form,
> +	u32 form_spec)
> +{
> +	struct mpi3_config_page_header cfg_hdr;
> +	struct mpi3_config_request cfg_req;
> +	u32 page_address;
> +
> +	memset(exp_pg0, 0, pg_sz);
> +	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
> +	memset(&cfg_req, 0, sizeof(cfg_req));
> +
> +	cfg_req.function =3D MPI3_FUNCTION_CONFIG;
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_PAGE_HEADER;
> +	cfg_req.page_type =3D MPI3_CONFIG_PAGETYPE_SAS_EXPANDER;
> +	cfg_req.page_number =3D 0;
> +	cfg_req.page_address =3D 0;
> +
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
> +	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
> +		ioc_err(mrioc, "expander page0 header read failed\n");
> +		goto out_failed;
> +	}
> +	if (*ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "expander page0 header read failed with ioc_status(0x%0=
4x)\n",
> +		    *ioc_status);
> +		goto out_failed;
> +	}
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_READ_CURRENT;
> +	page_address =3D ((form & MPI3_SAS_EXPAND_PGAD_FORM_MASK) |
> +	    (form_spec & (MPI3_SAS_EXPAND_PGAD_PHYNUM_MASK |
> +	    MPI3_SAS_EXPAND_PGAD_HANDLE_MASK)));
> +	cfg_req.page_address =3D cpu_to_le32(page_address);
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
> +	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, exp_pg0, pg_sz)) {
> +		ioc_err(mrioc, "expander page0 read failed\n");
> +		goto out_failed;
> +	}
> +	return 0;
> +out_failed:
> +	return -1;
> +}
> +
> +/**
> + * mpi3mr_cfg_get_sas_exp_pg1 - Read current SAS Expander page1
> + * @mrioc: Adapter instance reference
> + * @ioc_status: Pointer to return ioc status
> + * @exp_pg1: Pointer to return SAS Expander page 1
> + * @pg_sz: Size of the memory allocated to the page pointer
> + * @form: The form to be used for addressing the page
> + * @form_spec: Form specific information like phy number
> + *
> + * This is handler for config page read for a specific SAS
> + * Expander page1. The ioc_status has the controller returned
> + * ioc_status. This routine doesn't check ioc_status to decide
> + * whether the page read is success or not and it is the callers
> + * responsibility.
> + *
> + * Return: 0 on success, non-zero on failure.
> + */
> +int mpi3mr_cfg_get_sas_exp_pg1(struct mpi3mr_ioc *mrioc, u16 *ioc_status=
,
> +	struct mpi3_sas_expander_page1 *exp_pg1, u16 pg_sz, u32 form,
> +	u32 form_spec)
> +{
> +	struct mpi3_config_page_header cfg_hdr;
> +	struct mpi3_config_request cfg_req;
> +	u32 page_address;
> +
> +	memset(exp_pg1, 0, pg_sz);
> +	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
> +	memset(&cfg_req, 0, sizeof(cfg_req));
> +
> +	cfg_req.function =3D MPI3_FUNCTION_CONFIG;
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_PAGE_HEADER;
> +	cfg_req.page_type =3D MPI3_CONFIG_PAGETYPE_SAS_EXPANDER;
> +	cfg_req.page_number =3D 1;
> +	cfg_req.page_address =3D 0;
> +
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
> +	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
> +		ioc_err(mrioc, "expander page1 header read failed\n");
> +		goto out_failed;
> +	}
> +	if (*ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "expander page1 header read failed with ioc_status(0x%0=
4x)\n",
> +		    *ioc_status);
> +		goto out_failed;
> +	}
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_READ_CURRENT;
> +	page_address =3D ((form & MPI3_SAS_EXPAND_PGAD_FORM_MASK) |
> +	    (form_spec & (MPI3_SAS_EXPAND_PGAD_PHYNUM_MASK |
> +	    MPI3_SAS_EXPAND_PGAD_HANDLE_MASK)));
> +	cfg_req.page_address =3D cpu_to_le32(page_address);
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
> +	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, exp_pg1, pg_sz)) {
> +		ioc_err(mrioc, "expander page1 read failed\n");
> +		goto out_failed;
> +	}
> +	return 0;
> +out_failed:
> +	return -1;
> +}
> +
> +/**
> + * mpi3mr_cfg_get_enclosure_pg0 - Read current Enclosure page0
> + * @mrioc: Adapter instance reference
> + * @ioc_status: Pointer to return ioc status
> + * @encl_pg0: Pointer to return Enclosure page 0
> + * @pg_sz: Size of the memory allocated to the page pointer
> + * @form: The form to be used for addressing the page
> + * @form_spec: Form specific information like device handle
> + *
> + * This is handler for config page read for a specific Enclosure
> + * page0. The ioc_status has the controller returned ioc_status.
> + * This routine doesn't check ioc_status to decide whether the
> + * page read is success or not and it is the callers
> + * responsibility.
> + *
> + * Return: 0 on success, non-zero on failure.
> + */
> +int mpi3mr_cfg_get_enclosure_pg0(struct mpi3mr_ioc *mrioc, u16 *ioc_stat=
us,
> +	struct mpi3_enclosure_page0 *encl_pg0, u16 pg_sz, u32 form,
> +	u32 form_spec)
> +{
> +	struct mpi3_config_page_header cfg_hdr;
> +	struct mpi3_config_request cfg_req;
> +	u32 page_address;
> +
> +	memset(encl_pg0, 0, pg_sz);
> +	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
> +	memset(&cfg_req, 0, sizeof(cfg_req));
> +
> +	cfg_req.function =3D MPI3_FUNCTION_CONFIG;
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_PAGE_HEADER;
> +	cfg_req.page_type =3D MPI3_CONFIG_PAGETYPE_ENCLOSURE;
> +	cfg_req.page_number =3D 0;
> +	cfg_req.page_address =3D 0;
> +
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
> +	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
> +		ioc_err(mrioc, "enclosure page0 header read failed\n");
> +		goto out_failed;
> +	}
> +	if (*ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "enclosure page0 header read failed with ioc_status(0x%=
04x)\n",
> +		    *ioc_status);
> +		goto out_failed;
> +	}
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_READ_CURRENT;
> +	page_address =3D ((form & MPI3_ENCLOS_PGAD_FORM_MASK) |
> +	    (form_spec & MPI3_ENCLOS_PGAD_HANDLE_MASK));
> +	cfg_req.page_address =3D cpu_to_le32(page_address);
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
> +	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, encl_pg0, pg_sz)) {
> +		ioc_err(mrioc, "enclosure page0 read failed\n");
> +		goto out_failed;
> +	}
> +	return 0;
> +out_failed:
> +	return -1;
> +}
> +
> +
> +/**
> + * mpi3mr_cfg_get_sas_io_unit_pg0 - Read current SASIOUnit page0
> + * @mrioc: Adapter instance reference
> + * @sas_io_unit_pg0: Pointer to return SAS IO Unit page 0
> + * @pg_sz: Size of the memory allocated to the page pointer
> + *
> + * This is handler for config page read for the SAS IO Unit
> + * page0. This routine checks ioc_status to decide whether the
> + * page read is success or not.
> + *
> + * Return: 0 on success, non-zero on failure.
> + */
> +int mpi3mr_cfg_get_sas_io_unit_pg0(struct mpi3mr_ioc *mrioc,
> +	struct mpi3_sas_io_unit_page0 *sas_io_unit_pg0, u16 pg_sz)
> +{
> +	struct mpi3_config_page_header cfg_hdr;
> +	struct mpi3_config_request cfg_req;
> +	u16 ioc_status =3D 0;
> +
> +	memset(sas_io_unit_pg0, 0, pg_sz);
> +	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
> +	memset(&cfg_req, 0, sizeof(cfg_req));
> +
> +	cfg_req.function =3D MPI3_FUNCTION_CONFIG;
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_PAGE_HEADER;
> +	cfg_req.page_type =3D MPI3_CONFIG_PAGETYPE_SAS_IO_UNIT;
> +	cfg_req.page_number =3D 0;
> +	cfg_req.page_address =3D 0;
> +
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
> +	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, &cfg_hdr, sizeof(cfg_hdr))) =
{
> +		ioc_err(mrioc, "sas io unit page0 header read failed\n");
> +		goto out_failed;
> +	}
> +	if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "sas io unit page0 header read failed with ioc_status(0=
x%04x)\n",
> +		    ioc_status);
> +		goto out_failed;
> +	}
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_READ_CURRENT;
> +
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
> +	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, sas_io_unit_pg0, pg_sz)) {
> +		ioc_err(mrioc, "sas io unit page0 read failed\n");
> +		goto out_failed;
> +	}
> +	if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "sas io unit page0 read failed with ioc_status(0x%04x)\=
n",
> +		    ioc_status);
> +		goto out_failed;
> +	}
> +	return 0;
> +out_failed:
> +	return -1;
> +}
> +
> +/**
> + * mpi3mr_cfg_get_sas_io_unit_pg1 - Read current SASIOUnit page1
> + * @mrioc: Adapter instance reference
> + * @sas_io_unit_pg1: Pointer to return SAS IO Unit page 1
> + * @pg_sz: Size of the memory allocated to the page pointer
> + *
> + * This is handler for config page read for the SAS IO Unit
> + * page1. This routine checks ioc_status to decide whether the
> + * page read is success or not.
> + *
> + * Return: 0 on success, non-zero on failure.
> + */
> +int mpi3mr_cfg_get_sas_io_unit_pg1(struct mpi3mr_ioc *mrioc,
> +	struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1, u16 pg_sz)
> +{
> +	struct mpi3_config_page_header cfg_hdr;
> +	struct mpi3_config_request cfg_req;
> +	u16 ioc_status =3D 0;
> +
> +	memset(sas_io_unit_pg1, 0, pg_sz);
> +	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
> +	memset(&cfg_req, 0, sizeof(cfg_req));
> +
> +	cfg_req.function =3D MPI3_FUNCTION_CONFIG;
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_PAGE_HEADER;
> +	cfg_req.page_type =3D MPI3_CONFIG_PAGETYPE_SAS_IO_UNIT;
> +	cfg_req.page_number =3D 1;
> +	cfg_req.page_address =3D 0;
> +
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
> +	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, &cfg_hdr, sizeof(cfg_hdr))) =
{
> +		ioc_err(mrioc, "sas io unit page1 header read failed\n");
> +		goto out_failed;
> +	}
> +	if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "sas io unit page1 header read failed with ioc_status(0=
x%04x)\n",
> +		    ioc_status);
> +		goto out_failed;
> +	}
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_READ_CURRENT;
> +
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
> +	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, sas_io_unit_pg1, pg_sz)) {
> +		ioc_err(mrioc, "sas io unit page1 read failed\n");
> +		goto out_failed;
> +	}
> +	if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "sas io unit page1 read failed with ioc_status(0x%04x)\=
n",
> +		    ioc_status);
> +		goto out_failed;
> +	}
> +	return 0;
> +out_failed:
> +	return -1;
> +}
> +
> +/**
> + * mpi3mr_cfg_set_sas_io_unit_pg1 - Write SASIOUnit page1
> + * @mrioc: Adapter instance reference
> + * @sas_io_unit_pg1: Pointer to the SAS IO Unit page 1 to write
> + * @pg_sz: Size of the memory allocated to the page pointer
> + *
> + * This is handler for config page write for the SAS IO Unit
> + * page1. This routine checks ioc_status to decide whether the
> + * page read is success or not. This will modify both current
> + * and persistent page.
> + *
> + * Return: 0 on success, non-zero on failure.
> + */
> +int mpi3mr_cfg_set_sas_io_unit_pg1(struct mpi3mr_ioc *mrioc,
> +	struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1, u16 pg_sz)
> +{
> +	struct mpi3_config_page_header cfg_hdr;
> +	struct mpi3_config_request cfg_req;
> +	u16 ioc_status =3D 0;
> +
> +	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
> +	memset(&cfg_req, 0, sizeof(cfg_req));
> +
> +	cfg_req.function =3D MPI3_FUNCTION_CONFIG;
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_PAGE_HEADER;
> +	cfg_req.page_type =3D MPI3_CONFIG_PAGETYPE_SAS_IO_UNIT;
> +	cfg_req.page_number =3D 1;
> +	cfg_req.page_address =3D 0;
> +
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
> +	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, &cfg_hdr, sizeof(cfg_hdr))) =
{
> +		ioc_err(mrioc, "sas io unit page1 header read failed\n");
> +		goto out_failed;
> +	}
> +	if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "sas io unit page1 header read failed with ioc_status(0=
x%04x)\n",
> +		    ioc_status);
> +		goto out_failed;
> +	}
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_WRITE_CURRENT;
> +
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
> +	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, sas_io_unit_pg1, pg_sz)) {
> +		ioc_err(mrioc, "sas io unit page1 write current failed\n");
> +		goto out_failed;
> +	}
> +	if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "sas io unit page1 write current failed with ioc_status=
(0x%04x)\n",
> +		    ioc_status);
> +		goto out_failed;
> +	}
> +
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_WRITE_PERSISTENT;
> +
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
> +	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, sas_io_unit_pg1, pg_sz)) {
> +		ioc_err(mrioc, "sas io unit page1 write persistent failed\n");
> +		goto out_failed;
> +	}
> +	if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "sas io unit page1 write persistent failed with ioc_sta=
tus(0x%04x)\n",
> +		    ioc_status);
> +		goto out_failed;
> +	}
> +	return 0;
> +out_failed:
> +	return -1;
> +}
> +
> +/**
> + * mpi3mr_cfg_get_driver_pg1 - Read current Driver page1
> + * @mrioc: Adapter instance reference
> + * @driver_pg1: Pointer to return Driver page 1
> + * @pg_sz: Size of the memory allocated to the page pointer
> + *
> + * This is handler for config page read for the Driver page1.
> + * This routine checks ioc_status to decide whether the page
> + * read is success or not.
> + *
> + * Return: 0 on success, non-zero on failure.
> + */
> +int mpi3mr_cfg_get_driver_pg1(struct mpi3mr_ioc *mrioc,
> +	struct mpi3_driver_page1 *driver_pg1, u16 pg_sz)
> +{
> +	struct mpi3_config_page_header cfg_hdr;
> +	struct mpi3_config_request cfg_req;
> +	u16 ioc_status =3D 0;
> +
> +	memset(driver_pg1, 0, pg_sz);
> +	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
> +	memset(&cfg_req, 0, sizeof(cfg_req));
> +
> +	cfg_req.function =3D MPI3_FUNCTION_CONFIG;
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_PAGE_HEADER;
> +	cfg_req.page_type =3D MPI3_CONFIG_PAGETYPE_DRIVER;
> +	cfg_req.page_number =3D 1;
> +	cfg_req.page_address =3D 0;
> +
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
> +	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, &cfg_hdr, sizeof(cfg_hdr))) =
{
> +		ioc_err(mrioc, "driver page1 header read failed\n");
> +		goto out_failed;
> +	}
> +	if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "driver page1 header read failed with ioc_status(0x%04x=
)\n",
> +		    ioc_status);
> +		goto out_failed;
> +	}
> +	cfg_req.action =3D MPI3_CONFIG_ACTION_READ_CURRENT;
> +
> +	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
> +	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, driver_pg1, pg_sz)) {
> +		ioc_err(mrioc, "driver page1 read failed\n");
> +		goto out_failed;
> +	}
> +	if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "driver page1 read failed with ioc_status(0x%04x)\n",
> +		    ioc_status);
> +		goto out_failed;
> +	}
> +	return 0;
> +out_failed:
> +	return -1;
> +}
> --=20
> 2.27.0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

