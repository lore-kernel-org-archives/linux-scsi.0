Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66FFDC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 03:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350917AbiASDn5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Jan 2022 22:43:57 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:22628 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240481AbiASDn4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Jan 2022 22:43:56 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20INxBCn010715;
        Wed, 19 Jan 2022 03:43:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Z4ttxYwbJhV1x+WglTyU3KFbHIqnsZUkYS1k9iCpJ64=;
 b=jValObFCKMFLnrms9zZQT4QGTKpTisHJmInEsodHpnFsO8ZXYW3xchM8AO8xHtNxu6Ju
 67L8Owzqb0fOToSW9dq6xZ0yiMV3N76XOR0JmFcK7NDFCeTyKiZjq1gNoSalecUPQaXi
 rSctXPjeBLI5sgve9tB8IvywAVM9AICHuob9a/lSs+lvuO5JXP7piOpQhyJ2odYwm3/2
 rvBBwYnDwmmm5uYfe29gWoCuGfv0jxrTGtjlPjJ8VHsDWbfmTOQ+NDArheERBRNajkGS
 /d5+WOgoHW3vxF+fipOfgq4ZgrRAro2Ig9UF10k2xrnPjuACaLEsZXmi9MeljdaugcbS vQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnbrnutnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 03:43:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20J3e3FF036005;
        Wed, 19 Jan 2022 03:43:53 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3020.oracle.com with ESMTP id 3dkqqpmxhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 03:43:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n4lzwgwFAEtpLbUENJWUX+ST48/ZIbs5jZtsF12keM+qk5XaoTpZqZVSGsS0LTGzQUorI5MjXINx+v0OsQ1XD+D+5KQOA0KouHSPeFwv6iNKVI+u6AAYg9jz/q73qn+t5rUV0PRymuoM3UxfkzpJshpN6+lRPlIqmpGN4SBjGjDiZyO5kj0tsQKCQHd03ERqsxbYmFxV8KpB8S2r+XPqF+qi6vmXwBQbQ9UGo9AXzx2TFzNdGR4g3KxDpZzRwKtToHLj7FTVLpTZ/mA9x8NID5yuVDaFyImZHR5hwL3E4FVZ6ZXGTzTmBi/S0Plplfqsj5cmxBsoCMYu26pEqWgE8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z4ttxYwbJhV1x+WglTyU3KFbHIqnsZUkYS1k9iCpJ64=;
 b=Ad61yggOtAfhvRAgj5ypjQxwFVSbtO6b9cQY2PKIl0dCKI/E22hs9bbqty0EOrgI7KTOqe2LNjsReygWgV/zKcwwWfE2Pe/bhoV1c1BqRKSzEFn1BFKb8smik6H6lYnjV15VCKuSGVLWjUibWgWUlhNx64PN499v/BCgqBG6nhXKaDXUnXBgoOmp2QEvbywwVBDgC70HhYhv7L4eMg0QyDm9eS7gJxqrENmJAZptJval1s9GdgU6rZHN/ln5PPDxmld6mb1wzNI8XpLDVpAM+CYp1axq6g8/1shcj6nGYfeieA8grCJQRxIoIuwsNa9PvquH4MdYi6DDmYQGAIVv+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4ttxYwbJhV1x+WglTyU3KFbHIqnsZUkYS1k9iCpJ64=;
 b=pTP1sMFqGrb8Dg4fsfMKI51SQ7B7wI9YeR79pTbYukBJd8JGPfn5L+Zard5xloC69dBHafcuoZ3THpueg+7jXnv94wIbumwldGx6UrRkrjtP+C1GBvfYLNb+6aBkASM5tSzJr1UwrZNmu/37ll/XIDenv7XJsaA2xOZDi04I8i8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB5695.namprd10.prod.outlook.com (2603:10b6:a03:3ee::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.13; Wed, 19 Jan
 2022 03:43:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166%7]) with mapi id 15.20.4888.014; Wed, 19 Jan 2022
 03:43:50 +0000
