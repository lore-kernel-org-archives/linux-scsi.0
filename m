Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A471C04FDF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 11:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbjGYLQz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 07:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbjGYLQl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 07:16:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826071FF7;
        Tue, 25 Jul 2023 04:16:37 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36P7oaTk026623;
        Tue, 25 Jul 2023 11:16:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=3Pmx/xIOmWhEEqrVdFBHjUisllWqcKS8LA4mSPZpZ4k=;
 b=xawKlcHw+P0wNUBToWKbWcSvrbpAWfMjC8za78FB0r77Vso9xHuVB3zRpZkRRHArsGb/
 BVRJ/MkE0DUNy+4X8+gjh9Mhb88Rh+x+X1KNhgv7MyWEesVGuvuhDyZg3VBXGrzKZpEl
 lnl92VzCyYcS9o/DlYYSSB7Nj/ARNE4VR5v35QgrYIVh2fq/yGj5duPwPUFVw5F9MVn8
 jwQUVCP17fIf1CLpaplzwbmm2OV4pzcIjvRAXpmm9Ndwh106cOOli0pxls2OEyRSPSkQ
 8b109Cw6qCegxoncJxeS/3RJpiz+h9BJiAUI4+rrD+TR3EMlH7HomkXeUq/YBA6XvjoJ PA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s070avswa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 11:16:21 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36PA8sa9037436;
        Tue, 25 Jul 2023 11:16:20 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j4kumd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 11:16:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLyLeejBI3QaQ0RkSd9ust53MrrfVe9LtYQTnRjN1Hs966pqAX0FfghSg0EzcGF2vH1G8fk4UANlTBFm8TGt2mPy8ec81t3pl3Tn73FP3OxHzLPwLOZ5QxSLSBTqyFtPiGEyf+4TQjOJu4jVY4vQmkL+DPYPeUhYaiK/Y4n4uum5BjaAkmJqPBu9GKZs9/ONpVjp2zx35ZCXaAkyvqkq39zGWeUq7H+FBcSddC2T+wm2r+LjwVSeRPXKKzQcJapEqoW3UWZP7IcDVcCtkWPXqrbWguN/u5mZImb5tPZtIzlFIsxMJ6jlzgf/xpvFcfBXFWitSb8eKygJlOgtTC9Z1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Pmx/xIOmWhEEqrVdFBHjUisllWqcKS8LA4mSPZpZ4k=;
 b=mvAZAfWVblN2XrU5+yHwZnAjfBO3u6vFM/dQXfuVuopXbXgNtBr6OtoMbDtmmT/w1MVaCY2FAWMSJ04qdXWRNSR1ERMcV07OU7mr9qepBwUPR/90pFfMAWwStwqLTrgb4Z0j2zCQr/dKgOoborAMMVfQBa8eCXiRn/8thb5pBrzAWl+u292s/awimjJ6oQogQwbhXwm4L6gNajy3QP44hqfAY9qd5KDdnlK7iTcANVc7HVeoM17bSejkhfMYSU7SI0SaBGJQYjsUdyjp9s64kyE5UhJ9KYhORqxUU+ySnvdS/DqhMbPjc4IsXzOovI5WrAYcwNDdC5f1DmA0MMzX2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Pmx/xIOmWhEEqrVdFBHjUisllWqcKS8LA4mSPZpZ4k=;
 b=pa+5WWdQKlncsZD1nBDOLQ5/lQcMmmXWvzbXEnHxMNZGdXbD8tRzXUA/GyMJjnehSKA9BEADo+m8tc7CZNaE5H28jbutohUiOMANHq3S8GaikvM3M1y2Ef2Hjicq2d6Z7vT1Z1KhPGy5ZkTkVD8P5sa7qlyFoh9kzsQbYULdyV0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB7348.namprd10.prod.outlook.com (2603:10b6:8:eb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 11:16:18 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Tue, 25 Jul 2023
 11:16:18 +0000
Message-ID: <e2dc2999-e39a-8c1d-fef6-d67988070ce5@oracle.com>
Date:   Tue, 25 Jul 2023 12:16:12 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 6/9] ata,scsi: cleanup __ata_port_probe()
Content-Language: en-US
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230721163229.399676-1-nks@flawful.org>
 <20230721163229.399676-7-nks@flawful.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230721163229.399676-7-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0103.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB7348:EE_
