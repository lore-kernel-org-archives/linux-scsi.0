Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC4FBC6379F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Feb 2023 21:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbjBVVld (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Feb 2023 16:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbjBVVlb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2023 16:41:31 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D1732CC6;
        Wed, 22 Feb 2023 13:41:30 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31MGTPUK014783;
        Wed, 22 Feb 2023 21:41:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=L5vzlVJPswzbLGeWWbNqU6rJgUBHZKZDPnQNphwFzLM=;
 b=DBw5/qTxj2Vyq9vmT1XpOF+fPzAvenJKLAFBppKxkQxqseLTRguStLnzFKuGK1dQKNGR
 6yZ6JnWfk6cjWBF5Vle3IsIT6keTYQ+NwM0R4TA3GcrEsqPYSsyIafjfzaxgGEeWtV+u
 ksDLQtzj4No/EHeB0d0nYjt31WxdAFAkhnM5oAx6H7/Wy1ez9uwdoe2KVAR+EnKT5N+a
 KpK7mjcwO5eNdqCU5nnmvlZsRPvQKpyhIoP2OoAufyDtKnRHY800Dh3oA09eCmJ+S8uP
 ylANJd1RLHHLgB6BA6tNQ5ZYi79GGnIfYBuAcdFPx0yvv2wNKRcBH9movWWdhYY36l6n tg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntn3ds4wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 21:41:24 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31MKVZEX012997;
        Wed, 22 Feb 2023 21:41:23 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2044.outbound.protection.outlook.com [104.47.51.44])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn4eg3mu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 21:41:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SOEE9eHcGiRVjnJmF615XBp366BKLI7nYyprC39Ta3QCDBoRxkjyQullzFGG0syjg+zGvCtJ5vEd+hoygAoVy+U4yU17Yd2RBnnxzf2CfP/Zl8rUbXElFazkScUeJX0F0v4W7x6WSxR5jq1PvbHht8e+0VK76g61x4499bWgz7URInbJXKB8Vv+ycMcoLPbPmsNuUE2AOaQNrjJiMMm2z6EmwHpKSWmVa5ML3eOcSu08SwCMU/QS5Bt7ZVycMlqQlXm3J52al0ICMh7xIJjTUwHzdH5ez40fCmddAbyXrhgypUA3cxkwlxbGqS+h4VcKchyN8hWpy5LO9dJIqCvkNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L5vzlVJPswzbLGeWWbNqU6rJgUBHZKZDPnQNphwFzLM=;
 b=T621pYKgZBfNk8AZRm1YZ8RRzO2Fm0XFGHZa3R9NsYaYmjANDv362DVphksYgpIS9ULxiK0DY+/G3Tk95pdzddQ0vVhPETwJjO01LmQVMARWEe6ThcVq2jb/zczChpSiZddycbvxFkufiLBUj0aoJiTDmfmN1Z2EUjPjWfYdZTcTc+SfPJDaVKpwrG5PodCo++IHpNiMi55Tatt9dB1Gs66ek+sVZnaSOZGwE3biACHOyvKXzWkQSLlh0KT8EhZhgWuz9x3mXxXDUyr4ESveZpjx596ULEuq5++iKbyn2kUUAK+Jc6X90cpM7CgA+Ff3SXgCLv6mKaAWWb/aLO0/GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L5vzlVJPswzbLGeWWbNqU6rJgUBHZKZDPnQNphwFzLM=;
 b=TDKL/U6hZvh/BcS+3/FDX/7udJCxZSnWNUXMoBW+1h3hpAQHxjSkhzfQ9B1ehO61hTRVtSNl1BuLkDr1qKHG94F3PkxbUuVjjQRL/nlECG/R1A3mHW4Gl6jPx/JlGvYoTQxfHLPSKcNFMw3EvEgVW6LcobjH2efJxUtxQTJDnxI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5079.namprd10.prod.outlook.com (2603:10b6:408:128::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.17; Wed, 22 Feb
 2023 21:41:22 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 21:41:22 +0000
Message-ID: <a72558e0-04b9-d641-0703-63d2d348ff6b@oracle.com>
Date:   Wed, 22 Feb 2023 15:41:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v4 4/4] scsi: target: core: Add RTPI attribute for target
 port
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
        linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>
