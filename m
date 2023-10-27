Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29508C25B6B
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Oct 2023 00:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjJ0A5P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 20:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjJ0A5O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 20:57:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE0D1B6;
        Thu, 26 Oct 2023 17:57:12 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39R0i1rp028752;
        Fri, 27 Oct 2023 00:57:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=+ZIHvKzx8qLXBTkprYSTc0ZDcq3+DbNqKu053xVJdLY=;
 b=SL2xxSPQjlREE3iYDkZLbbcIaNTqRSExF04TH0mIj997nCce6Rs9+17MT1jRFDthBQmP
 DUiFSTfmpQhZzWvxLH41dj2QBXGIt/ZABr0xhwAoHc/XxPFoP2jccGLIdY4TETCIjAM1
 Tj6j//KCVNGu+6XYeR2Xhy74s8xqXeJyUT0bNVJqBLyiYW2mdGt/LhThMLge4+4Jnzm8
 5Cj3Xe7M9P+t4O56xOe9I+UpCeLJnyRNMChbYi9aKy1B1ML3J8cKBSTFwzSqQ7kVhbl9
 Yylwu5rOlU3ltVTgxBoedheK868hTGf2GROx12yemYl1Y0oL58ztmSQtT6/t/iSqQ8nB gg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tywtt0fec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Oct 2023 00:57:06 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39QNOVHW038015;
        Fri, 27 Oct 2023 00:57:05 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tywqsag4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Oct 2023 00:57:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZnHKCF5as1Rrgww5kW3zihd6S3QDh98s6rSA956K/aRQWc7+C34S45j+2dIB1KYiU/D2RLS7lT4WEQtRvKMqe0gAemQN/QTdtKapDigEbTAtxIPDbmsrWbkUkJ+VQN6DW82Dy6gbli0AyaS587yAjW/WI9VMQ9zyqCBrQ29/opq8rNxa7yGiFvxQ0PtiUGZzQJVe7vUTVLtUHs3P/OlH6shH20EWvQVwkZJeXtjumpqtn85q/6g6pek1YPnSz3idHbYuQquFlSK+T503zLWcZ6xmJV/XF+34wwWZ/mdODWqjlDE9rQhFajHV/zVRI9nVrm0qo4s+zrd4Q98dIqWHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ZIHvKzx8qLXBTkprYSTc0ZDcq3+DbNqKu053xVJdLY=;
 b=KRBKJ4JeT0WRZoluE8uqUgFAzwNJKe26hhRAKKshZRUmqri+CgGwo+bGksOq+9C3+BOl4DGSAcap0yOedGF6FkcM9C09oWNiB7zXa6IRLol0fBYBAeuoXeBBVT+lwNQdt6XmBqEELfJR9SVHrAS7RcipjgfQB4247IVFTZufa6rpRp7Eltit5Bd186hQEDybc05d6IRtE0lXR5GoqIlJQao5fvdmZlM8UQeTvglIJnACtirb9edADjkXPfNuD7DWtNxXju5urF5rTeI+gxZpOBL/W4M9+fQ0gU1IgS1fvMonqI+EGLJS7K2qUneE8v6Og0WxdI5BD3olxjTf4PbW1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ZIHvKzx8qLXBTkprYSTc0ZDcq3+DbNqKu053xVJdLY=;
 b=YP1HWP7HKUvg7bKYY6di0pMdUSg9ayCmkQ3pKnsYvIJkYhIQKQN9kQzlT9+K2veijA5SN0pkT23W2ATiZroGKjSnnzZxt0++VCNun1AexH/sio1lC5C0O3asrcKZozYtj7B9xk4bxFHB495xmimj47pZq+3fUgT5UajAHXy3M54=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ1PR10MB5932.namprd10.prod.outlook.com (2603:10b6:a03:489::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.22; Fri, 27 Oct
 2023 00:57:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4b86:3936:56a5:2074]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4b86:3936:56a5:2074%4]) with mapi id 15.20.6933.019; Fri, 27 Oct 2023
 00:57:02 +0000
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] scsi: sd: Introduce manage_shutdown device flag
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h6mcc27v.fsf@ca-mkp.ca.oracle.com>
References: <20231025070117.464903-1-dlemoal@kernel.org>
        <39fef5f8e090d50eb22d73d6bb39b21edf62b565.camel@HansenPartnership.com>
        <bf780d7a-30f3-4744-adde-73b4c2723d6b@kernel.org>
        <c3dfca871ddddfeef004fdb74432630a148300f2.camel@HansenPartnership.com>
        <23f25e02-a451-4ad4-bb04-e3449a1e6dea@acm.org>
        <84139e3b-15d4-4368-a6d6-77bba5555aac@kernel.org>
