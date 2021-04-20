Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B1EC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2958613AC
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbhDTCaO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:30:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49462 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhDTCaO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:30:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13K2TTsx183338;
        Tue, 20 Apr 2021 02:29:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=DRFxT8SGsQJhJkBWiOFa5v+AOvlHmNOeF1saD/h3O08=;
 b=J94ymc2pUXYwNm9u+lywqmszuwf8J0L/2s5WE3zHjhMvWiCJh2S572SUM14ciVmcrjFS
 ZFtovcARQHQDmBcyLozTV4LuFs9Y6aR3Fbo2DUApb7A6WfAh8yOGOKJeIN39Brcu7Xkj
 sOedrFTjrPh1soNUuwkKF3hj/8MFlda+IMN9RLcz2aDI7naIhRSjFJlYE0zSjrgstAvb
 UHdg8gX2Mw+btXKcJHkVIlajFsSokMyh2CNueGrfzSC67xPpViENz/ykj1QOhh/Dxxjv
 Bht1w9EMmd1OCjdK2z7x2yfwLeXJeQsgHnpzr3zMsTwj+G4dDhLays/SOld1iIpVXvip hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38022xvyqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 02:29:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13K2Q3ak190138;
        Tue, 20 Apr 2021 02:29:23 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 3809jynevn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 02:29:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QA/1SOFS+IO5kKeOoWS15WlYqWrMJ5MSH3hzqByoR+K0D92dOTQ5vAV0+OyoH+euMtLPRSZgAthDbbmEVMj2giiOVaNMBTj2edZ1pr3v7XOh0i4+/pPdvnlHXxokfxzRSuUPlHB2kqk0fJVmVTHygstoiPMqhTyLuaOWBzG053JcjrqikiFoWhQboV+NHXtAZHX7KEloAQAy7PVa3MUy8gw2dDJQa4lvnvqr5mJkiMGP/MLNUXst1IYq5kYYCqcUEcLJhTYeJEqsfSqN1pDQbLWbhRczViioNj/d8rXedgVqo+H54KvA6NwPkWfhPjmD8uZF8rphuMxj8jQq8c/K0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRFxT8SGsQJhJkBWiOFa5v+AOvlHmNOeF1saD/h3O08=;
 b=VJQWZz2EQzufAeLjqioXqQjk0uSHjOKnHZW9UOAWmzejn5GSvpSlRWP0gaYsKen1Qo5BJa7JW4oHtqAqawlnZq2YmGQZEui7ZVaQqhP7LXKrD7I1H8AwhwyFK9ehfYbDckzw4wxvtgma7KPLeVltLmzCFQY/NqDdhaoYRBjAG5/icYq0vd5KRD5DRSk2yyynYxNlyaMTugGxLy5Of7g0SUJHGFmaYFKPpgCmaEesWG6vIDajhqDLYH6dcmeDx4WCGViFUrCys/JS138jbqEGDGNaxAhwI/tA5z1f/pZHyiVP+NzlGs919G8YsPsCegnc3WRu0i1Vpp8er8f240CUVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRFxT8SGsQJhJkBWiOFa5v+AOvlHmNOeF1saD/h3O08=;
 b=GKN9Jrd2ZmOBEAfcxTyJBvIFEkYOv79hMZtLPn8lH4Jl0+mMn9gntcLHW0zbzlD4gRdYXyKROGrRt5PW2B7nAHkl97IhF6hqAHmHeFQEroq+2qVwk9yZz5suTGcIMB7xCAsjBNpcwzbDOje2fYCGeaO3SsvAZAtgNAp5ctz5RzU=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.23; Tue, 20 Apr
 2021 02:29:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 02:29:22 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Viswas G <Viswas.G@microchip.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Ruksar.devadi@microchip.com, vishakhavc@google.com,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        jinpu.wang@cloud.ionos.com, radha@google.com,
        Bart Van Assche <bvanassche@acm.org>,
        Ashokkumar N <Ashokkumar.N@microchip.com>
