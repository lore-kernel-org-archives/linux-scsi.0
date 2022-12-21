Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32A1C41535
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Dec 2022 11:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbiLULrh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Dec 2022 06:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLULrf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2022 06:47:35 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEFB1D33B;
        Wed, 21 Dec 2022 03:47:34 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BL8JXxa032679;
        Wed, 21 Dec 2022 11:47:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=0iTWsDVaIOFahUfPTzcbAgbG1/usCJjthAkPFeSCzLY=;
 b=cPl6Xy8J8qp0ft9ndK35rV3YYjMASKi8TJJYD2EE7TxaQFDC2aNlnlMsjGgKa78aB3Dy
 88lz1gFHgTnehlpntFf2xYFQO4bgPAczb38wq2vavSPbOY/trwhAMotUystbZ47GYsYE
 zsFOPzNxHqb2lZW326EyzTM6RQBjStFpxxlu9jJtsBn3dX1nOc0kF012/uQY9PtK1CK/
 bnp//a82/MEPiuKpuqcDKSdoH9BvBj074WK1wMhw29dr2FbXMDVedF+2mBiASMOfQcGH
 d0IOKdQuUrGItHY27441wfTSJEczVFGzkQWotsze/bsY5QGIf3NpTJWCHHdYyicry5qM TA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tm8mh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 11:47:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BL9T8oR009678;
        Wed, 21 Dec 2022 11:47:23 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh47cu0re-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 11:47:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dAeIA8xNLiyNmmmbVFh3U8ULqKlsb74GRR1VtCd9JJhY6RDeA/OedLBHyw0Tfn2Ddm18EpaxPe2El641eWGpKkzeu/AWP4bhyWQEcaTuJUMm+PeI8YZk1kSFZ9DqdVzQ7kYzVoagv+k8pshqQPHzcG3QESrX4ThlgnQBaV3qGeFBI42QDfbeEbXOpGThJW0lJurC8KghQLayACRTh/CnhuOoZhumZd5olH17iDlTbdGp8nCYTKfz7qTKj7Lm0dYvesUatzI3thO9SUji6HJJA5imCXWBy+1T4ZSCKdBKoGobYd+kwTaRqpbV8yGNyMKJJaufj3zcGPThbQZ7JR/pxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0iTWsDVaIOFahUfPTzcbAgbG1/usCJjthAkPFeSCzLY=;
 b=Fiu/jc4xG2dIASZuoj7AlNYV7jRdsnK7P56VcTXTlLfWdbyRPlWmJWGpD5W2ndmE+xdrIv0uPUPDqFCB426VyoZDbJyqsfBhqhG6JjfM15sZKD0mdnGai4s3MKqg7LmGHI5T86Ei99hO9DejjoCiAT5xlJXNPfZWh22U8gQqR2XNC+KuEnH5UU7Rl2YFEmRhiRUbdlmwhkhgEyWJkiUqx6hVCnEyF0rPGULk66la+V8lTzqfSRhW9VPuHgpATj9xL7kbqJODCi4QxJT1TG6CW8+YHSAIQJDaC9AHm4cBEIt4sM/6Ww99sd1V1wNc+ZDHa8/VmQQHSHkVR4w27BMYVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0iTWsDVaIOFahUfPTzcbAgbG1/usCJjthAkPFeSCzLY=;
 b=wPfcWUgk0JG2fPcOYrpxHfynkb4BJf4GPvRjBzt2kCxLKOjfdlVXgFAZxA0+H4lcL70YEAMx0r3pxXgfLeQgiVa0SIjZvDl/UKj6L6EHnCoX2eSvjWzj5yCJrCvC6FyRTmzgSv9ZIzBUEta+1Ke3T+bjEPqp6uzcFHBF/z+wSFQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB7270.namprd10.prod.outlook.com (2603:10b6:8:f4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 11:47:22 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::1040:f0e3:c129:cff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::1040:f0e3:c129:cff%6]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 11:47:22 +0000
