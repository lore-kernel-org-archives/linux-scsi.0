Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0CB3C001B0
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 15:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbjHIPby (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 11:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbjHIPbx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 11:31:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9160810F6
        for <linux-scsi@vger.kernel.org>; Wed,  9 Aug 2023 08:31:51 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 379FAk38000386;
        Wed, 9 Aug 2023 15:31:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=4+A+9MjG++emUatkS4XMZagb1ML79ZQl5afL6sipWC8=;
 b=Qz/NXtnO7Eot6z7m08yGToQeltp6Zj5wHsDjYbGk5132keCX7mMqK7H3gR+s2UhpnrYb
 6LxJWXDe0um6Ui2s1AroZbw1rlOYkqWMaKtsM72jT0l6iB9FOPhZewAgzuIMub/drbAr
 Ek3W2LuhHrErNDrV/3xsU5jy0opHHSN4SXVQjSJh6zGCXIY3I8LMm/wXq3l2YSRHkXoc
 MJa3xC2r07tGF6Y9ObOCoKN85U+nV3Yl9gtWMBz3rxAIxQ6pxXWStdXcARJn3wtpjqkl
 sUrxzGxmntW8bw36/5WFFwq7j7h84Yu+TVEt55wY9hzOHVFrPWqFAzJ4YCtMaKkln5G0 WA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9eaas165-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 15:31:50 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 379ESvZ0006233;
        Wed, 9 Aug 2023 15:31:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cve6dj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 15:31:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i6sIzLmkljOZ3SQVqvnj+loB3JJbfy1xWw3UclgfXAQl6mR7MKCJhYbYwBk2wcol6VHI8Fo1yI3nY7SMpE3iTsVGm6TIzvZhoTZXoCuFho8iYAfqSNGxrn61iD4UvfxLm3OK+bATMKKO76j1XLkS0JNdmSwp7uFEI76uxGUuWo4vl4d//+ax9nU9ABNP5rRkOUAlI+vneAwAg6DtImYcc0+167L3VtBzBtv+7SPz2HfTKg+A9h7pC3o1+hzbGqmCoY5Lk0Lsl/ZuzLfzhm4WbQzyyJY8ZKX88DJ87HjH05hZIEov+wSD3qOm+EEBWVCfUmOVEZRkkrNItoXi9QaTVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4+A+9MjG++emUatkS4XMZagb1ML79ZQl5afL6sipWC8=;
 b=gn/DS9YfRh9S8QwsoigIy2MHcMGcD8w4GtJtWEOlYqdobO/h0MiQlRTIlPIEFF0O/xRJPI7XxAGPrxZbbP1dKdlhm3ydhwfeJgy/yqjFOVPFxQNnfU7WL51DH77InadRGPHWdjZg7yqHjURUZED5mvPPbRC7mbxYygUzVjT8Kb5DKSu46eeBHGwcTMPZMekNxIJkKnJ3754qXcZJLVpx/4wTtUWZSpcyOq6irThA9dBdt25KCZoLVQ9ukvL/ImKamPE6FVV1kbaZARRWvfGdWBU2M/TgwO897DfJ+WCkKGRQQdxopySCLYpRm16pUluzR7s1Yp3KPMu3Tdp/PpD6Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4+A+9MjG++emUatkS4XMZagb1ML79ZQl5afL6sipWC8=;
 b=P7TxyE20FVrkoCCorcVQ6829n0R/fpvVDsEFwOmkE9pbLBf/cb33SP4vRgOnN/Kvo3j4OuVH35Jj/xEk4PPc+RXab0yyOe0b0VDygFHA3wVmdCwIIH51bFSa+1i7pFQJyfJ6fPHebEZUgVykFBZlnzulCw6BqSPKefCJ0XU1rT0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB5729.namprd10.prod.outlook.com (2603:10b6:510:146::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.26; Wed, 9 Aug
 2023 15:31:46 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%6]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 15:31:46 +0000
Message-ID: <bc617ed8-ea8c-eb4c-30d1-a3099684bf59@oracle.com>
Date:   Wed, 9 Aug 2023 16:31:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [EXT] Re: [PATCH v2 07/10] qla2xxx: Observed call trace in
 smp_processor_id()
To:     Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        Shreyas Deodhar <sdeodhar@marvell.com>
References: <20230807120958.3730-1-njavali@marvell.com>
 <20230807120958.3730-8-njavali@marvell.com>
 <c010df11-79e2-15d2-135f-71ffa6a6e8c8@oracle.com>
 <CO6PR18MB4500AF34C81EAA0943260248AF12A@CO6PR18MB4500.namprd18.prod.outlook.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CO6PR18MB4500AF34C81EAA0943260248AF12A@CO6PR18MB4500.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P189CA0045.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB5729:EE_
X-MS-Office365-Filtering-Correlation-Id: 69d22edd-29ca-44a4-729e-08db98edbe04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v9cqiW++KIIcv0s6bkW5PG4jmhIgIoqgXo52uIQwh9MQTjbulzsoSxOrE18X7IfI4HlOfuO+NwAid7eQGSlLsQPoLKYdJbsb55BC57WWy7WROFrhIIflrJr+wIMng9SqUQKYaYY86DaUeMwHN0TYiap/7K9GxoC8WA/Gjv7pPXABemSeMffiKzkdtHlhflNq9mUgXKBaO2sylDZsHbmVNunYEnPLfbE8LGBf9waJIZSsm5G6aSPzu+JlSZKxgELlX45X0uGkcoZInSIPvHM90U8gYR7gmxRUcspIgGk+5gSuliAZSQkIUYPRHiN/elQ+xIhMMOixsHv1SXcwPP0uR6ljYe43aUewHnf9JGaJ41reAyw1K0DYcBzkmJiAgpk2Jqjkxo30t0wOmcr46x3lrk6Zzg78TqWmmyHxoqznOHDrxn2eKQRPPqVKt5+gw4s4r08aNl0KtT0AEHPY+jQqIxHxquuagyn6gBGerdOcNq328Z3222SNy/DPdDyElnYRoNjK91TH0XsHEOke+LmQpBpcOnwZQSSevEQ4Z60H9vNbLj9qRahTl9xFMA7/3mrpYqkUJmm2Hc8hekVslj3v4aacvCNC4GkETopC1NJVZNGNoK37agOgs3AkGWjqZv9iuCQg//h4+QghE8yK54lzsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(366004)(396003)(346002)(451199021)(186006)(1800799006)(2616005)(86362001)(26005)(54906003)(31696002)(6486002)(478600001)(36916002)(6506007)(53546011)(36756003)(2906002)(41300700001)(6512007)(316002)(66556008)(8676002)(8936002)(110136005)(4326008)(6636002)(66946007)(38100700002)(5660300002)(66476007)(6666004)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXE1WGZKNXkwUUtWV1FCY0gxWFlIS1pNVlpzRXdCNjNrcmFRdys0TjRrZmI2?=
 =?utf-8?B?RGQzM3l0bWVGTWRqa3FvekxRVVZJVzJ2QzczZ2V0ZkRURHNMb2xMb1VZWjRR?=
 =?utf-8?B?bE9oSVVUTm9kdm5rend2bnU5OUhhRUR3KzhHWWE2eHdibmt3MFNESVhyVWkx?=
 =?utf-8?B?VGNjVWgySVBid0dvMDBxOFRoRmNpSlYyUXY4SmdpNzhuR1VxS0FqQTA3dVNy?=
 =?utf-8?B?MzlhU0xlWVp3aTBRQnFwL3RpNXgrWlN2YnFkT1JWdUtvL2syNDJidC9Ca1lP?=
 =?utf-8?B?TUVRTGtxMEI2SzZUd3RtT0NKVWZEbnhkQStNQkFpWGVUWDJhY0Z2UUpxYWdZ?=
 =?utf-8?B?M21vZWhPcXFLdDBvaFExZVV2ejBxV2RmNWJEVDNFNzJVZ3N2ZHh5Yy9tc0JZ?=
 =?utf-8?B?UnVwL00vTm1vNjhrdXJWOFZRSXA5WjAxZitDTUdLemcreVJaS1lLWmtmRE5L?=
 =?utf-8?B?L0xCM0VmYlpPWGYycXVsQlZuRVU2eWNySU53UjA0c2R4ZDA0N2NGZUJUU3ls?=
 =?utf-8?B?akJ0M3ZXckdiMENyaEVYRmVvSVJTc3pkSUN2TkVMSm55OGRUZFp6NlY3dldt?=
 =?utf-8?B?cUZxOUJIKytTanNScm8vN3MwdjFvTGY4R0lnVWZyZVNRN2w2d1MvUjVzT1I1?=
 =?utf-8?B?c3NvalMxUTRzejQ3VFNLTC9NRTJsMkNoZ0RtU0pGZDBrdW5uTDFjb2lwSUhF?=
 =?utf-8?B?VDlMMjIxMVZrRzZiMWFWNm43eGw2czZDdlM2RU1FZUpKU2hIMHl3dEJqN0NL?=
 =?utf-8?B?b1BBNkRCWTZWdXphdnJOZXNObDBTN1RVanVqTkFDNjVFSW9jSnE0QXcxS3Iw?=
 =?utf-8?B?bjhXV3RPQVpXQ2ZZQ0lLVG5ibDFiS3JRRWJvU1AyenU1anUzeEN1VW1lK1Iy?=
 =?utf-8?B?WG1CZlZ2Y0Q3RVJkQ2ZQMWpVdjEveG94eXVJNndVZTlxa2lCWnVGbFY4U0du?=
 =?utf-8?B?d0Y1RmNrUWNaOWFEZ3psSkExY1pZOU9KeStwQUEvdE4rRWh2WWJIdy95Zlli?=
 =?utf-8?B?WFRONS9MaWJTZmU0UVUwc3ZEdEV6QXZnTW5IM1BHcHBtUzE1a3lDbVhOQkVB?=
 =?utf-8?B?cXJWSEl1eTBqc1h2NHRIMWMxaXNJYmQvUi9zV0ttaUVacUtSclM0T0JDeWpi?=
 =?utf-8?B?TE44MUlqU3VlUkNPS0c5cE01aEVEazlIbTJ2MmFaemFxMVNXOEhzaTFJVWxw?=
 =?utf-8?B?OVFlMUoxRzB6SFVSbXJ3M1NhRmFLcU03WTlzbitDVXg1em1PdFpaT0pyOG1x?=
 =?utf-8?B?RXdXVnRtVHVLQXUyOFMrU0xxVzNkbklJZ3p6SERHRmpZSm9pYW56MjVKemI5?=
 =?utf-8?B?ZndjbUEweHdXY2JPc01Dd1N2WStQM0ROQjBrSHQxWDJTSDY2QWc4OEwxQ3Vv?=
 =?utf-8?B?d1lTRmpQL0lkSkJzZ3B5a3lJY0dUS1VxMnpCYmQyTkFBRGNYNnkrTGpyOXpQ?=
 =?utf-8?B?Nnd3Rzk0a0FKZU1mWm1xc25iMkFmTDViUmpCcFlzTGN5aWdiMUFraEpEOXpn?=
 =?utf-8?B?eFdOL3ZDYjJNL2x1OFVmZTZuc0NaMmdZTTE5VGZCVVMxdDQ0aWZBcUFlMzJL?=
 =?utf-8?B?R05zMHJtclppN2VTOERjRDhnOVZsSWRTUmwzTituRitFWmF1U0wrNTh1WmxO?=
 =?utf-8?B?QlBFWmMvQXlXMHVvdDRhbkhQK3ZGOUswSlZoWG9tRUJtMTQzQjN5SlM5T0JC?=
 =?utf-8?B?djlGZndpb2RGTUVzdzFIR2tXbWlUYnJhVHhaQUJucXd2UVZDZ2xkdjZ0ZU9N?=
 =?utf-8?B?Mk9FUWxRN25UMnZySEJDNHZDcTlyZy9sMHVmTGFYNnYvMk42Z2RpZFR4SXJj?=
 =?utf-8?B?WE5GQzBFamdtbjNhdENxMDM0YUVBQjllNkVpbFcxRGVobmw5eGZtcWNxZElo?=
 =?utf-8?B?YVB0ZXBrbE5lRVc3bDR1VzhKZ1dkVXducDU0d2R5akJwT1Jnd0VsdlplN0Fp?=
 =?utf-8?B?bDg1Myt3UyswTVgrdDJLSlVBSm1aYWx4Zy82ZEdncURoVmVpcW5vblNnZ3dy?=
 =?utf-8?B?dFRkYTl6RWFCWkVTVDkrMUF0aVhkNERlaEw3dWhBMWxVeFk4RFQ2b3RyVm51?=
 =?utf-8?B?YUJrdU50bE1zL2E5SnhKbW1oMzhBSGZBYVU3STU0aXFYV1Jqb2hHZUZMYzlz?=
 =?utf-8?Q?vCfANqR4PJKf8Oe9Y3vXhW99H?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: cPuB4mxkExEC8/7dMf6I9Tu4+FrDq1IGDXdDC89s4UHy8eiYjpQD4Kc4bVszjqo9wQv6GiP5EcbcEYhJaYBJGQYKQEQNNxXMRaVvvboyPS5L9Aedu0qd924XhoREOZyUyk9s17QBaKIZ/sLAGjuQ3SVve2Qao+/NTW2GLBrzjCzJdBQcsSQ9+bTF/xufg6/5LlcuiZ65A65hWFtyFYVDCMaPshRf1XYfXIqE5jice9D47+j/HnjxNAxod7nizTih28Ex+KOP2mO4BeYrdOLi+vAmIyHfiprgM0KLVFD2pezghi2TMqVXbDo7jRWLFuKKy9akSDFWmtCPeun6o5EJHtVg1dc1jLsb4U2Z5wY0/FsQD44qSvRxriRcg1s/PABmH/FiVQU822rju8jc/C/XBw1eZW4jyqqKSqwyvQ/48gOAXyqEkqcdHdZkOY64Eyd/EAk4n3LlHCHXgk1JRpiv86MdjHC/P5Ak0B6VOV0eJmUl+dgjYH1ILWQEhx+8pE8sor7kTn4Mm0xo7xDWEX0TIdvjD7SicLcwtXZLqmK45s403GDbDyUAge+9QEgWgSBRZebXahmB03TtVlynAS+JllRDfgPqnOxwrLvYyl6eriV7MEmZY0kpn6exnlRMBIJdrCTe/14KZT5QE15b11mdscZuaaBGaaYpXCYC+9sOk86qT+B5BMSgRAq8uDBkuUu7RnL2UWLa3WxhKXNfk6dNGjc/w41umsw+IodlttBd1GcX0nE7kCpXpappSxdfDMhOHZhhxTNywsLfB8p+1nrXsB3NgNR2dWtGf5Jiymh95Qs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69d22edd-29ca-44a4-729e-08db98edbe04
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 15:31:46.7961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VXEtZXa7IxiWVts2nH/y4bcpgcYghMwogdrq/NyAaNGkCYB2NB7I24udIzXyqr4h9cc7+7Am3PBisS0fAx24Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5729
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-09_13,2023-08-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308090137
X-Proofpoint-ORIG-GUID: _xXsgi887-b8xq3zE87MrcbokBEeb0XD
X-Proofpoint-GUID: _xXsgi887-b8xq3zE87MrcbokBEeb0XD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/08/2023 07:03, Nilesh Javali wrote:
>> Furthermore, for the instance where the calltrace is reported, above,
>> there is no mention of why it is indeed safe to use
>> raw_smp_processor_id() and why the warning from smp_processor_id() can
>> be ignored.
>>
> Thanks for the review.
> 
> This patch aims to silent the warning message in case CONFIG_DEBUG_PREEMPT is turned on by
> any user reporting an issue.
> For qla2xxx driver it is not critical to have accurate CPU ID which would momentarily cause
> performance hit for the thread that pre-empted.

I doubt that the driver needs to check the current CPU so often, if at 
all. But I don't know the driver well, so can't say more.

Apart from that, according to description of queue_work():
"We queue the work to the CPU on which it was submitted, but if the CPU 
dies it can be processed by another CPU."

So isn't something like
queue_work_on(raw_smp_processor_id(), ha->wq, &qpair->q_work) same as
queue_work(ha->wq, &qpair->q_work)?

I see that queue_work() already has the raw_smp_processor_id() call.

Thanks,
John

