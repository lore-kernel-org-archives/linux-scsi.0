Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF9FC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Dec 2022 16:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235689AbiLMQZY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 11:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235810AbiLMQZO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 11:25:14 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A470F3898
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 08:25:11 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDGE7lk002391;
        Tue, 13 Dec 2022 16:24:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=KaywqWB0yeDqNa5mqG+a2RP9TZKYD703bqAFM2Qhs2Q=;
 b=YcDI5GVU7Ve1NJoTyt+uzTTmjVpqP5Xin/IkQRTZTpAM+PDM3H9yAWRhQPweahSUxvSg
 RNOsYDWvJbWI6rY2ePOAj1LdfW73kNIq4JCX6dQfpH6J2wwno2u5iRpDJxFCa42P3aty
 VMciq8AjcgBmG3+n4x4joEU5520GvXzSdRUAaZkUYrLDbaIDvHnsPnwICYjazD2qDyoT
 xs7No8m/deWBc7YVBwC24fBpsM9vzRNSfv2fFzKfS0jOrD57Dzy4asydcDhZAFd9lERi
 iMtSQ8ePXZlNnyYIXZVtKvmVfaRuRebPDFtEx1etgKwJbmFNinXGPr0j/l7sIg9vac2c Sg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mchqswsu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 16:24:52 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDFCQmu009403;
        Tue, 13 Dec 2022 16:24:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgj617tr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 16:24:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BiVkH5KuKfaXPgamrW/d7x2ys1RFPFKSNC8jktPT/ytPsoGHX5bvmU4eoZYEdrOYxXpdiS1fY+cNqHPh1ImCfEwCndws+PL0uBwlzASLFONuI5Ma5wfwN0evDL4vQkhAGZRkRD4T/+1Pg0KlYM/Jmys73XviiW//QvsQQLtMl/hASLPLtcrB85jlgTQgRSUB6sn6BTWNcZHG4CPHVR6p/UqwH9hvw11btjDgL1idCfRfGlEM7rstOkQCIHCoHhazJLf+qr3eNf4eiCaNpt9CVXZGAHCCxU0VzOIuz7mat/E85tdGtpOeggJAypzVPrM4+YPYwDL0wgX2XEEYyWjUtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KaywqWB0yeDqNa5mqG+a2RP9TZKYD703bqAFM2Qhs2Q=;
 b=GFs2O0u/Oxz1l7LcDgQcqjLX+gHDC1PKSqnZ89j4RyaKEcLr+rrXCPS7WRxZ7ZHq/J8yCLDPHFvbrEuWQgzwKYHqW3USMZ4Tac/9rXHxXLkCzRhTnnMCp6sKeFmwSDcR6RU+poCgrDqg1FouyE46KLgM+AjtyCURQ3qYX7OhrBI/maX0AK7g33jsKZaCjFvV66THfGUfCQKpkEKAN7kup7bygp2a4Cg9UQYyyxdRX4w5kjZROGzt1KiehMDo604an+bKDXYmP1PkL6EXQYccaU8v19FKiNk472mAyZMJJ4CkGPfaFvz7K1WGxkAEs1GObVbHgA77hJEfqcm8rzinRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KaywqWB0yeDqNa5mqG+a2RP9TZKYD703bqAFM2Qhs2Q=;
 b=aMWbDnQZbWcMRG6MokOmDbuhY3sdE9cdeeFfxiVN+dSagTH0y1pTWpY2ESvmMGDSyZM4mgCpPe4Vo+NL6h0lO+EOKm4/QPenAk4Pca5OMBqDaa1YcovzS8pw2R93AWGF+7IVh66u+/CTDwL6O2UaC8+BxBILgMkojRRvqvvLyS8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW5PR10MB5714.namprd10.prod.outlook.com (2603:10b6:303:19b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 16:24:49 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 16:24:49 +0000
Message-ID: <580236b9-d926-c762-0f9f-e68d8258c40b@oracle.com>
Date:   Tue, 13 Dec 2022 16:24:45 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 5/5] scsi: libsas: factor out sas_ex_add_dev()
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com
References: <20221213150942.988371-1-yanaijie@huawei.com>
 <20221213150942.988371-6-yanaijie@huawei.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221213150942.988371-6-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0024.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW5PR10MB5714:EE_