Message-ID: <a86d8ae7-907b-a004-916d-e3354c3f88e8@oracle.com>
Date:   Wed, 21 Dec 2022 11:47:17 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 01/25] ata: scsi: rename flag ATA_QCFLAG_FAILED to
 ATA_QCFLAG_EH
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mikael Pettersson <mikpelinux@gmail.com>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
 <20221208105947.2399894-2-niklas.cassel@wdc.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221208105947.2399894-2-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0550.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB7270:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a1d81d7-fe39-447f-d0db-08dae3491ef8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WQ85RGJEEZxj0CgGiIOfu4waHUtt5/CN2Jcp9zhNINRrafWifULTo49AI37WwIOwPZ0/xUchbIBvhgXXWf9ASBTsTbXKVtYUn4D6+1aGn4UJo/n4gMuvknz4sVuI1LVL4SYMdDFaQiK294eMCzyq3fbr5q3mdFuSC2LOdtmfImDfE1aJw8qlguTpGzdYexIQKgDEwTpxS86ELSt9O8yBUO1mOxF9LM+W+7/4IJWJsFimxvFggAdoqBo7I+KgLhf1yYSrRBd4yKEdgaYfW/moBPKw0Ud9WE2oDqjY6s3Qn0TGjnnRYbAsDUOQ8p9osyBLlB4T6+4K4wkNeI26ifsAvWTyFMK8HZzUllYnehpMkY+vlF4XGsv6dL05kXy++ikiXPc98+I+9qBvxnqiG6zxGi8ihAXigpe5i2sMmtCZwbp+lwoGaAoqRkXpPikobfmPs0oTV++8TyLI0hM4FLwu90w2NISAXssz5/vevrLRHHtkXD737gCFwaWk0afZrQtodTyh1SEyNlGTuG6pDuO/LC2f2O+q5Brgtib7s75lHSwgBs8uillnvnphgwU41MsqLfuHQUJhFiylEXN6LDYBZgS/oJdJS7JylozuVemF7NEjeb6AW6yBDOnKqf03bspCG4Ng0volamW0VexgmIVNu9gcuctUoxlX+8Sn1q+7c98np2oV3LmqncVDEhkXEQtM3r6F3pBxwen1r0IWaPJRkFxUsQ6f4IonoBtn/bYWAUU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(366004)(136003)(39860400002)(451199015)(38100700002)(2906002)(31696002)(31686004)(36756003)(41300700001)(186003)(86362001)(26005)(53546011)(66476007)(5660300002)(66946007)(4326008)(110136005)(6512007)(8676002)(83380400001)(6486002)(316002)(66556008)(2616005)(478600001)(8936002)(6666004)(6636002)(36916002)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjVOYUx3Y1VjblNneGxFN0JGbHdib2ZtVHJ6c1A2VVFVVTRTc1N4dlZOTGNy?=
 =?utf-8?B?aFR3VVdHSDhwY1llTVlKV2NiZjlsQllyR25VT2c1ZzJqMWpoNUdsQnc1Nlhs?=
 =?utf-8?B?RjNjWGhsWlJPMlByRHJCcVFjamhTZnVkYWdkNGxUc1ZVOUVIV25SVFNTeCtu?=
 =?utf-8?B?K0hQVytEa0dvVFEreVRlVmlCWWU1ZmkzREhNcWVXRVNNVG9rbWtwZUkxaWFj?=
 =?utf-8?B?WkkwcVlTbE5OdkVrNHFralExVk5OYUtGUTdaNFdvR0J1Y1k4SFhISzEyQ1hK?=
 =?utf-8?B?S3MzNTR2amt2MjlSUERaQjdVYitrK1pESXUvSjUxM0xldjBHY2RIQm9CbnlT?=
 =?utf-8?B?dTRFQ2lTZU9rVng5S29wZkRtVFJua1VwS0NycXF3cmpXOTdVdWwxalc5RWNh?=
 =?utf-8?B?NFRackQ1S1RjdFk0cFNqRzBlRDNQTXlDZFF4U2RkUVFkNnkrR3BxbWNtOUJP?=
 =?utf-8?B?d2tJNGdtLzEzRUw0dlVuaUVsTzI0ZDBjeFJpRnRDdXpFNGNhcW1TTzBLSWVw?=
 =?utf-8?B?VFArY3RSazc1dDhEeDJtMlY5VjJJTWdHWTZBTDZzYmllWnU0aWtMQWtWZVJs?=
 =?utf-8?B?VDlyUHFwZm5wK2U3R1M4WWdlajBsWHlxSHpzdzF4Tm1TRCtTOURxZSsvc1Q2?=
 =?utf-8?B?bndicTlQSlhiM0Q1d1RnbVVrZnpoZFdYWmRSekk3ekNtZ3BYTE12ejhiZkMw?=
 =?utf-8?B?aGk4ZTZ6UTV3SkxhU0tpbXpNSFg5ZmFzVm9sMHVLWklLMUNQcTFXeW9OMEhI?=
 =?utf-8?B?ZnZBN2VTeWRkSGFpNXZHTzVQQm1hZTlrakczOG1tUHRId3l3YW9UYkNaUUhO?=
 =?utf-8?B?TWlqZDErYUZlbkFRYzNWMFYvQ3hOTU55aENxSDZibERpM3NObGJiTnA3cFBx?=
 =?utf-8?B?RmlQVDhXME5LeFRLQm5WUDYwQkc5cmdXd2N3RmVQWWs2bUlaK21JNGZ2cjBr?=
 =?utf-8?B?VGpmRVVWQ1hYbENBeFhTaDgrVWZXdllZQXZ0ci9JSVV1MmdNWVBJQTNKNGhV?=
 =?utf-8?B?KzUxeWVQdUtNVDRZRWszYmljNlRmQnlQaW5kR0dhVmxCUGMvOWU3SDRtSVJh?=
 =?utf-8?B?c0lybWpMN25nUDFZeXVuUkltNWl4N0RTUE9ma3VTZVhOQndERFM2ZkttZS9Y?=
 =?utf-8?B?Q1dJVUkxb2NqUGQrNVNNTmx1alRmRDd4KzlnUVdybEpEQWNxSUpCZ3JMcE5G?=
 =?utf-8?B?bVAyd2FOYWJFVkhFcG9ZM2NZWVJRVFFNOFlyWThvcXhuOWZhc1RoaDVqY3lQ?=
 =?utf-8?B?eXN5WFE2dUNtK2pHOEFyUE05ZkRQelBMdm5QMG10RlR4Q2dMSjF2T0VRQkJB?=
 =?utf-8?B?ZFNBOHpCNVFjUkkwL1lZUFBjY3N4TDlhSkg3WXROalBGNndLdC9FWlRZdFJh?=
 =?utf-8?B?Mk9mODRFR3Y5dFVPOS9oOTlBR1hweE9GTU13VnJtb0JGWHM2V05KTW9PeWNZ?=
 =?utf-8?B?U2JxaVhUZnNlYVdBa2NGcm1jcUJLME5oWHI2SlhQaGp1L0tXYjJ6VlpKSXIy?=
 =?utf-8?B?MUxCczVzdHlBNFEzSXRJc1R1bnNWRkl1Wk5wakdoQ3phcWJybmZwQ0dmRUU3?=
 =?utf-8?B?Rmg1YmhVckRIUEIwWXA1NXc2Zk1laG0vTml2eGNEdnhMWGtQaFdydlpJNzBF?=
 =?utf-8?B?TmdHOUdaMUNYYld5ZUd0UVRnWWkxMTF4TklTUktQK0ZwWjVXeEVSQmgybE5n?=
 =?utf-8?B?d2hxUHpQZnAzYTAvc1FjOUlmOUJrdFFLY1RWaFF3ZFdwZ1ZNUTdqcGcvZkM0?=
 =?utf-8?B?Yy9pM2pIS3J5NnBwck1uUndiSjNPcTZiZjAvRmlNdHNvRlBCbXFYWEpMZENO?=
 =?utf-8?B?bU1JVWNBc25ZNjdMK2daUTZBajNDdW1RR3ZzRzRRV2lnaDgyT21RbVAyaFpK?=
 =?utf-8?B?bmVxNFpiZFFtS2xXZTBkb1pja1NZVjExa3hxcjBTSlo3azIxRERhWmM1TW9X?=
 =?utf-8?B?aU1DWWtMQW5QakZMVTZRY2VraWdLU0ZGZW14MUE5UGNyWDhiejIwcldEVnBu?=
 =?utf-8?B?cHQ3V0xiUnJ1M0Y0VzUxMjlZTEJpTm9sY2pYS2xwcW1ORStGVmJIZXU3NFJB?=
 =?utf-8?B?YXFJcWR3a2VQSzdIRlpCcW5MV0xoZWtTY0JqZU1XcEdtNWRGSUc4Njhoejg2?=
 =?utf-8?Q?d8VNp6H2S/DUqoFkSXyUADBiL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a1d81d7-fe39-447f-d0db-08dae3491ef8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2022 11:47:22.0274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e9m0DLrTEdKVw+iud4YqAreebDPrB35KAvfe1DgRgVPE0KWiPZsBPqImo4vdQHG/OwhrrXg1iUTeJmclV4e+fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7270
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-21_05,2022-12-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212210096
X-Proofpoint-GUID: TuinpqD7hI1skZKvl1h2kstvS-sFMuqU
X-Proofpoint-ORIG-GUID: TuinpqD7hI1skZKvl1h2kstvS-sFMuqU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/12/2022 10:59, Niklas Cassel wrote:
> The name ATA_QCFLAG_FAILED is misleading since it does not mean that a
> QC was actually an error.

