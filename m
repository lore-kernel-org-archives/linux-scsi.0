Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB25ECAAD2
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Aug 2022 16:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiH2QLG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Aug 2022 12:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiH2QLE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Aug 2022 12:11:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3704F72FC9
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2022 09:11:02 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TE97Yv026728;
        Mon, 29 Aug 2022 16:11:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=SY1n3yize98xu9XUJJL85yRqdQv6ItpGHwrPNwcwpbk=;
 b=BK6iPBNUFnJ9/hl0tNu3MKvyahQ0hoRfgBcb+ozl4MI4IH5Gbb6zhKE1lxtPnwv/p5sS
 pihZEsfAJRnGHyYNaL+M3cM81oHfpOXr8Fsojbzq1gTp1vkwIMGZlvHj20iLIGRmzC8m
 iFOKEfPiNIfAJzXDzYqdXFUwKwoqk7crPQJqTDXN6ZejTFOw/2DdCB18Bp/8l0uKhr4O
 mFgnUcvP6r8PX0FCFuhymrOqNc9KCqjj2yxt4SrQ2QKxXL/ufTIZO4ke3yY69G9JpSHu
 PV8+21kdYSqNYlukMKXsV8vxiqXyVlmpxvbyhtfc/2klOAFSrMpHupW4SQkSMwI47+Zc VQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7btt3u63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 16:10:59 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27TF1tuV022051;
        Mon, 29 Aug 2022 16:10:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q2jv4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 16:10:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BiE3sW6lRR1bHH+uo+NBa+UDROovF6wigXz0LmKFp2vbRony6NIU6p4HwNJSur+urFL7STRZJjKSWQLkdh3qrLRo5ydapdmHV1NPQRFGnC0tiCamkfchVMQB2BpIJjRzTWupjbpUEp/bg5FZPUqoIkFwt9jzQAiG9+2xG0nWP60PTsgqG45gVPliLTICMIadLgLEWnYXRuf8UZO/upCg/3Q+Z895Uv0b67MZK2RfmaoCht+0b3P+Z/kylSTOgMpbTNUzaCBU3tIwM3HQb4AM93UXAPhsfUjIfwC3kdR3jGdN+xEEYs3Acut4uQ44gR4ybJglahaR4ffHoAGKCHn6kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SY1n3yize98xu9XUJJL85yRqdQv6ItpGHwrPNwcwpbk=;
 b=G4p86KSg5lO0Apoji6JsmTIsvPpK/toGyvpqNevj1N3uDix4Q0AEV+2gMMOAnsMJmZc+Y2IwRfKHo/3E/ZnZYR4H/nNUPbQYCgP9UfANidmLsKmtnPEUh3K9OrvkB90JQRncKIXL6R0MHS8uNwJ9NwUfMODtD79xKULL25QGEBMaSLhDTrmyRnuYhj90fCabrQKvoQhH4MNpB3D6IQlb5QsB2SE5OX1nzaOHHJKaPAiTZle8HlmmMokSrDXIQlL4UZfWLb+QU+wr9IDhl2TOvlsHgiIThRpLT70MBTa8PeWd8/OdNLPcsaHfQuoyl4QxML9eO9FQS6FnTWNt19x86A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SY1n3yize98xu9XUJJL85yRqdQv6ItpGHwrPNwcwpbk=;
 b=vMSIr/IXFBhfAD4QKVCQHlpc/D9OXzSVGKtmoRL1nUot3fZJd6vgrMvO+PH/578XoxzBG+vlQpFVpZhHI8JYcp/Kw7ZDw+m0o+im1oPPv2CcXdmzq8BNuWzaF8+RF83rgLkxaTF/hGLZ4YhF8OO1cVWvPOsEgTgr0EaqYOH2X1E=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN0PR10MB5255.namprd10.prod.outlook.com (2603:10b6:408:123::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 16:10:56 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa%3]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 16:10:56 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>
Subject: Re: [PATCH v2 3/7] qla2xxx: Add debugfs create/delete helpers
Thread-Topic: [PATCH v2 3/7] qla2xxx: Add debugfs create/delete helpers
Thread-Index: AQHYuTZOq7gqxnXxl0uDSxuBqtFe1q3GEWmA
Date:   Mon, 29 Aug 2022 16:10:56 +0000
Message-ID: <D11A885C-3694-492F-A846-3F3E73C2735B@oracle.com>
References: <20220826102559.17474-1-njavali@marvell.com>
 <20220826102559.17474-4-njavali@marvell.com>
