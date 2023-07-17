Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F7F8EB64DC
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Jul 2023 15:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbjGQPnZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Jul 2023 11:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjGQPnY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jul 2023 11:43:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E8FA1
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jul 2023 08:43:21 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36HF0SX6003956;
        Mon, 17 Jul 2023 15:43:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=mA1a29zR8bubnKxyJyXv2Uptb2uVj15HFYXGoSGsubo=;
 b=ZnDHxhz3EIHmKGOGBUKnxGePd/uFTiDn3wRIU4QB7PW1OgSNfT+xUmSqPjPsX4yc5/tz
 Y713wUxC0JPF4l28tqfohuF/PRgSRZGNimmM6ieC3fnTG4PRGNS8fyqiZQ3BYiRvSbgE
 fMgqZzgX8QWS07X2b38YYOyUe1ydjrutmasnrsCelGspUw1HVEhy4FU2GoNOFBixwyUL
 LhtYTXSDpnHcM/tCg+8CHwyng3ndqoXedKqrMV+rjDk1+bro+W5gu/u+6JqLHTHolOy0
 lshECKX1dO6ftxj0RlmwQa1veKLF/flpvG7oEcdsppgB4v2MxVxyn/CPvclTri+dlSAS +g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run76u149-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jul 2023 15:43:12 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36HEQlOL007749;
        Mon, 17 Jul 2023 15:43:11 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw3k28n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jul 2023 15:43:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iFJEZNF32Hou4rLgvGJde8JWpu42wteFCpqYltIA+5w3/PY9Z1hio1m+ax0QP9N3Lw31TPRR7LjyTUYGKK3bzfhGGV9P41xdewNvOiD4yKtWncydjgkUSk8f7LgcBrXUtsNK4s9ULQ84yrtFVV+srANkCR/Ld8uhJTfiOeYSB0mIZ0bbZTYabp8WyDH9rIM7pieRXmUf9Md6u+OR8VjaERyRMKoN0oDpChljEh72Wt9lLJe3kliuTJUaMtFXgwBKB8BHMtKYppnCQ9YYPc8c1t2iMfrAIARqLHuuPt8W0a3WU9pFIIcIUJJ+mE1e/4ruGeVzTuWSQYYemVh0gCfgPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mA1a29zR8bubnKxyJyXv2Uptb2uVj15HFYXGoSGsubo=;
 b=YJBIPl3U3stFX3BuX6Uf7jDBf4f9/Q2uSRI65xI5YLFj9iBh5xo5AnaBSInskLaVKgfBY900TIjEzvu6NmWgiMU36Wrf3Ss9ieEealPuFN8Lq2+g5sS5foG3/VJR5jr432KWqcEdEuA7PLN8c8pC+VfGneteKtRLLMxUSvAOtZdAakDCyS32BAZSnqvMBoj4iDZwPV+n/k8uDhNMQ7IoHz/cBDuOhmdA6yhuZCKbgrk8kSfzFWR3+zhuLNP6fbIZsrBCOQcGxCZKz4TFutvue8oyUH6aVdP7eZWj3UU5Cc/xItmL60pd2od7saF8jvxe8tqyQDjkPfMxGhPFemigkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mA1a29zR8bubnKxyJyXv2Uptb2uVj15HFYXGoSGsubo=;
 b=gGdEyPWoI55pWfQ1pM7F4950VcjSP/X4WAUXOn+yyCqI6PbXugX1muSPyZVXDif2TA1VZaU5qSONJTM897HHQQYnzq39Ml91vwiWCbI9MVH5SkEHolKjIadSt/0Q9ejIfzTYyss6rakwnA2mKR7rCB54UASz6PtzzLiDN9q1b1k=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB7428.namprd10.prod.outlook.com (2603:10b6:8:190::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Mon, 17 Jul
 2023 15:43:09 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb%7]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 15:43:09 +0000
Message-ID: <4c1252ca-0391-869a-2018-986e685f3611@oracle.com>
Date:   Mon, 17 Jul 2023 16:43:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 07/33] scsi: sd: Have scsi-ml retry read_capacity_16
 errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-8-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-8-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0239.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:350::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB7428:EE_
