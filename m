Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9AB0C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 10:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F16B61284
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 10:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhKKKh6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 05:37:58 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:21620 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232921AbhKKKhz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Nov 2021 05:37:55 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AB9IAIg026260;
        Thu, 11 Nov 2021 10:35:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2021-07-09;
 bh=KG3nVKjhhDD3Zg9jMlVn6y3zdQW8cH+tucO3Igze9WE=;
 b=Xobym6BncOx+U4ZcKpqVLUVRZXrDR8gmWT8Ko3rdLwGVSqL/RdVWD1aoberUexO0zRun
 rm6KthZCXfw6O0ymAvkXq9wE1MPRQ8Ie1cXn0i8j4khMrQR9j2Rnc9zeuqe+e6gPjUUH
 7xx2IjlI9wKHX2Fz7/8IQuxXu7Y06mL0c2NkwmqAPHSOzB4T4YHlXj2W01D48UiA0v/u
 k8VRX/6eCT33japZ58GSssve+WKkm79nFfsGTEUNZtyeLYfZaDI8ewx5/QQAy4xp4Yqs
 LpxGQGyR78b8Z05SoCnT6LzXhcijMlw5QqnlPcleCfJHQfxj7GUKSLF/Bvie1sGySVHB 3A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c85nsht05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 10:35:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ABAW9Hq022829;
        Thu, 11 Nov 2021 10:35:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3030.oracle.com with ESMTP id 3c5frh03aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 10:35:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bIBZRI4BfVpnh7QI5YNS03+TAuqvUXphkYqThZtioANdi5xU0NFtiRlxAxeEI94AR0Hw6aO5L/3T5IQw2n2G2eMlz7srlmqYwpbTQMgQo/nW6KrKtDjJbxHxSy/mWGupPDRSkJ5MRdhNHU0HDoP+xkhNnchxjZSbT61h0e5vvBxMeC5nujDHfDSavFrPEwZilESIm0fx5tlu6PWIZyYsPhymeTTSaEaddsgGT/0uCkXM0X+xxbdt0vd8wuvRg24OaOuPNBT2u/Qod42SU7Ny+/D/kIomH+l7g7jBPPmjxtJ88EmRwd/6LRtV73gPGLKu6QQxYn06q5b2UTVi18NI8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/pTe+eNBaKTsbgOqWXciMsk5t5/gOb09wJjtXZfhSWI=;
 b=jSSP0a/ohQaHC7S7e/YepPJIWYktlw48hRsbicbCCAsMzRUEVr6DeDE3Nsdsa5RfcXeTtQbG6U0zBitRIQ2aPBTqQzczFPhd9/JMrnGLibVJDKR/Od7LbYFayQjedb7JosNnTzSGTw82gZQjkl791uUnvwat7LixxVvo3zaN/bu0+AExvTc8pvftagE9DzeHTQkxmJFSn1hHDuyGLQ/hKkl2NWJXBG7XO32MY5jutLkEYYrcdzPrJtc7ilWKHMmGJsUi8Uir51pGb8S49TWQE50XLI4DtcHeso+wd9I5bkS6i6mreNayl9s+vkQB83G2L+FAQi3S91q+woIxu+rvCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/pTe+eNBaKTsbgOqWXciMsk5t5/gOb09wJjtXZfhSWI=;
 b=akGEziB7br8uZoUnXPRZyq/ZYYJVrMs11A8fSY4I+RT2PSwLnYDadVhsLQgmqQX93hdfOhljIz8KVuFaAB4DgOtZo3QH6kT9pwOFYxHYl8s1TamwHhWMiDhMQ7RI8YuNf2NBjMMGJhvuj8IW6n56XRO6E7mjkjuPWIU1djq8lR4=
Authentication-Results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1550.namprd10.prod.outlook.com
 (2603:10b6:300:25::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 11 Nov
 2021 10:34:58 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4690.016; Thu, 11 Nov 2021
 10:34:57 +0000
Date:   Thu, 11 Nov 2021 13:34:32 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        gmalavali@marvell.com, hmadhani@marvell.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Fix memory leaks in the error handling
 path of 'qla2x00_mem_alloc()'
Message-ID: <20211111103432.GP2026@kadam>
References: <cc2fe0148944cfac5e58339bf98e76fd5c3a54b8.1636578573.git.christophe.jaillet@wanadoo.fr>
 <20211111091711.GO2001@kadam>
 <3ebffac9-3be4-d9d0-1cb0-f2517c0f78c5@wanadoo.fr>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3ebffac9-3be4-d9d0-1cb0-f2517c0f78c5@wanadoo.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0028.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::13)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNAP275CA0028.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Thu, 11 Nov 2021 10:34:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35ee51be-05f2-466f-2bf8-08d9a4fee866
