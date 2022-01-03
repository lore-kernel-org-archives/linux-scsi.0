Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4F5C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 00:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiACAcj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jan 2022 19:32:39 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46052 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbiACAci (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jan 2022 19:32:38 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2029AgZj018061;
        Mon, 3 Jan 2022 00:32:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=pTffXQoRTRqCfdckFsYaCEZReEKUAhylNtmsDqGxB1s=;
 b=uq3z52bUVSngpkeHpREBm2csbu+Th7rPQ2OBXHGpINSA1V8cdOtnTxpibau7O53fMeaq
 sIWhpm98Q8UvRb5jXkX4PZOAYHW2uB4ax7hsGvn/bPVThOA4Cpyw9fFgldNSSJ9CuDyu
 RBXpoKPNWGolOYbOcukN3aKWdQ48n9A50agMwg1j27nmdeSTCzgbWgMSyLDdxfBlROoc
 sRup4ZoeNgz1WINhVCREkSuMG3t+U5ZgDF2DzAwTWXEWWnkLWjbYGUFJSLzzoO5OtjvK
 1JHSEiaSysvi40g8gyZ9zk6c5tOBlEGB8mGth+sJO4e1tKOexWeeYuqQ3nlGxFvdmZ+J ig== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dafgu9p15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:32:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2030PYTx155656;
        Mon, 3 Jan 2022 00:32:34 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2048.outbound.protection.outlook.com [104.47.74.48])
        by aserp3020.oracle.com with ESMTP id 3daes1nbcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:32:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PB9rRYv4F6ZFBZOmgi09E7FfhWh+LPUPzSX/Z3Du3iRRZcrVSXHpl55vZcNfJ8JbVTt4aTsINZq/AF/arxxf5myA9Wv2RCLxmb3jpmW1/6PY5DjHXliN6TLiVndcnffybYaFR5PDyLVzlCnf6jjFN+wA8gqNbbbIrZsqo2kOMYzHys8Cvcn1SnLlDTiVARf53hOEIYPO9VCbKBedb7tNfttknBbMFgfx2SHG1Jzu3I2iKu0bnK1MCdJqq0IZrpjdpSiM8EPaItX9C/lYynBf5N0fEKIfAUorZ/j+N7cLAKEsOS3KGAZXxdgVuXieMbQ+CR4cZCABUUT149dwReKeIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pTffXQoRTRqCfdckFsYaCEZReEKUAhylNtmsDqGxB1s=;
 b=JJQjQ8gdoeWiCUva7xZSnSsLp7S04pIMJ1KRhxenyFBZn/m6lVjj59t6l8Hhg1JHP5B0Kar1wU/rSqM4N6/I7DiwDLt1d91Tv29rrkc/8XUri1pQFLlgonhFwtIysuld5zOkmcOZFe0BtYe09WkoXwkVovGykdQ3gw7iSFD5bH/Qovbo4ElSvoZh2Ax2cjJxY+TV+T8laz8K4F6VZ3+dCSkuLn9mu0mdjR6pe09swIFyQ/3mFzyJTfGVkPJelf4iKu21zGRcOwkItgTlqx5YazdS4iGHodiPqGH5mqLLAhNyoU0WRuZOrpr+23BX0bjuQWWt36v6SHt+0ImNkkngyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pTffXQoRTRqCfdckFsYaCEZReEKUAhylNtmsDqGxB1s=;
 b=JgFautPoIF6R87IjtS/OvV80nI+SUQFfD0jjsAy0mudaCmW2quFQt0SWZnxtQXlYg4uGo7r7DYNUvNuh6ebsZNojPdVx3S6DXEmrl+bGkcEZw1GT1Ku4frvHWsHOF8A2rdKs57R+8KafAYSFOuAy3RqlSf4kiYO7Q36QGdjcTa0=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2510.namprd10.prod.outlook.com (2603:10b6:805:3f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Mon, 3 Jan
 2022 00:32:32 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 00:32:32 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 02/16] qla2xxx: Implement ref count for srb