X-MS-Office365-Filtering-Correlation-Id: 16fac976-c945-4b07-6400-08dadd268e3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wbYdXATiceSxkwczevvkcR/4SULdd+54G3LKuefk7Rqaj9MBrOaI8P7WfIjHJkoFFHnyVke2vKVvBaaB6j18HT3+qe4+NQxfjXgvj9zMSXGUN/o/Vwpe/3oV6ZYWns2CbenNMJoAVaQdXtAuNnAV+AvS4/a8/eNUWOuAR+evWvUyH6WGWW8PmjrYE6qQ9fSO6gjyGiK+ZuJzZJAO7TGgoY5ths4/PbIOSswZLgrCdXyhA4s2AtS0ZWRTwJh20/zlGWR3kzpBM1IVrenT/hgC7A+4fgEpFQrXfYvuNFoWrYYNjF3C/zL8lbcazwpne6gUgrjpRsJU4y1Ej0F0SmDRdBRVs5frzSL4vylUB8iS4G9QgLKuFrY+xWK7LEJUJW44QaKuXtSLGzVshwnfQ4ugRlwZuzMYTU3JKrKqHV7ETxLdFp8SmbGIl9dC0efRqLtg/iU8KPL4UNwhkYXPpJ79qX/pGHtf7JX8Vr1dslJMJAkvNa0g4HSZdMXvSuyC0U9VimZozbyDSfgw+VQ+7bV2tIFXMJO4NeMcCNuKsyuuJAQeHNtTR+ylyr2hI0KOn+MJVY9RIeR61Q+CFRDstJ9fNFozk+OyYaaqBJluXLEO9zWZB5/7hGgHIZ+MFsXThxB+K5fvdVdjrYqHDuu30MPyL/TN4uNaAKfIJJNc/VdeTYzfEWPqbAtOmGHUzely6HCqw+cs6RKnrL046qo9faGrGt9ooG5IXfMy6OM7bR48BZs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199015)(31686004)(38100700002)(2906002)(36916002)(41300700001)(186003)(478600001)(6512007)(6506007)(53546011)(26005)(6666004)(8936002)(66946007)(66556008)(31696002)(66476007)(5660300002)(8676002)(36756003)(4326008)(6486002)(2616005)(558084003)(86362001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?anlIM0VxUjhsZUdUV2FYdUJDU1Y5Vk1ZWXppd1JFZXhwRFR3c3ZITkhIejRS?=
 =?utf-8?B?bTZqakJVTi9QVEVwOWtBSnRZQWF3OXpqSUM3Z1k2ZGVhMHk5RFJTOStaZHR0?=
 =?utf-8?B?bGZ6dXZCd1F2Umg3RlozbHJhUXZKRHBZTFlMQ0drVDBtSloraVRCblNsRm12?=
 =?utf-8?B?WjNqWUUvbFlXZS83NVJvYlAzN21LbmRsYUF4b0RoWlY1d2h3by9ROEtNQjJk?=
 =?utf-8?B?ZllmQi9VbXFoVGFPcHVTeDVrMWgwVjlrbEZRWFRkR0pvb2tFVzk3azdYUnhW?=
 =?utf-8?B?WVlRMTNBREs0S3ZMbTd5NFdKQ2Z2T2R1QXdGTkluV0piYitHeUFra2dyL1Zu?=
 =?utf-8?B?K1Fzb2QyVmtqS2N2bG9IK0hMb1dVcEd0M3ZmN1ZnUXJEMWhmSjVRbnRuTDVN?=
 =?utf-8?B?VTZkRkdRbXA4a1R6WUk3WGdwL09halhIYjU1MytKczUzWjhnZGNsbFBaVXdl?=
 =?utf-8?B?SmRVK1JYTm1SVVRIT2FCWVRQNXJuV2d5cmh4dncrU0F5WWtXdm5QTWZwTGhs?=
 =?utf-8?B?UnlNUWVNUUl4ckVKMVlia0dKVDlvc05mS1hJOWVHTXRmcHNnNUx5bEJhZEpx?=
 =?utf-8?B?UWlBd2N3VDhycFdScUR6LzBJSUwwRWYvdFVoS3VBVkowSHNMaThvRnZZT2po?=
 =?utf-8?B?eCtwa0NHTXBjMlJLSDBNMUNXL2lqRDE4ZGdlWEQwWjczckN4Tm8vVmFPOGxs?=
 =?utf-8?B?MDV0ZjlkcXlWRmN0Q1AvSVJYUS9JdVpVVGxEcERtdDROcDlYaE10aHlSd2VZ?=
 =?utf-8?B?dHo4TUFoeXRTajVtUElHd1M3dkdSL29LTkdrNlVYbW1qTDBkK1NibFhmTXJR?=
 =?utf-8?B?SnQ0djA2cWVRSXk0Q0JzQkdCeWRTMFl5aUlGWTc2Ym9waEQrNE84RnV3Q3Ix?=
 =?utf-8?B?djJtYjNuamVEc0l4VW5TZU1SdG9hTG9rY1dnSjV0Zi81VTQwclZIdEcveTJo?=
 =?utf-8?B?QmlvSjJ2S2JNR0JIeGViR3BNSjJHZGI1cGk4Ry9Zd0lYTUpVOVg4TzNPQzBt?=
 =?utf-8?B?cWxPdlVuZHJJd3l0RGVTNTNSclFZd3dUWmRlblArbk5xRWtxNDF1dnFhdVZp?=
 =?utf-8?B?ZmkxK3N2UjRhMFJTaDlhZUhaRndScHQxMWp0aVNEREVJd2JocGR5M1ZJMm9m?=
 =?utf-8?B?VXBlZURZWjNTNEFUU2dXSmhuMVA2NjBBa1BxbFpPZmVOcGhMYUsxcisxcE1K?=
 =?utf-8?B?eVhsQnJnU3pCbDdDNlpNVnR6Rld0eC9DUTVTNmVmOUZsZzlHbWZpUkhrQi9V?=
 =?utf-8?B?dy9WbGVGaUhqNXFVeVNvWG9WeFIvY0IxNFcvck9JVnN4b0oyTzZ3dFhzd1Er?=
 =?utf-8?B?TzE2VGxIRXA5enM4MEl6UWF3MnVFWnovck9pdG0xRUZlS2RFcERQZEhwcEtG?=
 =?utf-8?B?MEgyUUo4V2k5TGNZM2JsTFRZZ09RcGxUQitRWDNLL0dNMTF3cDdxbnNxT1gz?=
 =?utf-8?B?dVdUSXU5T0oyUXYxZHpwR2poQW5mQTNJSlRFYkFkNGFCYjZlM1Z1bm1uQ3dz?=
 =?utf-8?B?dVFhcEFjbStMRllCR2tyVnU2RGNzNVllNERiRmVvQjJlSFRESm54VmFGMkN4?=
 =?utf-8?B?TzVJVlBIdHVJNGJ1VlVHOG9tZStDczZqbEg5Y0h5cXBNRFJVS2diMWlNc3NB?=
 =?utf-8?B?aTRPSzkyRUdtS0ljZThTcGVLYkd4OSswanVMNUtucFpwSmczbmlGTmNVcCtP?=
 =?utf-8?B?c0hrdUY5enNvUzQ3MkEvc20zdkJrS0IralVUaE5vbUs1cU8rMFE1OW1jd0d0?=
 =?utf-8?B?dVNqanZudTBBei9BcS9ueEd4UmcyTE9UTmhZQWJWdVBzVTQxbjl6bkU4eW8r?=
 =?utf-8?B?RGR6SzVnMzh0NGZHM0wwWkhEMVF2RHc4K2M5Y3I0aHl6U1N4MVN6cFZLYkM0?=
 =?utf-8?B?TytEMldZLzBXOStETHg0bytnN0krWlVZb21VY05oSlRNbE1GODNMRnlSYUh3?=
 =?utf-8?B?UzRxNm5Bb3pweUlTQXNkS3JGalBCTmYwN09zckxzWmNxNG43c0xyNEVrN1c3?=
 =?utf-8?B?Y1Z5VW5IelNvWWVSOXBTNGFRVjA4K3hqdHNRamZkQUhrakRNcHNmWVMyTHdk?=
 =?utf-8?B?MUZmYUVnM0Z4WkJ5cmJpbmVJSktoK2dPT2lHUEtZTEVsMGo0WkhpOFI4eFBY?=
 =?utf-8?B?b0I1R0U5dDVQRTZqb1VEY0gwV0sxb04xYTg5R3lid3U4Y1p5WjdVU1NiUW5J?=
 =?utf-8?B?YXc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16fac976-c945-4b07-6400-08dadd268e3d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 16:24:49.3586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VqysDuy/SHydY+hlUe09rxFefjueuIqaBp0fuExFThcww72M/eqeYcFnj6j536vZsOahxTR6nnkJi+CDk8SNGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5714
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212130145
X-Proofpoint-ORIG-GUID: 9dg-6oJfSpIziokQ4XiHbPlA4f3aVaaO
X-Proofpoint-GUID: 9dg-6oJfSpIziokQ4XiHbPlA4f3aVaaO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/12/2022 15:09, Jason Yan wrote:
> Factor out sas_ex_add_dev() to be consistent with sas_ata_add_dev() and
> unify the error handling.
> 
> Cc: John Garry<john.g.garry@oracle.com>
> Signed-off-by: Jason Yan<yanaijie@huawei.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>

