Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D8CC11F66
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AA8861D4D
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbhF2ENF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 00:13:05 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:43462 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231750AbhF2EM5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 00:12:57 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T462QG012450;
        Tue, 29 Jun 2021 04:10:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=VphjIgUDcbjen5NuonTo2zGoB4rnvRw9xhz/ggelTNg=;
 b=sXaGPxw1ZJJosphloOUvUiX4y/AQRho3G10nPQ9Hg2Bhb/ROhBB9gJNvZAYpwBOj1KkO
 1//dkkp+81e6UQxTYl12zDaz8w8R1+BlVBFLMkP2cMKF+B/sUosXBxQPQHhq8yS+rcax
 6Gq9t4lTvMc1+mIrxbmsw0x/SLwu8zx2gdQPeoTsm1dKbITGJvAJ1dINuPrOtivuGtPV
 hifBVyoph9zurGNYt3wL/O67iiJDGRZixii9ovr3r9nrbqaveC/WicOIAM6AXdOQgULZ
 kPBESHXiN0rsGWVY0Wn7qAqcpkUC+B5Unb53/bq6O1RXi1aRWDdJfujbb6l5UitP/cxu IA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f6pqafqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15T49rjU052345;
        Tue, 29 Jun 2021 04:10:27 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3020.oracle.com with ESMTP id 39ee0tv4n0-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AjFwTNp/lic7JG73iv3aLCI9dQu6e5n7BYIHaB9QQ8zY8EKtgFTZov3G4rJFYJIgcfDGx8aFiJkm448/yNpro38fLDxpNUq2mTUiH4lbRk5QPE/o0HGOW6My/ovKa/6iH6XREUuTDdxLqI4II09GBJRpKci0HxoJ4hXiPXUHg5HlOVAKqFv7w2png8bSER+bfcz+Qx5Ts7JfLHntmQBkIxkUF1Pu0nsP/XkujFwwfO2RRCGGXAy0IWteQueToDcUHWqGqqXXi3NSdTj2b43SeLSmTus3hzpEFM69XnQxA6iFUi39Qb8ATlhdfQ/XxlxbF+n3/ABQmwg84MD+Yixbjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VphjIgUDcbjen5NuonTo2zGoB4rnvRw9xhz/ggelTNg=;
 b=Jg5Ux63JHNughY+9/odIxcUEo9cNLi9Pgq+u1PGbsRtXLpOJhfR8I6gCUIag8MqoWRLunxzwd1JUDoSYup/BrxuC1aD/uEfIIqfXZvIvWeMBrYlVin8tM/KkUfKIYlcJzh8BJwx5askurIg9YRvH3P+sj2YvXoXVA7yESWmBBPpEhKW0Yq1eEp091FVEiWiY9e8dE6OwwV3yB5MRooyJgGSZMnx9DKR+bSjYMKMyNcVjKJDawj+8H921fe3WmxocvQqc2P3ESO0nwkO0L33Oe06QqApkzJDO1mEE+93yX725sOHxMoLB9uCAPFRSrXGLQO67G/lB0XrQvyWXjQd09w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VphjIgUDcbjen5NuonTo2zGoB4rnvRw9xhz/ggelTNg=;
 b=ESwRgkQmwG0V7oH5A/mBKuYPY8FrHnX/JHEJIzujgloNLG0wF9M9vuOEc3ZF24tOEsIv8vrKj+tkrXFj/LxlhDezWQXc/i0qKASTyqrk6fk1cGPauQ8frlBJWgOR0peIU2f+fXhf7EZRXMsETj3CX40EQI7tpmrPGlnjZqOpW6I=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5417.namprd10.prod.outlook.com (2603:10b6:510:e4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Tue, 29 Jun
 2021 04:10:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 04:10:24 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v2] qla2xxx: add heartbeat check
