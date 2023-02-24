Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E643CC7EE30
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Feb 2023 17:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjBXRsQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Feb 2023 12:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjBXRsE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2023 12:48:04 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D65C9EF2;
        Fri, 24 Feb 2023 09:48:01 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31OHiJlM020513;
        Fri, 24 Feb 2023 17:45:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=pH8V4wiflSOMKMLJnT/e1rHbAZGDLooDfNE3dG/x9Ps=;
 b=0FaEU+r4Vvu0T2VRw22iM9qr3ADs40yrj81fSq14uLsfqhPb2ljidy5pmkW/Lgcc5/VA
 53eOMblvO3HGmdo5cJW7ZYsEGFU8D4uUZJo3fHk2tLsPm7577D66ntRrmQkMFOYuH/wI
 WSR2E3T+Rw++6tZzQzcKqIN2YUkyGz8/G8e91RISnRdeke+iqnWBpZyYH7HADL8HOJMy
 suDKTxSY5ugRI9iiq6ny+bOFGT0Xhi441/RQ0l4zsfaN9V101IJ8vW//QTQ9MYijKzk0
 qqzKWoOb1JmZA3/B6xmKlcSIYNiXwif6KQZSjzHR0E6vWYI6SGIEvX+qq9mBXnTOdpu2 xQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntpjadkq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:34 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31OGXw1e001935;
        Fri, 24 Feb 2023 17:45:32 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nxsb4kufb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REW2xqi0ED00sFCCjxOHJOJTWQ8Vssr7Ylz2NFdoReW3eyqAU/+Lzk3aJ/4907WlSbDpRYbDKJQUrqO36xtYivh8ZmyaSDAQodL/Y1UIWnDYEPBIJEkq/0hupxGn7wKY5cl0kkqziui8IRjr7+OMI4+xLf/JJUWqNYuSRX/+CnWH51mtsKxTFKESWJS+GeVKk68X6hQr7VxouKuS55Pe+bIIIFfibHh2QB+GFSDEApWG6IqjnBjg+/li5+kW73T5JOp79nq1CYmlYeh6b0o/vx2Fnep2tIJH0QS7qOgCubtwklB/SoCa7O9f/XePml6XtdsKFdDZY9mtswx/jS5FuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pH8V4wiflSOMKMLJnT/e1rHbAZGDLooDfNE3dG/x9Ps=;
 b=CnBAj7OkhSb3IuNt/P+i6dum9CEUPuYWulPidG/QkeoEES9BGM5PVHRhhy0o9b9PSsxmjZ5ErCcnkR6RZv93nzhkXDVJkhuDGC1IqCoF6RaMWcL2kKeHUdSF/bp6GJFsintl/tRZmQyHMP8NBh9DW3c+neoQ+ZTspJLtnbL/1eIx16qgZd5NBRORCfZ/h3ksijoXS/npcOnW0ptKmpL0m6p7ywcIPyZT1tqmIt4zDHYdzRpVKP8mOy6gZKJggXIAlU0fMx5I7exJRLcsXws9tXTKa5VzjPFf6RGDw4wdjOndxy73D4UdNr5McF7zW8Y1sVbIgZoqVPRK9tqsZDwu3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pH8V4wiflSOMKMLJnT/e1rHbAZGDLooDfNE3dG/x9Ps=;
 b=NTQrw8K4me7dLK8G2x289hSu/8Q5+x5OZooZO3fFL31ISCoSAFvRTfZJP4oBK3SxRBG5s5cq3Nkai8KkShtUaXHh0Qlz+ouDVAhXeZzUpVfqOS5UwdcZtJxKTFjkoFcSDolIgpJUW6m2TrvxMtOWG8rm7bgbfyOCo4ggeiXYMXk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6245.namprd10.prod.outlook.com (2603:10b6:8:d3::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.16; Fri, 24 Feb 2023 17:45:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 18/18] scsi: target: Add block PR support to iblock
