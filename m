Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B875C00144
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 20:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbiHAUuY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 16:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbiHAUuV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 16:50:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230C86277
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 13:50:20 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271KT19t001710;
        Mon, 1 Aug 2022 20:50:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=C0kXMb4LvBkQyv4HHNvLShJLuO7Oqm8XYYprPuOGLw4=;
 b=RNiuFzKTyR1P1zXM9e0XMP10Uzoc1vC29wCJ9K0b+C4fIFcwjjGplpkYHdgLBGVMMbyw
 pAGyUwUz2F+FWoQ/cBGtxEhO+xyYLUAN9rwJtWSYaa0jZSF364ysVVTBg3pxBtyUh18I
 ampW66ZkUhPToizW+YDdCWFkMRZuc017FghfeWIvtkXASKAFgqEXrXsB64H6TPW/4j//
 xuGLj/80VTpwFHvvZh3Ra5/Qs6Mb3cUJkCyEF7Z316r71FciOp+U9Dfi3NkUiH8dFu+c
 NO2wm+/l8eUA8bys50PBIVMWSGEW/1genxoGk3YqLe0Jzc+ixNfawWXFhP3/v4XYMFWv bw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmw6tcwke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 20:50:18 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 271KJnpP031906;
        Mon, 1 Aug 2022 20:50:16 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu31p017-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 20:50:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/LbuYUwbqsSeq45IFDuRHiIeqFlhfX7k1Ua1HOrzViwsYSmKnNG9a6LKUHWXg/FrrEFLPs8OwGvpNcGPDk59Ss5/mMD5kUTjl+FsAnY+vwsCsCpIFWZSihFKfgSHY13jZ+MhUK51KPX7u+OPYJ9wcZ3tzRuVMiHk5nXwlol/lyaSbpTPCr/UTCTqZtbmtP94bpgMA/g+yl0Lqv2MpBSm8t/H1YffIBIqGzn0Su9ATlqOSYbDJ9uoQXJMW6CzfZo+aXVt7lS4SSaZamFWKEpbSTmZyP3NdkK0h+HchgbMf72j2m8l/SuAm0LRW8nYw/CDSFl3DqaIV2wWVs9EZxJ4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C0kXMb4LvBkQyv4HHNvLShJLuO7Oqm8XYYprPuOGLw4=;
 b=FAyNFzeohlN5HXIlFcMIYLYjGeF3LgdxGG5JTK3duaFJVz2SZfW9SNpUcqc9uNpBKGvkH1Lf4X/GKkhF42c+Lnq0QU0R0nr7IoBDiasuFh2DeifI5Ve+pJ/DK+qKLzrjxjZd+94vJN30Fe06uyA5WPUhItlppKSzkW1bcwSDInjQEWyD9lFAECCp8iVsHQd9gh7H4cjp8Z0Q0nfIhHIomh2YJ0BDEhMRtvEY/E7hLjeP81kpqYzWsFTrnx/wSCWIxvIn/dJQj7T/GjnMeewuoKLSmpuFN9hpGHsjP4HqsWrIV8GLPVTdO5GqIKu1buY8BC4VWC35GwDK3suLMIpq/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0kXMb4LvBkQyv4HHNvLShJLuO7Oqm8XYYprPuOGLw4=;
 b=Ag/avAkDqT2kKzTH2T/+pta3MVSeN/+n1E9X6ByVhLPb5ga6MOfflIwZWbosqd1hxmXkarf9fOQekv1ZXrTfmDDOQ/pQDGb1ZgxtshyojOD+v1IMMFGMQyoAcblggDYuBkwYFTJf57YX8eHc4jp3yRaArqGZFg/ELM44Aahul2E=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BL0PR10MB2898.namprd10.prod.outlook.com (2603:10b6:208:75::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Mon, 1 Aug
 2022 20:50:13 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3%3]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 20:50:12 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [PATCH 09/15] mpi3mr: Add expander devices to STL
Thread-Topic: [PATCH 09/15] mpi3mr: Add expander devices to STL
Thread-Index: AQHYo0wA6+JTguRz0UGffSGqpDRwVK2aif4A
Date:   Mon, 1 Aug 2022 20:50:12 +0000
Message-ID: <D41377E2-6AD0-4A31-9961-72CFD7D23D0E@oracle.com>
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
 <20220729131627.15019-10-sreekanth.reddy@broadcom.com>
