Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E285C0015E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 10:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbjGYKgX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 06:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbjGYKgW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 06:36:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A645131
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 03:36:21 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36P7oYqm000839;
        Tue, 25 Jul 2023 10:36:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=aB58mNnpaPw/2sSd6jkJ4BvhKN8jiN8UP4zShag9xos=;
 b=nt9PWmwRYS+xSfEOPxb/Nm5DXYWsM3LJn4+ilMGcAJbAT5QWEDoIYqEpHA14kVJJN3vW
 eoKSVCf3G6c5OIF1oSTAz8GgT3ubX/tvj3Y3MEw8N7d5ep77kyCVnzLrN763HGHrkLwz
 fdrKe/rCiQQWPRAzwuebQUVV3KlLcJ/ccwwmhRQ8I9w3kSO1s9aG9RjqavkPBN/r8hae
 BEPwjuxwn5ol4EvQu4Yu7yYgHAv3k5h/7MG6tpqeC+0rRKrcLJv4w64lsEchGDwVfN81
 NRJwctbHsGYQHSVbSWyOiTZSFO10f/r1mzIuAZWeVE12BdrjrNgxNy+t9wQ9Uxd5az2D 1g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05hdvr34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 10:36:11 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36PA8qwN039906;
        Tue, 25 Jul 2023 10:36:10 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j52vwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 10:36:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNGtMJrFbimxXd3UYfQMBv7Z6uxhqjTkJJWznHegQ/v/6+sL5ohvncl1l+FPARJGi38bzO4nLNXuVSMATAJQx9MzR3uosTtgnlli/SL3HupfYqnq21msNGyZQjVOsBQdohsimuU/zfTvFYSeK9rwgZF53zgMZXyUGOLmiqUehYuHy6iQdNJbPmFM8yfwS91Sfd8Al5ze6OtkU0fmptVd1GRudA+NYsFwIVL4HZQjVawmsQ8IQ3g7ekO9+nB/ktMKS7Bsm0BEBHqsxQ0yiiuxwZFBnS/fqyJf6kOBXH3zcZic4FqkFTI9ByVttyrToUNesfdjgOxew7JmeJLkUDAGTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aB58mNnpaPw/2sSd6jkJ4BvhKN8jiN8UP4zShag9xos=;
 b=gKYLYR8itoFOT1LUF+4JLMfIRRpnVxhWCHb6TRayYzvF0LZX5kPMfAVLIwZe1C5si3b3P7KoBl6CO8KAhoPts2Q/qA86JhZj4I1wVo/mrfGFgrg4TJYuYMb2oqYvd20yQJ6TKEv95cMDOVemQc+bc+NZov+jm/8BUq27r11OWFn6ZZp6Sf/SM1CCe3+AXkRSQmufSvzBGIHzAvqdGoKtquwJSXNvQIZ1hWtlseqEDw1L+XD28TE5VEfVWvwhm8tPGBvqz2QPGAa/YI8OQkAqlgsRapEgNRHn7YXlj3Cl8ny8BbzV2pDzw1fpH+KDo0341d/4zDzkDOPAUmokxMLwPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aB58mNnpaPw/2sSd6jkJ4BvhKN8jiN8UP4zShag9xos=;
 b=VB9/a6oMltnj5SXgjr3aPogfi1adWRNr4SdhegFQV0P2QPUgDq8/+BwOr2uXjlRnfBCHXG63V2+W0WQHiHPCKDi/ocaejq1WSfCcapwNlYMAHJyJkKGbQNxsgoemrzJverx2FLrI2mOxJG0dOAR6JMFvs0O99+EtYCNxezoF4LA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4653.namprd10.prod.outlook.com (2603:10b6:a03:2d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 10:36:07 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Tue, 25 Jul 2023
 10:36:07 +0000
Message-ID: <705507b8-5e9b-9967-a89e-3dfe66ae6414@oracle.com>
Date:   Tue, 25 Jul 2023 11:36:04 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 21/33] scsi: Have scsi-ml retry scsi_mode_sense UAs
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-22-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-22-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0029.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4653:EE_
X-MS-Office365-Filtering-Correlation-Id: 0abd19b7-3a6d-4131-057c-08db8cfaf429
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CCPOhSthSdbc0aNK9Xa/sHi7YjSEiu3E+u599xJeNsQKvW6G2agzA2t39UyFlaSDFqiG+sfAt267IFMwbqenaTwCvPxjaWzwGnFuWoJ56+D+16p3ivMSJnGF+dAa4/8v5lvBv7JU60JofwF4q8qyH/Ip+KiFkOqDbtODf48Y3l572Ag7FK2nyGVcx469UUHgieEtaTy03RySlx49cffM7yGWI9fKTvBIyhE2NJaDZc8UJGj0F1D/HjkbkngGsQwW0L1rG/mrdUtUGm9qy1g+w9rBzfBCg+p0rJdfVhC5nCpzNlk36+vzxCxLsLg/fEtpBp/mBrah9I1gQXn2KstMrhTR5AM7StZVZiyK8fW3D0RtHoyqcZ+L392KsdEcBZo2vZoy5cvhI+7m5eBSJaOXbeJsCyWX19HG3pXOxE7FaKrMT0uyJpyb+68DO+F2Dj91+KmaKUbaWQk8O4euZpCHMebIMnWOtPnhbnBvd/sBSA5uzITqrRfS5rm+OV4uHb9Xs6tRl4mcCpc695GGirFKZhgzvA9qhzf3EG/jN7DFx/7/E3FK0MJIK8s7hCSB23oiUGOQMkoE3IklORXLI0Z5J+5KQzFCG14ciicpfm57R/up2zrhCD16CgwQIA0uZGABdvkQh8lo1RHlm5wAvQQ4uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(366004)(39860400002)(376002)(451199021)(31686004)(26005)(186003)(6506007)(2906002)(86362001)(31696002)(558084003)(36756003)(8936002)(8676002)(36916002)(6486002)(6512007)(6666004)(478600001)(38100700002)(5660300002)(41300700001)(66946007)(66556008)(66476007)(53546011)(2616005)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWt3RXJFMFMyU2ROTTZ4U2FrNHdNSFhONnhsSVNpZy83R1NtZkR2MnVVMjM4?=
 =?utf-8?B?MGpCVkRDM0IrVjZvZDlZMytEeWhUWEh1M01oSEl3RkZSa0s5WXY2aVY5Umh0?=
 =?utf-8?B?SVpabzIzUVd6bFFkNWh6eTg4SHhNdGttQWFvRHcwYjd3YWRkY1F1anhQZ3Jn?=
 =?utf-8?B?cXJBUWJLK1kyUnpBcGhkd1Fvdml1Q1UzZVdIcVhxbzkzY2dtOWxQTWNDSmg2?=
 =?utf-8?B?ajBtWllWRjQ5RDBKSlg5LzBkWFA1b3Y2ODlvdjBmNVFCQk8zckw3V2cwMFRK?=
 =?utf-8?B?ank2UGlVbzc0RmNjV0pxdEUwRjFJZnhiVHVlSUxtZXNvWUFwMGIxWkVUdjhG?=
 =?utf-8?B?WTErVjBUQ1ZZRjdDbHdQUU1hY1RYdmViU0xPZGphMWFJMWllNEQxQitCS3p0?=
 =?utf-8?B?R2l2dk9xMm9sSHp6RjNrdFM2UTdaZ0VYNTBYeUpVcmxDSUtaM2RTZGJKVDhk?=
 =?utf-8?B?QmFxV21nb0toc1I4cG5xOEZ4dHNBRUVKZG9zOVdFSnQwVFRHN3NzLzloR3g2?=
 =?utf-8?B?TGVxRWp0cVAwK0Z1WUk4NzNNa0RyN0liMERhcHhPWUFPajlNVnU2ZEFEN1JF?=
 =?utf-8?B?L1F4akFoVlRSL2U0M3VSOU1qRjh5VXdrcmtlNlBoaHVVc1pheXJsUnEvV0pa?=
 =?utf-8?B?bkg3cHUwWHhNKzVsWkNzVy92cHlibXR0L1B1YWg4L25qUDdLUVVMdktJdGJQ?=
 =?utf-8?B?L1Z1ZWMrV3FwMFQ3RnowZnpwVytvZDBKRnEwd05NZHZ5aGdscTE5dmJLSWVm?=
 =?utf-8?B?Y1drcGhINWd3cmo1QmFxNEJ0M2d3UzgyQ1k0eG5zd2ttSkpQWlVuUitPVlBF?=
 =?utf-8?B?OU5hU29TN3N0TlhDT3d4UUgrc09Zb1creFMwOFVLNlRsY0xicWN1b1RSRjYz?=
 =?utf-8?B?WUJIZytQdVllajRObS8yWVAzTlZ2b0hNSWlWVVo3MDBBM0VReGNpNjA2dm5u?=
 =?utf-8?B?RmdhcHlHMnFMSk0yYWpBSTNSSnhqUU8vOEw2eXErWitGRWI0VVVZdlNRNHV0?=
 =?utf-8?B?RkQza0FQTmFPVGhONmJsVTRVd1lZTXI3OWYxNE5yRXZwY0EzVm80NURFaW5K?=
 =?utf-8?B?aXVSczZLNXNHekhjYzVCeEtFbTBqQitUYldiQjNaRENoQTNnUFJvTVhqVGlC?=
 =?utf-8?B?a0hTTnppVEJ1TGtnazBzbS8yUE9UVDhFZDB3OTRmSjYwTHorQTBSWUtjcWVy?=
 =?utf-8?B?STV4OU4vQmZyeTZrMUpvMUJXZnYvVk82SHFhZ2Q4S0JZckJLQmw5ZjZxb0hP?=
 =?utf-8?B?TGg1T3lyRXMvdW1SWG5hRWFyUUM0eHU5b0VMNEIzMk9KdmZBbGFiQVRWUmNu?=
 =?utf-8?B?Z0hWOFFlQ0RRVHdxd3hJcExOUm1FVHhBdTF6eTN2RHU2TkpUVjBpR0U0ZlBr?=
 =?utf-8?B?eitmclYvTHRvVkVBZ2F2cldpOThWRy9iMHBxNHJWaVA2REFtMjJBNGY4SUdi?=
 =?utf-8?B?eVFrcDJFbHVNbFFlNWpZUnpOSkpGYVVhK3NJeFMzeEZPTnNqRnZKa255bnZV?=
 =?utf-8?B?aXlreDJLVjlWRWhZN2JTRXlVZlJDbTdVZTZhSkRsMjRIWVB4em93QU1JMWFN?=
 =?utf-8?B?ZVhua3U5L2RTbGpaTElldUJMRnFaYXUzSVJzak5OT2E2azN2aXlYMGtFUGVo?=
 =?utf-8?B?Wmd5eVR5NkdvMUJ6aDlXMkxLamFNamIrQldrSnhyREg3VHIxTWs1bnBOMnJH?=
 =?utf-8?B?SXptNFJBSWhscWozWFlOdnVxU09PYkY5THpub3dFd0x5L01OS1ZWSkV1a2Zy?=
 =?utf-8?B?UW9iZUhMWk1VeTV3NWs1M0dyZWU2bEFhSEo3akptWWFSSzM4WXVVYzZkZStD?=
 =?utf-8?B?NVZzblovUWFOKzhISTRkTlZMSXpqcmltQTVDYjFWV3RoRE5kN3BXWDdRY3ZY?=
 =?utf-8?B?OEhhRFhJSE9MNW82Y2ZwOW5GMWdKekc5T2JEOE1yQ2k5L1ZrcVBuWmhFK21K?=
 =?utf-8?B?K0d0eFpzU0tzYTFNMG82ZzA1L21BVWh3SGppWUdWWlJzbkVmN1lIaHJJWG9F?=
 =?utf-8?B?bjVQd09hekJ6TlRyQ2VvTlhIVE5aTFdRdDNvdExIUWJvNkp4ZlMrcWtNYUhQ?=
 =?utf-8?B?SjZVRnFuOCtuNEd3MS8wWW5TMXVYem05WEVOcndEdjJmcGFUdjVONVhvUDYy?=
 =?utf-8?Q?vLcV9O+f335IXwStmXIN5Kx/W?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: eSfIinE27eQo2kC4QH4rE8J+SGhfKjXZjukuNCTr0uDb6YwsIZTPjqUsEnYovvIIQyV0MM4loqiDgiuKrGy8VLZqwSTs948fTFfKCL0USAlH3iwWQvQcS8AnN8FEGoOP9rYAjwHXVh/kNOiwkzSDZrt65F09Xr32OKOvVMIPvo1BwXIeGVfilAHKQvh0uDuh/1wQusXAxowyEn+Sxcb/1p805tW+qTIqjwSm7nrq7MD9rsBWtgRBXUTP5Kmf414CoaNkm6RY5HRaEjALO2VOsEKGbNQWPW7PvTGDbeYzVV1QXCE8GgE1R0hLljBRyDGin3wCIEpanDqWur6SRWgAbPf882OcpYdg6wez7sffk71xOGwoQ8wUGFhYOQQAFvdGag83WXPD3O+vM6P5bvPvbWhKGP1nm6YhX6xCaGVF/Ka3ig9Yz1I9MWcO+3WZ5WoR7DUIbKcz1z4BW+CEi1KFBkjsQXAfb5Ry1mU9PBodu+Mll8/t6ASrbt7egZ8S2GCCtjzBL+isJpAHkZ8usbJ//aTMpKa/ss2Bqc4iSSUEmIzFJhsWIG9scCVjsW6BwQI79rBHu1g2btoQzO4FYjCU0Ve/QDHm50B2BdzxGtxsFtPjY9h0eyNaOqkR1wFVFavkL/u97pJWphJzYZS4Teosfsx4hzNul6Xwwj37JyxFLKvwWwW/MhxHpGlYCzCxBl88y6k+5n2tv/U/ixq6N0lp0W0JRIa3f6jJ+4ihEP8Pr7ysctBH9dip6jb3FVWaj7xnU6ZAJI4lWN0LoVXnsqDXIiYBFB5Wqxz+rjJo3CCUGa1JWC+2r2DULKsffrESlclCwIlVt3Ir+E+XNePve5cugBhQ7z2Gi8fKDfpdbynZWSG1vUjcAQOeDsqMYrqpJz8a
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0abd19b7-3a6d-4131-057c-08db8cfaf429
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 10:36:07.1582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J+nlG7RrLSnFI0B9BsGd2QTH1xQT6Rh/FfdevQMnPgWnOQ/UL6tPgRzQl/sCFxriKZ/AK2eA0/Fp/7zUgl1wtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_06,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307250092
X-Proofpoint-ORIG-GUID: KqHD8kFcYpn4zrSyv_WKnn7-nj0qqTpC
X-Proofpoint-GUID: KqHD8kFcYpn4zrSyv_WKnn7-nj0qqTpC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2023 22:34, Mike Christie wrote:
> This has scsi_mode_sense have scsi-ml retry UAs instead of driving them
> itself.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig<hch@lst.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>
