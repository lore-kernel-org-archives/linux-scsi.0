Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44359C0502C
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Aug 2022 16:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiH2QPc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Aug 2022 12:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiH2QPb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Aug 2022 12:15:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B963AB0D
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2022 09:15:29 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TEewah014994;
        Mon, 29 Aug 2022 16:15:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ctSaIVOvEUGziV/u0pFtQXLIcGNFukEsZXkcNorrIOY=;
 b=o/CPKAgP5hW92QBF3/ofVUcShQPKOABYU9xp7ZFU94d1D3agL1IPetgV2ualCjedJqxb
 XxbgVjs9wVKevslr5WgArYazmvVbrKykI3q2OiwdTLOAgcBE82NcwyJPUxq9q6/bZkAB
 TKvnroXbPY8bHmn4x0rl66lYq/A9U9z3OPZqNAx5CMlusde4cVpOIkCJ0awaFdYcWKhi
 SjecW653dgtUWkIQAfQEXXeAML2q19DMXf8e1Ia+yUrI2ewbzM6SGRnGZFIjj0fGLK88
 eFr7bVxub5jlQU0nqKdIrlRdkBjunuCLGrFHA6asAiNtNo1m+KGdV2e7m0csZAp+P7Px cg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j79v0kw7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 16:15:27 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27TEGYTG005246;
        Mon, 29 Aug 2022 16:15:27 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q2k5jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 16:15:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NvB4ItAzzUkRUdWITnyU2AIuKXXOvsg5/T+U2UEuonju7kbPesyuE7Gn5SRtHNVgSZy6xApj2yb9vxuq4bSchU0wmkmhEWRXS+EVCUZQU8zxB+VhKXH0Z6SYMqJxRAcjFccLBkOa6QLMXthJfN//UfzzhQo6P5zXoTNS3x7fR40DDNhaTUy/mkhkix+9T8EMlLiEwoVbGaYTwzcqye/aq8taslFAyVYsgJDVR3B0pPAM5mL6FNSauCzskTrZAxi1ipUGWwZRuGStAGQzpbORd/jklzgU4PX6KTM6nMpdeJWFd4VUMhVMaRTC5Ej8tDbwkFSvAlw7KPtyTVrX2WY0dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ctSaIVOvEUGziV/u0pFtQXLIcGNFukEsZXkcNorrIOY=;
 b=IGtq0JIc/mH88Hxb28fDBVQZxNO6en7S4jhiZ91d2pRHgZutwmPexnM+5pGzrY+mfHqfrE0sVCIxeRBhhh+D/dFvvRrLER9W03DTN1lw5a2SA2Ew1DlORPN5bqKS/Tx4r4mExqaDFNzXWm+4Ek3VXUefnO1SgnvxsTNF1AXmE/uxBwXQQioSQyGuwxrZ0LVQf/cVznhMdAxD/cA47QZiLqPSEfq7QD2vpTUNIJKPSjes6gc3973Glk8WNqjW8J4siQERL0waFK+qrwp3L+bIe3KNjETU17NmPlYACNgPFlcxcI2EcEQyFL7tJn31E4Ileoo7Yw/WEX77HQNrx+0ICg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctSaIVOvEUGziV/u0pFtQXLIcGNFukEsZXkcNorrIOY=;
 b=LFcaD5eqgxID9S2wV+hfWbSuBmMrT0OanqrgE2rFMJq0vGMGgTeXK5MgiQCpfGV49qwoumI5XMjaKN6IFWs7f9b2lCRZg/hImCn8VptgH/ifHubf9bQ5jrcTaWf3hXgfa4+2zmARtIDxQilWgKbvvalo2Z+QbYDxjk4/1LoHpLA=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MWHPR10MB1280.namprd10.prod.outlook.com (2603:10b6:301:8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 16:15:24 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa%3]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 16:15:24 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>
Subject: Re: [PATCH v2 4/7] qla2xxx: Add NVMe parameters support in Auxiliary
 Image Status
Thread-Topic: [PATCH v2 4/7] qla2xxx: Add NVMe parameters support in Auxiliary
 Image Status
Thread-Index: AQHYuTZTGty96Vdlw0yRwfuQ2TEINq3GEqkA
Date:   Mon, 29 Aug 2022 16:15:24 +0000
Message-ID: <796B5776-1F99-42C7-ACE3-4AF1AB12B7D0@oracle.com>
References: <20220826102559.17474-1-njavali@marvell.com>
 <20220826102559.17474-5-njavali@marvell.com>