Date:   Fri, 24 Feb 2023 11:45:02 -0600
Message-Id: <20230224174502.321490-19-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:8:2f::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6245:EE_
X-MS-Office365-Filtering-Correlation-Id: 3eeac00c-bee0-471b-5658-08db168eec76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8bfJNgDFehkDHmDLG8i/mYRAUBWGOdMpOvggqrNsDFyusEBGq27DWeagWD39ZKaStsV2c0QIMK1PnDEZKV4rmEvdccJBvQe4zp10u5gPqfw/+DWyYdd+d2fjqgKl8dGUdMpxakPzxLVTzEBtYtjGWMNCHG7x0P7MGbRIgAgVsxZgMnuIcKWbhWUp78wcavKuQbWtDuIC1rc2FmiTbL8qwlOsUMMbqPSWEs60JDXPQ8lqi3vgupLWLUL06U3Q5mOzHU9OmfcxwQ/QUmK04lvHlef49c+U3svlzlitiDW/KMypPP9kkl9ZcnNQkVjyiN/CiAofd4Y1QTDqcZdM3Wl6n04HcwrjQnd1dzc4DV1N6wfuSBkYJL8QeBZmj/r5Gkyk8dA+QWb+7m/7ZL7BbIJ/oPo7okCfBxY0KbaqugMEuuR2kwFgqFQcM1CkNv9fSSQQ2lIh1UfdBcVgGMmUJth8rn9RA0iYgkhmuJAGZhwr6kpy8qVsS4tzPSiuOQtyX+je04zOzQe/zqGy6osfhm+XyQKJiYlmTqHVPqX0egFNOLjZcDYltsoHJn3YkUt1/2twh2I6xAglO/2HX4F9T5OHRUXRPD1iQpMk9oFachgNEjVtTsh/uxG7K2mVfoV1q1bQg7HyRcDevAmV12PmROz6XGT5IknITss+6jzYM6alw8PweZnHrbNBmS1NXnZbADHA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(376002)(396003)(136003)(346002)(451199018)(6512007)(36756003)(26005)(2906002)(186003)(921005)(107886003)(6666004)(6506007)(1076003)(6486002)(38100700002)(478600001)(66946007)(8936002)(30864003)(66476007)(4326008)(8676002)(41300700001)(7416002)(86362001)(5660300002)(66556008)(83380400001)(316002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PBeI6GrV5WAh1x0JX+NbkLtfSXtlh5DtCZcQtsTMy6R+YTH3j/H1f7gW6y+A?=
 =?us-ascii?Q?MARSHL1qc2jC5NJoUMHGg6uueXJZ9ToTr4ZTFRPzSPVXjVNlUoWuHPhlRg40?=
 =?us-ascii?Q?dd1SbcoOLNTiZrTHJdlNYjqtRGrgAX2DUQArc+wv3vfvVPZn3FxT1RtmIsED?=
 =?us-ascii?Q?p+LxBtAER0PfCODZK5/BjpiDTKjRP2EL1Cri2Tmjv0JlfJutRTT7EeGj+Zou?=
 =?us-ascii?Q?lvZjrxa0VBLuoCdVB+/BWDnvcFH24nSSPqsud4vuYwzoDNCd9kJVaajDu44E?=
 =?us-ascii?Q?1PcpvvnCGdl+KkGGu4z6jiOKwTPPvJFMDkIbaOgWYt1RsGEtorElm2eXqoWi?=
 =?us-ascii?Q?KbUxvZUmLtZXDu+2dqm+IEIlCTqc3ry+VK3Us29MP+2/hldqqUfQlca/zzW6?=
 =?us-ascii?Q?vGo4tQwvxR2j3k+59xx8Irbu8Dlwmisjb9ZtltQntYhEt121pjxNwElbPMj5?=
 =?us-ascii?Q?288KK7crxhaaIpWPXZmyPWCGLriV5LZsenheSZB41EZElkeFCE2VGyUKvSfh?=
 =?us-ascii?Q?S95+wbKR476Ilx+CW+ytCRlMpVCHemvZMYj0K9z7dl67ZhghICgzutvqVLfW?=
 =?us-ascii?Q?mJhKTI+lWGmeXlrnw11NSgNcvKxwlOQSMEy84m2zsneWeUOWG9O80lC/gmPG?=
 =?us-ascii?Q?e4yBRkIHD54zUysrvc8P+tgtK+qxrrfO5sdjZ7OVMqv5UrORvj2B0viES2W2?=
 =?us-ascii?Q?kFLvugIlW4RP2I6uAoJZbS9MkXYlIZokmFB9npV4ky9itv7jWi+8EfRrp/wG?=
 =?us-ascii?Q?bbZOTpFljZ295hMB1zNDisce8BS7RDabSfAcPY/Lw0EkQWKKOTF2JQ+O2lZK?=
 =?us-ascii?Q?dM2tApzPLRDllGjBhCg8OXEitqE97zi7Wi+UzH+OuUiqK77X6sCpavElZw/6?=
 =?us-ascii?Q?XztlCZkEZs7iIdy8Jajxyr1wkXn9N+JtgWtwBbFc1ryoXpbTz7XpZ8LfsToF?=
 =?us-ascii?Q?d6baYsn8N82lrNHoZuF98GeB2nJ5tPaolFWcTkS7gDm5iFEzE0mF6Ce+ZJMz?=
 =?us-ascii?Q?f9RpNOv0Pqtvi11aTU4bUVCkQoNFWUgDYDbWHslzEfk0okj/kdeiH3eUEOhr?=
 =?us-ascii?Q?0LGDhoRe8/7WxZtp49SAGZMB/AUSBEgMdC0IAmH2nhNLhRjxRpt0YrobwgSB?=
 =?us-ascii?Q?uLQLSczK2DW3ZPRFxN94XNGUsxiwJAzppHtKMk+RsfmQ4LBpnRurSI1Rm3eV?=
 =?us-ascii?Q?H4lIa17UQ2PGBzmhw+2vAPF2EhYhHrJl1PchnayNcMZqhJpvzJwHemg6kDkF?=
 =?us-ascii?Q?eNJrGfMYF6+8CfOjYpw35LVQGB+wVcL5J+pvevfV2OzqMsKEgJ4+ytl7U6FK?=
 =?us-ascii?Q?fTRoDxv0ztFOTvHYTEe9QIxHGjP0rxrN8N21AKKcwzZ/oZKsYFgcmNcUcrS/?=
 =?us-ascii?Q?BP9/l8fjKQvy5g4vuFjM1ONQFBM+LWDzWSUWKY5MOJe/fKbRxfDaZZ24UD9F?=
 =?us-ascii?Q?caGGIcLijwMvMCyaEbRxo0P8mzttvd7IZps/nNgE2OVCXRzoYBETJSwQGkCf?=
 =?us-ascii?Q?4n6Hu5Ujpv2lj1SD5i1AIR76oTMgyfJHoji9b6kXbdZU64PalyNGJs3Z1AC7?=
 =?us-ascii?Q?j0gJPQ02Kxw0IFdgQRiB+f4XhY2Sx4J249cP65Zjf3qcqYMlYFy+sX6B6EY8?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?g3n6OCfKb+CUy6eMBcXPhxdRXwVYMGEKrvmLyw+ShMb/mhox6VubYZ9BoGuk?=
 =?us-ascii?Q?LsX2kOjMuLjQEkUDyitZn2KtJacMyDIbhIfgZpT9nXf+N7rwAaBJiQ6VZVrA?=
 =?us-ascii?Q?IIloPXjAuP5BwYBg4J+gdI0y3rnZ/dl+ZWOS7MGZw7MMGavkBu4hoKrbnY+d?=
 =?us-ascii?Q?Wfj9yllHPHzY2nU3P0aE8UEnkEL34Q/ck9mPIPs0ODTr+kUozGedW38FLgdr?=
 =?us-ascii?Q?nUgbq6Z3/tR7ra8sD8hLV0sEml73/+irKWmRofIghVCxtPN+Vu88jvAe4w28?=
 =?us-ascii?Q?C6d/IQR5B9euXeVSibh6zf0XTFwFCQaWRsAaKHZfkb5ay9HtNgGWBbyF5Xyp?=
 =?us-ascii?Q?3goEigtAL8VhKAV++W/Rhs8UmmnFEuWpl4sftF/HM6+XWwFEn4aO/s4SSjlm?=
 =?us-ascii?Q?DbLvzCprKN1n8FGdQdBkKlikINQYyHV5IyEQrLIXjDunHSM4jDt6lSoBb/al?=
 =?us-ascii?Q?LuA7LDX4VBnYPN4IE/SgtZqdVGsgtdrJonwtcB0X7H3d+5eURDcxPp8RUGyS?=
 =?us-ascii?Q?w6PJ8A9tnJkCWwUc5RqttPAqWgBWQNGNq145n4BVO0n732ji3ZJ6b61cIkzf?=
 =?us-ascii?Q?38nxYxKBMYE8eogTiVrZn/1NBB+CRliSH7SAe8M/3oCDRPU/WilIu2cqwpIR?=
 =?us-ascii?Q?EC1VCMqwvfsGOZwAp7isggnzQyxDyp/l7nEvV+ZMnlQ9sXbaTSsmZztyFT1f?=
 =?us-ascii?Q?hSxjgx+0vb0oIQaTJvB40nbp7bTpFAsQKEz5Pxg9/WHtAtvNN+N4FvHWP74u?=
 =?us-ascii?Q?jPd1rjbwHC4qHgPv51vfX6RYFqucI+VlyWJwvONCaNs6VQ9v6oHYd5La0j2K?=
 =?us-ascii?Q?9JDIN/Wrs5GGP9NUGAjkVlLTUYFEhD6rYBMq3RQGjo4ll1km11xbo5o6DxvW?=
 =?us-ascii?Q?w6JvBE/dWAodh0FSYZ34409h//v3IjYP3Z6qDz/TUjAFLKKWbH8EOYbmjU04?=
 =?us-ascii?Q?48evJxRWdozywAaIhM6rqEAdi70S4HuLcZvmZSrDX/l7rD4+ilofmbMVQu8D?=
 =?us-ascii?Q?tZglDHauIwcSuz7dgqayG0kyCA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eeac00c-bee0-471b-5658-08db168eec76
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:31.2652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vXHtrfA7fdtHvuI3vHImVhsQZDaHKxqNYNSWQdOTYQBMM4u66AJSM4WzXupwSg6R8WRTezCFhXC8rVQJK8WFgiT5xF39vULxO7+rpyC1unU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6245
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240139
X-Proofpoint-ORIG-GUID: ej6P4rTjAmvuSFzkRfzSxF6sRFUr42_F
X-Proofpoint-GUID: ej6P4rTjAmvuSFzkRfzSxF6sRFUr42_F
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds support for the block PR callouts to target_core_iblock. This
patch doesn't attempt to implement the entire spec because there's no way
support it all like SPEC_I_PT and ALL_TG_PT. This only supports
exporting the iblock device from one path on the local target.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_iblock.c | 269 +++++++++++++++++++++++++++-
 1 file changed, 264 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index d93f24f9687d..9d60259b03fd 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -23,13 +23,16 @@
 #include <linux/file.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
+#include <linux/pr.h>
 #include <scsi/scsi_proto.h>
+#include <scsi/scsi_block_pr.h>
 #include <asm/unaligned.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
 
 #include "target_core_iblock.h"
+#include "target_core_pr.h"
 
 #define IBLOCK_MAX_BIO_PER_TASK	 32	/* max # of bios to submit at a time */
 #define IBLOCK_BIO_POOL_SIZE	128
@@ -310,7 +313,7 @@ static sector_t iblock_get_blocks(struct se_device *dev)
 	return blocks_long;
 }
 