Thread-Topic: [PATCH 02/16] qla2xxx: Implement ref count for srb
Thread-Index: AQHX+JT7FAEaXZI6BkCL9hReofoy6qxQgZ+A
Date:   Mon, 3 Jan 2022 00:32:32 +0000
Message-ID: <02990604-CC38-42ED-B3D6-11CCA0C5D43E@oracle.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-3-njavali@marvell.com>
In-Reply-To: <20211224070712.17905-3-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29c693cc-bda8-4e56-3aa2-08d9ce5087ee
x-ms-traffictypediagnostic: SN6PR10MB2510:EE_
x-microsoft-antispam-prvs: <SN6PR10MB2510DAF7069C7C25CC04E676E6499@SN6PR10MB2510.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:247;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7PCOTN8LrW5TyKsbMvRHUQad3Br6fJAEZ2mmRFQmZ1tFyTOOgIhFsDgIllv8HdH5TWUBl8okgnilRRG40lSTI0+qkRzHuydnJ2kNUQB6nZo5wY9Yjc9mpyahITxB4HFlOw7HgMnQyEdGDPyXcEfzrNkBTdpizj3S/Iz29AhH3NVzv93s8UquJ63MshsRXE7sQNDU9/AvN95VCfmSbJK4pNXY/gi267V0YGVZJ5WFKM3tx8N+tGLr1oZamRV36CdKu2cFUDBG1TQV7V1Mqo7XZFH/M+Ovgg67don0AGuLUeE7FBH+pR7XKHOjX6oSssgTlCzbDy6FpoA1R2AY6+8nBZziQx0h5necKvS3udJSsloN/aY4yFEklNvi9vsk0KzHZ1rhriaU3FCLa1WYbHRzoPy4CTMU4Ii9aHgO0CVWzXDiDji7ZjfaGzXoUQ7mZDNOFw843EVjt3ef8UImmO6AxHDOczEFItfRuic4O8Y/IhNH8IpjsDvJdph9aisRiETJ20Jes+w9pDXhDZiYZJD5nW1QPSE4bKkq7s/k/AGcGdBvtc1qRHcksbxaR4EDierItfvzIFNvPFmJNbugcMT8eMmJINi+MKmMCIcRVBvGcjLm+awPcRJ4jDMz5EOsqYSnleXmq3K9t+a8E2J55Z3XIN2mcjbV6r0QYoscAi8JJtUMvez33o4NwYMq6zj1aJkNiUw8z95d5rmgq8V6/K0F92LXN8JQR2Rzrgck6C80pAM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(122000001)(86362001)(38100700002)(2616005)(38070700005)(26005)(508600001)(53546011)(6486002)(186003)(36756003)(6506007)(316002)(6512007)(83380400001)(64756008)(71200400001)(33656002)(5660300002)(8676002)(91956017)(66556008)(66446008)(66946007)(2906002)(76116006)(66476007)(6916009)(4326008)(44832011)(54906003)(8936002)(30864003)(45980500001)(579004)(559001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FA1Nv8BF0q+aPpx601mvtf3PSC1CAYyTcGymxsQEX220OgtZPQ9k3pGb9tPX?=
 =?us-ascii?Q?luTdd79UlN0WxHyO+AvbDHpCtYwXT4wFafEUOtYnPe1vPzO9mGMG8GWPRWjK?=
 =?us-ascii?Q?EXaG4/QQP92IWTbYUE5ldN+e2nUB7qNEkDdfIW3o24yKw+fcaiJLv66y6bpX?=
 =?us-ascii?Q?7Gb7RVW0npg10FNG9aiWNx3uhcZ1dTITkXWcx8kwWGHToDAMaJGeBnjG2FuH?=
 =?us-ascii?Q?UkdwTP7AlxsHqiFoLTs9R6/zvi/tGGFqN6JJo7Hx/1k8CDPWLVM92YtBNL3a?=
 =?us-ascii?Q?0xeYpkWnFUOYcIkMYX2lM/neqAprbSdpnVcSfF72h/wE7fpwNWKYHHXxtopZ?=
 =?us-ascii?Q?ezzN+RiVX2ePXsG7Eg7W/5dycmJv6UWr2mGK+Dcdbmi1KTMqyGqmF0LYqO0u?=
 =?us-ascii?Q?h+8gBM0gQEtzAWgX9uKo1YMXfjSDT8TjD630jPaY41a86t+zx0ziE04LY6KN?=
 =?us-ascii?Q?8+zQ2kOmYOFW2BPHjDx8Z//C/MSorkAPktiNzoQdgGhnU9FxDfhUrV990JS+?=
 =?us-ascii?Q?vbHUSv22GZ8lFFgCK2YxM2eni3s5u7rCdwUXFTYiW1C9rv44ElhVfsrUsq6W?=
 =?us-ascii?Q?8jn9eppCAv20hxbDeUIBSmbFOnZBH4D437K5HlXfueVxgUgpoyXQPI8ghGT0?=
 =?us-ascii?Q?oBAYz6NGcGanlcYlVDdO2lVuPDTBVskmo0RCCdlV/fCOEN0Mq/sI3g4YLX3u?=
 =?us-ascii?Q?UPiBXZouiqQyH7z+cb3JK1UBU+eyHYjGzLn/ZRQ415dCKVuiCL4gtLEJjrfz?=
 =?us-ascii?Q?T6fm8k1nOnsRtCB4F8kzVj/HK8a1eduVrvedNmS6rJMz6MMYtfuaa9Ynhurp?=
 =?us-ascii?Q?yNJxONw/rfHnXbSzBwFkNR82C45KRcG9Y+zoMw3PxC0zIpQIoHK4VcBOtJU/?=
 =?us-ascii?Q?De+HPGfmuOok14bLDVFQ1NqGOaAK2+Ehan7fqOJv8Gk1u0iDeM+VASKJpslE?=
 =?us-ascii?Q?7Jr+2Yv3ccj3nmoXmroZD0NbvgQiMkrlJ7K3ZAM4fHSahGExcrPhRMd3gchM?=
 =?us-ascii?Q?2v4n1cg0GOsPteMwXlDWtJMGkBpaZ9oQ/07yhhpL+CuBOkXD5ifE/UooYDna?=
 =?us-ascii?Q?FTkiEJRTtyCjBdyLNFqCTDWDuhiNDJ7B143MzMK9a1EXKWu+ULZME2XshTlu?=
 =?us-ascii?Q?sAy+sA6QgZi7gy0fU9JD6eJXDG9cVjz9qyPASwpoBNFjavsC9HIGzLNGFIhl?=
 =?us-ascii?Q?BjR4lZKmxgF/mp2R+SRALsADw8CQq1zrb9gBYjIuVT4GPjvMVhSW+CoXcp4q?=
 =?us-ascii?Q?+YQLCNAKnxCLB26JvoYvHgvo3PhaMllGImraklDhM+3hZ/YR/93iJsQANdGV?=
 =?us-ascii?Q?YVzLDt9EMT47DesguLU/xiCAzmbOs3i2CAL0s3OuU8nBhorlBc62R6M0TcwT?=
 =?us-ascii?Q?sdumKYr5Oq7Roni2YNtvAEYOEHEQm/yj5Hri4JKWukH193icyLE5CV+l1FES?=
 =?us-ascii?Q?hvBCghyTXKmKTG7K723WhvWPswourENXWErFspQkVK3GHZWQ9PHsxv+MgfAw?=
 =?us-ascii?Q?rC7B26IrbgcNfwE9p2d5iZfyNUEld2Duea+tpRh+7exsvEws2wuvBg3xeMhB?=
 =?us-ascii?Q?jxoYFq+iy/SrbqpFfKGjRDIQ/oL5abdY6SFyoYNTq+gnj1Ol1LWwM7BZZM7v?=
 =?us-ascii?Q?IxqMXlmoz/18NoYhYnV/KR/9NLW8/U5DFPxSzoV7OoPXpyLq5m5iWOqtModH?=
 =?us-ascii?Q?CnHQg5/+xwqDYHdMG1ulAm/CxyI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <513152BBF0FFAC449FB9D786DEF4EA5E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29c693cc-bda8-4e56-3aa2-08d9ce5087ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 00:32:32.2096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z+ou2ElHug6VbFIQxKI9KMA3X4plC8NQFoMXWV8HyaSv/cwrfUQQYhCN7glrhaMOyCS9OgP+Y9ags3BYYpo31kmcTBM9qMbzGZpet/q3GxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2510
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10215 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201030002
X-Proofpoint-ORIG-GUID: dipAHfw5oBg16IWfbCiKrsPo6V-o3GXS
X-Proofpoint-GUID: dipAHfw5oBg16IWfbCiKrsPo6V-o3GXS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 23, 2021, at 11:06 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Saurav Kashyap <skashyap@marvell.com>
>=20
> Fix race between timeout handler and completion handler by introducing
> a reference counter. One reference is taken for the normal code path
> (the 'good case') and one for the timeout path.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_bsg.c    |  6 ++-
> drivers/scsi/qla2xxx/qla_def.h    |  5 ++
> drivers/scsi/qla2xxx/qla_edif.c   |  3 +-
> drivers/scsi/qla2xxx/qla_gbl.h    |  1 +
> drivers/scsi/qla2xxx/qla_gs.c     | 85 +++++++++++++++++++++----------
> drivers/scsi/qla2xxx/qla_init.c   | 70 +++++++++++++++++--------
> drivers/scsi/qla2xxx/qla_inline.h |  2 +
> drivers/scsi/qla2xxx/qla_iocb.c   | 41 +++++++++++----
> drivers/scsi/qla2xxx/qla_mbx.c    |  4 +-
> drivers/scsi/qla2xxx/qla_mid.c    |  4 +-
> drivers/scsi/qla2xxx/qla_mr.c     |  4 +-
> drivers/scsi/qla2xxx/qla_os.c     | 14 +++--
> drivers/scsi/qla2xxx/qla_target.c |  4 +-
> 13 files changed, 173 insertions(+), 70 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 9da8034ccad4..c2f00f076f79 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -29,7 +29,8 @@ void qla2x00_bsg_job_done(srb_t *sp, int res)
> 	    "%s: sp hdl %x, result=3D%x bsg ptr %p\n",
> 	    __func__, sp->handle, res, bsg_job);
>=20
> -	sp->free(sp);
> +	/* ref: INIT */

