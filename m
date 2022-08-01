Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7862C00144
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 21:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbiHAVaU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 17:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbiHAVaC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 17:30:02 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F38A5073B
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 14:27:18 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271KT1px001645;
        Mon, 1 Aug 2022 21:27:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=4BLwlahU1sH+j94sB9L/71i6CGvDwM6LsZTznio4Das=;
 b=IRKgCsVoyqEKw1/2JoONrh3G8M4bVBkDfpai3AZSOgiixjULin34/nfzKWML5SWs4A9H
 KCJ7jMSm9gilth+C71BLWxd/Irxe3HHmfAq9NT/zYZaCc9TBewyvcEpuEwECehFqZybk
 sfROBjSoMDFWs74Q9lFpwmONq1pKchXZk+H2HbQOAK8hAKy1iCFscpTqHNENdw5a92Wk
 yz8nFSVZLdtQ0PRHLNnKFiCzO/m7fpUIG9xiJk4QG9tlV5HiYmcGjIJasYi1hRbMi6No
 el5XPtXJR12jdQku5PLcI7p4c5jxCUHjIkSBvEAefYlgq0gpo5bAbujk/yCShKsCXu36 Mg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmw6td04d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 21:27:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 271Jb284007532;
        Mon, 1 Aug 2022 21:27:16 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu31f16t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 21:27:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MiIH/KORoVlZxvd7a8KbUx6/voLkljUCRDZOGKqMOxXSmXsMusZGhX6i1FCiSEIYdwErvBC3x04Zk6J+F+84Qg0BeM15uhn2F6o3Eaquz/AgwmMfPfMc8pg/1cHzSlr+Ptz0DOTS6xsJ9ay0SMiGVYp58R5cmfxCS62bmMsHm+05Yg3g24V3E0LxNHokURQqNRHza50hfTD+H1H02gzPLCzsmR4J6/JQCuksrNLRhKcGzgXULUFPQz3OdeFMqa4IyVycT+S5nTcUiBXQKO2UbuHha+GAWf9ijPrkJi3N/ZrjWuexGh4zwKt/8CGqSXF2KC/gj3iglb75qxMqh0rIiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4BLwlahU1sH+j94sB9L/71i6CGvDwM6LsZTznio4Das=;
 b=GWVLMf26cVS2Oa6qBiqWhoHFBnuO08anetU2IwcUQ62fZsBA1d0I4/M71y0/uaGe7PtPUaczbY+eRMb6eoRqv7BArcvlyzi4dGF/TlR7KSpZLzPWWBiY7D/z9yGmezBdBJblRBnZx0HWjfyPow7lQuVRb35kyHawrClc69UfbixuJl1HkeiApZR0BlFUwHJmx14gqVFPfCYTYj6rAcpEqHvAA5/VfR1WY2en5M9vbbPyw4GtaoPqj5vW92vcBRo/mN/6alFzscEQrz5WdnKW+dFFKvDQcLn0IUethz6V9ZShfM+f2uN9YHgK0Tm+rvtub97sJu7cO+0Z41KzOxArkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4BLwlahU1sH+j94sB9L/71i6CGvDwM6LsZTznio4Das=;
 b=BSrfvnwBF2IphSHy6DcYbflAgezU22mmX4Wi24PUQhyYcuaW3nlr/APnx49cYwMTlSqwo3WHx4g7oln/rL7tXNJ12fsoKfAJQQfrZNb2v4iOMDiP2NDXrEvCFYzpZ6eDhWtDZFsPrWU/P6IWtGj5wZwINFQEBvfuqKBWlucUifc=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN6PR10MB1410.namprd10.prod.outlook.com (2603:10b6:404:46::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Mon, 1 Aug
 2022 21:27:13 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3%3]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 21:27:13 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [PATCH 10/15] mpi3mr: Get target object based on rphy
