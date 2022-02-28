Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF5BC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 02:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbiB1Clb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 21:41:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbiB1ClN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 21:41:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF1D6E7A5
        for <linux-scsi@vger.kernel.org>; Sun, 27 Feb 2022 18:40:33 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21RMdVq6021527;
        Mon, 28 Feb 2022 02:40:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=GE8WEnRTi1eHZYo6wB+KDOGoFfjvbNz7PAU+7a1m/ws=;
 b=eadcB7uyfTZJCgmF8UKs3EbCbyudTnKDCK13uDwRsWg+/bIzKvFYuoVdIr3Xcc6fCIWd
 CsCar6B/U1tTVLnNTBkr6tVEiTsgc1Sxgyw/4IW3sFEco3TeYNGL533sbP1z7MjpWWq5
 daWcP8Q43PvfLmcIAkB9pkd4OCM7r6DbbqMPULLMGQlkmskU0no0i7DG/YQcJNztlfKZ
 erWRhVChBuVowY8eUgGXk2bOcvxSYbC13POG2p1nAx95pWZfT/yBn/2FBiZjBcP5QerB
 MEYgQdlfBrU3DejDKfoozGrAscRAPp65DOtMvdi+kDA2lZJa7KmIK8YUKdyUvKFwTSnU 0g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efat1txr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 02:40:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21S2Vrbe016871;
        Mon, 28 Feb 2022 02:40:07 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by userp3030.oracle.com with ESMTP id 3ef9auqex4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 02:40:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OLyAqYt4NdhaBy0mNgSrXNBXxg17ofLNQaauzY3rUgaWGz5eAfWSnifB13tamZNXU8OVzB/QSZ4RHjAgO+VnXM9sFQ7t6b7gufwNTXwO4BQFZU3qoUJ5hZukW9k5w6ldKF2GAImNq7J6QxbsnAhTgUWq91XrSgnRAx1B6CDwl0x5VdJm1XrDWJqFd3m9AZABQRO+Z2T+Va36cJSPOmQ6bgcvoCjnIHuODE1DEh+Y4DtcqC0YB6JmJBy461uiALF9AbURsI3Pe+I4gq1JKQtBzf6RzwPQAz6Xpe2lx+EOCg8huvQGjONRS+Vbjrtyb3iQA2QsDhNbr7RyJXqKt+Cdqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GE8WEnRTi1eHZYo6wB+KDOGoFfjvbNz7PAU+7a1m/ws=;
 b=WSuR9YuzzVNLEL1NUqRBHDbNkMj+Ep3PbX5id+SA5+iZA1q7Mr4VsOT5kfhIoqxaAQaQ5QdrqTRyAkteaN5ZF4wTVIdLriZLahx3vHwI4ERQrzCVCl5efbVJBX8Rd/x5H4it14azECO/qxobr3V4TmCQu/9nYG0bB4iIwb5Afvf5Zm4pm1wYL6MXPe3kfC0K/xyzxW1KdTtS8hNl6+3uRlfE8mceNRPUpXYGGegIYd6oq3FnTDFbVLqroixNRy3Y9n0q00jvpGvriwx8JS5y0KB8mgcXObrli6nLO9TkHA8ysp+vdTvdEvqFk3Tn/HXBi2p+sKZ4Wd8xh1o/AqspvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GE8WEnRTi1eHZYo6wB+KDOGoFfjvbNz7PAU+7a1m/ws=;
 b=uYFp3vbsmOo45bNiXupxjV3kSmTui+6fDZ8J0Y5StWtTTxRF9GZJYaAHE8yJp1kj5Z9Yh3NvlTPVzU7UCFhsjjV4YkCPH/F2cb/GLSwy3hG5D/Mo2S23Cz7TK1XgDTJabpMteWRDR4UNvRcTeFMJgqe/VKyLLg7ZsLdr5dsIJ1Q=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB2683.namprd10.prod.outlook.com (2603:10b6:5:b2::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Mon, 28 Feb
 2022 02:40:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0%6]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 02:40:05 +0000
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-scsi@vger.kernel.org, patches@lists.linux.dev,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aha152x: fix aha152x_setup() __setup handler
 return value
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h78j7lz7.fsf@ca-mkp.ca.oracle.com>
References: <20220223000623.5920-1-rdunlap@infradead.org>
Date:   Sun, 27 Feb 2022 21:40:03 -0500
In-Reply-To: <20220223000623.5920-1-rdunlap@infradead.org> (Randy Dunlap's
        message of "Tue, 22 Feb 2022 16:06:23 -0800")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0057.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7962d91-c5ad-4cb6-dcba-08d9fa63a0b2
