Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1EDBC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE2A76120A
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbhHXDYv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 23:24:51 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:32990 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234107AbhHXDYt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 23:24:49 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O0xBaf014822;
        Tue, 24 Aug 2021 03:23:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ccrZocl5NS2TB2nfqgGidGuJ2A7K1bFE0poNjUkXcFo=;
 b=uqaZPwodmpS4V7bAxQAiTiA+LzWYZg32jMvYxIr+83hmpWfS+XwXjkpH9temvv7vxgEt
 7vjh2xDZHUPvcvthyJ5/rwuu2WjQTf2VaRJbk2RSZ1Kkdx7S3S9jiabIxw4hm1PiGugl
 MLOc9KiM51sROZeXjiXxIlHrmAkUIzMRcO9ji7EsT9F9s3HTf3dUf7edHe7SNojuZEW1
 YQHQUu3pboU9xjr4qXQHtOis+RpOd6iMeh4NljVJzy+4RVBWsi1jfa2DmFgiUVTGz6HK
 38kP0cnEO0MH1U75jmd2kg/HNp26p2NeS8wLK8GUTYpXAae4R6LARtf7QY519GcHVGTZ +Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ccrZocl5NS2TB2nfqgGidGuJ2A7K1bFE0poNjUkXcFo=;
 b=cuuPDJtpzaCoRV+2aKW8OnNa4kIeROdHKeoi+/LI6GU2wIyIl/Z/SS/GEC/YafWS4FjF
 OCXO6xyRQSdlQXOmgVnhF1eXr0KFWjMTCZrvkygd83UKs9jD4dH2Q5VgRXMTQm/DJJiw
 S9p1j3LhZqIzjrJD79lcqzQo9CSe9D7uLh/vbbN/9dAoCZp01b4kjUyWBNcFzTQP/8vL
 KldfHrNvJuS+aF2iqpj1LH60357KTOtQIyCn8Nlfl4VxAqq6zVL5rHzFtwtZasiQXkJy
 Su7vFA9GioKxp3kOnxpPz1FBmS46XTk4ozBLCAVtGsPbWFDfxeg+i/Jn5xvaZX+kXiXd pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akuswk87v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:23:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17O3BI8J030153;
        Tue, 24 Aug 2021 03:23:46 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by aserp3030.oracle.com with ESMTP id 3ajqhdtbmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:23:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UpQt+J6jmHTk7kAWyv/ZRQjFRoU8tFGGz2lJ1juO1yvf1mLUmy3JdZN2HfdnAoaef/EG/D7CN/R2/4g4YbSHFrgzDoA3NVN4LKs9QPkmuaeFo1jUNLg10GHv3pWTxt120ZKEbZMxpTzS51w6NN7B+/J0ATb3Gbt4tWzQ6BFZ3Ei/lq3lY1KtGFptsO1Y3so8jPRZKHd9jExRnSLYySmJDLCBd0eKA2VLrdSMQHO/4fXBCRMWsit1Q+s83DY0vPeAE5/kNgv9RhuqB9gZIK3khJ4mFBGpYIkKe9ZLXq6LCqtN/T4s3DxOQM4yjtQo9DS74RlJ5TIj3osGCIlgBsclsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccrZocl5NS2TB2nfqgGidGuJ2A7K1bFE0poNjUkXcFo=;
 b=lhLOsHsTnOuGSlOe5tw67eo264nOIAoHr2Ba7tNnC8RNmRKpCTGAXvmYsYIaiSEDkUgggCM2imGNUeC0h9Hk/C4U/zaIVX7KqQPPumpm6V0dSO9PQKYJMon9o0/O0IUeNC/qiEvfbBIOOiXSHyI8m2UYXXJUCUeNbECuk+h3aKtmgVCCPggdQa45asziGdROnQJygd64ey40ut+oyATye010331pNN1rU0WWZZe50aENhFTDQWX2NySy27OIS6J9l4hjXJKv/9fwTpZswHWrTCIZIRjpqJu6FM3vXvLp1GX4LsS+SdZbDIJxPJ6923UukQh5hSrMW9Dpmw21g7CswQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccrZocl5NS2TB2nfqgGidGuJ2A7K1bFE0poNjUkXcFo=;
 b=lqkcxxckSU0Lk2q5VQ5BauQ5XP+IM+lVrlKIE7vNNPyLRO6Ni3TAUF0nmIl0MuU4/tlrCy56bbUtExTFPamrc+K/pIBBfRSxB/xQS1P8c63MyY99ok75qLfwdwWHF4onJxoNSQm/xfdMWCIfKcyAv/mSsyJWiRo2nWKCXfktgLE=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5609.namprd10.prod.outlook.com (2603:10b6:510:f7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Tue, 24 Aug
 2021 03:23:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 03:23:43 +0000
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, oliver.sang@intel.com
Subject: Re: [PATCH] scsi: scsi_ioctl: fix error code propagation in SG_IO
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtp7edao.fsf@ca-mkp.ca.oracle.com>
References: <20210823133458.3536824-1-pasic@linux.ibm.com>
Date:   Mon, 23 Aug 2021 23:23:39 -0400
In-Reply-To: <20210823133458.3536824-1-pasic@linux.ibm.com> (Halil Pasic's
        message of "Mon, 23 Aug 2021 15:34:58 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0010.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7P222CA0010.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 03:23:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c67434a4-eefa-41b5-c8a2-08d966ae9355
X-MS-TrafficTypeDiagnostic: PH0PR10MB5609:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5609B7B3B8E0ED2B84292AFC8EC59@PH0PR10MB5609.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uE0xNTnQ+uV4gdnl/BtJyR8m9T18FVtTob9ShQrRmJSCePUY5LUT9w1dLuQvj7YJDTNd9t7UefzGSQuhvk8uUtTf182Fpy0kH9CJv5SUAwtDddQ2vKwHrI57A5Ndq0+otgpcvYZ9ph60BBH+b7Ywud1a14cPAVNXJF2b7Y6gChK+irAmc+qgnFwqjx4uVuVIiRUluy9qmyu2yxKmXAKAJyTTYfMDZu/UwBfrmG1IvzPXJHPn4+MPWxvKGnCfrAJZvOA7l2PkgpEB46VXUIjJ4O9GaR0Tgkbs5yWuFB5RREazkznsCd/80wRd7OTujUgD22Hav/E/axeBZIC2Z6QTWHWTwOYzt+k2zoh/H4hxDGrROagKafLfVrrl93HgYumPHKUYgeTIdKDZHUHbVgNAiP3OHZ86yuLwdYvAk9ZOuVqjmvAIv5uUcQfE3e96w6y3hABYt6MUzvkF5XflUvhmlyTEn2iNZPB9c8K257onaLEFTWVbNvtLSOAaANJE8fidYp4aop0DYYnMLCr/C6avBHKrIm4njSwDVT9f3F3B2/foCSxZElcFmqxuw8QmcH6UG5soEgtNMqbpekGowtm61FOYupk3tMDihWvfXIVGdKL203OmoX5PHWZWlEuMQ5EjPZTGHRp8tWnc+u+ueT3h4GxwEFMZyOIzOKUiWUHqvl5/AZvnGb89dHai2VsugohCZ5FUj/DG9XAr9PZKOhtbTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(346002)(366004)(54906003)(83380400001)(316002)(6916009)(26005)(55016002)(66946007)(8676002)(6666004)(478600001)(7416002)(52116002)(7696005)(66556008)(66476007)(36916002)(2906002)(956004)(5660300002)(4326008)(8936002)(558084003)(186003)(86362001)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qCUyn4JsvHYa22MDGQqDCMwTI1u/26vveJTe7u02KIHflfq1iW2RleTy5kB/?=
 =?us-ascii?Q?KvB7dRQfyQED4BR0D5LIP9k/kFvjvznjqxfqC98tA38lgBBilbDUBKWTx/uJ?=
 =?us-ascii?Q?Ok0IBHmM7yF3r3Zw6N/VR+5XnRRpLiehN0/oCeivWmPU7qqpwy87N8o/vkBk?=
 =?us-ascii?Q?t/s74SE+iswBXjov4zrBLpwFP6l7JTeo8uXAK29T9HZ05827b62ssL9YEwve?=
 =?us-ascii?Q?Wo39z2xoROGd3+YWw2AHv9TE/a1zPiH258t+9d+SM0u6LvJMPPr5R7C1fLJs?=
 =?us-ascii?Q?t1U7AlWkAGD3khRQo8b9kU6eywgBbRilCol2v+01Ld+VIjm701eszw3vDgG4?=
 =?us-ascii?Q?oAV5O89EGUK809JqqebGtrFuq/GXv6IjVUhswZcKkf+kMf4adA25/RZVQ/gD?=
 =?us-ascii?Q?4os21jOTa8qQMSUUq0SoOLZYRiMHnDN1WfE24DdJoU7F9K23Q0yWjq5ZdYCG?=
 =?us-ascii?Q?/XqnFvm4LdcTUnlBcrumrQv1PYmj/wn/ei6VaVAOlgIo5LzGkiLNbVSd40rn?=
 =?us-ascii?Q?GL88ohx00/qWDgRpr4dKEiiNl8mGjAzpc+7VZxXJPe4QDLNv31FX4YHcyMhl?=
 =?us-ascii?Q?pbL72cAFwHPsswiSU+LGeqeuXUXnsxXwWdZbj7pnos6D1kVIYaftCZwRZPfj?=
 =?us-ascii?Q?5/FiI6n3mkktpVvzfWnkiWFTTLt1ZlmetPkqpWrE9vOudqbXcEoWlA7gEc/d?=
 =?us-ascii?Q?RBOVk+4lKcKI5b23J6FKsDnthhO72RiXP2sSlspUlUk1FcxUscXchlbK19DF?=
 =?us-ascii?Q?meA5oFmj1+J/6+5RL6syFPkrRI9xGaziWFB47nDAS6AR5TDnK2PdQzJiE73i?=
 =?us-ascii?Q?Pl9u0z6BZfMvjiYW5Z4k/vSQNlnBngWn2tbWkEHFELeR9hOphWJvU5CON7j4?=
 =?us-ascii?Q?TSxPeErwyUTlrrSAun5COfAV9hYxZofw6DemKQH7+mPTQ32S3WutskapCx/E?=
 =?us-ascii?Q?a0LeMo2aMLxOE7Noi/57Fbku84zutKzLpqqOdtLQ9iC6uCPzg84A8Od6CyEL?=
 =?us-ascii?Q?i6P8pTFky71cWjCCfcq6aDG45Xzx6eoB4mqSCYWET09/cvpwUQQlz+EXK76M?=
 =?us-ascii?Q?eDO5dW32kERLoLvGFWXvhytW7N0oOddiCqBHzsmLKaRp/RUC3O9woRha1ZGc?=
 =?us-ascii?Q?QaRiiKolh7q5tcr3fuzLR+IC62DvfCWX+RSjH2NB2Bh2xzVNiqqf5l9pWV4d?=
 =?us-ascii?Q?npDADcLPN01UdLaKuWD3D/I+V4c5J93qpnH10V6cgYq2IkhEvwMT7hFTN6Bj?=
 =?us-ascii?Q?CqBU5Faqebqt9gdXY9DjWWxtRSvYJtHka0NhKaaoQ2/z5uaietyddAc+iNaI?=
 =?us-ascii?Q?Vf1OpnWoaghBKWam038MjK63?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c67434a4-eefa-41b5-c8a2-08d966ae9355
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 03:23:43.2707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BGI/RoDvaP25KRmNsxcOgW9OGdv73ourSQpj2XUCB/DGYpL8Fn9jO+P6HqNcmOEXcaEuhMW9Z4yofB/ThgjVVTUbaLzCNMqwy61RbM+aW60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5609
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=848 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240019
X-Proofpoint-ORIG-GUID: ZxYFe2mTQXdsnTENJYpKRRZKQYcMnBIO
X-Proofpoint-GUID: ZxYFe2mTQXdsnTENJYpKRRZKQYcMnBIO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Halil,

> Fixes: f2542a3be327 ("scsi: scsi_ioctl: Move the "block layer" SCSI
> ioctl handling to drivers/scsi")

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
