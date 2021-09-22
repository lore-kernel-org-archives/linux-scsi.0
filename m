Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50DADC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C5AA611B0
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhIVErQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:47:16 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:41212 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231527AbhIVErL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:47:11 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M4ewbh013127;
        Wed, 22 Sep 2021 04:45:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=hlH122iF7XrU9xNlADz+fdQZ/Q3WNsm7F2GOIgtltPQ=;
 b=Ka0XI1DTzN2LrfsESqizUKybtEWQPUcKHZvsqiNUzsusrJdUYXg31lXAaRvzeXo0RClX
 4E/5owOXk6Mn2elBSN6+T8wrUYqSxTHmphDty2y2Spk803BHP1o0q9TJ+PdgLR09VKho
 i0iR4O7nFqDeC8WwVuir7RlF//hxfMv2f/SuSM2wfKZ1tFnxKCLsjBlrLRr/WK7LjB8a
 P5Zxkj2Cp74IpsswVqhBAVIJqUaSkZ1Ddx3fxxSu5SbFC/EbIsx9NcA2JnBhYHZZVPXw
 shb3bdn44YGJcACmdfls0lYNyvlFabWmR7+2BpnBs1jVUd4uDmlka7oGs8kFR5KPbvIK 0Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4qhc8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4jZs8178811;
        Wed, 22 Sep 2021 04:45:39 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3030.oracle.com with ESMTP id 3b7q5mc7nu-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yv3vfk2uhqB9r3i/auZWXjti8NpIkCX8r8e2Eh3Mvu9SNdZOlCfHmtGNdkNFXKxFiyBWPPJ3xbm5B6G2EkoS2Q8gyT0htuUDZiN+4GZl1f4x8ugSprjubjZGhmaYbd0ZK32/ZWbesuJyexYVDwkn60IFxcPcgxQcX40U4QrxvKhxiOGzeC49eli2S4QSGdbpO2azxzM4ka6kSJL5CZfl/CMChxF6e84+c7cIq6cudOko6L84ExngAOG/6vRGyl6OLXB1ebXvswgijinH363gTSjR0+9lxB0qrcQOW73T0gLxI+2V6ENbcKvThqvoj3CuyUWD5DLZsIQHXyOuROlFuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=hlH122iF7XrU9xNlADz+fdQZ/Q3WNsm7F2GOIgtltPQ=;
 b=cffHjEMirYYXvsAhfU+lsvrRBN4umnv5CbLBYGUVe6vYtku7PTs90YFDuC48A08Il4dGu2tNBxL6OVljotI/16brYA1bW/X94whogpZQkNgBq85x4LXKrOg3BHAURKS94Lvc7XnPCN14w8JG9JU3fvYdL8+9aeKvtOtvgARc3N+22nY6iTJ0tLRlVWQBqeTBJG9lYhy5UPvrTuFY/JCcYF1qgc4xSr9vdCB9ZkFE3fFg3/EPK59SD0fbs/5Lw4cWC8BBLsoghwWBNrQ6L9k7vLDphQc8SaV+ESu+MFNCEYm882VtnM468WdhbHON1SJOyeiOWmSs3tb5gikicINYVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hlH122iF7XrU9xNlADz+fdQZ/Q3WNsm7F2GOIgtltPQ=;
 b=C0w5RT09IVhPtByvwPDvGP0Nxg7DTm+8LWCDKu1EWjCtbAnvgk2UYciz76Hiq3RRgnjzJyBS/KvBoLAJ6OKeeuJW8xOjVdLDTHMEfe0Be2gwtTcrg58uIAJl3URsVxlwzMtaawgXaHnBzYSM8fvZzKfho/Hz123y1by83fPj7ZE=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 04:45:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:45:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/14] lpfc: Update lpfc to revision 14.0.0.2