-static void iblock_complete_cmd(struct se_cmd *cmd)
+static void iblock_complete_cmd(struct se_cmd *cmd, blk_status_t blk_status)
 {
 	struct iblock_req *ibr = cmd->priv;
 	u8 status;
@@ -318,7 +321,9 @@ static void iblock_complete_cmd(struct se_cmd *cmd)
 	if (!refcount_dec_and_test(&ibr->pending))
 		return;
 
-	if (atomic_read(&ibr->ib_bio_err_cnt))
+	if (blk_status == BLK_STS_RESV_CONFLICT)
+		status = SAM_STAT_RESERVATION_CONFLICT;
+	else if (atomic_read(&ibr->ib_bio_err_cnt))
 		status = SAM_STAT_CHECK_CONDITION;
 	else
 		status = SAM_STAT_GOOD;
@@ -331,6 +336,7 @@ static void iblock_bio_done(struct bio *bio)
 {
 	struct se_cmd *cmd = bio->bi_private;
 	struct iblock_req *ibr = cmd->priv;
+	blk_status_t blk_status = bio->bi_status;
 
 	if (bio->bi_status) {
 		pr_err("bio error: %p,  err: %d\n", bio, bio->bi_status);
@@ -343,7 +349,7 @@ static void iblock_bio_done(struct bio *bio)
 
 	bio_put(bio);
 
-	iblock_complete_cmd(cmd);
+	iblock_complete_cmd(cmd, blk_status);
 }
 
 static struct bio *iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num,
@@ -759,7 +765,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 	if (!sgl_nents) {
 		refcount_set(&ibr->pending, 1);
-		iblock_complete_cmd(cmd);
+		iblock_complete_cmd(cmd, BLK_STS_OK);
 		return 0;
 	}
 
@@ -817,7 +823,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	}
 
 	iblock_submit_bios(&list);
-	iblock_complete_cmd(cmd);
+	iblock_complete_cmd(cmd, BLK_STS_OK);
 	return 0;
 
 fail_put_bios:
@@ -829,6 +835,256 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 }
 
