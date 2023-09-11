Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1453AEE3F02
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 20:52:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237429AbjIKUvb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 16:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236433AbjIKKic (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 06:38:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E57ECDC;
        Mon, 11 Sep 2023 03:38:28 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38BASDPP003744;
        Mon, 11 Sep 2023 10:38:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=favm8SsrKqDbeBYPFftwwnqnwufmrbyXB3NkpP4uVbg=;
 b=Ep6XLAcn8YgL3Mejpa78lOLuERmqtDcArWftECj1p9x2ZXRKCGvfGjcWq7tx5phvz5LZ
 WomtPf2XuLjmK7/JAIKcEMlNkFll70EMXtvox263++wFI6aIs3Pd0kfE4o0IHt5ervit
 99hm8TyiHA9NnkBwl7NST8nHPvUk9bc3PAe3UzWPEQ+rcrMlt2iW9gRvQ5snaU5b7AoR
 o76111OpDeqnUBWiYQL3EUS02QtsCJYpPwynAoUevtH9i6f6Clu9MtKo1im1Kgl+RLV1
 Nv+7djct2/xrcbt/QXHCIgyoRjxb3W8QjW7VQoQ0wdr+GscsIW5/EDZchSyM9KumSFZx tg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t1jp795m1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Sep 2023 10:38:14 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38B8Fr9a002684;
        Mon, 11 Sep 2023 10:38:13 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f5a96u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Sep 2023 10:38:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aoIg3bqfvfwSC1rh7LN2FP4SQTtSwovGKcdjeD7zfiPOfGjnlQjMevHEJCw0H/mVp2Pg+yUZEM2q7rQsPEMCzGfXqdFrsrarLt4BVCEAwCWcRv9tcBtfBSC8MBTgBWjA382KiqC9//R5NmTMIC3n6Xs3U7R+mGCEBUcQYaADA9nYT6CFMmEgHxIyZl+RVVWZLy4GJIXYm6pByp3Bfv1sUT4ko1RWqHw/bMwgxHeLkeCcJ7bRjbKSLhJo/s2gXYgAQtMGN8V3JJvWCgztzvSMmV5X2SREjvr/hLuwRF1pljurN42Mq2n5gAIStX4Nrtb5kaWe+iHt9FmNPXt2gt0qng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=favm8SsrKqDbeBYPFftwwnqnwufmrbyXB3NkpP4uVbg=;
 b=C0Wwhdyvjxfl7piOE9Zzy/g2mC7umIJ+Pjr1PEjO+kXDJam3z7G6WGSSE8atJdHuXrMEDMOvvgN7F+N2k+F1mEtKZu5nAfOMD8aXKevK2WO0q+QALtk2YPpK35lGVpBA7GykpPVjDSZLCJTOedZIiLBBWr/P7ZIW935i3Qgk6Rds7M9+OIP+SaFeLgMwRTCUOEyAmIvT9gdfkW/l3y54KPVVtKG/Vznqx7K/w5DBGDAONBbWVSPx3LBvkZGeeOWA9QUV3pyXPHCjIOJ4n7ctp5MwllP5M5ZplHpLXij5nrIBpHbFj41EzOxmo1haSgeXP9+9KLvfrSnS4pu8Xbvdvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=favm8SsrKqDbeBYPFftwwnqnwufmrbyXB3NkpP4uVbg=;
 b=RCg2wjKs7VbBKrFr/PECZVFaiWX0FmCB08jSXVmm9ZPBa0DYHD1UPIBT9uL6/D7cqPSvhhFdQAn0TqJWxfkk6EfLT5NXY881plPCOAd3Saxx3I7YTBLezKQfn+B30IceJB7aUOYCS/fEQFWNlQ2FpbekCagnP+JqjC6BFled444=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA2PR10MB4506.namprd10.prod.outlook.com (2603:10b6:806:111::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35; Mon, 11 Sep
 2023 10:38:10 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 10:38:10 +0000
Message-ID: <5825b4b9-0bc8-4c27-d576-070c7113e1f8@oracle.com>
Date:   Mon, 11 Sep 2023 11:38:05 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH 03/19] ata: libata-scsi: link ata port and scsi device
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>,
        Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-4-dlemoal@kernel.org>
 <e8ca70d1-9c88-4a80-83e4-a65f4bbe6b72@suse.de>
 <8874a3d5-355e-c354-fd85-0dfa7ab77b54@kernel.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <8874a3d5-355e-c354-fd85-0dfa7ab77b54@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR07CA0015.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::28) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA2PR10MB4506:EE_