In-Reply-To: <20220729131627.15019-10-sreekanth.reddy@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc8f7d80-785a-4cc6-ccf3-08da73ff6e30
x-ms-traffictypediagnostic: BL0PR10MB2898:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ei3twr+6P2T7VVepb72k9ILn2sQgHGLM2yv9eoNWmi0PA1QBF9V4mDLVKp9Pc7SUdAgDq6TTpuTsCCMJCXQ4c6cGBLzeV6Sa9zsu22NkjwP0pJeuKB6rBB3LUexp6hCmli+nxOPX0djVcHjMZCsj59bZVvOMc4VC/3XZyQDBjPPdett9x+z3uT69lr7xd2IKdmD6/f6+G1eboU38UpFYgL+wvpIXxnvMkBLTUq+wbK3nUJlXwrelcfxXlLttKEy0jyOnK+WmB5winOpPJaiwwpLGHlC/zgDLhASujmlgwbrkG3tW2gRtNX94jw8dALWt8CFbWrCXBTwoAc8/3mkE4XInE0VLx/jFx2ETToscp9HtObHLgQmoIXgHO532iL06CjZSBmbTTdMQohY8kD7uP9s19S/sPh+iGlmh26kJWhzmiQlS3pplrXb4nejPG/eViOQnI3DJI1Yw0lw/eZgKxVrH2tniCNi8RXCbN8nv0Pos32HNdhJ0zUiR2K+la8qh8r5EvQxv70uSJT370tylI1ip5RIg7Kq/Wg24/yLhBAY+iDBy2XVcG+6RL0AzfRkxvzsUbi3XOubU//PmKQwnC3CqXpVBaKslU0ZMSEnHTOsoV6xQTBxdibXt1snZIr6Z/W79/glQpq1jOkw2YFFhA0xZ6+Djs2H1RAFZlO2uci3rmocQzVVnrRZ9UR91joo9b8At0uOHV4sBVNaAl1WMrcfkAEHXbKQGqbpZQ7/KcVPOmlLaL5zZ80uuEP3c9sMPbVIGuBmBLUUwAQHgM3x9JCSeGuCu5YUbX939xhuIgtZKoq/n5JyoJIZXW4vBLd06N/y7E5matqFPtRwYDeQMP5MlwAXSQaVqlIQlbJG1O44=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(136003)(346002)(39860400002)(376002)(30864003)(91956017)(2616005)(41300700001)(316002)(44832011)(186003)(107886003)(33656002)(86362001)(6512007)(6506007)(5660300002)(6916009)(8936002)(53546011)(36756003)(26005)(83380400001)(4326008)(8676002)(38070700005)(76116006)(66946007)(2906002)(64756008)(66476007)(66446008)(66556008)(6486002)(54906003)(71200400001)(478600001)(122000001)(38100700002)(32563001)(45980500001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?46PKeaBovo1YUqypBVnlrZg2LuF5uR9/hHsnf1ZAfmCkBL7hQzLEi6hl+RIY?=
 =?us-ascii?Q?wIjNq2WPBUTr2x5IJZz9pmlxihbypjyPG3Gzy4+/2MQl2dAvB1dL+N/t5KP8?=
 =?us-ascii?Q?syo6DF7LShKPiRv9Y1pYNOWhNt0zmbTMWtQ5EYkerIINxJ4z/O6UsbiCdnT8?=
 =?us-ascii?Q?S63nNwyFpZYf2RvnnfvbjOP+LYWTDOKJGCtvEXzb3UxuNI4bXw9XkeDRy/l5?=
 =?us-ascii?Q?UKZmriItr2yW6t3DLLzZEEzZSzIp5hVwRQeuFTH2y7KHQZGipSR9S6/5kb++?=
 =?us-ascii?Q?23K1Vk3QWo91Xa5x7RplMZ6GkYduqnGf6F8VTdzz0D+4bIpkyyLpmBPbpbeu?=
 =?us-ascii?Q?Up4rRax/dtwjRKtFbs3jqnDE+JdpmlXS9Bj8nVhVXhHKxNAvS/x/pTlaP/yu?=
 =?us-ascii?Q?wfJEfCF2OmsJP2K8PMlIUdIn8JGgUxcbS6AD+QMm+09pgoQbgCHm9wNgN310?=
 =?us-ascii?Q?2EjHnUy7y9MvOIY7HGkuEIg6g9VvOk/3zlUMrumJU0ORHCeMuz7vwCNklGDo?=
 =?us-ascii?Q?fpX6K5W6ziU+/Ff0o2r0Sr59FR/jo9n5S9Bv9jGgwc7HIH1InzZV5YZ93IRA?=
 =?us-ascii?Q?9q8XOKTashc7+UEtiBDGMFR2XyGQkPBQJGIUeY9OPPgQ13NzpTadVmVetUbx?=
 =?us-ascii?Q?s5PmMALKW2rgCuJVixG/Jf49M5OUt7Ilb9f0+MT4E/Jqc6jRqREVBeXApMED?=
 =?us-ascii?Q?x19RG1oFX3IZBj522+5vAApPvSqogV4h4erEXDu8soYZmj14xmIt1xOA9jWR?=
 =?us-ascii?Q?pW8SWZqJkQHQEODdTWPairN9vFUwYOMqSiMvwMPXppogv+MZLwF3YskHxzFc?=
 =?us-ascii?Q?w2JCm/MJ8UKoWKHd5i9mPQ6G8rMPpHhAUgGAmgljGw4CzXIJbIHuAE0nt7ai?=
 =?us-ascii?Q?Sqll+tOr89hd8tgtjRZah/MOAsWZdGTbpXkb4MbViIcmO6uQpmJfIlfgxZ0g?=
 =?us-ascii?Q?Eyk2dD9z6aBCDR12Heuj034+JIMrIU7gURQszYZR3FViUvRSijW0SFdgMMCK?=
 =?us-ascii?Q?o0Deak25eBRhprdFV3ul+C8EVA496EXr/uzAbfQMvLT1rqtJo2SJhHxmdVrx?=
 =?us-ascii?Q?Fc2ekqs+IucRSa7hyGm9RyTHGwnwy1VKmiF6Z55p4R/2Yi0rqFpfbH4np/wd?=
 =?us-ascii?Q?Nrk2SGSqTrEf1Ml7e7P57ay88D9+9UN0ZuVCnFJ3LYR9wtbTmRo9JhKf+n4S?=
 =?us-ascii?Q?SXdb/e5cUrH/+95qorBAQgrSihV0d8dppm0Mgcg62zaUP9ox1F0tWf4JbalE?=
 =?us-ascii?Q?X3AhKAfuBURwKa8oT8hQMs1D9l/kuyLwy7g7/r/DAq9BEZqd0wSwC0AIlq3f?=
 =?us-ascii?Q?nbFB29z6i7TkgYzX6tKgbT/+xPhqIswslSFFrIHjgciCAevTv2D3KApZ9DlH?=
 =?us-ascii?Q?EO0v7f5HfkH22EcfzcMF7mpoMQfrmSd2R0PHedbGhxPAyohDJKSl0yCgUbM0?=
 =?us-ascii?Q?201t6o2ZR4ZypsmrdOrgZawGzIO04BSfSb3+fDk4zRL209uhW1BULJ37WACa?=
 =?us-ascii?Q?eoJubJW2TqZp/uqNu+jRP8b3o4rlBMDdlyGq2Ezd6zwAoWR075oMlL46x2iN?=
 =?us-ascii?Q?ZmYnSrhJtMKJEgZWS7Pb/AtP7hjuvQPlTBgzXVylYwFUbuWYNBrOP9yUBe0i?=
 =?us-ascii?Q?AQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E88C053E4DFD324FB2268D58ECA23B05@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc8f7d80-785a-4cc6-ccf3-08da73ff6e30
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 20:50:12.8424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zQio2V8C30ZifxQOwAMVspT00IGEPc533zDMaLDMXdRVmoJij3slB3SFfu3SPz0vc0d93QKGL/ncv9rAv/RZqsUHJWrSjUvNmY28xQxSB3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2898
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_11,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208010103
X-Proofpoint-GUID: XgAQ4BQjoDP_tXnW_f-bQN5LdRB4ikak
X-Proofpoint-ORIG-GUID: XgAQ4BQjoDP_tXnW_f-bQN5LdRB4ikak
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 29, 2022, at 6:16 AM, Sreekanth Reddy <sreekanth.reddy@broadcom.co=
m> wrote:
>=20
> Register/unregister the expander devices to
> SCSI Transport Layer(STL) whenever the corresponding expander
> is added/removed from topology.
>=20
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
> drivers/scsi/mpi3mr/mpi3mr.h           |   7 +
> drivers/scsi/mpi3mr/mpi3mr_os.c        |  36 ++-
> drivers/scsi/mpi3mr/mpi3mr_transport.c | 402 ++++++++++++++++++++++++-
> 3 files changed, 436 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 8c8703e..9cd5f88 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -1341,6 +1341,11 @@ int mpi3mr_cfg_get_driver_pg1(struct mpi3mr_ioc *m=
rioc,
> 	struct mpi3_driver_page1 *driver_pg1, u16 pg_sz);
>=20
> u8 mpi3mr_is_expander_device(u16 device_info);
> +int mpi3mr_expander_add(struct mpi3mr_ioc *mrioc, u16 handle);
> +void mpi3mr_expander_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
> +	struct mpi3mr_hba_port *hba_port);
> +struct mpi3mr_sas_node *__mpi3mr_expander_find_by_handle(struct mpi3mr_i=
oc
> +	*mrioc, u16 handle);
> struct mpi3mr_hba_port *mpi3mr_get_hba_port_by_id(struct mpi3mr_ioc *mrio=
c,
> 	u8 port_id);
> void mpi3mr_sas_host_refresh(struct mpi3mr_ioc *mrioc);
> @@ -1348,6 +1353,8 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc);
> void mpi3mr_update_links(struct mpi3mr_ioc *mrioc,
> 	u64 sas_address_parent, u16 handle, u8 phy_number, u8 link_rate,
> 	struct mpi3mr_hba_port *hba_port);
> +void mpi3mr_remove_tgtdev_from_host(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_tgt_dev *tgtdev);
> void mpi3mr_print_device_event_notice(struct mpi3mr_ioc *mrioc,
> 	bool device_add);
> #endif /*MPI3MR_H_INCLUDED*/
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index ae77422..9a32dc6 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -824,7 +824,7 @@ void mpi3mr_print_device_event_notice(struct mpi3mr_i=
oc *mrioc,
>  *
>  * Return: 0 on success, non zero on failure.
>  */
> -static void mpi3mr_remove_tgtdev_from_host(struct mpi3mr_ioc *mrioc,
> +void mpi3mr_remove_tgtdev_from_host(struct mpi3mr_ioc *mrioc,
> 	struct mpi3mr_tgt_dev *tgtdev)
> {
> 	struct mpi3mr_stgt_priv_data *tgt_priv;
> @@ -1494,7 +1494,10 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr=
_ioc *mrioc,
> 	int i;
> 	u16 handle;
> 	u8 reason_code;
> +	u64 exp_sas_address =3D 0;
> +	struct mpi3mr_hba_port *hba_port =3D NULL;
> 	struct mpi3mr_tgt_dev *tgtdev =3D NULL;
> +	struct mpi3mr_sas_node *sas_expander =3D NULL;
>=20
> 	mpi3mr_sastopochg_evt_debug(mrioc, event_data);
>=20
> @@ -1524,6 +1527,13 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr=
_ioc *mrioc,
> 		if (tgtdev)
> 			mpi3mr_tgtdev_put(tgtdev);
> 	}
> +
> +	if (mrioc->sas_transport_enabled && (event_data->exp_status =3D=3D
> +	    MPI3_EVENT_SAS_TOPO_ES_NOT_RESPONDING)) {
> +		if (sas_expander)
> +			mpi3mr_expander_remove(mrioc, exp_sas_address,
> +			    hba_port);
> +	}
> }
>=20
> /**
> @@ -1744,7 +1754,8 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrio=
c,
> 	struct mpi3mr_fwevt *fwevt)
> {
> 	struct mpi3_device_page0 *dev_pg0 =3D NULL;
> -	u16 perst_id;
> +	u16 perst_id, handle, dev_info;
> +	struct mpi3_device0_sas_sata_format *sasinf =3D NULL;
>=20
> 	mpi3mr_fwevt_del_from_list(mrioc, fwevt);
> 	mrioc->current_event =3D fwevt;
> @@ -1758,10 +1769,23 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mr=
ioc,
> 	switch (fwevt->event_id) {
> 	case MPI3_EVENT_DEVICE_ADDED:
> 	{
> -		struct mpi3_device_page0 *dev_pg0 =3D
> -		    (struct mpi3_device_page0 *)fwevt->event_data;
> -		mpi3mr_report_tgtdev_to_host(mrioc,
> -		    le16_to_cpu(dev_pg0->persistent_id));
> +		dev_pg0 =3D (struct mpi3_device_page0 *)fwevt->event_data;
> +		perst_id =3D le16_to_cpu(dev_pg0->persistent_id);
> +		handle =3D le16_to_cpu(dev_pg0->dev_handle);
> +		if (perst_id !=3D MPI3_DEVICE0_PERSISTENTID_INVALID)
> +			mpi3mr_report_tgtdev_to_host(mrioc, perst_id);
> +		else if (mrioc->sas_transport_enabled &&
> +		    (dev_pg0->device_form =3D=3D MPI3_DEVICE_DEVFORM_SAS_SATA)) {
> +			sasinf =3D &dev_pg0->device_specific.sas_sata_format;
> +			dev_info =3D le16_to_cpu(sasinf->device_info);
> +			if (!mrioc->sas_hba.num_phys)
> +				mpi3mr_sas_host_add(mrioc);
> +			else
> +				mpi3mr_sas_host_refresh(mrioc);
> +
> +			if (mpi3mr_is_expander_device(dev_info))
> +				mpi3mr_expander_add(mrioc, handle);
> +		}
> 		break;
> 	}
> 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index b85d60f..1d6ae9d 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> @@ -21,7 +21,7 @@
>  *
>  * Return: Expander sas_node object reference or NULL
>  */
> -static struct mpi3mr_sas_node *__mpi3mr_expander_find_by_handle(struct m=
pi3mr_ioc
> +struct mpi3mr_sas_node *__mpi3mr_expander_find_by_handle(struct mpi3mr_i=
oc
> 	*mrioc, u16 handle)
> {
> 	struct mpi3mr_sas_node *sas_expander, *r;
> @@ -159,6 +159,45 @@ out:
> 	return tgtdev;
> }
>=20
> +/**
> + * mpi3mr_remove_device_by_sas_address - remove the device
> + * @mrioc: Adapter instance reference
> + * @sas_address: SAS address of the device
> + * @hba_port: HBA port entry
> + *
> + * This searches for target device using sas address and hba
> + * port pointer then removes it from the OS.
> + *
> + * Return: None
> + */
> +static void mpi3mr_remove_device_by_sas_address(struct mpi3mr_ioc *mrioc=
,
> +	u64 sas_address, struct mpi3mr_hba_port *hba_port)
> +{
> +	struct mpi3mr_tgt_dev *tgtdev =3D NULL;
> +	unsigned long flags;
> +	u8 was_on_tgtdev_list =3D 0;
> +
> +	if (!hba_port)
> +		return;
> +
> +	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> +	tgtdev =3D __mpi3mr_get_tgtdev_by_addr(mrioc,
> +			 sas_address, hba_port);
> +	if (tgtdev) {
> +		if (!list_empty(&tgtdev->list)) {
> +			list_del_init(&tgtdev->list);
> +			was_on_tgtdev_list =3D 1;
> +			mpi3mr_tgtdev_put(tgtdev);
> +		}
> +	}
> +	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> +	if (was_on_tgtdev_list) {
> +		if (tgtdev->host_exposed)
> +			mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
> +		mpi3mr_tgtdev_put(tgtdev);
> +	}
> +}
> +
> /**
>  * mpi3mr_expander_find_by_sas_address - sas expander search
>  * @mrioc: Adapter instance reference
> @@ -379,6 +418,35 @@ static void mpi3mr_add_phy_to_an_existing_port(struc=
t mpi3mr_ioc *mrioc,
> 	}
> }
>=20
> +/**
> + * mpi3mr_delete_sas_port - helper function to removing a port
> + * @mrioc: Adapter instance reference
> + * @mr_sas_port: Internal Port object
> + *
> + * Return: None.
> + */
> +static void  mpi3mr_delete_sas_port(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_sas_port *mr_sas_port)
> +{
> +

Delete extra newline

> +	u64 sas_address =3D mr_sas_port->remote_identify.sas_address;
> +	struct mpi3mr_hba_port *hba_port =3D mr_sas_port->hba_port;
> +	enum sas_device_type device_type =3D
> +	    mr_sas_port->remote_identify.device_type;
> +
> +	dev_info(&mr_sas_port->port->dev,
> +	    "remove: sas_address(0x%016llx)\n",
> +	    (unsigned long long) sas_address);
> +
> +	if (device_type =3D=3D SAS_END_DEVICE)
> +		mpi3mr_remove_device_by_sas_address(mrioc, sas_address,
> +		    hba_port);
> +
> +	else if (device_type =3D=3D SAS_EDGE_EXPANDER_DEVICE ||
> +	    device_type =3D=3D SAS_FANOUT_EXPANDER_DEVICE)
> +		mpi3mr_expander_remove(mrioc, sas_address, hba_port);
> +}
> +
> /**
>  * mpi3mr_del_phy_from_an_existing_port - del phy from a port
>  * @mrioc: Adapter instance reference
> @@ -402,8 +470,12 @@ static void mpi3mr_del_phy_from_an_existing_port(str=
uct mpi3mr_ioc *mrioc,
> 		    port_siblings) {
> 			if (srch_phy !=3D mr_sas_phy)
> 				continue;
> -			mpi3mr_delete_sas_phy(mrioc, mr_sas_port,
> -			    mr_sas_phy);
> +			if ((mr_sas_port->num_phys =3D=3D 1) &&
> +			    !mrioc->reset_in_progress)
> +				mpi3mr_delete_sas_port(mrioc, mr_sas_port);
> +			else
> +				mpi3mr_delete_sas_phy(mrioc, mr_sas_port,
> +				    mr_sas_phy);
> 			return;
> 		}
> 	}
> @@ -1235,3 +1307,327 @@ static void mpi3mr_sas_port_remove(struct mpi3mr_=
ioc *mrioc, u64 sas_address,
>=20
> 	kfree(mr_sas_port);
> }
> +
> +/**
> + * mpi3mr_expander_node_add - insert an expander to the list.
> + * @mrioc: Adapter instance reference
> + * @sas_expander: Expander sas node
> + * Context: This function will acquire sas_node_lock.
> + *
> + * Adding new object to the ioc->sas_expander_list.
> + *
> + * Return: None.
> + */
> +static void mpi3mr_expander_node_add(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_sas_node *sas_expander)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
> +	list_add_tail(&sas_expander->list, &mrioc->sas_expander_list);
> +	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> +}
> +
> +/**
> + * mpi3mr_expander_add -  Create expander object
> + * @mrioc: Adapter instance reference
> + * @handle: Expander firmware device handle
> + *
> + * This function creating expander object, stored in
> + * sas_expander_list and expose it to the SAS transport
> + * layer.
> + *
> + * Return: 0 for success, non-zero for failure.
> + */
> +int mpi3mr_expander_add(struct mpi3mr_ioc *mrioc, u16 handle)
> +{
> +	struct mpi3mr_sas_node *sas_expander;
> +	struct mpi3mr_enclosure_node *enclosure_dev;
> +	struct mpi3_sas_expander_page0 expander_pg0;
> +	struct mpi3_sas_expander_page1 expander_pg1;
> +	u16 ioc_status, parent_handle, temp_handle;
> +	u64 sas_address, sas_address_parent =3D 0;
> +	int i;
> +	unsigned long flags;
> +	u8 port_id, link_rate;
> +	struct mpi3mr_sas_port *mr_sas_port =3D NULL;
> +	struct mpi3mr_hba_port *hba_port;
> +	u32 phynum_handle;
> +
Remove newline here

> +	int rc =3D 0;
> +
> +	if (!handle)
> +		return -1;
> +
> +	if (mrioc->reset_in_progress)
> +		return -1;
> +
> +	if ((mpi3mr_cfg_get_sas_exp_pg0(mrioc, &ioc_status, &expander_pg0,
> +	    sizeof(expander_pg0), MPI3_SAS_EXPAND_PGAD_FORM_HANDLE, handle))) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		return -1;
> +	}
> +
> +	if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		return -1;
> +	}
> +
> +	parent_handle =3D le16_to_cpu(expander_pg0.parent_dev_handle);
> +	if (mpi3mr_get_sas_address(mrioc, parent_handle, &sas_address_parent)
> +	    !=3D 0) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		return -1;
> +	}
> +
> +	port_id =3D expander_pg0.io_unit_port;
> +	hba_port =3D mpi3mr_get_hba_port_by_id(mrioc, port_id);
> +	if (!hba_port) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		return -1;
> +	}
> +
> +	if (sas_address_parent !=3D mrioc->sas_hba.sas_address) {
> +		spin_lock_irqsave(&mrioc->sas_node_lock, flags);
> +		sas_expander =3D
> +		   mpi3mr_expander_find_by_sas_address(mrioc,
> +		    sas_address_parent, hba_port);
> +		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> +		if (!sas_expander) {
> +			rc =3D mpi3mr_expander_add(mrioc, parent_handle);
> +			if (rc !=3D 0)
> +				return rc;
> +		} else {
> +			/*
> +			 * When there is a parent expander present, update it's
> +			 * phys where child expander is connected with the link
> +			 * speed, attached dev handle and sas address.
> +			 */
> +			for (i =3D 0 ; i < sas_expander->num_phys ; i++) {
> +				phynum_handle =3D
> +				    (i << MPI3_SAS_EXPAND_PGAD_PHYNUM_SHIFT) |
> +				    parent_handle;
> +				if (mpi3mr_cfg_get_sas_exp_pg1(mrioc,
> +				    &ioc_status, &expander_pg1,
> +				    sizeof(expander_pg1),
> +				    MPI3_SAS_EXPAND_PGAD_FORM_HANDLE_PHY_NUM,
> +				    phynum_handle)) {
> +					ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +					    __FILE__, __LINE__, __func__);
> +					rc =3D -1;
> +					return rc;
> +				}
> +				if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +					ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +					    __FILE__, __LINE__, __func__);
> +					rc =3D -1;
> +					return rc;
> +				}
> +				temp_handle =3D le16_to_cpu(
> +				    expander_pg1.attached_dev_handle);
> +				if (temp_handle !=3D handle)
> +					continue;
> +				link_rate =3D (expander_pg1.negotiated_link_rate &
> +				    MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK) >>
> +				    MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT;
> +				mpi3mr_update_links(mrioc, sas_address_parent,
> +				    handle, i, link_rate, hba_port);
> +			}
> +		}
> +	}
> +
> +	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
> +	sas_address =3D le64_to_cpu(expander_pg0.sas_address);
> +	sas_expander =3D mpi3mr_expander_find_by_sas_address(mrioc,
> +	    sas_address, hba_port);
> +	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> +
> +	if (sas_expander)
> +		return 0;
> +
> +	sas_expander =3D kzalloc(sizeof(struct mpi3mr_sas_node),
> +	    GFP_KERNEL);
> +	if (!sas_expander)
> +		return -1;
> +
> +	sas_expander->handle =3D handle;
> +	sas_expander->num_phys =3D expander_pg0.num_phys;
> +	sas_expander->sas_address_parent =3D sas_address_parent;
> +	sas_expander->sas_address =3D sas_address;
> +	sas_expander->hba_port =3D hba_port;
> +
> +
remove extra newline