+static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
+					    u64 sa_key, u8 type, bool aptpl)
+{
+	struct se_device *dev = cmd->se_dev;
+	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+	struct block_device *bdev = ib_dev->ibd_bd;
+	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
+	int ret;
+
+	if (!ops) {
+		pr_err("Block device does not support pr_ops but iblock device has been configured for PR passthrough.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	switch (sa) {
+	case PRO_REGISTER:
+	case PRO_REGISTER_AND_IGNORE_EXISTING_KEY:
+		if (!ops->pr_register) {
+			pr_err("block device does not support pr_register.\n");
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		}
+
+		/* The block layer pr ops always enables aptpl */
+		if (!aptpl)
+			pr_info("APTPL not set by initiator, but will be used.\n");
+
+		ret = ops->pr_register(bdev, key, sa_key,
+				sa == PRO_REGISTER ? 0 : PR_FL_IGNORE_KEY);
+		break;
+	case PRO_RESERVE:
+		if (!ops->pr_reserve) {
+			pr_err("block_device does not support pr_reserve.\n");
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		}
+
+		ret = ops->pr_reserve(bdev, key, scsi_pr_type_to_block(type), 0);
+		break;
+	case PRO_CLEAR:
+		if (!ops->pr_clear) {
+			pr_err("block_device does not support pr_clear.\n");
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		}
+
+		ret = ops->pr_clear(bdev, key);
+		break;
+	case PRO_PREEMPT:
+	case PRO_PREEMPT_AND_ABORT:
+		if (!ops->pr_clear) {
+			pr_err("block_device does not support pr_preempt.\n");
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		}
+
+		ret = ops->pr_preempt(bdev, key, sa_key,
+				      scsi_pr_type_to_block(type),
+				      sa == PRO_PREEMPT ? false : true);
+		break;
+	case PRO_RELEASE:
+		if (!ops->pr_clear) {
+			pr_err("block_device does not support pr_pclear.\n");
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		}
+
+		ret = ops->pr_release(bdev, key, scsi_pr_type_to_block(type));
+		break;
+	default:
+		pr_err("Unknown PERSISTENT_RESERVE_OUT SA: 0x%02x\n", sa);
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	if (!ret)
+		return TCM_NO_SENSE;
+	else if (ret == PR_STS_RESERVATION_CONFLICT)
+		return TCM_RESERVATION_CONFLICT;
+	else
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+}
+
+static void iblock_pr_report_caps(unsigned char *param_data)
+{
+	u16 len = 8;
+
+	put_unaligned_be16(len, &param_data[0]);
+	/*
+	 * When using the pr_ops passthrough method we only support exporting
+	 * the device through one target port because from the backend module
+	 * level we can't see the target port config. As a result we only
+	 * support registration directly from the I_T nexus the cmd is sent
+	 * through and do not set ATP_C here.
+	 *
+	 * The block layer pr_ops do not support passing in initiators so
+	 * we don't set SIP_C here.
+	 */
+	/* PTPL_C: Persistence across Target Power Loss bit */
+	param_data[2] |= 0x01;
+	/*
+	 * We are filling in the PERSISTENT RESERVATION TYPE MASK below, so
+	 * set the TMV: Task Mask Valid bit.
+	 */
+	param_data[3] |= 0x80;
+	/*
+	 * Change ALLOW COMMANDs to 0x20 or 0x40 later from Table 166
+	 */
+	param_data[3] |= 0x10; /* ALLOW COMMANDs field 001b */
+	/*
+	 * PTPL_A: Persistence across Target Power Loss Active bit. The block
+	 * layer pr ops always enables this so report it active.
+	 */
+	param_data[3] |= 0x01;
+	/*
+	 * Setup the PERSISTENT RESERVATION TYPE MASK from Table 212 spc4r37.
+	 */
+	param_data[4] |= 0x80; /* PR_TYPE_EXCLUSIVE_ACCESS_ALLREG */
+	param_data[4] |= 0x40; /* PR_TYPE_EXCLUSIVE_ACCESS_REGONLY */
+	param_data[4] |= 0x20; /* PR_TYPE_WRITE_EXCLUSIVE_REGONLY */
+	param_data[4] |= 0x08; /* PR_TYPE_EXCLUSIVE_ACCESS */
+	param_data[4] |= 0x02; /* PR_TYPE_WRITE_EXCLUSIVE */
+	param_data[5] |= 0x01; /* PR_TYPE_EXCLUSIVE_ACCESS_ALLREG */
+}
+
+static int iblock_pr_read_keys(struct se_cmd *cmd, unsigned char *param_data)
+{
+	struct se_device *dev = cmd->se_dev;
+	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+	struct block_device *bdev = ib_dev->ibd_bd;
+	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
+	int i, ret, len, paths, data_offset;
+	struct pr_keys *keys;
+
+	if (!ops) {
+		pr_err("Block device does not support pr_ops but iblock device has been configured for PR passthrough.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	if (!ops->pr_read_keys) {
+		pr_err("Block device does not support read_keys.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	/*
+	 * We don't know what's under us, but dm-multipath will register every
+	 * path with the same key, so start off with enough space for 16 paths.
+	 */
+	paths = 16;
+retry:
+	len = 8 * paths;
+	keys = kzalloc(sizeof(*keys) + len, GFP_KERNEL);
+	if (!keys)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	keys->num_keys = paths;
+	ret = ops->pr_read_keys(bdev, keys);
+	if (!ret) {
+		if (keys->num_keys > paths) {
+			kfree(keys);
+			paths *= 2;
+			goto retry;
+		}
+	} else if (ret) {
+		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		goto free_keys;
+	}
+
+	ret = TCM_NO_SENSE;
+
+	put_unaligned_be32(keys->generation, &param_data[0]);
+	if (!keys->num_keys) {
+		put_unaligned_be32(0, &param_data[4]);
+		goto free_keys;
+	}
+
+	put_unaligned_be32(8 * keys->num_keys, &param_data[4]);
+
+	data_offset = 8;
+	for (i = 0; i < keys->num_keys; i++) {
+		if (data_offset + 8 > cmd->data_length)
+			break;
+
+		put_unaligned_be64(keys->keys[i], &param_data[data_offset]);
+		data_offset += 8;
+	}
+
+free_keys:
+	kfree(keys);
+	return ret;
+}
+
+static int iblock_pr_read_reservation(struct se_cmd *cmd,
+				      unsigned char *param_data)
+{
+	struct se_device *dev = cmd->se_dev;
+	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+	struct block_device *bdev = ib_dev->ibd_bd;
+	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
+	struct pr_held_reservation rsv = { };
+
+	if (!ops) {
+		pr_err("Block device does not support pr_ops but iblock device has been configured for PR passthrough.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	if (!ops->pr_read_reservation) {
+		pr_err("Block device does not support read_keys.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	if (ops->pr_read_reservation(bdev, &rsv))
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	put_unaligned_be32(rsv.generation, &param_data[0]);
+	if (!block_pr_type_to_scsi(rsv.type)) {
+		put_unaligned_be32(0, &param_data[4]);
+		return TCM_NO_SENSE;
+	}
+
+	put_unaligned_be32(16, &param_data[4]);
+
+	if (cmd->data_length < 16)
+		return TCM_NO_SENSE;
+	put_unaligned_be64(rsv.key, &param_data[8]);
+
+	if (cmd->data_length < 22)
+		return TCM_NO_SENSE;
+	param_data[21] = block_pr_type_to_scsi(rsv.type);
+
+	return TCM_NO_SENSE;
+}
+
+static sense_reason_t iblock_execute_pr_in(struct se_cmd *cmd, u8 sa,
+					   unsigned char *param_data)
+{
+	sense_reason_t ret = TCM_NO_SENSE;
+
+	switch (sa) {
+	case PRI_REPORT_CAPABILITIES:
+		iblock_pr_report_caps(param_data);
+		break;
+	case PRI_READ_KEYS:
+		ret = iblock_pr_read_keys(cmd, param_data);
+		break;
+	case PRI_READ_RESERVATION:
+		ret = iblock_pr_read_reservation(cmd, param_data);
+		break;
+	default:
+		pr_err("Unknown PERSISTENT_RESERVE_IN SA: 0x%02x\n", sa);
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	return ret;
+}
+
 static sector_t iblock_get_alignment_offset_lbas(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
@@ -874,6 +1130,8 @@ static struct exec_cmd_ops iblock_exec_cmd_ops = {
 	.execute_sync_cache	= iblock_execute_sync_cache,
 	.execute_write_same	= iblock_execute_write_same,
 	.execute_unmap		= iblock_execute_unmap,
+	.execute_pr_out		= iblock_execute_pr_out,
+	.execute_pr_in		= iblock_execute_pr_in,
 };
 
 static sense_reason_t
@@ -890,6 +1148,7 @@ static bool iblock_get_write_cache(struct se_device *dev)
 static const struct target_backend_ops iblock_ops = {
 	.name			= "iblock",
 	.inquiry_prod		= "IBLOCK",
+	.transport_flags_changeable = TRANSPORT_FLAG_PASSTHROUGH_PGR,
 	.inquiry_rev		= IBLOCK_VERSION,
 	.owner			= THIS_MODULE,
 	.attach_hba		= iblock_attach_hba,
-- 
2.25.1

