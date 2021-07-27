Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 354D8C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 02:59:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1128E60FF2
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 02:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbhG0CS6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 22:18:58 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:11350 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234410AbhG0CS5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jul 2021 22:18:57 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R2vH3V005342;
        Tue, 27 Jul 2021 02:59:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=GqGGPxM5BK2Ohejx8Q/Iw+WpsLuEb/CsnA6RWynVjPw=;
 b=wYHIRv4YV1ZwsxToGJebIqynp1gu8KauWlIymB/e6FHLmvoR8EnHUXenxpNK+WDbtwwF
 3VncaHo8pFyD0F00Hf6BLCIwxKssqv2b9dvjT0LJwpC9N0+Pat+NFy+SGz3XqRkyuhjM
 YF+tweHCs8p0MMYduhwhu13yCbcqpQes84IcX3vOTmoC/9OUJPDIekvywhnvR5VEwKRF
 8tZjm745kacvmP8BorN+2qtMdG009Mnfsudw9ggti1IXHZJfPhtls/cbcK3QsH/KBMhB
 0BrMSmvC8q6Blpjs8CiJNIS9H2i2epBJL562CD/6XRZe4TSpSQNXEBJEwBB+YKjpBA2J qw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=GqGGPxM5BK2Ohejx8Q/Iw+WpsLuEb/CsnA6RWynVjPw=;
 b=gUiTUMwPWDOAFSd+imIWyukSiy3Q7+6XlRMqVffVc8jYqcoQfIMFG4FdMDHlIQ2FgaTO
 aDDMlqgaTdg5sLDIiFYih1Ibi96Mqq+/MTE1ZJVBEA23J74V5Mhu6XX6YnwCWR+RoM7s
 8S+2TDAJW0jynMos8nbcjL4NttBdCwdZJEhXVspAh2WE4N6s4Ex5zrKE5Th9pOg95NqA
 /JPDGFnWo1UpvrnDS25If/i2P8gEdcQKwMNI669LzWgabYk9LaHhOTDw1qxUdqBp7Jxi
 OKK7wl9yINy5zJhZr1cIrgUo8XbKhq1h49h/t7Ed0Q8ezQ2dS0lPg7tzlmvwf6b2b8eg mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234w0m1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 02:59:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R2tgbg153242;
        Tue, 27 Jul 2021 02:59:24 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by aserp3030.oracle.com with ESMTP id 3a2349k2ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 02:59:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QajDenH2qe+UeuAmRrMvy4mXSpBYy7YqYRV7J5ghOFDQKP1Ly27nz+KqPTCBz9YZGhwWkrGr9MQjIGKavUX0A2hpvkX3wavSvRes9Zx/DqL8RRtcA3JtL9PALn65oD8rBqA1vHqYFJ7XKxSpl6VBmLVLqCgvVb+xpM6lf6tz/a/tFf65GXERGeTE3UFPJPYvZEfG00PLXqMtrW+bRab3lLbaCDO1IX6BfZVdpytG8FBPzpT0A1fQ9857vTCedHxtDrrCFs/3QCLfsrQGihIPoggL7S30H2InB/w6BVyyes+ZzmgNkgJR0ST7bDE2E3G4cgTYWqoAgNi7T8kJVYBEcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GqGGPxM5BK2Ohejx8Q/Iw+WpsLuEb/CsnA6RWynVjPw=;
 b=GBQzjtGpPzKb4AaH1qRNm6Q5fAUF5PE62O/+dgXWVRU72lhECshBi4F3RlxYVcJZ23wvs/r16uoFeOaYNJEiERFRVjm9Cmh6GiQw8ynXURODuMNTUYbm9D0ZmLI9EVXNrwTMoEfMpJQOdCCD4j4E1H8QnOaTYELbW5qTxfsXn/LX7jxfi0oX9IlNVy3tJ2Gfsq1Pk598EN9cEWPStGceEUtI3XZWRaAMyftMy/5MXYd1k12ooECa5rOhkabY4ZMAetFjVYno5KEyFMl6B6HWbDfhR4B/ig5l0O2YAMrYcoStSre8kmXUorYLfGjxEKtVXOLg5sxL+dZFBUw+r2Sn8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GqGGPxM5BK2Ohejx8Q/Iw+WpsLuEb/CsnA6RWynVjPw=;
 b=xTXSuw5t60p/OIGkXGI4XijnJuI+p/il95isfndi9mffmjj95JyUCQJum1o4KchnzKdEVvcZo4up1SK4qh9WV9zPldRA0qGC/83Dyvx0RaptC5KoKSVr/mEbHa1t82xYD4JcN9GyBV5pQc5JDhneHpL0G2yjgEG9rqwf/zHpoZs=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4407.namprd10.prod.outlook.com (2603:10b6:510:31::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Tue, 27 Jul
 2021 02:59:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 02:59:20 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/6] lpfc: Update lpfc to revision 14.0.0.0
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czr4sbr9.fsf@ca-mkp.ca.oracle.com>
References: <20210722221721.74388-1-jsmart2021@gmail.com>
Date:   Mon, 26 Jul 2021 22:59:16 -0400
In-Reply-To: <20210722221721.74388-1-jsmart2021@gmail.com> (James Smart's
        message of "Thu, 22 Jul 2021 15:17:15 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0005.namprd06.prod.outlook.com
 (2603:10b6:803:2f::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0601CA0005.namprd06.prod.outlook.com (2603:10b6:803:2f::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Tue, 27 Jul 2021 02:59:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77c821b5-3385-4156-580e-08d950aa87a2
X-MS-TrafficTypeDiagnostic: PH0PR10MB4407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB440778F9B12827698832D6808EE99@PH0PR10MB4407.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fbBVmm+KoZli9W/4hVZvHwXxe7mCCSRZpddlm+fkdBLpkUbpcTF1XKREPA/QSFkJ9aLGYHTKs7knYUGjwR3Ckcg++fdLGr2O8FZuxeTR0z8eCAnwwgjhjV2LxRcL1szqePQZOuw0m1FLGNw/7dexKLwc7Mgzkbgku+vFXEcpy98xQlubHmBTlm5kkJuXp21HlQV8ACjrpNNUVX+5GPaGBOlUqWMCj0EDPuqOpwWnWC4F761Jv6gkhOUT+tUVip2iQtd33VLyNu3IyRc0TW2AKr1tFVa+iaLSBH4c3m0/tKskeLXd/1ltcFJU36ibb7jUDToR5FzzPPpHH1ZrUZ2ZyWzgPu2Z0z6a/srpXpqMUJOOczSj4sqFyDxa8IJi4O4jfOo/QXjf69pDfLE9mpw7iuA66iaR7ybekI/LJtwV3vBmppQSzaLGpAZdPXwSex5IhjmwXE1pQOSE5fC61XM6OfxSNJ8OUfND931buLLUEinSk8T8PJJZz0a4ukeNdPg21RAUHGl77ehTZVwj/zmbGUYGg2vxAC+baxuzHCBG/VvSKCJFbqxS1+a6W3GVq9mADBrbqBy+PD69kc4xkWt/fr35dwp0tCqLfCLniE9JWynlyNYZkgUXWljQAvIkTxXBNp2RG9dslPTQXg2I52gXMUQkCjWRGDMuBj9h9u0vF3CFP9SQ5HfqD+q0P1x4LfS48sl0OrhgtV188CGdamrRjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(366004)(376002)(39860400002)(55016002)(86362001)(8676002)(478600001)(66476007)(316002)(66946007)(66556008)(956004)(2906002)(83380400001)(4326008)(26005)(186003)(36916002)(52116002)(7696005)(8936002)(15650500001)(6916009)(6666004)(38100700002)(38350700002)(558084003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WrrBz1yGNm2/Zp7UFbaCS7kEiGSEazke/Q7mfvkGskU6TYKo9vAC8/ZkK21k?=
 =?us-ascii?Q?RiNNK7tspogtUw2teGjKeiutlix5Ntq1vF0cl7IOG7IMU5WHD7QWeQzCz/1O?=
 =?us-ascii?Q?R1AhVuQJIluA1tG4mbAjlDSLoCI1jTpt2C19Ms7P7CWyQ3Y8dXZ2emqVuzbu?=
 =?us-ascii?Q?oSGGWdqA4a1jCqrE/+BCsnpolJmV/wkzkMhS2MHm+DuIl6D/Bzb0XO3cAj3k?=
 =?us-ascii?Q?VAsuFHoysAKAUK9CWS6UnsRJ5EN2zR0qwdI0Q4B2AtUA/WoqZryTz42tJWP2?=
 =?us-ascii?Q?TZGwYcXDhy6ir2ogd9CJyqYss9P+6JTvtJy13+VAePRQiQaxHPiYgzL4mnN7?=
 =?us-ascii?Q?AvWw/WEGX2z4O12fyHyhqUViCFg3txR5v5EWv1n+sfcUDbBXLhlfBCezlWLU?=
 =?us-ascii?Q?pDjzy7tUWwK6booIvHtiyCNyZv+anX41PZncGhYeI6GbWUMMNP4p9BlOKKie?=
 =?us-ascii?Q?4WcdZYG02XpLhhHbiqxWHngJ++Ga8TFcuwBeFsFNxBZ3cWsLFb7jQYQy4qPj?=
 =?us-ascii?Q?8W6Ex9baVoZdqH1QbnBtV4GTly6jKPb38LrFlbNdKzvY6MuFCYKeXT91mtCH?=
 =?us-ascii?Q?6d6MexulrdQjVLTaY3zRB0leTUJK6IYiMRj4/fowjOHbkTuJGd/qTZ0ssPHm?=
 =?us-ascii?Q?aBT8WefFzKhSui++0A8lLeITU8wGnDJ5b7HTFdNoa5bT9Qcl/sfZlCBO8MlJ?=
 =?us-ascii?Q?n7oosQY1aWCrVxCGa6SFzRNbJHvX4r2USVlnwFr36trByMeXn+sk+tMV/Q4X?=
 =?us-ascii?Q?JkmSI/K9Vro+F67RLoMjBDUJAVLp6DG8j1ihzZJIMuCsId8m76lhEmGSeRUw?=
 =?us-ascii?Q?UbmXPpWb6mK6RV0P36BdgbbXHsVOrxCFw7OLGN8tIdt64E/4HdZJlds/kVY6?=
 =?us-ascii?Q?Rs+pRsFsk25rA+fMdVJcfJ0Z5Z5xzYv3oRha73wK3hFPHiEyB0Z+oSTP+35C?=
 =?us-ascii?Q?HhNezRL1taqXhWcxGBKtBPnZQyoo1w8dWgiNs5Lyz3yw6kC9yplP7P6Nd5sG?=
 =?us-ascii?Q?YAEVt0BlmQE1ztE7J2W9i/ZoV0ikyyTxNJQzp9+3/FkdhleK0l9B5b9dDEV2?=
 =?us-ascii?Q?lDyPACsidP2cZu0mJbNca14JkV2HA21nAlWwnUjqo25L1laXEclhmdLyGs6B?=
 =?us-ascii?Q?EIAQAY2YVry2FxsqbP91R1HfrYtacEufDdIC3OPtKGfTACztsIRqPcdhfvsc?=
 =?us-ascii?Q?1UoWxk/uvc29LrVkUQWCxDSaV2M347OV+6R/WxG5y3XLdnGoHxnXXmXmBqFj?=
 =?us-ascii?Q?6v8Uhbva1LPjHxmf8VybXGem/vXiH9YmnJ/ar71VVTENFOGHi+fc7odSnodL?=
 =?us-ascii?Q?O9JGmuujujHayQ9sroOE3/hs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77c821b5-3385-4156-580e-08d950aa87a2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 02:59:20.1146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5rWbj6bzv7C29lH7WezwdZjVsA17n7ap9X8BGGVeo+UDOx5X61c49p1doSyvpwAMaXzwLsusiWQCtznmaTmXiyNM8ggg5rzEhkMS3IJydNM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4407
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=928 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270015
X-Proofpoint-ORIG-GUID: K_taBsQc8lW7t8nwgzR1QtMCgufyZTVQ
X-Proofpoint-GUID: K_taBsQc8lW7t8nwgzR1QtMCgufyZTVQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Update lpfc to revision 14.0.0.0

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