References: <20230221160622.7283-1-d.bogdanov@yadro.com>
 <20230221160622.7283-5-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230221160622.7283-5-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0145.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5079:EE_
X-MS-Office365-Filtering-Correlation-Id: 40089a21-0ca6-4972-1b2e-08db151d89f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HpXXgI4Ubzwdm2/zYkBbe1/Zj8Rre1dlFK4QaAdKYX8esg5DRRySDqOwCKY4QxAiKPadJ+6CAGe7vgsvUdFLjtrvIdCe99fOgyZwQs20TYxouyVUJkvwQcFU9CX9Apmm3se8QdHPFh9bPj4eAdPcWJV91V4Ll6Q7u6+am7F8AVZWOhLmx4czEfNF6W2q7SxBc45G5eSTM3gKcsL1D9jMh4QJvNIq7wTQAlFumA9jvPbVCneaj3oju7UNDMUtwxW9E/d4JuPFEnOjb5Oyt0JYS3/a5SjGOPMIusNaz408PrnDq++PCCWdz3mASXFtse8YyAPjQwzDBxRvUS7w0YRM8iWTg2DamTeLRfpI7dmEWezGu0BaQwAnR7FtpYi52kwwtl7UamA+VQYojfLJE4qfNYQZXq2TUKPWFDfcdO/h3/BPKg+o1Hbl5aHzAXFva8VZeGYI7Kf+YFG4BP4UkZqgrmkDt7Ov324mxmgDSr166QrBI2azNu3L4CCrB0X17CXLMa+g4kw6Ki4v5vD16G/5UkIwR8fv5h3HS77QcePjvNbV+cOxIzGVeO75RObwekumYUWA08mycoy6Az8o2Y2bV7NYo1TjXo20ZBxeU1ZolM/eISm/nuR36+wn8XhTgBCXWqRPe6tMQJmelr/hWFyap+QCBrjGgrqBdXAYIpS6d6CVOVunSJJacQs+MLLwU4M/vvylB3FQVgCyEeB3MDktNWZhsrZvhmWIYulQ19je9h8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(366004)(376002)(136003)(39860400002)(451199018)(31696002)(36756003)(86362001)(54906003)(110136005)(83380400001)(478600001)(316002)(66476007)(8676002)(4326008)(66946007)(66556008)(31686004)(6486002)(2616005)(38100700002)(6512007)(2906002)(53546011)(4744005)(8936002)(5660300002)(6506007)(41300700001)(26005)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eVg0TktqMU9LM3l4RFY4ejg5eDBNUU5Ic0N5bFpDZkRjQW9KZEhqUEdRYnJq?=
 =?utf-8?B?eWxQaVFtMmNvMVJ3bXh6V3JmbjRqRGZaT3N3ZXFORjBqY2VxRHF3cjhxU09D?=
 =?utf-8?B?Wi9DNUpFeDQ3UUIwRFB3THJ0eDVua1BRaG01Z1pKYjdNVWdlcDIzZ2VqRTQ2?=
 =?utf-8?B?SjkzWE9ES21uTURiZkVEQWR3RHVaWHk0TlBPVE1PTVFoRkZTaldMN0VoWlV1?=
 =?utf-8?B?V3ljaFJEVW13MlY5c251MTNPUHdycjQ5amdxL0tFdDJWMlV5S28zTGxEbGg1?=
 =?utf-8?B?ZEIvREUwYll3ekU3dEtWMnFONy9sRjRZQkxDMHNaKy9LVkYyeVBhajd0d0xK?=
 =?utf-8?B?QndDM0E4cVE3cFZRR2d3TXcyMElyMUZrbW5DbzV1bkd6VVhsakFjWElJQkNi?=
 =?utf-8?B?bzJWM1diWGg4QWNGUjJJTlJuN0x0ZWVESmxvNk80QkhiNDV1dm5xdXJVK3lW?=
 =?utf-8?B?bzc5WjRCd3hpcGFub0wwS1QzSnFJMWhRK2piWHNiWCs5MlZ0eDlFdlM2b213?=
 =?utf-8?B?UHNORlBSbWRiOVc5eGVPKzNPOGwycC9FYk5Ea1RrVHV3UGVhbFIyejVqdEEx?=
 =?utf-8?B?bDlUNndVTEtIZnNyOWNPdU1jakxKNVBEazM1UGg5ZnU4Sm5id1phU3lNb1Rp?=
 =?utf-8?B?c3JVekNxbjUzSE55RzdITGhNcVlFWFQ2dEZIQ1FtMzQvTFN4d1RiVE5jcWd1?=
 =?utf-8?B?YklFeGs1UXk2M0ZFNEIxekd4ZnNYbDhzYVNub3ZUR3BPNk16UUdMeFZIQm1j?=
 =?utf-8?B?MWZJZ1NEU296K0dkUUlyQkpYbVIwRkMvUTl6Mk1wWnJTV1dMbmpQVGNhNnpI?=
 =?utf-8?B?TFkyd0Z6NzM1djJyZ1c2UVFIZFNPemRsd1lHYTVxUFM1anl1Y0pwR20wODZG?=
 =?utf-8?B?dEd2N3NBeW1TNUJoMkwwR1M3NmJiNGw0MmkzQVQ0M2VLUGtmVnpodnN5Qmgv?=
 =?utf-8?B?M1ZieWkvRWEvclhsVm1jaU85TGpCMnNkU1VwWmZoVVU1WmtFSEJCVVlaV2Zm?=
 =?utf-8?B?M0R2Tksxa0pMNVJEZzFvUWp3WCs1bWpUUkx5amFOdGpldFpBRW5TOXFqeXdT?=
 =?utf-8?B?OEo2UEF0bUZORFQxTmlPQi9VazA1emJuY0ZWMGhxdFhDbzFEOWFGZThPVUsv?=
 =?utf-8?B?TnZ4V0tWa1YySnNyODJqckFwQWVOZFQ4SUdwRVRBOGhOdHYreUNWTUJlVDZX?=
 =?utf-8?B?YnBXenJoUCswRU1IaFcxODE5MmU0QXhNMllRKy9jell5bHNnMVZFQWd3cXVk?=
 =?utf-8?B?WFRZN0lxeFlEYThDZkV1bThIK1V2dTdNQksvTzkyaDZtN014NnhnODNTalMr?=
 =?utf-8?B?N3EyTHJ6WXNDS0VXYnBLYVNTNmMrcEoyR1g5RGdHQ3h4aVpyb010ZHhrTUJi?=
 =?utf-8?B?MmpOczl3c2ROci8yRnFTTnZIM2NUYXR0OXFJS3llTHNMcytpSHVacVFDc1JC?=
 =?utf-8?B?dlY1SzZLNEE5eEZtMFZVZTQwbGNYZVFEcUQ2bGYwQk9XKy9na2RLNXJ2RjI5?=
 =?utf-8?B?VjRQU1V2OVJPZmpFOUxRSEYya2xuTjZLK3kwV1c5Ly81Z1o0NFk0aTFXdVBh?=
 =?utf-8?B?aWZJaEZndzZMeEdld1Q2ZllZKzIzQkRsMjNoRVZUQUtDV0pUSVZmTzBxSllZ?=
 =?utf-8?B?anNOMHIybHZZNU40V0wvYVVjZVZ3N0sraEJPVVMrVDNGdG5xM2J2K2FUNFhx?=
 =?utf-8?B?aVVYSkpwRDlMRHozL2lxR210NXVzdU9IQXFMbFZwSG0rYU9mbllTVFFPcE15?=
 =?utf-8?B?V0xMODk2eW9uaTRZWEN5eEdFT3dWS0ZlMXl4dnNGUVZ0Mk1YMTBEUHFpMDYy?=
 =?utf-8?B?YVlnYVFLaHRMZ0dCNlV3VFU3T2FZQi8wczZhUDRRd1MrT3E5UmRNNEhGOW9S?=
 =?utf-8?B?M2lMamF0N3JHaDdMU1ZwbFZ6Q09tNXVBRGlweHpYbFU1ZVVRNEdPZmFYamVs?=
 =?utf-8?B?bjVPSGc4dk45VjZydkhXbDhKNGt4RURoNVhHSVhKSEd6N2NPbUtFMlhYeFFH?=
 =?utf-8?B?U2tGKzAzTEViMERVVkk5cU9vMVFSSnFOc2pmU1FpNjlnNW9ZTFNnL3dKcGtR?=
 =?utf-8?B?andzdkE0OU02clpZd3IzMDBYTFBsVkhDbE5FdXBka3JqSFBGZ0tzeWoyYlFV?=
 =?utf-8?B?QlBKZ1Z3TkYwR2pTNlptZzE4MVlzVlRreGtVRis4OHRJKzM3OGZPOWQ1dG81?=
 =?utf-8?B?aHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: bmmlrBKNAu7o8jfRa0cz+izO5vFRSv2aYq9RHCplz9AsYs60mQMxdxRtmNgUgSwl0MCoVSKxLwbli+gwi6EmKLKooO/IX5EHaupInKdKcmwnQ/fCWinT7moxRJsdjY5OcOv+NQNsJtxzOsjY+a91ytx/bgTXncEJkibZY4ObImKs1Bi9adkvIATGILQXFdcNhRRWQjL/I00DdNP+PqQCuggz0BnLVrDtmeVUZZPgTURQTWd51UHOz3/TAtpowVYUfUseLI6zRS5EYJyZvMabYqNYqwa3ExbT0sFnO0mk9/3lTcLgg2D1Yn2wpnK88oDaJfBP2Ceb6CZl9scuYNJhcqEmeYVPJVWcUeFsZgy6qXrob0ojH+S2cW/pLGnlITSiO2Zsmr7ZjGobw/GeckoRZ42i6Vyfg5Y8qlpqvkO/iTZD7FL/Q+VxE9Ymzfq+/QpHvZcUedTH1YUQU79aFjmimAYZP7ikBnMJW1npD7VMxaBfASSriE+ywZ9fQ3JGXKIoYyDe3R/PMAmI1WeUvZALZ3E0tGAdDCzP1p2AD4fIUPJ83/Z5I0dSjHhzccvyZZ++Uix0DVd/Vh2yoB38K08NWWT1A0ObklXlodGENqEcCCTGM0OpELLcFpt+RTRyrSfIAqMREd+vX9ant4rK7fmg8AnLxmHHqAf1Iibuo2Z1QSlVsiS/fK5IaEenYE+qo/Qzi95xNtzSqYS+pKkVAsbQg3d39LKpLi++PsVikk56uudk14d4HrCl6xLtw4Zb6wXhVKt1D39ugnnYfvdg9Io0THjXMk67DiQd/XQnSzKQLQWG2g8650iavklBj6mQRfQRVWzdB6NIuvVbcVwK5ggigA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40089a21-0ca6-4972-1b2e-08db151d89f5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 21:41:21.9271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bN2roG4lqV2ZWN2EFFczR/tn1RW/ey/BgMYPIP4dd40N1bMXGvtEWBxRpxVTezep3P38re2+R0LLDVAAgmRV6V8BAdrEAr59NwHoG8hlEpI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5079
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_10,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302220187
X-Proofpoint-GUID: iIYzH1MnG07qAvVQZEVKOimNut8BZRtl
X-Proofpoint-ORIG-GUID: iIYzH1MnG07qAvVQZEVKOimNut8BZRtl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/21/23 10:06 AM, Dmitry Bogdanov wrote:
> +static ssize_t target_fabric_tpg_base_rtpi_show(struct config_item *item, char *page)
> +{
> +	struct se_portal_group *se_tpg = attrib_to_tpg(item);

..

> +
> +static ssize_t target_fabric_tpg_base_rtpi_store(struct config_item *item,
> +				   const char *page, size_t count)
> +{
> +	struct se_portal_group *se_tpg = attrib_to_tpg(item);


This interface is nicer. It doesn't work for me though. I think
it's because attrib_to_tpg is returning a bogus pointer. The rtpi
file is not in the attrib group so I think you have to use to_tpg().
Or, put the rtpi file in the attrib group if that's preferred (it
doesn't matter to me).