In-Reply-To: <20220826102559.17474-5-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7784f2be-ee60-4955-9d24-08da89d9ae0a
x-ms-traffictypediagnostic: MWHPR10MB1280:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9BuWG04FOvP4YJSOVybTRWI3ua9hJ5bi9c0Tt4vIaBOR1uvkk9FbN/EsBL4YBmBkXhs11BvhfWmwRk20SzC/V956JYuMOENoc/+beqARrWoup7AC1yRILzn7WPMz8Pq1bbrpPWchUQY3IkpHGkVW/tq51f/oCpIg7b7hp8LswTR7ziMraQSG0TE6VZxd3uDJjNmkJwt+yKoPviQxCY6vyHAfOktGtgk9BYivUYTvdGwOhXR4CA4jN6fU39pX7ZCJALvq8E3Fl784/JthvC0L+6zlWD9wN0CxS5uzieRtGCq2fdGteud+7LxKVzfn0kn0hIxNSHoZE+P+xJZRLPodY750rKIZbE/GF7uizPl/WnP3Hp/wEjkOIK4xv7QbnNJkvMaXjktYRUd0ck2PHrFSU1hLKOLy1x3sadv7Vd88xbrpJNVpmNEwCvlSYZKSEE8PskMfeuo+hysjC1hp382uBGNi7v/ywoIa9SSv3SPpSTY0Ta99I2NXQq306NYxeM2qCQS6ozL6RqY5BVUNScsdziVAgIWs8D7vmOjzZZ+99MXoEw+GA/sNWu910hMBk3Dh3lrJ/zaOHXxZAf4FWLt0+8nOdCiBlKlm8eqxiGwGUbmWBgS6u3lIWfnX4tOsPBmrSEkQzAUfmTYutshDH14w58zaRgawcDQP3YElqsH19UJGGXCwU/PaAsvWOuIRhhnCTMLd8gy0CPW+OgcXCEjsmOX5kYRcUxi7OqpFviZf0bXZLymxHlybl3j539HuPskATJkqftmGPddCsOWI/QmNdhheEb5s4XzYSVIRfVZ7hLg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(366004)(39860400002)(376002)(396003)(122000001)(38070700005)(86362001)(6486002)(66476007)(66446008)(8676002)(4326008)(66556008)(66946007)(64756008)(41300700001)(8936002)(5660300002)(478600001)(38100700002)(91956017)(76116006)(54906003)(71200400001)(316002)(6916009)(186003)(2616005)(6512007)(2906002)(53546011)(6506007)(44832011)(83380400001)(36756003)(33656002)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8s5YNwrlZXcOqbUyemotTF2PfsuKcYBFJGBXpgSOT+aBYVWjEGEmxyaVEUya?=
 =?us-ascii?Q?x8PByVoarwXldQS0Ls4qIcuFbXpfaPx6dEI+dhypB4MFVR4RRv6z+3b+1cSI?=
 =?us-ascii?Q?5N8LTE/HWpKpQ/zUIT5uacxbL6UtzbOcFAM2ez25w/HsPPelqcbvtkeDiIkw?=
 =?us-ascii?Q?ojaglNHHd4G0iMXSllFLKldQjeWw+wSS60yFPkG8NLPLZCpdMmji8MFDsUkS?=
 =?us-ascii?Q?GE4zdxOANtBR9WLiWDyVGWWnwFYLxfUY5BORxZjGB80UyM5Gy9V7ZomKsWCW?=
 =?us-ascii?Q?tNOagqpoF7hW6BG39BQkAi9wu8T5Hn/ZTy8GCi+2pyu4O+q/pa64hcuYuo1N?=
 =?us-ascii?Q?Mz3tmEgvPtnTuMXHoUDcLZpcP8La5a7YjBFXCrKTWz19SYyx9ATTOXpY6ho0?=
 =?us-ascii?Q?8T8GDHlkva6LjmwdfH5AmbCkdx/3UG6O592BKqVtPaEcMkxaqz8IeH4rorm2?=
 =?us-ascii?Q?lWuD+soSv79PGTTNMx9KX3/OQlQyIeCPqkE2MjDtm+S4St2kkWALHmoKvZiu?=
 =?us-ascii?Q?tYNuH6YGr9Ya/n0HcSWkDfztdhS7jPCfckx6qyWe59joi0hf9BoMUvrf0d+E?=
 =?us-ascii?Q?SXcD/ATFu5uXu/jTCmOJerwOWWBChxlWNCz/7htTPLZ0FJ7kHvgwKFiMo7Gb?=
 =?us-ascii?Q?JETNWaZjAqV9SuurAzFHgn17a7MG6+ImWwE0R1pLrFSpH+MqgM5hilMdVOve?=
 =?us-ascii?Q?WhdspqLQQ2s32K2mluFez3UMuVA6wwiPRyzR8fS+zlBntjuE2XxbDlQVM68n?=
 =?us-ascii?Q?lfaMjYqy3LMkvSbHUzvpl3HwUhbdJbBNVMWisOzg9c4Q4Dfg89laUbKUexsh?=
 =?us-ascii?Q?RWkdNdIkuqyEGu7Xyj6jgedUeICdQdiJ5NpXETGdBOF8xMr0Gpg70DqNGscU?=
 =?us-ascii?Q?6HlW5Ae7ECEc022PNQ1V7LhNjXIL+9tJiDA4riV3qoiVNjFl+Vy4PSQiaJCY?=
 =?us-ascii?Q?VZj6r6wjOGQ7DbeyTqOZyBF6sV/epf/7Ppg8UFiA0XVYT3XUGxzguTiVhcGD?=
 =?us-ascii?Q?lnEB/+uCaz5dOtE0yef+Th2Zsn4pzwmeaYP1JofeQcUMOOWmKBOlS0QG36iS?=
 =?us-ascii?Q?1IS1kfhjkwxra0oH6U48cwjefmepWAeyrQJrvwdahWiQvn7dveuCvDasuSVv?=
 =?us-ascii?Q?e34PfkpNMopOqBW4ffqyp0w1zyZnGQ96jVHQ+HeFP/sjDjBIU1fiWSuNKa3P?=
 =?us-ascii?Q?8SI96OvUEzdHzqIolV0aJDDGNwoYrtPZgtT+GNF3CUwtyHcPUIrjtmLXshsP?=
 =?us-ascii?Q?PoNhrWYtXqcWwEoXVXCXOGrIUgvEl8HWI5fBJUxDx9QXk3VPcIKAA7lIuDEa?=
 =?us-ascii?Q?1gp4aljIUDqVV5i+VLUZaN/0oYAljM+mIPWYL8/wcm/ecIJ33J2ZWWZR1l9p?=
 =?us-ascii?Q?nQAkgZJ2oyJF9T3bBrt0bytP7RBpEbDir/sSkdwWzQJw85mtkew+vhIYiOb6?=
 =?us-ascii?Q?fxb1nlPPS0YvhtyMEAy9B9QKsYwj7ZksQvgHqzVcT6uTzV8WoSNbB4YAKLHE?=
 =?us-ascii?Q?m8iRgfYDtH6zEb3BCZ05usrJ0mv/uDggHBkG24meE21Jon8khm3mLc5cWzR/?=
 =?us-ascii?Q?TitH4sd4fl250X5YJpZx9gPDcD2jH2tq8pJwEQT9iojy2MFtMkDUqvb8pEZt?=
 =?us-ascii?Q?Jg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E85313E2E02B184C9378A44E950C35A1@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7784f2be-ee60-4955-9d24-08da89d9ae0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 16:15:24.7029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CpubnVBWt7BG0yS18Wo/zM/zFlTKPhPTbBJlPo/pOnl7OhtDNdLuPJyfQpVWp1/ySMHMgTBU7dYIbhKs0YiOX8mk7XUePdzFp3ZljBoN9A0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1280
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-29_07,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208290075
X-Proofpoint-GUID: 8k5gGpIzeNWFs1FA5D5idxZSEuY8iM5V
X-Proofpoint-ORIG-GUID: 8k5gGpIzeNWFs1FA5D5idxZSEuY8iM5V
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 26, 2022, at 3:25 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Anil Gurumurthy <agurumurthy@marvell.com>
>=20
> Add new API to obtain the NVMe Parameters region status from the
> Auxiliary Image Status bitmap.
>=20
> Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_bsg.c  | 8 ++++++--
> drivers/scsi/qla2xxx/qla_bsg.h  | 3 ++-
> drivers/scsi/qla2xxx/qla_def.h  | 2 ++
> drivers/scsi/qla2xxx/qla_fw.h   | 3 +++
> drivers/scsi/qla2xxx/qla_init.c | 8 ++++++--
> 5 files changed, 19 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 5db9bf69dcff..cd75b179410d 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2519,19 +2519,23 @@ qla2x00_get_flash_image_status(struct bsg_job *bs=
g_job)
> 	qla27xx_get_active_image(vha, &active_regions);
> 	regions.global_image =3D active_regions.global;
>=20
> +	if (IS_QLA27XX(ha))
> +		regions.nvme_params =3D QLA27XX_PRIMARY_IMAGE;
> +
> 	if (IS_QLA28XX(ha)) {
> 		qla28xx_get_aux_images(vha, &active_regions);
> 		regions.board_config =3D active_regions.aux.board_config;
> 		regions.vpd_nvram =3D active_regions.aux.vpd_nvram;
> 		regions.npiv_config_0_1 =3D active_regions.aux.npiv_config_0_1;
> 		regions.npiv_config_2_3 =3D active_regions.aux.npiv_config_2_3;
> +		regions.nvme_params =3D active_regions.aux.nvme_params;
> 	}
>=20
> 	ql_dbg(ql_dbg_user, vha, 0x70e1,
> -	    "%s(%lu): FW=3D%u BCFG=3D%u VPDNVR=3D%u NPIV01=3D%u NPIV02=3D%u\n",
> +	    "%s(%lu): FW=3D%u BCFG=3D%u VPDNVR=3D%u NPIV01=3D%u NPIV02=3D%u NVM=
E_PARAMS=3D%u\n",
> 	    __func__, vha->host_no, regions.global_image,
> 	    regions.board_config, regions.vpd_nvram,
> -	    regions.npiv_config_0_1, regions.npiv_config_2_3);
> +	    regions.npiv_config_0_1, regions.npiv_config_2_3, regions.nvme_para=
ms);
>=20
> 	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> 	    bsg_job->reply_payload.sg_cnt, &regions, sizeof(regions));
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bs=
g.h
> index bb64b9c5a74b..d38dab0a07e8 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.h
> +++ b/drivers/scsi/qla2xxx/qla_bsg.h
> @@ -314,7 +314,8 @@ struct qla_active_regions {
> 	uint8_t vpd_nvram;
> 	uint8_t npiv_config_0_1;
> 	uint8_t npiv_config_2_3;
> -	uint8_t reserved[32];
> +	uint8_t nvme_params;
> +	uint8_t reserved[31];
> } __packed;
>=20
> #include "qla_edif_bsg.h"
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 22274b405d01..802eec6407d9 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -4773,6 +4773,7 @@ struct active_regions {
> 		uint8_t vpd_nvram;
> 		uint8_t npiv_config_0_1;
> 		uint8_t npiv_config_2_3;
> +		uint8_t nvme_params;
> 	} aux;
> };
>=20
> @@ -5057,6 +5058,7 @@ struct qla27xx_image_status {
> #define QLA28XX_AUX_IMG_VPD_NVRAM		BIT_1
> #define QLA28XX_AUX_IMG_NPIV_CONFIG_0_1		BIT_2
> #define QLA28XX_AUX_IMG_NPIV_CONFIG_2_3		BIT_3
> +#define QLA28XX_AUX_IMG_NVME_PARAMS		BIT_4
>=20
> #define SET_VP_IDX	1
> #define SET_AL_PA	2
> diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.=
h
> index 361015b5763e..f307beed9d29 100644
> --- a/drivers/scsi/qla2xxx/qla_fw.h
> +++ b/drivers/scsi/qla2xxx/qla_fw.h
> @@ -1675,6 +1675,7 @@ struct qla_flt_location {
> #define FLT_REG_VPD_SEC_27XX_1	0x52
> #define FLT_REG_VPD_SEC_27XX_2	0xD8
> #define FLT_REG_VPD_SEC_27XX_3	0xDA
> +#define FLT_REG_NVME_PARAMS_27XX	0x21
>=20
> /* 28xx */
> #define FLT_REG_AUX_IMG_PRI_28XX	0x125
> @@ -1691,6 +1692,8 @@ struct qla_flt_location {
> #define FLT_REG_MPI_SEC_28XX		0xF0
> #define FLT_REG_PEP_PRI_28XX		0xD1
> #define FLT_REG_PEP_SEC_28XX		0xF1
> +#define FLT_REG_NVME_PARAMS_PRI_28XX	0x14E
> +#define FLT_REG_NVME_PARAMS_SEC_28XX	0x179
>=20
> struct qla_flt_region {
> 	__le16	code;
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index e7fe0e52c11d..e12db95de688 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -7933,6 +7933,9 @@ qla28xx_component_status(
>=20
> 	active_regions->aux.npiv_config_2_3 =3D
> 	    qla28xx_component_bitmask(aux, QLA28XX_AUX_IMG_NPIV_CONFIG_2_3);
> +
> +	active_regions->aux.nvme_params =3D
> +	    qla28xx_component_bitmask(aux, QLA28XX_AUX_IMG_NVME_PARAMS);
> }
>=20
> static int
> @@ -8041,11 +8044,12 @@ qla28xx_get_aux_images(
> 	}
>=20
> 	ql_dbg(ql_dbg_init, vha, 0x018f,
> -	    "aux images active: BCFG=3D%u VPD/NVR=3D%u NPIV0/1=3D%u NPIV2/3=3D%=
u\n",
> +	    "aux images active: BCFG=3D%u VPD/NVR=3D%u NPIV0/1=3D%u NPIV2/3=3D%=
u, NVME=3D%u\n",
> 	    active_regions->aux.board_config,
> 	    active_regions->aux.vpd_nvram,
> 	    active_regions->aux.npiv_config_0_1,
> -	    active_regions->aux.npiv_config_2_3);
> +	    active_regions->aux.npiv_config_2_3,
> +	    active_regions->aux.nvme_params);
> }
>=20
> void
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

