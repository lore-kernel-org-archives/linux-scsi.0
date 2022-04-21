Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E8EC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 20:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392227AbiDUUQN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 16:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbiDUUQM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 16:16:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918F263C8
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 13:13:21 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LJOIKH011972;
        Thu, 21 Apr 2022 20:13:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=QYqpFpnwz65vNGQ+OsnfrQ6bWAzt0wsFE0qEIgN3Ukc=;
 b=nZ/UliCgDtDUSWqATSeBTEty2pKUxnybGz/KG9/Kh6I+Wp0i6mupnefnE6yjit/LtyI7
 cSpQ7oBwQid59YKLMDkUEerCxV4W92LN3oHg2IX8ApCkHP16t9fyLcsdjDyhxEau8Z3+
 wYexqYm5qhcCvpm/7xBbP563INRtVFCegcIL9IBwFJFA8l6dl8s7lTEOeAW1DZi3Gipm
 JXusV76XIBUP0S/+85sWFwZvOd8DPXUOfM8EpfAOvvOOJEWBr3j1RQwqy2UyT7bWyLt4
 gY+E2LHLSn0EPLX3dA9piOs0+gQpdSV/aWTjpf2CFKg/78gC9HA+LFuO0Lnya+Qoyy4E zA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffpbvdctr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 20:13:09 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23LKCCcQ010978;
        Thu, 21 Apr 2022 20:13:08 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm8cqwwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 20:13:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6Fs2cByh6ZPXeGpiAvAbf33CnGSaNE2MkKvbJ2TuAVwSDvsi7I1Lg8RQapOexSWKcYy1XN5//T3KbeatlqFtkmUxiLDWR/HhAROxHb0B+e+f43hNBwSM5Jza1EYtGj9glv+95Rv7FJ9hVVZ7MOqvdeTJnk3XSyYCBwYTl50ROjTCBK/OmsnUfgbkYuftSGN+zE1oRL81nOeAOuOMIThe4gRc7Z9RjtXMc0SU2ts/QcpPldhlArQf4BTDFkxRsr0/fXxIa89OUCJyUjnxdXK+hmLnM5O3VxwCzfpQXvJgXvawlJV+oAd392s7SwMomsxlZc58QtvRnDY5sFhRz1vnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QYqpFpnwz65vNGQ+OsnfrQ6bWAzt0wsFE0qEIgN3Ukc=;
 b=dtoAi2LB9RgWNCFKPCr5em07WVzxBoIliTntvbbdaPB8w6m8YfE2oe4bGYR+Z8QiyucQ3fvXkM2jeklQfbrJMCKDf/96VtTojBZBSTOM3XPBfv83wkuyhqDuyTwWexbE1uVwJNEfpunsT1q6l+tcC5/bjHitCa2eeV0ZhXHc4A9dw32t+q6YTYIfjMriNK1LDxB5KHjYtghdEj4plYfwXaTRpsv4hFC3fp5wD3R7SvnXbh4cLGew1ttcBTG8uvBBQiX3Hr6Q0VyyPoBiEl4Tcvj57j97G2Ks6RuAsV9N2sWNRUcKOuJAoWUn2VktjvndbRkhI/sDfX3f60+r7rIZIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYqpFpnwz65vNGQ+OsnfrQ6bWAzt0wsFE0qEIgN3Ukc=;
 b=vt+PLaK6SHg8tRwxs+/Niqq3FeW3sl6L/t91ZbmHFSR7U8aQSsDbAjQIN+toiW0B1uO9zJIRQNpMyUvUHMrsktkj6br2P5CTsKVvk1ICroa5f74WhomB7avqn0waB3Ft0Sb5LrGzNn6vPllHhBAPtUhsRJO5MTPFIYSQBP8Ud1s=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CY4PR10MB1910.namprd10.prod.outlook.com (2603:10b6:903:123::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 21 Apr
 2022 20:13:06 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c%7]) with mapi id 15.20.5164.026; Thu, 21 Apr 2022
 20:13:06 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 4/9] scsi: sd_zbc: Introduce struct zoned_disk_info
Thread-Topic: [PATCH v2 4/9] scsi: sd_zbc: Introduce struct zoned_disk_info
Thread-Index: AQHYVa4+gzReq/+FqE6ks12ivawOnKz6zQ6A
Date:   Thu, 21 Apr 2022 20:13:06 +0000
Message-ID: <EDABBE13-7865-4F3B-86BD-7214C1A9935E@oracle.com>
References: <20220421183023.3462291-1-bvanassche@acm.org>
 <20220421183023.3462291-5-bvanassche@acm.org>
