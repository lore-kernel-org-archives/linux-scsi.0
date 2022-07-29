Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11354C00144
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 18:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238537AbiG2SeF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 14:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238523AbiG2SeC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 14:34:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E034F64F
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 11:34:01 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26TIWh0N030142;
        Fri, 29 Jul 2022 18:34:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=6Lf1ynpUyYV+FRptrydUR0U5WTDQePHX45/fsfrNZ1s=;
 b=UiqPcB0i1z1wDHJ11l1AujMQNaRGNlITRexctqpLdS5OZ09szndsDqwMXMUg8vBbLSHS
 rUuUkub5OsxPwfymSYrhAARiMLwBJq2KLshseW2op/21msdURCY9QyR3sLfEaoB2Htek
 eK7Ov95TY/xridfZ6UOgepP31hLC0IsyUtIwl6iNq/9G4LUmbNHjoyp8jV92SaEy1o0J
 K2PHftGkZDy8nphitGG4E+nnWu6Ab4qAuVEbAtJiwru6HJl0ZIm19GtKeoC9xPIYB+lC
 QAROP+ybyReeHPYVINaB5agEgxEQd5PE/bWcalLeI2NSUavYCkikHtpANfsRw7Isy3w8 lA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9a9r48c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 18:33:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26TI3LpA009160;
        Fri, 29 Jul 2022 18:33:59 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hm888t601-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 18:33:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B87Y+705XO14WvlUZaFLU3JQxdXGx44VO9tRh0+k37AOzxO83/T+nibvCfbqDIgejf5/dTLg1vDOGT/ns3H4QCjjyakQcPxLBExQ32sjKVdl/8f1CY+Jjf1se4Yzl9TUarnGqIeXyDVBKB6LF9bVMLV0oSk0yIrKfQ/9WYX0gz+PUiQurRqkkRHEghpnQLxIFMFkOqFtiSu7jHB4SXMmLRVxBCc+LUswczYHjIQg8sukKodUASO3CgXRQo8aw3kOUd9jMBj/DqOwT3eYvoHt2yMIeqHwmmkIzJhZN59lqpSSwhqOMWMsbQ61imqlpZVvZcB7MZC5aolr2+++ZKkWHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Lf1ynpUyYV+FRptrydUR0U5WTDQePHX45/fsfrNZ1s=;
 b=Jro90KSjceYVGzIusDy3ochgDDh5JdWQYkYUd7X6k8s0Lk9tqVIvFqp04GfrynTlnWuyMZY0RgXMBpPzLiizYE+MaNPvw5vPovpW9+Dt3VzJYOTPUnoxhNGrYLxwFPXeNjY2ONiIRtoXpxxdbkG/bOuHsJ/qyvqsUtefU0ORXTzjih17yRt7CHDRBlaFXRzuSOFxU+czAhiDAYpHvucybihzau2NtzWOBEdA1DTvpdNFOKHYiYDRxrKtBZQiiJKm8FkQDc/FmbGaMRixsofi5LrVh31DYJTxKul46s6mJ+5fdO3CNEexJma6S1Z6iPxz2OI9V7IyUU4Ykh7zZWiA2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Lf1ynpUyYV+FRptrydUR0U5WTDQePHX45/fsfrNZ1s=;
 b=xk3lWKVZ7IiqLYu3+ktxnJGnzyjf77CffsMsk9OGK4GIAMCoYgVhozlshFbydzel1nvlZiqAnov3IJtqgeK73th5mCln3kpTGSG61bx4mW/cwlDpVzHm+2Ww5GOziw7VJnUwyB/pLVxJAuouc+ywWLOrg6Nyl+hJDUy0x0ejrQs=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BYAPR10MB3558.namprd10.prod.outlook.com (2603:10b6:a03:122::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 29 Jul
 2022 18:33:56 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a99d:1057:f4ba:a4eb]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a99d:1057:f4ba:a4eb%3]) with mapi id 15.20.5458.025; Fri, 29 Jul 2022
 18:33:55 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [PATCH 04/15] mpi3mr: Enable Enclosure device add event
Thread-Topic: [PATCH 04/15] mpi3mr: Enable Enclosure device add event
Thread-Index: AQHYo0vuLVvTet8ItUyfjnlEM3K6pq2VrOsA
Date:   Fri, 29 Jul 2022 18:33:55 +0000
Message-ID: <295FBD75-B012-412F-9880-36E60AB61AD5@oracle.com>
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
 <20220729131627.15019-5-sreekanth.reddy@broadcom.com>
