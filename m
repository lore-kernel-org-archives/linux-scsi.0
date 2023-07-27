Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB85FC0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 08:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbjG0IIx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 04:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbjG0IHv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 04:07:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1393C28
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 01:04:09 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36R0s9Do016850;
        Thu, 27 Jul 2023 08:04:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Ikqvjucf0883/SyiT/hrdnZc1jRxkbJ22kKk7QSIM0A=;
 b=QrPYDLDo8ygXQafCTQsTUztC5+4hqZ9pjRiBjk6w2AGSlq5fxP1Mv/tQ3Heoc/mCmHGU
 95P4uzNUyai5Seu+hkvYKNPT3WC87CwBe0tGU9ZKC9SIi/A8op6Vh2hGmcIK8GVLoFhP
 e/yX+78JLXJfs+PUtQ9TGy4vrtvVkzpecXkBBglqFGts7m8rQAXmXiQZ/gyYwh1+fI7I
 Ffx6isOplJp8IqhlSr3usLjYcgpeu3TnM90p1AMDq+rQZfqXXHMotxfcG2rTcOByw4AN
 BObw4Cs042XE/qHVuT5DK2jJtOIaJv3gElN/OnSsPRPQxwnOs9FUY+LTIGI6Zx7cWeqD pg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s06qu1503-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 08:04:02 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36R734hb033413;
        Thu, 27 Jul 2023 08:04:01 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05jdm8je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 08:04:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L11NZ8Qrh6OKVCOfH3DW6wmbaZXqWLKYZpqOa1611ZZgrhx0CqYZ23sCkFw0OdVdtViRm/Efu3orHY2h9r6fxQ5fFQp70OvDx7TcP6WlEdA44C/SwMiE8Im6yHfuayPfeR+QQdkzBGnJd7fUh9TeuPNMn09bzj+ewIGCfGZD674ue4Fj9MMm9wDByWHF0fhxhpT0yMSbV6++kz67Fiwh3SLScZEwadOB1mONiCoHiMJYrMc2zSxxHsNTU7zSs1HPB3uJCnW3m0lBHH+Y75AlzUNVJ+DN4vtNLs3CDtlu8TDKlj0eyFRa9AJAfDWQ3gtPFXQisF5huJmJ0jEsJAYWcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ikqvjucf0883/SyiT/hrdnZc1jRxkbJ22kKk7QSIM0A=;
 b=UAiU0nmCYX6bmXooDi3gm2MpNMGlvJCJ/1A46cZFYkyNknrnTAbmB929GEoahFYTTNEiqQtSJSPrNDxORLvDEIEIAlHUwy+W+AqBDF7GoGnoQwkPUrIM6yZwtqXK0tul+Gjip1L35WHfUXjvgpaDnxPQ5x29EwLTv3fgvcjq3EYIJtO1pRlzosvv6xpwXMQsUTw/VsQPzWHpHN9u4lvwdOakJRVA3r6xo2f4dt3K7vJNmGqSdpXELydY96AEo4LMEzmmT4Fz2c5cQshXCwZGB/Pa3nU8FsEgmGkA+z/bvP/ypgNOs/jub7Z2nFJAkIC42r3RX893h2G7T4MMMQ5JaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ikqvjucf0883/SyiT/hrdnZc1jRxkbJ22kKk7QSIM0A=;
 b=YbTMBOZ6W6Fac9659Rpjz794Ry5A+Iv1OqOo68/9LPQlAiM4uk7yXat0HWADSeZ2JOZ66NI9fnbFvXhjzDT5x3Q/P1xegZ3e2uYRA+P/+tH7L95TJ8QHYs2qNQJmKS7TKDziC9fprh6Xe4xzyYixMu7Smz2odEhI8ibO4Gp/LoA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB4839.namprd10.prod.outlook.com (2603:10b6:408:126::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Thu, 27 Jul
 2023 08:03:59 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Thu, 27 Jul 2023
 08:03:59 +0000
Message-ID: <76b9174a-baf5-3d34-886e-f39e44ea4c29@oracle.com>
Date:   Thu, 27 Jul 2023 09:03:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 30/33] scsi: Fix sshdr use in scsi_cdl_enable
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-31-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-31-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0095.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB4839:EE_
X-MS-Office365-Filtering-Correlation-Id: 27e5606f-6004-4e80-11b1-08db8e780885
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ivx9CkTTaegvMSfQSkSuajIWefTn7SNwwoqlYEcXzf8ZELrc6gCjmvqD6Z4a1IZIoVBwBB+OQYSF8HICRasYH2iXRuFAZFm2A2yJzu9zSLKlOFHkU9pr44s2BX9DC4jT/V3ig0gXOhSUURANw7Jn48Z8E5Wpnm/NaeJpWgCyyF7EfO330sqBUYceieS5l2PQT3r0PtFxvs0xvAym7elfVjRgtTarZADhXI/kCO2J3TpJ4wz5lATh274/Lcd0K/z8GkvJgxJrfgY8dxVDe0RhT/qvx2IAi8euzd8umRD75YvFDjeo2EaTBqrUKwvG3SEQmwee65pNuRnIfP0xFLQDzgi7esD9JrZ7FVUdhxSe1YUS9p6MmGc1T4MOk2/NlYZg59RejI+C/hqfcmmMMY1weITjQKLphBIDEQSp3TSGLXxAIcGLIAcHJRUBgNR01wCc80dxGMEBkkm56c8JbO9e8MgC8yqGXYfDO5KmF+ggd1+XzWplgiLr4AT460Cu8KICFy6NEAeu64wKo2MbxWGVdA8NLMEJXQPgFwySkAZP8OQrsEZXeAGPkcMPJ1ubBtjxYMQlNgC1uEuTeuyUxkhM+P08A54chg57L7YWHAl60B/2e3MQy1dKKcbcV8DV0RGBGoFX5OhKAhIISF8roMg3Aw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199021)(66476007)(6512007)(66946007)(41300700001)(66556008)(6666004)(6486002)(316002)(36916002)(38100700002)(2906002)(36756003)(478600001)(4744005)(2616005)(83380400001)(186003)(5660300002)(31686004)(8676002)(31696002)(8936002)(53546011)(6506007)(26005)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGdZOUNJVnB6amxTWWMweEdnSHRLeE0xQkY0b2JCZ2tkNUZRamEzVFp0TlZr?=
 =?utf-8?B?NFVvYzdielBnOHFBN1AxWXcwYUVlSDRGRVNMekwyN1poZkxmdzlIS2ZaRTJv?=
 =?utf-8?B?TXdHZk16TUsvL0FUNVgraEJoZnAzMk9UNXJZbGdVSkdtZHczU2NQeGEwdFVi?=
 =?utf-8?B?ME93S29HZXlNNU5OR0pUaUVUSURocllvcjhLSG9MOXovSkpzRnlJWVB0K2hH?=
 =?utf-8?B?MjkwRnRWZVdMazRVbUFsZmpJVUM1MHlOaDBWa1hxTFRtTzVXbXBmdHBXVDRS?=
 =?utf-8?B?Y1Bhbmt0NUtSY1NYV3RuZWxDYXJ0U1BsNzg0YXh0dldzTFpOUXRTbVkzaXQ0?=
 =?utf-8?B?LzlsSzM2UnQ5bWZmb2JhbWZrODRPdXNueWJ0ODhLVEMvTE0vdTNhMnpFUm9Z?=
 =?utf-8?B?QmovVjRLVTkvTzk2ekJaRnp3ZTBwdFdEdm5yaUE2L1RzTTB6UHByeXFnK3ho?=
 =?utf-8?B?RmpPd0NZaUlOWG81RlRIR2pzRnB4M3lEOGVqaXdzalFodzVOZWlrTndFcGJu?=
 =?utf-8?B?bTdqbTE2Rm5zVzFtTmFSb1VadmErWk00SDRGOFF1alRQZDR6dWdpNFZ0cndv?=
 =?utf-8?B?cUM4d1BZaldJTGZ2UEJHNDJRb3dZZGMrRnk3ajg0ODRzSXNXeFd6TEkvNW5w?=
 =?utf-8?B?QVBVR21TaVpUeHZCTUszRWYwSkUvdTRwSENPaEhXTDZDaHNYWTkyMlJIWmw0?=
 =?utf-8?B?d1VxeGhLZ1Y2blJZdWI2OXdQYjMrSkl0Vlg2YTFRUlZ0YjVBTmtZRHNVUXkr?=
 =?utf-8?B?cXB5U0hQOWRxd3pyZUpPM294emMra1FFYUhuSHluUjkvVlk0REUrV3JoZHNm?=
 =?utf-8?B?Mno3QjFXL2tCZkpOMmhHNk1rVENCdjhFUTB2bVVUcjRyM0xQWDgvL0J5aW80?=
 =?utf-8?B?U0lkbEorNlhVRmoya0gwV2lyK2FxMzF0RHAvQVlrV1UxZGpBSUViVk5rSW50?=
 =?utf-8?B?bDNIb0x4UGFxSnQzVXh0Mm1lRXdLangwSUZiSFBwTWJqUERZS0FNaDZGVzk4?=
 =?utf-8?B?TW5GSVYxcmhiNlRNRjhJQWNtelVmcGxBUEhPV211WWhiYlF5Tk81T21ZMGtY?=
 =?utf-8?B?YlZuMVd0RjFDVWZtYVNNdWMzZkR3c3NPKzhKdHJFZTE4SVorekpuaS9URmZ3?=
 =?utf-8?B?ZUZoV3NPUERtdjNpaDNJelBXNFBIZmkrTjRxWDVJOU13OVFzM1dDUFp5T0FO?=
 =?utf-8?B?WC8ySjlVK1JPYmdOOGtya2czZ2dVWHlxQi9hVVBzanZoQjhQRjY3WDRnSStN?=
 =?utf-8?B?UUs5cncwSWJ2ZW9SYTlkdmdmVTh6M25ObzFpTW1kQUhzMHNTbWdqVTBHdER3?=
 =?utf-8?B?elpIUDFiMGxETjlQZ0s1V1N0a2Q2azdMUm0xWklmRjd2eWpXeEFqNDh1Q0NB?=
 =?utf-8?B?ZnFjYjJzMGtzT1BzZzRPRG01ZkdETTRkVzROaDNWa25OZ1J1VHJzQ2NYaUNp?=
 =?utf-8?B?QWJRdnZXb1lVOWREb3pLYkxrVWlxOGJ6ZHB1RDUzeFJ5Q2VSMGMxQUJuTGE3?=
 =?utf-8?B?WlFFZW5DbGI2ak5BVzlsQmFRRlhNYkxseHMwOHZ3UVJwYnliaVBGN0VqdlYz?=
 =?utf-8?B?NXhoYThDYzhiZFNpQ3Z1RkNZdUxkbmFBYm43WG8zcTRlOVdkaUtJRm9rT1Vr?=
 =?utf-8?B?OXppSG10bCtZWVBYZkFPUEhBbHJYK1RHaTFVQndFSWxjSE5yTlBNQmtNWE1J?=
 =?utf-8?B?RGY1TkdxSnA2RFlqenEvVE9MYkkvK2s1UGg4cFIrQmpkWHlpd0l4cUE5aUcr?=
 =?utf-8?B?eTYvczJRQklDbHN2dGh1cXNwSmgxS3lVb3VxNmRXTjBKb1pJVEZoeXUwYzly?=
 =?utf-8?B?eEFGeFV5ZGIybk9BWGJHVmFMTnBXaVJyRkU0RGlkSlBHL0E0UFZyRDhTYzR5?=
 =?utf-8?B?QVAxRkxldjg5elN1d1k1T21FalBZcWRJa1Q0Q3V6bWlaR0FCeGVmMzAxM0du?=
 =?utf-8?B?eWxsb3J4UlBRdDkyeWF3dVJpUm50RmRjNkNWT3FqZUFVd3N6TDNESFkwblJI?=
 =?utf-8?B?NEZaVjk5cllDZ3RuUUFWVDc4MzhEM3I5QUZ2T1ZDQTN5cjA5RTI3aDN1Q1kr?=
 =?utf-8?B?N3FCNDRzWHJWWTJ4SW51N3lpUDk3SkJPSlMyVTVLV0h3Ym1EZkFQSWw1Z3lD?=
 =?utf-8?B?Z0hpWTJ0d3Jmck91SXlheGhVQWcxZTRlM05pU0ZhSGoyVlNHTkY3QTIya2hz?=
 =?utf-8?B?U1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: OKcUnGDcFF3zHJjAfRSrI78UsrEix6qU9OHx7JUE74IH0tpzskfn7JUNUeF9tQ/EqE0tfaZlTpTXwYsENbHzcuPNUhYkbBIBjDx1UpK6MU6KIU1gbDflZOgC057FYjSy8hJaEz73oPhvIyhm4n4T+lEiRcl5gpw+b7fhFcxV1n+MaJSaiuguRlPp72vPBF9mZZunDXBAaB3E6s9RFEVcm/TGCFPbpoUuzavlkiRzghmgbtzwrVY8e5a1odHjFSNdpuOMW7lwH+OVhLW6rANrdPV0T7n3tBkLGIJbBnvKMP4xU5AWFLsd5BnDxSo4Vz9FDE3yDQ0pAAeWAzBddumPKy0waDxORXI2reTtes650fh5LU5Y9dxL9BVUxCYqLcmExLzrFRmJKrAzxcIPSjmdACMrOIXL9g/GJch+bds+RpPM4Vv7v0VtwwJX+GeVB3N8BlbJr/TnwC5SNm3syl07L/vzPrMnwtsZtwXdX66MPeDN+FApTgFeMqO17hhmRx41haggPNtdUyDrd5fpC+FeueAd4/SEXz9Ey/Lc+tXw/M7N1vf6Bsv+lrzW2tkTm46Lu4t3vFLUZ/ag6FnAM+fegtET80qsTJHsxBFZt5k8Z5pPse9ualVJ6XGimPnjg7uIuiGyeTiSCaKHTcgJPhHh+tZjxrLo9AQizj5Lz534RydRcVOiekzR3sE8764VEpiHJvKn9+wZ/bMM+iBzst2ix7CORjmLiQHVDkYggbcqcT4zPttegKOVkhhaxadITbRtWzDiy1qZhKnhFRRKflStXIORM0ZF2vK7SPsT1Ksue31B05oE39rCRGErCRmpnfi6H7i3AMUY+YjVXro09MN6cU8bwV431cX881SFEWtj/y2KzNJqRKLNX/dLEZ9SRAcg
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27e5606f-6004-4e80-11b1-08db8e780885
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 08:03:59.5680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RlgGzcZ3O8WBDSTHBGy4xcu3vOzwBVjO1AJYibB26EsunSG83IjFct8+cZjH3CeYIpZXjO4heUTrqZcik3oHUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-26_08,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307270070
X-Proofpoint-ORIG-GUID: 65Tq2etMTkvu6SUKeaYEDac5vXSdUimB
X-Proofpoint-GUID: 65Tq2etMTkvu6SUKeaYEDac5vXSdUimB
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

Reviewed-by: John Garry <john.g.garry@oracle.com>
