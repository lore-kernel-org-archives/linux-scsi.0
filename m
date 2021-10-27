Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A52D6C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 03:29:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89B8661073
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 03:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237941AbhJ0DbX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 23:31:23 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:31806 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232200AbhJ0DbW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 23:31:22 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R0msQB018048;
        Wed, 27 Oct 2021 03:28:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=qK7q/MS3nDlFEW8aL5aUf4aMOFeCRGFZkMFMlqSSBTg=;
 b=cZSRG8zFCC+S0V39TSbzeNN+wYgyJ1RjbZX/jnkhb8rPVOxqjtbCVJFmpe0QkxH5GI6R
 6/r/TpysWxDO0vZ5EhMR1nT4xUurWMroPtMJlpqdzI21uH8C/1ySSWlXTXj6TuSDCcly
 j8qvVxyb9VXZ3bKAtkvITVxbyf4XvjcilmqaEgfFO/YK/lvjCaAYsa9IH5w6FpwXXu4q
 rGsTbeZlOH+1In4ojBUOWHo/aBih4/PmZv6ptcC6ZQ52WDxsRIGXEL674lbjamAUV6K1
 nW0d4UmO2I0DveAU7MktwhEdAy5f36X+t5VnR7ossrjZFfvYgkdHlcA9WEicC+TBAa3Q GQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4g17eyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 03:28:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19R3FX0D092805;
        Wed, 27 Oct 2021 03:28:51 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by aserp3020.oracle.com with ESMTP id 3bx4gc1nmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 03:28:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/aLYTS/klPcYxveESeJ1gdEuNamPx/87qGvj2MvG6XgGKcXiyDvTeDwh5kvFmSff2YXNf1gAr73A5KF+CkO8d2UAG7KOtTHr6pg8N2KvSgbaVezDGxMBj1nncDnGB8jJaBGe4lA8cR/X6y6mxaj0WdJHh3lT7xWReIe52BieGGg3NXKh8RvOw0qgxhHRKHfxfmpUwu9QYXo4MBcDRLm2tUlqeUKncm9zTe62chVyZzkQ+biue1XsxrDLLlDXyUECY4jNrobtfPirJCKqMgva2PQzgZgqF8fYXMj5rHhxdh84aaHSkUpR0tH9DMCMTxvgLj5X6EhK32OZ5dAkc5N5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qK7q/MS3nDlFEW8aL5aUf4aMOFeCRGFZkMFMlqSSBTg=;
 b=Ng+M7hoXxKs4UV6XhII1zBYEGnCZc2Ofq8+P5A9um2cN5KZAQO2Wk1cnw5GWq2uHa01M9xhn9R5czEN83Z1cSruuwAdE7aKAYzwWRCr3RSBlEdlf0rWLODRG42IqGXEhXYUgCrZkhWumiKfSiyy/6tlMrjBihoURTqfKFjQHUJK9j9+SYmF3Wl9qxUlpRFHcCh7RKsglu2WVFXFuftxJb49VOHaxeHRpp/nVZYJBHBdS/dImlLNRIAWWuHyQqqw5Txzkca/Sm4QrCZnOFL/h2lRUAOZC3KiawyMWtwMPmPXUIdgekrwwmC7ZsS9EzHdDCd5WF7x9U00iwMmOQZ474A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qK7q/MS3nDlFEW8aL5aUf4aMOFeCRGFZkMFMlqSSBTg=;
 b=rpl2tYn5L4Lc3NBeUiq4oQrdQKJ4jNVdzDijCPkyatmQtAu2+qE5LrBCqHnT3JeYwTeb1JBDXz8mvLkmuOpJwsoIC2xaVZmPk3gj3L0Bui3oEickfp4gPSsictusc3gbxq2ShJn3kh7CZTtBJasWob97lYzhx21WO7E4K0x27Ik=
