Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3403C25B08
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Aug 2022 03:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240045AbiHWDyz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Aug 2022 23:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239454AbiHWDyy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2022 23:54:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171605A2C4
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2022 20:54:54 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27MNxMs9012486;
        Tue, 23 Aug 2022 03:54:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=l5bhai/OtM+dnTOpE4JasyytBE3LsVu3DBUUkeoXj78=;
 b=gE2GS3wXJqJ5wpwcgbm2MvhSABxvoajzCdVwGlNF8793LL1RpuP2blJz76RZgteUae67
 wV06h9bMzcti81gER4MR8Fc9JTLpPXSRNH6k0Q+uEXM9pEUpPSFCz+h0I5L19karlLUL
 7blZUGUErPOl+xU/TmRJ9Pu57H0Wf1xC8Z+QhCcQWw8bU/vIxjnGw9Iqj3l+Pjqc895b
 nzheFRYJXca5cAgU9eP0DOnQtk7aotexlKI5WQ73BzxYVpFNRVojvhH7L8udj3yiLz4I
 bsxSybhG0DcaFNX6FdNO8+mM7iH2hV25ckNpaPq8Br6l0R2infG1gLfK64L9r32y3fpe ZQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j4e8cs0qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 03:54:45 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27MNUJDh005031;
        Tue, 23 Aug 2022 03:54:45 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2043.outbound.protection.outlook.com [104.47.74.43])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j3mn4dnem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 03:54:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezfcJutl7Gnkuy1ewXRqZvZQpY53hv8f/WnUUkqpYQ5RyFahX1MG0Y2TMcPBS/pwpJnk7lDM23MRxSSWVQ2wvlAGfAYoTirgcvqD3gghKq9ap69EFR0rNj/KWHk5UXv2wX+ffp1DmvYHabC8GVU1LEbW0QUbK37wYgj9M7VdiEbLwCsVZ9xO2PZwmKdnF4j56IR462kVFOrEDSSQnjeFj0vABWPGxCm7s7RY+SN2yaIzssOT6rHza6ftXxNy51Kdv/T3uj51kwQV3gl6cTXEaYS0Mdo3Hm/s9N7Ot/4h8s4YoudxeoXTdzs+4ZZdB8xaKAJSMEQmVFaecaZZtopNYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5bhai/OtM+dnTOpE4JasyytBE3LsVu3DBUUkeoXj78=;
 b=CZEf6N+F5qiLvN5hStM9DWnJmrdZnAm+OSJIsCXSjtJYeG0Y/5SWdAjshXSjkeEvMZ+0f1PoOyLoRCW9Ft2suDVtNad1lwPwk3/K+186u5l+D9uL38yvsnYXYO5pnS9+Fm0yyvA0qh06797MzIVZUF9IfcS5/lhWFb5zjjO7o//DMWy4LGgcu36wXPSrxoGUycrdf9buppH6pZgMkbJ8/EnOc0ma01Frr5dUrNK3zFm+nc95Ef9iMKr9nXC+gweoeAN0VjurFdf1Pwuxsas45QvBlwh0oF+TjMj6RYhxT9TRBalW1U5CelkUKPNFcLRPh65z8TOZTScgh92Euicgjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5bhai/OtM+dnTOpE4JasyytBE3LsVu3DBUUkeoXj78=;
 b=HSOP9jGjgE2FU4BjmvdSpjK0YzTeVaPJgkeXkAZUx1XyFLMk3Lcgzl20eZgrUZpxur/xKcQX8ayYSHt8eB/7KDaDZJ2+4DoP5jxFHGPnNwuplMBgHnHfKOPl7UxE/Kinz+HwCNneDfnzyngLkJ46QFqbHJG9jWM+f2UZKFUE3aA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN6PR10MB3455.namprd10.prod.outlook.com (2603:10b6:805:cd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Tue, 23 Aug
 2022 03:54:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::89a7:ad8f:3077:f3c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::89a7:ad8f:3077:f3c0%8]) with mapi id 15.20.5546.023; Tue, 23 Aug 2022
 03:54:42 +0000
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH v5 1/4] scsi: qla2xxx: Remove unused del_sess_list field
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmgr8vip.fsf@ca-mkp.ca.oracle.com>
References: <0c335e86-5624-b599-5137-f1377419fb0c@I-love.SAKURA.ne.jp>
Date:   Mon, 22 Aug 2022 23:54:40 -0400
In-Reply-To: <0c335e86-5624-b599-5137-f1377419fb0c@I-love.SAKURA.ne.jp>
        (Tetsuo Handa's message of "Sun, 21 Aug 2022 12:57:50 +0900")
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0366.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd8e437d-321a-4b83-cb2b-08da84bb35c8
X-MS-TrafficTypeDiagnostic: SN6PR10MB3455:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N6XMuk6UWQ171dB76NhzXoQMr3wl35utc7CCJGXj4RxtRyo34GtHAam5u3ognBdHaKBdDpqMnG8L8C3khEf1HLADhIPbLQXq53HJHBIg6VhBmWoN3dEhtOBjhNF8EKCGmgxOTAz8LQ1CNMsyqZRs5NDUkIJQGrORJi+ecrdfSQOAoCmM8IaTst5gbDab7gSJm09oREEXz2dB7QTNvYZOikW11OgQXgO8jDLJH2GotvZipLqE0hyGQoYiAEVlIHoO3Xc35QWqJfcHtmeiMeRQfyvWHBJ1UyGJEUWUBccKw+ur6rc4newlnwNEB6K2++Jj6abZxBVlHHAf1Et188bAYFM29XiUl6zem4kWWnOIw0l6DZIV11GAugUjouyASaU32G7y/qyiw5rHlSdD6QsqjhzfZSG34ubcMAgYaF7J3geHSE+D2ABXVEuyHtGZ9O56zdQXC7rDU/Scq8XnP2Y9h3O8OMnQJPlq9WoJGcHMcx63Ynws5MVZOmtOTchJ+hCQR7ieY93Mvj/yEqroZigOE3N5QrYDJWUcWrQAoTIQRgugWual+A8SZmPoRIcbr37mWOO79m82MMj/noAf2jwJJDsfjxHFE2RC0iK5ByrZ4VVwyf+rCnENboKLKi1YXA/8SMThi9jbzZHyuU9RvG9J8LDUDAnHe1EzwO5+gewk1MC29I9OIzVqxt6A2nEkAhuNlOgFWCGuKue1sQZ5SlnNQ7+EopNI9laF4Q9xFfBdas2Kaz5Xx5TtLqyfc9Y4d4iO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(366004)(346002)(136003)(39860400002)(52116002)(41300700001)(6486002)(186003)(478600001)(107886003)(26005)(6506007)(6512007)(36916002)(38350700002)(8936002)(38100700002)(5660300002)(66556008)(4326008)(558084003)(66946007)(66476007)(8676002)(2906002)(86362001)(316002)(6916009)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w+bknTYWdYM+Gc959Xd8WQo79BVma0XarEDNFUGVociwM1SMvO5kuFU6Hwwu?=
 =?us-ascii?Q?o2Rydp6wDx/0i2PS5wPrODtkgaNr0JpCgDlqqVbF3y9d27Vi15hic3HotGnN?=
 =?us-ascii?Q?PlCUcX16QxXE1mp1N888hWo+C4V+Iolr2I8wUpCMZD+SzGyKtixETOtbV5TK?=
 =?us-ascii?Q?sTGdBHMVstNa74ROcFbVSb4BrPbeEYqJvRUhz4k2Jup/nuQv8972HWx37lAt?=
 =?us-ascii?Q?30P4WPlEUFZfu4CYjzZ5mgzlL9HrqU+xAb4qv/lBDSH65AKySkBlboA79/b3?=
 =?us-ascii?Q?0z4VBnhMzyRxfjT3CoYprGKLgJricJjF53RLFYPy+vcDNlWWpGv9NfvVXVvF?=
 =?us-ascii?Q?yb97I/1LNygq8/TwAkGObgc++KD7YKKXsabIyrmVx71kulW9V9ZAAADQjYL3?=
 =?us-ascii?Q?AuAjx3DOaHn59CCE/nZ9m2S89mf0nlkOPNr57juiTTH8boyP0LMo3Lb4H0/F?=
 =?us-ascii?Q?upZyrMm24jmF0BwdDWgM+m2JXGlX59IKiwyhFXL/HXDOqYX4qgP7pOgDavPJ?=
 =?us-ascii?Q?EFEN2w+oYyNxxSzBtRsAMPc2KaEJwB4y11txsNshkSesqJ04dBys+hN/g6FP?=
 =?us-ascii?Q?Uc5MEYueQiUJGVK49g6A86QARl2uN7gOZHjjkDDVpQgCtjmTpogK7UNlzfCH?=
 =?us-ascii?Q?A2zhArRuUCpcGg0egjT3TS0GrS9HLGxetcU8CTYVXVVO40f5zInq8mr5C9FN?=
 =?us-ascii?Q?+Gx1fUSN96Wvn8WhPTLUZDqMQc7FMax1MtiMYZ8x/VtJVB4/aqLvwpPSS3GC?=
 =?us-ascii?Q?ruq+zJ06fGoS1DgsztxzWRPd01cynhztQU+M1PSxr2VSUq3t1EplZGfoBYqT?=
 =?us-ascii?Q?XIpya3diLC0FelAPdShVVbANCmFIvB2cByQ1PF5LAOe3+gyT6lst83gieukw?=
 =?us-ascii?Q?IbDTCieg55MyHgWpPlW9A4LqGUXirB259ygwbWwLFsjVsR05ajN1bx6zBgsJ?=
 =?us-ascii?Q?ilsW58Y7ssi23qJnexpwmVbup98JBHlBQQa2YctOik/LqfQwOUmH7KPb2VwV?=
 =?us-ascii?Q?8JKZvJpZRmCw0juqiqkwV9EDaHB7dVdYNc1ud1p1/E+zPhMGRrfMfTZ6RC+Q?=
 =?us-ascii?Q?1YxMR8dsGGmA/nVXFZ/h94/lMw4h5t7l4xCmGwLVPEqX+reAtJq2cIDmvqFO?=
 =?us-ascii?Q?sOOJAI4L33K4xuj2y9X7EwWQ3FWIm5+/trMdSzHiMXh+y7rGT09R3cqfUT5R?=
 =?us-ascii?Q?YHgwxtCZMJLOizZgbgWI+hycvsIGdw6KzR3U+ncBPjjwO8tGufbufayEtVFN?=
 =?us-ascii?Q?FhQTKHF584bZM3Uh1ecrN2euvFRQom0CE8duUlkX3l5esIuBQH9M2omHAbkE?=
 =?us-ascii?Q?CDyAo9jHNoP39MLXssFSPnxYH860G5u3aJEFBRcOIxccivbJaYerSe41B4Py?=
 =?us-ascii?Q?1Brc8xrBnIHLSmJ//1Uvew5bQJmuGTyC4M87YM89cNgqeaaSNSIR7FSNyEhe?=
 =?us-ascii?Q?AMFXfnwq6AAHTLFPcDMNWg/RyGAYjCwh9PRQCpCk+YeBentxYkpiA3UcJ9V5?=
 =?us-ascii?Q?khRmUgff1hTw60cLQITBDY1D5jKDj+PRILW70wpUZ+EXOjt4YAljWSQa83nC?=
 =?us-ascii?Q?aF5pk+grg6t9R/uo/SHIBhMgfd+hR+2H9uBmnAYX/MyACc/uNZ2QBFcia8L4?=
 =?us-ascii?Q?Aw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd8e437d-321a-4b83-cb2b-08da84bb35c8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 03:54:42.5082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v5rXg574F95ZjRKC9mYafLj0SxwkMwBXoI2AlY3DgZS6OOPhk9OA/qdwcKO94RkU8EKbSkNp5bELwrYtJKiGQpdqSCbUYOP7CejKvMgK4Yo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3455
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-22_16,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 adultscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230014
X-Proofpoint-GUID: ehnCUOZ3_YMJhh2S0qM_lHjNpXKYb3jD
X-Proofpoint-ORIG-GUID: ehnCUOZ3_YMJhh2S0qM_lHjNpXKYb3jD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tetsuo,

> "struct qla_tgt"->del_sess_list is no longer used since commit
> 726b85487067d7f5 ("qla2xxx: Add framework for async fabric discovery").

Applied patches 1-4 to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