X-MS-Office365-Filtering-Correlation-Id: 64c53c63-3757-4785-4049-08dbb2b331a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sbhCVGKakvmyybDo1vdDyBtdJLElr/Bk6jd8BkLNDwwHGcDzk3eLxJ+SmjMM4d79yhotg0mPJXs/qBHepA3BeXU+mC1+cZIcFGnB/2aVdackDiypZCFlUjPBccQ2bnfOIiEm5x5TsZdcyRGDSx++OzJyvW8MZAUSOzxQAm7UL33impSnPoL4IblwqPfHXVL8Zgd8XxqJwV65bV/2eF6cHtOvt8CBQUJ6HTcoSVhkcRwk+vsMoUH8+/L+SnvoKU6RS2n/pwSwTV7pU5MoGTddjksF9Kejg4XyEyBGsiQcf65rPFpb8delTec93v67+8P9WNHI3zcSj0kmc6t/txus1w1KGn9qq+/DmCJoCJcSRcCUw8nAKbOhRYQyPB+Pdidra34G0eIgLAqncf9tULi59jbx82hgCUD/3L4TjoMziIg4Nzw0CCqwSfjcrPsEirCE8qTwuvHjcjE5UuTqC6XAmT8cQFTMDqXZ6JSfKwjjIqBzFkJzojI8sT9gm3h8Jq0jVdg5i2dq0GbG0SIljqb5l2TyQBN+xw6OrImWR/r1C/wxaxxJFELpXMO+DHigb703uGe0X1XrDIEL7tJuNYBC10hf5TVl3EqbdCuN1BJAP41h2Bphf7qsgBXdwGqI91EPL0EpVD0VHpyIdQ07myZEkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(376002)(396003)(346002)(39860400002)(451199024)(186009)(1800799009)(66946007)(66556008)(66476007)(54906003)(36916002)(53546011)(8936002)(110136005)(4326008)(8676002)(2616005)(478600001)(6486002)(6506007)(316002)(6512007)(41300700001)(83380400001)(5660300002)(26005)(6666004)(31686004)(2906002)(86362001)(31696002)(36756003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0pPT1h0VkE1cEFyRzg4UHh4ZGF3NGNLOXlYdzlhdnptRUVuMlp0SS9CSlhi?=
 =?utf-8?B?bFZNRnhTRzRSUkl0SEdsNWk5aFV4Sk5IWGhnZTZXaElnWTEwZ2s5b1pScFpD?=
 =?utf-8?B?dU5HNTVDYlRjcXU0VUxCL0Z6T3lkTlZXZXQ3S2IrYWlLcitVaXF6Sm5JQ0VP?=
 =?utf-8?B?aEtjNVZkSFlEbWIxNDhaL0JUMkV3TDhCMnMvVVJ5d1czMHpWaW9JdXllMW1R?=
 =?utf-8?B?Q0dBQ09IcGMwb3FvUU8wZ2JqcnBYenIvZTAwSk0zOEx3ZGVNS3ozeFZBQm1o?=
 =?utf-8?B?UmZqVWM0Q0JUYk1qZzJXakZ4L2YvVHRXSERLN3JVdmtQTmM2TDBSak56UFBV?=
 =?utf-8?B?RGRXVXNPZ0VaQzM0cjVMeHZCMU50Q3dyWFZWeDMrVFRWeFBEMnF6ekVkaVcz?=
 =?utf-8?B?czdZUExPSm1wcjlwL3Q3RVBGUWVja3hUOFlpcTFnczFyQlp1NDZvZCt1aVhG?=
 =?utf-8?B?Z1Z4WGM3dGRIYTJubUhaL1RDNVh4SDYvV21tbVdWMGF0MzZNdWFSNGExU2V2?=
 =?utf-8?B?RGRoN0FiU2JuM09LTGpUUEdoam0zZzFiZ0FxVHRkNWVVQjBPQkxsbXlpYVgx?=
 =?utf-8?B?UWhYdVIwTEtDOGd2ekR0Z3VscjhNTWs4Z0tzc2lNQ0JscVpFalpqdU1wOTZH?=
 =?utf-8?B?RTFIbnV5V2hWN0EvRVZlN1V2ekxFemtXYVJMTlZEQlhIcjNEaWJmbTJ5c1hu?=
 =?utf-8?B?WkZGMDIzRUFJZWdIVVpvUHIrenRlV0pkaW1EV2JWcW9oU1FLTkxsQVpabmcy?=
 =?utf-8?B?aVBCSFNPMXZXMnBqU2t1WW1vWU15WmVNR21YZXV3RVdFdmVxV3lBaXBCekRo?=
 =?utf-8?B?VzRpVGNTKy9EbDAwRUI3dzZKTWtNS3F5a0RGdUYybVhBZWZ5NUJ4YTVoU2pK?=
 =?utf-8?B?emhqOVZzWFlGNDdsdDZXN0dqZTFVTkRKN0JwYzFYcmZzemN4ZW9RYUppeGNW?=
 =?utf-8?B?MGFMWGNUYnIzYVhzeWYvZXpzUno3SWdsUHN0U1ZFV3hBRkhzdGt0WE1YMkFB?=
 =?utf-8?B?T0szWExPY1U4OGFIbEhDQS9yME1BK0liRWdWcVdpLzFjYVY5cjRTdHFDbUNq?=
 =?utf-8?B?cjNDOXNqSEhMbnMrT2NKK3FteHJzSVh4M00zMzBpWFcxcHRibEE3ekF4VW02?=
 =?utf-8?B?YnJ4U1JFUVdjTzRYTmp1RE9DTUlTSzZjVGhTRjJQNmlucnFlY2piQ2p6Snlm?=
 =?utf-8?B?aFBvY0xRRG9lV3E3eUJiNm50b215TGZ6MjJRa1hSM25BdStTV3h3N2tNU2o1?=
 =?utf-8?B?a3NEaHJEZVJaTG9oWDJveE03M0RpV2NpZGg4SEU1K3FMRitmVnNLMXdoNFBn?=
 =?utf-8?B?RmpkWmxneVhvZTZ4ZWovNzN2OVUyZlhKWDFoVk81bkQvdkFvekRjWVJFNk5W?=
 =?utf-8?B?ZGplVm40NXlDMW5ZU1kvTys5RERqNkhRdzNUUFBpZEVReUpzNFUxYkV3cnZ5?=
 =?utf-8?B?bUgwRk13N0Y1cnZhZlEzMmxhSEtPYkdadHl3b0p0UlpRVmhidm8rR0VnNy9J?=
 =?utf-8?B?cTdNcmY0ckhhcGtDNWxUSWFZYjI1bndGbXRTZVJwVEtqT0xyNTVMbk9FOGw4?=
 =?utf-8?B?ajFJeTFvYzZMZWp0Wm02L2FoeHN5bTIyNCthc3JoWXVPajBlSXdERm9SQlgw?=
 =?utf-8?B?UnpVdVl2aHpMVGFIKy90dU9nN1Y2YTB2eDBTTlFsNjF0aGRuYUYzbW52NWhG?=
 =?utf-8?B?aHBCNjl3T3JLQ2dlaTZiT1RPbGQxa0M3WEpZaW5zRjJheDMvZXFDR1V5cG9u?=
 =?utf-8?B?akxzS2dyNXl6WHViK3pML3hqTHBUSFJFWTZBRG4yVUs0NktPMExuQXluN0t2?=
 =?utf-8?B?WFNERWRqTjNVN2ErOTJrVHhBT1dlOGxZU1NSL1pRVXlBTWJ3Q09WZFdhZ001?=
 =?utf-8?B?TStWeWRqdjRvTitiM3BycmF3bXZWaVhtNFg5L28xZDlBb29CRTU5Tk92b1lk?=
 =?utf-8?B?SGwrWEp4TnBSem1TbWlZNWpmVW5YMEM0aFZzNVpTOWM2ZTBFbitET3RQZDVD?=
 =?utf-8?B?cFRtUStmSmlxMmtSL3NSNTZDV1RnYkR3WEp3czRiSWdIRDJCTHhxb2ZSRmgv?=
 =?utf-8?B?Nk1nQzIzbk4xcUhlU3lteXprNzN0elVsSUV1cjVNNDIzTlY5Q0YwcDJCOEFQ?=
 =?utf-8?B?OW53MW05dE5xeGFCVitHci9udFhVZXBaYnEyVzR0R0tmNEtTcmhpYkVDQzZ2?=
 =?utf-8?B?dlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VlVGSFFPN3kzYUVVMUx6RXBzYkowejE4cTJrcEh5aG8xOVBsT0puOXcvU1ov?=
 =?utf-8?B?UXRWSE0rb1RVdkFIL2hwOXFwdDIwcnBQMVJEQnIraDNXSWV1MXl4UzNLQk8v?=
 =?utf-8?B?RTlVdEpHR2dtakFTOXJYWnRYcDR2THNMVHBZUjZtamZ4bDUxNlgrVExBV2lQ?=
 =?utf-8?B?M1JtVDN5U2x5bVRSTlNENURqZG1XeFB6U2w3emljVzBITzBJais5Z3UrSU85?=
 =?utf-8?B?UGFVb3VOampwakFKbGpOamhZVS9UZU9lOHRjMXpiYXpNNmpUSStlT2RJa0Y0?=
 =?utf-8?B?OXA5TElsVXJGWkplbmdJd1owT3VLZGVsS3pRL2ljZVIzUUdqaXNsZm5OQmxO?=
 =?utf-8?B?S1EwSzRJckZySlBmZXJwaE03ZDI4dlorWGM5bys4dXpURGJXQ2haS1R2UldH?=
 =?utf-8?B?TW40M2tJTkhQcG5mREc5WW9uRDdlVXhGQi9xQ2RzT2w2WVdTSU1LVndZTElk?=
 =?utf-8?B?V2h4Tjk4QXM1dEREalUzTitiUmp0NE53NXp4K2FCZzZXRk5EQVRIdjYyN3hQ?=
 =?utf-8?B?UVl0c05oYjI0ZUlLY3VWWTdoVHh1NUhSSHpDZTYxQ05RcTh0SmlmaFg1U3Nk?=
 =?utf-8?B?U1JOTWMwWVFWQTJKL1M2b1VlbU9nb1VpZldVUHVkb0t6eGFYUXdDTE1tWjkx?=
 =?utf-8?B?Q0dXZldPZHArMlhsQTNlOHFWQlRNbnVrWElzUlZTZ1QrMXV0blRVNTRobm1B?=
 =?utf-8?B?VkNjRzRrazRDUXZtbDcrL1A2bVpTamJqQytpTE1YcU1HZ1RSbFRVSEhmaEhQ?=
 =?utf-8?B?Y0hzR1E0QnpwbzQrNDI3eXlNMXdYbFB3N1l3NFFxcHVMb3p4bTFHWUNhdkRZ?=
 =?utf-8?B?Rkg1TmFKZUhNR2lXWDdQc2JGOHM0NWlGaEdHMmJxQ1JTMWNIcXUrMGZ3cTZM?=
 =?utf-8?B?WXZkdmlyZjFYVzJlTXZ1akdJRHpkYXdxa1RvUWxCOUIvclRWSWJtVEkwc1Nh?=
 =?utf-8?B?RW9yU2trL0xaRTE0SzM2MFlTQ1RaYjAwQ1ZaWjYwcXp5Yk82Vk9EcnM2M0E2?=
 =?utf-8?B?T1gzZG5CenlEZEd4NFdvR04wQW13MXpJQi9BL0ZlVUlIYnM4NFllYS9VeVo1?=
 =?utf-8?B?ZFdLRHlZR2pRRGNWaUZKN2RlV25td0hGTFM4OVZQZFN5YjN3UEp6S0YyZXIz?=
 =?utf-8?B?QllSRTd1cHhtSWhXMzk2bTE5QmVnU3dsWDRtNGdUcDhsaUlxdUw1aEVZM29u?=
 =?utf-8?B?b0hZTVNiWlpiaUdnbEJWT052T2R4NU1MVzhyRkR3OUxSOWpOL1NCZlArZlhG?=
 =?utf-8?Q?rwwBnFFYmxyWxpP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64c53c63-3757-4785-4049-08dbb2b331a3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2023 10:38:10.6926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JhR7Bvr8NWTVgIZ5b+79sKvxH5u4WF+1oYu9EE4YiHfkr/NEd2jSB9re1qKMTXtdZLffHu3iBLo0vR04zG9RbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4506
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-11_06,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309110096
X-Proofpoint-GUID: jwzg6e0QOenqtRvUqhIl2RUZQdnhkXi3
X-Proofpoint-ORIG-GUID: jwzg6e0QOenqtRvUqhIl2RUZQdnhkXi3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/09/2023 07:48, Damien Le Moal wrote:
>>>   #define ATA_BASE_SHT(drv_name)                    \
>> I do understand the rationale here, as the relationship between ata port and
>> scsi devices are blurred. Question is: blurred by what?
>> Is it the libata/SAS duality where SCSI devices will have a different
>> ancestry for libata and libsas?
>> If so, why don't we need the 'link' mechanism for SAS?
>> Or is it something else?
> On scsi, ancestry from Scsi_Host is clear: host->target->device->disk.
> For ATA, it is also clear: port->link->device
> 
> The relationship is that ata port has its own Scsi_Host, but no "family"
> relationship here. They are just "friends", so scsi disk and ata_port have no
> direct ancestry. Adding the link creates that.
> 
> libsas does not need the link because it does its own PM management of the
> ports, not relying on PM to order things.
> 

For hisi_sas v3, RPM is supported and a link was required to be added in 
that driver between the sdev and those host controller device - see 
16fd4a7c59. And that is for a similar reason here. I see that we already 
have an ancestry for libata between ata_dev -> ata_link -> ata_port -> 
ata_host dev, so it seems reasonable to add ata_dev  <-> sdev dependency 
here.

I think that this should really be added for all libsas drivers which 
support RPM - pm8001 is missing, IIRC.

Thanks,
John