IMO, There is no need for this comment spread in this patch. Please explain=
 If you think there is need for comment.

> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
>=20
> 	bsg_reply->result =3D res;
> 	bsg_job_done(bsg_job, bsg_reply->result,
> @@ -3013,7 +3014,8 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
>=20
> done:
> 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 	return 0;
> }
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 9ebf4a234d9a..a5fc01b4fa96 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -726,6 +726,11 @@ typedef struct srb {
> 	 * code.
> 	 */
> 	void (*put_fn)(struct kref *kref);
> +
> +	/*
> +	 * Report completion for asynchronous commands.
> +	 */
> +	void (*async_done)(struct srb *sp, int res);
> } srb_t;
>=20
> #define GET_CMD_SP(sp) (sp->u.scmd.cmd)
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
> index 53d2b8562027..c04957c363d8 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -2146,7 +2146,8 @@ edif_doorbell_show(struct device *dev, struct devic=
e_attribute *attr,
>=20
> static void qla_noop_sp_done(srb_t *sp, int res)
> {
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> }
>=20
> /*
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gb=
l.h
> index 5056564f0d0c..3f8b8bbabe6d 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -333,6 +333,7 @@ extern int qla24xx_get_one_block_sg(uint32_t, struct =
qla2_sgx *, uint32_t *);
> extern int qla24xx_configure_prot_mode(srb_t *, uint16_t *);
> extern int qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha,
> 	struct qla_work_evt *e);
> +void qla2x00_sp_release(struct kref *kref);
>=20
> /*
>  * Global Function Prototypes in qla_mbx.c source file.
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.=
c
> index 744eb3192056..a812f4a45232 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -529,7 +529,6 @@ static void qla2x00_async_sns_sp_done(srb_t *sp, int =
rc)
> 		if (!e)
> 			goto err2;
>=20
> -		del_timer(&sp->u.iocb_cmd.timer);
> 		e->u.iosb.sp =3D sp;
> 		qla2x00_post_work(vha, e);
> 		return;
> @@ -556,8 +555,8 @@ static void qla2x00_async_sns_sp_done(srb_t *sp, int =
rc)
> 			sp->u.iocb_cmd.u.ctarg.rsp =3D NULL;
> 		}
>=20
> -		sp->free(sp);
> -
> +		/* ref: INIT */
> +		kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 		return;
> 	}
>=20
> @@ -592,6 +591,7 @@ static int qla_async_rftid(scsi_qla_host_t *vha, port=
_id_t *d_id)
> 	if (!vha->flags.online)
> 		goto done;
>=20
> +	/* ref: INIT */
> 	sp =3D qla2x00_get_sp(vha, NULL, GFP_KERNEL);
> 	if (!sp)
> 		goto done;
> @@ -652,7 +652,8 @@ static int qla_async_rftid(scsi_qla_host_t *vha, port=
_id_t *d_id)
> 	}
> 	return rval;
> done_free_sp:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> done:
> 	return rval;
> }
> @@ -687,6 +688,7 @@ static int qla_async_rffid(scsi_qla_host_t *vha, port=
_id_t *d_id,
> 	srb_t *sp;
> 	struct ct_sns_pkt *ct_sns;
>=20
> +	/* ref: INIT */
> 	sp =3D qla2x00_get_sp(vha, NULL, GFP_KERNEL);
> 	if (!sp)
> 		goto done;
> @@ -747,7 +749,8 @@ static int qla_async_rffid(scsi_qla_host_t *vha, port=
_id_t *d_id,
> 	return rval;
>=20
> done_free_sp:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> done:
> 	return rval;
> }
> @@ -777,6 +780,7 @@ static int qla_async_rnnid(scsi_qla_host_t *vha, port=
_id_t *d_id,
> 	srb_t *sp;
> 	struct ct_sns_pkt *ct_sns;
>=20
> +	/* ref: INIT */
> 	sp =3D qla2x00_get_sp(vha, NULL, GFP_KERNEL);
> 	if (!sp)
> 		goto done;
> @@ -836,7 +840,8 @@ static int qla_async_rnnid(scsi_qla_host_t *vha, port=
_id_t *d_id,
> 	return rval;
>=20
> done_free_sp:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> done:
> 	return rval;
> }
> @@ -882,6 +887,7 @@ static int qla_async_rsnn_nn(scsi_qla_host_t *vha)
> 	srb_t *sp;
> 	struct ct_sns_pkt *ct_sns;
>=20
> +	/* ref: INIT */
> 	sp =3D qla2x00_get_sp(vha, NULL, GFP_KERNEL);
> 	if (!sp)
> 		goto done;
> @@ -947,7 +953,8 @@ static int qla_async_rsnn_nn(scsi_qla_host_t *vha)
> 	return rval;
>=20
> done_free_sp:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> done:
> 	return rval;
> }
> @@ -2887,7 +2894,8 @@ static void qla24xx_async_gpsc_sp_done(srb_t *sp, i=
nt res)
> 	qla24xx_handle_gpsc_event(vha, &ea);
>=20
> done:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> }
>=20
> int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
> @@ -2899,6 +2907,7 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_por=
t_t *fcport)
> 	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
> 		return rval;
>=20
> +	/* ref: INIT */
> 	sp =3D qla2x00_get_sp(vha, fcport, GFP_KERNEL);
> 	if (!sp)
> 		goto done;
> @@ -2938,7 +2947,8 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_por=
t_t *fcport)
> 	return rval;
>=20
> done_free_sp:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> done:
> 	return rval;
> }
> @@ -2987,7 +2997,8 @@ void qla24xx_sp_unmap(scsi_qla_host_t *vha, srb_t *=
sp)
> 		break;
> 	}
>=20
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> }
>=20
> void qla24xx_handle_gpnid_event(scsi_qla_host_t *vha, struct event_arg *e=
a)
> @@ -3126,13 +3137,15 @@ static void qla2x00_async_gpnid_sp_done(srb_t *sp=
, int res)
> 	if (res) {
> 		if (res =3D=3D QLA_FUNCTION_TIMEOUT) {
> 			qla24xx_post_gpnid_work(sp->vha, &ea.id);
> -			sp->free(sp);
> +			/* ref: INIT */
> +			kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 			return;
> 		}
> 	} else if (sp->gen1) {
> 		/* There was another RSCN for this Nport ID */
> 		qla24xx_post_gpnid_work(sp->vha, &ea.id);
> -		sp->free(sp);
> +		/* ref: INIT */
> +		kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 		return;
> 	}
>=20
> @@ -3153,7 +3166,8 @@ static void qla2x00_async_gpnid_sp_done(srb_t *sp, =
int res)
> 				  sp->u.iocb_cmd.u.ctarg.rsp_dma);
> 		sp->u.iocb_cmd.u.ctarg.rsp =3D NULL;
>=20
> -		sp->free(sp);
> +		/* ref: INIT */
> +		kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 		return;
> 	}
>=20
> @@ -3173,6 +3187,7 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_=
id_t *id)
> 	if (!vha->flags.online)
> 		goto done;
>=20
> +	/* ref: INIT */
> 	sp =3D qla2x00_get_sp(vha, NULL, GFP_KERNEL);
> 	if (!sp)
> 		goto done;
> @@ -3189,7 +3204,8 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_=
id_t *id)
> 		if (tsp->u.iocb_cmd.u.ctarg.id.b24 =3D=3D id->b24) {
> 			tsp->gen1++;
> 			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
> -			sp->free(sp);
> +			/* ref: INIT */
> +			kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 			goto done;
> 		}
> 	}
> @@ -3259,8 +3275,8 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_=
id_t *id)
> 			sp->u.iocb_cmd.u.ctarg.rsp_dma);
> 		sp->u.iocb_cmd.u.ctarg.rsp =3D NULL;
> 	}
> -
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> done:
> 	return rval;
> }
> @@ -3315,7 +3331,8 @@ void qla24xx_async_gffid_sp_done(srb_t *sp, int res=
)
> 	ea.rc =3D res;
>=20
> 	qla24xx_handle_gffid_event(vha, &ea);
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> }
>=20
> /* Get FC4 Feature with Nport ID. */
> @@ -3328,6 +3345,7 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_po=
rt_t *fcport)
> 	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
> 		return rval;
>=20
> +	/* ref: INIT */
> 	sp =3D qla2x00_get_sp(vha, fcport, GFP_KERNEL);
> 	if (!sp)
> 		return rval;
> @@ -3366,7 +3384,8 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_po=
rt_t *fcport)
>=20
> 	return rval;
> done_free_sp:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 	fcport->flags &=3D ~FCF_ASYNC_SENT;
> 	return rval;
> }
> @@ -3753,7 +3772,6 @@ static void qla2x00_async_gpnft_gnnft_sp_done(srb_t=
 *sp, int res)