Subject: Re: [PATCH v4 0/8] pm80xx updates
Date:   Mon, 19 Apr 2021 22:29:13 -0400
Message-Id: <161888563604.11594.5318075766215807285.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415103352.3580-1-Viswas.G@microchip.com>
References: <20210415103352.3580-1-Viswas.G@microchip.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:806:a7::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR10CA0006.namprd10.prod.outlook.com (2603:10b6:806:a7::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 02:29:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ec54a64-3f14-4bd1-c7cc-08d903a41b83
X-MS-TrafficTypeDiagnostic: PH0PR10MB4536:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB453639005EE3E7D73BF3CFC98E489@PH0PR10MB4536.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RFq7O1EMqshl2R37g8pyJpqgp+zEinF1gCwLtWGGNvX1cgyf1YCd60BjH+zbGL6WIBXmUrTy9KqM7KZD5ur+YoxXSB/jKk3dKPflOHwWdf9/sXKCcZoz5n6oQPbhJ/Eqt7u6BZlJQIkfTPLdZpvW8E3UFMBQRm1UR75+l49qQPcF05OHoc1Nt92pa1NKo+41SrAHk6+F6IIqujiQ68uoEGdx5JR6V2bmiTdyuoGv+b7NFZuW6ZMiUG0xgrxQckRQbtcqNc7QcDvIYqy0yq6658DiZXHJ6IaXTa+xzzqPjDWDllk/xOh7+47S4/iTrG+jSUIY+Qzm2TzKQJLxzZoOeVYQjGXw+LJnV38v70ssHuYg0TZRZ0MTFAHO3ZhCxZn8knjoEXNhT+tslNeMeTL75EcWergzYFhomdcPGjbwB2gUJzsrV3xB8giwbuESyBDuaDV4ETO64wkJ4X2/7wUz00IxDxCV9/g84q/RsbwX1ac7uNqjrg9c+irTkTDK0KnlElCMDI3RtU1VCrFd1VTFU+6V+sV2j6Sy2BIgnNYZkBRKRdxiO+kpack+Lf0Byu/3togaEZANmwoGKYty4EiiFxeUDBQG9902UoQumYM5nx7YglgVOUvoUfPDDXrS7oe7h884YceulT4N6NICuRvV11wDCMwzMBj0Ga6D3ulZK1tYBDcwdT42/oIKrg2DK1LSuckiOX7ybYlALyCt09jbDLbCUwKdVs4q8HfSFHp3PNY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(366004)(396003)(376002)(2906002)(7416002)(38100700002)(66476007)(52116002)(86362001)(54906003)(5660300002)(38350700002)(36756003)(8936002)(966005)(16526019)(26005)(66556008)(2616005)(316002)(103116003)(186003)(4326008)(956004)(83380400001)(7696005)(66946007)(6486002)(478600001)(6666004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WkZ6dk9WVlNLZVdsRjFHZEhDSUFONkQ0WEJyNmJUcVZCelhRVzh0bFNrMXZQ?=
 =?utf-8?B?bHNuTjhPZkwwS0RRcWF4VVNtKy83eUxkSmJDMmRURFh3bGdBeFpHMWJxRTZT?=
 =?utf-8?B?NGgzdjdwMzJVb3F5a0xOVzBGV3pKTXQzV1YvQnlsSDN5TlRjSGVLdlJMTGxL?=
 =?utf-8?B?V0pYMkdGRlREUzY4S3MrcE1wb0J3OVI3YUpDNnJGeUtXZEIzUE95SlBoeGJK?=
 =?utf-8?B?K0hTb3RZS0pETndWYkhVS2t3aUNZeUdNbFFvTExmTyt3WDNXQUFmbnVaNHB4?=
 =?utf-8?B?eko2N0l5R0RjRmZZV1E1NzBMRWpOMnBxa0xZMEdlNkJsakFZTjYrdTlKdGF4?=
 =?utf-8?B?ZU9abDdTZmNKYkVlMmJZR0FrenhPVGVlbHlkcndFZjhZTlNtc3RUSm02YnNS?=
 =?utf-8?B?Rk1oMnQ1K1YxTDhlT0ptRmEvdnZxL2FOcnNCUWsxQ1ZyL3RXblR5NEp6bFYz?=
 =?utf-8?B?YkZmd0pFMVBZaXFsWnJjR1NyYndJemRXMlFHVjFxcjhLYlpkWkpGcytLaGxy?=
 =?utf-8?B?UWFzb1MrNURsRmczR3R6SU9RdW9ZMmN6aitJZFhaZVhVS2p3VXY2eFM2NHBa?=
 =?utf-8?B?S3g3OE5SSUtseHEwcysyLzhHbVZwTzl6L25hd2FMaVE5d3V1YzV1SUN3Y0Ns?=
 =?utf-8?B?WVR5a1ZreE9HNHJqZzRQYm13YmZjbE5FUkM5a0lmU1IvN1FRV1E0bm55OXlB?=
 =?utf-8?B?ZTAwc0gxSGh1djhpMFZjK2ErazF0ckVMV1YxL3I5c0RIM3J4L08xV1U4QzBp?=
 =?utf-8?B?cmNXY2I1K3dhSmRoamZDenpqeXVxb1U2RklJSGxkN252Z3lvRzJBZnM3Q2xa?=
 =?utf-8?B?Q0Z1Q0x4S3lPZDRFZmxWbXI4Y256dGRRT0xFRVBialRuRXBPaVplQTJRaVgr?=
 =?utf-8?B?ekd3U2djeFBBc1Q4T05LVDJnVFlnOFk0MmNpNmZEblFTWHI1cWQ4ZFFDQSt5?=
 =?utf-8?B?UjVVWE1TODRiUE8xYy80U2oyVEVVWEpucDVzczJNQTdXY3ZLMEpPTlBLbXlv?=
 =?utf-8?B?UTRCZ1hBUHRxbVJGeVBaeEcrWUUrdFJ0aFdUbnNEek1ZWmN1TnZLRWJva0xU?=
 =?utf-8?B?eTdON2NaZVp5R1J0eEtOYzRoUjFKZ0hOb1VicHl6SnpjRWg4eEFJUk1qTG9W?=
 =?utf-8?B?a0NsTkx4Mm8wTTBwcHpFVDlxcEFuM25VcXdXZTNuN1hNdUY1d0NQSTFzZmRP?=
 =?utf-8?B?MUphcGxlckdCb3Bsd1l2dTYyL3NFU2VlR29ZWlRpTVlpbjkySE1ya2ovMjNq?=
 =?utf-8?B?MGhLM3l2Z0svVHJnWHlQNTNRdDRLME5UYXZROElpN25GRk9rc1ltdFJXTGFy?=
 =?utf-8?B?dm5SRUVBWHArSjRvY0xLbGpqZnJyTmtudDJjeFQ1WmpXOEdHZTNjV3Jhbjdy?=
 =?utf-8?B?ek5hcGlTdkkwTThPenpOL3NuS2pIMTZNU3VYMnZWS2Z5UFNPTnljWld2WU8z?=
 =?utf-8?B?U0FsclNpMmZQSGJkUGdVZllFYmcrSWVNUDZTUEU4MDdnME40akMrQ0EvYmFM?=
 =?utf-8?B?dC9DYmtsU3FSeFZ0Q3pvZjg0MExFa2VzSWtNRWRrZDNvVUFnemF6aHJ5TkVO?=
 =?utf-8?B?MWI2S2owZlo5WTlWVWI1Wjc4L1VYUzY4S3hjcHg0TExRVmZOaUIwTC9hQW12?=
 =?utf-8?B?Z1lhTndLL01tcm5YZnZIc3VzdksvamdrUFJnRDFWRFE0YWYxbDJkdHV1d04x?=
 =?utf-8?B?MGdaYnN2UHNiNDU3WFNYN0ZZTCtFSGJnVW1pRHc0MDRsMGxIZlJOdzdESjhh?=
 =?utf-8?Q?GcC2sp9LpHP5XTl7k5UAButMj7O15Ii4o5jNEB9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ec54a64-3f14-4bd1-c7cc-08d903a41b83
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 02:29:22.2359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wl4uB8Km1Gv6jV2K7ZwWlsnLqPMzEqDJQpRFgWM/TOv0KoJxl+rXMQ39PyJXZpdOT6jHrN4mAR/NZCk2WcPMv01/OUeRn/IWR9QrZrwbATo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9959 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=917 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104200014
X-Proofpoint-ORIG-GUID: 9HZtNVPQCVPZg9lkFMKHsU0Jrn6N0suJ
X-Proofpoint-GUID: 9HZtNVPQCVPZg9lkFMKHsU0Jrn6N0suJ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9959 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104200015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 15 Apr 2021 16:03:44 +0530, Viswas G wrote:

> This patch set include some bug fixes and enhancements for pm80xx driver.
> 
> Changes from v3 to v4:
> 	- For sysfs attribute patches
> 		- Removed the unwanted variable 'c'
> 	- For "Add sysfs attribute to check mpi state" patch
> 		- split the ctl_mpi_state to two (ctl_mpi_state,
> 		ctl_hmi_error) as suggested.
> 		- Changed static char mpiStateText[] to
> 		static const char *const mpiStateText[]
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/8] pm80xx: Add sysfs attribute to check mpi state
      https://git.kernel.org/mkp/scsi/c/4ddbea1b6f51
[2/8] pm80xx: Add sysfs attribute to check controller hmi error
      https://git.kernel.org/mkp/scsi/c/a4c55e16c500
[3/8] pm80xx: Add sysfs attribute to track RAAE count
      https://git.kernel.org/mkp/scsi/c/dd49ded8aa43
[4/8] pm80xx: Add sysfs attribute to track iop0 count
      https://git.kernel.org/mkp/scsi/c/0602624ace23
[5/8] pm80xx: Add sysfs attribute to track iop1 count
      https://git.kernel.org/mkp/scsi/c/b0c306e62167
[6/8] pm80xx: Completing pending IO after fatal error
      https://git.kernel.org/mkp/scsi/c/4f5deeb40f9c
[7/8] pm80xx: Reset PI and CI memory during re-initialize
      https://git.kernel.org/mkp/scsi/c/b431472bc88b
[8/8] pm80xx: remove global lock from outbound queue processing
      https://git.kernel.org/mkp/scsi/c/1f02beff224e

-- 
Martin K. Petersen	Oracle Linux Engineering
