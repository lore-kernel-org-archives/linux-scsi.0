Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C10C197A0
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Nov 2023 11:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjKPLC5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Nov 2023 06:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjKPLC4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2023 06:02:56 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA88F85
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2023 03:02:53 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AGAsDQ1025688;
        Thu, 16 Nov 2023 11:02:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=oRVJhLiBSXC0BFoztnwT5JXFlfqinVlFFmEiM3BHQAw=;
 b=v6KSoyIvAuKnX+e2d1yTpygN37mqTG/mstEoGKiZeky6AxRXAe4zU/bVUdeVBaRxu2j9
 aRFrRWMP52rPyQWehVkXtJlQbD2+yqSTI2k5hMkfz9Xhto7yFJD+aQnf1AbjHFr91H+j
 6nenC5CHDUVdahYOps5eHN6ynvQ6UHKGsdLzlmUl4q2j4y+vsZKT1jEs+SPCR42bxS4+
 83SfZuitDzUxbe+ksuZrfGVvbhsE8fZXKIgSKjawbZufIrkKXfwu2dfLDTf0dz8QXGH2
 fZ1sXB6CTDLYZjhUt5StXUCAAeHlr4E/bNKYWd4A5iTV1wafDRlgYLjNyRJZdeTSjFpR XQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2na2t1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Nov 2023 11:02:46 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AG9balb035425;
        Thu, 16 Nov 2023 11:02:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxq2ne63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Nov 2023 11:02:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ia4rH1hjhwFOOu+ha1P+PY+cLyapTs5PeRW7GAqq3qXfrWsOhFcVvdmo/26O4BfaCmAsYlW9rgblzelMaOqE66qJgt8rhEyMGwfRFkJ6fmrz3b5JHedVnNLLEvlssyzLW8UVBcAFIdZV6pVHEQ57RyqOVSaU+rroiKXpsMgUxaYffwTjnj5t24T8vztErbC2JWyG1Gs8SoAZNMd6mKAcjXLsKnVPSxN6MY0r5Qi+1i5NsNT2kWj2V8WxPNcGfjbW2ND6DvAFhDVtBUeg57voFaEDoT3t+6WcoUxSOvfBErunqB4kIMIY3pxYx7v0HLiSjAVG2A0VmdiI4Wq/70rXMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oRVJhLiBSXC0BFoztnwT5JXFlfqinVlFFmEiM3BHQAw=;
 b=ZSzmvyAeM+WaCP4JsMzGoQ730LYvaxn0RpOrYTMAC3j1vVaXI/l55Xi/chsV8sjZ6eW1S5UvnV2QCt8Sy9oMEBplJDFn6nYpMMXe3zuWh5uhJDJrI5lGZ5Nu5jTv9aX5dbvPBNG/hmGRbOaimlIv1jnP0HWVIw7zsgLwno2WJMvoLHD+XPojQBKRz2CYt7eNcRhcBCIYnr/jO/V9X56daowMZKPSETV49tKs4V+sNLz4QsbAF/7CYHgoftJO5h+BUoFEOPb3AWJCGj39nx6wrd3sb+3x9pxuf8BBb4nBKlVOTEC6/mgspx8JzRr9EcPWUy+ruRfleLlDUddoGylO9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oRVJhLiBSXC0BFoztnwT5JXFlfqinVlFFmEiM3BHQAw=;
 b=U5/I1XuEyZROIMCr7TM1dU0D6kc9X8PA4xndfg+fOuw4h6UjK2HilZi4yxmqxQPElSH+x2Q/8qQBXWYBEh126hKja+Pfr6YtTrJl5jZKB10enDv3ze1/6iz/iKdEt/yjEBcUVZxGzQIWuzBkswd8eMRUrNbQ3rUIgG1GIwusXxc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SN7PR10MB7031.namprd10.prod.outlook.com (2603:10b6:806:347::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Thu, 16 Nov
 2023 11:02:43 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::102a:f31:30c6:3187]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::102a:f31:30c6:3187%4]) with mapi id 15.20.7002.021; Thu, 16 Nov 2023
 11:02:43 +0000