> 	    "Async done-%s res %x FC4Type %x\n",
> 	    sp->name, res, sp->gen2);
>=20
> -	del_timer(&sp->u.iocb_cmd.timer);
> 	sp->rc =3D res;
> 	if (res) {
> 		unsigned long flags;
> @@ -3921,8 +3939,8 @@ static int qla24xx_async_gnnft(scsi_qla_host_t *vha=
, struct srb *sp,
> 		    sp->u.iocb_cmd.u.ctarg.rsp_dma);
> 		sp->u.iocb_cmd.u.ctarg.rsp =3D NULL;
> 	}
> -
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
>=20
> 	spin_lock_irqsave(&vha->work_lock, flags);
> 	vha->scan.scan_flags &=3D ~SF_SCANNING;
> @@ -3974,9 +3992,12 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 f=
c4_type, srb_t *sp)
> 		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
> 		    "%s: Performing FCP Scan\n", __func__);
>=20
> -		if (sp)
> -			sp->free(sp); /* should not happen */
> +		if (sp) {
> +			/* ref: INIT */
> +			kref_put(&sp->cmd_kref, qla2x00_sp_release);
> +		}
>=20
> +		/* ref: INIT */
> 		sp =3D qla2x00_get_sp(vha, NULL, GFP_KERNEL);
> 		if (!sp) {
> 			spin_lock_irqsave(&vha->work_lock, flags);
> @@ -4021,6 +4042,7 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc=
4_type, srb_t *sp)
> 			    sp->u.iocb_cmd.u.ctarg.req,
> 			    sp->u.iocb_cmd.u.ctarg.req_dma);
> 			sp->u.iocb_cmd.u.ctarg.req =3D NULL;
> +			/* ref: INIT */
> 			qla2x00_rel_sp(sp);
> 			return rval;
> 		}
> @@ -4083,7 +4105,8 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc=
4_type, srb_t *sp)
> 		sp->u.iocb_cmd.u.ctarg.rsp =3D NULL;
> 	}
>=20
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
>=20
> 	spin_lock_irqsave(&vha->work_lock, flags);
> 	vha->scan.scan_flags &=3D ~SF_SCANNING;
> @@ -4147,7 +4170,8 @@ static void qla2x00_async_gnnid_sp_done(srb_t *sp, =
int res)
>=20
> 	qla24xx_handle_gnnid_event(vha, &ea);
>=20
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> }
>=20
> int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
> @@ -4160,6 +4184,7 @@ int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_po=
rt_t *fcport)
> 		return rval;
>=20
> 	qla2x00_set_fcport_disc_state(fcport, DSC_GNN_ID);
> +	/* ref: INIT */
> 	sp =3D qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
> 	if (!sp)
> 		goto done;
> @@ -4200,7 +4225,8 @@ int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_po=
rt_t *fcport)
> 	return rval;
>=20
> done_free_sp:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 	fcport->flags &=3D ~FCF_ASYNC_SENT;
> done:
> 	return rval;
> @@ -4274,7 +4300,8 @@ static void qla2x00_async_gfpnid_sp_done(srb_t *sp,=
 int res)
