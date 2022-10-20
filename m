Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EABEC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Oct 2022 19:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiJTTQS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Oct 2022 15:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiJTTQR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2022 15:16:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74AF2BE09
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2022 12:16:14 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KHxMua019190;
        Thu, 20 Oct 2022 19:16:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=DHiEQ+ag6D5ujteVPEKbPBi0UYT70KtrczKWtdsc2bw=;
 b=xhFjrsK+Nw+9burUNOK+pZsqHfsBCFJDUwxnBiGxQVX3r8S1LJMdiYD3h2CpKZ/JUnCD
 fV9rniYDO/GCVNzkU50KMtkaQwOiI6dRQUUsL0/D1K7Pc0VmKYXKazh2/6Um3uNU01PZ
 WjB6Kiw2r+AP0Sym+9u6GiArzbXE0FHYgjaJ5ci2Tyx6SberaV2pfwG4Hfnp5KqAI45u
 B1KxRiXCd4MLKi+7smdSfxHS7hDZyOiVPsKvhj4+WNwu51NQ9MhEBIv1KDyWyQGg4Ys2
 bDkxPu1mLgtVeU/zyKI0uboE8v2K2I2o8J/kqOlmFuh4yafsOBZYKnXhnnFAGavYUOG3 gA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7ndtq13f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 19:16:02 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29KIHu7b018157;
        Thu, 20 Oct 2022 19:16:01 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8j0t95yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 19:16:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7yIr9U+OutnRsjzR9jikcyzb0ObicQHKwEIfDprg0Pxt78jItHfVF3xmI6mgZ6VLKyv6JhtlSNhWQ5spQZcegUWyB7YT/uY0h7xd/4P8HCa7GrHSAfr1ZU0P6icYZxzB+mCyqC9DUCzzKYhckAD4E8pWYglgw75cKqhZVG/VyavkJfGpaKYc1TiQ/Yk6vje7css8R0hS3jDT+b0r6fLBntslmB8vGtasyNMzfkKiktzrFUkxaYZ/Uvu73LJ5zlz4eoyMmz2twsevtSvMPIbmZ99wEgM1bapcSKUAe5gWiLICjcZWPLljhOapmBTxoOEZdkp6h4tPbJQiSKSeyNQDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DHiEQ+ag6D5ujteVPEKbPBi0UYT70KtrczKWtdsc2bw=;
 b=LY7jDWEjo4DO/3kjgFEk8LkgXG8Kel7EyKTbJi8tCC0hWEXbw0eKMjAbLY9l58pc54ZiSbuBpDubuEnSGIA2K7663qMeAdkT8rvb/a5XkhJMyLkZDiCQFs6b3llvkhai5BJGVmIfWASJ41IRz2LxorVxdo8V9N/LIE+OHt8scerhOf607YAFvwTnNaOaAnEjKJbHkU2i7IaIR0F7FO3M/+XGUAnAWzBvEMf8tMsgRBTsu9NHZNnMIr438ihuYqVb1tstY6xkdqyxGRaRHc2t+W3IvBWCIam0/ePa7QVZrJMjsRBcfpzyt/bUFAPcDCMXrwQqOvXKnhFUo+muk4u6ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DHiEQ+ag6D5ujteVPEKbPBi0UYT70KtrczKWtdsc2bw=;
 b=DbEx1/O7SwFEySpw9zQx/HA9J6/D8twRzILjDOwWWomsx8Z+d9KLM4YLTcOXNrtKPKCVkpgG2M+VjP9o0G+z9HqdSgX/MzPx8ZkRYqB/P0knepcyTDWOYtq5UctDyfrynxFs8pIV36taXoudCG/LQ6WCjn2R6bAeos5hnwX+3TQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM8PR10MB5400.namprd10.prod.outlook.com (2603:10b6:8:27::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.30; Thu, 20 Oct 2022 19:15:59 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.035; Thu, 20 Oct 2022
 19:15:59 +0000
Message-ID: <8833ee78-d864-c1e1-ebf5-5fd8149921ae@oracle.com>
Date:   Thu, 20 Oct 2022 14:15:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v4 22/36] scsi: Have scsi-ml retry read_capacity_16 errors
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221016195946.7613-1-michael.christie@oracle.com>
 <20221016195946.7613-23-michael.christie@oracle.com>
 <2aca5af1-3949-a8ac-6050-4b06d71e2fbf@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <2aca5af1-3949-a8ac-6050-4b06d71e2fbf@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR14CA0042.namprd14.prod.outlook.com
 (2603:10b6:610:56::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DM8PR10MB5400:EE_
X-MS-Office365-Filtering-Correlation-Id: f114dde0-5665-4d7c-3405-08dab2cf8515
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pKiKkriQSYfuUUTBpja1gNLrgu9eTnyt0DZitZ4KSCPPicZUQ05q1HbkrgPGBZlfU5A9b7WB+jTozI2bK3luxT7AoCU3dhFHDyk2Z4/WGmhFbq2NR43F/5a574LBcy3BNRR/IoqcXj+9W52JsDLtTnwT3z6eiWg6PldzOHWsOAtjg4XVJzIbh9t1iDK80kwpO6oqL7tR/AmTw4WxzLgcrs6tjngiBSnwguNS7zKMG/dlyQwpmugOk23nHXGSGCcgzR7w/Vsu29P5N0R3drefvdOUCGDIZQnI+Eoi0/+xvpNJzJFRuYNRdJ0qz6nmRP5x9a2M/S1pNlmnsUEFWYe6LCm+4iBH8h8KBLXulul265eC1FPVvbrsbXUkUlY6pqFGd4CJEQOFcJHIvnz8PTpTUtD57H76e1XCvcVTMHNzSt03wjj7Xs90BBsBk338yhrFS+1AmcA0uQyZgjwpEZutNy2krE0yFrkVcnbDACdhnxGBhq6FXDuNrXMkVoDk6EUorWg1/9YKgxl0f5GeepTYPfFDXEIYnvcy86c3Y5gGDE6m1ZvmDhdMoiW/JNmR95/YXvrjC5BLsZYguoMZlTzyYqW4L6JVn6/yFyqLkroHjdf9Uf8FzZIW9njVFQR44+UusS/5frUPQzR/djxYqRsNbBZDpevpsg33vd4du1NKQ66FgoNm+/Sxyp+F5cHoPBYB01Zj2NqWfc4srA8ZYcurc8d49JdgSwx9tnAiul+2LrFIAkeYtCXnF+L1QI99hz6Gj6gPfZZAts+FIxdHOTDSYtWgLgJTNjOK76sDlRqjLe4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199015)(26005)(316002)(4744005)(31696002)(6512007)(83380400001)(8936002)(8676002)(5660300002)(2906002)(2616005)(66476007)(86362001)(66946007)(66556008)(186003)(53546011)(41300700001)(6506007)(36756003)(31686004)(38100700002)(6486002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlpZQ2RxYlBCQkw4K0VTZGNrQ2c2YVI0Skh2V0NjZVJjU2FXRlVWUG4rOVJ3?=
 =?utf-8?B?V3JmVExjSUQ3ZTZyMHRTUStnK1VzZitsZFBKWjdBVGlLb1U1bVVhYmhsZklp?=
 =?utf-8?B?anExWUZucUxQQU9pUEJYYkhSMmFDcDlLYU9jOGF3cEtsbDY4ZDhFY0xUNE5D?=
 =?utf-8?B?K29kTEVOL3dTNUo0MFdCdjFyS3F3cXBLZ09tZWU2RThHVGxhRTJNdmxuVml6?=
 =?utf-8?B?ZjBJMUF1T2lMTlBxdUVBT3dNTGFialAxM2Y5QndKMFMxOHF0UXBoRUdETXp1?=
 =?utf-8?B?QU1wQk44dnBlZEJYY1NLOUorak8vYytCaTdNSGdDTVc3bWRJSU95YUI1aEF6?=
 =?utf-8?B?V0I1cDdYZHBLbFljcUZXUkJlNnNVTkZpbTFGNGY4YWY5L1VadkZMeVZtb09T?=
 =?utf-8?B?V1Q1Mm41ZlE4a3U2M2FISUJRR1ZMVTlDa21VbHB5VUQzQU9HRWY1eCtKMHJ1?=
 =?utf-8?B?ZkkzUnp4YnMxeUhlNGgvZG0zcTNTUE9mcjlzUmxrdG9BWko0QkhqdURvOGpS?=
 =?utf-8?B?SlY2VWNCUFpMYlBmTjZwQUtPbkIxKzVaaWdPbzh0T0R5eS8xRGh1Q3JpZTVq?=
 =?utf-8?B?VDdUS1BzMUNNRFZxY29QU2FBc0dnRVNYYW03OWlyMzVWeTNENkpucGJ2WnR6?=
 =?utf-8?B?cW5ybndFSHlQVHVKRTV2aWVEMUhMM2FCN1hXMm83anNwaUl6cnJBVzZ2Nndl?=
 =?utf-8?B?ZFhjMld3ZzNwV2hwMHh3YzlCTVZoQXM3azNZOGVHWG9wWjN6VTdVcnh1dDlX?=
 =?utf-8?B?SU5OZFdzazJHS3M0dTlSWGtSV3pGRTF5eTl6WVpsN3V0ZCtKanJzVG1iQzMv?=
 =?utf-8?B?TW1OVGlaOVcycTVNa25vQTJreVFYVEwxTVE1Z3JRZ1NDSDl4bFNYblYvSmll?=
 =?utf-8?B?YlZ3VW9MMnQwNEM2NkdkbExwejJ0VmJHOTBOS0tFZExwT3JiTzdtM2tqaW5x?=
 =?utf-8?B?Wk52Q3E5SkFtcHFJV0lLT2JTakRZUWI2cnJlK2VtMURoUDB6UlhoTFlRVjAr?=
 =?utf-8?B?eTU0bUhZc2Y5TTVKMlFwMXIzem8vbU1KV1hlYnk4eHpNaFM0TjExY2JrUkFo?=
 =?utf-8?B?WGVPZ3JoZkFvOHhKRnY3dC9RWHpaQjBHaTVFckhiQ2xVZ1U1NW1ORDVQcUtT?=
 =?utf-8?B?MlRmNlFCUGJnaG5PYm0rK3VVQ25xYU1KQ1RkQkRSOVFhN1VzeTMxczg1dU04?=
 =?utf-8?B?eG9ieElpZldYTUtsQXUvcjk1UDI3YXh3K09qVHUwSDg0VFduOWdFcUlOYXdH?=
 =?utf-8?B?WFZaMUpTZmV2Sm1PK2dhcHRJamJBcXhQa3hFMkpHTGMzVHdQN3RUMXRwbFF1?=
 =?utf-8?B?Njg1L2F4RG9yVm4xa0xIQkVQT3JodnVJdlpMY2NZREhud1VXSmlmSDhGaVJD?=
 =?utf-8?B?Ni9tcmR5TDVrNkJKL2FVNXhlMHlTMXZMUEVHWW1SdUVhcHlXNCs4M3dJTTdZ?=
 =?utf-8?B?cllkUXFjRkR0clVvdzlUOEpUeDhMWENZbnpSQXBncWREZjZZcE8zdzBnb2p3?=
 =?utf-8?B?TGhrWmdIbVN0TGlQeDF1azlnT3MyWjVuc3V5MEdhZXdDMlM5VmhCdkpZTDdt?=
 =?utf-8?B?NEJxTUVqZG1ZZjZUOHZNRC9XOCtuQXFadWtaSy9GUFpDdmYrVHFEeDNtNjJD?=
 =?utf-8?B?Q3lxQ245N1lRNmhCbU16TFJia3l3N01hVCtULzVMYU5Xc0U2cVJibldkUHhk?=
 =?utf-8?B?ZVRRMXNrN3Arc0xjZTl0enpnUUVyYlBWOWJQbVRQQ1JsTS9qNjI1cTFXODV6?=
 =?utf-8?B?UTJGbjg5cFgveFlsUVVibmovUnNRNCs5M0JKbEhmQnBabHBxcU51WndVNlB5?=
 =?utf-8?B?SGIwSGxpdzhHRUVBMEtFQmJxdk9zc2xVTEFLOGVUL2phZGdCSmxVSXNnZ2E1?=
 =?utf-8?B?dmFqYktqQVpaUnlCYk5MTHNreXhFRnRyRmw5cHhiRHF6OWx2cFNoZkQ0S1l4?=
 =?utf-8?B?ZEhVamJ5bnB4MlJLK25QMll1NXNiaC9ZelRWa0hkbmdFWEVlZUJQWTdLMDF6?=
 =?utf-8?B?WFRQcy9PTWxEb0VJZ0pzcklibnJaaHRiMFBJamJBLzRhVUhUbys1NXViME5K?=
 =?utf-8?B?Z1pJc2RMVTVXWDFjOHZqU0wyMUJldkxBZkRFUUNOVFRZQXdiTThqbzZnNmlI?=
 =?utf-8?B?NERVVnc2WXdVeFJiNVRpUytpY2M1elpuWE81UWc0cE1UNWhvbEVDbTBleHlu?=
 =?utf-8?B?MWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f114dde0-5665-4d7c-3405-08dab2cf8515
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 19:15:59.0829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WIK98fPWaUuEbzmMz63eMAOkezHGzCAybPcsgK7/qrAstPitP/aINDMue/10FFfjU0asdwL06k+IcaH9+JDhKirLiwptkxthAyLKnXFTVSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR10MB5400
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_09,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210200116
X-Proofpoint-ORIG-GUID: AynaPjGgevb39C6VMe_5CpuoskSes8IW
X-Proofpoint-GUID: AynaPjGgevb39C6VMe_5CpuoskSes8IW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/22 5:15 PM, Bart Van Assche wrote:
> On 10/16/22 12:59, Mike Christie wrote:
>> +    struct scsi_failure failures[] = {
>> +        {
>> +            .sense = UNIT_ATTENTION,
>> +            .asc = 0x29,
>> +            .ascq = 0,
>> +            /* Device reset might occur several times */
>> +            .allowed = READ_CAPACITY_RETRIES_ON_RESET,
>> +            .result = SAM_STAT_CHECK_CONDITION,
>> +        },
>> +        {
>> +            .result = SCMD_FAILURE_ANY,
>> +            .allowed = 3,
>> +        },
>> +        {},
>> +    };
> 
> Is the implication of the above that any failure reported in the .result field will result in a retry? I don't think that matches the current behavior of read_capacity_16().

I think I made 2 mistakes:

1. Retrying on media_not_present
2. Retrying on the specific ILLEGAL_REQUEST error.

I made a similar mistakes on some other patches so will fix
them as well.

