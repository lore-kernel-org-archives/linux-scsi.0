Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC1BC433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Oct 2022 03:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiJVDH6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Oct 2022 23:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiJVDHz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2022 23:07:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F96A29C3C2
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2022 20:07:54 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDlTa001545;
        Sat, 22 Oct 2022 03:07:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=JQAwSMu3bnq/nNT3xQJBGrOWhinT+4lTeM0k45BCc9E=;
 b=DDKerlTxInDiZnpd/ecXnp4TZhAwgnpS25HR8j8fNuo6A/HYete8HofULrlsi8eojHNM
 fwpyui94GaLKLgMgyDWnj++JF77nXHgFlL1RahpNy9+CD+swYuwxujRmraBsREUQKSHa
 cL/4U81QoiBj1oJo/yAUULNfB3zldq+zx+VQa6+5p9Afclo1Osv/4PGaiuMGwKNjhVRu
 YbbAk7dP/dRwXyrrv3Iou8wJSJ3JpK+3o1V3atlP480U5u3lI0lP3Gey89Co4TyeV1cH
 GVqB5rS3SoAIaUiObirXXMcQVn1BuUnEdwVMwYFXvZAfoc3S8ajCH2dUM0YNcAviS40f uA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k9awwdscx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Oct 2022 03:07:49 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29M1X78G032049;
        Sat, 22 Oct 2022 03:07:48 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y2h37w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Oct 2022 03:07:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jh7u4b7dc1N1XBIDLnHeiGKx7I64WW0v7fqhlV1k83uI2VzIHe/cXhLE8r6SOOLRBgzcWNxmCtfC60X4JMZX+ZbhCn2Fw9CdE0tZz72rV0NsjahQe9Bk8JaUoOdNKgiHhan5Tg27jMfb8uF7S0DKOP9Qoylu4ap4/4yzV/UKpKAa3cuIUgXUrFASmkXLnDKGu7dtmHJwWGbfT/JZh7W/DW9WumLypGsWPGybuNd4C1ltxywN3aIwQIgnqN749+0t9UMr3HqX/0U+4MnzJYnaaMJTXj1c0DQgISm1E+mvo8w5ire2VlqvEmDnVU05WLwy8LmOtYquTr++p//B/0iSsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JQAwSMu3bnq/nNT3xQJBGrOWhinT+4lTeM0k45BCc9E=;
 b=TVsEbyxFSd1CMDQNaOhb7kbUHJnjIl/D66VZkKWkGVolYtD9bZIyF51wkcLtwBvx1rkElXxx5MGW9wX5KH0xOwbkbVjSybH0sMjb91Ep/uhmGUjY7oHv2i0u3qLabxRc4ztNVxhYdn5S17yPomiVn98Qab3ruPwnkHHq+0DunjPB9NSJn+qZ7jr2YW9Vwu2akiLABXdbMqobhC2U54E7EZkmfziDQOQ7ovsPgdaFqa6tWywI6n9TWVX/LOy3Ut0yYAdfj6RyINmixBQtzzdSSVq87gBp/70ycZPfqF3REcUAeOyVgTzH5bvldT9nk0WicdAk/om+furEqwTA2ZUzMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQAwSMu3bnq/nNT3xQJBGrOWhinT+4lTeM0k45BCc9E=;
 b=iZSFp73dC+6PllCxTX1SnN7znJKvrMuwGgBZK/FI294+FgVHELtocqHqlzhJ9Seq5bOWFyK7oWHX+1Vsi7rZnWJeUcXAoBJdDtziEReZoEmPeCocFyYYOoTIz8fej8FiL+FQ9HTey8hrImu5hYLZ3ULfnTrKO1H0+wBxifU9ePw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CO6PR10MB5792.namprd10.prod.outlook.com (2603:10b6:303:14d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Sat, 22 Oct
 2022 03:07:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8714:e5ca:3c31:7bf]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8714:e5ca:3c31:7bf%7]) with mapi id 15.20.5723.035; Sat, 22 Oct 2022
 03:07:46 +0000
