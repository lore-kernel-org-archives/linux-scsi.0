Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A5EC432BE
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 02:15:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1573C60EBA
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 02:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbhGXBel (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jul 2021 21:34:41 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:21152 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233628AbhGXBej (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jul 2021 21:34:39 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16O2BSEM022491
        for <linux-scsi@vger.kernel.org>; Sat, 24 Jul 2021 02:15:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=vFaPDp2e0dVFHusAKWaJsXr6Rf+RQMBRfLYNXFXhkWA=;
 b=jaOXRvqCfGqSpCXwMzkOcS4VXto2L3mP/L4DpL88arHet5Gn4fgNO9J7Htz/SI7RX1lP
 q2UehqK3Vqn50WWyL3IznNKRWrqEgRwu+mEYA9BkOg9dWqQiVbvdtWvB6ua7Yd+d7xoH
 AZ0Z8L5aFHyMWJIMTCCCBYH/P3d0TZub5xjKcFRAo0zfmj7DVs/7tVcMa+1bTtMmUlSn
 oMKaOhoNqnNOe3ZaKiNvFSNh+SbIqOV0WniNHthkP/tg25EXhFfVZLkdq8lKu4INYeZn
 ad2Y7MunrJH10trtc6cdxTulAzjDnvAWTsdV9Gee/6aAnjpQizmEZhxd4TMf7RKwymaZ DQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=vFaPDp2e0dVFHusAKWaJsXr6Rf+RQMBRfLYNXFXhkWA=;
 b=qZejIINQbQ+tRV7jUwk5qShdahM6DCSUTYyT/XJ7+t/IWxOT5hhHQMmFvalkb39p/ojD
 l2xOwzN8x6cUXYnf//Re1RWklxXq6n2ZuksDAzrLSNIBAeEqtbB6lnTznTeGhHkCHp+P
 YOrR/4y1Gs1grodx47CDD7M31xKnDcFUqX4Z96YkZDTIjTTGuUXHYQPu1sxKrsM1IrGn
 Q0c56Xcs4TIE7HW5g5zxhBShqkQPoMgsew1TYqyBRuqyzcmd1QbDD7u5w+pPe4cvLY+Z
 AmRYPpJYgeGdi4rfxaoAOMFDfSAxhxHd/sneGxvCnpyofaNCykYMKCxrMlbl1x959AlA 9Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a09f1g0h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Sat, 24 Jul 2021 02:15:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16O25R3q188062
        for <linux-scsi@vger.kernel.org>; Sat, 24 Jul 2021 02:15:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3030.oracle.com with ESMTP id 3a08wb21gv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Sat, 24 Jul 2021 02:15:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NucwLsmY9koyt2FxkE/9C/d+EF9Mdjm2ss6tiv+HK52Hy7b/ojsxMqRCHyQ0VHaRG4D3unaFvbXWgc9OLQk5qY0Gimq0wGGwCxO3WSzhT6lYijwHlLoAXEFihVU2lqnzOEmWrXNxVxJI9XsPi0cTgIU6ZIpt5vL0f9Bc0ZRPcUB2L+9QKtnAxPDXirtaAJTyy0amYBiPlb5NwjBsKkKvRdwzMDC0NupB1lP2+5E1PDr3HCEuD1JoDCDs3TKa89xHEYD/peZ0fvSx5jMDmEvKqiX+TGxurxBhTMxAa+T6opYTmi/wBWgz2fMiK4psfY3lmyJfAPGGBEdOkA+Kx7Pksw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFaPDp2e0dVFHusAKWaJsXr6Rf+RQMBRfLYNXFXhkWA=;
 b=n/+kq/2Hi0KN5huU1zo1EaHBL8BUpqIwGtRCbv76IUu1fTBLQ1TU/kwWEqPFUewdfNgnqAqnpb+3DBQh8imKGUJv8VBgTJlhLzooVqS5U2ianeRxDYQagClgEvU+JXeyguIJiH34y9krxyT1SBIir1rBuHuErSHPb/cJrPDksmHBb2t6srQIGOyoR5C94jlknu1ZkcAk/i7yFuaq6rtBEZ4eOeamU7CcHQXQ96MQ/OMY5UlkF+bHVQsu/Ne1G8QZXbu0tvNttFf0BSN198y1VFqazDXTN9sJ3barp7lQT8WKee+si+mPY5L3wQwMgFXrILrmtUZIxVUKey5G1V3ngA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFaPDp2e0dVFHusAKWaJsXr6Rf+RQMBRfLYNXFXhkWA=;
 b=zRI8q9/9iBqi9ULsMrErJStRdT2kc608qwzy+d1Rf96S/AltxSclAOXyoc5RvgkJAUv8CmjvspiuiKzKDwHqZALKEeDT9rF54FI9PrblsRyZ+l6DWtXw4feNW/UGgi26012UwdEhtoA5C3fJoqXTU7iQmSycLuloimRGruumAjk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4647.namprd10.prod.outlook.com (2603:10b6:510:43::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Sat, 24 Jul
 2021 02:15:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4352.029; Sat, 24 Jul 2021
 02:15:10 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/15] Subject: Protection information and block size cleanup
Date:   Fri, 23 Jul 2021 22:13:54 -0400
Message-Id: <162692235524.25137.2199773371069718146.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210609033929.3815-1-martin.petersen@oracle.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0023.namprd05.prod.outlook.com
 (2603:10b6:803:40::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0023.namprd05.prod.outlook.com (2603:10b6:803:40::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Sat, 24 Jul 2021 02:15:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53da4a46-349a-402c-39e7-08d94e48dd06
X-MS-TrafficTypeDiagnostic: PH0PR10MB4647:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4647307975BDE6F3C90EE7C18EE69@PH0PR10MB4647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HR5vZ2/QzH019jS+GisVhzCqnQE3Ejp5XlhWXd+nElSJ5hEJLNKOnvZP/KQ9gI9kC8qN4rr5PlbNUTzpVpkAa5s/aePLwgz2tK+i4iw+teuoeFmjlIUQ8Ffjp9sGl8uE7HOjuXn9Q4eSANLJkom6v7JStEMluRE5hC0XcIwKWj5G5uzmcBUKM7GeDEdzMfgA52XTWjxBsPROtWyTvTlqEr3UGTXpPCJJiagCdACKOw6fXkSmGwByW+scriQq5DfgzCuc80kaPZP4vmf7SlV63/UN6qMetbR2xne2Dg4lY3VY1VL/6t2Z4uNXFWLHwWktuilwRr3qtl3SOBzvQCW08Dwd7zLLJhaw1qI6Fi8f5YQ2yu5TzVhTaeqQ5Gis5DeqiiV15tXV+n/pp1virIMwfiBPCQ8WYG7EeLa+4Fz2efVqKzSGroOiLVNR/9xmA4bXjsvWlLtdaoZic/wA8AefgL7j7prABMLY5K006RXFydAa5U5wuAoJAvqIeMkhkkLYuWT8fpGxHfD1MpBDCjnWeF47dcdYZtZ2btHt+wS13leXhqB8Vug/FA82K/6vhUcedEdqWNV6a+/lOJn13kgtpXXbX2o5BAa7tuxmWudtV0QK83vNIiSMHVB4xKoVhXx9A3stQALXIqIXomKS0yzhr6zRnoVK4K7MmntZQm10KnZLj76hbu1HFc5JUBLJ3baetNxrZ+Uznn9es2VIfjGRGSeLwYP/trojIzGSUBT992xFYH2bB+D/qptqQSQTrnlZEdfPy7/PkLMnR5ntDOCUhZ5nWJZEm7QW05i1fU7iHhAwUX60se9QoT1bruizMWUs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(136003)(376002)(366004)(2906002)(52116002)(7696005)(83380400001)(37006003)(5660300002)(6200100001)(316002)(6862004)(6486002)(38100700002)(478600001)(6666004)(38350700002)(86362001)(956004)(66946007)(966005)(66556008)(8676002)(186003)(103116003)(2616005)(66476007)(8936002)(36756003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VW8rY0I0RGxwK09wVHhoeTZiNVhEZDREYzIwYS81TFZ1cTNyTnpzcm9ZQlRG?=
 =?utf-8?B?V2V2RkhmcWZIeVBIaCtJdWRKQkpoQ1FOdnY2aVpOQUE4UnpFd21MbWxvS2Y1?=
 =?utf-8?B?RUNWa0lRRHVLTTdYWlpzYjF2RGhRZzZPWXlxeVhiVHZWSUVmK1NEK1B0Y2t2?=
 =?utf-8?B?VnRLSFJhWHNlc0RieEd4VDJsSWtKZXArOFFPQjhVVjhZMTJpVXpHV3JjVEE0?=
 =?utf-8?B?RnBkUWs0Y0sxaTM1c2V5WjZOSHUzWGNMQVlBM1V0N3psbi90dVZ5aEYxT29S?=
 =?utf-8?B?K05vemU4REZIUG5UQVRaL2hENkI1SVhqYzJOWWRDcFhDT3Yxb0Z3WkUxbEdr?=
 =?utf-8?B?K0RmZDZkYmh2bXRSSWhtUEpWRy9VaENIYmJZUXNVbHNIM3pEVEFhVXRUdUhD?=
 =?utf-8?B?cTYvNTFxdjlEK1RNbEJFRmVvaEpJQ3luNUl5S0JqRnZPaWIyUHcrZFQyM2ZI?=
 =?utf-8?B?TG5RMkI0c3dSWldjaUZHMDB5Q0JwbnFFa0k0SDl3VmlMOVczWDFKQWNVRTFG?=
 =?utf-8?B?QkVMTUZnSElWbC9kNEc1YjFtR2RhMmhQNmhwL09xVUNWNFlNTFdrZmNTUHZZ?=
 =?utf-8?B?bFhoUTFFaElOS2g3T0tobDE1ZUx5WXhKUFl4RTZuRE5UWlZTenVBV1lIYmJV?=
 =?utf-8?B?K1VHcVFsNXdKcEM5WDFkWGlqbi9Fd1IrYnZNd0hSTEM0cXREYi9WbHUyNWZn?=
 =?utf-8?B?SFpGK1dyL2lTSXZEQys2SFF0TlJremk5NE9FS2J1cCt2Kzh0b05TaTdXZzBY?=
 =?utf-8?B?M29WRlFIYUNvSkpmRFpaTWhqWVdwZlNMRFR2amVyWmUzTDZQNTFaZ2QyWVNW?=
 =?utf-8?B?VkNqbXR6NWdLTzFpYXU2aVdUY0pTNVYxL0dTandCWm1KOW4wS3ZxV2IyZ2JB?=
 =?utf-8?B?N2hDRDFmT09FWUJBcFJ0K2RtUHFzWlhmL1pQVFp1a1FibHBKY0lrTTdSa2FB?=
 =?utf-8?B?MkxLMWN5ZDVXYjZxbTgrMjhTWTMvWXdZdWxrQkdaQWJqU2ViSnc3MFhjckR4?=
 =?utf-8?B?OEt3QjQwNDZJR3hTRE52THpsaUxEbk4xY0x0R2o1WXpzaVI1eHRVY0pDSzQz?=
 =?utf-8?B?OVM5Z2hkSWY2TjFmanFSUlBSeTNvYzdJNmVmNXljZTA1MUQ2SzE4ajN6ZUxQ?=
 =?utf-8?B?SzFEaE94RG05Z1g5ait3M3ZWczVoR25CTXczQjF0cDU3cHhOeG82TndqTzRh?=
 =?utf-8?B?bnd6Z1RtMVZESnFFTHZQYVZiZXh6T3VaOXhZNFd4VGZJVGRGMTVmQXFya3lC?=
 =?utf-8?B?Rm5ZK09zalBRVnFpR1BFdXdqc2lPWUNmVXlJOXdkWHFLVGYxWTdJMGpCbXJi?=
 =?utf-8?B?dXYxR2pYajRQcDBubkljMjNSSWpHOXAvemJXRlZpVzZmK21MWFRrMTNPWUdV?=
 =?utf-8?B?QVhrMzhFTC9CSWd1MVRNWFZ4UWdKNjZFK21tYnkvczdQekp4NG1oOHJyR0U4?=
 =?utf-8?B?YkJ0SzRPL2xxaVN1Z2txeGtHdE1KbmhtZlVYTCtoTEpURG03M3UyRlVhVmhV?=
 =?utf-8?B?ZlNHNEEzM3pVcUxtQnV3TmJrdTRYbGdSaFZ5ZGpaVnRTSlZpWGhXaXRqWU5x?=
 =?utf-8?B?aW5ORTQvei9zM090cU9TekVEK1doQ1dROEc1dVI0M2hwMWo1eVczMmRIYUFC?=
 =?utf-8?B?TS9xOGl2KytKSkxWQ2NJN29hcjBzK280UVRMdUhFeXpkMk91c3dQN0VKbEpl?=
 =?utf-8?B?T1dZSVVFcXJ5d2tpeHkxRVllN0c1amdROVlJMFZFTEVJLzVPMVRBU24zWC84?=
 =?utf-8?Q?Isx3pFjBLRD5oooo1mjGHrgSgQ1bP5+6W9ZiXc1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53da4a46-349a-402c-39e7-08d94e48dd06
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2021 02:15:10.4939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2pzcUwJgLeOUdQmgVQqowJEmoaD1SbB+nTQCjyOJBVjZh14TFO8dphjrOtXjfDWpKT7jhf9wCWBarsiDDOlCL02v/bwCjd09JWWOH5PSVrY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4647
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10054 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=786
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107240013
X-Proofpoint-GUID: y_JO_Tl5loVXLDw8vZ3hgHbdRYq3C_MH
X-Proofpoint-ORIG-GUID: y_JO_Tl5loVXLDw8vZ3hgHbdRYq3C_MH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 8 Jun 2021 23:39:14 -0400, Martin K. Petersen wrote:

> This series cleans up how low-level device drivers go about handling
> protection information. The SCSI midlayer provides a set of flags and
> helpers but not all drivers currently use them. This series updates
> the drivers to use the proper calls to query things like the
> protection interval, reference tag seed value, etc.
> 
> In addition scsi_debug is enhanced to validate and store protection
> information the same way as a regular PI-capable disk drive or
> SSD. With these changes scsi_debug is now able to pass the same PI
> qualification tests as physical hardware.
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[01/15] scsi: core: Add scsi_prot_ref_tag() helper
        https://git.kernel.org/mkp/scsi/c/7ba46799d346
[03/15] scsi: qla2xxx: Use the proper SCSI midlayer interfaces for PI
        https://git.kernel.org/mkp/scsi/c/e2e9cd68fb3c
[06/15] scsi: zfcp: Use the proper SCSI midlayer interfaces for PI
        https://git.kernel.org/mkp/scsi/c/73e61d5c22bf
[08/15] scsi: scsi_debug: Remove dump_sector()
        https://git.kernel.org/mkp/scsi/c/c78be80d20cd
[09/15] scsi: scsi_debug: Improve RDPROTECT/WRPROTECT handling
        https://git.kernel.org/mkp/scsi/c/f7be677227a5
[10/15] scsi: core: Introduce scsi_get_sector()
        https://git.kernel.org/mkp/scsi/c/f0f214fe8cd3
[11/15] scsi: iser: Use scsi_get_sector() instead of scsi_get_lba()
        https://git.kernel.org/mkp/scsi/c/87662a472a9d
[12/15] scsi: core: Make scsi_get_lba() return the LBA
        https://git.kernel.org/mkp/scsi/c/d2c945f01d23
[15/15] scsi: ufs: core: Use scsi_get_lba() to get LBA
        https://git.kernel.org/mkp/scsi/c/54815088859f

-- 
Martin K. Petersen	Oracle Linux Engineering
