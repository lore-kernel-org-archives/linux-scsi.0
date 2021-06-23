Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C41C48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 02:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F6366115A
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 02:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhFWCoe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 22:44:34 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:60140 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229890AbhFWCod (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Jun 2021 22:44:33 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N2auLc018519;
        Wed, 23 Jun 2021 02:42:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=74rxN2m2C3lGPvbMgbae4Dx103gWMa2cFFdFXRcb2hs=;
 b=FQYwfsvaOOj4aESMT89W1Y4iC+AeBnkQBPCnVuf8uBJqwPy//MUP7Oo4/x3TXibaLZGL
 BOC4YFrldP/9U4i3qiHXs+AcG2A+o835vJ5NQrETkVm5u8dwViTAOaNF71UbU34fTszy
 XaVKY9ag2g64jG3hMWnju3dVkiI0g/LhRkJXEQlFAuilBqiSIDOj0M6SKTt/XeOYFXgP
 dyafbrTJJO153q3rY/ZWzTYRxCaGcxXcmdaP5mHaBap2CRFCWodP7w9b4qaPnJAEYt4Q
 hNub9Saz6IdswaYdfaGs4qZd1XL7/RWIw/dTeemHe5216OSD1TqlcEYeGddWKl7vQx32 bA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39anpuvvp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 02:42:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15N2Zraq002545;
        Wed, 23 Jun 2021 02:42:08 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3020.oracle.com with ESMTP id 399tbtrasj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 02:42:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKnZ0KVp7leqtUvhNxkuFlrTixHyghx6WzqMJ211nfKkOyatIjNIn81sORmEhuMFZFUpRUrSqS5HAP/CUwOifVhEdZOtChtBuaqupdY0oBo7azPszPiEFioBn238fZZ328DpiaeaufUQhmUvbrWB8RslDQuwEoFEBPfGn3gI8yy44PGoGJ9ppMe31he62+7fMqioH+immtReCrDFiFwdk8ZpPl4u9//31SM+lkbYyTst4tLaazOuPeYh2GPA/7dbAUVajGWZ1tlQv85IBj8jcm7puG1y6uWJrSbcRSR22Gu8xcAJ39DHZ5EXlWyOjJwGXGvExKKNwoLJtU8TYzQxBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74rxN2m2C3lGPvbMgbae4Dx103gWMa2cFFdFXRcb2hs=;
 b=W7XGWxq03H5ueLuzsNibtEOVPS5guP+s5ZptW8t9sQqEPxQ6OlRPznEXvHv3q7ecP1XqnYyy2toVCwiAkpuOsjq6s6p3Hz5bYEItI4rLCMl4lc7NZHVtompQ2f7Dj6UGZYVm7434ZMm7w3r9E1EhvKzfmhnV9VZXTC83vnoBPX6zYi/DWHuj+ex55K7JLXQD0eXP9vN+NksMMLNqhir1wD49dNw+retsd7ZF8fqb7IHPwC+36mLIEdMoEEDwSzopODdDpAqzcmsXOBzpNzd6SqpUJBbmJqEOlSDLR/MXVy8r4682cO9/asJ5hhKApuHB5OPOMr3zQYaV1lxt2AsX9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74rxN2m2C3lGPvbMgbae4Dx103gWMa2cFFdFXRcb2hs=;
 b=WX16agwlDEX9jWh71P4wFX/L7F7BRN7oxKsMsUXI0TktbOBREFV6DRPpTH36lRlX1fGS0cUS2FZ1CJpg3mNPN7yar3kXHan5mFvST0maa6IGvgFIMhLy2pOdWvdrUm5/XBFOfTyfdL6N7AirLs34wCmFU+sCuXZF5g3S6GDwcEw=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by CO6PR10MB5412.namprd10.prod.outlook.com (2603:10b6:303:13c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Wed, 23 Jun
 2021 02:42:06 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%4]) with mapi id 15.20.4242.024; Wed, 23 Jun 2021
 02:42:06 +0000
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Sumit Saxena" <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "megaraidlinux . pdl" <megaraidlinux.pdl@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] scsi: use DEVICE_ATTR_*() macros to simplify code
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsx9qp3i.fsf@ca-mkp.ca.oracle.com>
References: <20210616034419.725-1-thunder.leizhen@huawei.com>
Date:   Tue, 22 Jun 2021 22:42:02 -0400
In-Reply-To: <20210616034419.725-1-thunder.leizhen@huawei.com> (Zhen Lei's
        message of "Wed, 16 Jun 2021 11:44:15 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN1PR12CA0082.namprd12.prod.outlook.com
 (2603:10b6:802:21::17) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN1PR12CA0082.namprd12.prod.outlook.com (2603:10b6:802:21::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Wed, 23 Jun 2021 02:42:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83743afe-172a-4891-8c3a-08d935f07d5c
X-MS-TrafficTypeDiagnostic: CO6PR10MB5412:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB5412F4AC05504346769258B28E089@CO6PR10MB5412.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VWKJCXrLPYyhEYB8F7dG2QoxVrC4o5ee8SXA4sa5NrHwtf8io/cJMKN9WLt9GAof0TmcFnzbjNI7kZRF2QlBuMWV2bj38d72CzR0BaPQRvCRTK0sbY6NvoEG+JK8HsA3IRPb3PrS1vXWzIS8n0tAZ/tLMV3hJsa9MzDVh/TvDs1nSR2VkIiJf8aPyo0fOEHJJz5k/xqrSBLSxs7LpzAje5DTD3dzmZDpEwfaIH+10/hyUEzXG1cfdd2oF6al3MC1UYHiJKm6CYxKC92NdD+xQ+waQBRJMUGlu8HHQIev3uwLwMaPukJOvjn6GviBznJ08Z3+4ts+GW6MTkfd133kDQ4RuyiDeFr/CbsLgbGfXbCQm6ZDdhKXqxzmOJNW9/J0HLYMiCBefWIX2x4yFsNc4doPmKD8VEiPdxBrw8//fjgwjLkvVWEHPUpn4QDoZSHa2mV1Ves6IGrqvLmN87UvXT65S8ittbcfBbWyn19jVeb759eALCb6PvVdFbW4TmnV8GHz5NkIxPHHBN3hvrQsiZjpB9nrRbLtaUFsE4xJdtLzdNZ3av3wNKJzBGd/iDeXoWG9/00I+jWDjadkSYilaFGMj7GqE+eQTBml+fdHUjDaUtGcASa5cUQPjDXv/hxoRz3f3ixErwrT9DeOEoQRZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(66476007)(66556008)(83380400001)(66946007)(186003)(52116002)(478600001)(7696005)(36916002)(16526019)(55016002)(26005)(7416002)(6666004)(38350700002)(956004)(4326008)(8936002)(558084003)(86362001)(316002)(8676002)(38100700002)(6916009)(54906003)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C1uZVt8z2kGIVh2pQbNRVceHrn7RYxNbgRaZcbhahsChPfy9aT4QN8zeCeN+?=
 =?us-ascii?Q?VgbKGiEw3Id8tr6ZEX98r4jigIL3u7YB4t3suz3dYFNTQ+P/0c8kL7lz3nBD?=
 =?us-ascii?Q?9LwFiYp4fAcLktnF/7ZQOVlUVyRdK2TXyneoZV9bg2ONbFnSyCEq+KbDe0Ia?=
 =?us-ascii?Q?KmazkSyDazOynTGJip1PCaN7Rf7B2DU+OCQaPiJ9uDCiGMEk065xjH1J0GfA?=
 =?us-ascii?Q?6/eGbObYI31r3mzuT0M1jkIAkQNZJo4FPmZyg6z1PXyFx577nJLJ9gJPkjTu?=
 =?us-ascii?Q?2nktgT6phGZ0lJ2EVCGp6AZy8LdZCNZe2GZ3uhNBFBkgZVLtOtHLMNYiqL4U?=
 =?us-ascii?Q?e4wW2gV9BJio66gq0oF3NsxRJyjzOdLULfFWDkzVeyVMhqrOEZEr9P3GrAa6?=
 =?us-ascii?Q?qPiQ31fGOW1oVxOLm+YG9ezdMQlQQ0yq7Ykg0RWUYX73zE4r2Jp4N1Oy8ufl?=
 =?us-ascii?Q?qJewdz4ILQqe60CYD0Z2BIW2hq+pYDbbyBlruEB7B1fnu3hmbfn7xoUGmIoT?=
 =?us-ascii?Q?zmEBl4XVe5xcwwX7iv5/S4bHKicxu6Ayb1eP1NyR832XOsxO9D4+LlWx4p96?=
 =?us-ascii?Q?y4Z7hI+u7di9voUAFPSsFwAduuWRXGmlecHlbRSKDXHPq+Wk7FA5KGazZZa5?=
 =?us-ascii?Q?ICP3xQfOUPVLu6YUrZkBwvw56UzD/y4Tww29H1kZTBu+3Gp8m9Ubjn87VrXP?=
 =?us-ascii?Q?qt2Noe0DLcfQXZGs2FgtP66TfU9Pp5d0Jpkof/W4EcMPG/Yx8vlwQPwv2+wS?=
 =?us-ascii?Q?7Qpn1Mu4J0SAyDWgpC1Q0+3WLluSLUsZvO7VG4ScAbdNdT10a9/Sya7S48qm?=
 =?us-ascii?Q?/yWmC/KqM5VJPodcQqqsz0ka/5iOjSzcCGF1ZnGjX0qEpY+4g4OGGK9mpKBE?=
 =?us-ascii?Q?BVpGhs0p0W7hmHxjDAtbOblf6+5f05OdkhdhqrnNGn+sQMLIBggVSrze9VkC?=
 =?us-ascii?Q?MNvrEgQ/+zs1D4ysxd6GLVWPCjlwbK03+0l7xwwdRHe7VMQuGTvDa+ePWkvs?=
 =?us-ascii?Q?NNjkzdvg5nPDJABxjP744c6H4ZN4iplTtwleDl2KjnQyUz6x1d2OKJCMjoe/?=
 =?us-ascii?Q?qWCn27ix4N2ETPyrE9OtoyXTu20VQA+k7D5JZFkuPF1emjZvhXOgFXqqfo+n?=
 =?us-ascii?Q?l0yexW3CNvRAibpDmYcBfA27D85AnGPuBWm0D9WJUsU7+vuSwpc85RP6LWKp?=
 =?us-ascii?Q?yThMbn3vUWvewjypj0o4333fMcTvtSVv30iNW4RQcwRJC4Psw9BPaZQf73Tu?=
 =?us-ascii?Q?Ynce7zREsei+xxFlPDa0tcTDVY0GdcyUNLrJadISn/5LfApsStB4AgLl7say?=
 =?us-ascii?Q?7Y7AE5/XLQuQkx6zc9hASkH4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83743afe-172a-4891-8c3a-08d935f07d5c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 02:42:06.2600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7z1dEtAre4NUmSy/xMvl4CIrMUeWC7J1h9vfYW4evM3RVa0FXG9W63V+/UZbriBKLRTzd4vG0UXX807rs7PgAxfrui9bhq0eVLLhJGyLuDQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5412
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10023 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106230011
X-Proofpoint-GUID: M_mQVSLJQ90EjcyfZQQW2fCI0KARxszn
X-Proofpoint-ORIG-GUID: M_mQVSLJQ90EjcyfZQQW2fCI0KARxszn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Zhen,

> Zhen Lei (4):
>   scsi: qedi: use DEVICE_ATTR_RO macro
>   scsi: qedf: use DEVICE_ATTR_RO macro
>   scsi: megaraid_mbox: use DEVICE_ATTR_ADMIN_RO macro
>   scsi: mvsas: use DEVICE_ATTR_RO/RW macro

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
