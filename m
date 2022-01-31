Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A78C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 17:56:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355151AbiAaR4k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 12:56:40 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18936 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346358AbiAaR4i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Jan 2022 12:56:38 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VFx2lT031412;
        Mon, 31 Jan 2022 17:56:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=keQVW9xIE/QT8cb1v6OIIZyx6l/USiVQrT1z22lMymo=;
 b=anSsYZr400P4A7s+Lx8ipSaiTFsHDciZ62UH+LVQa1HctEl+BczHG9icjCvb920AbOO+
 O6ywtobHR+O2fm5dkQwsd2NsPsIrw3IoiUXDstuPQNtluhPdEM0pFmlOjvIapLx4An8+
 rvXvjBeHHjdGEw8vOvZ8j4U1RhdZzr+20/d5o1lHXJmdRdrNjOZ0AZr4YPz6Cot03NNj
 StLTjY4kE3gbofOf2L7EDdhDJeg9PmWPD9XKsglwHPMk+jaKoIoYY418TSY9vsAb6rm5
 St6dsFb6cEr+Eg2Kfv7f5SEAKmG5ln4vYNhHtllfO6hLspGqHhU1IJR1k3nrmffi1DC1 4w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxj9v8jf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 17:56:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20VHpbpA158678;
        Mon, 31 Jan 2022 17:56:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by aserp3030.oracle.com with ESMTP id 3dvumdy3f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 17:56:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6ALxKz2sJkgL5KUxdvr8lOy5/5e9DUIPlCgjFEfyodTwku5KC0Haq4dsz1b6q4zFRwT9j7uSfqe6QcLQ1HPlFKcFc/Uq08KySPljRWXv0GbiIUxwu3WlKlT5bD9wmhb8Z8If/83CIMO+nrAkmygtT+h2Pbpah5WdCeqSobPXWv4dU6VK1zK6Kb3kqVUsk0o9+P+pisGUz7UmKpYY0Ihttgsc5vzimhjXBtsfLM4Vl2c2phBN91TXYIzxOWa6V87jmumOvqsYxb867SiujJAW8CgIy5Q1NoQZDYWhfgqTGAqSA6CwAZ1xjPbK/0+06uWOL3odt/Cfi4AKBh+ykG0HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=keQVW9xIE/QT8cb1v6OIIZyx6l/USiVQrT1z22lMymo=;
 b=OvJk6aRPH6Ho+GlPpDcvWTnVT+BG7dvcyYPYC6hOk6QswBqBFjVFWrDjJcRow+lzkutTWxoGAsYgfLgdnhh9qOVHtBQr4Lr2PnI5UOpFnsfv/PDEFn2Jfnc0vWQQWx+YbV2vYT83PJHfd7q3zPbs0rTQV21jvpAA1X8EFa4Y1NErQcX/mQrEl5ULEM8nb2d129WyL78/cUq8SXwuGlYIkMhi56pW+iZ/HnTmEvHgJvG33wAV0bWX4EmkxOqoiZgYS7CGMWMKXIEwbLFH1NSUOHT0ODpefFqEgo4Q0c4G8zHk41tuznA6XQl736Q597ROnCx6vdxVODImzXdII4yMBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=keQVW9xIE/QT8cb1v6OIIZyx6l/USiVQrT1z22lMymo=;
 b=zW7kPK+93DM/ngSuPCr3xkyddwqbH+hJp4FZqOJiivSkOJJKsEqWZi5H+9Jd2QUAl2hYMil4ksqtaxsovoapN7H90SVlAN0dF+AiUHOwJ3fPnl/K6QKLwQ34yv2jPh6c8AFiBHDJ7b0oxp2KnV0QZ08HXWKPaYg71yTzQKYIg34=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB3066.namprd10.prod.outlook.com (2603:10b6:5:68::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 17:56:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1caa:b242:d255:65f3]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1caa:b242:d255:65f3%9]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 17:56:29 +0000
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Martin Wilck <martin.wilck@suse.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V2] scsi: core: reallocate scsi device's budget map if
 default queue depth is changed
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ee4naiwv.fsf@ca-mkp.ca.oracle.com>
References: <20220127153733.409132-1-ming.lei@redhat.com>
Date:   Mon, 31 Jan 2022 12:56:27 -0500
In-Reply-To: <20220127153733.409132-1-ming.lei@redhat.com> (Ming Lei's message
        of "Thu, 27 Jan 2022 23:37:33 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR18CA0027.namprd18.prod.outlook.com
 (2603:10b6:806:f3::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f75edda6-66b4-456a-8311-08d9e4e30229
X-MS-TrafficTypeDiagnostic: DM6PR10MB3066:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB306634086A2840605919C6858E259@DM6PR10MB3066.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f6lK4TrdVDC83Z0KJOM/LTAoueCUt0O7iBVR6EVwmYxK/CbybVR9ZeI3wvfMwhicSH6218ok/5UimL0aS/aES0pmOVWMy9A1skwtMLxIbkRdbJMQ01xvaX4lLNAo9G4TwWU1cQAKjuU83EUsmJmw31PcHhh6Iszgt7pukSWXSPotomJALx6iK9e8wCUlnBD4dwfg7JuQnIQhRb2Kwkv/kC4nqYCVZP7A7Gm3nztRwfiX2Yvk8FeWHNv4bl0AkO3+60Qr5ni+/nvkIis4CFsgq1uj0tpDaxcHH0lUIlwCPuigeeAAY666v3jHgZ7pIwGPqdXm02mOoSo23dRNxL1i40769pueTL4Gr+EkymhEJZa4SgBzQxRvV9dRF6Lzy57P3SAozSqsJEFNdohK8CJ165XithjkcB+W6DwomrihHruNN8xgsex0OIjJ9lyI4Po7QfkFJCfFf4zkTBYk40hOQdtEmafs3yltt4dWL0VzaVkPrZR5JCISMCQ5M0jEG3GN1dZYIKwJf14edIKw0KJb0+SkrGyERNoEjtdSRPAsqrArIMheCozp44usQYVj/PXhbjO9w21yVKgVf0bcDag4zW4H7QpwoVmPa7OTKq9ffopHmBWq8sYsS3qj7X8kpNPRhM8v343ydUn1UxkjxOX1apWPWF9o1XJlKO4fcR0dkgKqStyZbnNYwOw3ltsPVgERRpbpyS1kV7o85JvXoiRkXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(186003)(38350700002)(6486002)(5660300002)(38100700002)(36916002)(6506007)(86362001)(6512007)(508600001)(52116002)(316002)(6916009)(8936002)(4326008)(8676002)(2906002)(66476007)(66556008)(66946007)(54906003)(4744005)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b1bIPuwK7yQNyIe2x65Tr7ldaenVyhMJkJWNon37Xvz30a4YvQ7KjDjP9jkP?=
 =?us-ascii?Q?ITbUGk1jHS5uUWeJSmDQ6trKAGv4ylpphbsoICmHYk24vXcu0ALxb+KzaQfX?=
 =?us-ascii?Q?V40hSMt+wiOOTJIIcwLh0GyG9lYDBLuOirnnEktMaFPRorI1LFpdk0iLSCoD?=
 =?us-ascii?Q?ItNheYLZki0OeX7+tESErIP219u3rz00qvtuK/zEMDUAgMqS4Aj4g3r8NeVU?=
 =?us-ascii?Q?H1q5Ec9gmo6w0OkRZsaiNF1Ts5t/oY7PYy/JUf/vwyJ6tCNpKHex85tZJ0ZK?=
 =?us-ascii?Q?IXCYeDL+w/2gOy/fLFzdPEXMJ4aawVEHvJQANDCbF2K1iisTGJ3ToEovn+Z0?=
 =?us-ascii?Q?jkatOi+5R+CfA1tVz+5PEmQFRreO30merchpcfIuNOxIPmIVpPEju+DoXNau?=
 =?us-ascii?Q?va9LBNVF23QnZ2a8WQZXb8CZk7vU8iZGET26dWCpV3/vX4d1md854sc9H8A2?=
 =?us-ascii?Q?b5CkjEYW56mUvv8rvOMopX33m8kecZqjwUWEIFvyPgNTABjdZf5mew2x8Gbf?=
 =?us-ascii?Q?mgJH4YSoJfvwhkWv+dlCk5UG8sgiOpS46mK/bU0gHYDx2h6L2VMqLdIKEDi7?=
 =?us-ascii?Q?jtqvn/ByOlVXxW69ATafY1oD6xscZIUULARDn47RPKJTNgRz14xawQMc9ac9?=
 =?us-ascii?Q?UjzFfzmq2FXxzaPpwWw1b5lelnX+tmE8d43Y2h58f+xj1lzF7eWSrR/7ZZdL?=
 =?us-ascii?Q?QYRjAGOAWo9Go7y1+L3a2DTkiAx3xCU5q5Eqq3NlHhTLqa0K9xyPj1YsN/Ul?=
 =?us-ascii?Q?fDbfqQhBYdr49OcEiN6r4uLntTg1MzqFU4EeBoSrkJd0/qFQcqGQvAezYxTz?=
 =?us-ascii?Q?oeFSwhjl20CUXwY6+jn7trBs7no00KJn4vuJ7lpRp5mOEtopQ/ZjvHrn+xJL?=
 =?us-ascii?Q?/JSg3UyY1zAniigsT0CPS6oiMlwIX6yL6lri0GFv4zRulzhg3G0FHgNf7Qq5?=
 =?us-ascii?Q?iBNlNK9htCFw2fppH87lQRZlhn7MB3ctoFl4dnChfnfs/6sqeLOFa6end41g?=
 =?us-ascii?Q?oe8lgM8dppvbvemuUTNxbHcmBXoUqznq4DWOtCBpfWGCI1GFo/OAqnFikSZE?=
 =?us-ascii?Q?FPtNu5UI3njKTcs0FJgKuSaP8WjpV6zO04p8jOJ5H3a335Ew5Mg1EhVHJQMH?=
 =?us-ascii?Q?yx/h3eIYDFyDPdgcgE/cIFc2cVYdGi2iM3W1IJZPGZUf+zeGz0iQxfZiUI0c?=
 =?us-ascii?Q?lebx03pymKdR5xiFWFkPWCQkHY5IunudHlvrDRgyqLTRZAXqvdwj8EO4FssH?=
 =?us-ascii?Q?00jwINimnlSsRGtc1bTEHZLfxYUhvXKfx8L9DIulDMkuuuByYzUW77SqXrbC?=
 =?us-ascii?Q?/zuLdQwNVOoApPf6NpZrGdNfelZLpiiobCOSUV4nB+0xyL2Je3QG3Yu1zeCG?=
 =?us-ascii?Q?HCKX3d8VdrCmqvYTIxt+oq/CWsH3z4APZJ8AJMDPE6sSJqzhK7Apti8l1V0F?=
 =?us-ascii?Q?4bO31MLOHaN+QbUA0/UaKGwBsFdZg20/wPci29RWdxXjXaTszVkQLbquGwdD?=
 =?us-ascii?Q?pHvhwxEROjrM2y3zxUxWcrhDU/CWnLhMCLEwwA5VmYbsms+rxsVyCEut8qN+?=
 =?us-ascii?Q?l9tHz/+k8uI6+ECTsUZPL58E1ZpX8ceR2vEVoxR2GIE4qPfwTVuP1ClIIPWo?=
 =?us-ascii?Q?hEFtmVzb3iSysfXZFYWi8NU2j6N5mAxnF49uzsdy+Y8kTW4/WQwnzg3xJXUi?=
 =?us-ascii?Q?14jpew=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f75edda6-66b4-456a-8311-08d9e4e30229
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 17:56:29.6338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dhuVe4A3f+862b7/9IBEO2RzkuTdKiFHDQb+t6FJrRD4xZD2cWQ9Ydp/5kDDNgdplgrxAwkk8eBah+Crk/BxTvYhDlAV5VWMo1WSjE14kEU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3066
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10244 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=984 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201310116
X-Proofpoint-ORIG-GUID: 6MPSBqWfEf93h4rp8pwG7YwHKW8T35FL
X-Proofpoint-GUID: 6MPSBqWfEf93h4rp8pwG7YwHKW8T35FL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ming,

> Martin reported that sdev->queue_depth can often be changed in
> ->slave_configure(), and now we uses ->cmd_per_lun as initial queue
> depth for setting up sdev->budget_map. And some extreme ->cmd_per_lun
> or ->can_queue won't be used at default actually, if they are used to
> allocate sdev->budget_map, huge memory may be consumed just because of
> bad ->cmd_per_lun.

Applied to 5.17/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