Date:   Tue, 29 Jun 2021 00:10:10 -0400
Message-Id: <162493961196.16549.17833770691927883449.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210619052427.6440-1-njavali@marvell.com>
References: <20210619052427.6440-1-njavali@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:806:6f::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR12CA0029.namprd12.prod.outlook.com (2603:10b6:806:6f::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Tue, 29 Jun 2021 04:10:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a52d0581-23f9-4da9-232c-08d93ab3d1ba
X-MS-TrafficTypeDiagnostic: PH0PR10MB5417:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB541779978197149C3FCB0D3C8E029@PH0PR10MB5417.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jG78G6TmdxbohT+vIse3ynI5AHGAse0PZRF8bGsJQ982q9005Dm4cbKiH2Q5LUOu0jGca2rWDQ8Vyt7Mt6oVyr6Kglvk52IMwNR3MgO4e3eCqLY8baA/NOJAsw4DA1Lg0TsOOEtFpCDHspkF6oTJh+5OZ/CI4gzmg+OygoGo+X2QcwwcFxfT+d1HhUVmr5i0o8Tap3sd3mNZdJ59oBdVeQq9ryB1y4zTdscEmaPybzq3vM2huOBX/12/ISs9nAAz/GRQxUj1ZmmptoM0dfc+MEX04TcscfaP2bUf08Z0E2fP14UHJrwVuqTC4fAurjsjTSZZIgLtEchcEzXCjfgK2PxAvCfeK+Uu9Zzo39m/1MU4UJSnbyUnFc3JA4s4iIekI8mLB72h7RIcMj+zbu/4PMgbJxNc1vYL1JE1kPPWmdoB8lRLW3Kv2BU3Osw5b+ET7SGEkl91XkGZu1ezv/yrMQFL1bM7aaaGzowSghOH0ZGogdzuNP+vmTZRfzw9Mu4+rzyq4xILbe7d13GiRIPVImjqVCEe063/48DuiV0KkejVjuVOVt3qQhcaGKtCApasbOoa82vt9enHbAq7xYI6R6FV6Nrxy2NYZN39Rt2lDwufMb0gcfdan73MInvkG6Vvjrj+ZOr+MXF8avVQDjRfk7aUx7h7amdzup6r2daLmkpcUR6/M0+WQFVKgyoAEVepyHhlxMtrpACcYdG3M1Ntu+YJ8uCTxpel5c13GI7fvLxo9pJ+PyfTn4tkdHpy5bMKo0MmVXIe7cwqciyEtfiq/LQRJxikBrBVRs78jUdeO9ybG5KrPyhEGoH39vIQQdsD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(346002)(396003)(966005)(103116003)(36756003)(6916009)(478600001)(6486002)(83380400001)(7696005)(8936002)(52116002)(8676002)(4744005)(66476007)(66556008)(316002)(66946007)(26005)(186003)(86362001)(16526019)(6666004)(956004)(38100700002)(2906002)(2616005)(38350700002)(5660300002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUtkbHNCeXNmWjExRk10blF1R0Y2OFQ4VFlBOERTOU9uTVVGRmwyYnpzZDZU?=
 =?utf-8?B?elNMZWxvRlVYZUJKOE9RNThhTER5ZG41NWsvZ1B6MjRicXhSYUdBSnJzMHVJ?=
 =?utf-8?B?RklNbFdHaFozMzV4T3VCWFFMVE41UFJkd1RDVnJkR0ZaQVVGcHBhM2xEbjlx?=
 =?utf-8?B?L25RWGx4c2RtRGJCanducDhKQTVKVk5MMHNoRDZtNkdweG5tRVFEUWpJOTBM?=
 =?utf-8?B?ZUNyUm10UVVyc01wejFudFBnUHpCaENhanVzRSs2WEZGSHQ5UUZGNXdXUCtI?=
 =?utf-8?B?bUp0dU9keDhDL0grSXFselFNSVhHUUVlRGxtU3R5MWdBa2kyVnQvMEhmNkdZ?=
 =?utf-8?B?UFlTcVJpdnVDQUVJZWhnejRNWHpRRjgyMWVzNldqMGVBSS9LU2J2cm9OLyti?=
 =?utf-8?B?dDhWNU9nNTNNRng1VkJ4eTF3MkhjMnhBNms3dnJWemJWcmR5VjBPVjcrS0tz?=
 =?utf-8?B?YXZnNDVBem5uUFdEaW1sV0hzaXpsNVdpV1RJaXFWNHQwNVBFOThJQ01ZQXJ3?=
 =?utf-8?B?dGZuRFQ5ai9henRrcmprN0xrOXR4dlJuQjI4K2p3ZURGYmx6VHZZekVjSWZR?=
 =?utf-8?B?TFJNZmt2YUdVTUVwdDJLenJabnB1SmR1NThVeXQxUms0dlB2NmRrWG8xK0tk?=
 =?utf-8?B?MmhXRWxoNHR3czhndkhweWZjMlBWdXFURWRMcGJpaTdRdlJ2MlNvK1h3Q0ZP?=
 =?utf-8?B?RVZmbDZCM3hTYTltbUsrT3ZTV3NqbmVlQ3JBNnlTNHBWbkh5U3BrNnFKb2NP?=
 =?utf-8?B?a29XY1NWTzFTdnZ2WjVaRFRCNnJjUWVtcWdHK2hxVnNiaVNWWk1IUjVOWk83?=
 =?utf-8?B?R0NiK0RPZ283R2gvVXVlVldlNFMvdFdRUGsxb3ZpdEpQYTV6V0F0aDN5MTlm?=
 =?utf-8?B?bFpvdVFaQ294T0dkaXBML2RzeU5kWkZwbmFXTFNSNHRqN3cwdTlGTEdtZXl5?=
 =?utf-8?B?RGV1a3dpNkUzaEQyTk9jVTBFay9sSDRRMW1hYUNPVGJiaUw5TXJPQnRvZ05y?=
 =?utf-8?B?R0t2V2h3QXBKcm0wL3ZOUEgwVTYrVW40ZDZpbW5HOFo3QllWMlU3NVZwWGx5?=
 =?utf-8?B?WCtMNFVlWkxTdFdrWFllb1JxN0c1UUNYVGpnTGZxRmdsdWNLKzhPTzY4T2Rz?=
 =?utf-8?B?TGNBU0MxUGptS1lTaFd2b1grN3BYWHZ6UTVFblZsL3ZkaTk2QVpxbGtxU0tM?=
 =?utf-8?B?WVRzU1RibHVTeENGVHdZTVRHVXU4N1dGeGpxeXlHb2FCYzdPeWVaV20wY1VZ?=
 =?utf-8?B?endnb2lUMmdnNFNqTU5wVHNRc0piQXNCcS9sMjRLUWZXRmZ1QkpuWHBYVUw0?=
 =?utf-8?B?eTBHSDg0dDdra0p1dERDT2JHMmVPQ1VqWGk3NkNoUjQrUVNtek9zcnFuMDM0?=
 =?utf-8?B?OEJwazlRTVBZTEcxQ3hsdFpCNkdGNVZpWWlWL3l0ZlJ3TGtqbE5DdDh3dHZM?=
 =?utf-8?B?OVhWYjhIWjAvZHYvaitGR3NieVdCMnhpR0tvK1dGai91ZDJoL2ptQzBWNEdk?=
 =?utf-8?B?ZDFyc0dkdXpGMXRyQlBodVRMdzltNm5BMFVNclNLUnpvaytmbmZqd280VDZQ?=
 =?utf-8?B?czFYZjVscHY2TXVzTEhIRlFWSjBNcDNoZnNhRVd3RmJIQm5WcHIxbTZXSFdC?=
 =?utf-8?B?UFZnMEhXOXpCVmtlZ0NaQm4ySFJYb09QbGtZNnE3bW5pNWxMTTZ1dzZUbWVm?=
 =?utf-8?B?ZjBDS2Ixdmo2WDE1Z3ZicUc1ekhvVzRRTmQrRy9YUW1jR090ei84ZDZ4d2Vn?=
 =?utf-8?Q?zxgUl+saHycsDWYuddy7YyfdmXVpHPhB5TDAGQR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a52d0581-23f9-4da9-232c-08d93ab3d1ba
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 04:10:24.3671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N5W4nEfXzZ048Z/pa9AwbDuOaf4k8oUKbCGuBRDa+7j2jMSO6xNik3QSoy0ekV3bzT5c7Iif1oZ4rzgnqoA41u+mXeykDB7cTk2smN/wiRc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5417
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10029 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106290029
X-Proofpoint-GUID: d020nvYiY0ezRNA8ReYc0CrvruJuVv9C
X-Proofpoint-ORIG-GUID: d020nvYiY0ezRNA8ReYc0CrvruJuVv9C
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 18 Jun 2021 22:24:27 -0700, Nilesh Javali wrote:

> Use 'no-op' mailbox command to check and see if FW is still responsive.
> 
> v2:
> Change function name qla_do_hb to qla_do_heartbeat

Applied to 5.14/scsi-queue, thanks!

[1/1] qla2xxx: add heartbeat check
      https://git.kernel.org/mkp/scsi/c/d94d8158e184

-- 
Martin K. Petersen	Oracle Linux Engineering