In-Reply-To: <20220729131627.15019-5-sreekanth.reddy@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04c2bfe9-dc59-4485-bd3b-08da7190e4e9
x-ms-traffictypediagnostic: BYAPR10MB3558:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FcgBO3itNDzyI/NLoIh2FR+81PKtPqnRDr1ELTFO1Q2XOxq0SV/aE2Go2obrHd0LSXUyPv97Rg0Z3+dmPjObk+97QMM/DM1Lw+pTFSBJ6XDMKGgw6UTXXRPvq09KKoCe1KAdBXhEUe861pcussA+nE62qjE33tVw9/Z1EfF6GHVgIR16zWb6fQ9DASFdOGbuzKGhCWv9vPYkvJ80bqyzbmXLCrQ7dcQzQe+JCVzq8txpO0KLHWbwSQooHj6Qg2rzQnyxOVC/2WsM4MUynNFaBOktE4qNQuBrc1qnhW/amJCwfpi5lCdvpeShdboKei5GeWI3pD35KS8yE2EzQySU8ng48EMY0aGFvt3mgCMrarD3T/CM1HLVo26TAZ1dJfjo+OLRSeeztmYV+vhaxKsnYSX2mRL6SuN7tstzwvXUKgBA1z52udnJ5ZKi/CHmqPw2WHyvYf4d1HimOqouxyMI81eRSf7GUkiXtg5irlJxgGSLlb80AHyaVGNkDeKZcw3E37RWR6Uz0QLO1y2cqMYVxzDHGrkYoxXd0LKLZzvviOQgQzqipOk8O/bjfryB4CR8UXL3Quc9XN7URaogReHJdfMw5ML6hpYVOaXqz+RfT781f5JsY1KbsrldV0Y7GXwCKdSHIpHRRTLqsQeWrXGN3c5LTI3HTNUCkk6A81FAN6lzi+jPIQQM2EZ7DjBAkppyoAcXWSmTKGWYsBDomdriiobUtjsNWyq4/pNOSFzegB13/LFL9yxJRdemKSnu/qFtQu8jAQt2Qx1ig74ZvuKIRqEDcmHAgUSK+RFWfr2gXNToKlB/krPa59RliIteQ2dhyy8XLbTHDlMR9XINOd+unFl/GqO+1B+g/R4T/HYroiw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(396003)(376002)(39860400002)(366004)(33656002)(53546011)(26005)(64756008)(2616005)(6506007)(38070700005)(83380400001)(38100700002)(86362001)(41300700001)(186003)(6512007)(107886003)(2906002)(91956017)(122000001)(76116006)(5660300002)(71200400001)(8676002)(8936002)(66946007)(4326008)(44832011)(66556008)(66446008)(6486002)(478600001)(6916009)(54906003)(30864003)(66476007)(36756003)(316002)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sOjsGGTSkccOROhFRSWX/k3YVZooCB/ORxfbne8/fHzt3zuqXUNq9d8p3/hu?=
 =?us-ascii?Q?URkAAH7MFhSgndzJdm5R+O+iJaKfd8Y3zr/SG/q2mCSTJo9PaJpnLP1GbkHU?=
 =?us-ascii?Q?LCiRON2CXLEwLOCG9ptdmE7n6e+eUO2LcExlt5ss8UpRBdgc06H2oDTSVQ4m?=
 =?us-ascii?Q?Rn6wb9Mz5c+7mx89KEvZ6w1SKHDqghZi0oYGvpGmtMzwpqCsRFO3Gnu5AMME?=
 =?us-ascii?Q?N6EDZa0oHn46mXBKRNcysDy04FRwwi36WOX4/AkF8d7ZJieET3lWsSJI0flj?=
 =?us-ascii?Q?1WbXVJsRqsyEhJoVscwfmiWvoro1FbYFWp6MS2AbNpWlcmQVlkKX4l81GmhW?=
 =?us-ascii?Q?YQfk5Xn5Oy+UgyLrc9bbn+n+Mn11Apv4B7Gblz3fv0xCNgtyKDAiRjN+hd/G?=
 =?us-ascii?Q?wC7d1FGYG5wY5X0AyajZybe9MwnjsjUstaKDN0DygBfCEpiXR7g+MiKm7oCa?=
 =?us-ascii?Q?kxfo2ru/7xdA0tqfpePCikzDqKB5TQcrpr9Mdi4RiDdVomWk1BO0El+TeF+1?=
 =?us-ascii?Q?5WyCsgYucsc09G3MvGeS0FTDXyzShijQy0KCpW37TZ6OSWEbUGMMg4OFn91Y?=
 =?us-ascii?Q?F0hcptLmFJKdVaWfaEtTsVx6k42ZoTUao7U/HXW+0GVFzJxjkKdWGgE92lRn?=
 =?us-ascii?Q?7/RMK7MDNBTJ2pn7uXaGEDNuZsZdJqLfa21JP8Puin5oV+6kUHb9L0iN0L2/?=
 =?us-ascii?Q?HhlsE0hmtz6HsC5xnrQDBnIGL5bbvyp8H8gWZEX9b5mw7ePrbQXnpWCPRJGU?=
 =?us-ascii?Q?kTUpReK2swfOGVkME5yZbhOT2MJte7ZDa3mG6bJ0KrD6u+sG4Tp/nnloE+/1?=
 =?us-ascii?Q?DxE92kPeJ3jNaxP15Z53WYzs4UI2zyNzPE0WP5cuWcm9zhDCs64bIYuXPbi5?=
 =?us-ascii?Q?6OVvgDyC6CeDfhNHLb//hGEelo848F/RU4nAXpf5GmLM1w6slhr9EHUBN3Cv?=
 =?us-ascii?Q?mpPB0xXF4b13+KhaFfhEz3aXuCsezIqwNzGpGPZRsqUeriIUom7e1A94QPBc?=
 =?us-ascii?Q?hsoDC09YegMfeRlnBftRHJJHVm/xo2GECH3HzM3nsK45iCK7UBsBs9w93Ulo?=
 =?us-ascii?Q?JB/BTfJhUOoPehASFeZDWXoVwpnt/h0R/jDGVJopJPkpnFtII2hjVILPNaf9?=
 =?us-ascii?Q?adpYQ7UyIX9rkpoYArRpDESoId6S8eZcw4a25Z2xTdy7O0Mt92j40XbrFPwh?=
 =?us-ascii?Q?wSezAH4aW/yKA3YKnj4PLG7Xbm8w/FpyahnkDcXh0gO6Y1aepa9z4H3rvpXz?=
 =?us-ascii?Q?/Mo/hMk/aznt7LnahT/DhqzuSA901mwxA83YhtpRJppvSkraTYyzPSPEZYCx?=
 =?us-ascii?Q?sQKOkhWX5dACfgBDO8gnHhyfm1yMlIu6kHB/NgNyLKa8dQH6VihUzCwlpnLa?=
 =?us-ascii?Q?M26mowYDIQRG1IM7Ofr/JahXcEw1PpODQf7ZEqzF3hRkfso8hmDMrip+dgsk?=
 =?us-ascii?Q?AVDjuZGLwi2iAl+n+jFfzGTBFRAYG76Sv4cyVlf+9d+qfr6EQbmNbNpvtUUd?=
 =?us-ascii?Q?zyRUBF8bkPdB0mxv3NWYejxe9k37IZlgRZJVDUdN/ZSUUApE+Zy8DvtVYK94?=
 =?us-ascii?Q?kd+MRqAmAQ26oJniyrVyGLC+ZGVG5obAiJi2Po/xftkdJNaLiuZ/y+r0IFLP?=
 =?us-ascii?Q?fQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8F4968AD87FA11478EAEF4E925E4510F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04c2bfe9-dc59-4485-bd3b-08da7190e4e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 18:33:55.5630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 88pD+vmkCaFjDmjTmhepkURZAvlhDOanbiI7GitW/Mq6KQiItu4wHMr7j9k91lzS/7ASUydWN8rc4EzJs0Ryfc+fztKU3P1vC1qaiVxy50k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3558
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-29_19,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207290077
X-Proofpoint-GUID: esgJpbcuTZDRXyKl7hCJGv6hJCjmsjnu
X-Proofpoint-ORIG-GUID: esgJpbcuTZDRXyKl7hCJGv6hJCjmsjnu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 29, 2022, at 6:16 AM, Sreekanth Reddy <sreekanth.reddy@broadcom.co=
m> wrote:
>=20
> Enable and process the Enclosure device add event.
>=20
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
> drivers/scsi/mpi3mr/mpi3mr.h    |  19 +++++
> drivers/scsi/mpi3mr/mpi3mr_fw.c |   4 +
> drivers/scsi/mpi3mr/mpi3mr_os.c | 133 +++++++++++++++++++++++++++++++-
> 3 files changed, 154 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 8af94d3..542b462 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -461,6 +461,16 @@ struct mpi3mr_throttle_group_info {
> 	atomic_t pend_large_data_sz;
> };
>=20
> +/**
> + * struct mpi3mr_enclosure_node - enclosure information
> + * @list: List of enclosures
> + * @pg0: Enclosure page 0;
> + */
> +struct mpi3mr_enclosure_node {
> +	struct list_head list;
> +	struct mpi3_enclosure_page0 pg0;
> +};
> +
> /**
>  * struct tgt_dev_sas_sata - SAS/SATA device specific
>  * information cached from firmware given data
> @@ -535,12 +545,14 @@ union _form_spec_inf {
>  * @slot: Slot number
>  * @encl_handle: FW enclosure handle
>  * @perst_id: FW assigned Persistent ID
> + * @devpg0_flag: Device Page0 flag
>  * @dev_type: SAS/SATA/PCIE device type
>  * @is_hidden: Should be exposed to upper layers or not
>  * @host_exposed: Already exposed to host or not
>  * @io_throttle_enabled: I/O throttling needed or not
>  * @q_depth: Device specific Queue Depth
>  * @wwid: World wide ID
> + * @enclosure_logical_id: Enclosure logical identifier
>  * @dev_spec: Device type specific information
>  * @ref_count: Reference count
>  */
> @@ -552,12 +564,14 @@ struct mpi3mr_tgt_dev {
> 	u16 slot;
> 	u16 encl_handle;
> 	u16 perst_id;
> +	u16 devpg0_flag;
> 	u8 dev_type;
> 	u8 is_hidden;
> 	u8 host_exposed;
> 	u8 io_throttle_enabled;
> 	u16 q_depth;
> 	u64 wwid;
> +	u64 enclosure_logical_id;
> 	union _form_spec_inf dev_spec;
> 	struct kref ref_count;
> };
> @@ -877,6 +891,7 @@ struct scmd_priv {
>  * @cfg_page: Default memory for configuration pages
>  * @cfg_page_dma: Configuration page DMA address
>  * @cfg_page_sz: Default configuration page memory size
> + * @enclosure_list: List of Enclosure objects
>  */
> struct mpi3mr_ioc {
> 	struct list_head list;
> @@ -1053,6 +1068,8 @@ struct mpi3mr_ioc {
> 	void *cfg_page;
> 	dma_addr_t cfg_page_dma;
> 	u16 cfg_page_sz;
> +
> +	struct list_head enclosure_list;
> };
>=20
> /**
> @@ -1177,6 +1194,8 @@ int mpi3mr_pel_get_seqnum_post(struct mpi3mr_ioc *m=
rioc,
> 	struct mpi3mr_drv_cmd *drv_cmd);
> void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
> 	u16 event_data_size);
> +struct mpi3mr_enclosure_node *mpi3mr_enclosure_find_by_handle(
> +	struct mpi3mr_ioc *mrioc, u16 handle);
> extern const struct attribute_group *mpi3mr_host_groups[];
> extern const struct attribute_group *mpi3mr_dev_groups[];
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 50e88d4..9c36f52 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -244,6 +244,9 @@ static void mpi3mr_print_event_data(struct mpi3mr_ioc=
 *mrioc,
> 	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
> 		desc =3D "Enclosure Device Status Change";
> 		break;
> +	case MPI3_EVENT_ENCL_DEVICE_ADDED:
> +		desc =3D "Enclosure Added";
> +		break;
> 	case MPI3_EVENT_HARD_RESET_RECEIVED:
> 		desc =3D "Hard Reset Received";
> 		break;
> @@ -3660,6 +3663,7 @@ static int mpi3mr_enable_events(struct mpi3mr_ioc *=
mrioc)
> 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_DEVICE_INFO_CHANGED);
> 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_DEVICE_STATUS_CHANGE);
> 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE);
> +	mpi3mr_unmask_events(mrioc, MPI3_EVENT_ENCL_DEVICE_ADDED);
> 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST);
> 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DISCOVERY);
> 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR);
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 40bed22..ca718cb 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -1026,6 +1026,7 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc =
*mrioc,
> {
> 	u16 flags =3D 0;
> 	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data =3D NULL;
> +	struct mpi3mr_enclosure_node *enclosure_dev =3D NULL;
> 	u8 prot_mask =3D 0;
>=20
> 	tgtdev->perst_id =3D le16_to_cpu(dev_pg0->persistent_id);
> @@ -1036,8 +1037,17 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc=
 *mrioc,
> 	tgtdev->slot =3D le16_to_cpu(dev_pg0->slot);
> 	tgtdev->q_depth =3D le16_to_cpu(dev_pg0->queue_depth);
> 	tgtdev->wwid =3D le64_to_cpu(dev_pg0->wwid);
> +	tgtdev->devpg0_flag =3D le16_to_cpu(dev_pg0->flags);
> +
> +	if (tgtdev->encl_handle)
> +		enclosure_dev =3D mpi3mr_enclosure_find_by_handle(mrioc,
> +		    tgtdev->encl_handle);
> +	if (enclosure_dev)
> +		tgtdev->enclosure_logical_id =3D le64_to_cpu(
> +		    enclosure_dev->pg0.enclosure_logical_id);
> +
> +	flags =3D tgtdev->devpg0_flag;
>=20
> -	flags =3D le16_to_cpu(dev_pg0->flags);
> 	tgtdev->is_hidden =3D (flags & MPI3_DEVICE0_FLAGS_HIDDEN);
>=20
> 	if (is_added =3D=3D true)
> @@ -1265,6 +1275,116 @@ out:
> 		mpi3mr_tgtdev_put(tgtdev);
> }
>=20
> +/**
> + * mpi3mr_enclosure_find_by_handle - enclosure search by handle
> + * @mrioc: Adapter instance reference
> + * @handle: Firmware device handle of the enclosure
> + *
> + * This searches for enclosure device based on handle, then returns the
> + * enclosure object.
> + *
> + * Return: Enclosure object reference or NULL
> + */
> +struct mpi3mr_enclosure_node *mpi3mr_enclosure_find_by_handle(
> +	struct mpi3mr_ioc *mrioc, u16 handle)
> +{
> +	struct mpi3mr_enclosure_node *enclosure_dev, *r =3D NULL;
> +
> +	list_for_each_entry(enclosure_dev, &mrioc->enclosure_list, list) {
> +		if (le16_to_cpu(enclosure_dev->pg0.enclosure_handle) !=3D handle)
> +			continue;
> +		r =3D enclosure_dev;
> +		goto out;
> +	}
> +out:
> +	return r;
> +}
> +
> +/**
> + * mpi3mr_encldev_add_chg_evt_debug - debug for enclosure event
> + * @mrioc: Adapter instance reference
> + * @encl_pg0: Enclosure page 0.
> + * @is_added: Added event or not
> + *
> + * Return nothing.
> + */
> +static void mpi3mr_encldev_add_chg_evt_debug(struct mpi3mr_ioc *mrioc,
> +	struct mpi3_enclosure_page0 *encl_pg0, u8 is_added)
> +{
> +	char *reason_str =3D NULL;
> +
> +	if (!(mrioc->logging_level & MPI3_DEBUG_EVENT_WORK_TASK))
> +		return;
> +
> +	if (is_added)
> +		reason_str =3D "enclosure added";
> +	else
> +		reason_str =3D "enclosure dev status changed";
> +
> +	ioc_info(mrioc,
> +	    "%s: handle(0x%04x), enclosure logical id(0x%016llx)\n",
> +	    reason_str, le16_to_cpu(encl_pg0->enclosure_handle),
> +	    (unsigned long long)le64_to_cpu(encl_pg0->enclosure_logical_id));
> +	ioc_info(mrioc,
> +	    "number of slots(%d), port(%d), flags(0x%04x), present(%d)\n",
> +	    le16_to_cpu(encl_pg0->num_slots), encl_pg0->io_unit_port,
> +	    le16_to_cpu(encl_pg0->flags),
> +	    ((le16_to_cpu(encl_pg0->flags) &
> +	      MPI3_ENCLS0_FLAGS_ENCL_DEV_PRESENT_MASK) >> 4));
> +}
> +
> +/**
> + * mpi3mr_encldev_add_chg_evt_bh - Enclosure evt bottomhalf
> + * @mrioc: Adapter instance reference
> + * @fwevt: Firmware event reference
> + *
> + * Prints information about the Enclosure device status or
> + * Enclosure add events if logging is enabled and add or remove
> + * the enclosure from the controller's internal list of
> + * enclosures.
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_encldev_add_chg_evt_bh(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_fwevt *fwevt)
> +{
> +	struct mpi3mr_enclosure_node *enclosure_dev =3D NULL;
> +	struct mpi3_enclosure_page0 *encl_pg0;
> +	u16 encl_handle;
> +	u8 added, present;
> +
> +	encl_pg0 =3D (struct mpi3_enclosure_page0 *) fwevt->event_data;
> +	added =3D (fwevt->event_id =3D=3D MPI3_EVENT_ENCL_DEVICE_ADDED) ? 1 : 0=
;
> +	mpi3mr_encldev_add_chg_evt_debug(mrioc, encl_pg0, added);
> +
> +
> +	encl_handle =3D le16_to_cpu(encl_pg0->enclosure_handle);
> +	present =3D ((le16_to_cpu(encl_pg0->flags) &
> +	      MPI3_ENCLS0_FLAGS_ENCL_DEV_PRESENT_MASK) >> 4);
> +
> +	if (encl_handle)
> +		enclosure_dev =3D mpi3mr_enclosure_find_by_handle(mrioc,
> +		    encl_handle);
> +	if (!enclosure_dev && present) {
> +		enclosure_dev =3D
> +			kzalloc(sizeof(struct mpi3mr_enclosure_node),
> +			    GFP_KERNEL);
> +		if (!enclosure_dev)
> +			return;
> +		list_add_tail(&enclosure_dev->list,
> +		    &mrioc->enclosure_list);
> +	}
> +	if (enclosure_dev) {
> +		if (!present) {
> +			list_del(&enclosure_dev->list);
> +			kfree(enclosure_dev);
> +		} else
> +			memcpy(&enclosure_dev->pg0, encl_pg0,
> +			    sizeof(enclosure_dev->pg0));
> +
> +	}
> +}
> +
> /**
>  * mpi3mr_sastopochg_evt_debug - SASTopoChange details
>  * @mrioc: Adapter instance reference
> @@ -1641,6 +1761,13 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mri=
oc,
> 		mpi3mr_devstatuschg_evt_bh(mrioc, fwevt);
> 		break;
> 	}
> +	case MPI3_EVENT_ENCL_DEVICE_ADDED:
> +	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
> +	{
> +		mpi3mr_encldev_add_chg_evt_bh(mrioc, fwevt);
> +		break;
> +	}
> +
> 	case MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
> 	{
> 		mpi3mr_sastopochg_evt_bh(mrioc, fwevt);
> @@ -2502,6 +2629,8 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mri=
oc,
> 	}
> 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
> 	case MPI3_EVENT_LOG_DATA:
> +	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
> +	case MPI3_EVENT_ENCL_DEVICE_ADDED:
> 	{
> 		process_evt_bh =3D 1;
> 		break;
> @@ -2516,7 +2645,6 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mri=
oc,
> 		mpi3mr_cablemgmt_evt_th(mrioc, event_reply);
> 		break;
> 	}
> -	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
> 	case MPI3_EVENT_SAS_DISCOVERY:
> 	case MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR:
> 	case MPI3_EVENT_SAS_BROADCAST_PRIMITIVE:
> @@ -4569,6 +4697,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci=
_device_id *id)
> 	INIT_LIST_HEAD(&mrioc->tgtdev_list);
> 	INIT_LIST_HEAD(&mrioc->delayed_rmhs_list);
> 	INIT_LIST_HEAD(&mrioc->delayed_evtack_cmds_list);
> +	INIT_LIST_HEAD(&mrioc->enclosure_list);
>=20
> 	mutex_init(&mrioc->reset_mutex);
> 	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
> --=20
> 2.27.0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

