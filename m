Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09081C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 21:00:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D62146142B
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 21:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240376AbhDUVAp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 17:00:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37540 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239096AbhDUVAk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 17:00:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LKq8sp039024;
        Wed, 21 Apr 2021 20:59:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=lj3ndeLaqSsmaaxEZdZVzbn7PIE4hRyzw7cvOrAEbmw=;
 b=yjo7aSj+qEbI5LjkI35TyOMtf9B01wSVecVshT9RyghDuNHeKKiDr+Wuxm1VfC52zizq
 OFeDz/1k3Ql7ctabq4zhgGGzPHxYKcvlagbTSvK0VdeVgC3ZcwYxmnVfuXF8c6K84FFM
 xDjW5IHQEY4sK2aoH5zjh/FkkF7f91ytBzlJ5m75pJEpAzoEHUKxy/bLSadVwW1ihDBf
 BWSNWL8IPqmjxZBP4MbhNuCf2W7hFnyfGInDTt8pmedCCy93VJtf/rtBjlI/zqpAeBSa
 N01ueAEoKH5veqcNcB+z+VrIFQYtbbFaUp7DFLiAgNOodGEGZW2oyw7Vor6TbgqD7vOv JQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38022y2xdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 20:59:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LKoqGh051907;
        Wed, 21 Apr 2021 20:59:58 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3030.oracle.com with ESMTP id 3809m16hdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 20:59:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LBz7SCwcGJ9/e01UMv8qUBEy2PLFqwmR2kQzzVObnb57PXzaejJA3BtzUiv8v26fYrVva0OCv/KQgwwqVOSawpgt+71UY9n6czXGwRwEb6MwTCRqDjoz2UHBjWpCivwAKpneCh/MJOtQPEnjcZABLgrnzwLpK6Q9z2bv7/P8L6W8QM1ii83LMHZPbd37Xpst9/rO7w4pkWNS0eBHwbU4CuCIKbgQRRiIsEPuJ1OfifgqT36vuaDcKVzQJs3KdjMM0w1rjZP7b/zFnz3WrxSc/BJUazLMucKrSstVRmHAQegTLe9C0NJS0FFoZJ2VzEQQn7gXKYdxkR3+lCsHomKfDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lj3ndeLaqSsmaaxEZdZVzbn7PIE4hRyzw7cvOrAEbmw=;
 b=L97GDdxeFRlO1cRMr923xJqB/UYR4C6rBBu6d8IQvaCk4CnpgmJezRwhBhKFv/aMrHzB4CcrM3vBuW2fEhouQ4rAzw5zlLm4Z2wFEPpO2GjgjbUBILpBB8JdPm5HY26EKMz0W7c8AdxPmQDFOIsM+v5dQ4nZk21tKXmQTqxkitpBR9t8yv0f+hMOWihGmSFGj8T4xdhus0sixbg/3fh7xjbDYp55dyyJ4D8ujbSi/FivZStsrXwiWkujt9nwQYJPfHBNr77wnO4Ov8hannzLKNP967VboVZagTaqNZaXw8qkAkD0G6Ngo2W2/or73yQiiP1xvC3IHqXjJHitWhxNNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lj3ndeLaqSsmaaxEZdZVzbn7PIE4hRyzw7cvOrAEbmw=;
 b=Q4KClbynCem8YeZp6Lu0qWgNoOse83MS761/ncz8OQOEQgDMNzTH/cvGhviNNYALjG4LX/2XgqvnPJaV9vBcMu39mW7nKs4hTp2Hme/4RgkwrHP7OkzG0nPDZWGBy4HfraEJ1PnPkzZvtB42zuNZc9PpD+L5SWzWXtfhZdcdR28=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2573.namprd10.prod.outlook.com (2603:10b6:805:48::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Wed, 21 Apr
 2021 20:59:55 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 20:59:55 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "steve.hagan@broadcom.com" <steve.hagan@broadcom.com>,
        "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v3 09/24] mpi3mr: add support for recovering controller
Thread-Topic: [PATCH v3 09/24] mpi3mr: add support for recovering controller
Thread-Index: AQHXNQuEeYRSEUxhfEipfbUy/lPPcKq/eHiA
Date:   Wed, 21 Apr 2021 20:59:55 +0000
Message-ID: <5AE2C917-B147-412E-9B90-0B4C90D41F4A@oracle.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-10-kashyap.desai@broadcom.com>
In-Reply-To: <20210419110156.1786882-10-kashyap.desai@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cae4fbba-60dd-4e58-11ed-08d905086a92
x-ms-traffictypediagnostic: SN6PR10MB2573:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB25737A90D40A3353C8A2C4F2E6479@SN6PR10MB2573.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:327;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ro13GgZYp9qUkZI8Zpq4I/nfujnevt3E0CLYCeaXDdmzs+shIfABB9BEw09G1Du4Hv5z67OkTwMLgIdaE7So0JV0atfaQZRUOXFnKf/fkYOWJkUWZeAWV/+k2iZ+p7D7opiCe0y3Vpl/1UE5AsXwiOucXEcAqGoiYiuWcp23Ogf/A0TY1FyUlQwGFZRY0kZpG+3pn9cyUa7AE720Qd7cN4QvORgQtCB1GqOQ9Y7ao4vTyqSnRMaNRfPRlU8aNuEb8bxbHfq8qCydCK3Pg4hLQEiP2ubpuBLDuICt0IHuXCpzB0yf+f0PDWsSGTwoWljMTiamxHeJnrICTWWrLbZlIG+nfHgKzAOU4KsVV5UebFD5iTEnLY5lgo/XxOifhk4PzGfEjr/wNCcdkz+ZbLe3xZf1KZ7ZSoegSulXYDLgu7RoSIdqmgBK59uAHLKINSmp+3RF2UQhumlmHQgLMxIEYhWJTQNShPLhTAclQ/j1D3DVT38PoOKubH2fTnm/QuYiOROpC6Kv22MfI9xwKFgHwWtZDqJPowalnSX+sx04JGvNEtVHPL5lMStP+u0jguIlCZb7hEg/XV8E9rHHUMGdd2qNxuh6gzXpt48Mq0QgPwdUhNB85dCnVIIbkLfb1kFOKO/9doMcx9f2+SvUZ1R2F3hDbHluRt3SJGQkEHKEphLYKGOA8SHlpgkvky0DYCw0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(39860400002)(366004)(136003)(346002)(478600001)(71200400001)(36756003)(33656002)(5660300002)(2616005)(6486002)(66446008)(8936002)(66556008)(2906002)(26005)(76116006)(6506007)(64756008)(4326008)(66946007)(66476007)(30864003)(86362001)(38100700002)(186003)(44832011)(122000001)(8676002)(6916009)(83380400001)(19627235002)(316002)(53546011)(6512007)(54906003)(32563001)(45980500001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?4yl5oo2khziFOdsKlcYNFhB4BzpOs329u404MY8RBHe35RqIYm4iAmYCH9+S?=
 =?us-ascii?Q?xhSWNCeD3J17brtZDSeHt4CEBmJh47c7fWetcc5W8CY/inD/aZkbaFQbz5iH?=
 =?us-ascii?Q?sevICgwwDJg53uoNQL2Wae1HR7AoiFZ43lwH5YSrpBDsXruJIOkSq0ab98y5?=
 =?us-ascii?Q?MJgxdQS3xKHM1ZmF2FbCUpDY7aiMeAH/B2ejsS+5hEiuRL9thMllIbJXce9m?=
 =?us-ascii?Q?p5grn9CZPjCPSR5ePdTE5YBK4rdnl5FOTw2IwbJQa6Fgjgjc7DUJWqNe6AY9?=
 =?us-ascii?Q?852BFFZzP4E2vmVw2xyi2JB9fK6Pg6LHbO5H5xbxaHBrBcOrZ/T61fQMiWjd?=
 =?us-ascii?Q?PXSgn9UvE9gYqAx2qAJS6MF9jqgRRxm6bl92ppBvbU9gaf3WWMDc67eMMrqH?=
 =?us-ascii?Q?/l91CkkavBV6mZAXD0xkeFsTJN1BepSwvIP800K5A29t05kDlO4ferM8b/mQ?=
 =?us-ascii?Q?RxaMDzH3GC7MeBhWE4AMBqrmmqIG/K5iaXEFeFUfEIPJrNwUeeACV+jOLKHx?=
 =?us-ascii?Q?aJZlBEHGVoPc+5mj7gxeXCmb97mhAxZ1XbviI662TjZxxZQ8ulaeplxma6IJ?=
 =?us-ascii?Q?9Amds1HqIEydBFoQxqRiy+FACwPanfLps8hjIxCJfumsRSudPevdnX7YZmCr?=
 =?us-ascii?Q?pdno313xD+w/ruOJXys0JtM5T3MVW3WtIHBTVtGTzSNX8XmdiYZDRCxpUsp4?=
 =?us-ascii?Q?/FCCuDaivyBemQA2hrbbkvpNmb6wojVK0Gn5MpnkC/5nm6TYQ4L8gnnfVlIl?=
 =?us-ascii?Q?wqHRt03u9NrUFgWW9FZ3CRQ5vDv/fAmGw40md3xs8a94OwwF0Ox9kAhzE9sd?=
 =?us-ascii?Q?0l3bRPmdagtnKbfrdxgOT4xeaZfyMb+Wq4u6iMWY3pIWsXKFPvsh1/b8Qvra?=
 =?us-ascii?Q?TK0RkFj/SIN158kBVc7plOiurX66FyboyRZV67rCN0+SFVpI/qWP0ft+xZbf?=
 =?us-ascii?Q?PqSHBsFUvkCOIdDYQ9HsGZuLgQLCjUywPaGy5vu4J/0RObk4eEspX9wzlMwL?=
 =?us-ascii?Q?I7LPsLa4Q6N7MkrA0EpHQtMYAMOKoQnD5noe36dbO517Bx47R7mVvcDBcumi?=
 =?us-ascii?Q?XfgzwwdwOy9/WmbEq69D/dfV76EJVSp7CP+j6u7E5Kft6P1wXxYG+DoedWI/?=
 =?us-ascii?Q?2KBSgHsc5UoM2lhL5lH2xom86oax/3lawN0s5Neli4EUUfK18IyJJmL3hfhQ?=
 =?us-ascii?Q?/AB4IAaTnn+wnY7jCfjjBkO1vN4omUsNFXvpf2dan3P3vc1JpRyqINBDcu4u?=
 =?us-ascii?Q?dLEkPhbLxF3A30n7WU0b89jFZsmj8tWx9IwB9KJVpCS+3l+yuI5JnRTtU/U5?=
 =?us-ascii?Q?NFhsqpukfLBhUoHhWDOteW5GwKkmq4cNP0f+iqRAfZu80Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4E4D6797AA5D7246B184F5B548BB0588@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cae4fbba-60dd-4e58-11ed-08d905086a92
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2021 20:59:55.3823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: auwb64mIHZpDmsWfPWgYI0/47RjBh9QNhUEGycIW4ia0+ChajMampdsCJRm6SOqFgBCU93c6sqLHvGSN2DhRaJrMza2XOgWGNzyNgVN5WSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2573
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210141
X-Proofpoint-ORIG-GUID: rSNJ6FQ6xsPWIBitvdBpYnX4chnuUIYC
X-Proofpoint-GUID: rSNJ6FQ6xsPWIBitvdBpYnX4chnuUIYC
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210141
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 19, 2021, at 6:01 AM, Kashyap Desai <kashyap.desai@broadcom.com> w=
rote:
>=20
> Added h/w defined process of doing controller reset.
> The driver on detection of firmware fault or any kind of unresponsiveness=
 in
> the controller (Any admin command time outs) results in resetting the con=
troller.
> The primary reset mechanisms used are either soft reset or diag fault res=
et.
> Reset is performed if the host sets the ResetAction field in the HostDiag=
nostic
> register to a 001b (Soft Reset) or 007b(diag fault reset).
> The driver after successfully resetting the controller reinitialize the
> controller by going through start of the day controller initialization pr=
ocedures.
> The pending I/Os during the reset are returned back to SML for retry.
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>=20
> Cc: sathya.prakash@broadcom.com
> ---
> drivers/scsi/mpi3mr/mpi3mr.h    |  15 +-
> drivers/scsi/mpi3mr/mpi3mr_fw.c | 416 +++++++++++++++++++++++++++++---
> drivers/scsi/mpi3mr/mpi3mr_os.c |  92 ++++++-
> 3 files changed, 480 insertions(+), 43 deletions(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 063877f1bc37..d18bfb954bc4 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -98,6 +98,7 @@ extern struct list_head mrioc_list;
> #define MPI3MR_INTADMCMD_TIMEOUT		10
> #define MPI3MR_PORTENABLE_TIMEOUT		300
> #define MPI3MR_RESETTM_TIMEOUT			30
> +#define MPI3MR_RESET_HOST_IOWAIT_TIMEOUT	5
> #define MPI3MR_DEFAULT_SHUTDOWN_TIME		120
>=20
> #define MPI3MR_WATCHDOG_INTERVAL		1000 /* in milli seconds */
> @@ -630,10 +631,14 @@ struct scmd_priv {
>  * @dev_handle_bitmap_sz: Device handle bitmap size
>  * @removepend_bitmap: Remove pending bitmap
>  * @delayed_rmhs_list: Delayed device removal list
> + * @fault_dbg: Fault debug flag
>  * @reset_in_progress: Reset in progress flag
>  * @unrecoverable: Controller unrecoverable flag
> + * @reset_mutex: Controller reset mutex
> + * @reset_waitq: Controller reset  wait queue
>  * @diagsave_timeout: Diagnostic information save timeout
>  * @logging_level: Controller debug logging level
> + * @flush_io_count: I/O count to flush after reset
>  * @current_event: Firmware event currently in process
>  * @driver_info: Driver, Kernel, OS information to firmware
>  * @change_count: Topology change count
> @@ -748,11 +753,15 @@ struct mpi3mr_ioc {
> 	void *removepend_bitmap;
> 	struct list_head delayed_rmhs_list;
>=20
> +	u8 fault_dbg;
> 	u8 reset_in_progress;
> 	u8 unrecoverable;
> +	struct mutex reset_mutex;
> +	wait_queue_head_t reset_waitq;
>=20
> 	u16 diagsave_timeout;
> 	int logging_level;
> +	u16 flush_io_count;
>=20
> 	struct mpi3mr_fwevt *current_event;
> 	Mpi3DriverInfoLayout_t driver_info;
> @@ -801,8 +810,8 @@ struct delayed_dev_rmhs_node {
>=20
> int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc);
> void mpi3mr_cleanup_resources(struct mpi3mr_ioc *mrioc);
> -int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc);
> -void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc);
> +int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init);
> +void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc, u8 re_init);
> int mpi3mr_issue_port_enable(struct mpi3mr_ioc *mrioc, u8 async);
> int mpi3mr_admin_request_post(struct mpi3mr_ioc *mrioc, void *admin_req,
> u16 admin_req_sz, u8 ignore_reset);
> @@ -828,6 +837,8 @@ void mpi3mr_stop_watchdog(struct mpi3mr_ioc *mrioc);
>=20
> int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
> 			      u32 reset_reason, u8 snapdump);
> +int mpi3mr_diagfault_reset_handler(struct mpi3mr_ioc *mrioc,
> +				   u32 reset_reason);
> void mpi3mr_ioc_disable_intr(struct mpi3mr_ioc *mrioc);
> void mpi3mr_ioc_enable_intr(struct mpi3mr_ioc *mrioc);
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 00c3996de032..a74eb4914c9d 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -1605,6 +1605,40 @@ void mpi3mr_stop_watchdog(struct mpi3mr_ioc *mrioc=
)
> 	}
> }
>=20
> +/**
> + * mpi3mr_kill_ioc - Kill the controller
> + * @mrioc: Adapter instance reference
> + * @reason: reason for the failure.
> + *
> + * If fault debug is enabled, display the fault info else issue
> + * diag fault and freeze the system for controller debug
> + * purpose.
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_kill_ioc(struct mpi3mr_ioc *mrioc, u32 reason)
> +{
> +	enum mpi3mr_iocstate ioc_state;
> +
> +	if (!mrioc->fault_dbg)
> +		return;
> +
> +	dump_stack();
> +
> +	ioc_state =3D mpi3mr_get_iocstate(mrioc);
> +	if (ioc_state =3D=3D MRIOC_STATE_FAULT)
> +		mpi3mr_print_fault_info(mrioc);
> +	else {
> +		ioc_err(mrioc, "Firmware is halted due to the reason %d\n",
> +		    reason);
> +		mpi3mr_diagfault_reset_handler(mrioc, reason);
> +	}
> +	if (mrioc->fault_dbg =3D=3D 2)
> +		for (;;)
> +			;
> +	else
> +		panic("panic in %s\n", __func__);
> +}
>=20
> /**
>  * mpi3mr_setup_admin_qpair - Setup admin queue pair
> @@ -2357,6 +2391,7 @@ static int mpi3mr_alloc_chain_bufs(struct mpi3mr_io=
c *mrioc)
> 	return retval;
> }
>=20
> +
> /**
>  * mpi3mr_port_enable_complete - Mark port enable complete
>  * @mrioc: Adapter instance reference
> @@ -2567,6 +2602,7 @@ int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc=
)
> /**
>  * mpi3mr_init_ioc - Initialize the controller
>  * @mrioc: Adapter instance reference
> + * @re_init: Flag to indicate is this fresh init or re-init
>  *
>  * This the controller initialization routine, executed either
>  * after soft reset or from pci probe callback.
> @@ -2579,7 +2615,7 @@ int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc=
)
>  *
>  * Return: 0 on success and non-zero on failure.
>  */
> -int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
> +int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
> {
> 	int retval =3D 0;
> 	enum mpi3mr_iocstate ioc_state;
> @@ -2589,12 +2625,14 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
> 	Mpi3IOCFactsData_t facts_data;
>=20
> 	mrioc->change_count =3D 0;
> -	mrioc->cpu_count =3D num_online_cpus();
> -	retval =3D mpi3mr_setup_resources(mrioc);
> -	if (retval) {
> -		ioc_err(mrioc, "Failed to setup resources:error %d\n",
> -		    retval);
> -		goto out_nocleanup;
> +	if (!re_init) {
> +		mrioc->cpu_count =3D num_online_cpus();
> +		retval =3D mpi3mr_setup_resources(mrioc);
> +		if (retval) {
> +			ioc_err(mrioc, "Failed to setup resources:error %d\n",
> +			    retval);
> +			goto out_nocleanup;
> +		}
> 	}
> 	ioc_status =3D readl(&mrioc->sysif_regs->IOCStatus);
> 	ioc_config =3D readl(&mrioc->sysif_regs->IOCConfiguration);
> @@ -2670,12 +2708,15 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
> 		goto out_failed;
> 	}
>=20
> -	retval =3D mpi3mr_setup_isr(mrioc, 1);
> -	if (retval) {
> -		ioc_err(mrioc, "Failed to setup ISR error %d\n",
> -		    retval);
> -		goto out_failed;
> -	}
> +	if (!re_init) {
> +		retval =3D mpi3mr_setup_isr(mrioc, 1);
> +		if (retval) {
> +			ioc_err(mrioc, "Failed to setup ISR error %d\n",
> +			    retval);
> +			goto out_failed;
> +		}
> +	} else
> +		mpi3mr_ioc_enable_intr(mrioc);
>=20
> 	retval =3D mpi3mr_issue_iocfacts(mrioc, &facts_data);
> 	if (retval) {
> @@ -2685,11 +2726,14 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
> 	}
>=20
> 	mpi3mr_process_factsdata(mrioc, &facts_data);
> -	retval =3D mpi3mr_check_reset_dma_mask(mrioc);
> -	if (retval) {
> -		ioc_err(mrioc, "Resetting dma mask failed %d\n",
> -		    retval);
> -		goto out_failed;
> +	if (!re_init) {
> +		retval =3D mpi3mr_check_reset_dma_mask(mrioc);
> +		if (retval) {
> +			ioc_err(mrioc, "Resetting dma mask failed %d\n",
> +			    retval);
> +			goto out_failed;
> +		}
> +
> 	}
>=20
> 	retval =3D mpi3mr_alloc_reply_sense_bufs(mrioc);
> @@ -2700,13 +2744,15 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
> 		goto out_failed;
> 	}
>=20
> -	retval =3D mpi3mr_alloc_chain_bufs(mrioc);
> -	if (retval) {
> -		ioc_err(mrioc, "Failed to allocated chain buffers %d\n",
> -		    retval);
> -		goto out_failed;
> -	}
> +	if (!re_init) {
> +		retval =3D mpi3mr_alloc_chain_bufs(mrioc);
> +		if (retval) {
> +			ioc_err(mrioc, "Failed to allocated chain buffers %d\n",
> +			    retval);
> +			goto out_failed;
> +		}
>=20
> +	}
> 	retval =3D mpi3mr_issue_iocinit(mrioc);
> 	if (retval) {
> 		ioc_err(mrioc, "Failed to Issue IOC Init %d\n",
> @@ -2721,11 +2767,13 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
> 	writel(mrioc->sbq_host_index,
> 	    &mrioc->sysif_regs->SenseBufferFreeHostIndex);
>=20
> -	retval =3D mpi3mr_setup_isr(mrioc, 0);
> -	if (retval) {
> -		ioc_err(mrioc, "Failed to re-setup ISR, error %d\n",
> -		    retval);
> -		goto out_failed;
> +	if (!re_init)  {
> +		retval =3D mpi3mr_setup_isr(mrioc, 0);
> +		if (retval) {
> +			ioc_err(mrioc, "Failed to re-setup ISR, error %d\n",
> +			    retval);
> +			goto out_failed;
> +		}
> 	}
>=20
> 	retval =3D mpi3mr_create_op_queues(mrioc);
> @@ -2735,6 +2783,14 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
> 		goto out_failed;
> 	}
>=20
> +	if (re_init &&
> +	    (mrioc->shost->nr_hw_queues > mrioc->num_op_reply_q)) {
> +		ioc_err(mrioc,
> +		    "Cannot create minimum number of OpQueues expected:%d created:%d\n=
",
> +		    mrioc->shost->nr_hw_queues, mrioc->num_op_reply_q);
> +		goto out_failed;
> +	}
> +
> 	for (i =3D 0; i < MPI3_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
> 		mrioc->event_masks[i] =3D -1;
>=20
> @@ -2758,14 +2814,109 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
> 		goto out_failed;
> 	}
>=20
> +	if (re_init) {
> +		ioc_info(mrioc, "Issuing Port Enable\n");
> +		retval =3D mpi3mr_issue_port_enable(mrioc, 0);
> +		if (retval) {
> +			ioc_err(mrioc, "Failed to issue port enable %d\n",
> +			    retval);
> +			goto out_failed;
> +		}
> +	}
> 	return retval;
>=20
> out_failed:
> -	mpi3mr_cleanup_ioc(mrioc);
> +	mpi3mr_cleanup_ioc(mrioc, re_init);
> out_nocleanup:
> 	return retval;
> }
>=20
> +/**
> + * mpi3mr_memset_op_reply_q_buffers - memset the operational reply queue=
's
> + *					segments
> + * @mrioc: Adapter instance reference
> + * @qidx: Operational reply queue index
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_memset_op_reply_q_buffers(struct mpi3mr_ioc *mrioc, u=
16 qidx)
> +{
> +	struct op_reply_qinfo *op_reply_q =3D mrioc->op_reply_qinfo + qidx;
> +	struct segments *segments;
> +	int i, size;
> +
> +	if (!op_reply_q->q_segments)
> +		return;
> +
> +	size =3D op_reply_q->segment_qd * mrioc->op_reply_desc_sz;
> +	segments =3D op_reply_q->q_segments;
> +	for (i =3D 0; i < op_reply_q->num_segments; i++)
> +		memset(segments[i].segment, 0, size);
> +}
> +
> +/**
> + * mpi3mr_memset_op_req_q_buffers - memset the operational request queue=
's
> + *					segments
> + * @mrioc: Adapter instance reference
> + * @qidx: Operational request queue index
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_memset_op_req_q_buffers(struct mpi3mr_ioc *mrioc, u16=
 qidx)
> +{
> +	struct op_req_qinfo *op_req_q =3D mrioc->req_qinfo + qidx;
> +	struct segments *segments;
> +	int i, size;
> +
> +	if (!op_req_q->q_segments)
> +		return;
> +
> +	size =3D op_req_q->segment_qd * mrioc->facts.op_req_sz;
> +	segments =3D op_req_q->q_segments;
> +	for (i =3D 0; i < op_req_q->num_segments; i++)
> +		memset(segments[i].segment, 0, size);
> +}
> +
> +/**
> + * mpi3mr_memset_buffers - memset memory for a controller
> + * @mrioc: Adapter instance reference
> + *
> + * clear all the memory allocated for a controller, typically
> + * called post reset to reuse the memory allocated during the
> + * controller init.
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
> +{
> +	u16 i;
> +
> +	memset(mrioc->admin_req_base, 0, mrioc->admin_req_q_sz);
> +	memset(mrioc->admin_reply_base, 0, mrioc->admin_reply_q_sz);
> +
> +	memset(mrioc->init_cmds.reply, 0, sizeof(*mrioc->init_cmds.reply));
> +	for (i =3D 0; i < MPI3MR_NUM_DEVRMCMD; i++)
> +		memset(mrioc->dev_rmhs_cmds[i].reply, 0,
> +		    sizeof(*mrioc->dev_rmhs_cmds[i].reply));
> +	memset(mrioc->removepend_bitmap, 0, mrioc->dev_handle_bitmap_sz);
> +	memset(mrioc->devrem_bitmap, 0, mrioc->devrem_bitmap_sz);
> +
> +	for (i =3D 0; i < mrioc->num_queues; i++) {
> +		mrioc->op_reply_qinfo[i].qid =3D 0;
> +		mrioc->op_reply_qinfo[i].ci =3D 0;
> +		mrioc->op_reply_qinfo[i].num_replies =3D 0;
> +		mrioc->op_reply_qinfo[i].ephase =3D 0;
> +		mpi3mr_memset_op_reply_q_buffers(mrioc, i);
> +
> +		mrioc->req_qinfo[i].ci =3D 0;
> +		mrioc->req_qinfo[i].pi =3D 0;
> +		mrioc->req_qinfo[i].num_requests =3D 0;
> +		mrioc->req_qinfo[i].qid =3D 0;
> +		mrioc->req_qinfo[i].reply_qid =3D 0;
> +		spin_lock_init(&mrioc->req_qinfo[i].q_lock);
> +		mpi3mr_memset_op_req_q_buffers(mrioc, i);
> +	}
> +}
>=20
> /**
>  * mpi3mr_free_mem - Free memory allocated for a controller
> @@ -2941,6 +3092,7 @@ static void mpi3mr_issue_ioc_shutdown(struct mpi3mr=
_ioc *mrioc)
> /**
>  * mpi3mr_cleanup_ioc - Cleanup controller
>  * @mrioc: Adapter instance reference
> + * @re_init: Cleanup due to a reinit or not
>  *
>  * Controller cleanup handler, Message unit reset or soft reset
>  * and shutdown notification is issued to the controller and the
> @@ -2948,11 +3100,12 @@ static void mpi3mr_issue_ioc_shutdown(struct mpi3=
mr_ioc *mrioc)
>  *
>  * Return: Nothing.
>  */
> -void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc)
> +void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
> {
> 	enum mpi3mr_iocstate ioc_state;
>=20
> -	mpi3mr_stop_watchdog(mrioc);
> +	if (!re_init)
> +		mpi3mr_stop_watchdog(mrioc);
>=20
> 	mpi3mr_ioc_disable_intr(mrioc);
>=20
> @@ -2966,13 +3119,94 @@ void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc)
> 			    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET,
> 			    MPI3MR_RESET_FROM_MUR_FAILURE);
>=20
> -		 mpi3mr_issue_ioc_shutdown(mrioc);
> +		if (!re_init)
> +			mpi3mr_issue_ioc_shutdown(mrioc);
> 	}
>=20
> -	mpi3mr_free_mem(mrioc);
> -	mpi3mr_cleanup_resources(mrioc);
> +	if (!re_init) {
> +		mpi3mr_free_mem(mrioc);
> +		mpi3mr_cleanup_resources(mrioc);
> +	}
> +}
> +
> +/**
> + * mpi3mr_drv_cmd_comp_reset - Flush a internal driver command
> + * @mrioc: Adapter instance reference
> + * @cmdptr: Internal command tracker
> + *
> + * Complete an internal driver commands with state indicating it
> + * is completed due to reset.
> + *
> + * Return: Nothing.
> + */
> +static inline void mpi3mr_drv_cmd_comp_reset(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_drv_cmd *cmdptr)
> +{
> +	if (cmdptr->state & MPI3MR_CMD_PENDING) {
> +		cmdptr->state |=3D MPI3MR_CMD_RESET;
> +		cmdptr->state &=3D ~MPI3MR_CMD_PENDING;
> +		if (cmdptr->is_waiting) {
> +			complete(&cmdptr->done);
> +			cmdptr->is_waiting =3D 0;
> +		} else if (cmdptr->callback)
> +			cmdptr->callback(mrioc, cmdptr);
> +	}
> }
>=20
> +/**
> + * mpi3mr_flush_drv_cmds - Flush internaldriver commands
> + * @mrioc: Adapter instance reference
> + *
> + * Flush all internal driver commands post reset
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc *mrioc)
> +{
> +	struct mpi3mr_drv_cmd *cmdptr;
> +	u8 i;
> +
> +	cmdptr =3D &mrioc->init_cmds;
> +	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
> +
> +	for (i =3D 0; i < MPI3MR_NUM_DEVRMCMD; i++) {
> +		cmdptr =3D &mrioc->dev_rmhs_cmds[i];
> +		mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
> +	}
> +}
> +
> +/**
> + * mpi3mr_diagfault_reset_handler - Diag fault reset handler
> + * @mrioc: Adapter instance reference
> + * @reset_reason: Reset reason code
> + *
> + * This is an handler for issuing diag fault reset from the
> + * applications through IOCTL path to stop the execution of the
> + * controller
> + *
> + * Return: 0 on success, non-zero on failure.
> + */
> +int mpi3mr_diagfault_reset_handler(struct mpi3mr_ioc *mrioc,
> +	u32 reset_reason)
> +{
> +	int retval =3D 0;
> +
> +	mrioc->reset_in_progress =3D 1;
> +
> +	mpi3mr_ioc_disable_intr(mrioc);
> +
> +	retval =3D mpi3mr_issue_reset(mrioc,
> +	    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, reset_reason);
> +
> +	if (retval) {
> +		ioc_err(mrioc, "The diag fault reset failed: reason %d\n",
> +		    reset_reason);
> +		mpi3mr_ioc_enable_intr(mrioc);
> +	}
> +	ioc_info(mrioc, "%s\n", ((retval =3D=3D 0) ? "SUCCESS" : "FAILED"));
> +	mrioc->reset_in_progress =3D 0;
> +	return retval;
> +}
>=20
> /**
>  * mpi3mr_soft_reset_handler - Reset the controller
> @@ -2980,12 +3214,120 @@ void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc=
)
>  * @reset_reason: Reset reason code
>  * @snapdump: Flag to generate snapdump in firmware or not
>  *
> - * TBD
> + * This is an handler for recovering controller by issuing soft
> + * reset are diag fault reset.  This is a blocking function and
> + * when one reset is executed if any other resets they will be
> + * blocked. All IOCTLs/IO will be blocked during the reset. If
> + * controller reset is successful then the controller will be
> + * reinitalized, otherwise the controller will be marked as not
> + * recoverable
> + *
> + * In snapdump bit is set, the controller is issued with diag
> + * fault reset so that the firmware can create a snap dump and
> + * post that the firmware will result in F000 fault and the
> + * driver will issue soft reset to recover from that.
>  *
>  * Return: 0 on success, non-zero on failure.
>  */
> int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
> 	u32 reset_reason, u8 snapdump)
> {
> -	return 0;
> +	int retval =3D 0, i;
> +	unsigned long flags;
> +	u32 host_diagnostic, timeout =3D MPI3_SYSIF_DIAG_SAVE_TIMEOUT * 10;
> +
> +	if (mrioc->fault_dbg) {
> +		if (snapdump)
> +			mpi3mr_set_diagsave(mrioc);
> +		mpi3mr_kill_ioc(mrioc, reset_reason);
> +	}
> +
> +	/*
> +	 * Block new resets until the currently executing one is finished and
> +	 * return the status of the existing reset for all blocked resets
> +	 */
> +	if (!mutex_trylock(&mrioc->reset_mutex)) {
> +		ioc_info(mrioc, "Another reset in progress\n");
> +		return -1;
> +	}
> +	mrioc->reset_in_progress =3D 1;
> +
> +	if ((!snapdump) && (reset_reason !=3D MPI3MR_RESET_FROM_FAULT_WATCH) &&
> +	    (reset_reason !=3D MPI3MR_RESET_FROM_CIACTIV_FAULT)) {
> +
> +		for (i =3D 0; i < MPI3_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
> +			mrioc->event_masks[i] =3D -1;
> +
> +		retval =3D mpi3mr_issue_event_notification(mrioc);
> +
> +		if (retval) {
> +			ioc_err(mrioc,
> +			    "Failed to turn off events prior to reset %d\n",
> +			    retval);
> +		}
> +	}
> +
> +	mpi3mr_ioc_disable_intr(mrioc);
> +
> +	if (snapdump) {
> +		mpi3mr_set_diagsave(mrioc);
> +		retval =3D mpi3mr_issue_reset(mrioc,
> +		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, reset_reason);
> +		if (!retval) {
> +			do {
> +				host_diagnostic =3D
> +				    readl(&mrioc->sysif_regs->HostDiagnostic);
> +				if (!(host_diagnostic &
> +				    MPI3_SYSIF_HOST_DIAG_SAVE_IN_PROGRESS))
> +					break;
> +				msleep(100);
> +			} while (--timeout);
> +		}
> +	}
> +
> +	retval =3D mpi3mr_issue_reset(mrioc,
> +	    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET, reset_reason);
> +	if (retval) {
> +		ioc_err(mrioc, "Failed to issue soft reset to the ioc\n");
> +		goto out;
> +	}
> +
> +	mpi3mr_flush_delayed_rmhs_list(mrioc);
> +	mpi3mr_flush_drv_cmds(mrioc);
> +	memset(mrioc->devrem_bitmap, 0, mrioc->devrem_bitmap_sz);
> +	memset(mrioc->removepend_bitmap, 0, mrioc->dev_handle_bitmap_sz);
> +	mpi3mr_cleanup_fwevt_list(mrioc);
> +	mpi3mr_flush_host_io(mrioc);
> +	mpi3mr_invalidate_devhandles(mrioc);
> +	mpi3mr_memset_buffers(mrioc);
> +	retval =3D mpi3mr_init_ioc(mrioc, 1);
> +	if (retval) {
> +		pr_err(IOCNAME "reinit after soft reset failed: reason %d\n",
> +		    mrioc->name, reset_reason);
> +		goto out;
> +	}
> +	ssleep(10);
> +
> +out:
> +	if (!retval) {
> +		mrioc->reset_in_progress =3D 0;
> +		scsi_unblock_requests(mrioc->shost);
> +		mpi3mr_rfresh_tgtdevs(mrioc);
> +		spin_lock_irqsave(&mrioc->watchdog_lock, flags);
> +		if (mrioc->watchdog_work_q)
> +			queue_delayed_work(mrioc->watchdog_work_q,
> +			    &mrioc->watchdog_work,
> +			    msecs_to_jiffies(MPI3MR_WATCHDOG_INTERVAL));
> +		spin_unlock_irqrestore(&mrioc->watchdog_lock, flags);
> +	} else {
> +		mpi3mr_issue_reset(mrioc,
> +		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, reset_reason);
> +		mrioc->unrecoverable =3D 1;
> +		mrioc->reset_in_progress =3D 0;
> +		retval =3D -1;
> +	}
> +
> +	mutex_unlock(&mrioc->reset_mutex);
> +	ioc_info(mrioc, "%s\n", ((retval =3D=3D 0) ? "SUCCESS" : "FAILED"));
> +	return retval;
> }
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 3629184f68f9..d82581ec73e1 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -311,6 +311,88 @@ void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mr=
ioc)
> 	}
> }
>=20
> +/**
> + * mpi3mr_invalidate_devhandles -Invalidate device handles
> + * @mrioc: Adapter instance reference
> + *
> + * Invalidate the device handles in the target device structures
> + * . Called post reset prior to reinitializing the controller.
> + *
> + * Return: Nothing.
> + */
> +void mpi3mr_invalidate_devhandles(struct mpi3mr_ioc *mrioc)
> +{
> +	struct mpi3mr_tgt_dev *tgtdev;
> +	struct mpi3mr_stgt_priv_data *tgt_priv;
> +
> +	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list) {
> +		tgtdev->dev_handle =3D MPI3MR_INVALID_DEV_HANDLE;
> +		if (tgtdev->starget && tgtdev->starget->hostdata) {
> +			tgt_priv =3D tgtdev->starget->hostdata;
> +			tgt_priv->dev_handle =3D MPI3MR_INVALID_DEV_HANDLE;
> +		}
> +	}
> +}
> +
> +
> +/**
> + * mpi3mr_flush_scmd - Flush individual SCSI command
> + * @rq: Block request
> + * @data: Adapter instance reference
> + *
> + * Return the SCSI command to the upper layers if it is in LLD
> + * scope.
> + *
> + * Return: true always.
> + */
> +
> +static bool mpi3mr_flush_scmd(struct request *rq,
> +	void *data, bool reserved)
> +{
> +	struct mpi3mr_ioc *mrioc =3D (struct mpi3mr_ioc *)data;
> +	struct scsi_cmnd *scmd =3D blk_mq_rq_to_pdu(rq);
> +	struct scmd_priv *priv =3D NULL;
> +
> +	if (scmd) {
> +		priv =3D scsi_cmd_priv(scmd);
> +		if (!priv->in_lld_scope)
> +			goto out;
> +
> +		mpi3mr_clear_scmd_priv(mrioc, scmd);
> +		scsi_dma_unmap(scmd);
> +		scmd->result =3D DID_RESET << 16;
> +		scsi_print_command(scmd);
> +		scmd->scsi_done(scmd);
> +		mrioc->flush_io_count++;
> +	}
> +
> +out:
> +	return(true);
> +}
> +
> +
> +/**
> + * mpi3mr_flush_host_io -  Flush host I/Os
> + * @mrioc: Adapter instance reference
> + *
> + * Flush all of the pending I/Os by calling
> + * blk_mq_tagset_busy_iter() for each possible tag. This is
> + * executed post controller reset
> + *
> + * Return: Nothing.
> + */
> +void mpi3mr_flush_host_io(struct mpi3mr_ioc *mrioc)
> +{
> +	struct Scsi_Host *shost =3D mrioc->shost;
> +
> +	mrioc->flush_io_count =3D 0;
> +	ioc_info(mrioc, "%s :Flushing Host I/O cmds post reset\n", __func__);
> +	blk_mq_tagset_busy_iter(&shost->tag_set,
> +	    mpi3mr_flush_scmd, (void *)mrioc);
> +	ioc_info(mrioc, "%s :Flushed %d Host I/O cmds\n", __func__,
> +	    mrioc->flush_io_count);
> +}
> +
> /**
>  * mpi3mr_alloc_tgtdev - target device allocator
>  *
> @@ -2509,6 +2591,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci=
_device_id *id)
> 	INIT_LIST_HEAD(&mrioc->tgtdev_list);
> 	INIT_LIST_HEAD(&mrioc->delayed_rmhs_list);
>=20
> +	mutex_init(&mrioc->reset_mutex);
> 	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
>=20
> 	for (i =3D 0; i < MPI3MR_NUM_DEVRMCMD; i++)
> @@ -2518,6 +2601,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci=
_device_id *id)
> 	if (pdev->revision)
> 		mrioc->enable_segqueue =3D true;
>=20
> +	init_waitqueue_head(&mrioc->reset_waitq);
> 	mrioc->logging_level =3D logging_level;
> 	mrioc->shost =3D shost;
> 	mrioc->pdev =3D pdev;
> @@ -2542,7 +2626,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci=
_device_id *id)
> 	}
>=20
> 	mrioc->is_driver_loading =3D 1;
> -	if (mpi3mr_init_ioc(mrioc)) {
> +	if (mpi3mr_init_ioc(mrioc, 0)) {
> 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> 		    __FILE__, __LINE__, __func__);
> 		retval =3D -ENODEV;
> @@ -2565,7 +2649,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci=
_device_id *id)
> 	return retval;
>=20
> addhost_failed:
> -	mpi3mr_cleanup_ioc(mrioc);
> +	mpi3mr_cleanup_ioc(mrioc, 0);
> out_iocinit_failed:
> 	destroy_workqueue(mrioc->fwevt_worker_thread);
> out_fwevtthread_failed:
> @@ -2615,7 +2699,7 @@ static void mpi3mr_remove(struct pci_dev *pdev)
> 		mpi3mr_tgtdev_put(tgtdev);
> 	}
>=20
> -	mpi3mr_cleanup_ioc(mrioc);
> +	mpi3mr_cleanup_ioc(mrioc, 0);
>=20
> 	spin_lock(&mrioc_list_lock);
> 	list_del(&mrioc->list);
> @@ -2655,7 +2739,7 @@ static void mpi3mr_shutdown(struct pci_dev *pdev)
> 	if (wq)
> 		destroy_workqueue(wq);
>=20
> -	mpi3mr_cleanup_ioc(mrioc);
> +	mpi3mr_cleanup_ioc(mrioc, 0);
>=20
> }
>=20
> --=20
> 2.18.1
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

