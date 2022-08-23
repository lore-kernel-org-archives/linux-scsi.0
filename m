Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D93B8C25B08
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Aug 2022 03:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239736AbiHWDvY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Aug 2022 23:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235448AbiHWDvX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2022 23:51:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCB15B7A2
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2022 20:51:21 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27MNx5Tq002899;
        Tue, 23 Aug 2022 03:51:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=pRsJsbKJ13qQAsPBpqVIcYbkTsBSPaYhrwHwIV74FM0=;
 b=hY/Gb4rPInwk4bLTh6MJeMg29wtQHU5icbjcQii3jStavBqZ2byHxONphy3FImFXUTEh
 9MKCZ3nkTbstpDXZUPk+XUrqHbYvakHZSWy0++sNaEtL7fHPaZhaygG3UhE7G1wFYlAx
 R1RzBmfz8FvjyPVfHNSw0yYEPeMy8i9c0R8G49Zn25QKc0Tr4wttD5n7WqOY3GHyXf4m
 AujBrm57Q4U6ekcrwohIgx5uDtN7LRxTwfkxCFm1tcQzltzrvcEiKineeQHD+GjXRNpk
 Via0IOBf+vUa4Q4wb+p4gGzMFzZPOxN84+cbG5svaKjXY/C3nZu7WiLvkXAbKOHW/9qR Jw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j4ea7102h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 03:51:20 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27N0mkAE035368;
        Tue, 23 Aug 2022 03:51:19 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j3mq2dpmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 03:51:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UrRrDZs/Em4XRjOr/Wigna9mb5S+AnxtpBl3mc965t4I60EjtjWe5OqNfB5uFj0yj0w2X8s1tImJL5kLoMnpa7sIkeHKLJjB6AUw1LL52wKpIMzq6KoHGevAtHwW91qO9SZsdJwT6+9lBKrkzo1+DcLcZ+2EHnLBIpnB40VJPFoCDRycUnypyi8zvZyfcqgtSmbUxOgssS5kpM66d98al7qDASR5uceyaWkrDu2OlG7hMKhyFRPKilTco7K32qvsHgZGGTZW2BWuRVC9Kzw+iEQMGKOaFxMKTb6numEu8Xw7+UnPGD7pU937MjjVaRsECn9XDO18QvCuAQAU8jbvmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pRsJsbKJ13qQAsPBpqVIcYbkTsBSPaYhrwHwIV74FM0=;
 b=MFi9R4+BD9XD5fOxFoyFZk7C2gEBUr3wBc4SCIiaMzHq0zmfqkoglBVFX1rgtaSgc18o2BBCnH/UgkrYe04tbOF3dgpcigZsgZjdf3aFd8mIUZ7ZxLcyJS6oBUJTkiyh0Oz3k4IkOctDOtnfvoDaUZXoicqc3VIwJHis2Fdke/mzU5I0gzAxxV4ExuaHndUGou01wtD1LYzSRQ2TkELfhWijUkXTqceYkCqU1B1xdCpW8YD5POgTzC7uuTcm7ssR0pUNGkCiZLEHeY2p3XedBe5ez6LFYhY4FVwBFV1S2BDhLE27daReKSQdLmFFA2rqKhdMEzTule+ky/kohBcSkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pRsJsbKJ13qQAsPBpqVIcYbkTsBSPaYhrwHwIV74FM0=;
 b=J/2eAUcgayuTwhVj5t5wPKXzoYU9mICGDbYRnErKK86pTldH44HeIcABk+7I3tFfUePBzIGnLu1xpyOFRZAOBvwGUJPovj/8nZMsuEZT/WGq/jntTvyFaWit+1FrwKsLjKVLjwO2qg/GcvCP2cprLGqeJrHUEPgnHb/wFrhuKiU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN6PR10MB3455.namprd10.prod.outlook.com (2603:10b6:805:cd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Tue, 23 Aug
 2022 03:51:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::89a7:ad8f:3077:f3c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::89a7:ad8f:3077:f3c0%8]) with mapi id 15.20.5546.023; Tue, 23 Aug 2022
 03:51:17 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/7] lpfc: Update lpfc to revision 14.2.0.6
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8qj8vo5.fsf@ca-mkp.ca.oracle.com>
References: <20220819011736.14141-1-jsmart2021@gmail.com>
Date:   Mon, 22 Aug 2022 23:51:15 -0400
In-Reply-To: <20220819011736.14141-1-jsmart2021@gmail.com> (James Smart's
        message of "Thu, 18 Aug 2022 18:17:29 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SA1PR02CA0005.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::10) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c97898b5-1b31-4df4-f441-08da84babb82
X-MS-TrafficTypeDiagnostic: SN6PR10MB3455:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Es/Gz49FEOYZE9/uRj6G3wV7DCDWdusmgCTSBT97FUafLLKP2sjplBkHHQ1wWX2WmZsApPxto7NDCkBoMpNU705qsRdUpL56DnNQqHnyrqQt9ifP2BvRD/OKgSta4DN0X6pq/PiWUxBv5761gFWTyHCjn+7vRzQsrb9JXHcgKRoPFK6TBIJ2W8jqqJmK9wjMMS9pBPP92DEB3RecX865Fa1xVsr/e5ydddKtVZNHD95Ux+JR2HmmaDNcEdccpfcZMW9/5FIVg4Jd1V+kFajSVcIfM2FaQupnZ7KLgH02AXUrKl4tF6AtxqqEGKY/YRLxB8L0pxeT0YWBF4Ltfm3adnprBVNxjljCE6NJvancllsNroClTT3mfawdgfArpHxS9qYwo1im4hQMlUUIIyd7NM54U1AkCKpXqwOORLQmHNmUgfkCA6gA7X9LyOtQa2fCHatBhc2xakowBJBtAv7XaBsglhFFuG6kCLlW3LiiRT7DewY5lFNyaCHM3Nl3bzIx1djIJdnvykE4U339LUJTgOkVy76fAj6aVHRx8oA0zd2RLpbhLi7xq0RZ9BFCVs18HSadHlcqWtVZuLvbTAyL/vLAZ2PBdN8GKqywP+V6astX1O1D9rffRzgxRRDvhOs1jQifDoCvBfnmmQCjd/ITNhixL54TM9WxL7bdTIxirbhj7pL9+WxNOYxHJ9HfeYfF7vsPjzNKEw9eyLhG8LrTU0mIAtGb45CKBgLKjpeo2z6csGxCLNNcwSUVHKQqFIJ9T2vH056O3xY8yHnC186wPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(366004)(346002)(136003)(39860400002)(52116002)(41300700001)(6486002)(186003)(478600001)(26005)(83380400001)(6506007)(6512007)(36916002)(38350700002)(8936002)(38100700002)(5660300002)(66556008)(15650500001)(4326008)(558084003)(66946007)(66476007)(8676002)(2906002)(86362001)(316002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I/hZ06eO0uOKIdLYrPVlwjiRpo9v8vTqEEfPfAe0xHoxSci5yVaSh0Zx1BBL?=
 =?us-ascii?Q?5tctfw7Ta7Z08+Q8mIb9f5xlzXQwVxTsiWAKprVbpOhrbZeDrDgKRVYn7LWa?=
 =?us-ascii?Q?7axnRxuIhKKmxr2i8FBL5RGyhUvFVpBsntw7lrDC+HMCdgO8UjUxmraR4pDQ?=
 =?us-ascii?Q?pgcVMRgngC8+ArUHUN+4VIdFn7DivS7Sv5CQn9M2tKXAIF7VJSe5/VVqa2tp?=
 =?us-ascii?Q?ENRHb5/XkeGxrd21hanPISB7ER/2RmAeYfJF17asLwOb2VG29CxuZuMfd29O?=
 =?us-ascii?Q?+jBR6zj5r+zQEOZcNLw2G9CUhgX8aeGK70yY6cHJ/Or90gbKW35/fCkDXKTf?=
 =?us-ascii?Q?X8KFtWq3ZRr5soSCKUfN8ulHACYqlUXAF+WVaN77+mct8Xp3hIGw1NwKYu3a?=
 =?us-ascii?Q?FBaToFNUNvNtM3WpESf4rDZ4htWizFYjQ3sU1AYVRf+CBotvyHAIISGH3GMW?=
 =?us-ascii?Q?YraIA9LNDfwJk8Ui1MyFO9bb+Mf8jNciLSlzElgOXOEFSAeZiPELgx/OFREQ?=
 =?us-ascii?Q?/qHP9LwX7jMKKgduvS/AsThcQXKQEp//na9/t4JUipMmXXiUrbH47JiU2C/N?=
 =?us-ascii?Q?3yvsMJeqTYTs48P5254vfh0O4VSPV684iBFj7gJ+vybOCqvBA0+Sbg/cfNWt?=
 =?us-ascii?Q?we9xw3mhqtzSm1sSVNp9xozi87JUs6+iMV5xd9ZqGiN/Wuxnwjuior8Y9B/4?=
 =?us-ascii?Q?tgQavpxkJk6bdp9ukXrZVLLQ3S2UFPLP4l6Ft8fowK8kVahgRWPv4cIcnpzG?=
 =?us-ascii?Q?18I9tgndkxaxceqyY6Fln80BNA4EXod9pPuTJuh/myvPiDZ7JxkLJKw4Z3Me?=
 =?us-ascii?Q?WKzaneKgLucMcpOTeVB9gAnQeyRBUb+/FVAFhO7K1gRboumKq/P/Pa/31So7?=
 =?us-ascii?Q?2FQa9z6UhA33EuL0mXIQ8V0PTAw5PVbgzn9aGYyI8+Et/qX412h+kvcHfgOC?=
 =?us-ascii?Q?KuJuLbQalKHnGRax7lf/uk5joFJdqMKK3zLPmxFkwcd6hOiNQDh91AMIfOVR?=
 =?us-ascii?Q?WbjwTZtmD9cnF8pQqoQ96MNtR6QdBl8/W/5FfpNeVUnUhnXls6lQrp9v0jrA?=
 =?us-ascii?Q?AFBeQOWM5LTN3g3CSCspkjFPsN1GAPqG7b+/8xeVz0f7Qy/oxdNCRIoo9G4d?=
 =?us-ascii?Q?4j8HvyLiu1FKJTGJFUVB5t27VmQ7CfALp7zGHYL6ovQkCNkKVfZGcE+irWud?=
 =?us-ascii?Q?jciRY9RD0A8joiaA/1AxOZTZ44aueQtpWVcZueGkeDZTCJauzLKMGNVQ10G9?=
 =?us-ascii?Q?xT/W5+dJRM8eP7Lu7WKC8UEdqLFV6ol1AorHdj9F0cbKUvmLsq/0T/zzH8WO?=
 =?us-ascii?Q?ctriJv7m0u0P1O4k7h/8H0F+FoP1L1OIgn8UbHVCSxlk4/SU8/lfmydnxTsv?=
 =?us-ascii?Q?t5wx0tiEHyhalcY8FfrToqmSENuY8Dey4xXNO2jl830V0qp5ZS2kwwUAc9fa?=
 =?us-ascii?Q?G8m42HfHJCu5LfKLNsfTF4sWUexjUEFGl4GiokuXyoRfs3zzTtW2pw7NlY55?=
 =?us-ascii?Q?PpO/wc6FB8bQ3DWcSV3s6UXsYnJSvxL/3onX/c4goXfC07a+VrepsaQrPZQl?=
 =?us-ascii?Q?IuZueWShyY5a9bL6d7NsmGwUyhMiMGV+eE06667AZGpAcxqoU9ji0J0aun8t?=
 =?us-ascii?Q?uw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c97898b5-1b31-4df4-f441-08da84babb82
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 03:51:17.3082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: whffmUP7zD1KIwB9n00VZHSLgq0UNNe5TqcSjrXS7aikgpBd66r8LFBikzkLk+DwDqBZmCF4F6F67xMOeGF3ZBI6uFeKIzJVdBQX8Z1UGtI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3455
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-22_16,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=768 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208230013
X-Proofpoint-GUID: eJpIPsmOyWcu3nlKC4RcPbtau1W630y4
X-Proofpoint-ORIG-GUID: eJpIPsmOyWcu3nlKC4RcPbtau1W630y4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Update lpfc to revision 14.2.0.6

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
