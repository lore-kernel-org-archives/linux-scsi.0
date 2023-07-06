Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9F5EB64DA
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jul 2023 01:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbjGFBbG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jul 2023 21:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjGFBbF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2023 21:31:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF3D102;
        Wed,  5 Jul 2023 18:31:04 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 365N3qiw009596;
        Thu, 6 Jul 2023 01:30:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=jMN4w0CQTDmHwZ+r3V2uxOShjIirDCAVpa/H5WvXeJ0=;
 b=KscsK3y5d52MxnFQ2h/cKNF1WfirK10WooZpFLNvnW1aUeYdIddifSttkB03234DQhx1
 SrcrenGzZs7zXsovjRMgj2KFbKCHhJDn8V5Lw8I+uQKKSzM+IJCS+8oHdRNEHoqTZ04o
 Phu2wM6whQPOxKw3S5lWW5ALChDwBIhH4Ww/3vgQmCugh1gaNcCXQmDJ494MP8n/sNGM
 BZ3up3hmnOSJEjiylLfFtuEMnZffCtSt6yhrOtD4Cqxzjw4Z/xhRlSYjugJvBAzeCnQx
 4d8hj2sqS4w6T3/seVVWSHe2wH0svfQaF3rXf40b/Y6JoHuJE9t9KAuLk2Qqr+aqHKUU sg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rnd8q8mtt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jul 2023 01:30:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 365NLi35007290;
        Thu, 6 Jul 2023 01:30:49 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rjakcaef3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jul 2023 01:30:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wzfog5g6QH6HkGkWD1ETtpt+y7g8jQHHWpH71OICSaXwsK3m8GfYqGYuxg3DB0KjHp4jRWwF+S/nMXc1/+h7McYAvUl/TIeYXurLXZ6kdMCCKMktM6DQtmt9vBUcqMXubB5j5F+9X3OApKTZnzuq+xL+Yjpu75g/rSCjkVtvFaJvJrPFwER+mTPmdxtRiux1qBWZxnpoYRRmhtCBKKDuGESY4noDH8Y0SHKaryz7BvtNYdEdr60aW63zYX0w1BxvSP/0FC6j72jwLJ8KMGtAibF4mit4XGCJbAderARUEkWrtKGeTaNK3AuNzZllZWSfAdQdl2yuhQifq6O/EoHhFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jMN4w0CQTDmHwZ+r3V2uxOShjIirDCAVpa/H5WvXeJ0=;
 b=LQcfF0bUuusr0j+xCQN9mRtz370a4FrbwLb0GC3QDKxViLFb9xPJzrEToqxadhJ0b8KCzmuE6g5LcybX97fkXlrrJA7Q/KyFQloIKAs4mIiZ9yt7hs7DQkXxH7NnBjff0cGmiPoSPKELfvNrmKT5kcS1x6ItqB7t78Guf8WVT63yRJ5rczCdqfFYveHlM6qeSV5HOxVCbhZm8yD0t94o2HDXjRyPrdIkRO6M//LK8y9XXw6vRxtrOh6QEYrxnEL41joh+EtTyAJ9urGeIYUuGx9PJt1PrkkOp4BhtsZtwAK5JilKL6vBNQD99UWsVhNanSnUnrDY7obScj3nO/qGPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jMN4w0CQTDmHwZ+r3V2uxOShjIirDCAVpa/H5WvXeJ0=;
 b=GCxPdWe4CMmfu5InOpl61P/JSXRYrvl9q3la1wFKaKkZCOvDl3Ymos8l4ClMao66g00sIHm2glAviR0hPt9MP0TFvspQQEtUa5LFLIcH8NwXNGn6F6JYUXfY6S+tBeCbQ8csCb9+kb/J9jsIyfuhsZMsb82/Uq2hUBCBJsaZeoM=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MN6PR10MB7466.namprd10.prod.outlook.com (2603:10b6:208:477::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Thu, 6 Jul
 2023 01:30:46 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::9f29:328c:1592:d5bb]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::9f29:328c:1592:d5bb%7]) with mapi id 15.20.6544.024; Thu, 6 Jul 2023
 01:30:46 +0000
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-scsi@vger.kernel.org,
        llvm@lists.linux.dev, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: qla2xxx: silence a static checker warning
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11qhln7wl.fsf@ca-mkp.ca.oracle.com>
References: <4aa0485e-766f-4b02-8d5d-c6781ea8f511@moroto.mountain>
Date:   Wed, 05 Jul 2023 21:30:43 -0400
In-Reply-To: <4aa0485e-766f-4b02-8d5d-c6781ea8f511@moroto.mountain> (Dan
        Carpenter's message of "Mon, 26 Jun 2023 13:58:03 +0300")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0087.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::28) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|MN6PR10MB7466:EE_
X-MS-Office365-Filtering-Correlation-Id: 00ebd942-e9d0-4614-b1a0-08db7dc09f20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bv2D51mKrIELQLovZGew0BDyfV7XUlTeGLJTfixQppO58b9eoUmBOzSSrka/MmpJMKhIKHWyP55Umol2D/cWPShfNrN6qNDfPjV8OeYiEX9Luw5INwUQnPfJH9Aal5Wpy1tqJFzGJ097vb5CjQ0TMzcC++7KWocDxU5JbAb54lQVVYuWtY4aIT5liUe/zJWUQiWVrHrWIycNSxphopXV8Ed6XD7Y41vBERvIVNAKOrbkWJlbU6jbuTmtPV6jISoxCWILju18GhUF4H65ieskdmnMeY94omqpjlc768LcxSbw8b6FN6BtQlNCwj2iGfh+EzofuRWA4ckA2Ma0R5+fWtTW33EurFlb61iPIzQJDdmwGSp0I1xRQvY1vEM4uW1KqroMbeceMfgr06fcsgvQ9Y6RLowuAoUg0SxTuQjJjOrXKY1kP1lQwlKLfDIt4uKgNDFaKXafHFi8PBK61OVGe/+b2NmIXWfjG0wXhOZrjr9RtCORJEPyJluiil/k0PSKNgqkD1LfvqONBvs8zThF/WAxlw8XMo/AZ/swwFlJP9wtsU3EV2Cg6Joyj3drhYzH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(39860400002)(376002)(136003)(451199021)(66476007)(316002)(6916009)(66946007)(66556008)(38100700002)(4326008)(186003)(6506007)(26005)(6512007)(6486002)(478600001)(6666004)(36916002)(54906003)(83380400001)(8936002)(558084003)(2906002)(7416002)(5660300002)(86362001)(8676002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W/J+YoNQqEiMsXrzW86LdpbO5R7KKBZlMtQl3Q27XyN6FRpwJ412HotT8xL1?=
 =?us-ascii?Q?eDNijIb1kRMyxKXlgIIUGntLu0jVL8/wnNE8IZXjdQHXdU+otnx7h/t5d8pR?=
 =?us-ascii?Q?fgLoJ7WVxvPQ7pJ4ux3/VzNWamCYf8eYpZrqIEpHGxaJa05pnX7VXfAWIeJ9?=
 =?us-ascii?Q?QDqxqz2bpLAQ7sjf1FlleKU9u2Aii1PHxQ4Ez9l+bbNFl2o/TL9wy8sPD4MT?=
 =?us-ascii?Q?FXclBnFzJkTbWi0j2sDBTE8Fevk8T/Oqdqp9L4bJZcQQ6yGlqmZbkOuy/7tL?=
 =?us-ascii?Q?XE1c8NocKgxxJuXaQIIFJsL+ldIz4nEceWktOdmrmnR0L4Gh30KvWz+WaTEv?=
 =?us-ascii?Q?PCGYWopc1MAaFeVag3vaBIkfS3QuH5Rz8n/cGUlMaS4wrBCCpkHot6w/jEVH?=
 =?us-ascii?Q?EumS4OD0IYKHJF6CM2BvpEFt6aLUmk/kQrJDmP4/vRdpI5J4fFfoeder9eqD?=
 =?us-ascii?Q?z9rsz7zB2KZmFheuYhApjvXU22tINFR6sH6uI8dmPCYrjAR+v9voae0TdPK/?=
 =?us-ascii?Q?ZGcPMfgNqOfE/1hWd5tDXVRicZSvY/XlbD/RygPFNuX4loujw/cINMFzujZN?=
 =?us-ascii?Q?e7ppjAOeoTMuogO/TOmUski5O/CpDrshH3KqPukaKG+lavCqXgmiDocKFWCI?=
 =?us-ascii?Q?qQFi6L2tbHE0XjLrqGUUMV1FTwYImOZuDlGIPD9tspy+n8896d/iR/XfL0EQ?=
 =?us-ascii?Q?AxwqlH4ry1+8RrmqZD//3QI42aFodXIjVHg8dRQB2SaTEmJAOKPchXXdeA6J?=
 =?us-ascii?Q?n/w0BinaS5iNWV6qZQNYZCdMz9Kk6QdM3VWSjiN7G7y3iL11f5XNi0eOBUSm?=
 =?us-ascii?Q?e7RUip8dwi/lTPNd8WqVQGdsd6N1AXztIkjM0N5w9W6FZYAzQF3oAng9YBqH?=
 =?us-ascii?Q?zZBYiw/L5pZtJO21nmMzQ0XFQj0qRtBti+Z6WOSWDveTq44pVMVmQ9fiHqO1?=
 =?us-ascii?Q?rr6zY0QFrLEEGyxF9Cr9rCkbjYHtWsMuMDSQeBPbJbj5XU2IKfmSrZLwNKKn?=
 =?us-ascii?Q?5ATlvnSRhPmo21sqhWu5xynjVlKZNU8UqTANe8qeNDcny4xyHHIiQcBPeasi?=
 =?us-ascii?Q?ozRCPtdtNOWjlTNqmpL6+Su2nGV7D8xkrebJJts9uTBDM6CcMbab6hre1vdJ?=
 =?us-ascii?Q?tO6ZSii+eFqc1b+g+nD70t1RZT+nB8IaGIYjtnde9sEFm4Z+FKmist18ZC7+?=
 =?us-ascii?Q?44oDLVk6zveCL4nL9+2o04/v00+T37Wrbkp9bpcBI0gUWdOg2MTylJw6ZCGu?=
 =?us-ascii?Q?+Py3M4oac8Q5goo1leXV6FCZwU1bTRdGl3RF0Nh1LlsilCt9qAWBQlxeH8PS?=
 =?us-ascii?Q?yZkXv/I/066gNSryYEMOyYMvduCJctAX2kyG9yfQFxOyLiZ4TNo3KhmpuAGR?=
 =?us-ascii?Q?gaJet8Gc+3UfRKK4kHzN0lsT29lE9Ub/zeWXBh3/k2uYv3Ahmf7BWqnteIK1?=
 =?us-ascii?Q?ilnBmNaivcYUs/WKhEvi6u/1xZRJ4ktJVY8PE518s7pXs1p1U3ZsYJjoKMvi?=
 =?us-ascii?Q?xm9+apNwi4jIWRveqEOdLHg02RY2ktevX6oN422koeKd8mrGe6eGlTGw/NEg?=
 =?us-ascii?Q?ejWkxx/Dou+zwEmxkuI+WTPDlgGbLSw+bh/a1K4gQpDE345KfVUkH84uwb4P?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?j/EACfiZDUt1CN2Dr5uTB0kXc+1Jw+2ayh9OTKUWSsN54Ruogw0BwgqMNLpC?=
 =?us-ascii?Q?Y7ryqv4F/ooZLzffgn9uQ+9xxAGjrDHb8fDqs9TCrkoRRseHnzTlGlEZ0I+r?=
 =?us-ascii?Q?BSWKbdvI0ORN9JfokATgj0CWmmq/aDW+MGVEG0hgpEx6U4jsnLcpFnG2udYJ?=
 =?us-ascii?Q?zBdQHWIbMWCOMbGWpCw6WoSsDA3A7uI5/7kG/RUlE0HzGP9hQV34KSOWCMip?=
 =?us-ascii?Q?Qs1Nss9BidgLjzys6k8g8AFtNhrxkKlOjOqSnOUoC/iEU+IQypZxSFfEsEec?=
 =?us-ascii?Q?ib32pZEzxIwB8wZcj9Z5MjVaNkBqGJBfJaXceFJorzqz7BKnRMyaLSMVLnjI?=
 =?us-ascii?Q?ETtRH1eMYpXfk3y+QsuPcuhVYEaBrKuKjg1YdMGRG92c6N7wfdAhjYBNH03P?=
 =?us-ascii?Q?3sFoy13xADk8wzsFnW211+GVT8x9uJmlsxnEGvEVycL4tl40JfxYLd7LJUCr?=
 =?us-ascii?Q?HRvit+2LWGcxlB1FAeNw6Zrs7Cuhw/gx+IrsUjaOJneFMV93QSTrUXYRiLa0?=
 =?us-ascii?Q?72m2HFT2aW4hQl73EDPDOULZdgIiG9HBXnCNDELRvpeY3XV3dpY0xURSsgDA?=
 =?us-ascii?Q?EGD2rWexZt3Z9aRR5+dX7KWTwYUyaoBZ92TJy+vsBbvvVMDakuzSPxl+NIpb?=
 =?us-ascii?Q?tENBMIbN+omNYB/RLWM0e80BSn41aBR7gNLHs4iXF8EKrzCpQ5tSIWgZ+4kX?=
 =?us-ascii?Q?u3f0qTvk8llS4u1W0XSTwg62uuYZPeE22K0sjdjAfV7oeiE5hxvvsNR723su?=
 =?us-ascii?Q?4gN5Ee/C9j1xH7W/M3o1imT2xicmtO0OkNwxLb5RgDKYDmS/BkAS2l3GQiTy?=
 =?us-ascii?Q?tKZ7DJvHyI6i0+VYGgozFevHlXY3ON3gFlk2i4Ob+uYqze5EjllQL4EOeoxi?=
 =?us-ascii?Q?pT0KXTbx/ArTlXAXR9lBjhNidXKcpyl5lPacXCOakoTK+lytc03eThDc/6T0?=
 =?us-ascii?Q?YgZBHXv7GPehwW+n5TFX2usw2fd4RDp+1k9jhyfRR/s=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00ebd942-e9d0-4614-b1a0-08db7dc09f20
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2023 01:30:46.1028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B6fHmDEOowDShJWh9Kh0kZk6K1Ik+dzvvAeobaJrGmISNDVbnX+vafP9/GsfdRx/zO99Vb0aXID0U6mvsDgfOPSRaWtW+XLCxHC5Ohs1t84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7466
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-05_11,2023-07-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=858
 suspectscore=0 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307060011
X-Proofpoint-ORIG-GUID: jCfXDJUV41KJz0ldGLN9bFd5nTc7nNYT
X-Proofpoint-GUID: jCfXDJUV41KJz0ldGLN9bFd5nTc7nNYT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> Smatch and Clang both complain that LOGIN_TEMPLATE_SIZE is more than
> sizeof(ha->plogi_els_payld.fl_csp).

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