To:     Steffen Maier <maier@linux.ibm.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH] zfcp: fix failed recovery on gone remote port with
 non-NPIV FCP devices
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8ygl7a3.fsf@ca-mkp.ca.oracle.com>
References: <20220118165803.3667947-1-maier@linux.ibm.com>
Date:   Tue, 18 Jan 2022 22:43:48 -0500
In-Reply-To: <20220118165803.3667947-1-maier@linux.ibm.com> (Steffen Maier's
        message of "Tue, 18 Jan 2022 17:58:03 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0183.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0c2343f-32e1-4d2b-2db2-08d9dafde83d
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5695:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB569512409214FECDFBEEF0358E599@SJ0PR10MB5695.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QChq2SoXh4wgQqIYu3QZs1/bcB+mOtFhY1z7K6DTDYL+8jdSDdyWoPidOBq4MIQkHIpcqlXkp90CMGgWklZ6cfIFYxBpKvOTmCiGgF4rwAW42qWZ3chtrI29LEL8HmnsoY+Aj0fj3+7Ik5+NVwWbqyWBrLAQLB8m5cn4ISUfgvH2ALg5UzZZuwz5KCjGY9KpC/UsIPT8bkCwj3Jql7Wg1yaTpr1c6BGTyzbAmR2lieRecOBywWeQffZAbOn/8pLV85gqayMdU4Vy2xVIeA69/mGs0dT0jWNP0etFtaMpSWvVpiC4E60Iosc/F+rd0SpcSLgRAKP1nPxht79ysblzjHsIVK6KqTCIvqSj1ADBGGgWixHmm7GMxuQu+XRxjDbHVEY4j66NEIAsg2zVbjiYqgvkCFifQoAFZsmgomniSN5j7ziFA+8nVCUCvdsGbA330RsHLm75MF+OmXJI/YeBV4X855D0B6nCsH5MbTTtBo3ev2MaPm6kYV2PKDPl+KE5CvbK+fBLmcNCT8gQinxsDN48uQrks9fsi9vJlFRV5OiJu6w/lwiRvCc3Ysjam7ApcLYBaZwWXNh4SzjoZUophMM/AZmfW2aYhAp52SJsfl9NGxinLY2mSZd/RWAzEAD6kGVitRJrz7TlaEp+zLrkdzhrtEE5AHt74KUidjhbo36onUbOg6SIDqolMAIpX9isvfRx18x00N9BzDlSnHsg1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(316002)(54906003)(66556008)(5660300002)(6916009)(38100700002)(86362001)(36916002)(66476007)(52116002)(38350700002)(4326008)(6486002)(6512007)(66946007)(186003)(2906002)(8936002)(8676002)(558084003)(26005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5KNLUZ9/HIgY0/ZDPD3EXz7HmhwU/wPjRbMSKumUTMAiuyIEIOU9HtGe1yAU?=
 =?us-ascii?Q?tHz+c2B4D5dngqk98FaeNvRvzig2QwhJmeHZUcxGiAshBFHMWQzZETF0PGqp?=
 =?us-ascii?Q?0PuEgIfmb3Nb9Gn/xBq3Vrx85SisnA6Pmr/ZU8le4QPIevWYykVuxWYUqyE4?=
 =?us-ascii?Q?/G9RSwQFlNOWbrWVGH+MSesSwX/FcV7m+ZvFxiMvWeJ4Q8FVctrJUhTja8W2?=
 =?us-ascii?Q?+ejX2iWy3Pu0D6YTgWlAk8nkCtw6odywNoY5vID+W5YtT3L8rZNfMAARPEAx?=
 =?us-ascii?Q?NCKliGHMLjgJYYLO+/oQ+UmWAxV/HPjlE/aAAKq8V/Uy1+ZhcmdkGgOP+21K?=
 =?us-ascii?Q?5xD/1zQacUvAP/nvh1FW1h6L8oX3SEnuUKnFUyU4knywR2kBlnZz2MPSSuwE?=
 =?us-ascii?Q?acl+c/hzg2TrL+1nuAOHPM+ahPdk0qcc5KXeyHt4E1hC7iNlQxa84pltrLVo?=
 =?us-ascii?Q?vmkAe6a/oWcdFov+k8rq8ZX+Mq9CSGiHyY38p7CokgbDx+t3hyk/P/jUGZoh?=
 =?us-ascii?Q?xvmPfWdwDbdsxyQRxQxnmmHpV2i9Eji06oTSiABcoOnWIAfntQYM2sG0AGYN?=
 =?us-ascii?Q?yRWcH9XSyS615i3V66XUl5Uid3bFk2q5IQ7YaF47CkFr1XTTLklXVoFJnBuY?=
 =?us-ascii?Q?1P64FcqBuljbWE/slzP3axRCOoOaSZSNUPY0miev7tchGws+eYsr4614m0d6?=
 =?us-ascii?Q?bEwJ/gKfI55Ml/xgJgNrlXlbD39NhgOtp2pIjuOONkSh33Nqc/XkWwIEpJxg?=
 =?us-ascii?Q?GJxzNhk6NqnwLk2BGS1PkqR6Qk3/QoZHtMCCHjYlUKS8/aP87OIC+niZQqOQ?=
 =?us-ascii?Q?KkkUkYHME65SYEB9h5McBU+OGLSPvBw61mFqiVx4EWisoSPFBa0NHNn1Gsic?=
 =?us-ascii?Q?LE/v1mrt76GSFT9G4xLQegbAa/Ubz0pEhT4UUuLXAt0bct5thVkYtSc+NZ2M?=
 =?us-ascii?Q?VFEr8rtM1k8I6qb2HualUE+TRgzKKZC2LGoo1jvFXmXKPn1gaGKXWOlnuDfP?=
 =?us-ascii?Q?3zvbQOgdHshb1WGmrKR07YxRfO4+gUXei7hO5xIbjO20XbPhEAFj7E2+Qd6l?=
 =?us-ascii?Q?P9RrRHrOdv9ZsnmMvPQJuc2/e/oE7Wrpjhf32eW7+LrT3t5yolEvXzI8FjhO?=
 =?us-ascii?Q?vngIrcf10FpQbFXthl6tnDTK4FKR7rmLs2brNTX2a6QzgrZVIJGc6YEY4qky?=
 =?us-ascii?Q?mmUcb2+c37kzzNGlFrEz0+7dagrTV2uS/Q1PdnRFUHtUd2plrqIC/B7jIZus?=
 =?us-ascii?Q?8cY0iQ1UnHUbxhUo4GRyRaIa1KELB00eZsEuHOzt4I0eXUfLyh5kvxSnlyyf?=
 =?us-ascii?Q?SuP8zVgCnNG2rZ3cDITfEnrzflAcj9940OMgGIUtBzvVw5fUyQ4Ix4xo3ouj?=
 =?us-ascii?Q?JqiNxPRw6wPcstcjnWR2hB7N6zv6XSxgU2IskNMPJn5jTqI7QmMUYjxzo2nc?=
 =?us-ascii?Q?Ag1PruqEbDqC/2bn6LbHY6yiXBN+d73WBBo4rsfT8QMxgjzfdGk/fJOGsME6?=
 =?us-ascii?Q?31o/hs355P9u8shtowCjO0QqhdQSwKlgvmHIdJWAqCmO6avhyIW99ivehHC4?=
 =?us-ascii?Q?ztYYtzwZTmHCP2iCByH9Ck6t/FYZ5Gd7eb5Qs5ew16mIT35iov6WJ02pcZN8?=
 =?us-ascii?Q?pr2UO0CY4jndZUxT9Yg+0130x2xhqC0GJ5RIW1Auz6cawfNwC6PxAJIEaB3X?=
 =?us-ascii?Q?D255qw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c2343f-32e1-4d2b-2db2-08d9dafde83d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 03:43:50.8790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qxWq3sl0KAYsqJz6Z20Rsa8KSAd9bi1V2GaPiTxNPfoVWiggxYd8WDldE7nbkUXK4o6z71h0QuzuuuwA97Re5ylH0GlR0ZhmKRVUdAz9V9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5695
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10231 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190016
X-Proofpoint-GUID: EhgX-Gn4bHGFDfCftumdZo8Sd7Exu84q
X-Proofpoint-ORIG-GUID: EhgX-Gn4bHGFDfCftumdZo8Sd7Exu84q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Steffen,

> Suppose we have an environment with a number of non-NPIV FCP devices
> (virtual HBAs / FCP devices / zfcp "adapter"s) sharing the same
> physical FCP channel (HBA port) and its I_T nexus. [...]

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