>=20
> 	qla24xx_handle_gfpnid_event(vha, &ea);
>=20
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> }
>=20
> int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_port_t *fcport)
> @@ -4286,6 +4313,7 @@ int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_p=
ort_t *fcport)
> 	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
> 		return rval;
>=20
> +	/* ref: INIT */
> 	sp =3D qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
> 	if (!sp)
> 		goto done;
> @@ -4326,7 +4354,8 @@ int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_p=
ort_t *fcport)
> 	return rval;
>=20
> done_free_sp:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> done:
> 	return rval;
> }
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index e6f13cb6fa28..38c11b75f644 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -51,6 +51,9 @@ qla2x00_sp_timeout(struct timer_list *t)
> 	WARN_ON(irqs_disabled());
> 	iocb =3D &sp->u.iocb_cmd;
> 	iocb->timeout(sp);
> +
> +	/* ref: TMR */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> }
>=20
> void qla2x00_sp_free(srb_t *sp)
> @@ -125,8 +128,13 @@ static void qla24xx_abort_iocb_timeout(void *data)
> 	}
> 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
>=20
> -	if (sp->cmd_sp)
> +	if (sp->cmd_sp) {
> +		/*
> +		 * This done function should take care of
> +		 * original command ref: INIT
> +		 */
> 		sp->cmd_sp->done(sp->cmd_sp, QLA_OS_TIMER_EXPIRED);
> +	}
>=20
> 	abt->u.abt.comp_status =3D cpu_to_le16(CS_TIMEOUT);
> 	sp->done(sp, QLA_OS_TIMER_EXPIRED);
> @@ -140,11 +148,11 @@ static void qla24xx_abort_sp_done(srb_t *sp, int re=
s)
> 	if (orig_sp)
> 		qla_wait_nvme_release_cmd_kref(orig_sp);
>=20
> -	del_timer(&sp->u.iocb_cmd.timer);
> 	if (sp->flags & SRB_WAKEUP_ON_COMP)
> 		complete(&abt->u.abt.comp);
> 	else
> -		sp->free(sp);
> +		/* ref: INIT */
> +		kref_put(&sp->cmd_kref, qla2x00_sp_release);
> }
>=20
> int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
> @@ -154,6 +162,7 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
> 	srb_t *sp;
> 	int rval =3D QLA_FUNCTION_FAILED;
>=20
> +	/* ref: INIT for ABTS command */
> 	sp =3D qla2xxx_get_qpair_sp(cmd_sp->vha, cmd_sp->qpair, cmd_sp->fcport,
> 				  GFP_ATOMIC);
> 	if (!sp)
> @@ -181,7 +190,8 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
>=20
> 	rval =3D qla2x00_start_sp(sp);
> 	if (rval !=3D QLA_SUCCESS) {
> -		sp->free(sp);
> +		/* ref: INIT */
> +		kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 		return rval;
> 	}
>=20
> @@ -189,7 +199,8 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
> 		wait_for_completion(&abt_iocb->u.abt.comp);
> 		rval =3D abt_iocb->u.abt.comp_status =3D=3D CS_COMPLETE ?
> 			QLA_SUCCESS : QLA_ERR_FROM_FW;
> -		sp->free(sp);
> +		/* ref: INIT */
> +		kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 	}
>=20
> 	return rval;
> @@ -287,7 +298,8 @@ static void qla2x00_async_login_sp_done(srb_t *sp, in=
t res)
> 		qla24xx_handle_plogi_done_event(vha, &ea);
> 	}
>=20
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> }
>=20
> int
> @@ -306,6 +318,7 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_por=
t_t *fcport,
> 		return rval;
> 	}
>=20
> +	/* ref: INIT */
> 	sp =3D qla2x00_get_sp(vha, fcport, GFP_KERNEL);
> 	if (!sp)
> 		goto done;
> @@ -354,7 +367,8 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_por=
t_t *fcport,
> 	return rval;
>=20
> done_free_sp:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 	fcport->flags &=3D ~FCF_ASYNC_SENT;
> done:
> 	fcport->flags &=3D ~FCF_ASYNC_ACTIVE;
> @@ -366,7 +380,8 @@ static void qla2x00_async_logout_sp_done(srb_t *sp, i=
nt res)
> 	sp->fcport->flags &=3D ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
> 	sp->fcport->login_gen++;
> 	qlt_logo_completion_handler(sp->fcport, sp->u.iocb_cmd.u.logio.data[0]);
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> }
>=20
> int
> @@ -376,6 +391,7 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_po=
rt_t *fcport)
> 	int rval =3D QLA_FUNCTION_FAILED;
>=20
> 	fcport->flags |=3D FCF_ASYNC_SENT;
> +	/* ref: INIT */
> 	sp =3D qla2x00_get_sp(vha, fcport, GFP_KERNEL);
> 	if (!sp)
> 		goto done;
> @@ -397,7 +413,8 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_po=
rt_t *fcport)
> 	return rval;
>=20
> done_free_sp:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> done:
> 	fcport->flags &=3D ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
> 	return rval;
> @@ -423,7 +440,8 @@ static void qla2x00_async_prlo_sp_done(srb_t *sp, int=
 res)