In-Reply-To: <20220421183023.3462291-5-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f52b51ee-a1a8-487a-c2c1-08da23d35905
x-ms-traffictypediagnostic: CY4PR10MB1910:EE_
x-microsoft-antispam-prvs: <CY4PR10MB191040126F97096A52ACC7C6E6F49@CY4PR10MB1910.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s+pwF6/LUXyX+z061DBdsJTOBQDxM8A7PHnc2RWTndGwJ5uYm3jU3uBvH0Ami13zocfyWLOBzczu4MQZcHsL8NB0M/xZnnABzlsLvrOBh5nomgyQNJa6Z2HPjj/agY9SmoEfs2K5aIpLoHrJLs4hi7BUb5vEDoZz8ODPLmgv9lm+7SADCNBFgYfDDVwW2fHevFVv3IpKQaRC5vPUEJtWFH73LCFFpCvNID+YvkvXvlmVQJFvMJ4i4FuxFgnq3OLJHo2yuM7J3TfGNYmV6/yIeYHAG7bI+cCKj0f+Y0hmzDIt0OEaEG5A4QPu0Ii1N6LHESaeIkyZI3kK4qVe/iFnVyPg5zbWC1vnvB6Cvc/7M7MK1gX7FcN7KRa3/eUiytgr7p6bvEFI1MO4JJWMP51XEe4A5M7YcI+HSk5tzIcRzB9ZyfrLFaqkj7Zsi8e9nnXf3CB7oYjMgIfvxtMuyw0aeqph3jRsjUO/9rW190dQJ6K+Szq607mWt4D+lTTHG95rdmLDbzAiiO3ZaJ+uIlV2owgh71YmtXZHVVL4cSA4lrNHTIJlvojnezqEo/YrxWU9x4cFARv1FTFanVLMoLXSRQMnqpPv4JioDojEynNX0nythGM2swpavUReGp9jbnL9U4v2VdzuqBUZH1WOtYcHPaQiVcNSLfyFq68q3yCZIF3uaoo8VKuM2NZMFNgBFfWV0GZPGUuYhL0qTqcQBvK4d35HaHMoL4bVCPU7G6oMWKs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(6506007)(4326008)(53546011)(71200400001)(2906002)(36756003)(91956017)(26005)(64756008)(38070700005)(6486002)(186003)(508600001)(2616005)(122000001)(5660300002)(8676002)(6512007)(83380400001)(66946007)(86362001)(8936002)(316002)(33656002)(44832011)(76116006)(66556008)(66446008)(66476007)(6916009)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OzTQt1yxc3gAjnzJNlr24uv4Gs2KuW+q0cCztFptUyJsZAr8nPm+69+8JfcP?=
 =?us-ascii?Q?VADgTR0WBqQekFMbQh4q0cb5k3q+viNKD2Fa7nJo3mEeNw5p5bLZxDgIjW/e?=
 =?us-ascii?Q?6u16Y/KCjvukvsFsxGDPDlugZEBK/h7TJmOvZzhU/wxqfG0303PlcUE/FaSj?=
 =?us-ascii?Q?U5RKDWusSHT/H6wTWyeD/RZjr+vvRODf3n+B0zIovX2bvPXQXHRUaah8uXX+?=
 =?us-ascii?Q?hgz17sTwHx1tsnNe7On6VFDo40roYu+/YEoyhAVPM1SNPix4NsmcNXCfO7/e?=
 =?us-ascii?Q?lWstRMaAnGzyJmTNqjn0GqAhBa55zHPN1XT06QDuZpVo9FYZAhasARIpFTdv?=
 =?us-ascii?Q?v9GXyxdH2MFrSgz87e8Y5KAaG9iQlL8dNfdySb1AYjhF5A4jbQZB0gFrgz4d?=
 =?us-ascii?Q?jqb+pDP/uJyOxM9ClUKWNNWsPogwqWlmZw3Ig4/VQuqARXK/pOUpfT46o0So?=
 =?us-ascii?Q?uFbAS7cXkB1aRJt1K7Ua72JYKEQwve+4g/KmPUV/GfAkb3PyjRQtIvPKvE8n?=
 =?us-ascii?Q?KK38shWz/hmIM3UH7S7PtroKwPZtZwVNUY6cC2wCGrbpLXbI/P9AFKJBRdht?=
 =?us-ascii?Q?LZYS1wY+rDxrx6tIKabmI+grCjV7tDoTcCoByKx5YAa9hnO2bqCGj47rGtki?=
 =?us-ascii?Q?2hJrFAiusVUE9z8cYkRpaetYqBpToS1Gsy9JEL7cMsi06sdH2iNbX6aY2D3N?=
 =?us-ascii?Q?ioPS2SNQ3cxnD5YKpQSB1Rzcqrq5uBX7dVYWFfZ+gDqO+zbQU5RGo1UvH4Fz?=
 =?us-ascii?Q?YmtrN/j1INJdLu49u7SN/+mFE1LbTcACwoHz8B6+hOd4cwCe8U5IErgBtcRL?=
 =?us-ascii?Q?6meXhgTvtTyVNHCa/T9RLy8nL0xbHoUT1SEcKyVrynrBBuSfGBCURv6JVOS1?=
 =?us-ascii?Q?mqYsYvPM7GRRDHbSEXug1pX1Fk8Q0hXvWY/kK9AEYYXQ7hToAdGBR80Ya4hM?=
 =?us-ascii?Q?NiGFUmLWQ7VRq+RUG1IV4zKYDzXrfyBDBpll7+yTEY3O2aKai4hyj7QFWGx/?=
 =?us-ascii?Q?OJdxPEFaI5vUl+XcEs76xz+7qtPTWGo8wKo/QaCkemps/SmUrV/w6EjZULPA?=
 =?us-ascii?Q?dWsZ8P+kM9r68nXrzofV3+YHuK39Wh9ynVcEi06WMH73moI2a0BvyDrsOPga?=
 =?us-ascii?Q?pRSySw2QvZM4cJosxW7G1gJ0XgISBgr73RrpS6581ULjwqDoCKw+NHwQPV1b?=
 =?us-ascii?Q?bUxOFq0ubPvKoiREHIceXEXol47VC5X9HoOb1g0XN/wTONJjrkpXrcjJQJsN?=
 =?us-ascii?Q?w0Q4yyNMC8pRvyrWA7SuMMyVVElILWswl1mKT60KuKSDcSGBgPWUunjcLFEQ?=
 =?us-ascii?Q?m9fZNRT9Y3c6tu2rr/32veniAmx4oLXKW624KcO1+blMdIcCWEWJpBWqQj37?=
 =?us-ascii?Q?emA3P5EIoJSh/rCxpjxPvzPsHy4vcYPlb6t3kpF1roagKDTo6sHAALTs3oKc?=
 =?us-ascii?Q?4TQWVI4dlUeWYc6MzVj/FKJq9o2p9hwCMgUFQRAq8Cq2Cf46MHofIJVlmdeF?=
 =?us-ascii?Q?9uL3EPRLU/zXBd4JP899FE4wTR8Y1gO2X8DrSCcLMvslKlIfow5TCKmKtnK3?=
 =?us-ascii?Q?moK1FXWMqk0rdMFdxzNQiI7XaAzeebU25dZT4lrHRmYN66olVk6bZgq5cwdm?=
 =?us-ascii?Q?qaIHkpNdkoR1HXOIgdOjHsd3w0zOVkTQGsMIACfnF4fbmCMhijm2BwqqXP7v?=
 =?us-ascii?Q?X/OVd5ZxCnMp/CsnLLq2tEhl/JVTMlWn84IciZLbenM0SGs3OxGO6fVREjTL?=
 =?us-ascii?Q?mRtMuZYyOGIgHmTBUtWSEJ+TMbGdi0117cJEFp15OxHOcGiiq5Co?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <089CC588EB831A40B2D3A620E9F41C54@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f52b51ee-a1a8-487a-c2c1-08da23d35905
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2022 20:13:06.3874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s/jHWeGTmBbUEohu15FQMK40BEctRcWU1NSV2EvIy68Fv/Nd7tGWu92voUVr2ePbbpysrZf4RtDK0LFadQA+GThufCNZOqiCDfNSEoBkz/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1910
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-21_04:2022-04-21,2022-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210107
X-Proofpoint-GUID: tMmwffWClrmgp9RZPWGmE_3fsKZE4XnQ
X-Proofpoint-ORIG-GUID: tMmwffWClrmgp9RZPWGmE_3fsKZE4XnQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 21, 2022, at 11:30 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Deriving the meaning of the nr_zones, rev_nr_zones, zone_blocks and
> rev_zone_blocks member variables requires careful analysis of the source
> code. Make the meaning of these member variables easier to understand by
> introducing struct zoned_disk_info.
>=20
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/sd.h     | 22 +++++++++++++++----
> drivers/scsi/sd_zbc.c | 49 ++++++++++++++++++++-----------------------
> 2 files changed, 41 insertions(+), 30 deletions(-)
>=20
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 4849cbe771a7..47434f905b0a 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -67,6 +67,20 @@ enum {
> 	SD_ZERO_WS10_UNMAP,	/* Use WRITE SAME(10) with UNMAP */
> };
>=20
> +/**
> + * struct zoned_disk_info - Specific properties of a ZBC SCSI device.
> + * @nr_zones: number of zones.
> + * @zone_blocks: number of logical blocks per zone.
> + *
> + * This data structure holds the ZBC SCSI device properties that are ret=
rieved
> + * twice: a first time before the gendisk capacity is known and a second=
 time
> + * after the gendisk capacity is known.
> + */
> +struct zoned_disk_info {
> +	u32		nr_zones;
> +	u32		zone_blocks;
> +};
> +
> struct scsi_disk {
> 	struct scsi_device *device;
>=20
> @@ -78,10 +92,10 @@ struct scsi_disk {
> 	struct gendisk	*disk;
> 	struct opal_dev *opal_dev;
> #ifdef CONFIG_BLK_DEV_ZONED
> -	u32		nr_zones;
> -	u32		rev_nr_zones;
> -	u32		zone_blocks;
> -	u32		rev_zone_blocks;
> +	/* Updated during revalidation before the gendisk capacity is known. */
> +	struct zoned_disk_info	early_zone_info;
> +	/* Updated during revalidation after the gendisk capacity is known. */
> +	struct zoned_disk_info	zone_info;
> 	u32		zones_optimal_open;
> 	u32		zones_optimal_nonseq;
> 	u32		zones_max_open;
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index e76bcbfd0d1c..ac557a5a65c8 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -181,7 +181,7 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_d=
isk *sdkp,
> 	 * sure that the allocated buffer can always be mapped by limiting the
> 	 * number of pages allocated to the HBA max segments limit.
> 	 */
> -	nr_zones =3D min(nr_zones, sdkp->nr_zones);
> +	nr_zones =3D min(nr_zones, sdkp->zone_info.nr_zones);
> 	bufsize =3D roundup((nr_zones + 1) * 64, SECTOR_SIZE);
> 	bufsize =3D min_t(size_t, bufsize,
> 			queue_max_hw_sectors(q) << SECTOR_SHIFT);
> @@ -206,7 +206,7 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_d=
isk *sdkp,
>  */
> static inline sector_t sd_zbc_zone_sectors(struct scsi_disk *sdkp)
> {
> -	return logical_to_sectors(sdkp->device, sdkp->zone_blocks);
> +	return logical_to_sectors(sdkp->device, sdkp->zone_info.zone_blocks);
> }
>=20
> /**
> @@ -262,7 +262,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_=
t sector,
> 			zone_idx++;
> 		}
>=20
> -		lba +=3D sdkp->zone_blocks * i;
> +		lba +=3D sdkp->zone_info.zone_blocks * i;
> 	}
>=20
> 	ret =3D zone_idx;
> @@ -320,14 +320,14 @@ static void sd_zbc_update_wp_offset_workfn(struct w=
ork_struct *work)
> 	sdkp =3D container_of(work, struct scsi_disk, zone_wp_offset_work);
>=20
> 	spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);
> -	for (zno =3D 0; zno < sdkp->nr_zones; zno++) {
> +	for (zno =3D 0; zno < sdkp->zone_info.nr_zones; zno++) {
> 		if (sdkp->zones_wp_offset[zno] !=3D SD_ZBC_UPDATING_WP_OFST)
> 			continue;
>=20
> 		spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);
> 		ret =3D sd_zbc_do_report_zones(sdkp, sdkp->zone_wp_update_buf,
> 					     SD_BUF_SIZE,
> -					     zno * sdkp->zone_blocks, true);
> +					     zno * sdkp->zone_info.zone_blocks, true);
> 		spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);
> 		if (!ret)
> 			sd_zbc_parse_report(sdkp, sdkp->zone_wp_update_buf + 64,
> @@ -394,7 +394,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_c=
mnd *cmd, sector_t *lba,
> 		break;
> 	default:
> 		wp_offset =3D sectors_to_logical(sdkp->device, wp_offset);
> -		if (wp_offset + nr_blocks > sdkp->zone_blocks) {
> +		if (wp_offset + nr_blocks > sdkp->zone_info.zone_blocks) {
> 			ret =3D BLK_STS_IOERR;
> 			break;
> 		}
> @@ -523,7 +523,7 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi=
_cmnd *cmd,
> 		break;
> 	case REQ_OP_ZONE_RESET_ALL:
> 		memset(sdkp->zones_wp_offset, 0,
> -		       sdkp->nr_zones * sizeof(unsigned int));
> +		       sdkp->zone_info.nr_zones * sizeof(unsigned int));
> 		break;
> 	default:
> 		break;
> @@ -680,16 +680,16 @@ static void sd_zbc_print_zones(struct scsi_disk *sd=
kp)
> 	if (!sd_is_zoned(sdkp) || !sdkp->capacity)
> 		return;
>=20
> -	if (sdkp->capacity & (sdkp->zone_blocks - 1))
> +	if (sdkp->capacity & (sdkp->zone_info.zone_blocks - 1))
> 		sd_printk(KERN_NOTICE, sdkp,
> 			  "%u zones of %u logical blocks + 1 runt zone\n",
> -			  sdkp->nr_zones - 1,
> -			  sdkp->zone_blocks);
> +			  sdkp->zone_info.nr_zones - 1,
> +			  sdkp->zone_info.zone_blocks);
> 	else
> 		sd_printk(KERN_NOTICE, sdkp,
> 			  "%u zones of %u logical blocks\n",
> -			  sdkp->nr_zones,
> -			  sdkp->zone_blocks);
> +			  sdkp->zone_info.nr_zones,
> +			  sdkp->zone_info.zone_blocks);
> }
>=20
> static int sd_zbc_init_disk(struct scsi_disk *sdkp)
> @@ -716,10 +716,8 @@ static void sd_zbc_clear_zone_info(struct scsi_disk =
*sdkp)
> 	kfree(sdkp->zone_wp_update_buf);
> 	sdkp->zone_wp_update_buf =3D NULL;
>=20
> -	sdkp->nr_zones =3D 0;
> -	sdkp->rev_nr_zones =3D 0;
> -	sdkp->zone_blocks =3D 0;
> -	sdkp->rev_zone_blocks =3D 0;
> +	sdkp->early_zone_info =3D (struct zoned_disk_info){ };
> +	sdkp->zone_info =3D (struct zoned_disk_info){ };
>=20
> 	mutex_unlock(&sdkp->rev_mutex);
> }
> @@ -746,8 +744,8 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
> {
> 	struct gendisk *disk =3D sdkp->disk;
> 	struct request_queue *q =3D disk->queue;
> -	u32 zone_blocks =3D sdkp->rev_zone_blocks;
> -	unsigned int nr_zones =3D sdkp->rev_nr_zones;
> +	u32 zone_blocks =3D sdkp->early_zone_info.zone_blocks;
> +	unsigned int nr_zones =3D sdkp->early_zone_info.nr_zones;
> 	u32 max_append;
> 	int ret =3D 0;
> 	unsigned int flags;
> @@ -778,14 +776,14 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
> 	 */
> 	mutex_lock(&sdkp->rev_mutex);
>=20
> -	if (sdkp->zone_blocks =3D=3D zone_blocks &&
> -	    sdkp->nr_zones =3D=3D nr_zones &&
> +	if (sdkp->zone_info.zone_blocks =3D=3D zone_blocks &&
> +	    sdkp->zone_info.nr_zones =3D=3D nr_zones &&
> 	    disk->queue->nr_zones =3D=3D nr_zones)
> 		goto unlock;
>=20
> 	flags =3D memalloc_noio_save();
> -	sdkp->zone_blocks =3D zone_blocks;
> -	sdkp->nr_zones =3D nr_zones;
> +	sdkp->zone_info.zone_blocks =3D zone_blocks;
> +	sdkp->zone_info.nr_zones =3D nr_zones;
> 	sdkp->rev_wp_offset =3D kvcalloc(nr_zones, sizeof(u32), GFP_KERNEL);
> 	if (!sdkp->rev_wp_offset) {
> 		ret =3D -ENOMEM;
> @@ -800,8 +798,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
> 	sdkp->rev_wp_offset =3D NULL;
>=20
> 	if (ret) {
> -		sdkp->zone_blocks =3D 0;
> -		sdkp->nr_zones =3D 0;
> +		sdkp->zone_info =3D (struct zoned_disk_info){ };
> 		sdkp->capacity =3D 0;
> 		goto unlock;
> 	}
> @@ -887,8 +884,8 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[=
SD_BUF_SIZE])
> 	if (blk_queue_zoned_model(q) =3D=3D BLK_ZONED_HM)
> 		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);
>=20
> -	sdkp->rev_nr_zones =3D nr_zones;
> -	sdkp->rev_zone_blocks =3D zone_blocks;
> +	sdkp->early_zone_info.nr_zones =3D nr_zones;
> +	sdkp->early_zone_info.zone_blocks =3D zone_blocks;
>=20
> 	return 0;
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

