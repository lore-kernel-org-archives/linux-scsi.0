Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA7C2C001DF
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Oct 2023 16:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjJTQ4B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Oct 2023 12:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjJTQ4A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Oct 2023 12:56:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB065197
        for <linux-scsi@vger.kernel.org>; Fri, 20 Oct 2023 09:55:57 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KD8rkE018036;
        Fri, 20 Oct 2023 16:55:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=t+HidXHQbW4V/mVRr9KB99c/iIOCHkgctgK9svpUPps=;
 b=M+QrE6n7lCtLcjcKJJ9q4E0TCVpF5Ai0mUNS2970yizxHj0OLyaTiCLOP/gpjKgJK4ZG
 VeTtWh4n3nwfdTqyxFKIs7YFKhevLTmU8Vr+dcbjRm2M1eGmh02FEflIJ8naO95PMaZB
 hQW6M7LtKodbjrKBGfKnWSRj1ZxUVf33Q2iphQUQqUM0Y39N8jybv/f8z2t4l50iIQ8H
 cezZ5jICBh0roZkidZTqU5rf1XrJxhWgjC1r9P8gM/3ODvUVKVDdp+effiaQjOvijsVe
 uKLnIh58KPlYGY7Pf6HL7PvU50/KtE+Jc0uKw31MzDpMIhj3KTuKP2mLh11BZIajEVoO +A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubw82abk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 16:55:50 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39KF4dp2014968;
        Fri, 20 Oct 2023 16:55:50 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tubw69e21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 16:55:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdVJ0XhxgbS6iC9jLNV2Ul0GEmuZwWjpPe9EC+a81yrLeJ0rCNXAl5tqZWD1TAXzNdA+/xVeYa9FMjnUNlKL+tX+Flf2UVnhrFovYK2C3dFQJ3q3A91Q7+TmacrsuJHtmUZI0zEtVUHAxvRsKBaqkYRORK6jm5euUHWF/PXqiFi7Vme8ZDsfwso2ZnpavGDGkiSheyL7h9PlGxOa9j0o4ppvpZu1VDo/ywXJ99yR/PxWxA4aDJeg9o70ZZ8kt3KBVkPU2ROxsuuIk4ZzN95//rWLqNVjgmXik60XT3NBGkv1cNr9ymDMp7i8FUEl7G2FSJu93IxjEVmy4e7I9zbIeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+HidXHQbW4V/mVRr9KB99c/iIOCHkgctgK9svpUPps=;
 b=Er47DZZ7iBVVnyRsxA7DcYW2S2FAq5STLHHebl1Yps37IF4w0Wrx3DUmRblhnbUB7UFcGMqlQmyGgfSsGM568AmFsM8n9UuaqjQGXcdZWmCoHgJTVNHkPmtUBVNheUZvglrQfhHReSuwtpYoNknGs6rzR0Ag9UxZDAU89jSWOe7I6N8vxFvxGRlemM8+G48OgCLLAGHbnbYotKF+h6JxkecZv2Ta7eq86FcdNZKeVZLCsYqEnuQkYnYuSdRP42Y1ylzTiYfQCqAu0lg/jp2udB/FFxqu3MgDFYbzIBzpK1uCutU9/AJnccmVX/xJyoXtapxNZOLqCicsMrsCLwkpzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+HidXHQbW4V/mVRr9KB99c/iIOCHkgctgK9svpUPps=;
 b=sWFj1Z1lwXGoWAH8hT+Mzx+nX2TCdkPJ3yXXnIyhzeldkfoc1pRCZYcSChd620MyagvET7vIvu3K4Ud3UtbcvSo3IvrbMMrDSWeS4ExbaEw8vkrDdc0GIg5Ym3WPOUpthFgUayzfSMgViiGbysLVSGGe2MMbW3dOo2o4XsNPDB8=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by LV3PR10MB7721.namprd10.prod.outlook.com (2603:10b6:408:1b7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Fri, 20 Oct
 2023 16:55:47 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6907.022; Fri, 20 Oct 2023
 16:55:47 +0000
Message-ID: <16a78fec-3f7d-7307-d89d-0bd1f0c51d07@oracle.com>
Date:   Fri, 20 Oct 2023 11:55:45 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH 09/17] libiscsi: use cls_session as argument for target
 and session reset
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20231016092430.55557-1-hare@suse.de>
 <20231016092430.55557-10-hare@suse.de>
 <00f10f98-46bc-4af2-a3f1-a1523c9f4e1f@oracle.com>
 <06475025-fb65-4ea4-8ae3-54292b2360e4@suse.de>
