Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C05C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 02:46:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3595060F38
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 02:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237033AbhJMCsr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 22:48:47 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23656 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229980AbhJMCsr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 22:48:47 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19D0bamc010762;
        Wed, 13 Oct 2021 02:46:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ePL3RgaxWJFIVz2pSV0aqIYfsoDl7Fs6QwV0CgMFxS0=;
 b=dZHJ6QZrc/qU+RqWam0/uDpP3Yh5Vs//g0+sP1uzROYb171cA+X0rt5XqqRqPqKdkWsr
 UVD0CleYCg2ioPDqFeT8CHy6ijAbekQIOITf2HcHHYPfG0ZN8Bel0LSGgC65dr3NWtA4
 p+VsVyl5LysFcVWbdx88lXRLoCFGyEU6yS59QCZPJrWfxZisYthVL4XyMS7tZk+q0F2N
 VNHwLoC7q7wyceOtzCehAqi/ykHfVT2mEJ/hlKRPCaqlNAii1OwXM3o2WKldxCV9HlTV
 RhJjNyshSvhmin2UGdHeFLccPIrlE8EXMNdRfzwKm2sTb8p5xhBZezRvJ8cJlwg6ETFo WQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbk8v11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 02:46:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19D2ik81016998;
        Wed, 13 Oct 2021 02:46:29 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by aserp3020.oracle.com with ESMTP id 3bmae02052-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 02:46:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kfY3Gg4IErsmKw9ZSzhdobjL3mWyHB8kwQybwqgPKkUl2/5xqvTTDXeIio7/c+Ikv8Il64ZCNTlO99DanhKSCnu4u3kAT1N0cvo55IbWSMc0fpUSEyK2snWpTcdScd1kUw7AWenuqCFEfC4dhr/Brvo2dLvf6mzf9BYSP3Opsym/VzHgbsLGg7fn5/mPbvwVZnV3+5oPbCzbsb9oXPSSK8bTLKGoyO0k8uu4W5J29zWzG7S1XLqJhA7uCymFnVYvXYGOMAgrVxP1gWT9AitXG96WVRqQsh4JaCh0PDD3WYGRzNu8QcNV2htJ8jP5tzvzBUsHguv6BZE/WczyF3kbKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ePL3RgaxWJFIVz2pSV0aqIYfsoDl7Fs6QwV0CgMFxS0=;
 b=BwEhnAAyz/bHukYPcCS3QVRlOWmoL9lzvut0HEaMfS9hPQ6aH2vjGo0s6FmfUNGr0eN9nX25xMMGAsPkZC8RtChUOzcEq8gVDpNe+7xT6hLXe6kS/gP/TWQbR/rRYl8Hr+p7v4We41etuKUDCxzkIB0+zrU68Kb8/Nrum89QFf3cLp4Eo+wFx7oZBjK3TPiZRm6FLU32UAUFNuznDc90JbR77ir/wX9fRv/aI5KmxONHOyL8GbLw89z42FwPCJRWRKoxzLeGDPBz+tFS+xD252/i10pE3KN2W1CnrX46b4Lr1KP1Qt8Q0JTDBRT3ysCkw2OT5t199mfhOIac1r0JTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ePL3RgaxWJFIVz2pSV0aqIYfsoDl7Fs6QwV0CgMFxS0=;
 b=VWFgCNxOTvLdw7sp7FYbmdHRlo+SR6SMvL4uRycP6aMyhtuNAe5NL7y/f2fAIaHU2cdQWjttx5U/0nw6D/Lt3bRFz7w0bEmJu2xlfehoUYTQN83q94wu6WTUpvs41c3M6V7jIuAKR96WAySNMFi6ua5aVDLq8/FzTGvZnC4Md6A=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by CO1PR10MB4643.namprd10.prod.outlook.com (2603:10b6:303:9c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24; Wed, 13 Oct
 2021 02:46:27 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::7c3a:acce:d3fc:a654]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::7c3a:acce:d3fc:a654%6]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 02:46:27 +0000
