Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CCB2C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 056326109D
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344738AbhDMFtd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 01:49:33 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56980 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344706AbhDMFs7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 01:48:59 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5jpd7010055;
        Tue, 13 Apr 2021 05:48:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=s6is0slzSdyAEIk2r7bbW893DXIsmPBE1EtB/TVcdpc=;
 b=nCNc/zNULWqHJJKY3OILkn00v9c9DCgREHz0cMMGdE0/oXH/Grl5cfzaeXA0KaofIe3h
 efyhMff7cFRBvC8lMjUpgQa0fJkYJ+VA9dTOK/ky8QATY7VSngNYeK1iVSsJNBPTqDac
 3ULkoxkOX4R3QCb6vvIkg3Okl6ZvoCY0BRWV3WeitUvaqxqSDe64H5HUnT6x4MHuOiys
 4mG3VrXUxAote/r+yEILq9T/AxFAKPHCwjyFtqR+5zQEeRthJSqjhYiOKDZj9EqKAybQ
 oIc68SDkpevl+4ySrpPA2HKb73WPZ9a7oovHTAAZDJiHq0otn/l0yZBQ48YskU8+QQqa 2A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37u1hbdxhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5kRqR137301;
        Tue, 13 Apr 2021 05:48:36 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2055.outbound.protection.outlook.com [104.47.44.55])
        by aserp3030.oracle.com with ESMTP id 37unkp3meb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bh3T50TLQZi4F4UlDr+BxGIygTLidx02YVOwANnxDbHrFsPElj4niLBt5FnppZ8lp2/LdHVjHNcZnMG2QzaOY3sOxKB0dcDHkSGD37zyLrkNhvuuPzRNmHOV0d7d18ih8SNGds6hCqvvLyJUGOiqAZP7F70DWAyjJQfQJGNi4I7rG0wCIlO3SCIDfNKYngZ1M8o8za0/2I2YvLkc8N/NXy2meLg7m1m5ATbt4xxdi0LUZOnXwxhqLaS9EoV0HI6thk7u5IkGl5uZ9/DwITVOmTju6GmbDEAcPMYHaaVbMccIYh+QtUXgEEEnFkqd0GZ5eyYZs4rbU5RwGXE62cANOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6is0slzSdyAEIk2r7bbW893DXIsmPBE1EtB/TVcdpc=;
 b=CaxLa9l0KkCA577ONUFlBH1jURBuFgmXt0gcnyLpfFIu19qDvoCToJCorEhuyzdODqGuqnHwUhNfU8q1vQ2F+niVk7a6hmtLRVTZVAgHaBIbfuZwBetd+JZpKbRS6D8fZanEdS42Y0GCtOd7vktKXpvszWv7LW9691dP8JvvojvB2+U0LmKefgYMaMun5gdysYpmjBDv8X8bCpuCPExxRewupEqgIYFmLgsBlh5klNdXx5JCUWOnpcqE/XHe7nXA9a87wbRp+3AHPIfFyo7pypsZAFmDAlL9XOf1Udz4t+TQAvb5DdArDZnGH0+n+vwF0XjWPdjwKB5lkajQ/Vf3LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6is0slzSdyAEIk2r7bbW893DXIsmPBE1EtB/TVcdpc=;
 b=V3KGczlRLu0zwepuC6grMSq/yCrIPvQ2XcgJPSlQ1V+fTG/xQUOnrSnXxrtPSWUlXE9PcQGFCkhaW09lE0RhfxQuHsTzXN8AfHGsALF/K8XGG675H3EfZRJ2B+J94qb3/APQsnkDYl5ra89PILYmLwjTXTi2Q8DewDNoorRtgEw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4486.namprd10.prod.outlook.com (2603:10b6:510:42::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 05:48:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 05:48:34 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wan Jiabing <wanjiabing@vivo.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>, kael_w@yeah.net
Subject: Re: [PATCH] scsi: bfa: Remove unnecessary struct declaration
Date:   Tue, 13 Apr 2021 01:48:19 -0400
Message-Id: <161828336219.27813.9425892335758391676.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210401063535.992487-1-wanjiabing@vivo.com>
References: <20210401063535.992487-1-wanjiabing@vivo.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: BY5PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR03CA0008.namprd03.prod.outlook.com (2603:10b6:a03:1e0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 13 Apr 2021 05:48:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 186e48d4-87b0-48f6-079c-08d8fe3fc6d8
X-MS-TrafficTypeDiagnostic: PH0PR10MB4486:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4486A2ED6D28E44F64F00AC88E4F9@PH0PR10MB4486.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:597;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YT6KVTyvb7tWOB7QBKSstiS8mDWDiHj7HAtmzcjmUh8o3lxGVdvD0TVJ7wxo4kMDvyfSwJHoLzASxFWHn1uP7Ve+W2lXBdC97HLEdftsKmR1zbw7LGnIvBneyCy/pTjHl9EOLIulZzdGagE/jJ99cuCRo91Zdm0GESvsZKDoiYE6LAT4zPTb12TbsTYut2P0Gi59ytzYYKQ/Cbq+g2L373yDmIeVd2cTwcq4wO3UuOuGOLYETh86dXVKphsUQVLNoAU5pLg3DjC4TgIgFPNPwUY3HfO2I+35AZx80vhzoemHM0V0XxKF50ihX++O/WlCvMu34Mwliisw4KnhRayBTDQ5iNnpiud1+IUp74mj9KkElxArO3tv+1J9tseyTAl/RiQn4SJ9cxcJHOmL2r0SMFq+orcnuszxtA9IgOdSLtdKscdhJr/sfeu2lDCoo/ZI5CVuoTaTHcHlD8A3IvvMJBQEHvExA3pxCCD4Dz+/gu6brDCg+ArwYYsg/LT+IayFUbZOA3I15x7Qxmnegu8EgS80RAB8UXqffIPXszQG3qXVYNnLQ8RAwYsHSK9EyKdDRHKYkuCE+8TqVarREPO32hm+7XeROBGTm/oDG64J4kZiOC2aVJy3wNnhkj4rSl6LEfXU72/bp/i/cxpIEHx7MdDzNwYJ3iQaMo7BOVPWKP0RlusLtCTN/YKUK7sbuh61Wx5LbdWhqd37GDqX0olMIi+LHau5FXjbH5TZd+Oc6hc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(39860400002)(366004)(376002)(103116003)(38350700002)(36756003)(966005)(16526019)(2906002)(26005)(66476007)(86362001)(186003)(478600001)(66556008)(66946007)(6666004)(4744005)(5660300002)(8936002)(2616005)(956004)(38100700002)(7696005)(316002)(110136005)(6486002)(52116002)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q0gxZGxRMlI4S2tKNVp4UlZHN2p3QW5yL2UxV0I3TTIrdFZOcWRadndxdVRo?=
 =?utf-8?B?dmd0RVUzVFpXK2hQcmx4ZmZMdGU3NFYzYzVVNWFwRElGNTRxTWdMTzhiNmxK?=
 =?utf-8?B?UjVYVGpHM2RDRXp0dGpuT2dUVElHa1dpSU5JVHJOTnhLN0lwbmtVamdtdkc0?=
 =?utf-8?B?OUEvQkl4YUZDa2xJVnM3Tjh0eFVCaTZCMWdUWnpjVlRYWFVNUTBaY2pRbVZ1?=
 =?utf-8?B?YzBWTm1URVJwWW5iZTUvR0t6d1RoL0lRN3JnaVM1OVZnNTU4ejF5Mjh6MlRh?=
 =?utf-8?B?RkluLzRObCt0UFpBUEd4QTJIRCtnT1dmWFlBTGtQNExSYUtTNmFGTGhZUFZU?=
 =?utf-8?B?SU5rYmxIOU5DSnF1SHo5NDJHNEZiSm95Mlpuczk1Mm9hUWFvTk5nekZKdmJt?=
 =?utf-8?B?eEFTT1N1NXpXdlZpRnNLR0pTellnbklUbENUMXVLTFZXREY3ZVphbFU3NHhk?=
 =?utf-8?B?U1FCR01sYjIwbXorVlA0N01zL3VVTHNPLzl0bW53NVZpOG1ORUxFK1FoS0wr?=
 =?utf-8?B?dk9MUkJEa3Vwa3pCYStJblh4QUErdjhQWG56OVVTTERzVVVmZHV0dmRqdnJ4?=
 =?utf-8?B?WVJoekg4eFN3aWNKOGZKSEZRYWJXKzZvK00rUjVUZFJUeVNLdzd6QzN3NFVL?=
 =?utf-8?B?aVNtc1REN1hNVDVkYVFHR2RPa0szdlZLRWJFMlVLaWZBL2RTNzVqYWRmc2lu?=
 =?utf-8?B?Sk95QXc0bGhPNWE3elB2Q0JQWi9xS2FZWFA5VUpRRk1LQjgwWjVIQW9kWkxQ?=
 =?utf-8?B?YkNSd2w3V0pqZy82cHVvWnhEYzFrS3BzMHVTNE82NGxVYWJCakNoZ3E0cDBJ?=
 =?utf-8?B?d0VRa2hiV1l3YTBxaVJ5U3dtREllTHNRSm5KRElQc3FsaHlYRHN1RGc1cWY3?=
 =?utf-8?B?YTU3SmJVMXpPTzhZR05OUUdhbkdVRDRacUpMVU16V3lVc3VlYUxPblpBYjJE?=
 =?utf-8?B?U2VsY0MyQUNCR0FabnN3M2txSFBBVlpCcGszcjFBeFVrNkFOWitIZ3AwQ0R3?=
 =?utf-8?B?bzhUaW1COWFYQVJZYzgybXpkVkg3WFRUNUJQUWZFYzBHWUpkWFRPUmlWYkxu?=
 =?utf-8?B?ZXRJUkhCYXNHNGpSZVQxcUF2UVRyT01qaVJhVmI5STRDSzFsSWh0Y0dKRjlW?=
 =?utf-8?B?VVhtVklGY3gwd1lmd1dlQlU5bnBld09IRnVwNXQxTDI1WXZ4ZXRIdXRML3B6?=
 =?utf-8?B?OVZpRmFyd0c2MWlSaytRNmI1ZGRpbWdQcEt1L05yVC9lYUNvdTJWYjcrV2FP?=
 =?utf-8?B?bDdMMXFoYnJMSkRTRlRrMElqend2Y2JibkVCREU3YXZDZ2xYUDc0ZFp4bE1Y?=
 =?utf-8?B?bWtBMlZuOEcxaG5BeFA2TkM0TGpkMk9udGRLZlpNT2VUVkVjOFZFRWsxZFJw?=
 =?utf-8?B?bTdUb3hpYktxdnNZU1FITm1FbWYvSndNTnFkR28rd2tjVzJKQWYzOEVlMHlS?=
 =?utf-8?B?cWJ0NWZSbnhjQmpaYVhMSkdwb1kwWlpPQmI1eDZ6dks3Q0VIQkpjVm90Ry9P?=
 =?utf-8?B?SmVOUDg1QzZLK0RIZHBTNWF6UjVpc1p0bzdKRHFFNU5vQjhEVVdEZG00dWZt?=
 =?utf-8?B?VHNYWEpBemJna3N6YnNIR3NWZHpSYTdyOFpheHR6ai9raHZodXZzNjBVYXBz?=
 =?utf-8?B?SnRLYTRpcmptZUhPNTd3eDB6L1B1TFRxTUNlVW9MUTI5U0p4ZmdteUs5Rlhm?=
 =?utf-8?B?NlZUOGlRblZhdWViRFcvU1dKQWxLNnFKK3UxNXFlRXQ3b2dGQ20zcUlpd3kv?=
 =?utf-8?Q?QHSGjtMFMBH0TeAZF+QXZPod2ewTJkQTU6vOVOb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 186e48d4-87b0-48f6-079c-08d8fe3fc6d8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 05:48:34.7258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QMKDsn1HMKgaVYd6hUVOBzZE8rqCbf5W3vZz7k+nD3GtFKrhfYxT5HLiKozUlHKxMg0b11qHmhz5erNpyXuMVNPWli+/HJgSJe8Leylse5Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4486
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130039
X-Proofpoint-GUID: ZxeeOGyGweG6nu9D-y5wQPunIGHhzgkY
X-Proofpoint-ORIG-GUID: ZxeeOGyGweG6nu9D-y5wQPunIGHhzgkY
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1011 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130039
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 1 Apr 2021 14:35:34 +0800, Wan Jiabing wrote:

> struct bfa_fcs_s is declared twice. One is declared
> at 50th line. Remove the duplicate.
> struct bfa_fcs_fabric_s is defined at 175th line.
> Remove unnecessary declaration.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: bfa: Remove unnecessary struct declaration
      https://git.kernel.org/mkp/scsi/c/c3b0d087763f

-- 
Martin K. Petersen	Oracle Linux Engineering
