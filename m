Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4553FC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00865610FC
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236574AbhDPCwD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:52:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38820 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235291AbhDPCwD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:52:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2masY046783;
        Fri, 16 Apr 2021 02:51:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=gSr7b9Z242fEh6Otqkx+xlGIim6nbCeegyEX38hDiR8=;
 b=V8cKqRhA7akKcVpVb9Ver5kC4KScAAxFp2pST/H5W9+Ve8zcqvPUXrq/E8wz70j+OctT
 EH4jVp9HuKFajQqxgO3WpxfqS0WVTzLNBemz2wO4fTd5bjicybToCbBIq5C44pYkWf5y
 /LcGd3ZxCvMjQxib56hgoH8p5ugrbYiDXfSVOZILTo6Q+uGrVLOYqZ8jl4vFlJBvRrMD
 R80sYLd2kqaz97ZU7jku+lnRE5XEg6FSfj/sdvagiLrwSxyExUFU8sP2jnRwa/7yLiTn
 /Mg1tKaWer9j5Pg+qOJSPWwsjgzUQpoHb63ucz5Lu+9/jo2L1BgPrgwAuhNnEDuwWkg8 Rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37u3ymqpkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2no6B173409;
        Fri, 16 Apr 2021 02:51:38 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by aserp3020.oracle.com with ESMTP id 37unx3twj9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CCMua8rn/l9JPguEgkw7/RuOsb9eWvhsxTm3tAMQRGlVWlPrnls6sDW74Izy1s6V38DQ5X6vUtLhxkLNLjb4Y9UebGR2Pyit5jmcXhFBZOaE0VIfDaOsqT57wVH5E6GrWlXk19ZZL//Y+OUv0jEfFM5uADQoD1I8x7PHSvNyGsh4CW4EO+BrxJbbdn9Wd0QfbPpuIBqXeBOzHujw5cslQzVuhCCH7TaKdgzpRnRjVACe3SZ2HKJnyyffvsHzFHz+pCRTouc1esQTX3QAjhfx/fA0NT6r6l6eJzfcuiTXPo5Pde4+9bxqJsepiH+QLTV2D7RFirBGv2Ssi9BeJE5wsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gSr7b9Z242fEh6Otqkx+xlGIim6nbCeegyEX38hDiR8=;
 b=mcI87aHT4a8WkgCzDk51ieihVAa3Ziluy39f0rpplxsznUwiD1BnxzA7biBa5yiDIl//RsDRzzfZOVS7QgiK++yrv67lohJilRzjaHLKwDWY+2Bl3G37hJYTxTI+7WfOtuDffBab+rbarkfgt/2tkF4kxi6R+531al3urJPGw+gScoBsNkyFMIbBMYnTNJhtRk7/Jj/y/+JPRTWbrfd0MGjwlfhNN/i2g+s9uul7hDvwHYv4wOa+tL2X9X/K02DJfm23vTRNS4lWoQyonHN+t3U+7XhVQo5Mt0BFHRxumotl7zjDm1aHnHMP/YPdYq9ce0jT67aqnqRYQjePZwH5/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gSr7b9Z242fEh6Otqkx+xlGIim6nbCeegyEX38hDiR8=;
 b=B2Av+/GziQiTe5YARaAsJGMOZTbJJyYeuJXYnh8u3exIDQ0GCoWfOaD/imVUKudO4eec782fbHIEz/B9wAVQgIhxc4khdoOfxHMWuEJjoP6cVo3m+kXSvNZ1QzddeP9qnl9oWFVu3lDLYdUUA7K3vqUkbT8/xD99Tka7jG7nOP4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5466.namprd10.prod.outlook.com (2603:10b6:510:e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 02:51:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:51:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 00/16] lpfc: Update lpfc to revision 12.8.0.9
