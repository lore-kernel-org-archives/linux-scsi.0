Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F538C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 02:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ACA6619AE
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 02:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbhC3Cqv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 22:46:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46796 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbhC3Cqo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 22:46:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U2jVfQ192653;
        Tue, 30 Mar 2021 02:46:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=JpyTVesCzTciG5rtIF9R6o1HrWGbtD9EyUrGzmJnkl4=;
 b=dfQdKtaO41cvf0/7BN1r2eWr77zzE1cqyO06wwFfPdvJ5L6SQ+TxL2rFbptRZpnWtluK
 n9O+qhHRp5Os24OlsQeJ79Do3P7riIVdXHxLo1Bb47ezJrOKLiNwxgZ4znZTePQAegBE
 1Dv40cD+DiImNzDV+RLoGTgTcdnl46bvky+cSqJ7LrQODb7aSdJTTqklmq8E6nGTgVoh
 rjKwAf0RZY8luoG8Fg/lXO29UO0OS7Nr+Ym2mjVkf8Cuz2/ooDMxf1bkQujNSezt+T6Z
 eGp/kLzH2KYlvC5b+vDAVvS/J4s/LO46F8Hb+4lXq3EApWEY5/AUqw1GWB/jJwgFlZSq yg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37hv4r5g0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 02:46:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U2ikwL036715;
        Tue, 30 Mar 2021 02:46:39 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2041.outbound.protection.outlook.com [104.47.74.41])
        by aserp3020.oracle.com with ESMTP id 37jekxxep1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 02:46:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b67wtT3v6ibiLIx8DAAwJS8hDleXRShureGAw5RLyKhXoX0/2huWurtqXAnofOBaIp0nhYy25w6ECP0pgkLcYtKMaK6P7NeafdOztdhyNkh48UMOwKpQmQWwfpPKeQk+U041aCvOuVip6fDUuvxqdpa6fPJE6LhNMpc9ibctXZT15esbokT6H8SUXXmr2AVL+uJALY74ZV4WJzw55OhHs7pmiADyxN6ZxA1zgD6TYNIDtvO0wGba9+iD46PzgWMGh6s0gc2X/uFdCT8rEcNP/NMp0h4QyZk9SkFiYlSF7mHeCOY/UJim15GJA7icfd0mEo32SwUQgVZ90rvKK8smeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JpyTVesCzTciG5rtIF9R6o1HrWGbtD9EyUrGzmJnkl4=;
 b=C9DR/X9agVzxLQjEQsNWOW9zw67BteqA1iXVPbAqhRNmhPZ3HQ0Mc5MUlm5ASBYxFYNFRlzZcty9l775H+BgjfbHi27wJK4fAOOt82Pq22qntgFYfMkLFRC66s+PUIQCmNN5NMJCNN3SBnIeLAv661fVyOIsrfU/t3dpptoGCk9TknkiLxYX9SXyKdrp8RpR9POWb03zp2OuCMeOaemIxbYT+fZ1pTt+mDbKnTib+77YX8P8reJmYvEdVDhD/MxOOdB//LPLuCvV7DtZR9vqxZ3HJve/v/BeBl9CuC9srPKQS5VZjMiI8fOPuOE7TkObTLRi+vbQTMklOMRI3Wg1wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JpyTVesCzTciG5rtIF9R6o1HrWGbtD9EyUrGzmJnkl4=;
 b=yDmJNOmZzPUq0HHFFeXKuY5cHxOnMT6kcUSXKR+EhONdt7S/VL5Qs1AISyUm6ugkJw2AtcDPKyXT2XUwS4WBotY2SDyCKR2395n1ug0O+Dw/YZ5xit0cMfdUS0A2FjWdN900anftGVSCKUXHXrtdmoSSA/IC2tTf4xEEhmAzhrw=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.32; Tue, 30 Mar
 2021 02:46:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 02:46:37 +0000