X-MS-TrafficTypeDiagnostic: MWHPR10MB1550:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1550E0152C9BE623D629F1618E949@MWHPR10MB1550.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +EeCVy1uikYle5Ecjy8rRlkBGkt44Klrl4pHWhCn+23HmwQ95zSlHw8Q8ocp4tOgc21Gv5RwV4bnWUR8iXIUi+7qIo0wPzlTrtaw+I2Imh15bzZdgITIo+Pvxmhw8mCwDs4Q/CMK76JPFqB7d6S0/tJl5qKL1WBiLoArx2kj0TGS/p9phGa6DCxuZEx1wG2rLkMMlYEZbCE0gwqON0HchNJr3JsIZInfGFktrcEkX+gXT4nd47ZqtU6XdeSbWbkzLmsB37SEay0y42KPEPwCRXMyaa/qXNo/zi9boTVui6E2iGD8iR4jauduNlDVti2VbH4b/8R4ERBzG9Q3LtD7T8V1xHCKUddwAsj1VkKweWQxIMRDAwaeZ2Dtlz5VfL4e86JqOgUGbg8N4simYBsLmRn4nxWrG00ewCICEMLjXYMeiQ0+l9m1gAx9c/89v+P6am8QgRzbP1iBvxRyFXe15lEtWfr9ftZR4cw6/MwEd8uOTOhYKJk6Wz2LixAg+rIslQmTh0lbAm41neVPddXrJSshEfXLTQFLKyZrQC3QvT4s9i2X4cHA4lOdhLNlL4Zd/aQN4nVXzRGty1tNVLzT1uCh89uQZSmSlCqeQHiglplopjF+r9sMHvvhisTMEoJLPOwttIrk21ZxFT1CD+bUnhC84JTcX+Jc9EEq1V256iQZ75Ip29aazukSgmUEaU5qIDLmliboQKodFDhf85JNyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(9686003)(86362001)(52116002)(66574015)(38100700002)(83380400001)(1076003)(38350700002)(55016002)(33716001)(66946007)(186003)(6496006)(4326008)(8676002)(26005)(956004)(6666004)(33656002)(316002)(44832011)(9576002)(6916009)(66556008)(66476007)(508600001)(2906002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?No9FLubWTD/aIItqBPG8GewHwQp8RolNfhEipFs7TKJOaceRfZlX2KjSCj?=
 =?iso-8859-1?Q?ZU5vLAN4euILS1Bvh49Wg3MmSt7daU0xPvoPt+PKG3ras+ljN2flTBL/nE?=
 =?iso-8859-1?Q?6tu4WF0GbTRLUT0I2VCU86XVFMm9IR7DL63piFpujpWUuiwcn+w/VbP9kT?=
 =?iso-8859-1?Q?BrJ2/+PDF6yledhMzTxOzfXrsKumgKGQhGg6uH4Hi39aNke7yi04JnjIEI?=
 =?iso-8859-1?Q?renD87Hxkyo4D7zcje8zy4+w9LK+0Eb76tvSyKQI5DRiZLS8Yla7b4HGs5?=
 =?iso-8859-1?Q?RH+QEey8E+iOCW8wcnSRjsfDq3VOv40/gvlrImg5VZZ9dmt83BwgAfgo6a?=
 =?iso-8859-1?Q?FOMvsEGt9lltP/NoRamAoAKF5q8xoagurgTltzrfDaahrHV/I41keEiSdN?=
 =?iso-8859-1?Q?aV81QksznJgR7oADciKduOG9/X0/cKPciVuVcqe6JDEjnG5rRGGbR02tM8?=
 =?iso-8859-1?Q?XMS8QmA2iIqGasMMw8x7LJbE0IQd7ZB0GErrIx8DMJ9mLov+D5dBDXJ8t9?=
 =?iso-8859-1?Q?xl2GGDMLj5cuY3UgojGxIYIqOUG7RAM8Y48gVxB9wQog5Tlb3/wi/0aFuv?=
 =?iso-8859-1?Q?KbuiLIK/k68io1OWgPMSMBLKGJyakjwZ7yPandJ57kgaUsQ/EQk3NYnVwz?=
 =?iso-8859-1?Q?2YxasE8k7Y016gl9xJMHoHxUB2xgTnPxhinU9q8kRO92ZOuNbtfdt2ZokK?=
 =?iso-8859-1?Q?DqoGNvnprclTH4uqSP5aYbPF2f9PN3mJOBSYi4/BbJ0fN6kOH0nm3r6mEQ?=
 =?iso-8859-1?Q?v73ix2aEVDhRyDaJy483jdB1PxNKPyMb34GMkJ8ymNuiel7nuBS/fNpd6r?=
 =?iso-8859-1?Q?jvX7LOb0MSNlzGpn3Qu24jGVQA+zYRHZoheiW8De71onLziiQ4tHzt7rZb?=
 =?iso-8859-1?Q?RgSJ0cOhAUrRd/qoLU5AqzoNgN3LcVXZEa0kkzGBIecmD5rXweE/uLdGol?=
 =?iso-8859-1?Q?aaazsNmemo4Fyb7nxe0XwRBuI1wp+E7DoF43dgDHnstbFTGAgx3JMbkCKv?=
 =?iso-8859-1?Q?5HlKBvGMoey6sfQ0oQf1GbWY9Y/b2HugpVRqqAhhgLy7qY9CtdBbeHyqGJ?=
 =?iso-8859-1?Q?en9WvCFM5t3G7cB3VZkeT6lWvmwSWo+YS0zqWuA1cRGyHAh6aGmI0akdL4?=
 =?iso-8859-1?Q?PZlDx9h0YvRkhACg7nyoWUvMro3+hdc76DczxN1Mhq6R4O3IElvxLcu5nP?=
 =?iso-8859-1?Q?PJP6JXzzIsl6dtKHQYtbrGl4npSw03R/qDFnhUaqj/iEmJqxC1gEG+GD4T?=
 =?iso-8859-1?Q?Y4aHHBnsh7mImibfyW+OgORtVHO87SN+VkeCDFd8nRoCUb4h4UvbU8JNEu?=
 =?iso-8859-1?Q?NilX9Kdv89RceHnqMOwzCF4yS6uLDdZ79Z4O90PlMVnmUcsJU8L06DKAN4?=
 =?iso-8859-1?Q?yyx7TAqKF3QB2mFf2UbELvO1389T8flTH7ZKJyKUQryUHI+c2AQC5zvAhO?=
 =?iso-8859-1?Q?PZz228Yt33vCUgu/wsMXstrQe+DdBmEB977gV0YvgTXxVb8lxZPTKJ68so?=
 =?iso-8859-1?Q?PQQhwgVmg87Q9VT0Z/s3w5/a7eX3GdtJyZFoApjrs4lajCLXg31Xtcn+CF?=
 =?iso-8859-1?Q?tRz2rlMX9O+GbCevBfQIU8eMJ87OIDmSM6TdHqiw+xwTxY0BsW0Wo9ihXM?=
 =?iso-8859-1?Q?TRZY2hH8Kt1hU7QKGpWZQTrazY4oDTRtYsXyjucD/1xhXJfHhbGqoZE2RV?=
 =?iso-8859-1?Q?C27HwheYq07Qy+uu7a02E5L6wDjnTQpo18WYDMpU16XdfpzVIivK32pHmh?=
 =?iso-8859-1?Q?ZhRV7ppAUvu/3n6NDf5Q4cR0U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35ee51be-05f2-466f-2bf8-08d9a4fee866
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 10:34:57.8643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5oySSoar8XcKHr4dd+fp5iM3z0XMFp73EFmEchCl5B7uewpsehwjk0gnn6YOmrPUCfK/DC5CWlJazzUSVRCb8n2QYMmZUhVjHJ+FrI1CbT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1550
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10164 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111110064
X-Proofpoint-GUID: ao78q5EKt3ZSDohUXJDt9szMFL6db1l6
X-Proofpoint-ORIG-GUID: ao78q5EKt3ZSDohUXJDt9szMFL6db1l6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 11, 2021 at 11:18:06AM +0100, Christophe JAILLET wrote:
> Le 11/11/2021 à 10:17, Dan Carpenter a écrit :
> > On Wed, Nov 10, 2021 at 10:11:34PM +0100, Christophe JAILLET wrote:
> > > In case of memory allocation failure, we should release many things and
> > > should not return directly.
> > > 
> > > The tricky part here, is that some (kzalloc + dma_pool_alloc) resources
> > > are allocated and stored in 'unusable' and a 'good' list.
> > > The 'good' list is then freed and only the 'unusable' list remains
> > > allocated.
> > > So, only this 'unusable' list is then freed in the error handling path of
> > > the function.
> > > 
> > > So, instead of adding even more code in this already huge function, just
> > > 'continue' (as already done if dma_pool_alloc() fails) instead of
> > > returning directly.
> > > 
> > > After the 'for' loop, we will then branch to the correct place of the
> > > error handling path when another memory allocation will (likely) fail
> > > afterward.
> > > 
> > > Fixes: 50b812755e97 ("scsi: qla2xxx: Fix DMA error when the DIF sg buffer crosses 4GB boundary")
> > > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > > ---
> > > Certainly not the best solution, but look 'safe' to me.
> > 
> > Your analysis seems correct, but this is deeply weird.
> I agree, deeply weird :)
> 
> >  It sort of looks
> > like this was debug code that was committed accidentally.  Neither
> > the "good" list nor the "unusable" are used except to print some debug
> > info:
> > 
> >                         ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0024,
> >                             "%s: dif dma pool (good=%u unusable=%u)\n",
> >                             __func__, ha->pool.good.count,
> >                             ha->pool.unusable.count);
> > 
> > The good list is freed immediately, and then there is a no-op free in
> > qla2x00_mem_free().
> I agree.
> 
> > The unusable list is preserved until qla2x00_mem_free()
> > but not used anywhere.
> I agree.
> 
> The logic in commit '50b812755e97' puzzled me a lot.
> I wonder why the 128 magic number in the for loop.
> 
> My understanding is:
>    - try to allocate things at start-up
>    - check if this allocation crosses the 4G limit (see commit log)
>    - keep the "unusable" allocation allocated, so that this memory is
> reserved (i.e. wasted) and won't be allocated later (see usage of the
> dif_bundl_pool dma pool in [1])

Ah, I considered that but didn't follow through on the analysis all the
way.  Possible!

regards,
dan carpenter