Authentication-Results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5449.namprd10.prod.outlook.com (2603:10b6:510:e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 03:28:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4649.014; Wed, 27 Oct 2021
 03:28:49 +0000
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     james.smart@broadcom.com, ram.vegesna@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com, dwagner@suse.de,
        hare@suse.de, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: libefc_sli: Use 'bitmap_zalloc()' when
 applicable
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lf2f16zd.fsf@ca-mkp.ca.oracle.com>
References: <2a0a83949fb896a0a236dcca94dfdc8486d489f5.1635104793.git.christophe.jaillet@wanadoo.fr>
Date:   Tue, 26 Oct 2021 23:28:47 -0400
In-Reply-To: <2a0a83949fb896a0a236dcca94dfdc8486d489f5.1635104793.git.christophe.jaillet@wanadoo.fr>
        (Christophe JAILLET's message of "Sun, 24 Oct 2021 21:48:09 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0338.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.42) by BL1PR13CA0338.namprd13.prod.outlook.com (2603:10b6:208:2c6::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12 via Frontend Transport; Wed, 27 Oct 2021 03:28:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7dd93b7b-259a-43eb-b41f-08d998f9e45d
X-MS-TrafficTypeDiagnostic: PH0PR10MB5449:
X-Microsoft-Antispam-PRVS: <PH0PR10MB544902470996E5438C4C3A968E859@PH0PR10MB5449.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5JKwqGKJ9tqJMvWfLC8gURnOcUkzv2zaEIPioYXgfUG+Kf1ok91ocZEGj7yYe7OnA8lAbvRwhPkgT4JtIWyNqMSGpMX55mO8Y0jOSosdXArsdX+8kE25aj3rqdWyHRXsGfr5LFNCFLD3TfJfBnclf4sh+zW/hQymn1flX/DC7176wppeqCNnUhT6GSieizigXku6qvwh3eWlFKjdmMrr6t9nYc2YI27sOSLoSbORBOr44RlZ5y2PhJ1uGKhxOJisrq56Ck2muEBiwh77Z2Hiaj+fxy6+mAuKFH/g4g2bJwTCmBZBCxAoJglIODqc7Kqn8VPYCvsu3QbFU2pdaVJi+c3q3xmt2DeC2wlbc26O608XFuC5+hsEHn7xWhrlGJ8pPNMWMkWxhtYp2tK0NldlX4jlLbhAUwFwGO+Oa+tQqvruLjafcOJBgDvYNPuQ1uWLH6+SzbyueXHXIkrySvwbefk/ivhTQ17O19Kc25o3e8b+EyfIxtSrap/qdkYw3NJv/a+N9PqHaTPoWtz/bp+/xJfNug94+6/FdVUr/T6/JjZ+lKbjg14Bnf0v/KCW450WKs8D4b6FIOkBKyJlj/sk5wJv2yOZChrM8NKWE7h4CtqANQfl1CGXAQuwvuYy4xpHQzpb2n0z+jB9MX/fS31QDilGzfV7ZRSBgBJv/tjeBttlwH0bgbFgc6EA1ntfyLPEa9pl+5rNRUV31SPdo8h9lQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(4326008)(186003)(6916009)(38100700002)(36916002)(7696005)(8676002)(956004)(316002)(66556008)(66476007)(8936002)(558084003)(86362001)(2906002)(5660300002)(38350700002)(66946007)(55016002)(52116002)(7416002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TaFspd2d/X8kKccccemrwrw7a+XOA0M2VImsMHad6d287k4Zi91H5lAgHY5Y?=
 =?us-ascii?Q?z11V65GZujhlQGAja4FfhLJWIBW8qlj9bZtjIWqv3bD0z1vthMl055i6jBz3?=
 =?us-ascii?Q?09jifqEohprv8p+9KsAY+HNfwv7rIlx/VrRT36t7pRKC5WMl5eqd9UDnwCV3?=
 =?us-ascii?Q?Dk5nzQ7CU++SIBqTpRtuIlNrunF6+LXDCXrYqrgrxI3zicRIXa+sirBVKwKT?=
 =?us-ascii?Q?LE4oFmswPbykkapczdwcYzdJYNgyTpDOmNDmAGahBqgM8ihj8B6KDoNWPCQL?=
 =?us-ascii?Q?qT8+EiO7ljukMB31uqw9zEbo5gRuxiIzpQAz1Y3phEpBXpQMnwHZGu27Eqe+?=
 =?us-ascii?Q?O1/PI/W1HAFWbmi4Oi3ufnMIVLraoqRZGeyEg4vaSAegGvsHD9OBS51+HGrr?=
 =?us-ascii?Q?un4AE4g9vq2eVxuNEglD4Fsku53lWCC8njhfG02bGYKrm+qT83vckx3rc2tg?=
 =?us-ascii?Q?Y95yzCiWMUwI5Mu3vgFwOEg3A+gdOvIqfMgEETy6bV5d9dzhaMulq78MUwff?=
 =?us-ascii?Q?3lbyvfpSt0KfACkBX7mJEXTfSRnLqJh5+rNUTp+L/VcSQw7VgJPdwmWYnUBr?=
 =?us-ascii?Q?eHqW4D6XVTSJpmTEfiY8paF+KccuYQKqMV1LLlFBjR4p9xFQcgGQ8G1G7Es8?=
 =?us-ascii?Q?NEK70nXS/ncLpIVErOXUF3kR3UaFII/r31a8LwuKI+M1mhA8oSndE1aoOV74?=
 =?us-ascii?Q?zmAEl7np9kUOCHQvouBm7qVxtBUsjKicgJRBv+mDBTiD5P7e5w2EPmjqZyJT?=
 =?us-ascii?Q?FBoWkmT04xlkOWjTp4JWQGKiR+7GbPOTY7Kgz9lspDeKquqIT4M3Vt9uhXA9?=
 =?us-ascii?Q?z4izldebZtc+YOxHc+nmuyeBI7qrX4QmFHhyHcdWQ5cn1SEzjKFBoGDbsq9x?=
 =?us-ascii?Q?aPOKTBscGouKM0ZcsoeD6/pSpDbb5Og94dQDtVvMxKsCniDqPhUtAVrsr5Zc?=
 =?us-ascii?Q?04elGVmhatkj8fKg8GqVnLYkQvSpNu7JX3GAj+VeGfEzHpxDaX/coIoO3nKA?=
 =?us-ascii?Q?N6vVRqxGis66fGM1UqLFUa4Te/pStHrP/dsh8GU0Z2OzDzmKS8Qy5/6coYOV?=
 =?us-ascii?Q?AWMQetJleUo8CuQnBOCFB9QjCnkAWlqalf1paiCMqjINpXc+sE2C78lG602A?=
 =?us-ascii?Q?noel2Dwibe4NGeUhSYccfo0hmBuThHbmuT+7en4ZTvEABFYbIrE+mlsugsOu?=
 =?us-ascii?Q?OynHbANS7SVJ7al9u4szjXRgtAl8EWi3ZnBvXb93pulzyWVEwNvzxBKztDcg?=
 =?us-ascii?Q?uHmFUloUqM7iwXfl6LL+wP/yioXxE2kG0e0M8hsSyGs5xBeP2zKr8H2omHaZ?=
 =?us-ascii?Q?g8lCo/IOnxD2dp42GqpCbaNwQvZ/udM+FJPTZokU8H5qq6l4K60wTAvkUVyd?=
 =?us-ascii?Q?ig74OJ97UfQZx4ecw7nF6XEe13Ku9MdJ3BOfukt1Sg8iVu+r30IEHzxvjcHR?=
 =?us-ascii?Q?WkIWS3wlJp9kK1F+Wkub3sAg9OAYG200BTKbsaOW+ook7toXBDCKFg/UTluD?=
 =?us-ascii?Q?fAk3nNUe0BS96pm1sQoNLCCT2H5//HIa7TOPHz9PaqpnsAj/4pErUja4FuhR?=
 =?us-ascii?Q?H875IqFTq9Q55Zi3hiarZ/WNnLew+Bs2CsN9uv7PAJtU2d2oX8NE/xILonez?=
 =?us-ascii?Q?ElWAQtFnFL52DK+bClZpp36S6ruufgQkommpWWjZFWAQOqfQmErRYE0narb0?=
 =?us-ascii?Q?RA99ew=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dd93b7b-259a-43eb-b41f-08d998f9e45d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 03:28:49.6435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +PNXmxQqJt8HIInnqMWmRWT4stTofBjRT093TOpN0sqFWAG9EjlFE9C7VnfPd4OS7eldOjd/FoJqcneJaa+bstBnRW1x/2m3bSOpdO8+Qb0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5449
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10149 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=886
 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110270017
X-Proofpoint-ORIG-GUID: q7DC-R08J-LQ7vGfr1j65yuYz0Q9psZL
X-Proofpoint-GUID: q7DC-R08J-LQ7vGfr1j65yuYz0Q9psZL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christophe,

> 'sli4->ext[i].use_map' is a bitmap. Use 'bitmap_zalloc()' to simplify
> code, improve the semantic and avoid some open-coded arithmetic in
> allocator arguments.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