> +	ioc_info(mrioc,
> +	    "expander_add: handle(0x%04x), parent(0x%04x), sas_addr(0x%016llx),=
 phys(%d)\n",
> +	    handle, parent_handle, (unsigned long long)
> +	    sas_expander->sas_address, sas_expander->num_phys);
> +
> +	if (!sas_expander->num_phys) {
> +		rc =3D -1;
> +		goto out_fail;
> +	}
> +	sas_expander->phy =3D kcalloc(sas_expander->num_phys,
> +	    sizeof(struct mpi3mr_sas_phy), GFP_KERNEL);
> +	if (!sas_expander->phy) {
> +		rc =3D -1;
> +		goto out_fail;
> +	}
> +
> +	INIT_LIST_HEAD(&sas_expander->sas_port_list);
> +	mr_sas_port =3D mpi3mr_sas_port_add(mrioc, handle, sas_address_parent,
> +	    sas_expander->hba_port);
> +	if (!mr_sas_port) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		rc =3D -1;
> +		goto out_fail;
> +	}
> +	sas_expander->parent_dev =3D &mr_sas_port->rphy->dev;
> +	sas_expander->rphy =3D mr_sas_port->rphy;
> +
> +	for (i =3D 0 ; i < sas_expander->num_phys ; i++) {
> +		phynum_handle =3D (i << MPI3_SAS_EXPAND_PGAD_PHYNUM_SHIFT) |
> +		    handle;
> +		if (mpi3mr_cfg_get_sas_exp_pg1(mrioc, &ioc_status,
> +		    &expander_pg1, sizeof(expander_pg1),
> +		    MPI3_SAS_EXPAND_PGAD_FORM_HANDLE_PHY_NUM,
> +		    phynum_handle)) {
> +			ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +			    __FILE__, __LINE__, __func__);
> +			rc =3D -1;
> +			goto out_fail;
> +		}
> +		if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +			ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +			    __FILE__, __LINE__, __func__);
> +			rc =3D -1;
> +			goto out_fail;
> +		}
> +
> +		sas_expander->phy[i].handle =3D handle;
> +		sas_expander->phy[i].phy_id =3D i;
> +		sas_expander->phy[i].hba_port =3D hba_port;
> +
> +		if ((mpi3mr_add_expander_phy(mrioc, &sas_expander->phy[i],
> +		    expander_pg1, sas_expander->parent_dev))) {
> +			ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +			    __FILE__, __LINE__, __func__);
> +			rc =3D -1;
> +			goto out_fail;
> +		}
> +	}
> +
> +	if (sas_expander->enclosure_handle) {
> +		enclosure_dev =3D
> +			mpi3mr_enclosure_find_by_handle(mrioc,
> +						sas_expander->enclosure_handle);
> +		if (enclosure_dev)
> +			sas_expander->enclosure_logical_id =3D le64_to_cpu(
> +			    enclosure_dev->pg0.enclosure_logical_id);
> +	}
> +
> +	mpi3mr_expander_node_add(mrioc, sas_expander);
> +	return 0;
> +
> +out_fail:
> +
> +	if (mr_sas_port)
> +		mpi3mr_sas_port_remove(mrioc,
> +		    sas_expander->sas_address,
> +		    sas_address_parent, sas_expander->hba_port);
> +	kfree(sas_expander->phy);
> +	kfree(sas_expander);
> +	return rc;
> +}
> +
> +/**
> + * mpi3mr_expander_node_remove - recursive removal of expander.
> + * @mrioc: Adapter instance reference
> + * @sas_expander: Expander device object
> + *
> + * Removes expander object and freeing associated memory from
> + * the sas_expander_list and removes the same from SAS TL, if
> + * one of the attached device is an expander then it recursively
> + * removes the expander device too.
> + *
> + * Return nothing.
> + */
> +static void mpi3mr_expander_node_remove(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_sas_node *sas_expander)
> +{
> +	struct mpi3mr_sas_port *mr_sas_port, *next;
> +	unsigned long flags;
> +	u8 port_id;
> +
> +	/* remove sibling ports attached to this expander */
> +	list_for_each_entry_safe(mr_sas_port, next,
> +	   &sas_expander->sas_port_list, port_list) {
> +		if (mrioc->reset_in_progress)
> +			return;
> +		if (mr_sas_port->remote_identify.device_type =3D=3D
> +		    SAS_END_DEVICE)
> +			mpi3mr_remove_device_by_sas_address(mrioc,
> +			    mr_sas_port->remote_identify.sas_address,
> +			    mr_sas_port->hba_port);
> +		else if (mr_sas_port->remote_identify.device_type =3D=3D
> +		    SAS_EDGE_EXPANDER_DEVICE ||
> +		    mr_sas_port->remote_identify.device_type =3D=3D
> +		    SAS_FANOUT_EXPANDER_DEVICE)
> +			mpi3mr_expander_remove(mrioc,
> +			    mr_sas_port->remote_identify.sas_address,
> +			    mr_sas_port->hba_port);
> +	}
> +
> +	port_id =3D sas_expander->hba_port->port_id;
> +	mpi3mr_sas_port_remove(mrioc, sas_expander->sas_address,
> +	    sas_expander->sas_address_parent, sas_expander->hba_port);
> +
> +	ioc_info(mrioc, "expander_remove: handle(0x%04x), sas_addr(0x%016llx), =
port:%d\n",
> +	    sas_expander->handle, (unsigned long long)
> +	    sas_expander->sas_address, port_id);
> +
> +	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
> +	list_del(&sas_expander->list);
> +	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> +
> +	kfree(sas_expander->phy);
> +	kfree(sas_expander);
> +}
> +
> +
remove new line

> +/**
> + * mpi3mr_expander_remove - Remove expander object
> + * @mrioc: Adapter instance reference
> + * @sas_address: Remove expander sas_address
> + * @hba_port: HBA port reference
> + *
> + * This function remove expander object, stored in
> + * mrioc->sas_expander_list and removes it from the SAS TL by
> + * calling mpi3mr_expander_node_remove().
> + *
> + * Return: None
> + */
> +void mpi3mr_expander_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
> +	struct mpi3mr_hba_port *hba_port)
> +{
> +	struct mpi3mr_sas_node *sas_expander;
> +	unsigned long flags;
> +
> +	if (mrioc->reset_in_progress)
> +		return;
> +
> +	if (!hba_port)
> +		return;
> +
> +	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
> +	sas_expander =3D mpi3mr_expander_find_by_sas_address(mrioc, sas_address=
,
> +	    hba_port);
> +	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> +	if (sas_expander)
> +		mpi3mr_expander_node_remove(mrioc, sas_expander);
> +
> +}
> --=20
> 2.27.0
>=20

--
Himanshu Madhani	Oracle Linux Engineering

