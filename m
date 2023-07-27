Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 280D3C001DC
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 09:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbjG0J1B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 05:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbjG0J0c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 05:26:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5F055B7
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 02:16:20 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36R0uZSq016129;
        Thu, 27 Jul 2023 08:05:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=auOVOiw2PDn+3Y3uxFIrUraUlwrRV29PfZx/LUQgylQ=;
 b=chWSq5h/ldHiOUfh+4Yxxny3ifZ4ZpFTebgh9tiXheNapi9rmmVl3ZP2mmIHxVfWzE5M
 ZQYLerX9ZzJtaUXEo2rhtutoITU+LeHGLBK36V3YZPCeyFSMcqQBHHDg6C2uxIq0TZC+
 EJkW1SBfR10H9dUmEVVfavAY6fiEAbfdnX9pB1+epVh7qSpopKSnxg0Pn3vZ1vSnkj0Z
 0QEoxpwd4kkmF8frCvhBxeuxmOdf9FZxFIX0vMxfFH/MVeS+l2HwgDAJscLZZzS/7fYd
 k4BWRW+YNZWfXVMKct8JZy3JoJlifE0k+UBtc6xyDnEg62uYCWf44kiwvZJjFKgnvzDt HA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s070b153s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 08:05:05 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36R79qgE025412;
        Thu, 27 Jul 2023 08:05:04 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j7t5tm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 08:05:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/JVp3GNhQv0tEQDOGrM7T2FchvL5CCCsSwP7U1m1+1UW5Y31NLRyioHs+8yohNtjEIstmBa30Ghnn3G+eICY9ctHZQ1z8O1xacgNbFhZUkqcOG+yJygcM05jLnrAX7lfXLGtBXftGfNdgHD1OsD35PRk6e//+fxHe5zCCw2Tfw2aVvuSy6X9a13RVePCTbUzuuQfuhkKlAljV5OEO2oFcqZpay6llo3sknF5/dpyT0lfovF/d8ijaPpQvn3TLUlT/oCYvXauaCfZMrdYQftGWHhTZAyeJoZg/OLPW/0sCS83FEoLg1czWJc8fV27P9Qez3az2zIzyg8H9dZP3adtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=auOVOiw2PDn+3Y3uxFIrUraUlwrRV29PfZx/LUQgylQ=;
 b=jFNIxWCfCLAAH4FShm+7HsHGbxrrV0WiDQmKfvSYuhu4hyDJjcTmy+RFVp0hyKSyef/C/48ZUaVDRA7nunLEanWIHgojxw4PNigQBjkTeJwk24g9kk7jUvGUmfweMHBCLTyjEJnyghGn5uapz3YVlKESrHWBA1hzsiGFdlictPZJZmCRZ/GEAzhIItMH4tf6DxnICyjZw07nJZ2lH0gK4DUstnfem2MkAONjYnQGWPJX8V769ko5DrJPTwVH1tJam7NSehZvZGY93/AceycubXVLijyMEjOADp+plrY8ppcbUYbvflPQ/C9uYVyKPrZNv6eGhz9lBXgy7t71y9m0kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auOVOiw2PDn+3Y3uxFIrUraUlwrRV29PfZx/LUQgylQ=;
 b=OBM4GGdR2CSLfjZMtZEjnvhrRsV95X17R0mWdG2U/3S/a/k9h3TgwllUPMwr7i38rirQZDEWxdAazO49hdKr3L5jVTTYofzWksHos+bfqLOIAaF6i6fyMqHBDRPjb/055shTRNk3uc3rI5FUy+lh/hPoTXtv7U6pbUxChbkOi18=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB4839.namprd10.prod.outlook.com (2603:10b6:408:126::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Thu, 27 Jul
 2023 08:05:02 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Thu, 27 Jul 2023
 08:05:02 +0000
Message-ID: <e80b83cd-1f92-1e39-e4dd-885352c02ea3@oracle.com>
Date:   Thu, 27 Jul 2023 09:04:57 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 31/33] scsi: sd: Fix sshdr use in cache_type_store
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-32-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-32-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0054.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB4839:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d5e4b63-d9d2-4d19-7a20-08db8e782dc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7JAo7LcMV9Woyom07GYtG8qjOPrr/nVA/7JcwtY+KtoVpkAkK2pSoWjHY7KlFZ/Q5VPLyouj9C0O9+FFdhmdwVRyJclQcDPhPplI6YXDNshhQewEPRjn+F464+N/k5kgmr4TyKD2WO1628q1/k3pnnmWWXjAUgbSnW0WBETVv8RNkwi7ujPujObZ/mPQSOtRCZxmebsM/mwbxE9yPqagHFR2hvMsdhvhFCOcpnCpwTRutzNLSwQJpUhHgV5zCLCVGGYHoveCmq3CQKUrlxN5+MveKc5GcpOKwybNup9pD8dCjI0dyzQdYAnyoDK0c7VqTE4hqWYrgccnSzVylErn7WNiL6a4RHnaSfXfoSkxWcxvsQ/xenKr2W6mnYk0WKyACK7AMiE62L3JeqNDZFa11kAIPE6PIYi36MYeCrW/zAiwTd8QsEBf8UUOa3e8zHxBCaqOrsN39Ad35sX1nqk/H7DMkQAtFCEDkHF6/Wu2Fr+7iP3Z5jSML3dcTxh0s0VSE1668WZWL0jXZMqhtyC30IArzmw8EgS7bEqCFllBqi2t7+uA5ncYvgM6bL+FSdCUcJt069eVWlOAAJkkmQZtwyF0t3SN7fQ9wMOSaDm+WeWArktRM/iW3FWQznIIA0RXlqgBC7dzwE6q4290YUy63w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199021)(66476007)(6512007)(66946007)(41300700001)(66556008)(6666004)(6486002)(316002)(36916002)(38100700002)(2906002)(36756003)(478600001)(4744005)(2616005)(83380400001)(186003)(5660300002)(31686004)(8676002)(31696002)(8936002)(53546011)(6506007)(26005)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmFDRElwSm9oVTQrTjg3RTMrZGpNamFOazB5VGVvNW9iYm85TFVFK1E4djlw?=
 =?utf-8?B?aWtHdU9lditTSVJaMDBIUm5tczd0cHdLaHhRSis1LzhhbytjMGdwbkRITytN?=
 =?utf-8?B?REIvc2U5OGZJVmYzZXJndUdWbHlxUS9Ec0J3ZkVBeFBUVzhURmgxRFhBU1Ru?=
 =?utf-8?B?U2RzbmhDWXluNFAwT2d3MFVJeVZyRzBhSEZnaHJvOVBVUnJsT1ZuTlJDWnJN?=
 =?utf-8?B?VVJjS01uUmhJd3lyc1c0d0d6SGdBNmo1Y2hsU2taK0NRR24xZkFlY0IvbjlJ?=
 =?utf-8?B?ME13U1J0TE5CaDdFK3ZFQkIwREptVHhnU1JYM2I4L05oUElQdzd1djJ4Vkk5?=
 =?utf-8?B?RGZ1bkJ4S3FJNHk2emh6TlI4cE0vMTU5VDA3TnhJUW5VcHErWWNib1hESTlS?=
 =?utf-8?B?OEljN3dQditRdUN0VjBFQzRtcmQxUXdyNFJBL3JncFFyMmVFcGsrZmREV2hu?=
 =?utf-8?B?anV6cS9VVzk3c1NRSm1sY0ZxbnNmeFNJNm5mZTRoQXlGckZHOUVQYXprTDUy?=
 =?utf-8?B?aEc5dzVRN2V0TThjcEFlK1dlQTE0V0FxaFBYRFRmSlFTNTIxNGFsRTFNVVZ0?=
 =?utf-8?B?di9zbWZhcVlzd2hkR1h2bXZ1R0hEbmhId3YvZGQxaVNkMnlqeXVPY0dlL3V4?=
 =?utf-8?B?cFlDdENzWUZ0UjlqQWk2K2Z1d25RWTNCQVNFVkJGa3dyWmt0L0JiYlFrOHVn?=
 =?utf-8?B?SnZoUldxUGhQZ3BEZk15ZzFZeG9NVFVxS0g0NXdRdHZKZFBqRlZmY0JxWWV4?=
 =?utf-8?B?SDVrRVh5RG16ek9OcWZFTGhBWUp2MmtQYTJ1QWM5Tyt0Wi8rMmVBN3l1NEpr?=
 =?utf-8?B?N2ZqK1BCTkkxSFl3MjZGUDZOOW5nNHhPZDZENVpZVjUyZGc4d2ZhL0tkeVRi?=
 =?utf-8?B?aHVjVk5YcGdqUmVDaTBpTloxQmwrVHZaMXJRdHFDNzdmS3hRS3RKRSsrV3Ra?=
 =?utf-8?B?TTVPcEtlZk41aTFDNUM4SkNzYTBlS211YUtOb2VaaXJqUVIxcVBtVEVpOGVa?=
 =?utf-8?B?amxzNCtTTi9GK2VISXNna0VhajNXTnRMeitTbkIyU3NvMkduU1lyaVp3dFV4?=
 =?utf-8?B?ZDZ0cU1meGtTdCtYZDg5RzdKcDJoaThvYUxVREtSbElieGduWUZObDFCd1Ar?=
 =?utf-8?B?eUsvV2VLTUVKbDBKM2RSeGFleFd3N3ZrUVFGVERBZTEvc0ozQWI5eHNUQ0l3?=
 =?utf-8?B?VGlWcGdGY1AyY0ZDSzhyT1BWWmNEMjhvRmhkQXplTEp1NmQxMVpUYlpKRFcr?=
 =?utf-8?B?VWQ4VWxjOWRxYXFyajc2TXNYL2d5bkl1U0hDYkR0dTR2MUxrNXNMc0daMXBM?=
 =?utf-8?B?ZkVnSUluTUxtR0ZjUWtSeExDRGZVcEw3OHJaa0oyR2s0bGRiakVEN2tnbXlo?=
 =?utf-8?B?L0x3alJrRGx4UGtMWEtyd3g2enlacUlGRXRIeG5HTnVpc29ESWx0T2R5bTJk?=
 =?utf-8?B?Rno4NXVqZkFETThCVFQzRTZkQ2FtNDRHZCswdFlmSmNCL3M0SlhaMlBsLzdW?=
 =?utf-8?B?RVpkeUozcTdJZStFMnlTblZ6NWdHNUsySUxZZUw4Z1o4Z2hGNG81OXp1ZEpZ?=
 =?utf-8?B?RnVCd2tiTzVQMHhWYmNDeGNHVmVOcThMY3Q4YXdkM0hxRm5SeDBrdFNFVWRZ?=
 =?utf-8?B?b1U4RFJLd0NzQTlWZ05sMHZHSGgrUjJxdG9zNkMyZnI3MjI0VFVKU29zbGUz?=
 =?utf-8?B?ZTA5WU02UUgzanUvRGhJQk9mYTVGTUdMcGR5MzNzcThRYWF0SGh6a25aZ0lp?=
 =?utf-8?B?TDBkbFBjYjRQck5VOS94Q1VGUWdmYWQ5RHZwL3pEbU5kRW1wdnBNSC9NemVv?=
 =?utf-8?B?aHVxRHBCM2RUZ3Y3UGFyMFRDamthYVIrQm1XQjYxUGdvVC84LzFjRTYxWnVL?=
 =?utf-8?B?MEY2WFV1SUM2L3k3NjhJdkJDazhTRkxLRTB6RWRmektFN3JPSnJaNkRWV0dH?=
 =?utf-8?B?WGJRdHFZcUJhM253bDQ2U2VZeGFjemxvRml0cVZtVXZiZVJnRFNibGQ3NVEv?=
 =?utf-8?B?NVArUUxnYVRtaEVvdkk0ZGRlb1hIRlhqKzQrcnRFbytscHVjaWFJQmMwVDFT?=
 =?utf-8?B?a1BnelNRcmdkTHpEYzA0ZVFEVVRuOExvNUJrT3JqeDNsVDVaMVdSU09RcUd3?=
 =?utf-8?Q?Jo3ovboKX2qvaaiAy/SHkx7+8?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ehY3jLRAyzRQq+zjVr7S0zymXA+7VnSglWoS6MtX1llmLUxXXtBy9OagEOKooiqJG5kbMrrfyNeUA26OT6+DMIHtbBCVF8tLXaKeTmcD7GKf1jO9+LHlSUmh+hzFeUdFUXgICH33Mf1zMWdeyAB2HgY9GK4UrXNyLIW7wBv7bfBDbTW6WJdUMeK1Q2Q0aL3RDBkgry/AiICrAd+WH7dhn5ALUX0wLb6BIAzZtyMM+++qRA6mtaWDEQld1h0eLoSG8EyOiKmgBen3cS/Suaxq3jvR/s1YAek+4PU5OLgWVejxDQguhtal+mqP+EZSpokw3R353pMep9yuVGfYZ08s7rc6b0guohpgXe90hwO6mVQE0vAN1HV19NVfylDsNX4oCzmfVIB6r3+kvZ4ycSFcLGWYLo+WhRXpP8ulXg4XjLSV2T7ZLlyWXvGiuUGz9m7wILcrKWIof2l5l83NigRXU+srHdaFMiWLSnphbhPSuU6CQruZfNIrC/FvGtvkrWx/8v8DJBmxpoOAiU0vudSy4D2U6bwM8oc/IHF2/6Cj0rf1n1GXAfLV0DfQPaas3LRf6bjxd6MShQByZsSjDLBLE7PhO/h66C/C0WgNjVR08wkR4Ii6caN4jW3najUrmlABNyUiQ6YQZOQfOARv6/Z1kmOyZgTZ66S/phIUVOkwoCDhl291/dyPmo5znH3ddqNvd02o8SWVp5ZtObIZa/2AcpQxb1eRYKmP9glnRD+yvaI9dLIDK1ziP+gn26y7LZ1E4EZUL6OHaYTM3HrI4fdMuED4DbKrGxXdS4AlEMlmBKDa9Adi8UCenMCpzG4WbGvjZilx6eaOi0sfEj1SYeuFVDq8GK1ohULxgDFjbaahxV8E9eMBc16DTVYZ2R1BYAKO
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d5e4b63-d9d2-4d19-7a20-08db8e782dc6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 08:05:02.0671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pjVchQJxAVlgGHYJaeI7G9+xjSoUTp7PNlfv21vlJ7Rg1zSdZBSoRrcC1D2+HVRCdnNENPG64mplbOPCvA0qaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-26_08,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307270070
X-Proofpoint-GUID: tMkpwDq30kitUgNDTMQu3MEeNYLDbb4t
X-Proofpoint-ORIG-GUID: tMkpwDq30kitUgNDTMQu3MEeNYLDbb4t
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2023 22:34, Mike Christie wrote:
> If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
> shouldn't access the sshdr. If it returns 0, then the cmd executed
> successfully, so there is no need to check the sshdr. This has us access
> the sshdr when get a return value > 0.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig<hch@lst.de>
> ---

Reviewed-by: John Garry <john.g.garry@oracle.com>
