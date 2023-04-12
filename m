Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79C37C7619A
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 01:01:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjDLBBF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 21:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDLBBF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 21:01:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460523AA8
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2023 18:01:04 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BL6x3G019804;
        Wed, 12 Apr 2023 01:01:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=YHUhLzzGKc6L93jmSd6GPLx27cMdSFV8L7BvdTTnkSM=;
 b=II33fYj7AEo5Lup5j+wTFdnXG6suP6IFZMZ+JhrtWk5A4VjiMGl0f5VXZScE58NfMIH2
 1Qp21akUCxfcCbsWpwGrjXmBt+3/Tr+PqkTCkr5ldENtc5STeJKRSafS6HJ4R2mVt5HO
 L7MU8ZYXrhXBIEQGfS0dwlVn9pyG5JVTn49G7m1tomIfyAHK+OOYUrISRP8rBIkPgIYx
 w/JHgsU3Yku+8Q7Ft9zsx0ylCTmyZEjxELRITdHVcdbQTHWSwAusriYIl6Pl26ZWnEjJ
 eMAvctCs1n2jLkAU+4kQ/3d4Uj976xo/bzYohul3gyHix+gPisVvGsYAGflKZLirhEIX Xw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0b2xuu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 01:01:01 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33BNYipd012831;
        Wed, 12 Apr 2023 01:01:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwdpt35w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 01:01:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JnKVeTqXCgdoERS6bF9yMlChs7MkwiyCqZYK1cRWEZAtLhTVVnaL2HL7TSnRCH2iSSOME0angi6orBcp60BU2KlPajb89dPm86KT0mvK6pW3/7cbIpudM+/6fOgZ5wNxkCxbRVoABz99kZpRU+PNHr+X+rlAyBVq2C6Cq6ajc+CygiaAX3MOT6gMMi9GvqqrWJbqr57VAqcNA3iPv9sHfvm6FHz+CgiiTLPpt7Jm8/IraMUHJJIkXrW978dpAuEccT5eSSyhf0aW8SWyIW173rXvGoCdGrraqrB1J+2SAiVN7JUXdV1XPqKhAj4V1yelXFBX+x6z2Fc2aX3WSP7Skg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YHUhLzzGKc6L93jmSd6GPLx27cMdSFV8L7BvdTTnkSM=;
 b=dUen7D3v80P07qmC085DfDX5RJWsvcBxBJlTqp+kkrtn5UWArb9Sa5jrIr2VedFuxHYEAVb6laRPJXRVUaLP+1F44LvUknGdtRIhOIa9BOtPoO1cMc6+csLbvew44VV2/k2IICKNlPrHSIdFjSzAQt0d0+uTGWFOSCcSK36KeAb9gDQ40aWcPANEFUWmbCdtuLKq2HW0oJ08MVhjjhwaA5g+wNbrcgYK2wvUY/sWrCGCgt4UMvXs0IxJ9fU7LuxJERuDyKQY8tI50B5teOyhHWjY0yCyp6+54v/ifO5w3tJAk8EhhdNZOWnv9NTOfZbZJlJYqTcHsSr0Z37Lb5Kb3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHUhLzzGKc6L93jmSd6GPLx27cMdSFV8L7BvdTTnkSM=;
 b=Ocuw+SGy3XcDnKJ42KlYd/drCCMnXBURwvRz5XY1cFHG402zWPP5l0YH/GO8MgBL++NPnx6CzyjuNL62nYno68KeKUkhSGcaQOg3QhsGPubkWzO026BCGiKkywCCbtGCXwO7g7xszif0Ok+Gw0WoPxEzNuB7B3NBCvbeWi8gY94=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BY5PR10MB4148.namprd10.prod.outlook.com (2603:10b6:a03:211::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 01:00:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98%6]) with mapi id 15.20.6277.036; Wed, 12 Apr 2023
 01:00:57 +0000
To:     Tomas Henzl <thenzl@redhat.com>
Cc:     linux-scsi@vger.kernel.org, sreekanth.reddy@broadcom.com,
        ranjan.kumar@broadcom.com, sathya.prakash@broadcom.com
