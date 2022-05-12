Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78177C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 23:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359532AbiELXjG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 19:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347853AbiELXjE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 19:39:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6677C286FE7
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 16:39:03 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CKrc8S024475;
        Thu, 12 May 2022 23:38:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=bMvqbIEUuTQESeLuPZ/DWd+qwihKTrI4inWHE/+/KUg=;
 b=ZCw6ARWxocKCq+GWrdqT/Z1v0UlyzuXz59ZM+6Flbibg99aAefxkqA8/Vw1cHKtv/NU1
 Pf9JTXc67zOHwzoR0fwExfpxydUdABpwsoj1hjjFqVkKvWH7PkMqFX9AJGLFXQWQtEyy
 6NASpY5vBXWqZpOqlX/feL/HsyrUHMuY3rJtcbVj1G8NClWn/9f8jyexR+oF0uxqriRK
 Zm2UVCR2A4sd/w+fRj5Kg5025f+1GMPB0q0BbF59UZQGTsQnV0YLwfxpJyUVLiei3ktB
 HK0Y7BSDjgvXhKbjF+EqhMPqh1frLW5dtgHlGJzGeWvE7mCfWpHAi+YP6XdXHJhh8yqh RA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwfc0x4wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 23:38:48 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24CNZp3g019458;
        Thu, 12 May 2022 23:38:47 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fwf7cbxg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 23:38:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTKLUoWjOZL3EqrgEvhfIUf+NNMdjsV4MBxUoeAqWKteuR8WdV8ZPe1hCOKaFq8sk4dicYykx2cZdoJhH8kdUTQlwiydhp62yfZgeEmDGDj3/nNKoGZ2Ouyda/+cmxJ+yUvi4r0pi5ARv/cOz7DkBvWUb87jqXrM9cCxHDMYfbODyvK+T6UqGqVDePCqWibJETHHLNhLWS1dgWXzFulzTf5Z2XdjplT7c+Ruu7nZB+sxO7L72vL+Hp4GXqUxrekyU2VQBpDltOtY5f0QME17yE8lNWMzuU4nc4mFuiOyu9DCsdNnvGiLC7UCwQ+DSEo94EKy8ELXiFWsePSpFYUlwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMvqbIEUuTQESeLuPZ/DWd+qwihKTrI4inWHE/+/KUg=;
 b=ajmQ/mYQqSS0YBx+AnTSrweoujryI7m2uoA4aFaCQxrZZBT3aOG8uGH0vB0AvrnM7EhX26XgVG8HGWEclbxdrYTrPgdea5M0Mi2RknKrfnBB+j6P8vRv9G4g9HwLhC71gZxRv2BwZm08q2tbJlTiMjy4sFO/nv6Jd/NkUbIF4THAIRmx61zf9M23Vw3LwOjWyiXrsK+yrEu7y6vXk4Q3vARFX2B8PhkQjXqpUx9M3tFT2zvuwiDqknjkmfHYcE2I4BBbbrarA0HviVdbo0PrQivEOkhL0NCS0WijKNwI05RCo1AaXsBNnA9VMIgsA2Kih5bqIx44d+/rO9QX6ann7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMvqbIEUuTQESeLuPZ/DWd+qwihKTrI4inWHE/+/KUg=;
 b=I8IUyfz4dRu/MT6NSWEuIWvbLO5MUA5BkHnw0OLvv430xxzQGcQjRvb0Gv5NVT+Vczzuj7pSas3mNOYe0tlq5XDt+eOb+wOJhGQaQFrlJWN/0u6ZV3knRFeRbLqkGiUeFUdzdAAKC4shyaWZ/Sd8fbmOvziEAi3km+bA0j5p9Po=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MWHPR10MB1760.namprd10.prod.outlook.com (2603:10b6:301:a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Thu, 12 May
 2022 23:38:45 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478%3]) with mapi id 15.20.5250.014; Thu, 12 May 2022
 23:38:45 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     James Smart <jsmart2021@gmail.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: Re: [PATCH 1/4] nvme-fc: Add new routine nvme_fc_io_getuuid
