Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5238EC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3864760F46
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237204AbhHQDSg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 23:18:36 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47044 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236715AbhHQDS3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 23:18:29 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17H3CXPf025816;
        Tue, 17 Aug 2021 03:17:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=7tqFjInjFmvqb8d/PnDDSnujVtJNvcXn+LITCdO0gpM=;
 b=0zXKnR8ZL8cP/cZOyhcrC5qzbtjuNs21YoKv57YDKU7LHyzkL3Q9roD9fiLVeamLIdoU
 IqHm200oJI34uBzrBSkSHNO4VUKOzEFRPeOs3DZkTmY+8eEks3y501Fp4bhfYnrwMNP+
 dT325Mqy2GVXBWBu0Fr2yeDcDuNkDyeRmwBKB6eW3NrHIP8q9ht3PH/JJBQMk6QnRFyc
 OGgnO2oeqDjKecvGWloopHCrHHBqosZGl94Ce1nEc2L2wQ3wynawAPKaCbXIZWfDi8XR
 4us8dfJy5BsHopo9dVHGVDVrPGu90xWSIcW6x5NkKUAvj8eGaaCs3A3wK+xMDKZ04hfQ hQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=7tqFjInjFmvqb8d/PnDDSnujVtJNvcXn+LITCdO0gpM=;
 b=tnw8HbWV73MBXMQiYffDG5lbvlC4i+KfKLvIsbMMm8EvAMgdowrb0doPaLSPfn7plQYt
 yrrqGFHTDQb4IRfBGM2BdIoazBZokZrg462FC6oe9fJrayXacmq+tAPxsagNNKPsKKj7
 ISc3oMkFKBZ8xyq8IcPq8OMRXdeF3HpWB8VBCL+RiIAdk2FgiorJKPx9n0xTGOfE8qlh
 tEkYKE00UY5GW3JWM1IpjksT1ZInzIXnmKmTNOy0cUiYc+RjwW8H1G+Bv+TDMwq6lUKc
 512o22BSWSkPXoIXRQeMZjyDyiK0BwjrfwnpCSdO6f14YpqFyOA7qQkqyER+SMzogv+y fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afgmban68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17H3AlOM195395;
        Tue, 17 Aug 2021 03:17:51 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by aserp3020.oracle.com with ESMTP id 3ae5n6rgde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nluRgZpgFcIC0FGmzSyIsVAz1RheJLsCpt+d5kRSYVcsimcE+fcsMoCh63ynLib9vRYLSsMbwXRaQdpNJaFs5ZpnqyBu3C4Gtvve/q/mfpP1SIZtB0KzJ26MHohhQxUik9l7zVB/pNmeYWj909C+EQSTJX2HMnjjb85iZ+rIQRoOJUujrHTT8AD5P49Zechy/fuGFykA/CfUCKf62pSj+hRHDicKcXdV+HobqGy5Cm9oExeLoxs8cM+VE+rEo7DCQbC4yLHACcVwpfoLdmgsMKcEhkE0cCTpjFsARnKRK2kFfMH/1gKlOXwJZgrnwxQrs2OHD8PkmAK1yh2fcXsovw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tqFjInjFmvqb8d/PnDDSnujVtJNvcXn+LITCdO0gpM=;
 b=kl6ubWpPDUYVTMwUVGkBesqr4OhyMJkRN2YGZRQrwQUvi9WyLmuvr9XJs8ni29BRrqiRs/WRZgByH6zrgUePF9hPBHr+ARzDX73gwJKp1RHPMC+yY0pYF1D+U/551pXef0O4jGLfyQ3dq9HDwtvfa5soELVz1gglinFdNtksuWHbVW1auC79TOlW1f0pJtRoL59eSlUMtojuVaMev+BKG0Z2Hs05qicH7dHisqQlhKxI6nPzXehwhE6FEhhC8SPgZ3nKI97pozJgBkYUX1yXkYdOgV3sWl+Dfpw2eob7WTJFwabIZr6au/iRv8DIn+xfXlFNrRlwlSVkateoZXlieQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tqFjInjFmvqb8d/PnDDSnujVtJNvcXn+LITCdO0gpM=;
 b=lpKJsbCE+52Tu6fPQVSPlour3bbVY/gnOvVyk5ZilBlI8m34mvX9cFqPSKgDNHXMKOoC1t91Y5AO9fJw5bTSKGPtq1cyuEzJGbyN0mebPx2M1Yvpp1hfi2K3a4ea9BLO+54DmrgcssF/sRsxeL+apt5e1GFPucWwANm6rCCB9q4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4566.namprd10.prod.outlook.com (2603:10b6:510:36::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Tue, 17 Aug
 2021 03:17:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 03:17:50 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>,
        Colin King <colin.king@canonical.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: efct: Remove redundant initialization of variable ret
Date:   Mon, 16 Aug 2021 23:17:35 -0400
Message-Id: <162916990043.4875.16953936130048433588.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210804132451.113086-1-colin.king@canonical.com>
References: <20210804132451.113086-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0178.namprd04.prod.outlook.com
 (2603:10b6:806:125::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0178.namprd04.prod.outlook.com (2603:10b6:806:125::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Tue, 17 Aug 2021 03:17:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89ec6422-0e89-4da2-a0e3-08d9612d97d2
X-MS-TrafficTypeDiagnostic: PH0PR10MB4566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4566E08A9F8F0798D103A5EC8EFE9@PH0PR10MB4566.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cFvJ6/j7tVT75+0sURsqIVZd4P4SAzMoVDujoGwInuWqRxAUUPdVRQCQZ5y2ApMf9D+tQOv6ZDqeT8HKR9u7wcwfTME2dCkhT3vTYLYG63U0+JK0XgPuEuIJrQw/jbFKO18YJZeHUkerNuQEUTSQ8c6KXJQqSmxfxDb4oRJnsOcmYAuh5D3gZd8ij7VhVfYTVOhvIiNT1ZFmj6EhQI7htxbM0p3Zab/FhUaMuRFSA06S6z8bL8ZI47nTqT+WtmEAtfIsclAFIehaXyjV4xUvvnANGHUQFMZc4wOE1E8JRbGDaHOJE1tZI9B2qfmZtghVX2K2Lepw2XvHygXa7rVmZJadwiFPDsVUh5yGnyVcikKAAsw+guHFlkh3X1vnThLm0xIYrXYt0RYcEdSTMN5eqZRmV/DSb06mTtXv5xoiLEBSJUnvnFwBl2vAxOuH5oR5a2N3kgjQOGPGTT6DFvY+mXBxxNooE+ywfk3hUwjzR7DErc28Zwk78Lb2jx/lIzOTEp7GdBd2yQKBcAdy42dL05rb/G/9aHiwhN/qlVywZM/CI0bhAKo6oNSOiUN/L0GUjhOwSLUitL916d20D3r6LV9wQnEuBnAqvfof23s6UAlIbmniWqO337dQvMDI4NZlJnGhVJjK1OOqL9mfu8zOosCVrQHU05mDTVTzclaypkLAJRXrRZwntHEc+pL8BUOxlXmnnA1JIxziBLbVaFWSJgA1q61s1rBfK19zJayGluq7ArlJ/HCo8Cz9MqbC3PUhh19XFPjcbqmp3mTunLy19OxInlGFhKirz2deOKSCYoI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(366004)(396003)(376002)(6486002)(52116002)(7696005)(4326008)(66556008)(66476007)(66946007)(6666004)(5660300002)(2906002)(83380400001)(86362001)(186003)(38350700002)(8676002)(4744005)(26005)(36756003)(2616005)(316002)(956004)(38100700002)(110136005)(103116003)(966005)(8936002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlkzWjBzTklTaXBaVW9MTUJqenVSek1lUGNrK0ZYUkFOUi9ua3ErSm1FeWVN?=
 =?utf-8?B?bVFTY2s4Y3Zxc1R4bEkzejlDaVVZWmwvU1ZSbWRMdkMwM1loS0l6SllnNldn?=
 =?utf-8?B?YVY0OFoyY2NuUm5aSjFmVkVZQ2dFM3Y3MVpGRzBDcXFVRUQ3VTM1V1JaQUNZ?=
 =?utf-8?B?S0tYaXpmbUNkSGdsa3VaVFA1R1dPRDFpTjFvbnBaazNDMXZpbWl6a2lKOW5w?=
 =?utf-8?B?aGxGcHJab0srOEptMTdLWU9zRlNpTE9xNGFaTDNCZE1ScGoyZk1hNVZtWFNq?=
 =?utf-8?B?cTlmNUkzSER6V3VWL2ZNdlFwTnl4NVhxb0RueGNhZklOcnVFYTFldkdpY1ZO?=
 =?utf-8?B?R0dWMyswSGJrNWFmKzdPVlhJOU9nYnpHMHNWQWlCU25WNU1hQ2FKMUx4UVoz?=
 =?utf-8?B?amdSdU80aGlsV2tVR1hpT09oSUhZRzg2SHNlSGtRNGJ6OVdUUnJKNnJEa1RV?=
 =?utf-8?B?ME5NQUljdjdUaVF0OWxzNnlLUWZ3bGx3QmpCSWZyMW84MW1yTmtXM3g3b3RL?=
 =?utf-8?B?bWErZEhTOGpKTDZzNzBCSUN3VTdLbnJaRE1Idjl1RVBxTWVvdDJIQnQ2OFNQ?=
 =?utf-8?B?RHlJMjBBTEdlSUZtWGJkYmZXdUUwQ0kxb1U2TXRQaTEvRHp6b0R1WEIzbWlJ?=
 =?utf-8?B?NGgxbkx2Rk1WcFdSOUoxTUdTekxSUnd6aGRWUzFTeDdpSDZwNmJGczRjMGU2?=
 =?utf-8?B?R29aaU5VemVxbmRvTEUrcVRpQSs2TXNaRWxVMVZUNHRkWHJPRk0wVnZQODM1?=
 =?utf-8?B?aHE1WTljVTMwblZMYVdvNlFRMkdJUGFrd3N2MnhMRkFnNmdkMy8yb3R6QnZp?=
 =?utf-8?B?cmIwUFhVVDcyYStkS04yWGZlV1NuK0FJcnBYQzA2SVZnY3E4eXJMZnhFSk1T?=
 =?utf-8?B?TmFzV2JLVzNxMXFWWVJMTzB3M2VXOVNHcTh3QnpONVJacUpmdVNydWo3L1F5?=
 =?utf-8?B?NmVlZXVBTjcrcWpDcVdVYjBvVVg1bGdQanJ0czA1SThhN3ZFb2pTUDR3OTZ1?=
 =?utf-8?B?VnJkdTdLMVp2bElucmcxM2JicVpuWEJrbUo2QW4zdUZQUHNuVFY5amFCakt3?=
 =?utf-8?B?WkdwSHFUVkM3Qys0aDJIWDhQZmM0bGhsZWhzZXlxL3luN3dGeVZ1c2dzZmYv?=
 =?utf-8?B?YUxpUnRISVFLSXZ0UTBLRVg5RFZrclFLYkR5NEc0eEhjUCtjVUVVdjMxSHlj?=
 =?utf-8?B?bmEyak5zMFRmdVdPQ3BWdVUvcStHNVNDVUY5U1FQd1BYdllFTjc5UTZLSk0x?=
 =?utf-8?B?L0d2WE5WS2E2Rk1hV1VRTWpqeno5bDlIbHlHRnFGQVBFUkN5K1ZqeDlEREQ4?=
 =?utf-8?B?T1ZTUlU0bVFnZ1lPT1Z5RHpxYlQ0MWN5bUd4WWhLaVp1VVNJMTRuNnkySjJZ?=
 =?utf-8?B?VHR5SzMxeXdpMHpyd1lRdUwxSm1BR1dCdVdzVUw3NEswUjFXWWlhQnVOcUJy?=
 =?utf-8?B?SVVSQWdPd09CcEtWZU1xRlZuRS9vdDM4eUp4dW1WRkNObGZnZTJIeExYdTFX?=
 =?utf-8?B?NWRGakVCcTNWK2JubFE3YU9sWFEzTVJzdm41UDNPbHMzWEcyT3pGMC9Cb0Ir?=
 =?utf-8?B?RldpZnR0ZHo0SVVBcXdYR0NiYzg0L20yT1p5bFZKT0xGbzROWnRqRjlFVmti?=
 =?utf-8?B?cEQ0NGZxbkVmMnM1bU9tcndEWEk0aGFnVXFYb1FML21OWjVoYzZxRWpLTkhW?=
 =?utf-8?B?bXBhTUlQUUx5N3BTZDNQN3Q2djNxRW9lREYwMlArTFljQXVRMk1HRUNmcURk?=
 =?utf-8?Q?Qhf3I03/bxTy7fzusxuOSx9ay5i3cmV9O9m1j/J?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89ec6422-0e89-4da2-a0e3-08d9612d97d2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 03:17:50.0143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sE73dIWH70ZpyYraUj05h/80YosbNnvgCYzqh0RVICQ7lypwKiGA97L+OB/VSUQjKZCdv2rMcU9fP2nh+HQWNTC182nVTLR+ogfc4Iadtn8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4566
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170019
X-Proofpoint-ORIG-GUID: N8kmNo_FD8NRukwQfl_Xas-fpvEZz0p2
X-Proofpoint-GUID: N8kmNo_FD8NRukwQfl_Xas-fpvEZz0p2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 4 Aug 2021 14:24:51 +0100, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable ret is being initialized with a value that is never
> read, it is being updated later on. The assignment is redundant and
> can be removed.
> 
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: elx: efct: Remove redundant initialization of variable ret
      https://git.kernel.org/mkp/scsi/c/e71dd41ea002

-- 
Martin K. Petersen	Oracle Linux Engineering
