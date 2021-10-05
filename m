Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7333C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 01:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B994A6137D
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 01:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhJEBmW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 21:42:22 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:16940 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229850AbhJEBmV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 21:42:21 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19515wme024348;
        Tue, 5 Oct 2021 01:40:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=e2pW31uF04fL6qx4y4ZV25TmxH5GeWUWr+6uZlPlDG4=;
 b=VmdsJnsOcj+f/Kl8ImlFJu/jnnEcE672tt590ZL60o1ta1SmVfeYl324rRFi3bvvQXtg
 Dt4J1yiNCb36ywVx6JZUuonIcAiHXGNXb+uwxYbwU/R8qq/jNadmAUJpcvTa/66OGHf6
 jykT3sAi++3fQPEtVMQFPsKLqz632ca4jE7yRGeHp67l9r/otoGzu9ZCD6WMW2OOiGAP
 8Wt8OK2gvNqm2hVuCVzR8N/6W6lYUIHy3eoc7oYQHG5P1pF2/GXO0JLdsOWGW+WxJz62
 MJC88Zr6e+G/vjudehBn7iiuospg8lN/kyay0iMuZTR2Y2Tfer2/mw7C6HpKezmdUis7 Eg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg454bxew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 01:40:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1951UdIT141707;
        Tue, 5 Oct 2021 01:40:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by userp3020.oracle.com with ESMTP id 3bf16s9qcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 01:40:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLizfU9yYdDfkZtnCitV9ko4YIgt+wWBcNMitau6naMcsHJHROfRpgCyTNSTbYXJPgb0EFkoCDrFMFxQm7ey9DvgDUyB+hmFajpnH82Mnk+04CjZmdGErVwLvefeThKmANflfKA/jWmqvF2C3AJHIZNR17C5vSVLQPKpd+/VxsmLCys4odJ6bi/evnzn7Ydi3BQb0s1USuFxnN8mmIiwitWgPlqtoDJKrk8s1Bp2fUGuy0TyCfVBedrjdeAcs/4FJFfvR4M+QLzwh5sEhXCqU6BzYexUOW86ucY6QVqf4/GVv1Ll4nqlK33hCAuFFloPUJS1hquA4c9doobQqFLjqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e2pW31uF04fL6qx4y4ZV25TmxH5GeWUWr+6uZlPlDG4=;
 b=nlztOHCcvZzBm58q8+avn51nZQRzMYYoVJT+waRnZ4bgXYs5nnm2wPDf3+gcxLN/X7Y0oz/bIt/9ihYZ5tfNw+LO4962mGrCkgAhoBQsBaLefqstdoJ1SQkKvR1bQg1cJNRNoutGe+moltP94HgqRxK7vG96mnoLO+jszgSapcEoSqWIf9gwsRMLRZl+wYBTU/hzM9gt5Qn5YsWX8pQeKBfjXoZRJtERGpDSe13lFWpQkC/GxnUX5KYmrhnlYxFK+WqMSabSG76nFZMR42OakvbU7FR1bk3E9ToGF0CLCCgvLd543MxxFzyKLZJGM2qLRBIHIqZ9y41b6E0N6LcpIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e2pW31uF04fL6qx4y4ZV25TmxH5GeWUWr+6uZlPlDG4=;
 b=ZLod/6eSnOLwNo8hmTNSXmZwctvQszGS3vjQExbbteMTwg+y4Jx3tLlSLmBZzyubx22sABMZI3Su/nqH6pL+Ty8xGR3nXQl6CjEL6CYRPJZ3UsftvMEcsvWwWzDpgWskNIBPoaX/kx0tQIxpDpKaSe1NmYK2ZjOzF4omHQkXaP4=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4677.namprd10.prod.outlook.com (2603:10b6:510:3d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 5 Oct
 2021 01:40:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 01:40:24 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: core: Fix spelling in a source code comment
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnms8d1f.fsf@ca-mkp.ca.oracle.com>
References: <20210929182318.2060489-1-bvanassche@acm.org>
Date:   Mon, 04 Oct 2021 21:40:21 -0400
In-Reply-To: <20210929182318.2060489-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 29 Sep 2021 11:23:18 -0700")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0012.namprd20.prod.outlook.com
 (2603:10b6:208:e8::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.0) by MN2PR20CA0012.namprd20.prod.outlook.com (2603:10b6:208:e8::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Tue, 5 Oct 2021 01:40:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 127c1a5b-b7f0-496d-17a9-08d987a119a0
X-MS-TrafficTypeDiagnostic: PH0PR10MB4677:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4677026B7E9AFFFA59C579AA8EAF9@PH0PR10MB4677.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7fq2bxTSKT/olE/J1ckhMun1hwBk1xEo/Nncb6lLStY4HVQxwNQpViJGjnuBVo/eSy28oDffvnOfpGeUNxwg+6ZxmjkYlKlrPW3ZNLlUMQbKhZJeqUTA8Fx+0qWIqY/GFzy9tlCQNHHSjlpmaWlLgAlUwmXtr1OYsl7Ep48ehmz1chALK0UOpRgL187jEhCAPqLwVL3M81LJb+8esG8/bJu0w7E7K2b9gM92VdGjCkzBe+Lf/pbzRzp7g8q9dwSRNQOjFOVwmVOuw5ywp1Gj7HGPh3AtyGvigJg1OvEvyKo5Nm7xBuoerP9tsDeyPT2yG/fonW6B7TwHzUfcKnkgygL5g93M/OsmutlbaLKYBUVwaSezs6fRk+H2nIACkw+HZUcZF0E6mhuzWngtrF7pWY6wrGz9xoualcaowIBj9DVXvbB/gUCUfdtZVzsgyF1STH7N8EJ5ZZw7wvsMNctdeBMI2ryRCwhGRopO0/YFQVO+dWwnOmYHEtd5E/WWtktmanf5dO5GX47U/EEtC3pDcr85/fOgCJLSxWRoejDZo9jm+NEZHqB2DhWB0l9pf3Tg41y2m6HNyMNN/c0WDv+EJ283jJ3Fffr5NaCtwWKKR3Ao4dXLbe829fKeO5cjPEGUUbePXVq0SDPsjvZOdlj74jMtQkR9An3+HKMC+hKPnVmqf9UXtTFalt+5YEIPkpwp++4fvONGeVSJOH6zhORO1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(55016002)(186003)(26005)(66476007)(5660300002)(66556008)(6916009)(66946007)(4326008)(2906002)(38100700002)(38350700002)(52116002)(36916002)(7696005)(956004)(8676002)(316002)(54906003)(508600001)(8936002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XERpk5J7fXIpvPGZzG0mce8m8+vOX0oWLr7lvQVb9hwuHzUeUZpJwAHqWwUi?=
 =?us-ascii?Q?YKwdZ5hlfSFX4cV9NbWtZVSdtM/yNTtFYYM2UtOzdQGmIiex77oNBIjifx9h?=
 =?us-ascii?Q?F1FutLRfsiHLprasKoCiqHs38yAU6sV4DOwG3FtDLHiGkLkEjJb+cztx3Ej5?=
 =?us-ascii?Q?mXexEr8D+QmtViUAhVXaWT0/th81nvTFn6WXaPzckUhwuiPd8fY+RlNUbOtm?=
 =?us-ascii?Q?kkvUb1t8j/IrBMkVKeeNDm1BeGNMQGlb08bqMBL27+8jvRP2aOdMKhj7E/RT?=
 =?us-ascii?Q?TPKvEBpOnFQ4fQoUmxH32Rd8zrNGed71/UuRclk129zyQwi9xi/x3oiKtnp6?=
 =?us-ascii?Q?5k4ZKBLcp6zkxKOZH0h5Ab8iV3qf3uAF+kBsANw5s9QperVPNNaIlodxXSO1?=
 =?us-ascii?Q?S682DHSHZDmUF85hkP7uItWaT2K9g6UFhVjsYeZJYlK0xHppgoyk2nJxRcO8?=
 =?us-ascii?Q?sbRj9LUtytzU2eUHec2H97UkfIyqz16Ao+LHnlLfi/IhumY7wQvgKk52bB4G?=
 =?us-ascii?Q?9dhyGhSe6TNQwPf7Reu8pAs6WqOeOmiMaEEJLwrLVFbwOdCkE7vPllYfTsJU?=
 =?us-ascii?Q?LnZ4CEpX1Mn06tAfft55QEaLNnhT0P0OF7Mq6lMBFrGFmAlGRIA2GiKigBow?=
 =?us-ascii?Q?c4IJrLTEV1XZ2Xd5H1xaXH0u+1ayl/Axud4NEIylBqoASJ1v6yUoPBXKLz2P?=
 =?us-ascii?Q?hZrNLnGSRDDkIeokhmBLOou6vkcWGr4SgZHsxW92FWG+KJgluR3ThqMvszNg?=
 =?us-ascii?Q?yHfN7f/yanT0NNNJvq683NoYthJE0/NS6j8lstkmPlZ00ExXW2VlVh6C5d37?=
 =?us-ascii?Q?qY0Xdl4GHnUCJFXgDYCu1nNBNpT20MWr22kOCsI/MH09dxvzCkIj0PRyVZRW?=
 =?us-ascii?Q?slw1GlFPpPKT/fXULSJ/ZEj1Fgo4aqhGcBjfVLXA+idUFTD/6pEYCeKQolCy?=
 =?us-ascii?Q?I+bV71v2gEDnLwNpGQA6Vj+NdOuc+TstqkGzgV8Cjg30/qzaNrWuUghaHwMM?=
 =?us-ascii?Q?+OLU4PQV2yI9o8FaV6TNLMZ6HZKsdS0pZDzaJbhhJ96ocSF2c9i0SR+dhTLt?=
 =?us-ascii?Q?zu0Jn+6Kja0vxgh7M++gf2RzvrBmrM/Z+gfxTEXhHpT0q/V6XgNziklcqyqM?=
 =?us-ascii?Q?M6dpcsfUTz9gK9pJhsVm8O38nd5u8QvN0Z5I2I/pU1AgZkNHReqF2omb7X5w?=
 =?us-ascii?Q?/P926getvBsd4B+H++PBh4WM6WarVp6WsAOLnwPMHyPQysNvQ8udfPkCrBYo?=
 =?us-ascii?Q?lq32s5NKvtxVHO0PKhzkiSVO3VknJmt2nOeQPXNS4ysgjzmvbzkpU3jpbqZe?=
 =?us-ascii?Q?A4dUsAwLk9vgOF3vH6DO3KLb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 127c1a5b-b7f0-496d-17a9-08d987a119a0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 01:40:24.0336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VxeaGQ4WRhEfre1VoFWZkbYmGyIWBR036NV5yNYZ+fmqmf3JcVIkVdlgN+wJqPA3TlrEKA0ChVIiv2V40ic/umZyzA+xYO9z4g6x+gE5N1c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4677
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050007
X-Proofpoint-GUID: rxpoNdnsST0ZvDFikqB3tptaYEIrE2hb
X-Proofpoint-ORIG-GUID: rxpoNdnsST0ZvDFikqB3tptaYEIrE2hb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> The typo in this source code comment makes the comment confusing. Clear up
> the confusion by fixing the typo.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
