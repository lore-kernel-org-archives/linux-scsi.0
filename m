Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 025D0C432BE
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D128260F5B
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbhH1CdZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 22:33:25 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40134 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233174AbhH1CdV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Aug 2021 22:33:21 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RLwKUa025345;
        Sat, 28 Aug 2021 02:32:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=1teEGwiNpitpfVFyynm+bENHs+/E60/jEKyb+1feCIo=;
 b=i2CZgnqQ+b7UK4gGcDQyvMoYIuj3gW1pXf3kXODY66edM49/gbefjTEqXapOrJU6nvR5
 r/jPUUlHnZZoM38ifhDkihWmtrhiaGuu5SR7YRwLIx6/iTwcBrbnq+WQAUfMheBJt97Q
 lNYgHcOLBdTEsO7/kI4uaazyGiadvlp2UQCPvMnqy30+4kv+X227j0bEDd7A9vb2G3GP
 djL8jAf6gmDunBnSELhP+DvuifSOzVvVkcRGTEqorHeyaJq/4T4CZKUAmFBnIzzZ+TjD
 dlcM9fKeL3edPIhbsMSKEycWhhSH0jnhwoMc5OoCYuCjIfFhcDUYRqbaeAL9fJRmWU1I zg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=1teEGwiNpitpfVFyynm+bENHs+/E60/jEKyb+1feCIo=;
 b=pyPzDcmpDAszJJp/QzrJ+jd0dnjWFpFEvXHBSZMHF5gxOHzS7+Tp69lc9d+u1A9tnH2G
 vbitAJyC7bSrv9fFyuw8tSuG2XlaSCBiWf8RcZn/L1J8/X8jSDtOp1kpa9LPM3LKihUH
 Lq9Hpua+nwH0FriGwgMliHWDskQC85T0lnbHf94l87GUAUfN9niK3Pe6LEq5c9VDGSwh
 7opp6DwV2iPrpdOLmihjVtWOUe0mEVCSddG7FchhEW1/2QuY1w9JiDo7FJqcUv+8yT0s
 GDpg0qs5JXfh1prMLgyMJ0+bvxzDBwW8BIxK96Pd263ocrmsiY4Kx+TAjnSzmu1hCl5m uA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aq1kvh570-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17S2Fm2g147458;
        Sat, 28 Aug 2021 02:32:21 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3020.oracle.com with ESMTP id 3akb935rd2-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YLac4j4L5gxZoaFUMzwvUejBH9wHVzkN7yqQeUyJnsLo7CD41P/chCwQxVaWvGTWOb/KFIdRG27n5TRgvoJJ8CJRGrZgHsJ2qk+io9PJ6YBffdSTSqI7VXEvbT7jTDqarb3QypJBHNgKZMPneiljbBoHvS4pOmdnnCN/sMqTXDlieAMqIGf97UpsW1RyAMbL7Bf7SNN3NC0CQ11sL4VFFdVBbJFwOQ5EQ9WbVnXF4IE8hdB+kULj+xhZ8TlLfPppzHxRqkFxrJNnbWuqgyrIcy7MMLO1z2MDWkYdo5KaNBEdMY43VflN9K6D7oSNYziQO0ehslHkjmLKrYjOGfDQIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1teEGwiNpitpfVFyynm+bENHs+/E60/jEKyb+1feCIo=;
 b=MT64aikYiaJesVRoSDSxARXAyPfgu/GRf5Wucr5Yb+rJoq79m6BHr0z9KkIDTdqJiyusdLneWCc3CoHKTeJgZFf0U1AdLy+k5VRhwJcMrp1IzDSzgjS3BbIp56cwR/Oie6SFZfg0jtcaav10u8qxeSi8ZsK/PXpXAzvtmCnE8B7OrGnOHnYwIKR6ghR6FdCs0oANXW4hWO+pEODfg9HCfHjdnualvfyU6o9rlZVNIf3RQ8sWRt9A8pj8Ag7+1lJN5i6A/KXdxVFBZRiMZlz//qzGnUMJvQdoCPpKz0hisFh1kqxAOowpwZtubHl7lT2LJ8dgv+AH90dsPvL3cgnqdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1teEGwiNpitpfVFyynm+bENHs+/E60/jEKyb+1feCIo=;
 b=wZfWmmEFDgg+mOuAwfDAzBsqWCf95rTbB3X7Y6blRPMPon/yvIuEK0j99GvaejS+WooyrWjbnfxsmj7ggABLz2MDpn8PyeWwUf/nQBFt+VfS+Q/7hLgjATIE3YbraWJPkefCRc40acxTQQfYybboMdro3m+/wRwSd8nX9spi3t8=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sat, 28 Aug
 2021 02:32:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.027; Sat, 28 Aug 2021
 02:32:20 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        linux-scsi@vger.kernel.org,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/3] qla2xxx: Fixes for SCSI EH rework
