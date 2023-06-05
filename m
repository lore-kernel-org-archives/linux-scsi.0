Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 408BFC77B73
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 12:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjFEMd7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 08:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbjFEMdl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 08:33:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D265310FA;
        Mon,  5 Jun 2023 05:33:02 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 355BfMLN017333;
        Mon, 5 Jun 2023 12:31:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=VcUrflDhdMkt9B7wMSbuTwT8QdG9Ww4OojiHMqmt4y8=;
 b=egr/bj1imGTo6EGz86cvgWnoT5RZp2sd8epZVThkUjVTx9txElw76KRYMqHDG1suP3OL
 jdHUcfO15oCf2uyGwp2sFgESAFViPZXRJtjECVLYkXADir9EMOqf05PMR78FM4PJdAQT
 YC2U309QyoD4NVugkMgtftsts5Su6NIhpEgNIG2CNfBGj8xjHu7zHY2f2oPwa5pM2DG1
 323enKxotFeJLcS82hkatWq2/wDukU1bsb9o7VH4oPrQJYjxlbCnEUJTsaB28WAbJUqY
 6fkk/opKpvMbV8p7gvxBqZ8AOaleIGl63gEfujpVjCWJl3rGq4tOmpO4yNVnXbJpR9ug Fw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx1nttwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Jun 2023 12:31:52 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 355BiuGL020110;
        Mon, 5 Jun 2023 12:31:51 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tsw5kch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Jun 2023 12:31:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N//FdImdtjh07cacNNQ57Dy/crZ9habgTfdVONlu1gkM4COlRMY7+JNUzmxD7Meuq/ScEzdVpgUE4POi6d3IVcwHiErw2HMQtlnEiP9WqoCGlrDqOD3ymtsp0FRMI8hMcYPApcc3ZfMjx5H7NsrpBk2UUG8qgspP2xfpHr6EJJrH6IU/lSlBDTYFmBP6Ed58N1dxGzHK3eaXxEk8+NgbDcxSXhl1qJJ/099im2jsni3IWa2+p+FfEyK/FzgfYoFeemMpCFSuGNa8pg5Xfy/rIb0nBhmFJfMQshVNgVZQwOsURxFhYrC7+HfJnY/IevcSjGe/+qpymi+FJ+5u0g1Fbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VcUrflDhdMkt9B7wMSbuTwT8QdG9Ww4OojiHMqmt4y8=;
 b=FMlZWbLRI3rfH3RecbOxuczFFAR7hLGgd7ClUDQ+ETnoHI6Nl1ydacE25RsAgnZsI2eYpQXCXp38J0pL9Bgn0+PzmJV9S9GsbZO/Q0/Dm7DCUk4oHSEMR2AH5kxbrF7yzLVpM1AcO9HHELqG4bppZ/ljW6s3WxEOnh6/kFEUuL2/t5XZlKyjT/fJl+J6ufmtpnBwsuMuVgvU5jDvKZhRIu7EwnVCHdXyxTduXBnRe49D7t/iaZ1PTHwI83br+3UyRusroKPu645AtwNtoQO4sL4H9DTsAbxzF6d67pWwB0u2vo9kg3ZVa7rBt+kwrszmUvMin5FcVZlKOAxviluaBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VcUrflDhdMkt9B7wMSbuTwT8QdG9Ww4OojiHMqmt4y8=;
 b=Wst20NOUIh2rNSmzFNQZQ+0xf2cv487N8emk5fLb2dTA24CnMhIql+/tLVzW6dOTvHrrstOiZRjQUfxK4dAyGuuKIO4+F+O5gwVp0i9weiy4GAo43EQnNEmTog1vyel3jHjnjagrBhvODAtUd1iLWfhGKD0q/ziB02gPVmx7Q4w=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB5596.namprd10.prod.outlook.com (2603:10b6:510:f8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Mon, 5 Jun
 2023 12:31:49 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::acef:9a5e:9d29:17c2]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::acef:9a5e:9d29:17c2%6]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 12:31:49 +0000
