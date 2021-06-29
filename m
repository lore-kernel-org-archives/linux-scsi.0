Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C654C11F67
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7526F61D4D
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhF2ENB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 00:13:01 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:59970 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231244AbhF2EMz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 00:12:55 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T46im1014298;
        Tue, 29 Jun 2021 04:10:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=5FXy82TdBDPCZ78kXRTZ4mUC+jQsCiMdjqyY+hkoYsE=;
 b=k5l7TAkCAfN06PoXCjd5a4yW2w1BLF3xBZd7CBh1BKrG5nJ2F3uxCJB+ogzUPEC7ZQc4
 4MAbbDqt/h6d+AIIExQnEbaXnqdcT+zOrNCNaMgT5M+b/fkeopdz51F5yvTlpUtkzIU/
 szTMhdS9naDNAZm4OJ5ShfbAvruG1siWU1rRv2ash5JWZCtjGnO6djVo1YB0WFqDfOV2
 ffD85kTNtEntR4v1dBMi+s6+LPq/03LjVr6u2l4CWn/vArc8bhzc2rW4DygCGuRtOK/k
 JejxHho6eP4/FjtRkG5LOJvPcBAxorGcS1heLXqhnsINEd4sMwfeJFgSyiFjwJ4H/bgs IA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f174jpnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15T49pBn150664;
        Tue, 29 Jun 2021 04:10:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3020.oracle.com with ESMTP id 39dv24tfen-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CEXuNM7/VzitPuM8w6L/WFIY2CbqIiUkzRiUkTuIgEt9WIqvFwPAGa6VoDr6Vw2JVfAEDx62DZ9+gItvUNBsFctg4AOmFwpMLw4i7rcOFhwXFEjw4PdHByYogfoVazrjDoHOD2B20jBP9upb1OfbGPNVNsuF+PQPgF4cysNJvXWsEqRBUU1JgvJEn63mOgs39QSh0RI0fMoy3DyjJdwQ0ZVul+Ui/+vkT3QzvOp9UOkvCpYqng1J0j1cIkE86DYW+9pJ/lJebn6gVQ//xA/do8ai8IGTEcundbXqtZrmnS8Bfhba/vEJYUfi/ncCcMbxV1i+JbQKoofQqXU9U+kbLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5FXy82TdBDPCZ78kXRTZ4mUC+jQsCiMdjqyY+hkoYsE=;
 b=KMz26KLqCdQN0fqIoSkQ0WLfU/ENSoavNGBdRzSGwBqhqNLxwZn2bIdVLabz5grE9//fiSaZokvMr90Sj/6rHOVpkcnu76d+YB7Yy/O2kJ2T2IwqYuMmuIiyarb5hY9i7QWSFzpyM9hfzNOrPy1GpS6UE/+Cu6rJcUg8qQo2zUj7tY12rlnaoRvJiQSa+NXLP7qXfoKRc03kfSDGoTZMdyQOHStA9FXgZvA8DUuCcPl/HlPmyx4RqoS1MlZ8i+iz5c9PhQJFueMvTnHo6qsfhbEX2vC/XgrsRnL0Upb/oMfMjjPj95y9q2jgFwPc8EcEYEZQlkTvS4ueyfX76O3dXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5FXy82TdBDPCZ78kXRTZ4mUC+jQsCiMdjqyY+hkoYsE=;
 b=yo4e69nTLpMePyVfDg4s0kWrLjWUKO47wbpfh9EQ0WtaN+d0K5fAOlsUZAUt7r4U2bJG+SYlWYYMC5whfpielVkuIh5UYq026DhANSBfg3FN+WcogLPTKxsU0rPUffkfnisD717EmxWGAJJT7U6q/sPzEFojbmvHtpYKDmB3LwU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4711.namprd10.prod.outlook.com (2603:10b6:510:3c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Tue, 29 Jun
 2021 04:10:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 04:10:20 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Colin King <colin.king@canonical.com>,
        Hannes Reinecke <hare@suse.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: aic7xxx: Fix unintentional sign extension issue on left shift of u8
Date:   Tue, 29 Jun 2021 00:10:06 -0400
Message-Id: <162493961194.16549.11024974338962781518.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621151727.20667-1-colin.king@canonical.com>
References: <20210621151727.20667-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:806:6f::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR12CA0029.namprd12.prod.outlook.com (2603:10b6:806:6f::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Tue, 29 Jun 2021 04:10:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7157a764-a67e-4727-0fd0-08d93ab3cf86
X-MS-TrafficTypeDiagnostic: PH0PR10MB4711:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47116B40FA800366286503CA8E029@PH0PR10MB4711.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R3q4EltxjsvzJVTN6J/d4r4lWHTO4QjlfqhRxDzcKwdcY85f0Dx14Jra7EhhrbRUjB4JrSvbm1ftc+oM+cW8N+o+g/XjR3kYsxVkGhTfVIV1twSYGkeapoo/UEAV7wf4P/8jp2gJFjNEHKo5PO0ffvj5N3VNVUvfWbek3t4CcDunJkamFq8ntR61VFfM1SIKTKueLkSACWLpnnMdJgA+2lBbiGDwmRvi5mMfsgW4mdq/cku2z4kR0rGt8QCiuFMR/RTa9GJEruZK4rQJjr/v5vMk8/eaFv4ST8zAH+CuDaoMq/2URap6WE9zL9gsL+k4R+97evrV5RcJZ2LC3nGz5HB3JYV9SZ7fVMu82A9v2Sa0DZqF40BTAiXR+TXwDMlYD7vdCreLF16W0V6cVKvi4fIWur8GO4LumragMQFEGR63Px9D6XXCtu6h20xv8OgQfOphPvJMzgEBSJpJlKVLSqY0XvCOLoxPCtX3ZgDJfmON3PZL2lZt2FvJJVu0zk11652TgNCFLirOd8oHwETej1LpY+95BSyJ5uR5EH9NAhvKqMx5MvXtr1GRCTrRyUVPmv8bMinqrNR2GIgAiXze6/P0Gmm6Sl33hr6sSl0U6RSzrTFCdX63R42cCsh9rdtcsnnZDWSKNW+K67EdP3Rr5Eg+SKfkDv8R4siH9IrHJH1P/R/zrODq9B28yewGEtemteDgp8xD7o9n1DdVOW97hXyYo0cq4loQhXCt/C4xbh8BF/6lCCjitqChmk6RdKHeH0v6/J3bMa2XJd/1VEh0eSlZ3aBeI5fUkynWJFvIH/9lsa15uz+D1CgrgF1oY7BVbyqOF5yJEN9YfaOhj6U5cA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(366004)(346002)(396003)(6666004)(316002)(6486002)(966005)(26005)(38100700002)(38350700002)(110136005)(16526019)(186003)(103116003)(4326008)(956004)(478600001)(5660300002)(7696005)(52116002)(2906002)(2616005)(66946007)(4744005)(8676002)(86362001)(8936002)(36756003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGhlMEpjbzRMMWRCL0lWdUpUUEZMVmk4dUlFSXBOeFZCL3R4RVdQR2lsb0hT?=
 =?utf-8?B?aXpSb1dZOEk5RHh1dlpLZWJTNnpzUTFBdVRodGV2SmJENEpGMm9mREZSZjNR?=
 =?utf-8?B?YUliZEoxR2dwQ254WFA4Mit0NXVDbXlJckhndEZpN2g3ME44M1FNYUVIK3NW?=
 =?utf-8?B?WWRYZXp1STMxK1dYTG1aejFxOWRwNmhGU2M0NmFnbDlIOG5JOE1PQVcxZmp6?=
 =?utf-8?B?RDlnRjV6WmtDRjNUYXUvNVhFRnJQNk02MEwyUG1oVlM5enpFOGxDVXBoWVc5?=
 =?utf-8?B?UUV3RVM1SC81MkEvTVhKaTN5WjhicmNDMDVoYnZJQ3g5dStMYVVOejlDUkhI?=
 =?utf-8?B?d3gvVDBsR2pmb2kwakNER2I1NnVNNUpTZHVUNnZvMXMvZ1hwUlZkN0NFakVF?=
 =?utf-8?B?SFREczVBUEllbXBOOUtXNkx2ZndKQytPcnN4TUs5L3BudXhIUE9nT3JCbE96?=
 =?utf-8?B?OG1JeG1MVG1OdmZHK1hKNVlJb0JkVzgxWEQwVThiam0yZmgyVGpCdDNINGNE?=
 =?utf-8?B?UUJ1Y0tZL2pMRGROaDRsZ3pHVHlQL1NoYVRTeXNaNjJqN2JLTHhSNmpubzFx?=
 =?utf-8?B?TndDV0c5ekFxb3p0ZXNNVnhmSHIzbnZOYTJxaEE0ZW1nTHFIaDEvNUVNL1pz?=
 =?utf-8?B?S243eG1seWxQL2RlMEJWUjIyR1MyanBESVhTcmljb2tjaVE4a1lIS2RydHFr?=
 =?utf-8?B?c1huTFpZUGxJbnlEcmw5SlFpMWJ1bE80UE9FU3FJb2pFVmtDL3hOL3o1QjRJ?=
 =?utf-8?B?SmMvYm1qZURSdjQvSVZYM0U2cjU1M0tlUmQzQ1FRZDFxdjZFRnUxRG1yOWl1?=
 =?utf-8?B?cDNsS3VRWHRTSGxiUURqR0Y2VExkWkcxbnhyY3NxWE5Ka2RuVngxcm1DNUE0?=
 =?utf-8?B?Rm9CQlVueDdNUU1uajBiemd2TUwrRzhPMDRWZ2laSFBXNm0xZmpUemFBRDFN?=
 =?utf-8?B?Q000RXE4SzNPbXlRZWVrWXBnSUdMbXYvblhyK05haitqSUxubCtVOVBSYlJu?=
 =?utf-8?B?WFZLRDZESDNEK2t1aWxTQzZJRm1ld1BiYkJablkrc1N2ZHpxOUh6ZWFIVHhw?=
 =?utf-8?B?Zksrd01PUkUrVEtCdHhLaXVtNHlJQ0RLSWpzWFBYTWQwN3BBMnlMQWYwanlK?=
 =?utf-8?B?ZDQwNktRNzhNUmUyMkxJc3lad3VyVXFWcFVLZVYvTUtCam9kbHU1MndwYmFa?=
 =?utf-8?B?cWZBV2V3L04xK2dnUWF6RW1YSmtVWE01MXVIKytxcFVqUGM4WEU1aWVXLzFL?=
 =?utf-8?B?c2JQSkZ1SGUxN0RiczZvaHU3cXRtR2ZycWRqelRYcDZ4dU1KVytOdXM0dUR6?=
 =?utf-8?B?YWJpeE1iRCtpWnd1UnZ6YzN3ZzEzT2JOWi9DdlVxYkdFK2Fmd2ovczVtZDJa?=
 =?utf-8?B?R3U0M1oxU0VCSWhtQkNoM3g4UGhjVU1abkFuTkQ1UlE2MS80RmZ3L2ZHdFZB?=
 =?utf-8?B?bVpKUkFsQk5pdmZjd3dqNDArRUZqcStMRllETzlZWVlBNEVlNmtqNmVzZGJ0?=
 =?utf-8?B?V0VwcmJvMXk0d2tZVlVIbnJSb3ZFTURBQTdCN05HclBKSFV0RmR6UFRZbkpG?=
 =?utf-8?B?WXZ5eFkxUngzRVdVRS9teW5WUHplSE5IOHphcC9tM0lQQWx3RmovaUkxcDhN?=
 =?utf-8?B?TFpjd2NRTkthV01ocjJqUVFPTXYybVpFWFB0TlpmKzJtU09SUVFIT0xMdG91?=
 =?utf-8?B?ZnFpZnc1dkxzaElPTjh0Tmt5d2lxcU1WeVVMUERramgxYTVZRDR6UHJuRFJz?=
 =?utf-8?Q?PaTGtR8/lbWM6tyujTfd6E7/Co7A/ByxC2Rj0wo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7157a764-a67e-4727-0fd0-08d93ab3cf86
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 04:10:20.6704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QinqnTIxKksCNlIUr8p4/LXlE7DhIvs/YFMwzy/bAakOPncTiTEr1CIikbJRTjP+5zOcP9UTdyOlFrL6/YFerB7jHBI5YUmMI3WHg+WFphM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4711
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10029 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106290029
X-Proofpoint-GUID: fLzeQiYH62kRijsnvykpS3PVcVdpAaJP
X-Proofpoint-ORIG-GUID: fLzeQiYH62kRijsnvykpS3PVcVdpAaJP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 21 Jun 2021 16:17:27 +0100, Colin King wrote:

> The shifting of the u8 integer returned fom ahc_inb(ahc, port+3) by
> 24 bits to the left will be promoted to a 32 bit signed int and then
> sign-extended to a u64. In the event that the top bit of the u8
> is set then all then all the upper 32 bits of the u64 end up as
> also being set because of the sign-extension. Fix this by
> casting the u8 values to a u64 before the 24 bit left shift.
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: aic7xxx: Fix unintentional sign extension issue on left shift of u8
      https://git.kernel.org/mkp/scsi/c/332a9dd1d86f

-- 
Martin K. Petersen	Oracle Linux Engineering