Date:   Thu, 15 Apr 2021 22:51:13 -0400
Message-Id: <161853823946.16006.4418077612662148411.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412013127.2387-1-jsmart2021@gmail.com>
References: <20210412013127.2387-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:6e::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0023.namprd11.prod.outlook.com (2603:10b6:806:6e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:51:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 541e57b7-d48f-4b0e-8636-08d900828c75
X-MS-TrafficTypeDiagnostic: PH0PR10MB5466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5466C55ED87C0FB4B4B1FB048E4C9@PH0PR10MB5466.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gop1AFrc4N5csKqzPGki7bmAQZ+GoFayM+7FDd0bU49Um1pKxT0Am2mASEGCUehHy4c7ebTcdCmObZodRQOoYJzWEHkZoBpXCpPafnBnN9tY3r3hPiK9uc6lU6lTcL3CxGwrl8tAOzuA4rZfk6X3bk7K8vjTiKYrHAP7aAMu/bZ3YNWsT4bQTFYNaId+i7EX9V4ge0afqoYQh/BMM4PmOCmrC/Cw8V1SrCSFbyHhcxriyJzETNvuin2DHYIJ6HuMJ6N7d+YGo3KTOS9yYalNv/I+VFnMoZCSnZimww0n4iwWTL28K6HJ9KpIdQpdWTCYQnOUdOhp39iE4JH3NvgUFocR2C3Tqf5meZTyI4ZTYIBW7u7WO9QQKbQu8KLCYfz2WZtREA/ZtjLvbCM/Ap8E1UsBpLftuc8vEh5c9O2zRWTtic2mSNtfP3NEb/t4HcaK+kbQ5X4MN5BxGWdedO+d/zLVAzIMENpvs1q8DB4Is66yvz2xF+SQJuQq1kOdXE9JTPXzC+WbuwNIymI7uzeyL0eaNfw9D3ML/ccpRu3pAvSSJoEyNTWmR67dMeMVjzdSzFmVLQghfKWYifjTanDEIAkE7HPmgE+Sk1QQfXZrkKY/LZsoPtq3Vj6obAoxgdpOy9AlsAc+4SLfR1xJPSny3Nb1V6Kq6CnvZjwoBH0ca4qBt4enhoCmeqLnCrt6h3SkA0To5TvEMz/nnmB8mKN1Vz4E1Z/FUJnQSTpJvPpaVQw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(346002)(136003)(7696005)(2906002)(36756003)(956004)(4326008)(6486002)(6666004)(5660300002)(2616005)(103116003)(52116002)(966005)(508600001)(107886003)(316002)(83380400001)(66476007)(186003)(16526019)(66946007)(66556008)(8936002)(38100700002)(8676002)(86362001)(15650500001)(26005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VHlIaElRY1lpR1M1azEwcUIvVjZyem14UjJpemcvdERDM1FFbVp2c3NjbGpX?=
 =?utf-8?B?NTFHdm81TkdvVkJVS3pNcTEyUm1adG9udXl2cEtGMDdoL2NKcmZNdkNqMG1z?=
 =?utf-8?B?R0pJcC9GZlczbmcwaENsR0JWQUZmSkI2dCt1RFMrYmZPWXNQR3h2eDllZXJM?=
 =?utf-8?B?TXRUVEN1ZlA1Y3NxR0RPUkdKOWJPSXlqYWdEbDZNZnJTU1ZFWElDaEtmeHE4?=
 =?utf-8?B?cUFhQjljVzlHQUswUmEvVEUzUjNRMnJ2b3FxaG92Ukd4SlhSNkFBd3h4akhH?=
 =?utf-8?B?NmREeU11UnBtSW1UbDNaYWJ1WDlDUDhISElaTlYvRTJqaEQyNkpxeXFPY29t?=
 =?utf-8?B?c2ZlYTlFM3VFeVFtMmZKU3VnUENBaGZOdkh0L3pUaU1HL2pNWUU3L3FTU21J?=
 =?utf-8?B?dTI5OVM0ZUhaNjVCQnVGZTk0Z0hwVm9nRmlZQWpZS0RTNFQ1Z1VScUM5R1JF?=
 =?utf-8?B?UjllQ3JGeFJGck5FSjZtSUVNOWd2cjRkZUQzSVNLeEFUU2dqQ2liS0N3cUZl?=
 =?utf-8?B?aWNwN2NnNU1ycVh5K1VkN3hhck5Vb3N0REU0RjB6aFlCWWtQaEg2VWF6YWxX?=
 =?utf-8?B?Z3NmK0dhd2ZNWU1kWW5kbDc3RWFuSmlmU2gwbXZINFNjMmFyQjVwcnlYSGp6?=
 =?utf-8?B?SU5ZMFk3NWRaRFUvcS84T0dIMzU4MlhRNkFIMWtFRFFpOFhLbFRGbG91THhG?=
 =?utf-8?B?YlR4SFhyODRZeUM1RDgzdnZYc3c4MUFDZHB3OVB6Mko3YVhNbjk5UEtWYXBP?=
 =?utf-8?B?YmlMMVpDWlpJWTNFd3JsQlpyVzZZMTYvMHpLRDU0ampQNW9kbUhqU2s5Q0wx?=
 =?utf-8?B?eU1jTWtVRmVLalFGQjdoSzVZZ1hqR1duWmp3dWNtcVUrbDVLaXF2cWY2MmNa?=
 =?utf-8?B?Um5Fa3dwNTF3ZElVSjVLMUN4M21PdmFnb2Q1TmE4QkNSMlhjRmtmRk0rMURE?=
 =?utf-8?B?bHk5azBpb1dQMkdvWlQ4cTZBQU5GbGs3dHY1YUZ6dU8zSzdLUXR2NXhDY3M1?=
 =?utf-8?B?L0Jac2NONTdMTWF5QXlHUEt6TWlBMzFGQWRvU0lvK0RhWHlrLzMyRDBUNjVa?=
 =?utf-8?B?aG91YjlrWnp5RUk5WDFyemxySW5hOWF2Y2ovYVVNZmczcFNUTHlQNjBYaDRo?=
 =?utf-8?B?SjFkaC9sdHFvbng1dXhYQ2cvYzVtY0tQbm80S0ZQSjFsNFJCNVNSNGVyRDlG?=
 =?utf-8?B?enlyb3RjSGpBSGVVQ0JxcjFnVTdoK2tPRCtROWVzVVRWL004VEFGU3g3UVhw?=
 =?utf-8?B?b1VLenlvdTJCT0h2SkYyaVFnMG16NEFpTURkQ2luMUl0cjhreVRwUU42VEc2?=
 =?utf-8?B?WE9FSFNzYnVLTnhtRHpiTGFKZHNnNmU0WUFtcHJyMUxycEFZMFVSWVhBMVBP?=
 =?utf-8?B?bHdwd2F4RGgrNzMzTGZZRXcxaGUvYXViU1NjOUhJWS9hSm5qemw0SGs0a1Fi?=
 =?utf-8?B?R1o1QXpralFsaUNYclU0OGwyYTA4Nm10VlVnQU1IdFJlZGxnMVRSRGo4dE9u?=
 =?utf-8?B?Q2UzbXF6YVhuZ3lqTTlwU2lkTENzSDgvOFd3TTZvUkxPSTU2eWJiaXpqWlNY?=
 =?utf-8?B?aDdZQVhtNkZub1F2d1NEc3Zuc2hzODVkd2FzYkdQODNiTVVOQjA5eEl5WjA2?=
 =?utf-8?B?TkV6ckNyK1BGS0toRW8vQ2VId1QzOVFDZ3V5TnJtaHN4cmlXUEQ2UTZPMGxG?=
 =?utf-8?B?RkpnR3VaQ1d3N3g5SFQ4STB5VXBlaFYvSktieS9wUFJ4SjQ2SDJWc09Pa1Rj?=
 =?utf-8?Q?2/6RnIsVpGB4TuqjmB+/mAR0k0wUJZg38vEOzRr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 541e57b7-d48f-4b0e-8636-08d900828c75
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:51:35.3678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qHt0NylDPa47ed6o8y8aHBt5ufYRv3KaaALo4yMXQNKFhumemU8d9ohUQzwB6jSmoferCodXJeysHNhjsqyk2K52dDywc9jItCifbujI7X4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5466
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160022
X-Proofpoint-GUID: zw_8xnlWmzTmfbsHMIDtaIIEhiSOS-9g
X-Proofpoint-ORIG-GUID: zw_8xnlWmzTmfbsHMIDtaIIEhiSOS-9g
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 11 Apr 2021 18:31:11 -0700, James Smart wrote:

> Update lpfc to revision 12.8.0.9
> 
> This patch set contains fixes and a cleanup patches.
> 
> The patches were cut against Martin's 5.13/scsi-queue tree
> 
> V2:
>  Reworked patch 3, Fix reference countiner errors in
>   lpfc_cmpl_els_rsp(), for kernel checkers warning on ls_rjt set but
>   not used.
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[01/16] lpfc: Fix rmmod crash due to bad ring pointers to abort_iotag
        https://git.kernel.org/mkp/scsi/c/078c68b87a71
[02/16] lpfc: Fix crash when a REG_RPI mailbox fails triggering a LOGO response
        https://git.kernel.org/mkp/scsi/c/fffd18ec6579
[03/16] lpfc: Fix reference counting errors in lpfc_cmpl_els_rsp()
        https://git.kernel.org/mkp/scsi/c/f866eb06c087
[04/16] lpfc: Fix NMI crash during rmmod due to circular hbalock dependency
        https://git.kernel.org/mkp/scsi/c/a789241e49b6
[05/16] lpfc: Fix lack of device removal on port swaps with PRLIs
        https://git.kernel.org/mkp/scsi/c/4e76d4a9a226
[06/16] lpfc: Fix error handling for mailboxes completed in MBX_POLL mode
        https://git.kernel.org/mkp/scsi/c/304ee43238fe
[07/16] lpfc: Fix use-after-free on unused nodes after port swap
        https://git.kernel.org/mkp/scsi/c/724f6b43a349
[08/16] lpfc: Fix silent memory allocation failure in lpfc_sli4_bsg_link_diag_test()
        https://git.kernel.org/mkp/scsi/c/a1a553e31a99
[09/16] lpfc: Fix missing FDMI registrations after Mgmt Svc login
        https://git.kernel.org/mkp/scsi/c/a314dec37c0e
[10/16] lpfc: Fix lpfc_hdw_queue attribute being ignored
        https://git.kernel.org/mkp/scsi/c/d3de0d11a219
[11/16] lpfc: Remove unsupported mbox PORT_CAPABILITIES logic
        https://git.kernel.org/mkp/scsi/c/b62232ba8cac
[12/16] lpfc: Fix various trivial errors in comments and log messages
        https://git.kernel.org/mkp/scsi/c/3bfab8a026b3
[13/16] lpfc: Standardize discovery object logging format
        https://git.kernel.org/mkp/scsi/c/f115612528b8
[14/16] lpfc: Eliminate use of LPFC_DRIVER_NAME in lpfc_attr.c
        https://git.kernel.org/mkp/scsi/c/5b1f5089b6e6
[15/16] lpfc: Update lpfc version to 12.8.0.9
        https://git.kernel.org/mkp/scsi/c/3ebd25b0a443
[16/16] lpfc: Copyright updates for 12.8.0.9 patches
        https://git.kernel.org/mkp/scsi/c/cf270817cafb

-- 
Martin K. Petersen	Oracle Linux Engineering