X-MS-Office365-Filtering-Correlation-Id: 636e4b5c-d97b-4a55-bb59-08db86dc8541
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: phUPwDERG82IIQQslX0VaCt61EImrci4G2PvRSQmsSx2qwdul0AE/sdTkdhSju7Teutk+QRHTXU4hul11aJgE5nF9JcQgoRGiOLXSRcwfZkitB/nfsBRfxh3M1XNdXTrkRHewrKJehA9G9UX0gxre/vjwCuD0JAVoXzAeSs9uoFEhF1sTXyMFENJ8YVdeAN3Kx+jWrgxIrmsYHCliaH2D0CdWDpa2uJKJbj1SvPn1UZUi9x3PA1pP6ywDAkAVNSM0AzbBH1GW9aroH30nFpiY5jz6EZ82MEslEW4F88n7N2m8zx/lk14lxVk3i/SNHqcYuUsRKoPLXYk6wmHT8p2PCmJ3PrWX2otejxvGy9CsTtsQEEg64l7fja8CxCcc7JryGov0Q05vwBn+7TwOhM/2nyts+ENEQNTULHTO1YfykpksAVw4nQqyfPfTC1ZMvM0UGTltQ4wb62OqB0RzTGRWiGw8LXSAvWBKuVNmuSy9LeeA1t1f/fziNrdt6cDzlfbwxgYXpvunortOX6BIHXxMp+TU43DsQjY5Dna4ZeVXCuGhiEKYzGaMyj5FZSIWcvC0EcAYjYcTNUQ08zeMGIUY1Y5DDBN6Ip7Vo6G1WdOfjmRgP0x+GYFmo8vp11aqIooGD53d5fEKbYW1IvKUeZ9Kg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(396003)(39860400002)(346002)(136003)(451199021)(31686004)(478600001)(36916002)(6486002)(6666004)(83380400001)(31696002)(86362001)(2906002)(53546011)(186003)(36756003)(6506007)(6512007)(2616005)(316002)(26005)(66556008)(38100700002)(66476007)(66946007)(41300700001)(8676002)(8936002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1Z1SjdhN3VWWGJzb0V4REYrekZIcmwzd0tnUHY3MVFiQlhhK3krODNhRXgz?=
 =?utf-8?B?QnFVM3N6eWNYMEtvN1RuZnEwMStPaHBWZitoSktWcVBLdkxyWVVmTUtkbmxa?=
 =?utf-8?B?MHdVZkRoUDFnZnMrN1FYL1dtclVONTVvY3VHNldWR2tjRE5BbmtNTUdqaWpr?=
 =?utf-8?B?eWFJNDM0WlRvVXMvQWI2R1lmQ2swNFBIVXNMckU0V0I5VVQ4MnZSejNMWDEy?=
 =?utf-8?B?a1NpUnR3N2hWaTg1NHlLMFpJbVBxL2xSNlZaT2VOVGNLWVlFTUVOSHhvbWxM?=
 =?utf-8?B?NC9DNGVzbExNdWNsWUpOOGxjV2xZa29rQ2s5ZFkxalVJV1NPMjlGSFUwMzIz?=
 =?utf-8?B?bnpCOXVkV0o3b2g0L2g5RXZWVnRkMjNFL25uUERQUkZEMWFnbkVjbHdPZ0du?=
 =?utf-8?B?MDMxb1BXQUdqdHptVzlkTWt2Tnd2UHZBbmhSSTl4MXhWTEJVQ2F5UFE4ODZL?=
 =?utf-8?B?ZzdVRG8zWWg0cFIxYTZQK2czZEw5SXZEZFk4Q3M2U2xCS1N0QVhpUVY4OU0x?=
 =?utf-8?B?U2tKQTZNL3dlNG42cHNBQ0Vyc2pIbVJqVXV4WFczcjEwdnFxc0tZN3UwSHRE?=
 =?utf-8?B?VWtzcWQwVDZsZlNMVWdoVzlSRHBXSDBxbVl0U05ONlhIRWsxeFl2SFZiQ1Z4?=
 =?utf-8?B?WXZsNVhpaFQyVzN0cW9iSVV0ME5mUE5ZRGhaOHRrQ2hpMUo4QVFhN0R6L1ZG?=
 =?utf-8?B?RmZFbXJtRmZHSUVXZitRenR4bDgxMkFYWW1HYmZZaG5xYldIdWtNaFdXU3BC?=
 =?utf-8?B?ajh6a2ZkdDNvbG9XdldVM3IraDFvT0laRHl2dzA4WnNGRElQZXpMTmw2WWRv?=
 =?utf-8?B?R3lnSnpBZGRnOWtrRFdreFZVd2xKTFZYcGR0SzVaZ2R0T1hYamVReU5XUjhZ?=
 =?utf-8?B?NDhDWkxFTHFRMVFmQzhEOUZBenlnaVk4V1d2VnNXUjhHOGlwelFQbVBBK1Zk?=
 =?utf-8?B?TGJZVnJuY1dhcHkvaW5PNFVSa0ZQVmRnWjU0V0lNOW1QK3ZadU1xN1JOdDBN?=
 =?utf-8?B?cTY0MDR2RFM0bVE5bnNFekgyd0YxTHRxU3MydHh4YWNheEZseU02aXlya0Z3?=
 =?utf-8?B?Vk9JV2pEcFdFbmV2OHdUeTQxbk90VlRMN0FzajE3WG1jQUoweFJzRU1obThP?=
 =?utf-8?B?YVdnVkZmelNmak1aNitjZjNNbHk3WkJzbkFBeUdGUnJYL2Y0aHRIRW9pd0Fv?=
 =?utf-8?B?eTVZazVUZEVsaHRKbmtuaWRjMlkrdXlpT2tjUXN5NmcrODRKZ3JuMU5IMnN1?=
 =?utf-8?B?RHZ1UWdpKzFBT2RiVUEvWDJYeS9mUm9tRFR0WnVJVU9abEFOWGlNRURaaU1o?=
 =?utf-8?B?OHB2UHUrajVBNFRtUWl0bkF0cVlqNGgrdThRVGZMNmNNRHp5a1d2SGF0NWYv?=
 =?utf-8?B?MTQwdVNGMUhmT3NlWnFHTmNjdURrbnBQNnRpSGI5T2VZVGVWdGNYRlo1blI0?=
 =?utf-8?B?bGNHYVh0Q2FlaGlMNlBzYjh2R3p4RnJqZjZncW1GSlh5NnFkcmE5UkFPQTdV?=
 =?utf-8?B?cGx5MnkyaXZTREExZUZvS2MxMnVuTkc1ZW9JdW5ZY1Bxek5aVDMrWGpIaXpJ?=
 =?utf-8?B?dTlCYlVVeHg0aXFrYWNUS3FHVVRYWEs4cUN5M0NlZnkvSmhibFBCK2IvcURV?=
 =?utf-8?B?SmIzMUZRY0ZhYVpXdVFhSDRtMEFoa2tyTTV1a3NpdUs3R1I5U3RhK1A4NWRx?=
 =?utf-8?B?bVhlUDhmanh3MkMwWGlRWjFZZVA1OFpxZGc3R3ZQVVFmQndkUFBLZ3MxM05n?=
 =?utf-8?B?VmUvTDJsWTNUNnRtM0tFb3hWRVVoaTFpRldFd3dUckpIUlhrd1BvUlk5cE41?=
 =?utf-8?B?RytCaFI5YUpYVmJ4UG50RW9jQ25QSWlOOG81VXNhbGl0T2NxTjAzM2tBTXZ1?=
 =?utf-8?B?YWRSUzRZT3preXgwM0NmTWNyT1VPc1B0cHY2amxuaVNHTTBqTnJFcllHbWlj?=
 =?utf-8?B?VFhqdG5wdlpKUVRGQW10SVdCVmxvNGplOUt3cnJHS3c1TVlrOUY2dmZHblV3?=
 =?utf-8?B?aTBNWjBieXVONEtoQTAwcE1GalVoMVk5cHdvWU9mNXl6bXY2eGo4Rml6MVR3?=
 =?utf-8?B?QTdBaytrTWdjSEJnb1BnaThlMGoxZUZGRnUrdFBmYkNaMlRoZlIzTUtjSUNU?=
 =?utf-8?B?c2ZYNVNqK3JrdnNFNlRpR2E4OEdvQy85bXc1Q1hxYUVqWnpJbFlHN1RvRDVj?=
 =?utf-8?B?UXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: s+dI+RgSX91i3zuM9W002ccAxblb5WfoklAHzpwUQY1NHiDNwkjJqQuDMMtWIWBa1zy1WDmHtX9VNqLAej4ZFmCv4mMCaHrE1tJ8fgIlXKsvhehS8c7YxyMAK6xVVzcMedL5kp3/fzwYPkgZoSGUoYCG9DlfHi/xBJL17tOl3KYbmLN3iCQEQR0YrokDlK5aU7UhQtaO7qaBCzb6X+8fRmX85N5l1ss8CgR1NF14We/Nl6C8UEsuoQKJxwe5DttBsk7K/YvHWAM4WNERLl9LgKCEKFLmMs0FzwZrJ74Zb1r/eliLE/6pSvki3w5rYm6OIGVxEbHogXrqYaG4f/nXI0wADwe69i6ksWyOQLdNj2GmysqVrDqYx6NdGVqvyGK4uCRZsm8JwKHEnSIKQmkwMxC7PtA1df2k9L6PvYSAitwa+vK0r/3VdRum82GtKZPrmdyt1K+P/9hyWIrNQ6ewFxoszj9jXAxi9BzcAR+7H2Wig17D8+89cE30UK7RV8Ko76ssbMFN5W4YaQDWoC4udv57hpVjWZ+b3JnMcAGrX52EngGSo+wPs3UG4csC3G6Ttf9aFgzfoczh9XhMlut5GEpQbCxAC3tV7ALcM1gqD71zNsta4kAuy8NdfgsjqmpLZxMVRLNkdzYXqrkAq8gTX1oBmj9e/PiT/inAepyhPs6jsg97v04HCuBl4veOVWBQhrktOZLZo4QpVdmqRi9i9Kup+zfv+I88F9Dk4Swbj2rbo8dTiJzFTvVSqg5+vEpWamW4FpAAuekXZ6afoWqBkhSyuPCwC5JsGTSbeplAEaryujdRt/A11OE8arKgq+AK5aen+1E78AX7b8OLnTKcnZIeYrqFZb6EJH2VZvbmIXvQnDEnJK8o02hKOjUbuLG6
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 636e4b5c-d97b-4a55-bb59-08db86dc8541
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 15:43:09.1999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VzwiQw/KmSQ7Cotyozzudr6tUNXtO4H0gH/HKxfUfCNBzAWtfQEDSoPcHwR54goxaeEPAXeoNTFs61GDyHHBUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7428
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-17_12,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307170143
X-Proofpoint-GUID: ebRNOHq-q8c1CROA2V4ef2ifojxnSUR2
X-Proofpoint-ORIG-GUID: ebRNOHq-q8c1CROA2V4ef2ifojxnSUR2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2023 22:33, Mike Christie wrote:
> This has read_capacity_16 have scsi-ml retry errors instead of driving
> them itself.
> 
> There are 2 behavior changes with this patch:
> 1. There is one behavior change where we no longer retry when
> scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
> for failures like the queue being removed, and for the case where there
> are no tags/reqs since the block layer waits/retries for us. For possible
> memory allocation failures from blk_rq_map_kern we use GFP_NOIO, so
> retrying will probably not help.
> 2. For the specific UAs we checked for and retried, we would get
> READ_CAPACITY_RETRIES_ON_RESET retries plus whatever retries were left
> from the loop's retries. Each UA now gets READ_CAPACITY_RETRIES_ON_RESET
> reties, and the other errors (not including medium not present) get up
> to 3 retries.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Regardless of a couple of nitpicks, below:

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/sd.c | 106 ++++++++++++++++++++++++++++++----------------
>   1 file changed, 69 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 755b09beff2a..245419fe9358 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2402,55 +2402,87 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
>   static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>   						unsigned char *buffer)
>   {
> -	unsigned char cmd[16];
> +	static const u8 cmd[16] = { SERVICE_ACTION_IN_16, SAI_READ_CAPACITY_16,
> +				    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, RC16_LEN };

In terms of coding style, could you follow previous style, like:
	static const u8 cmd[16] = {
		[0] = SERVICE_ACTION_IN_16,
		[1] = SAI_READ_CAPACITY_16,
		[13] = RC16_LEN,
	};
	
Seems safe to me (to ensure we fill in the correct array element).

>   	struct scsi_sense_hdr sshdr;
> -	const struct scsi_exec_args exec_args = {
> -		.sshdr = &sshdr,
> -	};
>   	int sense_valid = 0;
>   	int the_result;
> -	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
>   	unsigned int alignment;
>   	unsigned long long lba;
>   	unsigned sector_size;
> +	struct scsi_failure failures[] = {
> +		/*
> +		 * Fail immediately for Invalid Command Operation Code or
> +		 * Invalid Field in CDB.
> +		 */
> +		{
> +			.sense = ILLEGAL_REQUEST,
> +			.asc = 0x20,
> +			.allowed = 0,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		{
> +			.sense = ILLEGAL_REQUEST,
> +			.asc = 0x24,
> +			.allowed = 0,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		/* Fail immediately for Medium Not Present */
> +		{
> +			.sense = UNIT_ATTENTION,
> +			.asc = 0x3A,
> +			.allowed = 0,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		{
> +			.sense = NOT_READY,
> +			.asc = 0x3A,
> +			.ascq = 0x0,
> +			.allowed = 0,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		{
> +			.sense = UNIT_ATTENTION,
> +			.asc = 0x29,
> +			/* Device reset might occur several times */
> +			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		/* Any other error not listed above retry */
> +		{
> +			.result = SCMD_FAILURE_RESULT_ANY,
> +			.allowed = 3,
> +		},
> +		{}
> +	};
> +	const struct scsi_exec_args exec_args = {
> +		.sshdr = &sshdr,
> +		.failures = failures,
> +	};
>   
>   	if (sdp->no_read_capacity_16)
>   		return -EINVAL;
>   
> -	do {
> -		memset(cmd, 0, 16);
> -		cmd[0] = SERVICE_ACTION_IN_16;
> -		cmd[1] = SAI_READ_CAPACITY_16;
> -		cmd[13] = RC16_LEN;
> -		memset(buffer, 0, RC16_LEN);
> -
> -		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
> -					      buffer, RC16_LEN, SD_TIMEOUT,
> -					      sdkp->max_retries, &exec_args);
> -		if (the_result > 0) {
> -			if (media_not_present(sdkp, &sshdr))
> -				return -ENODEV;
> +	memset(buffer, 0, RC16_LEN);
>   
> -			sense_valid = scsi_sense_valid(&sshdr);
> -			if (sense_valid &&
> -			    sshdr.sense_key == ILLEGAL_REQUEST &&
> -			    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
> -			    sshdr.ascq == 0x00)
> -				/* Invalid Command Operation Code or
> -				 * Invalid Field in CDB, just retry
> -				 * silently with RC10 */
> -				return -EINVAL;
> -			if (sense_valid &&
> -			    sshdr.sense_key == UNIT_ATTENTION &&
> -			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
> -				/* Device reset might occur several times,
> -				 * give it one more chance */
> -				if (--reset_retries > 0)
> -					continue;
> -		}
> -		retries--;
> +	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
> +				      RC16_LEN, SD_TIMEOUT, sdkp->max_retries,
> +				      &exec_args);
>   
> -	} while (the_result && retries);
> +	if (the_result > 0) {
> +		if (media_not_present(sdkp, &sshdr))
> +			return -ENODEV;
> +
> +		sense_valid = scsi_sense_valid(&sshdr);
> +		if (sense_valid && sshdr.sense_key == ILLEGAL_REQUEST &&
> +		    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
> +		     sshdr.ascq == 0x00)
> +			/*
> +			 * Invalid Command Operation Code or Invalid Field in
> +			 * CDB, just retry silently with RC10
> +			 */
> +			return -EINVAL;


nit: personally I would use {} here, like below, but that's your choice.


  (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
		     sshdr.ascq == 0x00) {
			/*
			 * Invalid Command Operation Code or Invalid Field in
			 * CDB, just retry silently with RC10
			 */
			return -EINVAL;
}

> +	}
>   
>   	if (the_result) {
>   		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);