To:     John Garry <john.garry@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <yanaijie@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>
Subject: Re: [PATCH 0/4] hisi_sas: Some misc patches for next
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bl3tprpi.fsf@ca-mkp.ca.oracle.com>
References: <1634041588-74824-1-git-send-email-john.garry@huawei.com>
Date:   Tue, 12 Oct 2021 22:46:25 -0400
In-Reply-To: <1634041588-74824-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Tue, 12 Oct 2021 20:26:24 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0027.namprd05.prod.outlook.com
 (2603:10b6:803:40::40) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.12) by SN4PR0501CA0027.namprd05.prod.outlook.com (2603:10b6:803:40::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.7 via Frontend Transport; Wed, 13 Oct 2021 02:46:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45dfe04b-67f5-4ce5-b4dc-08d98df3a78c
X-MS-TrafficTypeDiagnostic: CO1PR10MB4643:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4643D942CE29C150550A2B0A8EB79@CO1PR10MB4643.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PnaXAf3aZasvoAHBMZEUJ4+Is7UpzcE0be+s1ulQb7YgOjUBOaPruxFcb65aGdLfUSA6H0tiGXXznvSTWYBpH6UYeAk1H0JzyReiDKF0GNz/0Rs7OK9J6CnEgscYchb6Dntmk/gpgcSISZqzt0WeLruCPUsGpgq8dTc6ZN30wk0+bw2EPBfei/d/977kYB4rOxc96o7Gce59SwlW4E3yiB4ZZ0+0qrl+Nz82HXjj2rLqtTecM6To/yaLqvaVSI+8YGdDDmdEt2auIUoZQXQhpipLQZH7GRFs+XRzVzZMdABpc8OiT2yPju9syK9H6WnvTFLTZ+pJHs2vOJwWLGVlf4unA04cYapfbK3i4zIyq5lXiMha2V8HleVc6rp+GEQ7z/XVtgBHv23ZZhckF+XV6j6kqJ+sNHBZC+sBdjoFiwkmMamYSiG9kFAg9bM/OMO5xNcgW0DUO0pVxUoINzv2JRAlwCWYEQcTSannWWKDPnqnnVikRwmcUViAXmgqN6EnhJbNgQZI8NQONnJ7sCf2iuyjZOn30RIl2GS7Vf3R4mtuw3G3eHVJYSCbNmsaUwj1EQmU3TsJ4jdEzcp2lKsm2V3w6om1PsUky7O+zBdzZ0RbiI0Dw5CLjT9RXCGp+TFbR9h650FblNxpSGGM69lZl5B+YAX5U4n10wgljKA9o8DJJgL6Jw3oanAIiRhFd8oKud/ueNqquB4+534fmg66oA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(66556008)(66946007)(66476007)(4326008)(6916009)(38350700002)(2906002)(956004)(4744005)(38100700002)(508600001)(26005)(186003)(8676002)(7696005)(8936002)(36916002)(55016002)(316002)(5660300002)(54906003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4OJsYRtCN4FAPWL1NejzObPS+8eVM+ghm5IQITD3rralm+wAGCVZi+ew13Oj?=
 =?us-ascii?Q?C0rfTh0fO8L4YrYcwnG9hX4NtFc8Nr1OHaXMQuwiJ6eT0l0oP+ECLWbPNNhC?=
 =?us-ascii?Q?SAdgk5N9/pC0RF2F/WDTMbIAodKw3YMUZ7LpJ16wAjpt56LYJatFidSpBlSp?=
 =?us-ascii?Q?mmlMqyZ9q5+VP7SrG83Vs8vtK0V9oYRI1VYj00TbZHrZZu75995eW67MTnlb?=
 =?us-ascii?Q?4K4r4VKF8YfhocNR6SVWLZPLjLzcB4c/NekGSOQWiXPAW9iNMeYVZoG4Z4Q6?=
 =?us-ascii?Q?NWK0qZwbvKd4k2slIS7Lny3gyLBu7MYLZIHMt+SpJDVoMgj4Y8ibKNmTuPUm?=
 =?us-ascii?Q?/vMQQJrgne5FyI+D9zRRM3sZUpn1xmuJf+1zr7yNSO0kxX+O9LGg1Tc0aSZ8?=
 =?us-ascii?Q?iRhOhxy/jYSCXuQPXWtLxxmQ+IyTWVLVGvHLzDkg2+zAG9AX8jMQ6pyQfou+?=
 =?us-ascii?Q?E4ITyjmjNBcDgU1EeHXjMLnvQbqswUKKkRzHa3sz7hLdCcFFBxjEmcPxMYrt?=
 =?us-ascii?Q?v28+4x8UH923KAKwe6bpxg09qfBwzdt1tICUpJb/RHSaq4yeCyn6eSNQg5aO?=
 =?us-ascii?Q?1t18iqr0qbxmXKgDfJG9ErPov2tflS4azoYoKMDxvaP+3D9FP+sMSDGhIE+7?=
 =?us-ascii?Q?9NjiaJS1oZ33VHUYRbr9FmnRXRNTsx4QmEC3bWznf8+hWsLiDl7k7YL3JacP?=
 =?us-ascii?Q?NdXLTO8MfTEXAjBqdk/Tcr2xJvvmAKJRvcVGKMfxKZfLtETbRO1GXmF58klP?=
 =?us-ascii?Q?FH+M+B9w/JQslyyqgPsDLlZ/bxrgl/K7qozIesIysnMqKp9tyVSnv6D1z5jF?=
 =?us-ascii?Q?U26FT3QBlnGvapAsKjsfQZHoia8havsEBthUwkFtrthAXDx8xIEkTDhl5Qcg?=
 =?us-ascii?Q?cOOdCAahNmCIqwPY0ju8nT+JPwvNuYpNKHCZgcdXBa9VZit7i60K3msIAhqX?=
 =?us-ascii?Q?y/E+SxGoQ3g/Ur2ZXzSGPkScKT19zZn2P75KnE5cMYT0+/kh2nJDw2pyIm8u?=
 =?us-ascii?Q?ntC2BW+KZ3DxHp9+xYVDuP+tm0naKrrcV2wai3iTQ9k8EqpJvPAqrKaeJIMe?=
 =?us-ascii?Q?qBmipdp/rK+EGAhyQ419C7YLHcYUW5byrf++BDYC1pKg2MKpkdjsFYMFGqFj?=
 =?us-ascii?Q?VRu+NGUZ9N3ecurEdiWzTz+a1+mF7J4R/+oTBiqnZKa2pyqsWcrP9LdMIcAl?=
 =?us-ascii?Q?OIwLTW8TuMII+hNotJhFl6iOkACYeq+KA44dsmj7QmlPmgZEQVECPp0EGPk4?=
 =?us-ascii?Q?mNWhqcczwkNkgaDJWmzCDQTBgt9m35lLyLKIUYj26yuDq2eJ6O0lDSZ2Q3oB?=
 =?us-ascii?Q?tcM7qPnG6mUvRpOLTEWu6pby?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45dfe04b-67f5-4ce5-b4dc-08d98df3a78c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 02:46:27.8057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Os8HK0FA9nkHK1un1fQO4/FYNSlIJV7HPAG9ZbT7Zz6RNBfWKR6hwqTz4CjpYDqe2eqlSShCjxIlF7Yf9TL5maahmMxCqI4GN1h/CK/n6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4643
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=774 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110130015
X-Proofpoint-GUID: AKhIsbVEF-sYWzUzJ2-bxua302lRv7SQ
X-Proofpoint-ORIG-GUID: AKhIsbVEF-sYWzUzJ2-bxua302lRv7SQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> This small series includes the following:
> - Relocate the init device functionality to a more appropriate location
> - Make the phy control function synchronous
> - For faulty SATA disk, disable their phy to stop spinning in the error
>   handler
> - For previous patch we need to export a libsas phy control function

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