Date:   Fri, 27 Aug 2021 22:32:02 -0400
Message-Id: <163011776500.12104.15818631160451307769.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210819091913.94436-1-hare@suse.de>
References: <20210819091913.94436-1-hare@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0025.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR17CA0025.namprd17.prod.outlook.com (2603:10b6:a03:1b8::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Sat, 28 Aug 2021 02:32:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: deec204a-4386-4d7c-d2ed-08d969cc0f7d
X-MS-TrafficTypeDiagnostic: PH0PR10MB5515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5515768FED87DD07A70734538EC99@PH0PR10MB5515.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fKpAOaEamm32bAHmx6OtmMQlXux9e2LSuW9LCi4qZgm0HronoRr6AcRIAAebmBVKwHEK4ykAmkoicbUQ+akRDDYhC/1bjSMWzrWoPs132gFw3z8CiZhUJ21HBqiASTmosAen2f9PRyajGgRRIOomtSviIrkoz8MvjdtXQb8gnn8HcyAsI7UHxdb3pia8lQ8Ceq1rbIxBXF62JJBSVq3sk4tYegMv7XPHnN2od5ulFfDLxfKkm1BY7qnDijASJhN5EtE2STqQJfzZ/H11WaZ/9M8vGH7dHn1Min3DcFso2fDM2v0rAX9QOENQ5TB7FdmmyKh5w2IrqgrPRdG55HsklV+bhzGKSnDuguX6O6bU9TbASRSKordv9m9hA7b/7JkNbZWOyi9vQAdrSYNACmfP0T1mNq6YVEEJ8+HZmTPdCi6JVKiSdH2iz05Gf8NgZ8vvcjUvhfGl9WRlFUCM0w1B58r7n2akiZ9UJJ+9GtESpmkICTrsB+KJJ8VGzwmt8pLOCpKpqDTQ/TsttUrV3Tfoex2aAgMDGfnspKd/8rEvTK4hmyv2cihEc4X/nc5/vyXKAcwZMaIF9CSYUBW4a8R/YtY5Q3zaCTLeVPY4ZJsOplaXxwfQyYCLl9dkiPumNfH2QBj8Q6RLSOplRhLJPt+arxwDboHHpjcBNthj3BOhIeTF1Cw1NP3k/08srtB/necn/++CapPPs255RUrynO0Akd74BfxUabeUxRVLn/InWEmqgcrNvv76plJyZLAwn1fxTejMN8K9nQZbeiDhKS5YULzBXn5c8hggT+t6xjGIEmG+nTL45+63lpsDy6yezrVr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(966005)(5660300002)(2906002)(508600001)(52116002)(38350700002)(38100700002)(4326008)(54906003)(7696005)(316002)(36756003)(186003)(956004)(2616005)(6486002)(26005)(8936002)(66556008)(4744005)(6916009)(103116003)(66476007)(66946007)(8676002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVNDZUhHdEZITy9hNGk2Q1JYYUdqRkgyV00vd3hFbzA4MGtqVDcrRG0rd3Y0?=
 =?utf-8?B?QThxZWwvWlhla1pBVzZZMVhmY1lNQXg0Vi9zRS82bHFtUGliNkZKaUxhZUQy?=
 =?utf-8?B?NTc2YmY3em9MWjhCeDUvVElMTkQ0cXpHcWhhUXRTcm1wNnZLT2lIdC9hVnlo?=
 =?utf-8?B?QlJ1dzNSRndmS2VzUzlHK2tmek5VczU1ekRXaWdwblgzekV6RTRKMmc3QzB3?=
 =?utf-8?B?VmRQbitBWC93b0lqMEFXZG0xSkpYd3Q3ejdPVmJvQ2lxazVDOGJDOE80emRC?=
 =?utf-8?B?RFEvQ2RoZmlGZ1lxR0VUZVRQSDIxTXJnSVJJTHBySjY1RTc1Y0FsQkVlUDl3?=
 =?utf-8?B?ejNpTUMvUW96ZkFrOXU1NHZoNGFjNlVlL1pKZzNKTTM1ckxLZ3R4WTZLYk5W?=
 =?utf-8?B?Q2xGdFRXbkQ1VWM5alhWdktiNXc0YVNLMllpQk5CSWk3QjVRTnZOZFdCcms1?=
 =?utf-8?B?UXpsTUMvQ0JQVGdaYzBJVDZGTU1HTmVCMlZnbVQrOGNWTXg4VldrQndjSVp6?=
 =?utf-8?B?M0diUE9SUnhRdDR4WUFVbC9QN29QS2swaTl4L1cyWGh6Mi9tWVlCZHB2VG95?=
 =?utf-8?B?b202ZVRqMWlmWFVET0h1Rm5oeHhQTmllNVZib3JJaWFrY1JMSHhxOXB4VHlV?=
 =?utf-8?B?MjRoNkxEWk80NnZscWJBc3NtT1FqbHhidHBRVkxxT0U2amt5RXdjRkdwU29w?=
 =?utf-8?B?aUlBVXVXZjczQVVnYWd2RFZYamtyMXR0T2pDZzRvVnd0N0pwbzNsU2o0U3BL?=
 =?utf-8?B?TG01U1o4VlNaVzdaSVRHRlVMWlh1eFFZWTZVc3l6S1lHRVE3WXNCaTdocHVR?=
 =?utf-8?B?a3FEK3A2eTdtWEdLWDZhTmQ2K2NFa1RHcjkvL3NiNTViM2s3VGsvQWlCNGll?=
 =?utf-8?B?Zm9jSXhjTUZIU1hJemRTU29pOGREdGxGMVZnZ1FIamVKa05CYzZMWGdaYW4w?=
 =?utf-8?B?U25EeVp0d1hXdEdNTWZkWGdtbWxTb2tHbTUwR041Qm5GcUFneFROMi9wcTRZ?=
 =?utf-8?B?bExGM29LNHZXQjRMamVuNnBjdFBUeDVjRmtMTGlmc2RrdHBUc255VEt3OVp1?=
 =?utf-8?B?Q2VoZDJnZ3JQNmVHMmFkai80c3B0Z0pWZXJPdFZlYmZvUDdieEZwTXhlWW9I?=
 =?utf-8?B?aFlrOFZ5eFFRR3lSZFArWmNIUnU5V3o3WkVTRktudnUrK0FRTHJQdkNxdmZO?=
 =?utf-8?B?d0hhenlTMytBeEFER2NuZ2ZEOUE5WDBGYUpwb0lpeEFIMXRKcVh5aW5XZWZC?=
 =?utf-8?B?aXk4TUc3MVhwZ3plSlpETFExczNWRTQrNUpieDJwVlBlaGxHY3lNNllRM2hS?=
 =?utf-8?B?Y1N2MXNtUUVkeEVtV0J4TFJEczQzRWRRS0RYNDJhM1FsdUZQTjlEWmx5Rko1?=
 =?utf-8?B?RzhBK0g4bE5pbG9RUERsSWlrdW5ZYVJJMGlwMlhSenp5a0NnUGtGMGY4MkVM?=
 =?utf-8?B?ZGpWa21wVDU3RUdpazdxNGt0K0FMY1d6bXlrdTFibVZUMkovQWQxS3NQblVD?=
 =?utf-8?B?VkFML3dlTENGUHo5SjgvTGEvM2lmM2VkNUFRNEZZNUNjNFR3S0Npd0dyaE91?=
 =?utf-8?B?VklsNXkvU3QwQmJ3TFBxSlZWRTRtY3V2QzRlUDdxVHcxQkRhbUZOYzZSczhs?=
 =?utf-8?B?OWJxT0FGMDR0ZHkvNk5BVCtMNDJtSFdzZDVwUlRGd0lrUjhncDR0KzVlQ1Az?=
 =?utf-8?B?UEZESzZjVi90MzJwY0d1aW50WWZSakZwZk5KSjg1Rm55Rll4WmRxYnBhaytL?=
 =?utf-8?Q?+etM63x65MDKrS6jxC44/KICgs04H1fIUHAM8wE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deec204a-4386-4d7c-d2ed-08d969cc0f7d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2021 02:32:20.5935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nY6TqqxD7Mn6TmHtsz6/ITXPyuYOzAQtTaq6G2Trg4vs8RJ5P3Dy4mTJOfEsNRb4ttDXVYqvJM3WMBiNE1wL7h37ZLi4XV1E3nYIjm7/qgU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5515
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108280012
X-Proofpoint-GUID: 8FvVcyuU6fMx4aKWgvQict36g_cIGNtm
X-Proofpoint-ORIG-GUID: 8FvVcyuU6fMx4aKWgvQict36g_cIGNtm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 19 Aug 2021 11:19:10 +0200, Hannes Reinecke wrote:

> with the SCSI EH rework the scsi_cmnd argument for the SCSI EH
> callbacks is going away, so we need to fixup the drivers to work
> without it.
> 
> This patchset modifies the qla2xxx driver to not rely on a
> specific command for the SCSI EH callbacks.
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/3] qla2xxx: Do not call fc_block_scsi_eh() during bus reset
      https://git.kernel.org/mkp/scsi/c/c74ce061f898
[2/3] qla2xxx: Open-code qla2xxx_eh_target_reset()
      https://git.kernel.org/mkp/scsi/c/e56b2234ab64
[3/3] qla2xxx: Open-code qla2xxx_eh_device_reset()
      https://git.kernel.org/mkp/scsi/c/cbe1f0d70072

-- 
Martin K. Petersen	Oracle Linux Engineering