Message-ID: <0b3a1520-1fdf-4f6e-97d2-fdbc47fed039@oracle.com>
Date:   Thu, 16 Nov 2023 11:02:40 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 00/20] scsi: Allow scsi_execute users to request
 retries
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20231114013750.76609-1-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0363.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SN7PR10MB7031:EE_
X-MS-Office365-Filtering-Correlation-Id: b26b1366-21e8-4887-c396-08dbe6938ee2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JfGfgS+mPVuUCBRaWls9i3QYiiKEOLRS84L1o8PmvMi4/fSXvDN4NCz9wx886mBeObvO6UIGKG5LzhLXKU7Ry8Mt7B+TmHdOxR+ROn2Zd9MqwLljF07DA7vkJjwil8iuB1e6I+GerE19Dc1fFt6fIfnkk2keG4DrX+kyO6utvCbRq9aVhNHYVy8VPqnpw4w9ka9OTmYKDTudrH6rVaKOPgTIQ0I7F9Y0SJm0vOKFeSAGcQmMhnWYIOEYKwaqDoXbTPgilLZEo7OwK6OXNZnqgX0/doPuLg3ZfyBLq8cEUBLJtVBUH8ndtb2D3+V9C/DuV4b4l9hFWxDwkLtEjV6KDMYJBP+An+OIVCKRIi8GMiuFqNP/6kT9ot+LO9Q4fhWLK/5BQzJLQFc18oJ5smMPTdhkIhfSiSDbgLiMMQaRUnJGkC+qIUbno3M1A20a9pejM1AxBAYCgMeyB1+ZMwO5GOPIuAiPEdAoIC/pl6FIJOEj097N6b5j+h+dXRlbDiz9J2gaKstWd5IEVn8z8VAJOGKXJNx+tUWdXqvUwvEK9RWnSN2e+XVYiY9YNXdH5pxKxpUa/Eu46dhy0etBZ+6rY1xz0VVID/NJ4rWcbh3yEGz/PyxM27QmwpOqneBwSINj/IO2E5XAeYfYSCy6n636sA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(346002)(136003)(39860400002)(396003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(66476007)(31686004)(5660300002)(6512007)(26005)(66556008)(41300700001)(66946007)(36756003)(8676002)(316002)(2906002)(8936002)(2616005)(53546011)(6506007)(478600001)(6486002)(31696002)(36916002)(86362001)(558084003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjlUZCtjK2NPR1VCZ09TOFpqT0FhdWlmVkhURzYwY1dRbGZmdFg0V3BUN2N4?=
 =?utf-8?B?QkVhSXZXS3hXS0VBc0NJb25XTnozQ0FCbWVTRnE1Z01qL3RGYzBKc2pXaFV4?=
 =?utf-8?B?WStvbDVqcEVKSlQ4ME52V0xtWGt0dlRRQStGUTJra0dvcDZnUWFJTCtyTy9G?=
 =?utf-8?B?S3RTM0l2TkJjU1ZXeXVHSEMrVDk2TThOUy9GSzh0Yk1JZGhoelFyclh2cXor?=
 =?utf-8?B?RFBuM1NUWGl4Z1BXblBpMHRTUXJWUFV5YlBWd3kvOXhFWG43dStSei91RFVm?=
 =?utf-8?B?UHRBTjVpNGRhVzQxYzlzMTdhZ0xUWWRPZ1BNNmRaQkdmL0YwMk1EM1BKbStj?=
 =?utf-8?B?R2IraGJsRm1ISjdpQTQ0NUlzdUp4bzQzN1VBQnY0MWFQVU4zbjZZUnFQaVNs?=
 =?utf-8?B?aDlmZXRNMVFCTy92ZFk2TWo2aTF6UWVpWkM3dXA1dnBHYlNvUjl3QXlUMkd0?=
 =?utf-8?B?ak54YllGV0dLdUcvc3pmd1dIYUVkOVhOZ093MGJKUWZ4aVNBTzlWVG1IZEhi?=
 =?utf-8?B?SzBFdy9QeG1aSUJpUVNzOXNucm9wNVhMc1VSekJralF5OUFob1lhdTNFd1Ez?=
 =?utf-8?B?SWE3aElTVENxTWFGNkF0NXlNRDRRRlgzV3g2S2JRd0h0YXc2TXljN3ArTVJZ?=
 =?utf-8?B?KzZJN2hyNG8vWXhXNm8ramhQLzZaYTVGNTNEN2FON3JWYk5hYmZNVkU5c2Y3?=
 =?utf-8?B?SjVWc2kzdGpNUHlFdk4rYWJKazI4VEFsekorZEs3aklseWFQZ3A0RS9Hamcr?=
 =?utf-8?B?NndjOXlVVWFGS0dXNk9pNmFKcU4xbTFzbmhweXBxcEVKSzM1RGVmVmpPYlhm?=
 =?utf-8?B?NGFUbi9XNDFYZDVLcHRWdVhlemlyeHg1WGlocHRRbCtQZWJLdThBU0Z6cE1B?=
 =?utf-8?B?Vkhxdnp0RUJjZ1g0bE5GNlFkN3lFK1BIR3ZEenJ4aEk1SDhYN0VIT29DM0Nr?=
 =?utf-8?B?ZXB3RkVuRytZeDd2Nk56S0s5dVFLTnFFRDc0Q00wbHg4WmkvdkdSQWkvenVB?=
 =?utf-8?B?RmRlSjZJaXppR3pFcnJjazNkOXFjbmRMZmwwcE14QUpXYWFHQUhka1k0ajM0?=
 =?utf-8?B?WlpBdXMvQ3hRd1FVaXdtdGtUNWpyRDVTd3ZacFE4YVExcUR3TU9ib1dmRjc3?=
 =?utf-8?B?aVlLMnRaZXk2dElnNFE5TFpaZTlqWmprd1ZUNEJSdldhU3JjWWI4bmNuUEV6?=
 =?utf-8?B?bkJ3TmhKTktMVHJlTENRcXJMYlRpZWdzWlQvcDB4WWdRY0ZxeGNGUXZoTXhS?=
 =?utf-8?B?OXZyZnFRb1J2YXpVdi9tRkRXVm9XZUZMUUtYaExtTDVCaXN6MnYzTkFKL3ZP?=
 =?utf-8?B?cms2eG1HazVtSEk0d3JRNGo5ZmVzcDRPdzc5bjVoeWxNRkNYTDQ4VEt3UUgy?=
 =?utf-8?B?b055UWw5d3JTQVVZbERXaUtIZUpDYUk4Vm1xYzZqN0x3SUtPZVJ5NnBQMy9C?=
 =?utf-8?B?aXZwUDZTQnI2UGhHWFNhQ0J1T3R6YXFVQlAxcURJVEdSRGlQWi9MNTFTV3My?=
 =?utf-8?B?aXZQSHNaYnk1emxFeUZqZittRHIyLzFrUUo0SHFBc0dsZEJHb25uVlp5K0tI?=
 =?utf-8?B?dG9Lb2llVDNmTUg4YmQyREF2RTNLQnJzL3V5QmJ0YklrMXNyN0s0aHphZDhs?=
 =?utf-8?B?WHQ5SmpidTJrRGpIMDdXcFlOd1hFaHF3SjBqUy9hWUFpelZHYXdOVEg3SXJ3?=
 =?utf-8?B?NUF0aXptNE5JN0cvUE8zcXZJTkd2Qk9TbFEzMk1OV1Q1dVMzRVpkUVNsb2tp?=
 =?utf-8?B?cE1URkU1UDZSVWJkUjMrbm1acENUdDg3ZWNndFpINjN2UHJsc1A3Q1FTakpC?=
 =?utf-8?B?aFR0dE15dHdaUHczazNhaUZJS1hrSzFqTjVaN1VnVWc5ZDVuczBhWkNKdTVI?=
 =?utf-8?B?WTI5bzdyalB4cnI1c2JmSDVWbXkyVnR2QjgvdGJNK2w4M0tVeW41cEh2ZkZk?=
 =?utf-8?B?ZWZxQlRwdlhXREl5M2lXcHN0UHNhTXZqaWpwYjNpdVpKbGVrcTNrcWRsSHZt?=
 =?utf-8?B?dXhocDV6K21uUlBsK3ZZdlhweUNTK1VJWlFuZWxjTVhNNDQvdGRFZFNIalM2?=
 =?utf-8?B?Q3lyYVk5RnlPeHc4VU53d3lXcDVYVzNoTE41NHpvc0FNWVhJU28vczBSZ3JI?=
 =?utf-8?Q?sm2Hu21XmbyJIBvLHPX/2aRlp?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ZE13jzZviBuuC/HUQ79AP3ohOtrsABM3tFY0BV4TO/1KxiX7IR9rMQ1sRjr36iQaxIYvEiqqqIChxTTtT0tNutGx+yHtNqdToRvEBnxLdCmoXY/rxh8rWWLhI5mLPGACZ5e1jkdGFq1C/AzXhwJWfVen+UBgok3hYwTU6aqd2RseBTRQ5swQrKJF7r9638N6XHxvmTcCUTcEa3jYfomRrr4Wsft1x92+WEYhgwENzDVQtqpdPVqeXmkfR3IGciv1QRLCtgRGEgvfeiEbcNnKFiSRqVsD7aev5VNrC1WElCcaVMkNeU0/acnBBdvcJpaWAjw+wVuejgLjXirzKx/W/FSp1yME41YBfRSmsBisHLODARQiKNq1TGlY8Dl/Do4xSY0Vs0tcscjILUowGYYgZoKUiHNU/nmBY1TABu/1YOvahyH8JvLY47wPkWQ+Llx/93kPxspeCYqf5eoPu8TOkewda6zdGmK2GV6sWflSNd2vOV57Rmi+8dPbXz2HGStqAahrPl3C20SI2O8ndUN9Lc4P4df2vPoQmO3gfWn9w2ioLOV38dQcSxr4gh5doTKcUV9l2IjVdMVzN3GkG23ISLmRE81WKlqWsI/cmixvLYkWDw7h5oeQGlWE9Zf46x7cS4EgQmE+ag4DHNgMPketvxTESZnX7lWMRPa4g9PvvwJwWah4WqN4bStw+7aDEe5fxlHeiTwdKV2IsyGZ6vqTkJtFWmuqHw1Kund1hUz6DXqa4c9rmctrQQZ0DuYoxEvrPn4RUq8MbdokxzUhQBT4keapln4ZMgiiM2u1XRbPnO7XDTw5KnrJFmWWtc/HiWcICJkpGkDLSaKCeCIqjfndwF1WEbOHNjZPqXSfUXwiTknueu+2Gl6d5J7bDB5hd5aP2/5wkJmlPG65UlNULCmq0g==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b26b1366-21e8-4887-c396-08dbe6938ee2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2023 11:02:43.7320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7JEW9hVfdI3HZ4jmNPolr83kgA7c1YbXS9DQA437nygNxUD/Ml0Fme0A+aPTKG3xwt3pfuRs3E8WrGfW4XLQgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7031
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_09,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311160088
X-Proofpoint-GUID: 4aUqms7wHYYgxTVTdrTvrh93wNiQMwOT
X-Proofpoint-ORIG-GUID: 4aUqms7wHYYgxTVTdrTvrh93wNiQMwOT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/11/2023 01:37, Mike Christie wrote:
> The following patches were made over Martin's 6.7 staging branch
> which contains a sd change that this patch requires.

Hi Mike,

It would be nice if we could apply to 6.8 staging - was the sd.c change 
not in v6.7-rc1?

Cheers,
John