X-MS-Office365-Filtering-Correlation-Id: bc11b455-8ff5-477a-cefd-08db8d009148
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cMY5uGQrBs1hYwqZNA+R14YML4s6ngZpl/A1B++pGAjKBS+RZ0awKp3Wy9hayeqPAH6pKUihP7oNhzuQYPCBvMjImuQqBvxpWPHQh61SrHN17WHEpQVWlmyRS132/SZT3lQvfmDTufwTh+ZUpG74nOWhoawrt5t0WgajR/CaDHpytLVdmw55lcIxSk9wT4RHUPfriFgkmGYIff8a8o4KHpjE7pIy/3Z25xbHKs2b4yhmWzvYcAOYbyO1LkadhUZkAAjPrEvbUwCPdFclFbUzAcNR0m+EglXWazZTtlwLO9VvE16MUw21r10b3wt4AnARbdMcKoZAq5SIWMczy0Pb5oCpWJfZerezHPIvP1VgE4raDF2g4Vy/ZmfLPoXGpAgB0lNR7SGMYyAqhKl51BH0wQIW353/M48HwnW1wASUkR9TtkSVYh5QejWgFzUbinnunhmrkFhoSkSxgf+sFVA3X8K1qdzabiuXXoY20ZYrERcTAhJP3FqEllOOz9XDn+L4fC2Qxcw6oLFeM/0qRgwmQCeYc0aNJgBLTKwhC+OcnzNJ5xZR+sQ8Zcl0nWoL6FrRpnGMgSjc23t5jsnMQoK0ovYYN6lWA5th48Zz4VP+9iC34qHSDnuQTYG3+xR4lO/9QQ28LU+VU5SZz07rt9WmEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199021)(31686004)(8676002)(8936002)(5660300002)(41300700001)(316002)(6636002)(4326008)(54906003)(2906002)(66946007)(66556008)(66476007)(6486002)(36916002)(6666004)(186003)(26005)(53546011)(478600001)(110136005)(6512007)(4744005)(6506007)(31696002)(86362001)(36756003)(2616005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUNDOCtXbkdvUjZLQWdGanJYdnZCem9JYWtIRW9DK1B5V3RkUDV1T3JMU3ow?=
 =?utf-8?B?TVAybUxKTUI4ZC9Lbzd2S2o5ZHF6UHNNaHcyL2d5MUt4c3psRjhNU2QxcC9O?=
 =?utf-8?B?MjFTM1d6b3UyRnpPYmhIYkc3dUhLbE5ZcEhFZCtseFMvVHpRUUU5Vy9sNjF6?=
 =?utf-8?B?UTE4WWY4Zmc0OXFNbTlnZWVRa2dmcUdEVFdQeHFVWTJoVGNEV0ZOcHIvV3RF?=
 =?utf-8?B?c2pWbEZuUzlvOUVMUUxJUGhFVVdsdXc2cWwxdVFqMUJHdnh0cTRQVSthYStG?=
 =?utf-8?B?a2o1TjZWd2R1K2x6blNvRnRZekxRVjRzTjJuWFhWSXcvZmhNN0RNbWdJSmVP?=
 =?utf-8?B?bTgwaDlIWUVja0hHUTNPbjI1V0FWZ0JiWXhERnpPY3BEUW91Vy9FQ3lxVngx?=
 =?utf-8?B?ak5KbVBiWlZEZTdjckxHVUlqeGJpWWFXZkw2NkNTT3JDOFp1bjR1RWJqQmx3?=
 =?utf-8?B?bkthSjA3aDlQamZ1THJKdjlNTUFGa3Fpc0U3MllqcVJVWWh1REVDRG5pR1F4?=
 =?utf-8?B?RFhnVG1SWXlrOTc4bUg1VkxPU21LVmJ1SlBwQjlrY1ZqSFZsQWdHSERkMUZs?=
 =?utf-8?B?amFrZ29QVkx6WmNVcHc4YzA0RUphSDFac1J2SGk0OElZY3lIVWhXMnN0ZkVU?=
 =?utf-8?B?UU1EbjQzS3g2U2RXNDVaTFA1K2l0SHExTkJwS1FMcjM1Nm55dmljalVoMDhm?=
 =?utf-8?B?TlFNaWpRMWx1WENBbi9KV2IwYTM3OEFkUHQ0NVAraU4yR0NmdDRjNCt0Tmgy?=
 =?utf-8?B?ZFhKajRtWkNreEVtTHE0Tm96T2w1SjRxVzIyWjNwT3JhSGFNQVp5aXNNQ1RM?=
 =?utf-8?B?cUltVzRLcHJ1NVl4dUxoVGdJVlNFNnlOajFCTEZTSXJpY0txZXdGTDhVQ3pm?=
 =?utf-8?B?alJuYVBmWm1hUDBZdCtqOU5YZkRyN2ZVSE9uS0ZoeUNVQVJyR0ROelhOOWNW?=
 =?utf-8?B?akg2eW5QTlBXMUZERFFuNGRzS3I4Q0NUejhNVHZtNjZRNEpyZ25YTm0wWHZP?=
 =?utf-8?B?bVRDakpPTzFSYWVMejVZenMxdmhkTDlUQUpvY0N5QW9wY3lpVm5hVXoyTC80?=
 =?utf-8?B?c0xqT21kbUdWbkdxZWdoSkIvcEVWMVBYMEcrVDNpNDQ0S0NpdXJYQTJiQitO?=
 =?utf-8?B?Zmc5cG12eHB1b1pXd2dEYlJ6eUFOWTVDa0pwZjBjZ2FuSVFDNVc3bHluY0ZW?=
 =?utf-8?B?YnlaQkxxYWJJRkdDZFdtVk1OUFdwVk9lZGxQK204OFZNakxyNnRMRTA3bkxO?=
 =?utf-8?B?YVphay9JRGkyRk8wRVlLdmxMSzhKV0NuSXF3b0RaOUJLc1JFdTA1TlVzeWcy?=
 =?utf-8?B?ZVpmK3NWbnpQYkxnb2FHZFlYemVnM1lXU3RJdGZJUmtQNG9BYnpvZCthNDBB?=
 =?utf-8?B?eDZSa3lMV0kxczNBVUVMVTVZL01jUzhlR1Z1Z3phbkFWRnExRVVQdVV6dU9P?=
 =?utf-8?B?cEtNMTFWcEZ0WDdlRDZXa3YycFhrczJRWkw4eFY0dWFYdUl3ZHFaRUp1azdp?=
 =?utf-8?B?Z3RZNklUWEQwcVhSM2I5dDBLaGFaSzk5cTAyYUFqKy9GM01vZWprblRLTXpN?=
 =?utf-8?B?Q2x2Y2hMcUVBQUZHc1hndWdmRGE4T25HR2ZlOHh5cEVCUTJtTGhEU1RyQWJN?=
 =?utf-8?B?QjNFdWRTd3FwUFdYamRzc0I4K2JoS2JhOVcwNnhFQ0VHdEpiMlJ2Szg2V2tC?=
 =?utf-8?B?SVZmZzhMbEg3U3ExWlQvVFQya3NkcU5JdHVjam42OTVDQ1ZCZVRSRzkvRE1H?=
 =?utf-8?B?OVl6SzhTdENOc1o1Z3pHbDhBNnppTHlDVTdvSTkzdmc0N0t6R1ZCZDh6bWFJ?=
 =?utf-8?B?aHBYblhRdjBzMjdMeDFjUnpjanVhcUJsNmtVaklaTmJBS2t2ZytidUFLZ2M1?=
 =?utf-8?B?UVdkL2p6VG4zMkw0UkdzWmVBWlFFL1pZL2htRjREMkJrR0ZQMjNCd2tjMEti?=
 =?utf-8?B?aHpLYmdXeFJjNm04UHdMSDhMcERqR1RUZGprLy9CcGtJaUE1Z3ZqRGJrYVZK?=
 =?utf-8?B?UHlrWDltS3QzSm5FazRPUWluTEY2Nzg0TTR5Z2JlVFd4YThpOHF3ZkVqRU1B?=
 =?utf-8?B?Y3Q1ODFseGRPVkFKelloNFVFdlVoMTJOZjdnbVBXN3oySjcvYjE4VktXTmJl?=
 =?utf-8?B?UlppMEFVNXJBUmtGaExvbm9NVkU0TW05MUR2Skc2Q0ZzRG5qdmMvbjNqanhl?=
 =?utf-8?B?K3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?WkVOT001cXY1NkhkRG9aQUVCa3hqaXk5ZTZQL3pna2MxZDJ5dTNhT2hqQi9p?=
 =?utf-8?B?VUQzeWlkQW5vNkVTdW54aEtUdC81YVZWNk5JRmp4aUJIQnhKUVpTd2ZxaGty?=
 =?utf-8?B?YzgzYzZzY1F6VFlKSWRORis5cVBEQVVpYWlnb0tmSTNGMEkxajltSXBMOUJ4?=
 =?utf-8?B?bXUreGJPOGlwQkU3U0kxU3JGRHU5eGhIRFNta0pTeWwrY2ZoVkxiU2ord1g3?=
 =?utf-8?B?SEFWQmtuMmp4VkE1U0Y5b2FYbXlWYmhVejAwcVkvRFgwM0ZQV3BmWkpESW1G?=
 =?utf-8?B?b01KNlRSVTFXenRPamxYajFhTzc5azE0Q08zYmczei9iRG1wdzU1TE1TdFpV?=
 =?utf-8?B?WXdPemowM1RSdVNUb1JBT3hBdFVPWUdBcFpsV3BLMnZJM1d3NzdUU2l5b01k?=
 =?utf-8?B?cUFDQ1BTUkxpVzU0cE1TYk5rZWZXYWdidmEyQzdoa3JKQ2Q4bFY4NHVsUWdo?=
 =?utf-8?B?TER5bmZWTDgvSWdFOFpSSGk1ZTdKSnVVb1c4WVg1K1ZZZlFmMDN6WUE5TkdD?=
 =?utf-8?B?SXhtTjhQQWdaMVlaeWFja3llSFRTdEV6MFVYUVoxb1dJeWZ6bkVTcnZ1WTNP?=
 =?utf-8?B?UzZabW1uQ2NsY0k5YkVJaVZ2N3NUcWFZL2k4TEkwZUpqNDVKY3lCcDA0VE81?=
 =?utf-8?B?RlNndkQrbGg2L3gyUkFEYWg3TlRtUGNIc1dud3lxcGdoYnVJY05TWW5YR3hE?=
 =?utf-8?B?UW9qNXcvYnN6dm4yY0tVcVdQRWVNZ1J2Zm93SnBoSGNtNVVlY3ZtRFROdG5Q?=
 =?utf-8?B?bDFQUWJ1SHY4VTlycXdTbFBqbzdHREROdmN4bjR2eTAxRlQwR0pST3BVYlNG?=
 =?utf-8?B?Z0ZpUTdXbGg5TUwxaUk5aWZCcU1jUE1JVExVZDVaQnB5MFpacndpSUo3Mm1z?=
 =?utf-8?B?ZUpOdzc3bWIvcFNnMktxeWhFK0NqOVROd0ZuajUrMHlCVFp5VlNPaWYvRmFk?=
 =?utf-8?B?SStFUVdvVy9BczFZZ0NIa01RcjJqMzFMbnZjQXcxR1NTcHpDRTg2N29rU28y?=
 =?utf-8?B?UUxPdkh1YTZtaGNuWUtrR3RUbE9WWHV3VkxlaFZNYlNSZGJHSzV2NlpoQjFk?=
 =?utf-8?B?UFErUk9WYUpOYzl0VmFLclZCZ1RiSGFtaHZsZjR3YXhBcFhFbjlIVHoyWmJl?=
 =?utf-8?B?TGc3OG5FTitYU1NLSzcvMVV4NC9aY1NzaENXZTlKQVM0WnNSMkNRdGxydlQx?=
 =?utf-8?B?QU5rN2tQSjNPMXRxby9oWWdIdUxqWkdhQ3BBM3hPQnpZVzkzWkc0WDdYR1Ur?=
 =?utf-8?B?cm16a0pUbmR4Vk4zZVhwQU9vL0Fzb3I3ZFJTUUs5U0c5SXBwUT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc11b455-8ff5-477a-cefd-08db8d009148
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 11:16:18.2278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XPR6B6AmjKQU86QVCCeul9+gG5vm5K/+QCfl24Xw6IaRz4fzbBEzRYKbFcm6+G7OvgEbVQORosMB7hASQcYXPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7348
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_06,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307250098
X-Proofpoint-GUID: 8jOIFBtZjOKCYsEnjlaZHbW3lIoHsP4z
X-Proofpoint-ORIG-GUID: 8jOIFBtZjOKCYsEnjlaZHbW3lIoHsP4z
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/07/2023 17:32, Niklas Cassel wrote:
> From: Hannes Reinecke<hare@suse.de>
> 
> Rename __ata_port_probe() to ata_port_probe() and drop the wrapper
> ata_sas_async_probe().
> 
> Signed-off-by: Hannes Reinecke<hare@suse.de>
> Signed-off-by: Niklas Cassel<niklas.cassel@wdc.com>
> Reviewed-by: Jason Yan<yanaijie@huawei.com>

hisi_sas_main.c still has a comment mentioning ata_sas_async_probe() - 
please check that

Apart from that:
Reviewed-by: John Garry <john.g.garry@oracle.com>