Thread-Topic: [PATCH 1/4] nvme-fc: Add new routine nvme_fc_io_getuuid
Thread-Index: AQHYZKiskN+RsJqYk0aaPF5PRfNnkq0b6YQA
Date:   Thu, 12 May 2022 23:38:45 +0000
Message-ID: <F25608AE-7306-4751-BC5A-12984988341B@oracle.com>
References: <20220510200028.37399-1-jsmart2021@gmail.com>
 <20220510200028.37399-2-jsmart2021@gmail.com>
In-Reply-To: <20220510200028.37399-2-jsmart2021@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4bd868ac-a485-4bc0-426e-08da34708e43
x-ms-traffictypediagnostic: MWHPR10MB1760:EE_
x-microsoft-antispam-prvs: <MWHPR10MB176033C6B5EDA0BA98DFFBCBE6CB9@MWHPR10MB1760.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ml3O2h+jkrGW0CWXm6NUIh0Xh2xmsK5FVv8eXvjLqPvSMq1dY+IpStvGodr5XwnIwNCzWHOYlBFt84nyisgl20P8+c3+zdMYxKpXKk8c+k+vGHNbnX+b9Hi/JyjJ8WQsdqZae7s2HD0xFy2Eocn78+IejifNEWI8QSDlnwKVtPNCzPgh6t7yw+9EoNcc1LAMJ8jPLKQItjJsLv2SVihb2cIgZ0qt1tN/pesPsdwcXwWdq3V6cZYOo0beCYsCu4W7RDpbauAHAIkDW0Kw2FZryVJJm8A3GnEU9nsXp2wf4V6oi/wkKn6xf9QnOny8eweCVRGtUty9TzNv0eIXM8lfeR0ZG/tsBZozRykFt2mwtl4CS+xj2fuefa3WoOgd0bBHy5JnQ3DJfNE+2HCmJNs5myGBjsjr1dZqIzrxMfL3m0ssgG50Lv1RkU7Lc3dzRnqqnIIINr4SuPJteoI6cy/0RYqD3xDWX1RxAzgt7KjUA8Yjdf6msEny1qO9OaJ/SwjLkCMf2DYK3DfxWpiTxwkq8nfg8YaiiAi2qvBNlWBOT4lPUdoPDKM9HUBXNlgZ+1WSbOG8hR+MiONIApH2SmXNhp83wVHgfxbNIZAL0dQy0I3A1pbf79YsUazn3NaSxQnbG3kB0k4FdK5Z1CAgX01y5mhmWGtursTt4CgI68xMQy468nudEMF02xfn6sPtmY2z5vj6WAFOylVHhWVWH/Yt9P4ZNVGcraKA33mr8Y4WH9NL0X3C3umbM4kRnLSC3ORE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(316002)(508600001)(44832011)(8936002)(83380400001)(6486002)(26005)(33656002)(6512007)(2616005)(5660300002)(53546011)(38070700005)(38100700002)(86362001)(54906003)(66946007)(4326008)(6916009)(91956017)(71200400001)(64756008)(8676002)(66476007)(66446008)(36756003)(186003)(2906002)(66556008)(6506007)(76116006)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/mpMIcq3OFH2Q94AAlYC6ZqXeRgFPZUzd5bfa1gVtBqDXFvnoMwX9JXFPv90?=
 =?us-ascii?Q?NNCcxkmZ92bolWt76tqFzrTu7KYbatv+3IdB5TVYav598RiUb64mwVQ0dOyI?=
 =?us-ascii?Q?jOcfcEFjV2Y09IEjzb+9APK2SS2AXV2otF7n+uyCBIDyCTu5OqM48q/qo/Mu?=
 =?us-ascii?Q?KvBycSE+5vafDXRI8zqBGn0azxc1sGeKrWO9ZDJVJrr5H5dxTXFx61Ys0tuB?=
 =?us-ascii?Q?IN0WHPNtdhBqNuZBUeOfJJ+kdaCFk4Vrwq33ZhV96zDhOOhf0Qilw3G7KDRe?=
 =?us-ascii?Q?z5i82dOmTLLt5rarGyJ5EPs0i1Mn1kJ4bRFwGjSwN1zn0aE7gE5Sg1oVyZvM?=
 =?us-ascii?Q?FM2xN/F2zPVm9IY5Je1Tktm1o/v4BsdX7VVzbL0unE5BC6sjI2odZnpPJAPe?=
 =?us-ascii?Q?5Ra7khkW2ZoW6ZIK5QHdwq08VtZko4LVRtRB3SKxnYURXiX2lqB7jOhsKFqn?=
 =?us-ascii?Q?wj+II2lgKVMvoVEjGsfDayefBuipS3IXHQRl5lNLfXhC+C3BV8aKNgdkVEoU?=
 =?us-ascii?Q?9ncw/5PP5TKfyptoL41PkcmxkJBLlH0C4iXEGYXSNxOO7oHb+qbsZGIRYVFy?=
 =?us-ascii?Q?ndOEblbGXcNfToS9kkdkYxA9q47nGwGKkhhaHsSzay1cTR67yh6e/VGjqwfi?=
 =?us-ascii?Q?hNYtQyAPP7lhqTlLhQLKWs+hkXVIXg9w0Ao24XyEPVeykXEiKCLVpaAH2Q2j?=
 =?us-ascii?Q?nwl5COyFgdfNcfbIcoUFYGd8jG/xIvg1ucF/ul7iAR8/iXadA8IuP/Bw3c8o?=
 =?us-ascii?Q?D9CoelvcZQWiFwnxSpGso9UJEACffazsPmSOHspi+RqkC4+5GAKGtdF1y2br?=
 =?us-ascii?Q?V0+EKvnoVfVjoROx9n9ReH27JGaVNmCYL1+ijrv1UOOBQzbFJ3Z4NgCq9mRw?=
 =?us-ascii?Q?kx36zw19o8XCJo7YNwckBVUlLhlJfw+ef3I7C6JOVcJsRk66VoK1CmJSkVAG?=
 =?us-ascii?Q?ReKLVLJ3ABFaND9LrzTPaN1sYN1Q4KYjd3TMhKhlU4nwpuyN98J0bs602Eh0?=
 =?us-ascii?Q?mMSReJ27vTfZ5GjRxE7SYF9qZe//TQ7lwijM0NcDUGP67JIYuUHlxI0NBj95?=
 =?us-ascii?Q?7e8E0MxVnAfIEApM1kpZnAQAI7hJJTX1NK2D6BxS0BRgD04vqjAG0v9wKAOz?=
 =?us-ascii?Q?aaNEzOcHAnp1kxmgE95Lo61RRsiCLtc5shIBnXFzO+Qy7p9TOUalDBX4EeKl?=
 =?us-ascii?Q?6QouAb37jWZmZL5uC7noN+dZKFVeeypFfGeK9HDoApUSPK5MWsw9H8X6mBDa?=
 =?us-ascii?Q?b3CfMJKfk4rxe2PPGehGv6VAyDb9F8aLGV7Pjp8OWUsfbqR63udhu7RfgiBS?=
 =?us-ascii?Q?htdHUeJjxnfnFSxhDm/J+6n5Qm+tVOu5KJOy5sdhg3voaJGTszvW/Btz2MLz?=
 =?us-ascii?Q?ZabYPTD3WzmCWTx2kCG9XAmSp8Msm4ZGG+42KlrXb1Y0L0uvIca5uwb7vUub?=
 =?us-ascii?Q?LlFQ2lBn1yTwUgaghuYfHavV1FMTcR2RbgjBhw0wKsUFwZER3QRWOXSo/poV?=
 =?us-ascii?Q?jrEUBxynMNN0IArs2XHQNpQC/hPzwGrQJNy6VMpXVkI1pwpwJiH4Bb/vRQvD?=
 =?us-ascii?Q?konQGrg0ybRCeGT9n/PhcKQxga4E3yO1CKuJPDhIzMKB5QHdspRjCkSR3zQG?=
 =?us-ascii?Q?xQZBmHj60OAedRPERRIBeGS3X5t+HXRBaGKJT+WRCRDXOopvD+LSKg0fd+lk?=
 =?us-ascii?Q?DW6fh2GnEm9MGzSRH8RLmyWywxkZ7tqRTgz8g/9mKM2qxWMCAsLIo6nNCSRL?=
 =?us-ascii?Q?lxsVIKD0Q2JFhzAWypcWpuAyqAl3+S71EnejlHc2GKqyamsPZBit?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A6BCD15F277B6445ABF228A4B88ACC02@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bd868ac-a485-4bc0-426e-08da34708e43
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2022 23:38:45.3631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nvHd9Bva4fzFZijITD0mu/c5X4iEJWNJMiCz1LSOir6eAXzO+AuW/5I5w82ACCKK+1KHwTLNZDNU/n/B34GZRo/qDMrMLgP0jecbwr34a40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1760
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-12_15:2022-05-12,2022-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120101
X-Proofpoint-ORIG-GUID: iJYaDnwfugU5eNa_gE8sTvLuKU3zzxgw
X-Proofpoint-GUID: iJYaDnwfugU5eNa_gE8sTvLuKU3zzxgw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On May 10, 2022, at 1:00 PM, James Smart <jsmart2021@gmail.com> wrote:
>=20
> From: Muneendra <muneendra.kumar@broadcom.com>
>=20
> Add nvme_fc_io_getuuid() to the nvme-fc transport.
> The routine is invoked by the fc LLDD on a per-io request basis.
> The routine translates from the fc-specific request structure to
> the bio and the cgroup structure in order to obtain the fc appid
> stored in the cgroup structure. If a value is not set or a bio
> is not found, a NULL appid (aka uuid) will be returned to the LLDD.
>=20
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
> drivers/nvme/host/fc.c         | 16 ++++++++++++++++
> include/linux/nvme-fc-driver.h | 14 ++++++++++++++
> 2 files changed, 30 insertions(+)
>=20
> diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
> index 080f85f4105f..a484fe228cd5 100644
> --- a/drivers/nvme/host/fc.c
> +++ b/drivers/nvme/host/fc.c
> @@ -1899,6 +1899,22 @@ nvme_fc_ctrl_ioerr_work(struct work_struct *work)
> 	nvme_fc_error_recovery(ctrl, "transport detected io error");
> }
>=20
> +/*
> + * nvme_fc_io_getuuid - Routine called to get the appid field
> + * associated with request by the lldd
> + * @req:IO request from nvme fc to driver
> + * Returns: UUID if there is an appid associated with VM or
> + * NULL if the user/libvirt has not set the appid to VM
> + */
> +char *nvme_fc_io_getuuid(struct nvmefc_fcp_req *req)
> +{
> +	struct nvme_fc_fcp_op *op =3D fcp_req_to_fcp_op(req);
> +	struct request *rq =3D op->rq;
> +
> +	return rq->bio ? blkcg_get_fc_appid(rq->bio) : NULL;
> +}
> +EXPORT_SYMBOL_GPL(nvme_fc_io_getuuid);
> +
> static void
> nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
> {
> diff --git a/include/linux/nvme-fc-driver.h b/include/linux/nvme-fc-drive=
r.h
> index 5358a5facdee..fa092b9be2fd 100644
> --- a/include/linux/nvme-fc-driver.h
> +++ b/include/linux/nvme-fc-driver.h
> @@ -564,6 +564,15 @@ int nvme_fc_rcv_ls_req(struct nvme_fc_remote_port *r=
emoteport,
> 			void *lsreqbuf, u32 lsreqbuf_len);
>=20
>=20
> +/*
> + * Routine called to get the appid field associated with request by the =
lldd
> + *
> + * If the return value is NULL : the user/libvirt has not set the appid =
to VM
> + * If the return value is non-zero: Returns the appid associated with VM
> + *
> + * @req: IO request from nvme fc to driver
> + */
> +char *nvme_fc_io_getuuid(struct nvmefc_fcp_req *req);
>=20
> /*
>  * ***************  LLDD FC-NVME Target/Subsystem API ***************
> @@ -1048,5 +1057,10 @@ int nvmet_fc_rcv_fcp_req(struct nvmet_fc_target_po=
rt *tgtport,
>=20
> void nvmet_fc_rcv_fcp_abort(struct nvmet_fc_target_port *tgtport,
> 			struct nvmefc_tgt_fcp_req *fcpreq);
> +/*
> + * add a define, visible to the compiler, that indicates support
> + * for feature. Allows for conditional compilation in LLDDs.
> + */
> +#define NVME_FC_FEAT_UUID	0x0001
>=20
> #endif /* _NVME_FC_DRIVER_H */
> --=20
> 2.26.2
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