To:     <lduncan@suse.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix fnic driver to remove bogus ratelimit messages.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135wdicjr.fsf@ca-mkp.ca.oracle.com>
References: <20210323172756.5743-1-lduncan@suse.com>
Date:   Mon, 29 Mar 2021 22:46:34 -0400
In-Reply-To: <20210323172756.5743-1-lduncan@suse.com> (lduncan@suse.com's
        message of "Tue, 23 Mar 2021 10:27:56 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:806:a7::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR10CA0006.namprd10.prod.outlook.com (2603:10b6:806:a7::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 02:46:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 706ec46b-e8f4-4975-21d3-08d8f32609e7
X-MS-TrafficTypeDiagnostic: PH0PR10MB4439:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4439513866BB4D13A930E66D8E7D9@PH0PR10MB4439.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aRatw1zzBJ6+lV4Dp4MNFNF6fuv8iW37Er2vsfXN0wsYCEh2h0LM4gLxjxG+X1LGxhLcebf44JQmSCuJK+bag3seMx36dYDLTaSdXNWhQKE4FVqj/Kib5kEoUMNlvdFGVo3PBJpPHIJzDJOVSsSwnV3ztBK77sbAWP+O+D1fV5MzTbgprhW/C5R0vJ1dTJuMgE4k2OCl7fFiFcMwfOjWmKx/S682wJ/E3CB7wjGN3rE+JlQU+hGKti6wkZmyGGhhcKYKYfsUPuKSuAjl0Mc5EQV1ruyURst+1nqB+Bn4h7rJaZ1xaY90Uo9C8AnZfn+z/VxvBxTKFWkDwps4X+XHvrEUJbnwDVqCfsv+XlI2ymz7zcngJqreCW6nxImbXPUrkNw3BqZozdw6lAtFHBV1SIj1DK2tuH1DjS9xQBn36tJAUguAqUMKcKQpc25+8zW+JFqAIIzvdCIP/DL9NlDKQiKspP/2K7VbaVf4/jHZ115y1VpOHZotC/j92Bd9jmLTXknDEPQQunG52zvwU9BNF3GSy9QqGGzIW5xpm1mn3B4J0SQHEfNZfiCwX/kptNTSpfa+Avw0WN4mkM6mb9+8gRMK1OajUsVjd3RYxxCuTemIASWOBGqUKi0B4jICxHYlnCrB/4YODmxVCziFo2pxZDiEji+6BaurlYSN5v4XZdg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(396003)(366004)(39860400002)(6916009)(4326008)(5660300002)(8676002)(478600001)(956004)(4744005)(8936002)(55016002)(36916002)(26005)(52116002)(2906002)(316002)(83380400001)(186003)(86362001)(16526019)(7696005)(66556008)(38100700001)(15650500001)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4hdHve2lZmgwJYMMo3nvP9Y2HRsZgd/jkm3sysyVnvtWESd3vwOVECI1Ad5J?=
 =?us-ascii?Q?exhzfiXYW01c5gFaRMvT8fGsoQEPDjTeGvRQYSICINtK01TerceaZxMHRunZ?=
 =?us-ascii?Q?qzfcfP/elb3uQFZ7762B4p2g3H0M8Hktn3kfADF53Rkd1sxebg3H7gJi4lVC?=
 =?us-ascii?Q?C4CdVXQJUYjhYA0AkLZBPkBU5wvaT6JOtQPuLmCcOyGiaZf7ALp1POmSzDDG?=
 =?us-ascii?Q?g8iO/EVPAyON0Dkgt63lwQYV6YHdN7GBKQkE0S5sd5EdaWRsROJjJNXID/5g?=
 =?us-ascii?Q?d0KJe8OjNzXXMgmVMv/aDFCVN6nAJrQNyHRZtNwGaJQz/vrPf/mLdgw+v00x?=
 =?us-ascii?Q?zbwcWms7bh3/qlLfCe65qyHaSiq9E42foxDyMNMlpN/lDYWUECnkE9QySUtg?=
 =?us-ascii?Q?gluLYCBA1zta9r7q/7dlEvFYGqbfzXsiQEWLpsWbantmiENdkdQ0kapKsdXw?=
 =?us-ascii?Q?CuCObGuhxUuEvorhtA00xTyfyBmYM0Eg3JcCZlBnuvcUiD6kgQT1mdxHKw/s?=
 =?us-ascii?Q?qtcZAPMhEqYbFJXVGr3kTG+xA6pWORHOz93cSx0nYkkpfMJ+zn3sB+quuGDp?=
 =?us-ascii?Q?J4lRb785Coz9MthpKtSNMDfLl7wAIb1wHUqvqq66K2LjXA4CN53jrk7P/tiN?=
 =?us-ascii?Q?B44miQnBMCtxBOWCfI0J5Ai0EMtXCgUQXsyyu61RocTQZfscXErPADGKXPeT?=
 =?us-ascii?Q?xLMjJv4WdeywOv0t0CAwxXc5T1SZz3AHZzwO93LruPSU7Z7dvQaumw8P8WyW?=
 =?us-ascii?Q?2rnCUiaz4TYjH9Z7ZFydhYOObDOv1ydEkCedH3YRh1+FMYgkeN+BNs1W5LEC?=
 =?us-ascii?Q?jNcuNEXFZQQxUUeD40u/hELn2rKEFxPwrRS4Dz0nYh3i6ieKiEvrO7At1ECl?=
 =?us-ascii?Q?tnNZ9QGQD5AhUvzkKH4vrvn3CGVRd3rv4s5clD5jYQWYh6hP3QFngcRWxGsO?=
 =?us-ascii?Q?tKcTEQXDUQx49fYnTuZzqWna9FvV/C5tBt63huyIpv9KaRyOL9ih60HspxDR?=
 =?us-ascii?Q?mndIUa/cKM026UkqM3ZaEpzbRQRcqnZ9sGF5gGWis1Djsd3PzyPrdspyeT7E?=
 =?us-ascii?Q?kWXOaNHdYLKTgznbt5GOMQT/aDAtBcfjfj0/sUlUP8LtGG/UMxOZb4aJx8uV?=
 =?us-ascii?Q?i7/lRYb1zO1Xolkxge1S2fFzGcgIdsks8lOLBIjPDLP/Bh9pgufnA6TfLP0v?=
 =?us-ascii?Q?siLw8bc6NBvwASu12IsJLoG92GjpVef4/2FIqpah8fQ0iyNcwqtF5MUmQ1Cv?=
 =?us-ascii?Q?xnxkKZFABZsnAe7QMtxZSPCmZPJMCrs9NaChZ22pXl9UR6AuqAJB4TUgMABK?=
 =?us-ascii?Q?AsRkjahUpJvGty5+dJlKqLXU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 706ec46b-e8f4-4975-21d3-08d8f32609e7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 02:46:37.5236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nk84R6KLrKUl97ZmCc8WQAt1zfboh3Y3xjrTeipC4m1EtLt+br4Y2iCdfWqc46AyKR7GKyqkcXarPQa7zSg1I/vS8jYwyMRu5Eswb9K9r3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300017
X-Proofpoint-ORIG-GUID: Y_fXlm7S9UG4Vg86dWXupWioCRcY9DAZ
X-Proofpoint-GUID: Y_fXlm7S9UG4Vg86dWXupWioCRcY9DAZ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Lee,

> Commit b43abcbbd5b1 ("scsi: fnic: Ratelimit printks to avoid looding
> when vlan is not set by the switch.i") added printk_ratelimit() in
> front of a couple of debug-mode messages, to reduce logging overrun
> when debugging the driver.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