Date:   Thu, 26 Oct 2023 20:57:00 -0400
In-Reply-To: <84139e3b-15d4-4368-a6d6-77bba5555aac@kernel.org> (Damien Le
        Moal's message of "Fri, 27 Oct 2023 09:26:27 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ1PR10MB5932:EE_
X-MS-Office365-Filtering-Correlation-Id: fd2e35cb-2a5e-4a05-c3c5-08dbd687a1bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8bCu7KHYAPHhPBcOaLuz9h8ted5NUrlOU2uTVQNi7tXiHhG+79M1q09MZkKaJTJTSPdWbw/x3JauQe1xaMaum/2QHE2AgBnH6XAGuDOCHCPEprc85zAY5pAA/M49opcKitDHVdulnx8YngJjVjMCh4mCJqeTFD/fmIy610b8YKyV4Pg160sg8b0hmXMjqzXgIcwEcuVKrfo6zukmV3/mqnk8Ms5GWbXFu6xFo01Y2kD+J5ahdN+pID2LSf2mlUWVcLmf5BjauscQmdE2O0y9c/TR1mKC7SwEGBAjoXzu6Q+m1nhbiOaqi6dTMqmnkCSz20Cb9blE3gzehDod/XXLyWFyVLiNs26M1VVsNjL5NzuGCK+HIG9tt+8B2+r0YuDfNVPw0QP4JgL/2pg33cyPA6KuIhp3TSAIEooOcaY3XgRzv7CelXl1wBJCNvzUGYZ4nARU9hBA2VMRydkGyMdyL/mRi9ZmA9QMwC4E3rtMPomJuN8Yx0FXD0V+HzL4tN6ckA4gAuQIX494dIVfr1J8KsOe8/GBuqPN+spAN8uI/9t2JgzNjBBCExFVu5PSej5F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(346002)(376002)(366004)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(2906002)(38100700002)(86362001)(558084003)(5660300002)(6512007)(41300700001)(66556008)(54906003)(66946007)(316002)(6916009)(66476007)(36916002)(6506007)(8676002)(26005)(6486002)(478600001)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gmpkWm0EMo8uNdPDnUemX+h+HDkb78lTLD3f06lqq2fR+lyYWyhoERbUiT4u?=
 =?us-ascii?Q?30OPJIRPMtY7t5AbvIuIHyx5dkJVGQX6AE2eNBsY5pm9ItlrQ8RXbzLpxNJp?=
 =?us-ascii?Q?oJV70sfWR0xi5HnkdEgYnjSexz8C5jUzgtS+sPJRsPtGSM8Y0PAObjGpzYd4?=
 =?us-ascii?Q?DTVRd53MvHGdRUX2sz6AGnxQGOxQbBnFiC86J9EOtqK1aRINwO6HoweWvd0M?=
 =?us-ascii?Q?eQ3Sg6D5C1m/Fs42VC/bW2ITANPUsdnGUduEaQRXCGZpjBeBTsD2k3quIFUj?=
 =?us-ascii?Q?IbzOozKmMHigRMzAeNIMNNUA8EAgPBICyPNxlSa/gBvoksx+SRSJuOMKcLMA?=
 =?us-ascii?Q?6SsSWdsTRNozK3b9/E5cWRad/5D5a/04zbAsWSUS9krPzdPzCSS9wgq6k0Sk?=
 =?us-ascii?Q?R3wNaUjOTCXZvFa/J0PKgb2bx0p9SoSXx6oIRVecKLt1N650K694LAJ6O4Yv?=
 =?us-ascii?Q?MwQye762ozdWdLnJ4ySeJmFFHFZuAnncoHCSREjVhcAb8bHw6xR0vxjPQsUF?=
 =?us-ascii?Q?CGh4D91OAMNx+gFtL5ZryoLDxgIOsedYM9WCTLx/3NLWS6VL6y5fsgZgTo9b?=
 =?us-ascii?Q?CMBitVciE8KtZsEZlC+2Qh5jxI+7ZQMi74uJjH+0HdtFwkThwDnPBLbgbivq?=
 =?us-ascii?Q?sa+A48E/CV22BbzNTC8wnOz9fEmFPObiZDCDAXyloijk1iM5ors0hG3cBfDD?=
 =?us-ascii?Q?eRrpiBjKF7XuMsUMzCy95z3mVxTS/L+FlsV8LKw7yx9yHHD2W8CYH9+2sG3t?=
 =?us-ascii?Q?KdqNKHMFnp0IjnRxROhKOnFOTsR9vUn54TJKKDwVqOMaRsJLGfbkzQJGszMz?=
 =?us-ascii?Q?VNfO2dlYoamqcD5GbiuDKohwoC9IwVM+90KXxpo3aMNpOHsqqSPpGWlYsZEu?=
 =?us-ascii?Q?bFfxEIJ0qLsJIutBCWCKYf3W6VfH6IiEHORQ5cz/D3OfGHInB5LKZcV3vSWU?=
 =?us-ascii?Q?9CSDzOJBlxe4C3HlgGxGfoLg6XuG9gBsLDs1L1qg8o5g1drxc1xO7xWDXRyb?=
 =?us-ascii?Q?jcnnf/jfLLOdnRF+IkESvGtonnEGLMoSkql+KaWPOD2DkhYAya9d9C7eA6cw?=
 =?us-ascii?Q?GAHWX52Xab7Ht2ymrZ3x1u96Iq5f3OkW/DG6jDvQiTT6PWtJ1P23z3KYcVz0?=
 =?us-ascii?Q?Ne6JOvj5NiAJprHaj17de9/V+i2Tgck+8EvM0HJwSKwwuZ0XWzja1E6VJah7?=
 =?us-ascii?Q?oV6AAh32faNdR/gLK96KHyL4PSR/VEejt6ytHlvjQ/PNwtTKwjIQ12mtgGeK?=
 =?us-ascii?Q?TpMypy1A8UxJt6+nY1fsF1S9h+HYNjHYdUUNl3yqP2iWYcp/KMx5UT0I07gO?=
 =?us-ascii?Q?Ad9HeC0Cwff/6GV3DjPkwamMIe3VWcqISj5vs+GzZdbACgugq2HTsIRCcc/u?=
 =?us-ascii?Q?H1nvJCQCFrD3L9JfDE9f+I/9144kgR21cncO2dpJa028Ntsdg+EDsMvpmat8?=
 =?us-ascii?Q?SpycMrSK6LZ0rxgNgfgE2+4dcyd8sGJXqCT2Qbneq6K5EOv3ehNtaCRqe9I9?=
 =?us-ascii?Q?Hz8C1v+wkZvs89fTDvK45P8JIBS6raenoZswK++R+5UgIRUdJLYPB4Jie7V9?=
 =?us-ascii?Q?3KHvNBe5iDD4CpqBOB3QO+qUi7WRDe3xwI6Eox+RuwIISUh83FwVEhj+4JBA?=
 =?us-ascii?Q?fg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: w5qGE2N6sz8vrob0bAMAVX/WsbOUjKNyGQdcIAVOfTnN/leuDax1iLynbxiRUxzaCAWAbjke68njNbrdyj5rYiCQsKum692tvSUET2eS6mxD8VRQEBn+xHngbnJjCortZN4qXsavDmWBiZCgFp9eE00qLPLl5AGSozLSvyD8P2g+AxCM6TX9R//BMVLIMIa9ccSAkxzll3IBKkv7whzVbCBCTcXD/0KObeQwz1Zr9hdPMIqSmYhiK0TpSWVauWHPEuyp/pHgSZz/NITDgCME0EeACxxwQVT7w7Kk0ejPCFNpRaQcEcM9Lxo2WaTkjDVlvToagoB6VfEG+XX6ib/lVtRmzhTc/bCHvcwBS9mj5fmW6uJyAe5IIUZROzgswhfBesUIEJ5JHk2ceUMZk1NZE4kGIOodNN97Q4T4jFMTmHuXIwkZcdNuMhkpX8HRP8J2aI7VKEfl4IIMN6/OmHxjDjRucCaUvKd45oIxtKfCPBjie1My9G17UNr2R2cjo2UmhTskCAVVXThVV4te6K1W+rZ9bc+6L9aC2eH8WDObvA5fi9Gy2RYtUHgAOC5qzVQM3U7XaFH6VK78bPto/YcUvOtfV5GixmY9P28V2N5LM+NR+hb1jX7prL2cyyztOeiHC4EWSEUBXsw6mNt00QymEna6H07m/h2HVux4xab5uFaHoDqu0wDJdPkMt7u/EvpSMfhBAZ32sAieUNgtowS7LmA6FV5/aiL7a675gN13hd7F222hMxAGHdC81i0BSy75KkzPwoU3VTFdudCouhYudGPVRni+jS/I0NQkBao54o2HK2QkTS6ZBhmRgaaoVU3krz3IFUEuxm0bvXALT/sG+NcEl14SblH8z1PmMDZrBSyfl7/C4NJHAmH/XBQxE0uz
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd2e35cb-2a5e-4a05-c3c5-08dbd687a1bc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2023 00:57:02.6762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p0YmCLYRzyeQZsgzrTh4XaxZF2aE2CQPlvq6Yl67Pw3bEycD9jkTs6E4Q87AZatNDZTJNqadIWn4N4uULmPQlwhOVMweYIbassUGpYcIMco=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5932
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-26_22,2023-10-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310270006
X-Proofpoint-GUID: e46kcu3dV0FPcpA2cT6BDnqTRVeoRKGN
X-Proofpoint-ORIG-GUID: e46kcu3dV0FPcpA2cT6BDnqTRVeoRKGN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> In any case, I would like to push this fix for 6.6-final as this is a
> tracked regression. Martin, James, are you OK with this patch ?

Yep.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