In-Reply-To: <20220826102559.17474-4-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f64c57f-cd0b-4483-9f22-08da89d90e16
x-ms-traffictypediagnostic: BN0PR10MB5255:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S/lDpjS11nEzN1uOHtZ309y57stcJ4V4p49nlESSP2j2jvTvvhFjtv3msuawZ2aYkkblPee7IVE3BiXGh3eNJa813+O9OcETcwMH52iEGvpi9jHOqZPDNG4UatDKLbTSiOOJu7X2zlcQjk8q45v3R1z9xkfGj/FlwCsZbcr+2fwgix+LWQxhwn5geuQejAAhMYahNkEAN7TRee5SSx8acMcOSsnmSwnZs2E+b7wevwv+mp3SRMajxbUyBp136EVlVQfSwPnpmAhkyQ37Q9nkXVUtmCLCsl2pLW1FwsTbu5alYq/axSvBod9w8614zM9TjjHV717kbDrP/tsMCNiU0rB0him1dsgF51d1P7K3hiwbkqQkKJeyYA0Dpb9BPoM4rExEMk2LKUiNncAzW5p/HE2TNyb3TdRxTQQfQAcRdFQboYCptxucCx7zcjZF24loY5GND0HLtpVpvghH/BCIBSbU+AP/CAjPsigkBZ6Fdq3IdxuPGEy2WEXDe9HubqlGOZj6Nh1GFE7ZYNBb/r6g3AfSb63unpZiEIROgWC4tRGNzN7Z2Yh+qu7IiXhNjM3EQeGa6s7GsLJ/8ECGcs3FZ5pju9slDE1YOGJYebUSMxBi2Zb6pfspryQU6A93E5KOp0YIohHW3rAVw2mFcUPOSMn/RcdVWC3k0QfWjjdJ9dT0HjajGRFbiz9EWkEogZ9VqHsRt+9lxzRFSdWSjoKoH/7AkJzzcp7/Yi3JlSIVlvkQbX/sJQE/0Ig7ehTFKDEnkmxnnf38cr3dcVlj0RWku5mlmWMvUIzA6SFADykWxwo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(366004)(136003)(39860400002)(376002)(2906002)(6512007)(38100700002)(26005)(44832011)(122000001)(53546011)(6506007)(2616005)(33656002)(186003)(6916009)(71200400001)(8676002)(66946007)(54906003)(4326008)(66446008)(66476007)(66556008)(64756008)(6486002)(76116006)(91956017)(316002)(38070700005)(41300700001)(36756003)(8936002)(5660300002)(86362001)(478600001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?P9HttWN9XPmazUy2JYGtwEmWMARe5ggECQ7TgakcfZH4ajTP9oA4t1ECLPJO?=
 =?us-ascii?Q?RgMwcKVgtxAr/LSpsdrCwp8B532mCu66GD1szkgOQrVHZv8+iJ7n3XbxH8EY?=
 =?us-ascii?Q?vPf5mWI1RNt7kRmT6Uv3pkjccKvDwrbjvfIZChfG87SKuw9cbQE8bbgJwI/p?=
 =?us-ascii?Q?s5xoP20rzV8X87VO1dxSIit5nep1v4JeV3nSZtuhAU7xWdSHtBwcJXApNYPG?=
 =?us-ascii?Q?rZ2KxO1Qp7rV+SA5ci5LM63yMI0dKN+T2aGHyojMYdXJAoVEy8TT/Mo0QH4C?=
 =?us-ascii?Q?2ZgD51qQX2px8t5UGNb5D/eRg3PnoZqquNqPf3MFqKe2JOkqaRS84QVuEcUi?=
 =?us-ascii?Q?8tKcVdUpKIVRpwRlF7b6NCqaKeAq/6wLc1Mafi3vtvPC3gKgOXkaMDM18Y45?=
 =?us-ascii?Q?fheiB1+m6gTL+yqNl0zb82RTskL8IHe0hQZ4Oc6BAi7HiHrYU5gAiR04J/vn?=
 =?us-ascii?Q?N9iUHlpbQomwOkwgkGm4mYEU9JGsCzXbzyZ4qGOXc1tv1yEJmkblyaJ5iuln?=
 =?us-ascii?Q?OSE1Pa5bP9URtdScpfI3ZWeYG82VrG/7U46aJZ4wZvpT8j4ehqTRsDAhxC6w?=
 =?us-ascii?Q?tB2jG5iCqfT3xuxvNHkc7ih8bwCfGYFX6rMxKWNWHFXsOHtIptNIomCBtQUc?=
 =?us-ascii?Q?VO8zEhnUChVDYlT6qfgAB3RpNPFJR2nFompw2br1/BKN4iUGgsTA7zfgtQRU?=
 =?us-ascii?Q?CyfMf2PCOSyuillZWs1BPccyLjqgovCUhYzxHaNO3N+0VxFcUOtPLtOD+h1e?=
 =?us-ascii?Q?FXLx8OI38aMKkbUq4t3gh1vk3+/J0m/0Dn52VqkdZKmuKR5sERxQr7C0iO9W?=
 =?us-ascii?Q?Nwd6dJWHRdKwbGqrP/CRqqpGLqAwYc5Bs8P2isFgtqBqivrm8h6QaHa54OOV?=
 =?us-ascii?Q?il5RvbrH/0O5V1pUOBYBdPP09lBk0bE/rhMI4Q0k0k2CvJL6fW7dx+iV1WeR?=
 =?us-ascii?Q?1DZytSNGqiwK220MIYRy6jdcshwSl9UYzg5bJ4LbrgJcACPzJO905LYHP54W?=
 =?us-ascii?Q?Ennrh5/3HZLIkA/4KJfliJI7P0foKIdzIefILyjKnxKWq2yq2JqSxrS0RQxh?=
 =?us-ascii?Q?b/9RQOFyA/bZ1w9umNyoVCEUQ1dfdiNhT0zdL7LGMK41bUt8iWxnJ+kHHPkS?=
 =?us-ascii?Q?GFVQLpkvOW1G+/2O1phwm9cNJL7ThIpsTlwWzkivSJGKwVG/QlxKrplArYHs?=
 =?us-ascii?Q?hkMyAoPvaw8rUG+akFEZE71WU3inU8PYJf1tYpqRUAtoRDTuLFOC1bvT31g6?=
 =?us-ascii?Q?hbct0QxsOIhaHKYZ6CQJ2ZlWOYMzVboNcMvNG3yD9MRQYTCbgdXBo3i7Xxnh?=
 =?us-ascii?Q?Vr+r0dxoE2WG0LAwiQC247vXZ5KQ/MSBXk/qbJmlb4NZWKP+BFqhS/AcojcL?=
 =?us-ascii?Q?QbPh5WOyvDhflvI18ciIQFrv3DFvvgsXqbxamhy3hyG+o5h2Xek2t+0XZAd7?=
 =?us-ascii?Q?QyE/9NiPxjsXRL13SoXwvvCuw9xR1Z9qwmcgv1RKer1Es7aKa1hVcRy4GLKd?=
 =?us-ascii?Q?iZd69ueSg3aHJppbgGEy+D+CC1Ujdv1l2SzIo27qL1w0uXvfvarIsd+KDdV4?=
 =?us-ascii?Q?pp3wqUHKf4o017WzpbxPUhUnUDvnH16ww5DS97oxOTJhTnz3UBMiKXXDeJGC?=
 =?us-ascii?Q?0w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <73283C7DFFAF9D4FADA7300C595D7642@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f64c57f-cd0b-4483-9f22-08da89d90e16
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 16:10:56.2993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oMKgwrBGEBIUudEAYOGdS0u0fBVjT0XaJm6IzvGbGG2S6+1tXsCGQ2iy/OwnbcT2zm52JFfYaUg1MWeD1iTCEXDAFas61vqgx7WI62eDv0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5255
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-29_07,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208290075
X-Proofpoint-ORIG-GUID: _PRLrUEY4aNhRwqlHD9_dzcr_hVgDnmU
X-Proofpoint-GUID: _PRLrUEY4aNhRwqlHD9_dzcr_hVgDnmU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 26, 2022, at 3:25 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> Define a few helpful macros for creating debugfs files.
>=20
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h |  5 ++
> drivers/scsi/qla2xxx/qla_dfs.c | 93 ++++++++++++++++++++++++++++++++++
> 2 files changed, 98 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 3ec6a200942e..22274b405d01 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -35,6 +35,11 @@
>=20
> #include <uapi/scsi/fc/fc_els.h>
>=20
> +#define QLA_DFS_DEFINE_DENTRY(_debugfs_file_name) \
> +	struct dentry *dfs_##_debugfs_file_name
> +#define QLA_DFS_ROOT_DEFINE_DENTRY(_debugfs_file_name) \
> +	struct dentry *qla_dfs_##_debugfs_file_name
> +
> /* Big endian Fibre Channel S_ID (source ID) or D_ID (destination ID). */
> typedef struct {
> 	uint8_t domain;
> diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_df=
s.c
> index 85bd0e468d43..777808af5634 100644
> --- a/drivers/scsi/qla2xxx/qla_dfs.c
> +++ b/drivers/scsi/qla2xxx/qla_dfs.c
> @@ -489,6 +489,99 @@ qla_dfs_naqp_show(struct seq_file *s, void *unused)
> 	return 0;
> }
>=20
> +/*
> + * Helper macros for setting up debugfs entries.
> + * _name: The name of the debugfs entry
> + * _ctx_struct: The context that was passed when creating the debugfs fi=
le
> + *
> + * QLA_DFS_SETUP_RD could be used when there is only a show function.
> + * - show function take the name qla_dfs_<sysfs-name>_show
> + *
> + * QLA_DFS_SETUP_RW could be used when there are both show and write fun=
ctions.
> + * - show function take the name  qla_dfs_<sysfs-name>_show
> + * - write function take the name qla_dfs_<sysfs-name>_write
> + *
> + * To have a new debugfs entry, do:
> + * 1. Create a "struct dentry *" in the appropriate structure in the for=
mat
> + * dfs_<sysfs-name>
> + * 2. Setup debugfs entries using QLA_DFS_SETUP_RD / QLA_DFS_SETUP_RW
> + * 3. Create debugfs file in qla2x00_dfs_setup() using QLA_DFS_CREATE_FI=
LE
> + * or QLA_DFS_ROOT_CREATE_FILE
> + * 4. Remove debugfs file in qla2x00_dfs_remove() using QLA_DFS_REMOVE_F=
ILE
> + * or QLA_DFS_ROOT_REMOVE_FILE
> + *
> + * Example for creating "TEST" sysfs file:
> + * 1. struct qla_hw_data { ... struct dentry *dfs_TEST; }
> + * 2. QLA_DFS_SETUP_RD(TEST, scsi_qla_host_t);
> + * 3. In qla2x00_dfs_setup():
> + * QLA_DFS_CREATE_FILE(ha, TEST, 0600, ha->dfs_dir, vha);
> + * 4. In qla2x00_dfs_remove():
> + * QLA_DFS_REMOVE_FILE(ha, TEST);
> + */
> +#define QLA_DFS_SETUP_RD(_name, _ctx_struct)				\
> +static int								\
> +qla_dfs_##_name##_open(struct inode *inode, struct file *file)		\
> +{									\
> +	_ctx_struct *__ctx =3D inode->i_private;				\
> +									\
> +	return single_open(file, qla_dfs_##_name##_show, __ctx);	\
> +}									\
> +									\
> +static const struct file_operations qla_dfs_##_name##_ops =3D {		\
> +	.open           =3D qla_dfs_##_name##_open,			\
> +	.read           =3D seq_read,					\
> +	.llseek         =3D seq_lseek,					\
> +	.release        =3D single_release,				\
> +};
> +
> +#define QLA_DFS_SETUP_RW(_name, _ctx_struct)				\
> +static int								\
> +qla_dfs_##_name##_open(struct inode *inode, struct file *file)		\
> +{									\
> +	_ctx_struct *__ctx =3D inode->i_private;				\
> +									\
> +	return single_open(file, qla_dfs_##_name##_show, __ctx);	\
> +}									\
> +									\
> +static const struct file_operations qla_dfs_##_name##_ops =3D {		\
> +	.open           =3D qla_dfs_##_name##_open,			\
> +	.read           =3D seq_read,					\
> +	.llseek         =3D seq_lseek,					\
> +	.release        =3D single_release,				\
> +	.write		=3D qla_dfs_##_name##_write,			\
> +};
> +
> +#define QLA_DFS_ROOT_CREATE_FILE(_name, _perm, _ctx)			\
> +	do {								\
> +		if (!qla_dfs_##_name)					\
> +			qla_dfs_##_name =3D debugfs_create_file(#_name,	\
> +					_perm, qla2x00_dfs_root, _ctx,	\
> +					&qla_dfs_##_name##_ops);	\
> +	} while (0)
> +
> +#define QLA_DFS_ROOT_REMOVE_FILE(_name)					\
> +	do {								\
> +		if (qla_dfs_##_name) {					\
> +			debugfs_remove(qla_dfs_##_name);		\
> +			qla_dfs_##_name =3D NULL;				\
> +		}							\
> +	} while (0)
> +
> +#define QLA_DFS_CREATE_FILE(_struct, _name, _perm, _parent, _ctx)	\
> +	do {								\
> +		(_struct)->dfs_##_name =3D debugfs_create_file(#_name,	\
> +					_perm, _parent, _ctx,		\
> +					&qla_dfs_##_name##_ops)		\
> +	} while (0)
> +
> +#define QLA_DFS_REMOVE_FILE(_struct, _name)				\
> +	do {								\
> +		if ((_struct)->dfs_##_name) {				\
> +			debugfs_remove((_struct)->dfs_##_name);		\
> +			(_struct)->dfs_##_name =3D NULL;			\
> +		}							\
> +	} while (0)
> +
> static int
> qla_dfs_naqp_open(struct inode *inode, struct file *file)
> {
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