"QC was actually an error" sounds odd. Maybe "...it does not mean that a
QC completed in error or not at all". I'm not sure on a good suggestion.

> It means that libata decided to schedule EH
> for the QC, so the QC is now owned by the libata error handler (EH).
> 
> The normal execution path is responsible for not accessing a QC owned
> by EH. libata core enforces the rule by returning NULL from
> ata_qc_from_tag() for QCs owned by EH.
> 
> It is quite easy to mistake that a QC marked with ATA_QCFLAG_FAILED was
> an error. However, a QC that was actually an error is instead indicated
> by having qc->err_mask set. E.g. when we have a NCQ error, we abort all
> QCs, which currently will mark all QCs as ATA_QCFLAG_FAILED. However, it
> will only be a single QC that is an error (i.e. has qc->err_mask set).
> 
> Rename ATA_QCFLAG_FAILED to ATA_QCFLAG_EH to more clearly highlight that
> this flag simply means that a QC is now owned by EH. This new name will
> not mislead to think that the QC was an error (which is instead
> indicated by having qc->err_mask set).
> 
> This also makes it more obvious that the EH code skips all QCs that do
> not have ATA_QCFLAG_EH set (rather than ATA_QCFLAG_FAILED), since the EH
> code should simply only care about QCs that are owned by EH itself.
> 
> Signed-off-by: Niklas Cassel<niklas.cassel@wdc.com>

FWIW,

Reviewed-by: John Garry <john.g.garry@oracle.com>