Message-ID: <bb65e249-9a77-5e95-5a99-da7a4f270438@oracle.com>
Date:   Mon, 5 Jun 2023 13:31:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/3] ata: libata-eh: Use ata_ncq_enabled() in
 ata_eh_speed_down()
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jason Yan <yanaijie@huawei.com>
References: <20230605013212.573489-1-dlemoal@kernel.org>
 <20230605013212.573489-3-dlemoal@kernel.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230605013212.573489-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0611.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB5596:EE_
X-MS-Office365-Filtering-Correlation-Id: a84f3a70-2231-4623-9dcf-08db65c0d582
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PLLkw1mc2+oBr/tNQemTv0/e/TCc7R0S5lYb1V3z0w2sIp74Bjv00AuB2YxguRRIGMrkqT7YXTL0PGjVtECeZShsWdfBR+B4OyI0tSmKlbgneOZApSeMe+zKJ6lqb8o4V/QxalUnrXFuU10Uda8mgXOp5wbDw8kxoenROZxnlHyP8d4UP0hxIJuhd/ectTZILywVgTrnU9aurXdFOmWQ/7nBekYN9JWlvRQH8TtYLP0bRoQdxc17DryTlVPwbGBtCGxy57ME9mJlTi/NRx4TME1SYyiglSZuQQNDbDslE8LJfNu0fNCRvRECIDBznBmKXGAxPL0JX41apYUiJr3l5SAH5KRkI0HG/2UPMwZgsFTbQUVSv1xlNpPfvSHSBR/1UvJYIevA0Kb8eVzXLhU34rdsQhngQK91l8oDNRMUXiKtvgr5GQMM3rahNWANe7DjB5wYadGRqmSr2IYyE5fBc3igz0wip6m4olRz2hU5wo3+t6T4aiqMzr5k1/5nzLu6DjNKwRLG8zmwWL5DdHzkssLIJcgPPoqJyP0HXDfoc/l8sMnUc1ifR06+1XO4w//4h8knR2eNJ3DIrlqmlgtGDIc4NAc2URl0VchNoHSpbeuqskGMenvQAdUWFUvyVuf6LwW+2nLcchMFSUWkJZrUOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199021)(53546011)(26005)(6512007)(2616005)(6506007)(38100700002)(83380400001)(41300700001)(31686004)(36916002)(6486002)(6666004)(186003)(478600001)(110136005)(4326008)(6636002)(66476007)(66556008)(66946007)(316002)(5660300002)(8936002)(8676002)(31696002)(2906002)(86362001)(558084003)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmplTHRsbHpkK2lIazRzVzVHZWprMXBtb045dWtBZGhCT2Zvb1Zod0pLWkpJ?=
 =?utf-8?B?dnlVVWdlOHdrOURWQXF3S205LzladVRpRVpuckh5RGZCUDJvams5MDhnWDR6?=
 =?utf-8?B?WDJ1TWd1UGNHLzJmS0hpSFc2MC9WMXVqTkdBaE5aQU5TVWFUaXNITU9qWnkr?=
 =?utf-8?B?ZVN1RVVHRHRseGZzVEl4SCsrNXN0d3JQcFJ6V3BnYjRYV3ZWVEZqdE5RUHVK?=
 =?utf-8?B?VnplRnlPcmNjSE9pbXVIUWF1eFc5Y2NtMWN2clFZTlRRWlVyck4yS3VKdWE3?=
 =?utf-8?B?Y1BKUWNXVFlRYzlwaTRTMFQyLy9jQUlUYXAzODhDYU01Y3lKcGFqNFBRbFJF?=
 =?utf-8?B?ZTd2bXd3MjZ6dVlGRmVtTlNMVWNJTGZWQU1rQVkzalJBcUNTS25hSXpqdW0r?=
 =?utf-8?B?bWZGY1B0L0JPSDlrQ3JCYXhuZjBadmtBZytPd0tyNXcwUktNUmV0c2VtT3JV?=
 =?utf-8?B?VlVvQ3JabVlBK2xIcDBndDdXS2w1ZXR4bW5LeHNVSzV5WHdUQXdlZERGaVg5?=
 =?utf-8?B?a1BKblBKMXYzaHoxYkUrVXFlZW1oT2MyNU4rU2VGOXlIZXFEMTlBamFhTGU4?=
 =?utf-8?B?aWZwLzNkUUUvYzVjcXpxY1lOek5ZZUpTNWE0eEFsclc5V2k2bUt2YUdxSC9s?=
 =?utf-8?B?dzRpaDYxUjI2SnhReGZQd0luQ0xYRE93bENEdUpqb2JhMnVLTTNqcjFVZHRk?=
 =?utf-8?B?ek16a0NoZnFjdFg3YnozUzd5OG1TdHNkNXRwOWZJT0hia2pRc0wxdWhWZW5P?=
 =?utf-8?B?b0svenVBQUNkWkgxTEErU09CYTlpYzd6UWFpLzVlenVrUXN4aTFVUEpKWjNJ?=
 =?utf-8?B?L0lrUURVUzVya1N1enhqUW04UzE3NzluT3JxL1VLQm84b2pjVDhlemFhMW5J?=
 =?utf-8?B?Q3ZoWnRpdWxacUwwK2JKbTliRk9IZEp1dkdpdTdUMG9vTlJBNkl3TFlPV1lO?=
 =?utf-8?B?R2orcjYvNXlzK2V0eGE1Wkp1cGxJdmFjQVdiWkhFeG43NWxMK3FvVmhFUHg5?=
 =?utf-8?B?U0pCZitMOG5wYVpMY2xNZFUwOUdIODFMVmZSZ0RRNGxiSWc4S3BKTC9NY2E1?=
 =?utf-8?B?MHBBbWhNV29GNXdBU095KzJmV3VSRlZDTEg0R2lOYkgxT0ZjTFptSXpFV0Nk?=
 =?utf-8?B?TmpZdENDTk1lQlcwMHFGRWEzOXdSalJNeElXeGk4K2VqSEk5VG5hTXZmVWo3?=
 =?utf-8?B?MG50TG03L1BTY1pRSWdMeW5FcHg3eU4xbVQwNlZZb2c5M2dQR2g0R2RIMnVv?=
 =?utf-8?B?NXRnRGRzbmN1VEpBR0pSTFpPbXljL2wrTnYvYmRIU0NxQ0ZqdXJVdzR5bTRv?=
 =?utf-8?B?eDhOVm9YUTNmQTNqM0lUanI1M0Jld0VNRzlxVnp6VnZoSWVzVHVydmtHMEYw?=
 =?utf-8?B?ckNuNnRocTZPUEtHc3dlak9DVDJGbUFsVUZaeENXZGJPNWZtVG9XRVhSUmp2?=
 =?utf-8?B?VXNENHdQL2NTZW4ydld2RXBtUTBlaWRoT0Q5R1c3R1hsT05rZFgrZ1pvOFRP?=
 =?utf-8?B?U1MzNndaN3JxUFhvNFJXZG41NXpYTHE5bU02OFQwMDJBb01CSXBEZjEzTi9y?=
 =?utf-8?B?Rk1KQndkVDg1MGpFSmpSc3p3ODFsS2c2NGRqSWF2T0lqbWFlVVQraWJZZWRQ?=
 =?utf-8?B?cWpzdEhHYU80bVdLNC9Ld01GOTdEWlVkN0V1OXExS20wc2RKcERGdTFCTy95?=
 =?utf-8?B?UFVpczZYVUdhVTQ1Sm1Lc0U1b0s1bFU5ODJtMndjZkt2cW9MNTFPbkluTW9i?=
 =?utf-8?B?YTN2YW9KbjhWL3JaVi9NT05seFNnRVM1UG5acEo2VjNsa084c1A4WktvVTNw?=
 =?utf-8?B?cXRubkFEVUpQTm1mTk5BZHhqSUtCRDk5WUJXVmwzYWtDdHI3aTEyMk0vZnlS?=
 =?utf-8?B?azIvOXdJQzl2Zm1tczNNNDV2cGJzRlBIbUFCV3lKMHI3eVViOFh2SkwyNHpz?=
 =?utf-8?B?YlR3U2Vrc3RnbWp3QzdJaXhTQ1NrRE5vVlBNcjBLS0o4d0lmR0IzdVRTRnQ0?=
 =?utf-8?B?V2NsZzFiUm03NHJydmxqU1ZKTGVmWXc2RzR1ak5zRmdoTzFIQVkrRk91Z0dx?=
 =?utf-8?B?WnhhTS9EUHNLTEdQTGZVS1hiaFVaTWZNVVVVWkFGS2FLYmQ3Q0Z1dWhIUU5K?=
 =?utf-8?Q?nhxIZq0OEFRyIUp/WTkAkkkX9?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /2mLL4osUNmPJgxEz3pS53BHJyFmpX8jvrtE4jVEjOmDwnv5jOE+90RWXBONifTnOewV5onldXcDDXggseTPgeEfkVJPWEP2NsIEACxyFvidgtBIg2zADT+h5A6cQDNhPid+Z7Gf66hMs3btSDheItaXfuNKEkgqzzgzXn6F0XyszNi1f7wsLMP1L9+A7dXUfq+uOaFcbrXa5g8quQXeynIa7RfUhEZsKYyBT1pkcYyEKkjOAOltCBIO3M3cLBsLMt6m+cn8uviIXICBBhxblV+kVq8CJ40W2PZgABhnVxA0d0ji1azn74gSCM+pNeisp/FSsx9q68LQtvZ4HP3iJRVXLu6GG6lw1jg8Uu/IWf2SnUUxZSd7alo3nLZDWKtzNBIAPbH55dgbsRlAVQpCOYBkxDcR0cD6dP8bOlkPfulwxKtz2fhPjBgWJKIACgnAWrUhjFsMBVzKKghTJ//YECr5aiCg9ITIEr6r36p+Kx6ILqhWXb0n7H0IuZeEpozvP1qloYHHJrRB6Dbsr/QaFG4zfDuG+QXEzqkiAf4bpAy8mtSnaSsGCdPjPLnZ8eNaQvS2EqLiCX85xe0I+o25pQBz9iibyPB8UeBqiHPr1QQpJot1I8B89GXVvvkidQV4ANvmD77lw078XzHiSh+VAkiYSmg9ER8Pf5rOa53DDb+Rg2yNp760fWzBhrz0m84k3X9lBSI64Oh6mx3ZiL3raB8w0FH/+R1Bnusg6uTRwTAnSQkpNfdx10ksoCvUY51+KJ62zYl8p9IawfHMOuhxbpI5O9xEpKLW46zBNfW4K3WhSoI8vKvFLKBYU8qmzt5Y
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a84f3a70-2231-4623-9dcf-08db65c0d582
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 12:31:49.6033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: urup48g76yld6V22wm36jN3z6a1onABRG5lnm3bHoxFzHP28rHYLe0YIlfrKSMa9TYAxLaXZQM/ccX3TFIFyNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5596
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-03_08,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306050109
X-Proofpoint-GUID: gBBikpiq1s_ODOQXrPU0Yuzm-f9eB7rg
X-Proofpoint-ORIG-GUID: gBBikpiq1s_ODOQXrPU0Yuzm-f9eB7rg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/06/2023 02:32, Damien Le Moal wrote:
> Instead of hardconfign the device flag tests to detect if NCQ is
> supported and enabled in ata_eh_speed_down(), use ata_ncq_enabled().
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
