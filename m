Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25CFBC7EE2D
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 12:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbjFEMf0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 08:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbjFEMfU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 08:35:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C891B6;
        Mon,  5 Jun 2023 05:34:58 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 355BbvXG020567;
        Mon, 5 Jun 2023 12:34:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=vLvvg40EEq6ug+TUpQhnbyf97gzZ4loCjtLV/ayFNUk=;
 b=kq3Yngp9T6jGoYvdWH+2SWxgGKgd6KTjT1aRfTZz04RVKVVM5nh9kwtLxbk6BABlVy8I
 UhmESWzKb0QoyuZD9ILwMpD9MzC+gsie8mm4lU6eju32fE0ELu6LZ7ZwFpFT/Qbgxy+3
 Q1kImHflHpZ57K8ddYhV2mm1gwdDWkr7Cfi2tNFxrLvZtmudt4PYZueeMbJqLj3yX0RU
 tkJ/AYTWW65G8GDalUf0QfiUKEXRCcA0TxgIsaBvKUYJQIfKrFltcWAd+ALay56AAzLz
 dZ0NUx2k3IS02Ddo5Iz+QKbii4WX873qaZiIQLuvvGOurlGGCIhfgWNOot2wey65buEI Ww== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx2wjudb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Jun 2023 12:34:09 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 355C4ivN023651;
        Mon, 5 Jun 2023 12:33:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tq7nvuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Jun 2023 12:33:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DH0OKrvaAzNCe98xMsWeea+oNO4k2JYcjzES8S5TIjrMCFIhwnlmSMeXmkwk2OtFCJnusyT/n3yxTEPFndEADIPJ7dhi+oV/PUJHnuMCsy4U85apCU24lPCuZhrwmoeqEw7R0eH4k7ip0CvW9FiwhENbXJyiD3di2dsEVVNYpSA8gpLIMbAXa2FH2YsNA+zJhsg8ax7NztTXcnyQHcHoZQJTEsdYEe22fuyyn5ingUK5H3e3Y8pZ9IIoRSfOwuuPGHAOCoxpcKwZH3twZcwX5UVPeOOKndPJqlu4YwZ/w5N9GkkUhZdmdCr6uL/O9qJTZzr06D3UiT31MhPCOPV0FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLvvg40EEq6ug+TUpQhnbyf97gzZ4loCjtLV/ayFNUk=;
 b=EbybVLbC2beaGH2b+BBty7nSHo/HutaHNAiaApESAqnPJub8E/IC/4brYLdOSEn3bVDNsrYRQChaoLYZVYpuNNfbhkk6TJL6jp2zpO6ps2szniUR3VG57SwzwznerW4+BL9Qjo5eZlNMkY6LG9BXQQrXYNy70VQR9iKCyNTQtf4A9/taDubT5EytAvAYxLkvEkXEKkDPiLqheOYmYVEhsEApWOSWPMeTdBcV5C0C0+JhdeMGMzGYyxl81LF/owwDmUGDuL21dBZqIfmyNZbiSOnuFkHOd+I0lUwR/isTKES6nx00XHaJgOyYdQA82YF/NHjwSgIQ492UaMxIe5ldDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLvvg40EEq6ug+TUpQhnbyf97gzZ4loCjtLV/ayFNUk=;
 b=LhgaVt7bbLWfznZOXl7pPHFqzXQBBu4k/H1dJsBphc1p/tnEKgiGUoazsAHpejprsjy3XFDCt6M440bwfMEZefgICk/DrpjiyaA2ecO2aOA3WrdvLCVz9YjZ495gSr4VTtYMjcab10oiyrMGwhIH5xJ7IMSUpiurgK/pa3IEpJc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB7133.namprd10.prod.outlook.com (2603:10b6:208:400::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 12:33:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::acef:9a5e:9d29:17c2]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::acef:9a5e:9d29:17c2%6]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 12:33:38 +0000
