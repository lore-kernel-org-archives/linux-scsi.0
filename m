Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A047BC43460
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72CEC6113D
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234323AbhDBDyp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 23:54:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59378 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234011AbhDBDyj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 23:54:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323o4HK112264;
        Fri, 2 Apr 2021 03:54:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=TZyYtontyJrwbkW/xCuMtc/UREUhRcuwYY1JruU5A08=;
 b=Kry5J3l724FUJk9yYjUqGYEypGRnLkHozh4DE8WkJGYewa8Rsg/z7ZhCAc+JkEuDZ1du
 eIbJTosT3ZXKpsLQ0tHRBz+rg2pKaj6LhWNnpRaMashb2hP6enoJSwfCFEIadR7FT8Si
 q0+AB+BXC17weND12hHhdSvyUOB1lJt68/mLqwKPvShszy3OrkFT23huDrt6pRcocn7n
 +9JVBnadfzw9QFAcNC7h4mEvFcBP7U/NrPa/hUaan8QDtc7QQCtbK+Hkeusqhl2Fo7ek
 lCqi35h+rvbVnj/+NrQB0rDLMkR4NqLCAdJujyrtyvOc7qU+g2y5OvNjaaHjO/4zAm7M 5w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37n2akkq75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323pdq0101561;
        Fri, 2 Apr 2021 03:54:37 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3030.oracle.com with ESMTP id 37n2atmxf8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGY/VtdxmjBiIFmO1E64k8zG8fhxd1UXCsLQ5zFPk4IyBW/t/0W0Hwbz0ghBTd0oETzSX/O0rVRNCwQ/88IEeWFWDiMVhPIQLZF+M3PkMckwouuH+PTzn81k1SIm8POAzB3gnMsnLHBdsbDe0x68BtE6pO6/xA/FEDGWkj8rnscnAoockgXEv3qJK3v+Kqo/ZtvRhOd9wRGzV5DR+NH2b90OcKvzyTc2SXOJR964ISfFezL3d2FA/ExEUyWUwYNerTZN2hRIBpbnifIj+vZjniPKt+dKVBeqiZcSVlqopHa1Ry4xXJbAgcA7QWtfI35EFGmbe+hB12IlhNGBJOq06Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TZyYtontyJrwbkW/xCuMtc/UREUhRcuwYY1JruU5A08=;
 b=DfoiAtV/ZvuKujSLk5Jn/5EhgJgsTmbdOSo7YRB7GQH1R56yDJZPbTRHDBtQ3KcHqsgsrlfD7TaPlvrZ0/gAlVnYPtvd49n1Qr5uwq6U2aGz4MjxTtCK30PSgOepT+ZpLfeAZ5PeeN+ZZlP++HlszfP8C1EWRsF80rz1oimf0Ub6K0hFukkoMolVRhlq+q7KPt1oWw1i3HCZnYVXzs9CuwVpDiJn3HTGEkSa3k8nW9NxjAXj6Gb1BD1SveoZrF0ttizBKYnyoxPA2dWpeSGEEtIxQykXUWviyw1b6p+FREQzmHepimXDS3AF3K4MpFRkxr5qVy1N9pvYq1s1QLoY2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TZyYtontyJrwbkW/xCuMtc/UREUhRcuwYY1JruU5A08=;
 b=Tc00bmhHV39d9MuOUTfP4A+NNeRXQUlNLaQWjBSSvABPazaE8V/hjlhnMT8fE9hLX3j3FV9UXwLM3ikV3guYJ5jKrLkNjhMRAJwGXUwrpnHrt6mJxWlutovpiS0VTxRzBMXrjRZFTe0sOFWZ0rBKZ9NccNVooEIgttPnLDolgjc=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4680.namprd10.prod.outlook.com (2603:10b6:510:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 03:54:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 03:54:33 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Wan Jiabing <wanjiabing@vivo.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>, kael_w@yeah.net
Subject: Re: [PATCH] include: scsi: scsi_host_cmd_pool is declared twice
Date:   Thu,  1 Apr 2021 23:54:21 -0400
Message-Id: <161733541351.7418.10594825800308190224.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064632.855002-1-wanjiabing@vivo.com>
References: <20210325064632.855002-1-wanjiabing@vivo.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:806:a7::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR10CA0007.namprd10.prod.outlook.com (2603:10b6:806:a7::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Fri, 2 Apr 2021 03:54:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 110da7e5-542f-45b0-fa68-08d8f58b069b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4680:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB468016B7EFC9DF6CBECBA0C28E7A9@PH0PR10MB4680.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RbL85fhekucaoQLXL1podQbAsc0MsgSjxIscPURAPtdaXQwoPIv/GVybS8bCtDDfAzgFFHC8MnfcMSPjpzN2mf/JnaD6y7ms775ye6vD3FjH7our+FkflIya0i2fBZ4WnSL2Z4zRp2v7vWZgDB3BkliXyftVxIjfmuZyBhgygwG1wnFNtOWrDwKigq3dcIdj1CzhzVmwc8oAfPJm948HbkT2PkZTY6vQ2chzIVB89Lstpa1QSdNKtONRow4AQJAP9UQib/PBjk7HT5Ll2SE0VVgXDVFohd3mir6Zj518XWOSWRassWHID1n1ZHj7yCw+WAmEqiKODWmdod4VPWPdj1AYxqqet/VVxDCC/Ji3MJmeglQr8nZBL7D/K/HQcEFmJkxXz/Bk0uUEJW7hCgn7EkStTZnC2kMpDjFtKP60Vl5nfnN3AEAeQK+mVe6s+lSpCMf7KFemTPRvjlE2spoWUe74Xv0J9Ji7tof+N3SXo9ewh+ko8z/Nxtztl2wrcX8PrWkMeSQzJNUghebJ/Bguqqd8taRRHb6c3PMfdsLxs/gjWLBWOEv14R2ISuhjkp6OPHbGw0U/bo9Pjw3GyBgV2qfUiWnFUKL/d1nU0ALqFSe27nPiWZljYdwRn/+qbUlL7YLD6eCEuqlxx1pU/VF6p3Ng992pYjiqBgSHqBqtnXYj3Msjtq6h0NQdMB9QQsao6Q5o/QJNo+aoWoOWcF0MA1kEATKuK0S6U2sHbXm9Fls=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(396003)(39860400002)(366004)(26005)(2906002)(2616005)(38100700001)(956004)(16526019)(186003)(8676002)(36756003)(66476007)(66556008)(66946007)(86362001)(52116002)(7696005)(4744005)(103116003)(6666004)(966005)(478600001)(4326008)(5660300002)(6486002)(8936002)(316002)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R1VMWTZTb3RQM25ONzNCOUhXa2Y1aVY0dHFZc2NhZ3h4VjlkT0xjeVNGM2g0?=
 =?utf-8?B?ajNRZ1g5SHZqVDJhYjV0SWRYTlB0QndVTkRYTFEzRlA0VWVPQ2gyR3hzblo4?=
 =?utf-8?B?S2xkZTVybER1dUE2NFU1ZXorWk1tRm5qekhSTmZiVU1kRUk5TTZiTlRyMEtP?=
 =?utf-8?B?Zk8ySXNHVDIxVlgzVUFmSCtVTWRucUV1d3ZVMEhtdndnRlN3VmtNMXdhQjJi?=
 =?utf-8?B?dFZ5a1lCNXBXbzR3MUg2MTB0dERYTjRhOWtkOFBRSmxvRFZvRW42ZUozNnB1?=
 =?utf-8?B?cSt4SjJ0MlhyTjV6eWlyb2xYblhLRHBBSWlmTDZYblUvWHpGNGFrUmNPVXlJ?=
 =?utf-8?B?QWNIMXNLUU9jNXdFMDR1UllzWkdIUmRWRk95UExDYjc0MWJ5QnA4OHg0dnNC?=
 =?utf-8?B?a1cxYWdNbFl4VDN6UE5mbzhQQ21IbGZ4SVdlaWd5ZU9NbitRUXBMS25mY1RK?=
 =?utf-8?B?S2pzWHlUQ0E5UFdNTVUyend6bmdnbGFDdlpDVFhyd1FaNUFFNCtJeEtYZTVQ?=
 =?utf-8?B?dlJ4UE84TC9DRmkyTVpJUFlKQzZoQ1p0ZnFoa3hCMnFGRFdzTC9qY2hWN1dM?=
 =?utf-8?B?cU9yNkFFVmxhZmpDa1MzTHN3cnl0VDdTSFdGdmEydzh4YVgvaEVxRkFiRDRM?=
 =?utf-8?B?TUlvSUtkWVlNa1BSZDJBUzJJKy9Fd295UkJUN2FyaHRrMVQ0QmI0ZTdtbHFm?=
 =?utf-8?B?YndldU1rdGN3WUdLRmorZSs2aWsvZWFBMGRKWXBEcmN1SXNaZ1hja0EwLzhy?=
 =?utf-8?B?eGFZS1B4Q0hqMGJETEQwZVl1dXdPYjc3YnVBN1hCWmZUNWZ6MEhLc0VwVzJw?=
 =?utf-8?B?QW83SmR5azdqNDMxNkszWEVSYkp5emN1OEliUUpqZVcxOUZJMlBrSmlqOWpv?=
 =?utf-8?B?STA4K2lBTlZGbSs4ZG9va2J1ZEhieEZwRE4vMUFIUSs3ZFJIeFlkUU85cHV4?=
 =?utf-8?B?ZVdhcFYxZUFxaXNaQjNNRyt0dXp1M3ErQklIekYxUVNtZmNXYUxZcDRkWEZX?=
 =?utf-8?B?UlZFUFMrTld6eTlBM21rQVhuUjY3YUdLRXg0OW5qbC9yY2VoM29PbFVQRFdH?=
 =?utf-8?B?SDBnWStvZTdqYXVMTDlEUmxCNVAwaDdQSDFTL0xUelB1dmtGSTdKbGNMSVNX?=
 =?utf-8?B?V3dPL0FWK1JOMXpNOFFlalUrbkUwbWdGMVdYd0d1dEduSllwaUhhYTU3T2hF?=
 =?utf-8?B?cXIyV0VhMm1pK3F6M0YzQm9ZaTREVy9ZRHBwZURaK0F2MExzb2pIaUlqckcy?=
 =?utf-8?B?K3FWRzMyaEM5Sk16T09WbFRvSk40Y1ZxcG00TUR4S1p0cTlXMjFsL2VaZFVa?=
 =?utf-8?B?bzBuZkpxYlhuV3R3MVhHd293T3QwbVRQWk1ZNTNpeXFIZGhrNElXbHF5NWJy?=
 =?utf-8?B?bGg4a2ZPZDIxcDIzWWl3N0RlQ205allsTDg0VVM3OHU5Tkh6VHNwMXBDVXJC?=
 =?utf-8?B?R0ZFaGRsNXNyWTZOS1VwZ2s0cEpUQ0t5UDRyQ2cwYnN4NDB1b0krQzR5ZU5T?=
 =?utf-8?B?VGxXYitUTGFlUDVkMGpvRnpvRkdUYUh3MlVGQjBzWUtXVmRIcVkrMmJuNFFZ?=
 =?utf-8?B?WWFOMmdiOHVvdGpmVXJsWWVTMUtEaFVSZU9ObU8xbURpdHc5YXVHZXZNRnNH?=
 =?utf-8?B?bU5Nem01cnJwZEp0ZkRCVUdVKzRVNFU0NTF1MDNEbHFnRW8yeGVXYlJSeFJs?=
 =?utf-8?B?ZU1GNGhvcWxVdDU5TU5VY2Juek84SEZoOHRrb25LZWVFUS9TeGtkV1M1cWkx?=
 =?utf-8?Q?W9WQ7KXlQnrCSiKPkslq2NnIjICQnVIqPSQjIwM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 110da7e5-542f-45b0-fa68-08d8f58b069b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 03:54:33.4563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V0uH6clDkveux/mSqyeBFqKkNQnHkrYL/vBLWgwIMJ4TBmFcOlXwBU9LXs6c9syLVK/nEDmEjowOQc9hoGw10+HEL2ZhgDErR6+llW+FPNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4680
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
X-Proofpoint-ORIG-GUID: iBbhrtiHcbZNFhsyJL2qNQv-7sVtqZCF
X-Proofpoint-GUID: iBbhrtiHcbZNFhsyJL2qNQv-7sVtqZCF
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 phishscore=0
 bulkscore=0 adultscore=0 clxscore=1011 malwarescore=0 priorityscore=1501
 suspectscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 25 Mar 2021 14:46:31 +0800, Wan Jiabing wrote:

> struct scsi_host_cmd_pool has been declared. Remove the duplicate.

Applied to 5.13/scsi-queue, thanks!

[1/1] include: scsi: scsi_host_cmd_pool is declared twice
      https://git.kernel.org/mkp/scsi/c/6bfe9855daa3

-- 
Martin K. Petersen	Oracle Linux Engineering