Date:   Wed, 22 Sep 2021 00:45:20 -0400
Message-Id: <163228527479.25516.15231951219902210842.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210910233159.115896-1-jsmart2021@gmail.com>
References: <20210910233159.115896-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0154.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0154.namprd11.prod.outlook.com (2603:10b6:806:1bb::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 22 Sep 2021 04:45:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89d04260-b586-436b-1519-08d97d83d14e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4456:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44560D7A46DB59913FCD361B8EA29@PH0PR10MB4456.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZJqRzsAahUZvy2LhOlzBk/3LCulwI3Nn1GULtRYPU1Rqr/NTG4PKJuDD2q5+g3lqdog3OWU7VRkISk2q7znsqrwl1aRKE0t11QK1641EcnW3M4/Hj55nf16rJ+yHQmhB+S0qYKgfjNJ2jRLUPCQdYZ0Jpl/rSzvExteM+AfmgMu61G/hSONSX/GvRa+RvtBDZyiQXUmPLiz1+I9B/K93d+Jyiniq9D2tw3dHNnGbDJjUuTBRtFGvhSlOHREt3XZheQon4aOreOcdHnedjOOCIZiFgx61+M+gNlJ7pmhpSipUwX/WrejzTa1k2QArpAh9s8z31Pj1KNIDnbh8qCqV2opDvQXpvF6yEK9oBwV8utcLH85UUfGxPMQURMUjw3RHLFtLBS+ehV+ooWPZy8HBv5a+jOgLTyz9zNu2Ewtkqe8CJSMVB7nQRCyjGOLpEjHMJFzwjCx1Y/WmwtwGV31l+h08i/YKbUXIe3NpFsZtk6whUZQrfSB9aePs/4zA5SnJoaPP/ANEGNeyX6BbO9AJQW7pUKtAkNGZ3n3d7vhUSVLvn7qDsJs97hZPmrncHyfPWVWST5ylaYcV2xzDSwP17Y3lUO6q1jy9Upl3MoGqEG5yArHdb7dvWIecQmKV2sWNvCnLTob4urjglNFww1FMz1/pg6GaQ1uf8Ty64STZ5+13iSpm37k7fBJerFNRI+gQHZv6+cAoKo5tLJ/ohY0+dF9rZsqCt3F+cZ37jiqdcWelHB4wMRwFxtYOhIH2dbme5DZcR9j4vYlkcOTTk5s0KPUXKhWL8GcTIGg3MsWW7s1zOFFQ/olAmqwFW0Z2KU9+zpCTeWloZj2Rvqri6LZFbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(966005)(15650500001)(36756003)(86362001)(2616005)(4326008)(508600001)(2906002)(8676002)(6666004)(66476007)(38100700002)(26005)(52116002)(103116003)(66556008)(5660300002)(66946007)(7696005)(6486002)(186003)(38350700002)(8936002)(107886003)(316002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clNBNnc4cWJGVDVpZGVGRWtpamZoQkRwakQ1UWlZZ2tiMUJwTVZmYTFrUWt0?=
 =?utf-8?B?UmxqWlpvdjI4ZmNFL0lLSmpOd0pGN0ZCbnVBRFdqWHJUWC9NRUh2aVdGMnJv?=
 =?utf-8?B?ZWozdjUwbGliK2NnWXE1VWVqZURKK0QrQXdKaHBneDVZRlI3TzkzZUN6WE9w?=
 =?utf-8?B?Q3pURWxUYjBTT1EyY1ZrQlNVWG1sZ2tQbjlaL1Y0TTBhbTA1WGorSjFMOXFI?=
 =?utf-8?B?MGRYZFhWRXZKNFBCOEgzU3JGN0JVVlhQcUJ2T3JLQmJEYkxkSGpoSmV1WGcr?=
 =?utf-8?B?emJnaWpyUFpCUG1qQmtBTlB5YmdVVkw0azFjajhBUzY0R05mcngzTWZJT1NW?=
 =?utf-8?B?L1NyY2ZMaHVzSmV2d0hUWEloS3J4a0o5QmEzeXlEL2RNRXVHMkNYQjdUdDV0?=
 =?utf-8?B?a3M2L05zUDlseE5UaHFKWUlkUHZzek9xc1V4YzVkMXl1eEZhemxpNEJoejY1?=
 =?utf-8?B?VnIrN3NIMUNzT2NhYnRub0xVZFVoa1FnUFQ4cERmRmNDTEEyYzRWejlwTjB3?=
 =?utf-8?B?aEJmU2Iyb2V2eFJ3QzJ5N1NxNTlaamZnWHI4Nncvd05oa3JaWFZ5RGxVRDRo?=
 =?utf-8?B?MGZEaEdualJDU0ZNS0VGZHhzMTZKUEE2bzE2d0ZjV3ZteWVubjJ6V0VORm1M?=
 =?utf-8?B?TlFVZGVVOGNPZ0xTS09qdE1iWXFIY2FvOVZGaGE2dDI4K3hSYThlTjdaYWZN?=
 =?utf-8?B?Q21PNW9LazIvWS9JdFhlaFZCZDhXQnV4emNEYU5iL0ZOdHBJRUtLL2MzZ0Fp?=
 =?utf-8?B?d2tDbnh2a2JCYXQwcUxDUytNOUVjYXBjS214Ni8wak5XalBOU3lCZDNSVGhy?=
 =?utf-8?B?dmdYNEIzWm1SWFhlaURaSTNCMW1oZUx5Z3hUTnRvNytkWWdNNHhhdDFWeDZt?=
 =?utf-8?B?ajkySlVZZXpoc3hTdnN5YkFJUVkvc1NSZk5tZWJ1SWlCeUZNUlBLVC9XbnJP?=
 =?utf-8?B?N3FtZnNkNzMzS2l6MTZoMGJqT0UrSVRuckZoQ0YydnRhSlZPSlMwVDJCWXZD?=
 =?utf-8?B?UXF3TDZZR0J3cTFwTlVkTFhhYWxIYm1RS1hKMERYMkVuVC9NMk80Q0NJK3h5?=
 =?utf-8?B?MWg1Z3ZHMENPRzBRanFjbFJuS2tYSkNscjZsbStvYXBwMHB4QzZuR3ZTVXhz?=
 =?utf-8?B?UHVnY3hhekFWV1FvU01zSE8ydlVJR2NMWFF0WUxtZjhqSGhPSDhnZ2NVbThI?=
 =?utf-8?B?ekxER3ZaNmhnRE1vR3ZEcDNZdmRWc2NQUDRyTENFQkZRenBYWVZRRFhqK0FG?=
 =?utf-8?B?bmYvcUNaNmltV0lTKyt5VUZZRy9GMkJEd0N0VnBhVWZoaHJKS2tNditBUnBI?=
 =?utf-8?B?dGt6b1hZaStCVjhUMEw4TkFvR2FpenVqcVFFdHVVNCtuSVRhQ2NVTHU1ZEN4?=
 =?utf-8?B?SnZ5VmVOU3dERnovWGtKUDhDUU02c3JrdS9uN3U3VHpDWW94WHlBeTNwMTZK?=
 =?utf-8?B?Y3NRcS9pdTMyZHozOW5vWG9QYlB6Q3hTQTZWeHVHVWw3TlZ4M0VyaEhIYmlC?=
 =?utf-8?B?TTI4QW1FV25qWCtnWjNZQ095MUhsd2g0WXlYUGRBazJaSFNqcWozbzFKT1Ar?=
 =?utf-8?B?T0pSMVdoY01MMDhXbHBVMTVIeE5PNC9Ha25KRXM4NExpblZLb25tQVJwRmd4?=
 =?utf-8?B?T0RKSXVDU0kvS0V2SWR0V1BWTjJaUWR2eW5TbURtYlFub1JQanFzYk5HNkQ0?=
 =?utf-8?B?R2VFdTdIcHNQRDk1bWQ3aXNpUTA2U2NKQzlJSmhnbTd0eXJmRTRNU0Z3U2dw?=
 =?utf-8?Q?PdnO+T0z5AGVNb1BEMlvMnvHYWqb5P5wv6NHuhp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89d04260-b586-436b-1519-08d97d83d14e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:45:35.6892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d6VHPiDQiP8j0e08oRhD2h/kkAtZmtkpF1nUX3F8hBmgbF7cPbQ+3iyafffHLN5pxhSFsjvL8xF6i5DJ4HcL181DF6TcARruWZhrVWRv3E8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=556
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220030
X-Proofpoint-ORIG-GUID: QayHJbY7IxwUJlelhqdP7oRNPvg3_WOJ
X-Proofpoint-GUID: QayHJbY7IxwUJlelhqdP7oRNPvg3_WOJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 10 Sep 2021 16:31:45 -0700, James Smart wrote:

> Update lpfc to revision 14.0.0.2
> 
> This patch provides a number of fixes to discovery scenarios and
> tweaks to the recent congestion mgmt framework.
> It also provides a significant eeh patch as well.
> 
> The patches were cut against Martin's 5.15/scsi-queue tree
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[01/14] lpfc: Fix list_add corruption in lpfc_drain_txq
        https://git.kernel.org/mkp/scsi/c/99154581b05c
[02/14] lpfc: Don't release final kref on Fport node while ABTS outstanding
        https://git.kernel.org/mkp/scsi/c/982fc3965d13
[03/14] lpfc: Fix premature rpi release for unsolicited TPLS and LS_RJT
        https://git.kernel.org/mkp/scsi/c/20d2279f90ce
[04/14] lpfc: Fix hang on unload due to stuck fport node
        https://git.kernel.org/mkp/scsi/c/88f7702984e6
[05/14] lpfc: Fix rediscovery of tape device after issue lip
        https://git.kernel.org/mkp/scsi/c/3a874488d2e9
[06/14] lpfc: Don't remove ndlp on PRLI errors in P2P mode
        https://git.kernel.org/mkp/scsi/c/a864ee709bc0
[07/14] lpfc: Fix NVME I/O failover to non-optimized path
        https://git.kernel.org/mkp/scsi/c/b507357f7917
[08/14] lpfc: Fix FCP I/O flush functionality for TMF routines
        https://git.kernel.org/mkp/scsi/c/cd8a36a90bab
[09/14] lpfc: Fix EEH support for NVME I/O
        https://git.kernel.org/mkp/scsi/c/25ac2c970be3
[10/14] lpfc: Adjust bytes received vales during cmf timer interval
        https://git.kernel.org/mkp/scsi/c/d5ac69b332d8
[11/14] lpfc: Fix I/O block after enabling managed congestion mode
        https://git.kernel.org/mkp/scsi/c/3ea998cbf9e7
[12/14] lpfc: Zero CGN stats only during initial driver load and stat reset
        https://git.kernel.org/mkp/scsi/c/afd63fa51149
[13/14] lpfc: Improve PBDE checks during SGL processing
        https://git.kernel.org/mkp/scsi/c/315b3fd13521
[14/14] lpfc: Update lpfc version to 14.0.0.2
        https://git.kernel.org/mkp/scsi/c/0d6b26795bd2

-- 
Martin K. Petersen	Oracle Linux Engineering
