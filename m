Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA2FFC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Dec 2021 04:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbhLWEpp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 23:45:45 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:59374 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229704AbhLWEpo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Dec 2021 23:45:44 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BN0JQsX016934;
        Thu, 23 Dec 2021 04:45:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=3HcyYOZQkJLVInvFYlZf2JUWCBF906NIjzHSOdAENgU=;
 b=OGWX3gzDcgh1UcedilZCS2zKLe/C3SDUdDGk7+VBTwXOHv7KWv4oVgIEo/jhGvCm/aKK
 SSsgHit/BWeVStO450l0BNNeK5Vp/Bm37Z99vhAbwsDFenP/21u0LJl2yNOmvoMJETxu
 0ULAKvUjBTKjZJqfo8DmQy1AQVgYDhV2MJzi1uC0nWCGa6pU7Q8IRZ15aEyEYDyu++My
 XAuInkZY0+J6DKAtBhqDHxO445o5gPpKsvLk4yb6CreecAJ+RHGFr8SbgO8rlmCL18TF
 F6avIFNROnVSQwAHNmLAuiOpjdz9vWn6LfKx3rHxX0Ynfer1NG5Km7liqysHz7dbcBIt Lg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3d46qn1mk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 04:45:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BN4j1jl036137;
        Thu, 23 Dec 2021 04:45:41 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by aserp3030.oracle.com with ESMTP id 3d15pfkm2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 04:45:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAb98EJw12x/RGNxk89vXEE8O8yH9cwCXEFB6i9MGukzEZ7PsCDFVq1fKJ4yp2bdByFBckYQwfijZVudaCJ9ftxghCcgkhpq74jF9c90eso5Mp+38xuuevTP2qnZWB+NzIYxUtKkNGBVL8CMsrdUKQHK+ZC4we1ekK2I2nIF43w4LhAPIS4VtWAun7n8KJt6rUmm6iqColc9fxrYQHGDAAh+qAMqR6FQnfluQX+4l4kFw4/yIhc7Nn+z07yuDYbNcnfH1wub/F0vkzkqqhHSyH5A8Nq8jORmjIaNLTIug8wBVm4gfz5i8CXYd3qQO/6OWtJM2SZTv8TTs73fKw0G/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3HcyYOZQkJLVInvFYlZf2JUWCBF906NIjzHSOdAENgU=;
 b=LqFmOC2QeAJtsEwz577sr+iEB2whCUJNvaniQZs7Iq+/aEIUq4yKh3KgpHFdhL4p8qZ0ybpXso6LqN5nVqTEycDrxGV9xdkIkGY23WXI9mzYUhrQAQzRttEkMRUvt5hBI6J6uGgxK4JlpFXCs2aC2VmwNCOv6JQGdno3ztvvdow0AbiakfR8Cot+qBix68sJtNfUzq1Dt7Y2Q9xfPCZQtKC2d/t894Yvhgt16Hsuu/cyKtgmkfC/Ncho+uBbL8kBDjVVqLXQYpYmo7tRJ9AonphxpXrTwBWxikE8p9i8Qt6zVPK4/Ya4tUMMxEEiEkjrlK0q41YhTXpxBa+UrF1vqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3HcyYOZQkJLVInvFYlZf2JUWCBF906NIjzHSOdAENgU=;
 b=R7hPUh+JCRPpu90p5vun4CcQvZsde+GrP0q31HnDGlJ6O8mq26lK2Bx32Gbz7gS/wv86c2x24Y2DmpHMlQycavGL9pAO4H5Iwq/K9gEnEFmfjdlslWGKl/HBX4fyDTbjaid7BZjhnvPSUazCu+unbSJs25fZuVV+PDOzBuvI7aU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4662.namprd10.prod.outlook.com (2603:10b6:510:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.16; Thu, 23 Dec
 2021 04:45:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e%8]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 04:45:39 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] initio: don't use GFP_DMA in initio_probe_one
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lf0cgc9g.fsf@ca-mkp.ca.oracle.com>
References: <20211222091630.922788-1-hch@lst.de>
Date:   Wed, 22 Dec 2021 23:45:37 -0500
In-Reply-To: <20211222091630.922788-1-hch@lst.de> (Christoph Hellwig's message
        of "Wed, 22 Dec 2021 10:16:30 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR2101CA0029.namprd21.prod.outlook.com
 (2603:10b6:805:106::39) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d659cec-e89e-44b1-f53c-08d9c5cf11b3
X-MS-TrafficTypeDiagnostic: PH0PR10MB4662:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4662F73BAA551FD7947287A78E7E9@PH0PR10MB4662.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1OcPCv+bsC7CItDuhXJVgP30UDFw3R70RR0yZ4POvD2wmxXIJNxC50rrRsTuRKUCAXeItVxtjeevKO3Fjwkv2Ni0tDHS5Idp++pUSMSUqBmsIf6qBYKaUofFV6gf1cPZzc44pTwmSENYV3keMxid8gMDf7PfBRJszy480Do6wOeG3oBqSRzgKOolcotULz29prtZLrjuJADs50HB7g+WelvOlxez4RoiSDU4yO/IDqPmLutBUQp/0F7SnPWjV3S730O4oCVXskNFAeUD5/lEqNNo6bae4xLz0+hldwd89YoOL9lsXD2pTRXRavTOERT9QKCLJa/eTf9bqG3MeHcuVWgoLL+gGB+z1S0aZhGQC4wPpaV/F3iIphdKvgj5yhEtRqZIdVpt77znsagMdcDicu5Gu5B/BfmQTlxJxyNO7RpdgNsg8KqmDp6AmtccR1BTDqb09irjCIOGTnjMwV3NZZoCluQPMso/fRLu7lZL3GcbKBeJ39Rt7ucwuXThGGUyuX029KTf3pwJl/t+co1CapIhZoSD6l2aq/HRwDtHHf1NNUf8b53Pu7tY2TlZoQtcaRxTydLgIgHPaafTZ1OMoTuQbO4OaqL1iCgU19jNg4p9e5vil6nSF2HgmX8FO692cz4EdSyZ4rFGgbkAww307vD25vboqOp8cgU5NFzXzp9XwLZ9tiAF5c5paSiB8uHw97fUXd+8bSoz1fY1FVdSAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36916002)(52116002)(316002)(86362001)(38100700002)(2906002)(6512007)(83380400001)(66556008)(66476007)(38350700002)(6916009)(26005)(186003)(8676002)(4326008)(8936002)(5660300002)(6506007)(66946007)(508600001)(6486002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fhEyDvy4misyEbNoLo3uY35ryTM8bsdXVns0V0ZhRuul19KcL1JrHZnlCbYq?=
 =?us-ascii?Q?FovBAVI/lKR4o3JOoFR2OFxnzzpLvuPeJN660JlFN2ImkU5ISBxO1CdIkt2g?=
 =?us-ascii?Q?Y1A9Lw8DqjvjMqeP9KuftJcJkAO9Kv41rfD/biAhj6IzIlAzBDDN7utNCQbB?=
 =?us-ascii?Q?DRcxKOLcsgi5SdxJpxqFEjVkT7Fd48tSDIBmKAAGM82284bIvSqvYUCwNSLi?=
 =?us-ascii?Q?qx1lxq3q3JgChOQhD+4uAasSsGmurLfp6z5UC4+UvGjYaEiEzaIMMxfM4uTb?=
 =?us-ascii?Q?GV9UZevMRcsb0HSvFO6uIjIahrjNR1uwctWOOKyUAFwUAMX04B4J5yiXqL01?=
 =?us-ascii?Q?J52b4OFWmDeyW2XGdf8RSHgSh4ziGY0E2JPxHQiv7aPzZvbyX8OBR56M7Dg8?=
 =?us-ascii?Q?y5yZ7oFzR4DKuDdcAKT6Aa4vI2Z6/PbVchFFkmfX/uoDD7NIQUFzIx/MmGIw?=
 =?us-ascii?Q?LaB39uF/bPxs4+zhp0AUyGNwlIQ1BcO7bNr25iYAW7dq/Fv/gDs0VZQcPJfN?=
 =?us-ascii?Q?tZA/j9gC8PeWUW2VwJiWVRHM9hQo5slzEEcF4Kcl9ZxxIsMoqORpnWck4KKw?=
 =?us-ascii?Q?+yw6qsQ0EvhHGdFGFFrBo1B/cVQKFDBJSEA4ntPLEIbkh9ps+COu6QmApQng?=
 =?us-ascii?Q?bVfAm2Qh2Hbep/5X3ZQuPOeN7/yxU50NDhzJOvvJ/N5wCf5sBH0WUP7Mhqem?=
 =?us-ascii?Q?JJxW7tkB+XH/gzY6WKDJlHjAK+cFSMHZYtydMRrE4Gh05rSejwKwPbje/2EQ?=
 =?us-ascii?Q?RvuQ+fO4uLRF2NBiLqgz5m1hJXe/BzbwaveHY1RxpE4skfpfZ/wAPX0oSjvq?=
 =?us-ascii?Q?hsGXvTGKn9IRhTVy4cnaJxcHAfvtlsXMRT9fkUBgyWh6gIew/BnuTnre9bSt?=
 =?us-ascii?Q?rDANDc6WxAqxe6krHw+ylAOUfSEO0fBFhCYvs6lrjdAsFbWKFktyRKbBm1S9?=
 =?us-ascii?Q?k6myyqJxXpCcxFwtIGK82ybDG2tyHK2uOGrWqHnMbw/7Wi9OdClCKR4qYkhi?=
 =?us-ascii?Q?HO/CtWr1WovtvSbNyFSzn3X4bz3xyYZ/1JDAYdKqMxFe/U2S/Rf8bkyuhIRA?=
 =?us-ascii?Q?kbWOcC+WXiOEGBGNmmaDrQd/gQFj1wo1qTpwf+ptLGSZHXrhM1kaugDb8J+6?=
 =?us-ascii?Q?nLx/KMkNW6JxPJapmcDK85zinb5L9UIFLmKqJnraAiG0B3byndXyNp4kXi25?=
 =?us-ascii?Q?1vbvqVZBS+2MzclTrgR0nH08YF7xTpf/2AoBO04P93eGt16nA+WricVDsqd2?=
 =?us-ascii?Q?IQHNHmC6G6yOuUGS/c2AdbFtZH0h6feFSvphybB4IJytheVRhj8KXo08iRlg?=
 =?us-ascii?Q?W7pEkcJRTblLToyXjHre8/cgupEylMJd8BLCALswz3WLSlQwtx4fxyq/crdO?=
 =?us-ascii?Q?+YiwWG4Ku9pv1XElWLkZ0KUrHJhgNDoLPQZbrMkFDMV9KnnWk/aOjTH73PE5?=
 =?us-ascii?Q?OILkD/3s2mVrp0tiYdKUEr6OQmEc+w1nnywbxwHrA6iKWgM1nJF65Kz07FXh?=
 =?us-ascii?Q?J0QhH3SH1rREYE5OekIwrCRi30cRuP62jq1Be0Xa3hnCg9ObSYPI0WJ9rCEy?=
 =?us-ascii?Q?my1hosZDY1skM3WMAaM2AJk1QAouSpMt2DtIDvNye7cW2/NbkNbK1II84aCY?=
 =?us-ascii?Q?xXSbdputdBFOZIbH5FmmpIX1scxzwteSEJkSzuqYL2a8Q3uoIZOyVGiEPGdp?=
 =?us-ascii?Q?r/d6ow=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d659cec-e89e-44b1-f53c-08d9c5cf11b3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 04:45:39.6325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GqJgacXzViaxkZ5tqIdHX2chRZlF+r3Alz8V/XPVL72CWFtmECPlEGYZMJcjEdNhzBlIFOkZrMCeYcZxnuOGGEo+n+HIulwLs9q8p3XEY0M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4662
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10206 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=688 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112230025
X-Proofpoint-ORIG-GUID: qQP0yn7rKDrFkLRlSzjKhCBolmBfsx6A
X-Proofpoint-GUID: qQP0yn7rKDrFkLRlSzjKhCBolmBfsx6A
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> The driver doesn't express DMA addressing limitation under 32-bits
> anywhere else, so remove the spurious GFP_DMA allocation.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