Content-Language: en-US
From:   michael.christie@oracle.com
In-Reply-To: <06475025-fb65-4ea4-8ae3-54292b2360e4@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR02CA0092.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::33) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|LV3PR10MB7721:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bdeceba-800c-40ba-4cd6-08dbd18d6852
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QC2ZY6W8zd+yE/WOYx0qYoJk1wmKMBXR0e7jBNBJkN8e5eO8n46jSFcY4/OlY/b1NjNN3hsoxyLzrpfSsDlIiyOr9fyVVJpvpT8ZqeCzgHMOKSQKpBVAqUC50iwTNetzUyQ8kmsHDcTGOsycKN13iYtxCkOJSbz38Hdeed/5bt+/64PyOxlCL+VExZhlWILWSQIzp5jxKjfN3RzEQXeoiV1BGKLIq72H9vQuMd0nxGk+mb912qrF7DIyn+5lTfdN9bruRhasddpM0YDMj0b+0u4rlvvHMcPlq38fyZgIKcgi8Znu03ywfhFnUSNFgQggP7BMmBe2pIykW+0uv7ejHNCiZ8cpm4vkEWqeT0JENQ6LFFzw2qQ8+FvvHT5bwCtnPjK1Q7ZIBZdjUMk0wjZH9SzUgmjIqtvHIdpPmoHbRaDVtXCuswY0Y+NGcphhdUiT6NoXE/DpWmnX8pLa+yjnNNC5+Fj7FQpe/pWP/XMtIEpm4cddpGLgrUFdMelvkQBO/DFEt1NUGC+mQ1JDnmzF5DlcZcY6KOebec/UYsWMZg7asfooAwPzC0v9Z8IFkLg/c7FU/HO/KQx+W1Tml/ZopI9z6kSR0Hes+a3/mWVXZ4UQ064HpuDXyY3eVcQa62rB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(376002)(136003)(396003)(39860400002)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(66946007)(54906003)(6506007)(6512007)(6486002)(41300700001)(53546011)(66476007)(66556008)(2616005)(110136005)(316002)(9686003)(31686004)(478600001)(26005)(8936002)(8676002)(4326008)(2906002)(83380400001)(36756003)(86362001)(5660300002)(31696002)(38100700002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N281OWN4S0d1eFFSc01KRjA3N2pFWHJub1RyL1AvTGJSakxlRjNySjBtZUs5?=
 =?utf-8?B?anpOUHNieWhGUjl3cVlsYnV4eGNFdEUvR2Q4MnQ2V3N1MzdWdlBDSS9xTFd6?=
 =?utf-8?B?UDByWVZyN0thaURYYVE4dzFkbEhqU2hjbFVuNS9oWFkrTUtkWVBaK082RGRp?=
 =?utf-8?B?UzhIMkt5YTFRRWpCbUNjRVRwNXhzRmNtaFV3clJwYzNqaXcvL2NuRCt0WmxD?=
 =?utf-8?B?SVJ3VEtvTDJWSjZ0aHgvUHlodk96eXE1bnJIcHlodjVyWWs5bmt5T3dRVkZo?=
 =?utf-8?B?Uzd0MmFBblZPRDRVMXJWVk5LcW9TelR3NlhkSXJCNlBmRW9BSE56M09RUWN6?=
 =?utf-8?B?ZVlZVE1ibDF2ZXVHSmUvSHgwMVVpSVhKRWJmaUpIWDZmdktBN0dneUF0eVFX?=
 =?utf-8?B?MlBKd0FpZldmV0ZLK29qTERKMVBPR3FzOERUODVXeEZ4N3FrWnJlODRWUnN6?=
 =?utf-8?B?WXFnV2kwRThCYlk2VW9mem1Fa1dpZSs1K1VtRHVxeWQ4S3RKc2k5bHc1Uit4?=
 =?utf-8?B?Skt1dWlsS3FlU2QvVWF5MGRWWG1jckxCZXFNMFZFbWRHZnI2bEVJVVRKNkdQ?=
 =?utf-8?B?ZHVacFBGNUh6SDlpZlpJU0JCK0Z2bUhSZFd3SXZvTi9OYkU3cTl1ZmVHVERK?=
 =?utf-8?B?ZExRT2x0bXRiSkZneEZHdkZmcHJSWUozalRQWHp6Tkk1dFlnMVlBRG03M0JU?=
 =?utf-8?B?M3ZvcHJSWU1jWU5hdFZtYm9IU0JGRVFSOTVJNk4rTEdsSWsrZnRtTE4xa05Z?=
 =?utf-8?B?K09wUzlOWXF1UC93cytqb3pGRlNreFlKcjZncjZMTXFaN1RiRVFFaURBRkFO?=
 =?utf-8?B?M1F5TXJzWUVTLzZhTjNrRUJHWFdDMFFNYVB5azRVaTZtYkk0aS8vaGowUXE2?=
 =?utf-8?B?bDF3R0ZVYy9BWTM2OTRBRFFRNWtyb25yOGdad0w4YXRaVjFhVWxQSnJmRVJr?=
 =?utf-8?B?elNwZXJiRTFTQXZRbnNOd2dFUjgvS2lFZCtqRy9KK1VpTjdvWmw0S3J5Mytk?=
 =?utf-8?B?R2lDWVVjVVZvVXhmdk1ScWZHejRBRTNtWFJDbmZFSFZlM3dXTmdTZzJyWDRQ?=
 =?utf-8?B?OHhZSzdlSTBnekMrYWhIQmlPZUpmQjZqTmtJOHY0UStDWk1MZlo4RWJPWFh3?=
 =?utf-8?B?Z0IwYllWS0psR2xPS1dvM202bmNvZUNneFo1N3YzdzAzNzZvU2N6TG56M3Z3?=
 =?utf-8?B?cmNyZ0xwRWVrclRpSjJWMHZyKzlPVDkvVTgzUE8zaVQ1S0w1MFNjdzdKdU1N?=
 =?utf-8?B?a2tNR1dSMU9TUlB1NUlGYWdSZnRCM01vNTVLMmVSYWIzUE9jS1c2dzA5Q00z?=
 =?utf-8?B?QU9ScFByblVMcXp0TE1Fcm5CdG05blVzdlFDR21ETVU1d052ZUowbjRQc2xB?=
 =?utf-8?B?ZHJoNEprUUZVN25sQkp1Y3lpVUZCRGY4YWJFM21kK1FxSDFvQktRR2pTSFFq?=
 =?utf-8?B?Zm90ZU5iWTZCOE8vcW84YjMrMkVDZmtHNDFxL0M3N2VMSTU5b2I1ZElMVXdW?=
 =?utf-8?B?ZFZpaVVLcmhscktLU0c4S29kV2hLemljM09KQWJCcmFGNlRCcG91ZU5ROVlj?=
 =?utf-8?B?V2lXMXJGcjJWU2taejBiUG5vZlZXNjNVVVdTSnBsRVZNRkpmSmM4WkFNZ1M5?=
 =?utf-8?B?MDQ1L0I4b0JTTUVrWSs0R3BBdFZhQlNjYUVYSTRPMmovdmlmRzlGR1NDVTNa?=
 =?utf-8?B?bFUybllMcCsyZHZDTFBSYkNiUFdzbDV6UjNubmsyRWtQOUdXVU1VTkllYzNW?=
 =?utf-8?B?eXp5WmNtRDc1ZGdjcGNFblEvdVhxV2F0ZzdUK29rdnFLdzlVV09aaUFDRlM1?=
 =?utf-8?B?S2QvNCs0ck44UEJhb2FjRHdoY04vK3h2Q1Fublp3ZEZScGkvNkgxa0t6Q3VY?=
 =?utf-8?B?TUhhM3plZ2hzZHl6K0VPb2hHK09mbmM2NGNMNlRPTlV5T0hOTTdkalZZZXU3?=
 =?utf-8?B?VUliMnNHOHRVbUpWQkg0WFNhZ2ovQlFaZVlXeXhVR2xYUHd4RmNCaEpaTlov?=
 =?utf-8?B?ZDhVbG9aQTFOcm5vUkNmdnBGdU5HQWlvcTlsSXR6WWtJaTZnbzZ3U2tneFFm?=
 =?utf-8?B?KzRNeTFWc09CWXNFSEV3djNodlNsbEJwcFAyRE0xSWZlZ05sdExhT3JSTW0r?=
 =?utf-8?B?WXBmdFN5SUNIS2hzcmswdmdET0lQaFp4VUh5ZHRzdU9kS2cwaGxCaVpuMkFt?=
 =?utf-8?B?M0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jbm+2//toXWhnndGal0v2JeUgYoFaMU2LptKpRUYPUMQFAM2hL0PIeP1dcIZvxgJHWE9HmCbuN5q0eHLLUBNZg7W42ES6oNXNmjl11cn3UDRIRxwPpqOIjgccoMp/L5GIL3Rz9sk09e9RR+mjJm3CjeWC6Uq8KwCYjBDT5rdV0IH+0o7JpLlY6cw+/V3RbaA4F6u9vkMqGOydEYNestkiKRsBczIv/D2q9RI+/QsAyUcVMPYgTfIY2uiT7RD2gC8QOexJqmIsXgeZWvE0XUhVD720ActjmDuotAiVttrzFwshkWrXPi28beBba4NNmZHTt3pZJX+WiF7avLtPfw6g6r09bRvz//K6rzTM5KNt5FfVp9meGynDEJ+SEdWRG+TsTqHsCQV4IZqumS2RbILALn2eQQPCV8hZfqnZAWTimsL7WxU3gjxjjo8R+HK0Lby2ndF/YytVcemb5sZ6c1sfHEoDzxMini97iQZbelviGJbvlRQPucWFzTB6sJHSTkOfZiFtElXLzp/xJF1HY1qGtlaRk28LGDR+KZOaVSF8yEK2hmV7I80Y4vj0dH0avK3Swm33BZgXHbmQTvNOsaeTOOa68H/UBR2ySw8hJCN4wK0sBkpmALT3eMe31Uf6V5VWT2b9JA25kgyGTdabj4zBFA5oe6e62qVvH8NkEtKVtqyfqUdwRmVjGKyk+WaCIjjj290AQ7r+LrmZU2+DxCtlo5WjyNnLlYaRTPI9jEgxZ6WwIF715xFDe0A6VhpRomPsdQK9n6gTu8hf6WsffuJvzoLFgfvO27Gh9DpNwr7XPPUfELf+uesuAk5V/+PW6Y4xx/dnd6H9bVajxTRilihiL6NG80G2ESIM0/oVFQg6QI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bdeceba-800c-40ba-4cd6-08dbd18d6852
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 16:55:47.5516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U5KYPV33SOKuCMzzZ6Stw5QXqInKsxA6fHDhO61xh7Xsr64SExBI1A5oGiYcyBAGxS+RBWNtXotGNRa1+T9JSt4bNnTyOZoYxvl9nzK1XSI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7721
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310200142
X-Proofpoint-GUID: sZFAsnwuG1tzpSO9ZA2dVJ5C_cWscNPK
X-Proofpoint-ORIG-GUID: sZFAsnwuG1tzpSO9ZA2dVJ5C_cWscNPK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/20/23 12:53 AM, Hannes Reinecke wrote:
> On 10/19/23 22:02, Mike Christie wrote:
>> On 10/16/23 4:24 AM, Hannes Reinecke wrote:
>>> iscsi_eh_target_reset() and iscsi_eh_session_reset() only depend
>>> on the cls_session, so use that as an argument.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>> ---
>>>   drivers/scsi/be2iscsi/be_main.c | 10 +++++++++-
>>>   drivers/scsi/libiscsi.c         | 21 +++++++++------------
>>>   include/scsi/libiscsi.h         |  2 +-
>>>   3 files changed, 19 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
>>> index e48f14ad6dfd..441ad2ebc5d5 100644
>>> --- a/drivers/scsi/be2iscsi/be_main.c
>>> +++ b/drivers/scsi/be2iscsi/be_main.c
>>> @@ -385,6 +385,14 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
>>>       return rc;
>>>   }
>>>   +static int beiscsi_eh_session_reset(struct scsi_cmnd *sc)
>>> +{
>>> +    struct iscsi_cls_session *cls_session;
>>> +
>>> +    cls_session = starget_to_session(scsi_target(sc->device));
>>> +    return iscsi_eh_session_reset(cls_session);
>>> +}
>>> +
>>>   /*------------------- PCI Driver operations and data ----------------- */
>>>   static const struct pci_device_id beiscsi_pci_id_table[] = {
>>>       { PCI_DEVICE(BE_VENDOR_ID, BE_DEVICE_ID1) },
>>> @@ -408,7 +416,7 @@ static const struct scsi_host_template beiscsi_sht = {
>>>       .eh_timed_out = iscsi_eh_cmd_timed_out,
>>>       .eh_abort_handler = beiscsi_eh_abort,
>>>       .eh_device_reset_handler = beiscsi_eh_device_reset,
>>> -    .eh_target_reset_handler = iscsi_eh_session_reset,
>>> +    .eh_target_reset_handler = beiscsi_eh_session_reset,
>>>       .shost_groups = beiscsi_groups,
>>>       .sg_tablesize = BEISCSI_SGLIST_ELEMENTS,
>>>       .can_queue = BE2_IO_DEPTH,
>>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>>> index 0fda8905eabd..a561eefabb50 100644
>>> --- a/drivers/scsi/libiscsi.c
>>> +++ b/drivers/scsi/libiscsi.c
>>> @@ -2600,13 +2600,11 @@ EXPORT_SYMBOL_GPL(iscsi_session_recovery_timedout);
>>>    * This function will wait for a relogin, session termination from
>>>    * userspace, or a recovery/replacement timeout.
>>>    */
>>> -int iscsi_eh_session_reset(struct scsi_cmnd *sc)
>>> +int iscsi_eh_session_reset(struct iscsi_cls_session *cls_session)
>>>   {
>>
>> Patch looks ok to me.
>>
>> Reviewed-by: Mike Christie <michael.christie@oracle.com>
>>
>> As an alternative to this approach though it might be easier to have
>> this function take a scsi_target. You won't need beiscsi_eh_session_reset
>> and for iscsi_eh_recover_target you can pass the scsi_target to
>> iscsi_eh_recover_target/iscsi_eh_session_reset.
>>
>> Either way is ok to me though since we have to convert from scsi_target
>> to cls_session somewhere.
>>
> Yeah, one could do that. But the relationship between the target and
> the host is not fixed, but rather depends on the driver and/or transport class. For simpler devices the host is the parent, for others there are elements in between so the parent device is something else entirely.
> So for generic routines (like libiscsi) I prefer to use dedicated
> elements such that the relationship is known.
> 

Based on the first part of your mail, I think you want what I suggested :)

libiscsi and the transport class setup the relationship between the scsi_target
and iscsi session. They handle deciding what is the targe's parent and pass the
session struct device as the parent. The drivers like be2iscsi don't know this
info normally (be2iscsi has to do it in the abort and reset function because
it works reverse of the other drivers). So, you don't want
beiscsi_eh_session_reset function since all it does it translate between target
and session which it shouldn't be handling since the class/lib handle it.

You just want to pass the libiscsi function iscsi_eh_session_reset the target and it
will figure out the relationship since it set it up.