Thread-Topic: [PATCH 10/15] mpi3mr: Get target object based on rphy
Thread-Index: AQHYo0wGheShurLmZ0+JGyhP37gIga2alFWA
Date:   Mon, 1 Aug 2022 21:27:13 +0000
Message-ID: <7DD5AD26-E7C8-46D7-A64C-E44D951B617E@oracle.com>
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
 <20220729131627.15019-11-sreekanth.reddy@broadcom.com>
In-Reply-To: <20220729131627.15019-11-sreekanth.reddy@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0da17176-c4c4-4a12-56d4-08da74049a03
x-ms-traffictypediagnostic: BN6PR10MB1410:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FRGSQ9q4b8lQ4w07LMknaAo/qbmaJRAuligST4npk3D/u+TO8lZwIDXefx8MCLKSgu5c2DixdEO68QpPVf6vtdj1aer8SFnLvgnvtOCzl/0wStQoeeJh+FdMyAG8GYMnBsrb638I4OQ3jVN8SybUtbLaoOQfM55uYNwM2M4FX788awxeDwOsn384qOMVbVxoqCk05KiKb74OePcusQMYEpleY6Z+0CL/xXG8NHJDqZWOvXL3yZWUKu2kPrAFRSbasquc8mzVTE8HCOTR8pjeD74Z6Y9PYLUSGj2+pk9ndIeTQwySF4Fs5YkQjrmkOLRiJ9cgqJY1f7b/1GUZeNGvPXnLObbieRYKfdguFWC6VrVPpkUEsfe3X+jckVCHdNBCchy4Ai+K4cE+u7Dp4jM73ixo08rwIJXXLQyDJFzSEVCm0H6ejUs/i14W9zx6I/hmerufu9Fp6f1nBPusNIivY27f0Bok+LHB3ih4DNt5X83WXoBwX3osSNZ5HLmtNkuja9gNTZK6hPWADQhkqHbJMutUkMMXVCgL1Md2MfcHaKtPdLx9n6d3mnnpl/bHt9Cqect5v000fBZLEaufblWoZnwHcifuPEKIa/gYsEYi82YEH2MK2YSqYa6a36OEABmUouCNVgMWvlDHQApNYEwUuh7L+BnIingg8Arooyga8EVCJZT2DExoyA524gJsuvb5CYj9vm9ei/fVN/FsqpAIUsWpgjP8hPDH3hUCkadMPOVJ2BSAGAi33XYp3YXivDiw512ZWgZ3Mh/gKxzb2nhIlm5MKC+IxzFStHLZ+QA7lNTUf42wrWsqwZF0XgE1yXx5Zesf+YM/bvKDCJTY29CF1QnAtUho6fz05XtmL1H2214=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(346002)(366004)(39860400002)(478600001)(6486002)(71200400001)(41300700001)(2906002)(36756003)(86362001)(33656002)(66446008)(66476007)(54906003)(66946007)(76116006)(66556008)(91956017)(64756008)(6916009)(316002)(53546011)(38100700002)(107886003)(2616005)(186003)(38070700005)(6506007)(6512007)(83380400001)(26005)(44832011)(8936002)(4326008)(5660300002)(8676002)(122000001)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RX5iJDhPbTMKUDdxjY0r06EKbCTjwji3iXIwf3C8PbJjXzdchvJkvzI7SpOB?=
 =?us-ascii?Q?VEf1iWFJYbkRDDmUJFRf4E79fWrJ1QQv5SPuOy4Mj/3lfeK6k2tyowGCy/ni?=
 =?us-ascii?Q?LnVCm6vNMUjBjEg0hQK3+z8dzZVsqTmjXXFxcXLe6QwMu1mL9QmSQ4Tkob/P?=
 =?us-ascii?Q?4AZWcFk5MFQUrWnPxNM7O13yrFNRGNSnHkR5B2AnF31j7LT1af5bE0K/4/by?=
 =?us-ascii?Q?ibFcrtfnfw9+6TfbXuIzYhy78YM5EomO7AwLBaNhp+xkhBfOisGU3qaZuzRn?=
 =?us-ascii?Q?zpq7mAdz5mN1sodS3QXnTsbQsOWBH0Dcn45fsBmyAMrize6OV3oBfAAy18kg?=
 =?us-ascii?Q?tstV64C97GWVwkm7ci68+Z8wW7uM/O+Iqpidsv2HPx8qKNXt/YM2jzffs1NU?=
 =?us-ascii?Q?NKCxJPnXriMkUHxYxQpRaZ4mYsMMg34qSy/8D7kDghH/EUonxwWrJ9wq+wrG?=
 =?us-ascii?Q?Pk3uGR2RvQqlJK8zx84+Ctz/pe3IgeXQkOQtmOwESmG8crvnpPSsUJfMLjsw?=
 =?us-ascii?Q?DeeumpI4xG4oHDglWFQ4l5q9YQwWYbhJASiofEkucg7NWKKVbvAoGfT4/3zs?=
 =?us-ascii?Q?IhzmsXm8tPdOJIYtQSByaupUiySz/9JkoP7OEyuiEYqyUJifTp5+Gh0UUskJ?=
 =?us-ascii?Q?+LeXhIyGpHAgDRP03NAGLKoqe8JCr9VAqYzS+ipBL0oIaaL1H3adAW4oGzlS?=
 =?us-ascii?Q?I8mBrWkGD1tnAKthM0Rnb1vmob4H/CY8qJ9vBBG42pNMO51ymbpuHHiNuMDw?=
 =?us-ascii?Q?4tdxar0fK1BCVM9YYCV5kqW+OyHnGO/2S6yadxBT1ILkGCQ0N98140l5/GN6?=
 =?us-ascii?Q?wpCKOK9WfBY1Ww9uc75K+aNt0hyd2mPXup1Zh/r10QM7TGMMZ/XId0ufSJFh?=
 =?us-ascii?Q?ql9vNADsexYWjiNuBXjmW1SXm4iFfWtsuTa5S8SoUrJLBylLXGgfR5ZPG8fv?=
 =?us-ascii?Q?kUWbHFDzzjD3sAszQQ+LBHOc/rc3CLwIpdLzs7J+uIjGO1rS8iwLIz00uwha?=
 =?us-ascii?Q?LA0KFj2YRYUrVFIC+017QHOu8HZ2Qro9SbVaCmhnIKEeVEk5HLyVVsSmwa9A?=
 =?us-ascii?Q?hd5L7MzKedLD86nzqxGaA6Xe70juOdZldOHIpNmqO7vAJmWeldYmx3aHvlT/?=
 =?us-ascii?Q?4IaFq047gPXnVoiCz5ca8lleej1ShpQ0BbnLatz7fokvlcaIdTVBqZSTSK5Y?=
 =?us-ascii?Q?BOtZU73s8tDYJuy1iRxqMnlpY9hYgVD6t+ulVaPDng9alP+QJVzIJOu4xCs8?=
 =?us-ascii?Q?cke+nzqpUldSnIMCPjcUqstiIaIXZ0YbFRbYQxIMLHwwe9LY3swXSaldi6fM?=
 =?us-ascii?Q?MGBC9POZ5sJU2pq3K1SeN0aU7OTzI4bX1XOhGIxQ2XKhXzViO8LkDqQOHPPl?=
 =?us-ascii?Q?BNkmq+Nyd1lseIG9iZ9XXHMiUSOXG5HNPNJW+6eLys2UC1ZsilbxEaHJE1uO?=
 =?us-ascii?Q?90WeeNWOaK99AFBmu1K4bWJz0W6QdtGtdKGXDVwuFFCzAVzZf2zqNmJfUki5?=
 =?us-ascii?Q?uXjwIo5sFkOjMfMqpEl8ky0kDThIUznDx5DiAjFFAmx2SaKVo24BR/GO3zl4?=
 =?us-ascii?Q?uQwOrAEkIH2xoUwQ5j3VVaga0697qCgIrEpaY1ROtySB1Mokgb69uRLdhhR0?=
 =?us-ascii?Q?ZQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <48A7005FB2083C4AAA617E6EF11486A3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0da17176-c4c4-4a12-56d4-08da74049a03
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 21:27:13.8479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: igmRjWRB5Ha4/GNcdRxpboed+xh1pM7nzmQbKmkU8FrFkIBOkxGSNttdJsm6VIKIsZCdF796CwG+EnxawapEoRIaiva0Lq62EcBYBjW4Efw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1410
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_11,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208010107
X-Proofpoint-GUID: CRQbGMN_LsfFaMNykaDhcIbgrrAbpIR_
X-Proofpoint-ORIG-GUID: CRQbGMN_LsfFaMNykaDhcIbgrrAbpIR_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 29, 2022, at 6:16 AM, Sreekanth Reddy <sreekanth.reddy@broadcom.co=
m> wrote:
>=20
> When device is registered with the STL then
> get the corresponding device's target object
> using the rphy in below callback functions,
>=20
> - mpi3mr_target_alloc,
> - mpi3mr_slave_alloc,
> - mpi3mr_slave_configure,
> - mpi3mr_slave_destroy
>=20
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
> drivers/scsi/mpi3mr/mpi3mr.h           |  4 ++
> drivers/scsi/mpi3mr/mpi3mr_fw.c        |  2 +
> drivers/scsi/mpi3mr/mpi3mr_os.c        | 61 +++++++++++++++++++++-----
> drivers/scsi/mpi3mr/mpi3mr_transport.c | 29 ++++++++++++
> 4 files changed, 86 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 9cd5f88..a91a57b 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -997,6 +997,7 @@ struct scmd_priv {
>  * @cfg_page_dma: Configuration page DMA address
>  * @cfg_page_sz: Default configuration page memory size
>  * @sas_transport_enabled: SAS transport enabled or not
> + * @scsi_device_channel: Channel ID for SCSI devices
>  * @sas_hba: SAS node for the controller
>  * @sas_expander_list: SAS node list of expanders
>  * @sas_node_lock: Lock to protect SAS node list
> @@ -1180,6 +1181,7 @@ struct mpi3mr_ioc {
> 	u16 cfg_page_sz;
>=20
> 	u8 sas_transport_enabled;
> +	u8 scsi_device_channel;
> 	struct mpi3mr_sas_node sas_hba;
> 	struct list_head sas_expander_list;
> 	spinlock_t sas_node_lock;
> @@ -1355,6 +1357,8 @@ void mpi3mr_update_links(struct mpi3mr_ioc *mrioc,
> 	struct mpi3mr_hba_port *hba_port);
> void mpi3mr_remove_tgtdev_from_host(struct mpi3mr_ioc *mrioc,
> 	struct mpi3mr_tgt_dev *tgtdev);
> +struct mpi3mr_tgt_dev *__mpi3mr_get_tgtdev_by_addr_and_rphy(
> +	struct mpi3mr_ioc *mrioc, u64 sas_address, struct sas_rphy *rphy);
> void mpi3mr_print_device_event_notice(struct mpi3mr_ioc *mrioc,
> 	bool device_add);
> #endif /*MPI3MR_H_INCLUDED*/
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 0659d3f..9155434 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -3745,6 +3745,8 @@ retry_init:
> 	if (!(mrioc->facts.ioc_capabilities &
> 	    MPI3_IOCFACTS_CAPABILITY_MULTIPATH_ENABLED)) {
> 		mrioc->sas_transport_enabled =3D 1;
> +		mrioc->scsi_device_channel =3D 1;
> +		mrioc->shost->max_channel =3D 1;
> 	}
>=20
> 	mrioc->reply_sz =3D mrioc->facts.reply_sz;
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 9a32dc6..aed9b60 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -4031,9 +4031,10 @@ static void mpi3mr_slave_destroy(struct scsi_devic=
e *sdev)
> 	struct Scsi_Host *shost;
> 	struct mpi3mr_ioc *mrioc;
> 	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data;
> -	struct mpi3mr_tgt_dev *tgt_dev;
> +	struct mpi3mr_tgt_dev *tgt_dev =3D NULL;
> 	unsigned long flags;
> 	struct scsi_target *starget;
> +	struct sas_rphy *rphy =3D NULL;
>=20
> 	if (!sdev->hostdata)
> 		return;
> @@ -4046,7 +4047,14 @@ static void mpi3mr_slave_destroy(struct scsi_devic=
e *sdev)
> 	scsi_tgt_priv_data->num_luns--;
>=20
> 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> -	tgt_dev =3D __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
> +	if (starget->channel =3D=3D mrioc->scsi_device_channel)
> +		tgt_dev =3D __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
> +	else if (mrioc->sas_transport_enabled && !starget->channel) {
> +		rphy =3D dev_to_rphy(starget->dev.parent);
> +		tgt_dev =3D __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
> +		    rphy->identify.sas_address, rphy);
> +	}
> +
> 	if (tgt_dev && (!scsi_tgt_priv_data->num_luns))
> 		tgt_dev->starget =3D NULL;
> 	if (tgt_dev)
> @@ -4111,16 +4119,23 @@ static int mpi3mr_slave_configure(struct scsi_dev=
ice *sdev)
> 	struct scsi_target *starget;
> 	struct Scsi_Host *shost;
> 	struct mpi3mr_ioc *mrioc;
> -	struct mpi3mr_tgt_dev *tgt_dev;
> +	struct mpi3mr_tgt_dev *tgt_dev =3D NULL;
> 	unsigned long flags;
> 	int retval =3D 0;
> +	struct sas_rphy *rphy =3D NULL;
>=20
> 	starget =3D scsi_target(sdev);
> 	shost =3D dev_to_shost(&starget->dev);
> 	mrioc =3D shost_priv(shost);
>=20
> 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> -	tgt_dev =3D __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
> +	if (starget->channel =3D=3D mrioc->scsi_device_channel)
> +		tgt_dev =3D __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
> +	else if (mrioc->sas_transport_enabled && !starget->channel) {
> +		rphy =3D dev_to_rphy(starget->dev.parent);
> +		tgt_dev =3D __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
> +		    rphy->identify.sas_address, rphy);
> +	}
> 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> 	if (!tgt_dev)
> 		return -ENXIO;
> @@ -4168,11 +4183,12 @@ static int mpi3mr_slave_alloc(struct scsi_device =
*sdev)
> 	struct Scsi_Host *shost;
> 	struct mpi3mr_ioc *mrioc;
> 	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data;
> -	struct mpi3mr_tgt_dev *tgt_dev;
> +	struct mpi3mr_tgt_dev *tgt_dev =3D NULL;
> 	struct mpi3mr_sdev_priv_data *scsi_dev_priv_data;
> 	unsigned long flags;
> 	struct scsi_target *starget;
> 	int retval =3D 0;
> +	struct sas_rphy *rphy =3D NULL;
>=20
> 	starget =3D scsi_target(sdev);
> 	shost =3D dev_to_shost(&starget->dev);
> @@ -4180,7 +4196,14 @@ static int mpi3mr_slave_alloc(struct scsi_device *=
sdev)
> 	scsi_tgt_priv_data =3D starget->hostdata;
>=20
> 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> -	tgt_dev =3D __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
> +
> +	if (starget->channel =3D=3D mrioc->scsi_device_channel)
> +		tgt_dev =3D __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
> +	else if (mrioc->sas_transport_enabled && !starget->channel) {
> +		rphy =3D dev_to_rphy(starget->dev.parent);
> +		tgt_dev =3D __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
> +		    rphy->identify.sas_address, rphy);
> +	}
>=20
> 	if (tgt_dev) {
> 		if (tgt_dev->starget =3D=3D NULL)
> @@ -4223,6 +4246,8 @@ static int mpi3mr_target_alloc(struct scsi_target *=
starget)
> 	struct mpi3mr_tgt_dev *tgt_dev;
> 	unsigned long flags;
> 	int retval =3D 0;
> +	struct sas_rphy *rphy =3D NULL;
> +	bool update_stgt_priv_data =3D false;
>=20
> 	scsi_tgt_priv_data =3D kzalloc(sizeof(*scsi_tgt_priv_data), GFP_KERNEL);
> 	if (!scsi_tgt_priv_data)
> @@ -4231,8 +4256,25 @@ static int mpi3mr_target_alloc(struct scsi_target =
*starget)
> 	starget->hostdata =3D scsi_tgt_priv_data;
>=20
> 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> -	tgt_dev =3D __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
> -	if (tgt_dev && !tgt_dev->is_hidden) {
> +
> +	if (starget->channel =3D=3D mrioc->scsi_device_channel) {
> +		tgt_dev =3D __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
> +		if (tgt_dev && !tgt_dev->is_hidden)
> +			update_stgt_priv_data =3D true;
> +		else
> +			retval =3D -ENXIO;
> +	} else if (mrioc->sas_transport_enabled && !starget->channel) {
> +		rphy =3D dev_to_rphy(starget->dev.parent);
> +		tgt_dev =3D __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
> +		    rphy->identify.sas_address, rphy);
> +		if (tgt_dev && !tgt_dev->is_hidden && !tgt_dev->non_stl &&
> +		    (tgt_dev->dev_type =3D=3D MPI3_DEVICE_DEVFORM_SAS_SATA))
> +			update_stgt_priv_data =3D true;
> +		else
> +			retval =3D -ENXIO;
> +	}
> +
> +	if (update_stgt_priv_data) {
> 		scsi_tgt_priv_data->starget =3D starget;
> 		scsi_tgt_priv_data->dev_handle =3D tgt_dev->dev_handle;
> 		scsi_tgt_priv_data->perst_id =3D tgt_dev->perst_id;
> @@ -4246,8 +4288,7 @@ static int mpi3mr_target_alloc(struct scsi_target *=
starget)
> 		if (tgt_dev->dev_type =3D=3D MPI3_DEVICE_DEVFORM_VD)
> 			scsi_tgt_priv_data->throttle_group =3D
> 			    tgt_dev->dev_spec.vd_inf.tg;
> -	} else
> -		retval =3D -ENXIO;
> +	}
> 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
>=20
> 	return retval;
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index 1d6ae9d..f7faf6e 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> @@ -198,6 +198,35 @@ static void mpi3mr_remove_device_by_sas_address(stru=
ct mpi3mr_ioc *mrioc,
> 	}
> }
>=20
> +/**
> + * __mpi3mr_get_tgtdev_by_addr_and_rphy - target device search
> + * @mrioc: Adapter instance reference
> + * @sas_address: SAS address of the device
> + * @rphy: SAS transport layer rphy object
> + *
> + * This searches for target device from sas address and rphy
> + * pointer then return mpi3mr_tgt_dev object.
> + *
> + * Return: Valid tget_dev or NULL
> + */
> +struct mpi3mr_tgt_dev *__mpi3mr_get_tgtdev_by_addr_and_rphy(
> +	struct mpi3mr_ioc *mrioc, u64 sas_address, struct sas_rphy *rphy)
> +{
> +	struct mpi3mr_tgt_dev *tgtdev;
> +
> +	assert_spin_locked(&mrioc->tgtdev_lock);
> +
> +	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list)
> +		if ((tgtdev->dev_type =3D=3D MPI3_DEVICE_DEVFORM_SAS_SATA) &&
> +		    (tgtdev->dev_spec.sas_sata_inf.sas_address =3D=3D sas_address)
> +		    && (tgtdev->dev_spec.sas_sata_inf.rphy =3D=3D rphy))
> +			goto found_device;
> +	return NULL;
> +found_device:
> +	mpi3mr_tgtdev_get(tgtdev);
> +	return tgtdev;
> +}
> +
> /**
>  * mpi3mr_expander_find_by_sas_address - sas expander search
>  * @mrioc: Adapter instance reference
> --=20
> 2.27.0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