Subject: Re: [PATCH] scsi: mpt3sas: fix an issue when driver's being removed
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r0spoqwx.fsf@ca-mkp.ca.oracle.com>
References: <20230403184736.6399-1-thenzl@redhat.com>
Date:   Tue, 11 Apr 2023 21:00:54 -0400
In-Reply-To: <20230403184736.6399-1-thenzl@redhat.com> (Tomas Henzl's message
        of "Mon, 3 Apr 2023 20:47:36 +0200")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0044.namprd11.prod.outlook.com
 (2603:10b6:5:14c::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BY5PR10MB4148:EE_
X-MS-Office365-Filtering-Correlation-Id: 7891ef71-7bfc-44c5-0228-08db3af15fb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZOBS78Vk2GYnv+mIHnKD1azA0lI8TwqAHJsCTdWaXn6AJRuzxHrqnAzv8n7QYwN9MEWjC+4ijH+AOB2LuwufU1hVtWzAkaUa1drvBpO8Wox4CHmtnyV0suXl2ZhwoXNhIh8B5CBnk0OtHaN5nT/bGXN6K/7ARz/hxyX5E/ysUbqIM2DbDpES5/E8uENePSEIQ3GenXK8Bh5gOY3BQZvU43I/S3m/m9d0R4kJiAtDPEuEfCUoaZXIyVs8WTpNsJfupos1lL/16KwkCmqV1PeiQWaXaNIsQaUxBJRVKmPaZWmQSsdJ8iPfjOyZj7jeHmEKLjrseWT+fs3fHFZIFKz4xZFp3f4IV9CKDKQO7nNkfSSozWEpa/wrS0WWX/hfnO11T0n25LiutuEqUEP39odvzelIw/8pWXrkk4HgjXlyh2KE/Ym/8H+AZULQK0Oac8dKAu0SQzG4DzfhRErt4XRVoEwxT8qlfgdvsE+QKzc9Ig84+vy6nNR1cobkZfHmh6uKpMo6icwRmLiAD7dJqkqsmuBzJyVjK76pgOecpRaESy1rgidYctun2ujlwbfvMcEb/6XCcEkyWC0MNdnDCiftn8V0a1zThCI/o265O6Exxlk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(39860400002)(346002)(366004)(136003)(451199021)(86362001)(4326008)(66946007)(8676002)(6916009)(66556008)(558084003)(66476007)(186003)(5660300002)(83380400001)(6666004)(41300700001)(36916002)(316002)(8936002)(66899021)(2906002)(26005)(478600001)(6512007)(6506007)(6486002)(38100700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AgaJKBEvEWHu/WX7GX5xBHXpSYM8Po8dUvKB0SZuZia3aITVI4m8+FImXsG2?=
 =?us-ascii?Q?S9OC5Z4MSzfptzuz6jALp/9eYcNZVDjv1Ugn6JAhT/T+98vLkFNy2GobE+XY?=
 =?us-ascii?Q?IJTaJEfmLZkApPTqVsiAn4Riu14uKLBmeFKtdyrG36OgKn08AYTcJMyRVUjV?=
 =?us-ascii?Q?VgfP1Uhe0aju+bC6zZQZSo19mwoyt9AD1zOyCJi9VhcOT+6/VM0LydKzkZjt?=
 =?us-ascii?Q?YaWF9F3IfCZOLLwwHo7UJOSjKyXFKq/FysciDAdikwLk4mvOO/D6UnFz6oT+?=
 =?us-ascii?Q?n4zfUyhqiRQI5/L9WJj9lDQGqF1ztzPtmSZqRf4KAwjcdrx5HGBXUH2z10qR?=
 =?us-ascii?Q?lD0o1CU/rtEXoFt5PbIhhGtGuRtRc53/5Ual8yha8DJI246dV5cY/I3PthSV?=
 =?us-ascii?Q?D4kZVB4+WIB/pHbRDTsBqEQubBlLoNOst3X/lhMWUzOWIUo14m8uVS7TBppe?=
 =?us-ascii?Q?ZhffGfmvIdBZE/mWEiDjHcXvbqXMQ8HHYOS4hgSjyvIgsyx/q37CbwDKh7FO?=
 =?us-ascii?Q?Y23uJ0u7Hjq3URbHhWyuZC6gKJc2Za/al1aKqU06hD/SbCltcBsrpItOfQdL?=
 =?us-ascii?Q?p73o9YifpExx7HfdkmMDTfn1Tx82dBqExRe23WDnhgnIUnBkCSGCOe5Lx4Mq?=
 =?us-ascii?Q?GuTRwNvj6lXcLEOqygN3Ime2op+vKrffnkElwGxyeB+0adEKj9SzEQLNAaoy?=
 =?us-ascii?Q?bPRBizcqhYlEG6PuC8v6N/XqzX7uekuNF/tg0Ls5wthWzuPpDxrEb54681UG?=
 =?us-ascii?Q?pm8dC2zs7uEd27VBiN39B8mcfs41cXnWCjfoUf0HoMCzVEDDhGH1rVTuUVSp?=
 =?us-ascii?Q?LvC4q4ESEZvCZ1wBe76A+XilUFlnr5SYrDa1ZCrGrNN95AUjXpSQWHNVjTKw?=
 =?us-ascii?Q?B1sODCsz3C+JNFQcVJI4h0iOGa2txf8qtBIbwO5icI0kZdXw5E3tUXe2gWRE?=
 =?us-ascii?Q?AdPJ5s6ddXp2qKn4pbUrpKS3Esx/ceO0PWpmn0j0dxlYe2ZQ6rCvpaMsB2ue?=
 =?us-ascii?Q?we6ICaJCgRX4yOq21ALcTKcIDEfKdMn1dLTdJfqRH7J2ig9oVK2uhLFRr5h9?=
 =?us-ascii?Q?BPO0Z8Pzffr/nZo8ttIwI/PJprGitMMxr5EEw5GdgBRvCdbU9nkF+//tBmD+?=
 =?us-ascii?Q?w1d4dsqjIGspe+0f9yKDo1jurUoH47zV41p5Szvh1iNHN1L8ysuPFc51sT8s?=
 =?us-ascii?Q?GTOB5t1VNeH5e2VEUbgq5HJZ8aUpKfOZhqmGy6cPRqSVWZuElwUDR7g9apqe?=
 =?us-ascii?Q?RVp0V6iYGWbjJtTN3vFFMAQjVH4FUlaTdoZSjzKkhlRtzhVnc1jY9YjtEcAW?=
 =?us-ascii?Q?K62JWRSxD/XBk45HcfBlaR7PW3qwd96kq9p7tcK+vw9cxigBTOrKyDSlQMZf?=
 =?us-ascii?Q?cqusUex5hpMnvZVYGDyNsrDIc8HD7p6xn+qRQUeK1qYXr8UJxe3X/M9mNv9h?=
 =?us-ascii?Q?OFOO72sJJZIpfy8Xw3pdbstGt4CF+eYjNXzHmU/w2Nimjp+l07QW21X20l0B?=
 =?us-ascii?Q?Toyu0AO7HGJri841KiE+Zpoo9qdS3r2+mgfj3BGAVLXReb1AiH8tH1ia+3Ad?=
 =?us-ascii?Q?QMt5j3Uqzdzx/YG5oN37GtpDqxo3DDjCsFE3DvKbnyv4nVNvS75dve/qbOzR?=
 =?us-ascii?Q?BQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 9oqSVi3g8oEdEetOUL7QfyS3T4roBQYTrMDT27fLW7rT+erYbZnV3WNXgEieiTI+oDFj+2QaCHrDzvVolfRkmPux1ogDXULAuGkWhLh2+951/ecr6J+A2VLD4gIT9DEpE3xVVVsQcm/tkJ0cgqBCY6EKq7yObYIlP2MqlrY/1COLdVs+NOVqrMs4Yhs/fy6z5SUI3uUXeVgalmQXf3kGDoFm4ySX/+hNFoZogvUcn93LWqeot3Uy2rhqpzl9oMxeLPIxW5MmYzSGoke9NLxLTdHtsxo3dYlblZF+4XI/clvQRTlaBJHHrZa+arvYaPiZ/5zkPn22+SOlLv5yR9iD41361hcWX1jqR8Vhq9tUDKKAZfD7tJQT516sYbXm4ySg/tHN2WGcWD9wsQYISodRR1moArAmBNVXCiJSlDLukFbOeYoyjyhuPnKopr/2VEc7M/ZNFD+xWBY2RJcF4sQYELmqXGAZBgKu2z+3HnvJnzw8L2I6QcKgY3IAu/uBd6Yn2G6BnLsLzcvx6urq2W9EuEsPi6Bkmly0H9vUkBBL9WNGKzy1AuAYuaYlbVACeSKzBx0D4UqInobNzui7fXxiohHNi4QqTNUreQz2ByniY3YLG/P/4adGa+l1x9lwvu82M9NNbhicrwHE6fscml4iOkEHSAXKkYI4DdcNiE6L4HmchhBSu26mYF6MbEef/Wb9kZaSCoEjNuIz8GHolleGKU/XlHb6YZe1c/dmHkApkk7o14QF9JWYyjato3ZDJ2pAVMwdetgMCrufMwIdNIu8BcGntg362RQeY/HViQLnmoEaWl/xduLqjIfXMulr0Sf4FshHkE4yv05cMDaydGoCXA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7891ef71-7bfc-44c5-0228-08db3af15fb9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 01:00:57.2353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZzgKbc0LM/31tsO4lJS6dtIdDCwHSSkQR4P/JGnSLFmKLC+TpSrVzwKwZpFIZDM63N+PWN6qkGwdfl/KvCnEp7H16k3eLtqYIMhdAanhNNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4148
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=800 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120007
X-Proofpoint-GUID: aS-mN59yDY2_Mt5u-R-HePk3l3eAdvCV
X-Proofpoint-ORIG-GUID: aS-mN59yDY2_Mt5u-R-HePk3l3eAdvCV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tomas,

> Warnings may be logged during driver removal:
> mpt3sas 0000:01:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT ..,
> Fix it by deallocating dma memory later.

Applied to 6.4/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