> 	if (!test_bit(UNLOADING, &vha->dpc_flags))
> 		qla2x00_post_async_prlo_done_work(sp->fcport->vha, sp->fcport,
> 		    lio->u.logio.data);
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> }
>=20
> int
> @@ -433,6 +451,7 @@ qla2x00_async_prlo(struct scsi_qla_host *vha, fc_port=
_t *fcport)
> 	int rval;
>=20
> 	rval =3D QLA_FUNCTION_FAILED;
> +	/* ref: INIT */
> 	sp =3D qla2x00_get_sp(vha, fcport, GFP_KERNEL);
> 	if (!sp)
> 		goto done;
> @@ -454,7 +473,8 @@ qla2x00_async_prlo(struct scsi_qla_host *vha, fc_port=
_t *fcport)
> 	return rval;
>=20
> done_free_sp:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> done:
> 	fcport->flags &=3D ~FCF_ASYNC_ACTIVE;
> 	return rval;
> @@ -539,8 +559,8 @@ static void qla2x00_async_adisc_sp_done(srb_t *sp, in=
t res)
> 	ea.sp =3D sp;
>=20
> 	qla24xx_handle_adisc_event(vha, &ea);
> -
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> }
>=20
> int
> @@ -555,6 +575,7 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_por=
t_t *fcport,
> 		return rval;
>=20
> 	fcport->flags |=3D FCF_ASYNC_SENT;
> +	/* ref: INIT */
> 	sp =3D qla2x00_get_sp(vha, fcport, GFP_KERNEL);
> 	if (!sp)
> 		goto done;
> @@ -582,7 +603,8 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_por=
t_t *fcport,
> 	return rval;
>=20
> done_free_sp:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> done:
> 	fcport->flags &=3D ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
> 	qla2x00_post_async_adisc_work(vha, fcport, data);
> @@ -1063,7 +1085,8 @@ static void qla24xx_async_gnl_sp_done(srb_t *sp, in=
t res)
> 	}
> 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
>=20
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> }
>=20
> int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
> @@ -1093,6 +1116,7 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc=
_port_t *fcport)
> 	vha->gnl.sent =3D 1;
> 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
>=20
> +	/* ref: INIT */
> 	sp =3D qla2x00_get_sp(vha, fcport, GFP_KERNEL);
> 	if (!sp)
> 		goto done;
> @@ -1125,7 +1149,8 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc=
_port_t *fcport)
> 	return rval;
>=20
> done_free_sp:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> done:
> 	fcport->flags &=3D ~(FCF_ASYNC_ACTIVE | FCF_ASYNC_SENT);
> 	return rval;
> @@ -1171,7 +1196,7 @@ static void qla24xx_async_gpdb_sp_done(srb_t *sp, i=
nt res)
> 	dma_pool_free(ha->s_dma_pool, sp->u.iocb_cmd.u.mbx.in,
> 		sp->u.iocb_cmd.u.mbx.in_dma);
>=20
> -	sp->free(sp);
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> }
>=20
> int qla24xx_post_prli_work(struct scsi_qla_host *vha, fc_port_t *fcport)
> @@ -1216,7 +1241,7 @@ static void qla2x00_async_prli_sp_done(srb_t *sp, i=
nt res)
> 		qla24xx_handle_prli_done_event(vha, &ea);
> 	}
>=20
> -	sp->free(sp);
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> }
>=20
> int
> @@ -1274,7 +1299,8 @@ qla24xx_async_prli(struct scsi_qla_host *vha, fc_po=
rt_t *fcport)
> 	return rval;
>=20
> done_free_sp:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 	fcport->flags &=3D ~FCF_ASYNC_SENT;
> 	return rval;
> }
> @@ -1359,7 +1385,7 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, f=
c_port_t *fcport, u8 opt)
> 	if (pd)
> 		dma_pool_free(ha->s_dma_pool, pd, pd_dma);
>=20
> -	sp->free(sp);
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 	fcport->flags &=3D ~FCF_ASYNC_SENT;
> done:
> 	fcport->flags &=3D ~FCF_ASYNC_ACTIVE;
> @@ -1945,6 +1971,7 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t fl=
ags, uint32_t lun,
> 	srb_t *sp;
> 	int rval =3D QLA_FUNCTION_FAILED;
>=20
> +	/* ref: INIT */
> 	sp =3D qla2x00_get_sp(vha, fcport, GFP_KERNEL);
> 	if (!sp)
> 		goto done;
> @@ -1988,7 +2015,8 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t fl=
ags, uint32_t lun,
> 	}
>=20
> done_free_sp:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 	fcport->flags &=3D ~FCF_ASYNC_SENT;
> done:
> 	return rval;
> diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla=
_inline.h
> index 5f3b7995cc8f..db17f7f410cd 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
> @@ -184,6 +184,8 @@ static void qla2xxx_init_sp(srb_t *sp, scsi_qla_host_=
t *vha,
> 	sp->vha =3D vha;
> 	sp->qpair =3D qpair;
> 	sp->cmd_type =3D TYPE_SRB;
> +	/* ref : INIT - normal flow */
> +	kref_init(&sp->cmd_kref);
> 	INIT_LIST_HEAD(&sp->elem);
> }
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index 95aae9a9631e..7dd82214d59f 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2560,6 +2560,14 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry *=
tsk)
> 	}
> }
>=20
> +void
> +qla2x00_sp_release(struct kref *kref)
> +{
> +	struct srb *sp =3D container_of(kref, struct srb, cmd_kref);
> +
> +	sp->free(sp);
> +}
> +
> void
> qla2x00_init_async_sp(srb_t *sp, unsigned long tmo,
> 		     void (*done)(struct srb *sp, int res))
> @@ -2655,7 +2663,9 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els=
_opcode,
> 	       return -ENOMEM;
> 	}
>=20
> -	/* Alloc SRB structure */
> +	/* Alloc SRB structure
> +	 * ref: INIT
> +	 */
> 	sp =3D qla2x00_get_sp(vha, fcport, GFP_KERNEL);
> 	if (!sp) {
> 		kfree(fcport);
> @@ -2687,7 +2697,8 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els=
_opcode,
> 			    GFP_KERNEL);
>=20
> 	if (!elsio->u.els_logo.els_logo_pyld) {
> -		sp->free(sp);
> +		/* ref: INIT */
> +		kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 		return QLA_FUNCTION_FAILED;
> 	}
>=20
> @@ -2710,7 +2721,8 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els=
_opcode,
>=20
> 	rval =3D qla2x00_start_sp(sp);
> 	if (rval !=3D QLA_SUCCESS) {
> -		sp->free(sp);
> +		/* ref: INIT */
> +		kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 		return QLA_FUNCTION_FAILED;
> 	}
>=20
> @@ -2721,7 +2733,8 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els=
_opcode,
>=20
> 	wait_for_completion(&elsio->u.els_logo.comp);
>=20
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 	return rval;
> }
>=20
> @@ -2854,7 +2867,6 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, in=
t res)
> 	    sp->name, res, sp->handle, fcport->d_id.b24, fcport->port_name);
>=20
> 	fcport->flags &=3D ~(FCF_ASYNC_SENT|FCF_ASYNC_ACTIVE);
> -	del_timer(&sp->u.iocb_cmd.timer);
>=20
> 	if (sp->flags & SRB_WAKEUP_ON_COMP)
> 		complete(&lio->u.els_plogi.comp);
> @@ -2964,7 +2976,8 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, in=
t res)
> 			struct srb_iocb *elsio =3D &sp->u.iocb_cmd;
>=20
> 			qla2x00_els_dcmd2_free(vha, &elsio->u.els_plogi);
> -			sp->free(sp);
> +			/* ref: INIT */
> +			kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 			return;
> 		}
> 		e->u.iosb.sp =3D sp;
> @@ -2982,7 +2995,9 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int el=
s_opcode,
> 	int rval =3D QLA_SUCCESS;
> 	void	*ptr, *resp_ptr;
>=20
> -	/* Alloc SRB structure */
> +	/* Alloc SRB structure
> +	 * ref: INIT
> +	 */
> 	sp =3D qla2x00_get_sp(vha, fcport, GFP_KERNEL);
> 	if (!sp) {
> 		ql_log(ql_log_info, vha, 0x70e6,
> @@ -3071,7 +3086,8 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int el=
s_opcode,
> out:
> 	fcport->flags &=3D ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
> 	qla2x00_els_dcmd2_free(vha, &elsio->u.els_plogi);
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> done:
> 	return rval;
> }
> @@ -3882,8 +3898,15 @@ qla2x00_start_sp(srb_t *sp)
> 		break;
> 	}
>=20
> -	if (sp->start_timer)
> +	if (sp->start_timer) {
> +		/* ref: TMR timer ref
> +		 * this code should be just before start_iocbs function
> +		 * This will make sure that caller function don't to do
> +		 * kref_put even on failure
> +		 */
> +		kref_get(&sp->cmd_kref);
> 		add_timer(&sp->u.iocb_cmd.timer);
> +	}
>=20
> 	wmb();
> 	qla2x00_start_iocbs(vha, qp->req);
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 2aacd3653245..38e0f02c75e1 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -6479,6 +6479,7 @@ int qla24xx_send_mb_cmd(struct scsi_qla_host *vha, =
mbx_cmd_t *mcp)
> 	if (!vha->hw->flags.fw_started)
> 		goto done;
>=20
> +	/* ref: INIT */
> 	sp =3D qla2x00_get_sp(vha, NULL, GFP_KERNEL);
> 	if (!sp)
> 		goto done;
> @@ -6524,7 +6525,8 @@ int qla24xx_send_mb_cmd(struct scsi_qla_host *vha, =
mbx_cmd_t *mcp)
> 	}
>=20
> done_free_sp:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> done:
> 	return rval;
> }
> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index c4a967c96fd6..e6b5c4ccce97 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -965,6 +965,7 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
> 	if (vp_index =3D=3D 0 || vp_index >=3D ha->max_npiv_vports)
> 		return QLA_PARAMETER_ERROR;
>=20
> +	/* ref: INIT */
> 	sp =3D qla2x00_get_sp(base_vha, NULL, GFP_KERNEL);
> 	if (!sp)
> 		return rval;
> @@ -1007,6 +1008,7 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cm=
d)
> 		break;
> 	}
> done:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 	return rval;
> }
> diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.=
c
> index e3ae0894c7a8..f726eb8449c5 100644
> --- a/drivers/scsi/qla2xxx/qla_mr.c
> +++ b/drivers/scsi/qla2xxx/qla_mr.c
> @@ -1787,6 +1787,7 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fc=
port, uint16_t fx_type)
> 	struct register_host_info *preg_hsi;
> 	struct new_utsname *p_sysid =3D NULL;
>=20
> +	/* ref: INIT */
> 	sp =3D qla2x00_get_sp(vha, fcport, GFP_KERNEL);
> 	if (!sp)
> 		goto done;
> @@ -1973,7 +1974,8 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fc=
port, uint16_t fx_type)
> 		dma_free_coherent(&ha->pdev->dev, fdisc->u.fxiocb.req_len,
> 		    fdisc->u.fxiocb.req_addr, fdisc->u.fxiocb.req_dma_handle);
> done_free_sp:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> done:
> 	return rval;
> }
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index abcd30917263..0a7b00d165c7 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -728,7 +728,8 @@ void qla2x00_sp_compl(srb_t *sp, int res)
> 	struct scsi_cmnd *cmd =3D GET_CMD_SP(sp);
> 	struct completion *comp =3D sp->comp;
>=20
> -	sp->free(sp);
> +	/* kref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 	cmd->result =3D res;
> 	CMD_SP(cmd) =3D NULL;
> 	scsi_done(cmd);
> @@ -819,7 +820,8 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
> 	struct scsi_cmnd *cmd =3D GET_CMD_SP(sp);
> 	struct completion *comp =3D sp->comp;
>=20
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 	cmd->result =3D res;
> 	CMD_SP(cmd) =3D NULL;
> 	scsi_done(cmd);
> @@ -919,6 +921,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct s=
csi_cmnd *cmd)
> 		goto qc24_target_busy;
>=20
> 	sp =3D scsi_cmd_priv(cmd);
> +	/* ref: INIT */
> 	qla2xxx_init_sp(sp, vha, vha->hw->base_qpair, fcport);
>=20
> 	sp->u.scmd.cmd =3D cmd;
> @@ -938,7 +941,8 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct s=
csi_cmnd *cmd)
> 	return 0;
>=20
> qc24_host_busy_free_sp:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
>=20
> qc24_target_busy:
> 	return SCSI_MLQUEUE_TARGET_BUSY;
> @@ -1008,6 +1012,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struc=
t scsi_cmnd *cmd,
> 		goto qc24_target_busy;
>=20
> 	sp =3D scsi_cmd_priv(cmd);
> +	/* ref: INIT */
> 	qla2xxx_init_sp(sp, vha, qpair, fcport);
>=20
> 	sp->u.scmd.cmd =3D cmd;
> @@ -1026,7 +1031,8 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struc=
t scsi_cmnd *cmd,
> 	return 0;
>=20
> qc24_host_busy_free_sp:
> -	sp->free(sp);
> +	/* ref: INIT */
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
>=20
> qc24_target_busy:
> 	return SCSI_MLQUEUE_TARGET_BUSY;
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> index 83c8c55017d1..b0990f2ee91c 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -620,7 +620,7 @@ static void qla2x00_async_nack_sp_done(srb_t *sp, int=
 res)
> 	}
> 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
>=20
> -	sp->free(sp);
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> }
>=20
> int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
> @@ -672,7 +672,7 @@ int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc=
_port_t *fcport,
> 	return rval;
>=20
> done_free_sp:
> -	sp->free(sp);
> +	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> done:
> 	fcport->flags &=3D ~FCF_ASYNC_SENT;
> 	return rval;
> --=20
> 2.23.1
>=20

--
Himanshu Madhani	 Oracle Linux Engineering