To:     Igor Pylypiv <ipylypiv@google.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jolly Shah <jollys@google.com>,
        Andrew Konecki <awkonecki@google.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: pm80xx: Remove unused reset_in_progress flag logic
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h6zwwo84.fsf@ca-mkp.ca.oracle.com>
References: <20221007230751.309363-1-ipylypiv@google.com>
Date:   Fri, 21 Oct 2022 23:07:43 -0400
In-Reply-To: <20221007230751.309363-1-ipylypiv@google.com> (Igor Pylypiv's
        message of "Fri, 7 Oct 2022 16:07:51 -0700")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CO6PR10MB5792:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b99770a-c682-4eb8-1b95-08dab3da97f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t8gOeDKQWp/vga7JjwcogHs1BrFZc1GZQEvM99Rvv3y67Lq68DbfDgL1gIEb6rs6m1m7O1+sHranWkGhdpBtqRnCZ0f70+bC20NwS3+qIu/j6KZDeE+gEUMReJi+g7UclaNHwgpTMu9U/aeNQrQZKKJxM61WHsVf/P+tqQTgGnrlOOmUphv9TWvdg7tizqJtxVcBoauXFEWTL2GxJWFmbgXApxxxNRwNMSH2gh7d4lPvW6Cu36zL024T6GzMeuoZoFWofJ2RzkLCRLoJoyzP6ql/LGByZ+x+V8o/SRBfYzSGj+MjGXZIM9V3jOcPV9jXSc4bBj4dv76ofVGyBKQhf/Ky4xjb8Cg2JUWz8wI8PmC6+SpaoXe1cmxwYCYwmacjqoIUfDJqB/Bg5SA9KfYc19j/JsaDM7gQA23174Qv9aQpsyZvZGjUOJnp17T6k/3QTtXvCbHbDsMW8nnNrtqlWh4lMEAPCd5MzMAURuQhnzl98AD6IWpscIwFuuBb5W92spsM+aZepFYFw3JNmnNQlItf6RUbmCCL3UcFGy6eWsQr+nb1RqkhHWDcJrf93ncr+sOeI5DIx8yEJ5cWOmMEak228owdINlzB/npbQtLS8KY07z4kfbWWdfTyltDhFGLervHJTTDm/fxcTjGK4DTYAHASNdo6i3e8zeVurJIUrOXxQIycWWEOXOtSeXv32QywEcBGtk+1b8aRIU3pSzofg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199015)(186003)(558084003)(2906002)(6486002)(38100700002)(478600001)(66946007)(8676002)(66476007)(66556008)(41300700001)(6916009)(4326008)(86362001)(6506007)(36916002)(6512007)(26005)(54906003)(316002)(8936002)(5660300002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dDNa7BQFnCta5G241ypXuRkVu5LkySqoeSGtIncLBvbgfV8MfRvu+ODey9QE?=
 =?us-ascii?Q?u8hBhEIcUIVCJgx7rRRIQxvr2CzBLla4aUzj9mYuBvFFp8O4fXMYMIofue9A?=
 =?us-ascii?Q?b5X8MtwwG3P6DWimVA0x5azOyCkxim3iWiLSgVLIzpJ3dyYL+UGVrckLTkdy?=
 =?us-ascii?Q?S+ojN7gZGBGnn3ZfamgUBGdAhaOUQf+0FJKIg9qIdrfjMHRsIrXZtFyYxOql?=
 =?us-ascii?Q?pd0pVvQUDCAIGVDgVKaxMZ2ExEtudARzBa7TMqpqvVjs4BIqdyb4NxQo429K?=
 =?us-ascii?Q?yfYbL7/+1O4KHZPCG6k7ycUpxoOGUgJvq1DiXJhLHFjQCmbPezKIoo/wncAd?=
 =?us-ascii?Q?bB6eai+SNE5A681t+Hdwnd8/2zx686ZAeHVwanC/ZOmMP2DXC5RxRinqQhuI?=
 =?us-ascii?Q?12zqpJ4wv5fQkDOuD4YxWxfea0iMIeaxRTkKF+qy1FEKMxCAucPXc3exNR4a?=
 =?us-ascii?Q?ZKTbEFqzY+LPnRgcLBsZKr2EFMwBAMad8hx3k8OxpDAcVRzEx2seELG8CgL0?=
 =?us-ascii?Q?6W2/P2iyYv+L/n+55QxFe2ua9fFffaaZfUxF4XUV2jcG192404e1TFQVm+VG?=
 =?us-ascii?Q?CSbmzi4Jo4BfRgUzOQp3cDhWYruLW1EhBzGKUZuxnMjeDRW+IZRKmwnlmHiz?=
 =?us-ascii?Q?0E/VzG+W5/ZNGdDqRAWISjXkMM9YeAAklR64s6ybPYC/frTWjZqjhCkkg9AN?=
 =?us-ascii?Q?GXq15Zh2vPSyCabH4qqWKzO94pkGi1YdPWAnkR8aHtVhnsjTfYa7177t9YwA?=
 =?us-ascii?Q?t6w5j0k4y9/in4PsRWhZtrOAW2Vpmyc9ery//8B70pklDAM25jJe4taZb9sZ?=
 =?us-ascii?Q?4GBJWNw1ivn3auN1XE8ZdbmyoOUuJVAcu1A0zy1iXOQWJAkfRt/REtll1mWz?=
 =?us-ascii?Q?/o2s0vXXk++osPsk4UeJ4x6GKZyT/PDaR+RvUOR2DsWjvMEIjMtkG0Oe2GYX?=
 =?us-ascii?Q?9iABtmG0VnAoLcxKevkax4rAd6r53ugY3MEQa5Elp9mB8lXJ93Fu0L4f8RAv?=
 =?us-ascii?Q?ACvufdiOyrQMNg+XBO0RutfZCBp+tiFqTL5F8/pYUukjLQsNEHEzVI4z5ybs?=
 =?us-ascii?Q?Omj6FVPx7PD6U7M9UNHnu+ddCIhEShBluO+Br2Elfj0+56sqBOXUR+ARN3qe?=
 =?us-ascii?Q?OC4Az0BnxSTCEa2Gs4K5Ow3VZtxi2uG5sQw1aCSbqsbg1NG285VddTV83x7A?=
 =?us-ascii?Q?07dQXa9vcVjlXMkugkOdUfZ2MQoGV4TyTSGHEgqm1A/rhkijIqN0vazQ0vuv?=
 =?us-ascii?Q?uGEVg2I6bsYS3LObybsguQQAyThWo2OCaWtX5U21RPGtPLCavrFSGrcwIYya?=
 =?us-ascii?Q?d+moEfLGhsbiOcWFTEcfDJXADnSZtEqCB1EYO9kDqDZO+4PR2PKLb2carllN?=
 =?us-ascii?Q?WTuG8koN3BDSACgmg7k0oR/XD3e/LYs9UyVLwug2UBJw5gQkwrP/+RhnA2sX?=
 =?us-ascii?Q?s+x0HrP2fZd+HAYvm9lmFeKlxwG2wEan827jXM3ZhOSD2KsUgrsd6I1eERjY?=
 =?us-ascii?Q?g6iOtBJbRtj74vhmCRZDttbq1N2rNb+UfeKsg7dejUXBF72aZntNsHmdMagH?=
 =?us-ascii?Q?IchhJuwZg5tSQEdb1fBuigwN04IOD5kN+uopwlZO/pRA2Lg8DZCQUbD1CPa1?=
 =?us-ascii?Q?0w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b99770a-c682-4eb8-1b95-08dab3da97f0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2022 03:07:46.1715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: asuCQKD8uh4RPwwtQn/tMLYZ2/Q1RA2YeUgzyWzZUuxoTIilRsXd6XXFbYv6kVzJeEzmTRstpqvH4NDcnYlJOz4HtZn8QcaZtQRfEqz9PU0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5792
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210220017
X-Proofpoint-GUID: kApZe1AgUg8CFQQVp91lo6yDtYas4wS1
X-Proofpoint-ORIG-GUID: kApZe1AgUg8CFQQVp91lo6yDtYas4wS1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Igor,

> The reset_in_progress flag was never set.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