Message-ID: <515d98d1-c0e6-ad2f-292e-e80e7b40368c@oracle.com>
Date:   Mon, 5 Jun 2023 13:33:28 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 2/3] ata: libata-eh: Use ata_ncq_enabled() in
 ata_eh_speed_down()
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jason Yan <yanaijie@huawei.com>
References: <20230605105244.1045490-1-dlemoal@kernel.org>
 <20230605105244.1045490-3-dlemoal@kernel.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230605105244.1045490-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0001.apcprd04.prod.outlook.com
 (2603:1096:4:197::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB7133:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e80e209-e7fc-49e2-73c5-08db65c1167c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BZS43kJ2TNY2LBSw36CyReo8pAut2v7G16scZSlcpFGwJYJZM+wDoMlg3kmNEEWh/pAcwjUozgjUrqjT5uWoWnJgHx8RnL5IYD7lZSnKQzxIQMJWyvTne2peGPOY3ZWLCUosyAHYMmDaYHInxL+RkZdoF/JOaNh0gdHgtmOGyioKhWwsnW/iJiLBZjkrMGfJbBgveihe7DQnLEPR7UoZVUW4bEoHV5Su+bmZd6HKKEIXmaTBLcEX3wINkUhcxrbW3WsdS7VsT29YW7p9ujpQcP1F3Uwdfy/Xp/+/xiviQWwth+F1NdtXlJUKBQ/cxuXKQt4ogbRoLbjuzkU8jr3xnuGugfWrCXFVB0IOB+MTakXJe/KABt5QjHchFmaimn6HvNa5/+XR8ac7cta6t0J2FDHNnaxqLST2Pj+PF+8YJ5fEw+ZOvmbDJDZx7jg+q2GOzK2810Vz/ECHHhhB4RAIL+VzBTNxwtQY5y4VPzBXEeVDEACESACN1KvfYF2PB75nHFjB7hO6HIK/GXo6rSiR7wDV8Kxfyni0nluNONZaRmjW/ZgY9xkPFJTD1/PaZH1SsF7BKYKJcanMj/6Ik+7+tY4RkLdKWqAa80eLrd2R8K1jB6SzX4KEZABbJo5cUDUwMpiRG4LafGol0dUBdRVG0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(396003)(376002)(366004)(39860400002)(451199021)(6512007)(53546011)(6506007)(26005)(36756003)(83380400001)(31696002)(86362001)(38100700002)(186003)(2616005)(41300700001)(110136005)(2906002)(4744005)(478600001)(66946007)(66476007)(6636002)(4326008)(8936002)(8676002)(316002)(31686004)(66556008)(5660300002)(6486002)(36916002)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TENDbnV1bklwODVzSjZyWFFJZ0R2bjRoUjRRSHZLV3l6K3VoSE1PaGZwdU5O?=
 =?utf-8?B?MzhtbHJQUjN4cjVnNFMxdGhqOFlZanZIcFlBbi96eldZN3YzWU16ZTkzdEd2?=
 =?utf-8?B?eUNMQU00eDE3eXZ6MXV0RitzSDByUW4zZTJ2RjNZVDdOVlVNNnIyZ0FseXJy?=
 =?utf-8?B?eEIyUE9zUG43Q2tGVStmaGNqenhHbUVBNXFIUUozMTIrL05sZW91bkJjQVc5?=
 =?utf-8?B?eTRwRytSSzNoUm5PZnMwdzdpREVGbk40NjE1SUdVYndIZGJhd2R5ZlJMSHVa?=
 =?utf-8?B?aEFFalBHc3dQQlFRN2hCc3VFa3dwL0RGT2JidzBHbE85c0pBVXR0ZXJrL3FT?=
 =?utf-8?B?YldpM3VoaUlBOVJzM0o0RVVDb2dJUDhoMWRweWtuOENmL3UzVGtZSVRCY01L?=
 =?utf-8?B?SHZyVzVkZko1TnhBWlhLOHhnaVliazl4dDZEZkZOdEZheGVzYUg0OXR4TVVp?=
 =?utf-8?B?cEQ1Q2xwMTdkbzhPUHZmbUZJTk9QcUt2UUJKMjNFZVNsWEl2UUxGajl1SSs0?=
 =?utf-8?B?eVlQcWdoNFZJdWZ6U3RDcEU1TVh4eUdqcjloY2p0OUxBRGlaQmhnQjJCaTRM?=
 =?utf-8?B?d0R0aDA1eXg1d3JDRUxJYXVwM1VPMEw1WFRXKzdTUW02Y3hrbGN3OU5hTXM5?=
 =?utf-8?B?c3ZoRGpLaTFaQlFuNUVvSm01OVY0RmVtL3ArRkZrN05sb0h5bnMxU24wTVZ2?=
 =?utf-8?B?YlZRVzFyL2lKdlpDQUVxMHdvVVduMEdFd3E2dFNMQXJYRU1XZElxdC92eG1u?=
 =?utf-8?B?THR0VjhzcENaT3Z4SjNOOTFjYVgxK0hKbkMrNGZUUXlGZTFDV08wNEc1UUw5?=
 =?utf-8?B?TWhJaHU3d0tFYngxWEo5ZVVoZWl5Z0oyWCtOWjM5aForY0g4ZERrNlFMTGN6?=
 =?utf-8?B?VFp5K2ZjMldZWStlR3UrYzB3SmFkVlQ3VHRIeHZzWlkwZUZnNGJCR0o3bEkx?=
 =?utf-8?B?QUpaM0VUWHJxanpIN0swY3Z2ZDYwOHNTZGgwNTlDWC9sMEZ5eHhsUldJcVd0?=
 =?utf-8?B?aXpYMDVuRmZKWFJZeWNJOUJqTzZhTlI3ZkJzWi9RR04zV3JNUVN1ekJhb1Vm?=
 =?utf-8?B?NFU4ZkNaWHpmd0NjRHMwN0F4KzFDOWtsOXJxU3ZIb2p0Zll1dXpwTnRBQUYy?=
 =?utf-8?B?L001MTl0RmkzTnBvMzZBWkNkNjk1eFFJZ0ZIZTlxTTRaWHU1dzdHZVFPeXhU?=
 =?utf-8?B?OGwzNTZLaEFiZTVvSXpWUTNQM3UzQ3pjWm5UN01xb1VuZWJ6eXpXWVdqSElK?=
 =?utf-8?B?bUNDOW5vdXp6K1ROdWJMVHAwTVc5RHB0Wnc0NWxrNmNha1hxQ3ZvZWowQmRn?=
 =?utf-8?B?TlBQR1Q0Vk5yOEdiU3c3ZVQvRTFRR0xNaFZHVy95UWFkaXdzcHFCNGQya2J4?=
 =?utf-8?B?ZXdhZVZmTnNpbDZVajYwYXdoZFE3UWRXNTRxayszRGJDM2JGbmhGUE1XUEhw?=
 =?utf-8?B?SzRyTHdmMTAvcEZ0MmRhY2ExdkVENHN5bDdOTTRaQ0MycEUza1JvUkxYbTJk?=
 =?utf-8?B?bTFWNWJNL01OS2V0NHNHdmRnWUYySjYrT0s0a0ZtNmZXeTBhMW1NZ0NVQ2dv?=
 =?utf-8?B?VVNmQmljNVRQMmVHdWFxWXFXSDh0alloVlhxK1N6dm5mUmZBUmJTQll2NzZK?=
 =?utf-8?B?Z3dDVk5vVFpKWis4U1ljSTZuUXNadFkzQlJuUWtodnVpL29jMW5KM1NtWXlI?=
 =?utf-8?B?WWZCU1VaWDNuczhwYjZlNWNTbVl5ZHRWUERpbXAySjRMcVl1dXhxTWRNYlNL?=
 =?utf-8?B?QWFCelVqb01QeXJBakhVQk03Nm9uRlNKTVVSeUVZenJUa01UVHJMcGQ0MkVT?=
 =?utf-8?B?RkxGdit2SWFNUkJjb0hzTlh3WUY5UVB5MlJqYTNLVVgrV0JUTi9SUXdxT2pI?=
 =?utf-8?B?SXdSVkFLM1hUVjVtd3Vibi94Znp1VHlvUjVpell5MmJNWFBra09xUHFHU1Zn?=
 =?utf-8?B?VXVGSW9PekhsNldRYWgrS1ZZa0pHaFZzMFQwdG5hVElVRmxndC9kZzgxK250?=
 =?utf-8?B?VnBaV1ZMTGk1L0hwRVNJRWtaVFNzOGlRUmNtTVBOZE93eVVmbDZhaDZkR1RD?=
 =?utf-8?B?TlF1MTNmZDNIVzhPc1V6eTF0NXcwYU96NkFxR3NoSVhHNFhIRGl5MEtiZjk2?=
 =?utf-8?B?OEx1NWFOOXB6ZVdyZWZ2Wi9JUXZOV0xkTUdwY0lLNElpMWJOdDRXWW5GQU83?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: GZ5ZO+3w//VkI8rvfCNF1znNcTyVYIPmX7x8A5DD3i+FWXpKYXiIm3xzHuBO8kQwFvrgNY10r93t1H8C8yohBbH5ivT4mLkp3mnKZcn/a0B5dTgV2lFlLA5Bdc1a5Qsx2t+Vzt0dxaEwZDYZxgePyvS+18V4Us5/IKyPINAKUcjo09G9s2qUxtISgux4v0xARYgkovQGCX7ks5FQN7WoJth4mlJDiK5sF8a4en5Y5ThjzF2I9BF22brYIXopb/BHHXJRYoDqsUZwPVErThIBzk0DMbZ4iU5iLEXt0XhAtGo7FXgqL0oK2bleZV5f0hAEyiYFCNZgGFgpIe7hDn36hHkt5fAcPxmGPGc1mmzjTfubcbVILIEGZKbfYzHdsC2LmOuSqC9DFsslahk68bZvT6KFaaAwUs6bcIrpNEK9jpREwG7J/gvVQKpypntmNSHfwSaxQTX5fo1W+XZU6WQjILIJZvsjsbzVfRX5IQu5zF7r6LZ9KvaL6v3YXbj0VkD3Ra1/lUqRHISkg39H8gcM6/A6CNZSHfipe2yj5GR2EwVw+XbQWraiPPsXZ/PYrtgf+733h1LZHrP1UZkDXfKBJ3oTyxJVRFrEhI6/cndnxakrxUddSPdLS7dXe8+LUzs6TOPPNGkNrmpN4f8IObl0d+m9RVddVo3kPN/p/QkO9YlNWfj7U9miPPZawGoZpWkjZerLX7M1mHnuCXOv6hk8nSB4x+zCnNVGg/A2OisXC/22/Pq58WD7db0r8WCxBGjOuIKMdrAHmbjDeg3iyAY94D7E7kXpVzCEq1u2WDD5ND4eRO63ZVhsAPpPIj2A6fta
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e80e209-e7fc-49e2-73c5-08db65c1167c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 12:33:38.6959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xlqcbUfOTY5zuEf3nXzKu5KxH8c1LGvM0kUmsSJ1lVaVp/yaY7WYVhfA1aXPEVa2gUrBXohPkp8WRHzQpHaslA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7133
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-03_08,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306050110
X-Proofpoint-GUID: 3blvndlsZpTbmWe0QlKN7w5qvMBUWULi
X-Proofpoint-ORIG-GUID: 3blvndlsZpTbmWe0QlKN7w5qvMBUWULi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/06/2023 11:52, Damien Le Moal wrote:
> In ata_eh_speed_down(), instead of hard-coding the test on the device
> flags to detect if NCQ is supported and enabled, use ata_ncq_enabled().
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke<hare@suse.de>

ughh..I reviewed v1 since this was sent, so:
Reviewed-by: John Garry <john.g.garry@oracle.com>
