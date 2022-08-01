Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08AC3C00144
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 19:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbiHATOW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 15:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235016AbiHATNW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 15:13:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CDD326E2
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 12:12:24 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271HsIYE025353;
        Mon, 1 Aug 2022 19:12:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=X+I1rm+n1wL0YF4JP6OvxctD2XHcXtmyaGNrr04vBI0=;
 b=JnaUScIsb5PrfpUTXwfdDVKg6ZzXK6Qo6CBW5Im0jaqQz1vJ/QNBbQR2+aLJK1niqe5h
 iyit+uBgjjXWFXCt9P3tFK8ovHfMrXU83WhywL0ZZM0L4TZaoENRH9ryeeJcKXK6DnJV
 U3u4I70qTc8Prh6fpsmf6wYRhqlKfU1AN1V1wY2B+3xYR0OmfIUHo3Yy5642sFupZh86
 a2A2Yla70abfrlMAWEUQQLvN3CwM2kkKdjhC0c0T1vyixFbDzavQtVoHzYylDPuFat/Y
 28qtxvRepmNK1ILs4kq2ZuBrbuMCcp21HIzUvCknZe6iFXQ97VA0mRG2pPf8j+5KNuZz iA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmw6tcnnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 19:12:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 271I0lIX014927;
        Mon, 1 Aug 2022 19:12:21 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu31m5u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 19:12:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FULyua0ZzHL0d0BHyrdyJqgXafGSMB8d98HoLfeItx7OySmAOa/iaABWBSi8/sm0RBZolcIr/0nSmz/RyCjUdHQrziXqBzc75jkNUZTRmhdFkqk9XIjEYlKWa2n5g6wGTAMlP0TK1IDi7xRUirNjsvStv8+jJI7+qBQ7mIRSDHLwR5UMsLpxeifPl0ZBuJ22f25YBlPNbYwycwqGIiSQnsieLVzan0nYRb5XZRt0xpAKxQwFuUeViTodwI9TxoOnrBYG1FmiKWMOj9GLkoYrXscJKm3FGh6AIf9yEYHpN1qh7Q8t8Wu5NZXO5gilCL4pnHJS3h3DN0i6nCeJZusg5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X+I1rm+n1wL0YF4JP6OvxctD2XHcXtmyaGNrr04vBI0=;
 b=ANNitCs2+m/HMb0hz9koUL5MI1h3TQzikq4KCUHdNgzZ8TKSSMgNtHWkifxsoAblAhclrDC4QF0KPgq+3WxEdug75qh07OMd6qEGU9qdwlvVhlygSJPZJSrREC8IXsx12/BwU6rzHwtna41xC/2nYbwVD9SDx11/o/S5tIadWKeaAxpXhQ8kiKLVyiaFzK30IgvXdxFAOqUjl4L40QFSj9f7eOydvm3F+iaUr9tZWHfoklM9cB+rf2u5fzDRo/XSsCJRXi0jMK0zOO3P8u5hutqZsRrAGix77RCI8XDgFYQdf4gpVgvlCxhqlK8sv9gsuON4gqt9RDH6bWLdhCQsbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+I1rm+n1wL0YF4JP6OvxctD2XHcXtmyaGNrr04vBI0=;
 b=XlTS6USqNh6wwTbqkxvI6+16KcNPO48Ex7wKArirwa5+PzMLgx4jsItO4iwz+jh7l1QAuAePGw6zxd7K77BnRwjyq2Aoe7D3JNRn9yd8DdSxVR5hZkuBl0WAoOw79qWoHqaC9W3MQ6eafWrryULbFmtdiLpBFBJgLqEsBTxVU4Q=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM5PR10MB1499.namprd10.prod.outlook.com (2603:10b6:3:10::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Mon, 1 Aug
 2022 19:12:15 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3%3]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 19:12:15 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [PATCH 08/15] mpi3mr: Enable STL on HBAs where multipath is
 disabled
Thread-Topic: [PATCH 08/15] mpi3mr: Enable STL on HBAs where multipath is
 disabled
Thread-Index: AQHYo0v+HQ/K55ltN06HTpU46pIYlq2abqCA
Date:   Mon, 1 Aug 2022 19:12:15 +0000
Message-ID: <2C23AD3C-A987-485D-AD1F-EF795814A6F0@oracle.com>
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
 <20220729131627.15019-9-sreekanth.reddy@broadcom.com>