X-MS-TrafficTypeDiagnostic: DM6PR10MB2683:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB2683272A87066B934B3063D58E019@DM6PR10MB2683.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zZTdW5LE7l4DUX4YcqYIXoR/lvuX3ui8n03tPvuNu7u2tPbYJoOs9fwGRFP84wEC3MWRIc6OYFBVajUQhy3XeB9oL+8e9xM5rimzKwg/BN56sdBlThfTY7cXnJ6FWh43Q6rkMnLmaSeYukFvPglq2y+mspAVnLFhx9mRa3ycF/+GmhwmnHbZzu5d6r1k6AsmaXq2/3bnNKvFE53ARfOVjr9pG6T+ANKioy2W6iDz1jy5OEeq5ufkrOLxA5ZxsvvxCREj5pEd//3AVKw3XfwQtIA3oPAFCjgf57hbKVxCvgq+danYDDfeXfcseDJ2EkR1pqFFjgzvqUPt8hW0Bbcaao/yWsjhVnRQF42ukhalnHPL4xTryMvqkYAOw95sf6k0G1GPFdFi989PqUbME96XNus5vdGzsjAGyrvk7cMmXJCOIHbi+frF3PpkUkksRX7ztMlcKRcQThZIrPfI/zqgRg2P0ne+BZGHcAuck3RzkZjveVLTSuB7JwtYFRLHn3JuqADaJ3B1VQnvHqNfS7ka7YcPseIw9wwyNTCWOW08vLzZDhzwSFbiD3wb2R35SPHbQYzEnOTuFer1GRZINiMwt/sId37Trktd4u9DS3CMfq+lxOsTAGXFbcw0zeHu6CftYiFzNWBRnTY+IrUl8iaEl/emu9N1nPU7P1J2Rr0Hc7yEIVLbvi+xR2xpVkgY0jDdBdo1HF0rvVWrB1GGXze93A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(8936002)(2906002)(38350700002)(38100700002)(4744005)(107886003)(186003)(26005)(6512007)(6506007)(36916002)(52116002)(8676002)(508600001)(66476007)(6916009)(54906003)(66946007)(66556008)(4326008)(86362001)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kf0Tbax9B0aW1EmI65f7y/9tAeTTLfRC1n6LbOfM8cCyg35ot4vgsLmWoetD?=
 =?us-ascii?Q?0C5Hu9R/iyJWuPsO39COo0rQLfi46Kc4Kar3z056X15OdctXjqX/XhapU4Dp?=
 =?us-ascii?Q?YM+fivxAs/CQbgC6O8BMrkzdXc9heVdNxj4BHTGyUkpDIStmgOynfHmA1Plx?=
 =?us-ascii?Q?Usmml0GdUWVD/DZdYog1uZps8VlvbQ14Lk9fKZEXQaNG6/vpmEeeQ/m8ctzz?=
 =?us-ascii?Q?JRigMFzcmwRKTkm1ck/ZOnS9El0+DyOyzst3+Tm6uZ9q+bcuqVyhb/Z14trz?=
 =?us-ascii?Q?gQ49XU2/5e1tNh85hXmSxFjqDZYotBDqvmlq1THW81lyQO2XtNEPEIBRcJdI?=
 =?us-ascii?Q?mjDsYWf49QSHmanApKcTSYDDH70rdCP7FKYV0qy5wzpj9YvED1n3Cw+ZoOK5?=
 =?us-ascii?Q?1tqVvJc+TawudQyevINRhxb3TfYWFkQseGlxoj1fFKbU9oInqU30eqg0XXW8?=
 =?us-ascii?Q?jtFG+kcOiYeM9hESbCg4iFF3mB223e3EX0QxzTY2kvL5c5wgn2TUzkmYGzez?=
 =?us-ascii?Q?u8Z1UoUPneIQGsvDY+0CdHaMNab2R3eIwHItt+YSI4gwI7TJCwMsT28oGTFI?=
 =?us-ascii?Q?zVbD8AbBIPGzTy5Icbb+tIIn+vHxfzYS6WJHWowwr7Ilg6Ln/0U+jYO+3uKw?=
 =?us-ascii?Q?21lPfNS2fyO7lEvaH0YCEUhm5YFB07jHjTYNpDWDjQFbccrrG5HM1DaBSCl9?=
 =?us-ascii?Q?F47koolvPnGavPfekz5VLp0GvnU29Bp54LkJCzk41DtXOfHddex57wbt4BFL?=
 =?us-ascii?Q?bssWsxhC+PP8Q3nIURMduNSXOfr6FyXePLfXfnly3JPIXh0r9dxYt9FHt+KB?=
 =?us-ascii?Q?Jn3mjOsGsJ/w+r0hv0ePJnBNjk1Zz5/XRCsC2Ku7rRQILYEPJdW7SmiesQYb?=
 =?us-ascii?Q?aGyiYRLFSQ1sBQYIWWCBV/Qikv8lu21uBrJJ/L0v4kN+P1QnB8hqBPQyHlNM?=
 =?us-ascii?Q?2IFdS7f3YtKJljBjyXQfdn6q6+KA3dxmTnxWYDahVmv2Rhy7qidO5WkCwEau?=
 =?us-ascii?Q?399n4GGyvC55Eu45EhWL/QoTTMlqIfOWOnvOoOKqdDqd5bvd9JRCA8IyIHaX?=
 =?us-ascii?Q?mTx60m+sSPlapMIkjBAXFuXXGeRzg7lL2/2gOD72xenBI4mMjtCgWuzCXTyP?=
 =?us-ascii?Q?JGLAKMeFTek0XIuupiXKPYhmUv5tnFuw+f9CkyulP7d22cwr8lhbEbtjNESE?=
 =?us-ascii?Q?plaGPbf/ucDK1tT7MpYsScc9NW3NmAEFE5K0tGdkZfx6wIUEa2oKhOLJChuy?=
 =?us-ascii?Q?74q2FntbvrK+9DmDhecsAB6i0vhIa8jOv5eW7N5I0z3GV0Y129o0zetEhwOe?=
 =?us-ascii?Q?qByYEZ1skrtMqQpj1GpHEl2Ts3DawWIC0hcKrBnWHdFVcWxjENzBmagm1s0D?=
 =?us-ascii?Q?nSna4sKFu6wGEoemvFL9N9Yh5QcdQIrkHWYlBGqa2+d/pl3EVTpSKONrAzYf?=
 =?us-ascii?Q?/vCre6D5cpTOEkQWJJ38vcn/E++U0eA79RhkFSX3f0Vmd/NTKpMfjsVTMNq1?=
 =?us-ascii?Q?JBnSRMJwb2dGH+CUAoHHaCRUvpOcoV8+bpmY4AvqROCt/h5z97cfuVFfOGng?=
 =?us-ascii?Q?iZr+IyOtjrmiFDUvh0xGNcMrhN31FkSC9PVMTl/mtRSi5BG9DshogMdrwDO0?=
 =?us-ascii?Q?AgTnp3DXiLHZ3LFPGbLEo3LWdo799Zg/ElJWaIb7fHrR3o9XFRXuy00LfoFX?=
 =?us-ascii?Q?FnteyA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7962d91-c5ad-4cb6-dcba-08d9fa63a0b2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 02:40:05.6606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KPJEM6BoSx/Vk1MT8yHnh22qV8WZOGEvK62ODIY4B5WKkT6Gt5G0efSfA8npZbu32AzQ+rPYaYCHNS4ivfY24MxjL0BBQ2FX0yrF3TZoP5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2683
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10271 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280013
X-Proofpoint-GUID: Y9Btxgf0EM8yw8Uvi9sTCZEub8hlkSQ_
X-Proofpoint-ORIG-GUID: Y9Btxgf0EM8yw8Uvi9sTCZEub8hlkSQ_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Randy,

> __setup() handlers should return 1 if the command line option is handled
> and 0 if not (or maybe never return 0; doing so just pollutes init's
> environment with strings that are not init arguments/parameters).

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