In-Reply-To: <20220729131627.15019-9-sreekanth.reddy@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb242154-8491-4505-5aa0-08da73f1bf1e
x-ms-traffictypediagnostic: DM5PR10MB1499:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NRThkzvLAC590FdQ5aSK2zrWOI3Mh0Yn1kvELfHeLgqNRIoqKMUOGRK/Nlt7PVyJDHZBxaIAy0F5+/HI4drjTsC8uH98mDjqTIOp/c5UaSTexIVXonBHhhZxPuychUmqAcFjGEtZ2nw42aWy5GNRLFrDMQnl/NA1Y+9XVYYDk5W9D6GKOB9tfxsWagTDyOtyx8RZKs1Zed+aejWUmIKOBMGeqBcy08fAF52YBG0QXVma4E5pt9KMsVQvgOGa3/eXdQrMFcYwxbWZW5Q+enhrSq2gSeODdNI/sFfnJ+YtbHC3dmzUei/VFtVn62bf3ZNI3CDF7l71F5KHMeg+ldvz4biuQi1r8XHROX6jrzckBvuYxYyZ0fEi5n3xcMk3ate048VB9B0cTkNz7oQW0EwUzv3PEyqoZA8G1nY0kQPlEJjPt9pekd1o+EgI5ECoc6byYRGyTtFgMrp4hqDh+7tMcBxMNllhGYsXkdfj54TvHpvTS0W0GUiwewTsB5F0GgRLYfrPwxP7vi2yzVIQmhsyaBZYxmSj8oqJ7XffC+pItCj+KPxdcKCUtjkwN8XJYcv/0hku2f8Woy6NEDOV9qm03x4a2TQFEIYiQhSVWD29n0ldBlv8nmn2wgCx4SK5LfKpcgw8jgs/zelgKz30kbxN/Pq+BigaehPhi47nYFMAWrMNFtaT6mgcAB//mgXNolz09jTDf8QC4UWF0Wo++56cvebfJ6Ns1ngAtD41FAqtqH3jllc4rlbI1nDJtelT67AmNcUHc9Swi62Fpl9RCrAn6/OPWnOMRVIbLG06hy1p/r/wgry5YsZyBuSjwDZWl3Nvk90P0KcQqve26selCMJ7C5XQLVd19a4kWarLiZJ6fCE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(376002)(366004)(39860400002)(66446008)(8676002)(64756008)(66556008)(66946007)(83380400001)(76116006)(66476007)(38070700005)(71200400001)(91956017)(26005)(4326008)(6512007)(6506007)(41300700001)(186003)(53546011)(86362001)(2906002)(2616005)(8936002)(478600001)(6486002)(33656002)(44832011)(107886003)(54906003)(5660300002)(38100700002)(122000001)(6916009)(36756003)(316002)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ogRffzT/Ah2Vw/+ozpRRvdGh04Ci9uUXjKWcFBlIAeAfEvjRzdOi+3kLTgsJ?=
 =?us-ascii?Q?wP8Sj8jNBLVwLPIV7rPON+76O6BOv62pU3ivhk2dv+p77TXm38IljU0uFov8?=
 =?us-ascii?Q?LxwacqPBiMFkYOPPGXwH5SlFfUs3e+QFUPbrNV4icWBbXYLNWZiWuwENkokg?=
 =?us-ascii?Q?fRpmUp6dFjMhS6yLQpO9XV96kTz8iSX9b/vWLSTib32kCK98lqLe39S1ez4a?=
 =?us-ascii?Q?0YENiCDcOJu7fGoX7bIAdRqaAhr+S+lBZWMRw6H1NwL/ZhnsYXC3bjhDEjw/?=
 =?us-ascii?Q?9DJH8tue+ZnCSIG0m0/+0SpdD+V/C1loupcCeaBRGd2ZLguOhsH4LPZLFztd?=
 =?us-ascii?Q?YHE2hUd9seuwnobE9HyDDsAUgUvQri/MS05eRQy6aAaVVkNAsqcAadDIhcJO?=
 =?us-ascii?Q?QEauvAYlqm+r37dP00hXM+HmfUYA+Ddx+bzMRSsAFRfwyUnstbyHcKjGy7O5?=
 =?us-ascii?Q?imPnPNNjgkjnvy61AHsnTIoj7fkcvNV11iMjZYaBLaMz/mi0mF1F175SICu/?=
 =?us-ascii?Q?3B1Tr+DSL+YjHaCr/uKNDd4Ml2+W2fEVl0Nb0EKxfXZvuIu4YIasXXz8GoZJ?=
 =?us-ascii?Q?LBdxaSxSsoQuASexr783EQskny0cwpXf2dBUKN7P3mnO8At9C8lo9OKn5y4i?=
 =?us-ascii?Q?WTEmBMc3vCTotxJ2w8BP4H3cc2TNsgZzKXkjvnrlKInJKNbctRjhOg61r/rD?=
 =?us-ascii?Q?E2AfRC4BSUDpuZt2gt2ppHmLTNSxXjv9zN1so4jwFZUlreeLgSLO0eqOqIYN?=
 =?us-ascii?Q?BJ7t8b1YjZlf8J5ADA8+1+OWNEDSTldox9YWSYm3mtuZcA5pX+m1qfMaKZIW?=
 =?us-ascii?Q?Bq6RrBZlrS0cfWalAMFyOnIbc+V4Gha2VOLIkF636qjWhf4NwU0n+2zb5ZX8?=
 =?us-ascii?Q?ZoBN4skiIfD94jQWemMdsbyTrtdxBpw8yX0kdD/4Z3xrxSCZ5koDJdBb9698?=
 =?us-ascii?Q?/J4/hYriCEyh0a9xEnVyPt0WCcqtnM6F0p174mekEq3oW5oyXsXIQADH7eUS?=
 =?us-ascii?Q?Mt2sJBOBwRg6qr9Bx4FMvqVyFFe1ja4WO0AQt4ck3e4HfxB3S6HeDpRLGG/o?=
 =?us-ascii?Q?RFm1npUBtrzwBHAOaYHJiwUCy3Ay5T1iwfH7S6OZfMdOhVzfrzFXQKW03J6u?=
 =?us-ascii?Q?oXZ3ZBvSs8WGxiWEz7jS8Z5BZqNPBsPKBZf44kSEcTCZeihRpc8PdNU4nx3B?=
 =?us-ascii?Q?3oK3dLtc9nRqQPAI8Nv4yxk5hnv7gBW5hyfZjihLjEp9s/QQYzgmnrBZ4Rhy?=
 =?us-ascii?Q?Na4GuRZRuusJaYbz76WWm0g0PPVFUG4C0d+YuXuk7T1qPbbqHZLprw8A0OD6?=
 =?us-ascii?Q?/jKYKfvQa8YO+48Tr4bmiqDvtAkBPI62VM+nfq04Nh/O+qiz2H8pTp+xAqhR?=
 =?us-ascii?Q?7zuSlE6pxh6Yat6Whd8X3MchFlzTy3k4bzllNbytXkwgKOG5VTi/ZdKprNWB?=
 =?us-ascii?Q?/PvChkqMSMH4dAs6pW4bBh35lKn1KFVxoTMJiG1Glqus/N4CoiGO7YuCNimd?=
 =?us-ascii?Q?gQILhBvB4QQJVqNXIyDa5+iN2znylWp1e1WwRF5cglGO15/f1Y7MiSiHc/lq?=
 =?us-ascii?Q?DBD8iHYB78F9AjVt4TL5ljiCdXqAStAaTIuVjmTzFhnFdj19MAHykhQwnryY?=
 =?us-ascii?Q?Bg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B631857819180A4B86DBF575763ACF1A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb242154-8491-4505-5aa0-08da73f1bf1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 19:12:15.6627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DwV2qMbSbtMEq+DL3e/KSJgL9SLlozD/w4u/13U54hWFReLvunpOMJubhoL5rPAcw/+sTGjIsj/ji2PUKv3LW0lzguL4D5mgf5o7cie6iFo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1499
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_08,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208010096
X-Proofpoint-GUID: G3CKkQQdT8XHnicNbVzosNa-0nPFGCa9
X-Proofpoint-ORIG-GUID: G3CKkQQdT8XHnicNbVzosNa-0nPFGCa9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 29, 2022, at 6:16 AM, Sreekanth Reddy <sreekanth.reddy@broadcom.co=
m> wrote:
>=20
> Register the SAS, SATA devices to SCSI Transport Layer (STL)
> only if multipath capability is disabled on the controller's
> firmware.
>=20
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
> drivers/scsi/mpi3mr/mpi3mr.h    |  6 ++++++
> drivers/scsi/mpi3mr/mpi3mr_fw.c | 13 +++++++++++++
> drivers/scsi/mpi3mr/mpi3mr_os.c | 31 +++++++++++++++++++++++++++----
> 3 files changed, 46 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 8ab843a..8c8703e 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -650,6 +650,8 @@ union _form_spec_inf {
>  * @dev_type: SAS/SATA/PCIE device type
>  * @is_hidden: Should be exposed to upper layers or not
>  * @host_exposed: Already exposed to host or not
> + * @io_unit_port: IO Unit port ID
> + * @non_stl: Is this device not to be attached with SAS TL
>  * @io_throttle_enabled: I/O throttling needed or not
>  * @q_depth: Device specific Queue Depth
>  * @wwid: World wide ID
> @@ -669,6 +671,8 @@ struct mpi3mr_tgt_dev {
> 	u8 dev_type;
> 	u8 is_hidden;
> 	u8 host_exposed;
> +	u8 io_unit_port;
> +	u8 non_stl;
> 	u8 io_throttle_enabled;
> 	u16 q_depth;
> 	u64 wwid;
> @@ -992,6 +996,7 @@ struct scmd_priv {
>  * @cfg_page: Default memory for configuration pages
>  * @cfg_page_dma: Configuration page DMA address
>  * @cfg_page_sz: Default configuration page memory size
> + * @sas_transport_enabled: SAS transport enabled or not
>  * @sas_hba: SAS node for the controller
>  * @sas_expander_list: SAS node list of expanders
>  * @sas_node_lock: Lock to protect SAS node list
> @@ -1174,6 +1179,7 @@ struct mpi3mr_ioc {
> 	dma_addr_t cfg_page_dma;
> 	u16 cfg_page_sz;
>=20
> +	u8 sas_transport_enabled;
> 	struct mpi3mr_sas_node sas_hba;
> 	struct list_head sas_expander_list;
> 	spinlock_t sas_node_lock;
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 9c36f52..0659d3f 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -1136,6 +1136,13 @@ mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mri=
oc)
> 		return -EPERM;
> 	}
>=20
> +	if ((mrioc->sas_transport_enabled) && (mrioc->facts.ioc_capabilities &
> +	    MPI3_IOCFACTS_CAPABILITY_MULTIPATH_ENABLED))
> +		ioc_err(mrioc,
> +		    "critical error: multipath capability is enabled at the\n"
> +		    "\tcontroller while sas transport support is enabled at the\n"
> +		    "\tdriver, please reboot the system or reload the driver\n");
> +
> 	dev_handle_bitmap_sz =3D mrioc->facts.max_devhandle / 8;
> 	if (mrioc->facts.max_devhandle % 8)
> 		dev_handle_bitmap_sz++;
> @@ -3453,6 +3460,7 @@ static const struct {
> 	char *name;
> } mpi3mr_capabilities[] =3D {
> 	{ MPI3_IOCFACTS_CAPABILITY_RAID_CAPABLE, "RAID" },
> +	{ MPI3_IOCFACTS_CAPABILITY_MULTIPATH_ENABLED, "MultiPath" },
> };
>=20
> /**
> @@ -3734,6 +3742,11 @@ retry_init:
> 		mrioc->max_host_ios =3D min_t(int, mrioc->max_host_ios,
> 		    MPI3MR_HOST_IOS_KDUMP);
>=20
> +	if (!(mrioc->facts.ioc_capabilities &
> +	    MPI3_IOCFACTS_CAPABILITY_MULTIPATH_ENABLED)) {
> +		mrioc->sas_transport_enabled =3D 1;
> +	}
> +
> 	mrioc->reply_sz =3D mrioc->facts.reply_sz;
>=20
> 	retval =3D mpi3mr_check_reset_dma_mask(mrioc);
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 905b434..ae77422 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -1032,6 +1032,7 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc =
*mrioc,
> 	tgtdev->perst_id =3D le16_to_cpu(dev_pg0->persistent_id);
> 	tgtdev->dev_handle =3D le16_to_cpu(dev_pg0->dev_handle);
> 	tgtdev->dev_type =3D dev_pg0->device_form;
> +	tgtdev->io_unit_port =3D dev_pg0->io_unit_port;
> 	tgtdev->encl_handle =3D le16_to_cpu(dev_pg0->enclosure_handle);
> 	tgtdev->parent_handle =3D le16_to_cpu(dev_pg0->parent_dev_handle);
> 	tgtdev->slot =3D le16_to_cpu(dev_pg0->slot);
> @@ -1092,6 +1093,13 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc=
 *mrioc,
> 		else if (!(dev_info & (MPI3_SAS_DEVICE_INFO_STP_SATA_TARGET |
> 		    MPI3_SAS_DEVICE_INFO_SSP_TARGET)))
> 			tgtdev->is_hidden =3D 1;
> +
> +		if (((tgtdev->devpg0_flag &
> +		    MPI3_DEVICE0_FLAGS_ATT_METHOD_DIR_ATTACHED)
> +		    && (tgtdev->devpg0_flag &
> +		    MPI3_DEVICE0_FLAGS_ATT_METHOD_VIRTUAL)) ||
> +		    (tgtdev->parent_handle =3D=3D 0xFFFF))
> +			tgtdev->non_stl =3D 1;
> 		break;
> 	}
> 	case MPI3_DEVICE_DEVFORM_PCIE:
> @@ -1124,6 +1132,7 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc =
*mrioc,
> 		    ((dev_info & MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_MASK) !=3D
> 		    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_SCSI_DEVICE))
> 			tgtdev->is_hidden =3D 1;
> +		tgtdev->non_stl =3D 1;
> 		if (!mrioc->shost)
> 			break;
> 		prot_mask =3D scsi_host_get_prot(mrioc->shost);
> @@ -1147,6 +1156,7 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc =
*mrioc,
> 		tgtdev->dev_spec.vd_inf.state =3D vdinf->vd_state;
> 		if (vdinf->vd_state =3D=3D MPI3_DEVICE0_VD_STATE_OFFLINE)
> 			tgtdev->is_hidden =3D 1;
> +		tgtdev->non_stl =3D 1;
> 		tgtdev->dev_spec.vd_inf.tg_id =3D vdinf_io_throttle_group;
> 		tgtdev->dev_spec.vd_inf.tg_high =3D
> 		    le16_to_cpu(vdinf->io_throttle_group_high) * 2048;
> @@ -1424,8 +1434,9 @@ mpi3mr_sastopochg_evt_debug(struct mpi3mr_ioc *mrio=
c,
> 	ioc_info(mrioc, "%s :sas topology change: (%s)\n",
> 	    __func__, status_str);
> 	ioc_info(mrioc,
> -	    "%s :\texpander_handle(0x%04x), enclosure_handle(0x%04x) start_phy(=
%02d), num_entries(%d)\n",
> +	    "%s :\texpander_handle(0x%04x), port(%d), enclosure_handle(0x%04x) =
start_phy(%02d), num_entries(%d)\n",
> 	    __func__, le16_to_cpu(event_data->expander_dev_handle),
> +	    event_data->io_unit_port,
> 	    le16_to_cpu(event_data->enclosure_handle),
> 	    event_data->start_phy_num, event_data->num_entries);
> 	for (i =3D 0; i < event_data->num_entries; i++) {
> @@ -1732,6 +1743,9 @@ static void mpi3mr_set_qd_for_all_vd_in_tg(struct m=
pi3mr_ioc *mrioc,
> static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
> 	struct mpi3mr_fwevt *fwevt)
> {
> +	struct mpi3_device_page0 *dev_pg0 =3D NULL;
> +	u16 perst_id;
> +
> 	mpi3mr_fwevt_del_from_list(mrioc, fwevt);
> 	mrioc->current_event =3D fwevt;
>=20
> @@ -1752,8 +1766,10 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mri=
oc,
> 	}
> 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
> 	{
> -		mpi3mr_devinfochg_evt_bh(mrioc,
> -		    (struct mpi3_device_page0 *)fwevt->event_data);
> +		dev_pg0 =3D (struct mpi3_device_page0 *)fwevt->event_data;
> +		perst_id =3D le16_to_cpu(dev_pg0->persistent_id);
> +		if (perst_id !=3D MPI3_DEVICE0_PERSISTENTID_INVALID)
> +			mpi3mr_devinfochg_evt_bh(mrioc, dev_pg0);
> 		break;
> 	}
> 	case MPI3_EVENT_DEVICE_STATUS_CHANGE:
> @@ -1851,6 +1867,9 @@ static int mpi3mr_create_tgtdev(struct mpi3mr_ioc *=
mrioc,
> 	u16 perst_id =3D 0;
>=20
> 	perst_id =3D le16_to_cpu(dev_pg0->persistent_id);
> +	if (perst_id =3D=3D MPI3_DEVICE0_PERSISTENTID_INVALID)
> +		return retval;
> +
> 	tgtdev =3D mpi3mr_get_tgtdev_by_perst_id(mrioc, perst_id);
> 	if (tgtdev) {
> 		mpi3mr_update_tgtdev(mrioc, tgtdev, dev_pg0, true);
> @@ -4850,7 +4869,11 @@ static void mpi3mr_remove(struct pci_dev *pdev)
> 	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
> 	if (wq)
> 		destroy_workqueue(wq);
> -	scsi_remove_host(shost);
> +
> +	if (mrioc->sas_transport_enabled)
> +		sas_remove_host(shost);
> +	else
> +		scsi_remove_host(shost);
>=20
> 	list_for_each_entry_safe(tgtdev, tgtdev_next, &mrioc->tgtdev_list,
> 	    list) {
> --=20
> 2.27.0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

