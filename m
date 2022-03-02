Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF857C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 04:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbiCBEY5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 23:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbiCBEY4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 23:24:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADA85EBFC
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 20:24:14 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222mYKs014686;
        Wed, 2 Mar 2022 04:24:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ZEFBbCxNG49P+yVZw6Ppj3XeNEQ8dew7gxWWgZfxIpg=;
 b=qRQ25saLNstUgYQ97MVFoGCow/0W2ge9H8gEGzS+4LwRCgEo5zYRcxH4Mfc33J2L+I8x
 9+AKua0NCjEPPp2Ftzig60IsiZyEIwaWouzvgxL+W/o6i5iPaLqDeKvb7efyOAWQuBRg
 uBZkRb+CEnuzC4XeQunOl10+ZPVHa5BGKSE6SZMAIbTNcQGiF8DQyp+A2xTobZ/RRml8
 RTuyS2hOYNGB5NhRpSPPf6CVcV2g/wJBGYwPzI6idf+IRoHVSjPxCj9w+o/keufeyDcX
 iXLGEwyqHZehyVytPCm/y+7j0AMsqzYfK3ZvWu7e/cuMVm3b6q8pFHREd4nN//pAihHC Vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15amm6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 04:24:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2224FRZZ039418;
        Wed, 2 Mar 2022 04:24:07 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by aserp3030.oracle.com with ESMTP id 3efa8f8gg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 04:24:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SPF0jMNLwSf1vJ03hnUPFb45KaILX5jnF9y0W2gGjmFFnR7n5EnwZInltD1mmqJw9EraRuGCUnk4AInmwRqSRNtL9HnWLrABznx0F1mm+yeITpGhhNKiZhiMLUz2GxodUJzuBoAAqbB2SOnI0ltNG0rXebtFVY4AljmEjj/HPjtPGXbZmeJvOrpWQz4Z97cLLnEIk/b5m+MDSbW8UfCfyUnV/IaxKa2VFge2Zb4KPnKV20AiGFrG7St45eRcGiFz76UMRbfqNO8UMysKKoz3cGcQg3k4tpwaU/4QskcJAfEtP8WxdyD6VrktrU1ANtVTq7KV+Mu8lq2XS87x9yyM6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZEFBbCxNG49P+yVZw6Ppj3XeNEQ8dew7gxWWgZfxIpg=;
 b=QmEmVc+l+S5ilFOHrQ6iBWhNjZtEDlVNFqCklIB0l4xShPNMKjuKUmRJLcIaO6BXq7l3c6BcGAADS5QgCRmR920y0D94C1iGoqCS7tfOrGnVe7vPaRjbioixziIbjDhycsnOYPHtByRgeSWXPumlsx9yZOL6PhD0Df25FbKfHIpriSRml5qGZgShN4r74Z8f6oXir1pk9ip9wok62ZqUzhBFJA78cpkw5hP/BF0h1x51A5OnbUzh+cVfi+dpRVIvYXOZVJNhekKaEOrVtVkG+oEJtgNjA/agl2htqwlIu/RcuLr6UGlimVGlbowsREtraXKBy83sjL2kKDvJKUF9vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZEFBbCxNG49P+yVZw6Ppj3XeNEQ8dew7gxWWgZfxIpg=;
 b=dnJp/eN6ejJDgM3rs4xJzxbKLGuvmjKBlcnC0ohYOTGRzYnt/iQxSzGnB5yBVRo5dOid0bX2XB8rb5xe4ukemFtik3W4/LW5Y7ljlSDAqPmGzrhXegS5FOV/bLU9ia12EO/ILOyv+qM9o4HtYMpghMX0hpoBN8neBUf0kSVePq0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH2PR10MB4295.namprd10.prod.outlook.com (2603:10b6:610:a6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 04:24:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0%8]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 04:24:04 +0000
To:     John Pittman <jpittman@redhat.com>
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        suganath-prabu.subramani@broadcom.com,
        sreekanth.reddy@broadcom.com, linux-scsi@vger.kernel.org,
        MPT-FusionLinux.pdl@broadcom.com, loberman@redhat.com,
        djeffery@redhat.com
Subject: Re: [PATCH] scsi: mpt3sas: decrease potential frequency of
 scsi_dma_map errors
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y21tyocp.fsf@ca-mkp.ca.oracle.com>
References: <20220222150319.28397-1-jpittman@redhat.com>
        <CAFdVvOzsSECZsjtniH5LCoBT-h01KHfGwose9awH1PN=-7yp0w@mail.gmail.com>
Date:   Tue, 01 Mar 2022 23:24:02 -0500
In-Reply-To: <CAFdVvOzsSECZsjtniH5LCoBT-h01KHfGwose9awH1PN=-7yp0w@mail.gmail.com>
        (Sathya Prakash Veerichetty's message of "Mon, 28 Feb 2022 11:24:04
        -0700")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:806:20::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c8fbd0b-fa2b-42bb-d325-08d9fc047c34
X-MS-TrafficTypeDiagnostic: CH2PR10MB4295:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB4295E26FDDB67CFD1A63E10C8E039@CH2PR10MB4295.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PLBVFY56xGrCgXPYAk77KmUQUADUtd7Ttz8dG61AgRXK14cjKXOWKvTumGRu7AnXfRx/xJXp+Nb3gWasHPXHI60abK5mN67g4DyRooz3vNpJ+eUyKuYA/rjK3bAT7e8uAhTc801ky51jHgXmbkJrqj6FDx1/+7wGowZ7JF4Fi/uOtaYbYgPJ89okh0ejtSkVoNkAoMitnRWDHR1if1rmv12rD5pTSw7OurADxyLS7nlSJ0r3QlKIVtDfxWAlRfU7jTEW3HcLh/1Ov8KTawRvlJ17mH1w1gJkUvOYRUGjKyVOpyBlMp14PrHLgXkib0z6r9fjk0Es4/jYwNKKvGPzcQYLlm6dIiDuJf/nncNxHqhhC0YH6sIqzOtkDtxc/n7SP2z0p0n2zp7qVepcw5UAuYonteTgX0jqx9TK3HWIvsI/k1Vs/pFkZPvVaYyn/r/dj2Dy37P9vD19UZb7v17ng51UWBS177V2dT7AS5CKLkQHVV1h2bM+Uf7zfEPyXgoq0bTlOifT+sGKpRdPlN4S7byObQSoP2xPIpI8nOXLHxvQOypXhWjVchzJJ8H1yAoIVQ90cuiEdMhUbXfy9faJX6YiYqLbsGTS7W7jVKqFmAxO6icEPKN9qz95meEElvNae2De2CXPsG8Ufk2x8RJeop+35YI8hfej5Iuzdr0E/byOdCtSJ1B89C5bNYsk/BiR5vxlUA7OjwkehUa1YiaeHspDQ6gtvEcdDZpbeAI0eRc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(558084003)(6486002)(8936002)(38350700002)(86362001)(38100700002)(5660300002)(4326008)(316002)(6916009)(8676002)(83380400001)(26005)(186003)(2906002)(66556008)(66946007)(66476007)(6512007)(52116002)(36916002)(6506007)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b7rKpEFvr71yJ/z3jUtWYCwJdcjeBQjxIfz8jHbv0y+h0C4wM1/NWIHzXvUY?=
 =?us-ascii?Q?wWu4qSuM8X4+KcEPiDGSjgnfWkousfruGf2a5ADSzHvYnXvfTg4xrRaHcc2y?=
 =?us-ascii?Q?yvd9J3LWhLz/XhmB3yW7I0cBrLqgPHbq6WDVApHXX4Uhvo2waX8ekGG0R/7c?=
 =?us-ascii?Q?6HXNdyCOiNbAewpHbbwcPnKZLtqLMdkSSbYnYL9x+yZvJ4CHAo6WE+dEA73e?=
 =?us-ascii?Q?gcRYvScb+TgM5J8ggC+F/DYwjBReDYQjvOTSvAvP/xDw1LbnXw9eTx9BqgB6?=
 =?us-ascii?Q?LHNRkZZ5EGrP40KtEaf2JS+4hrdHfOBfFeVAQTivvncyZmRfGmn7maudy/Oh?=
 =?us-ascii?Q?rWRUUOPf0m5p5Q9LAgGb8m1TyUaNlUFIxYBUz1GUKxlFRJ5jbt6jD9W5zPUL?=
 =?us-ascii?Q?yn1nXmGMFAN/kdwULA7iUCHaTHhtWtS/nfrd8ds1Pjje3ujD8KX714vI9yCY?=
 =?us-ascii?Q?u3RRYWcg2F3B8Am7rkF6+QIl4p5AhEfGrtlXbaYBTaCfkqVX8xgloNY2yOlF?=
 =?us-ascii?Q?rrvkZmJXY2nyKz0e1/I1kLWFiyxlCp4/OmRpqYZW/+tUAzzuO4lot0OMLreX?=
 =?us-ascii?Q?OrNJfeHWjbD3CmTztY4MQn16869uCOp5H9xQZK/sbX7gAYLctLTSiVa4qhPF?=
 =?us-ascii?Q?EQmbTmd8DL4blGQfDTlHzWwRPyPTWSqZ3POztuopVvjF8ZTChPeSk7/3xYnr?=
 =?us-ascii?Q?vxFgVkASaTJP0zVsA3aG0m7kuhvm2W+TtvCfA0pwI3mPEWkby8iABeYgwceH?=
 =?us-ascii?Q?OPkF0YIKZ4wE7ZaOvFxdmo+rzHK/WrlaF9tedZ8+rv558AnaTvBDQ5HqoOUJ?=
 =?us-ascii?Q?F+XOZgT30UJT8ZluZIj5ZHPMpqfvRQWRDG1G2NaxkWFbrDh6bSUz8f1iPTaZ?=
 =?us-ascii?Q?QAQm5KqCBTz3cv4MbVe8kCnwXvtdVNJahGwuEy1/WQWc4o+IDUrfxh7/hkt2?=
 =?us-ascii?Q?aMQxzA4YWa0k+1un+SEbsF4tsWyMliqVSVnURqTkBgSzcUGKq9qluBtgPFIv?=
 =?us-ascii?Q?hWYOQLP2iw4+3d0kW0jq90wV+GX3eus/VaNlci7Hg5gSPs0BIwqVqYOsWkic?=
 =?us-ascii?Q?sWsy2+HG0elYiNchnmFez1PBYjBL96m2jUmRVsHz+zvHY1eIXWKQTDZMasvH?=
 =?us-ascii?Q?qD8zCR7pxh9iQN8sMq7Uwz+LI7UAaRuyyuNsiPI8oB2czR/C7tTOtK2XpUp4?=
 =?us-ascii?Q?nHkW9EE3kRiNYc88MqhWpizPfLZ/W1waj6M2VoW/z/0pI3KRp79vrsLHogGm?=
 =?us-ascii?Q?EPug9UdpF9JUNVfkT0jYHTvvgAo9xuU9wy03kt/bPyQTvhUkHdNPE5V/7x+w?=
 =?us-ascii?Q?7TOLo3QGm9YhK1CSP2Lg/fiPXRsxglW2TlGhni3yjbyrzcR3c1nQMBb3UYET?=
 =?us-ascii?Q?eAu3VcZjuxcF+avLIpv6mzOozpu31nSfOoRyVAHwGcm7zx6bxvWYIswQEaUM?=
 =?us-ascii?Q?ArRLX1VvgeAr7KPD4EP1QpfbFlpCy7Y8rIcMS5dUJygqt+3D65gdBEhWcoK1?=
 =?us-ascii?Q?6WPJkgy90usvzJoGHDjpZF1cyJmH88sPqzpLSxr6ks3gq7tSjAJCmXfoTeLC?=
 =?us-ascii?Q?ZycZ0fw0PENGwMryLMwQFoBTKeT06e55Qds92oPn+ZtOWJYM4k8YfOgnOpDf?=
 =?us-ascii?Q?ZI9OBIhnk1qbN7KN9dV8SuqWsEm8hn2RUdTDYWO3SMv3FqYjG6I7m7gWRr+L?=
 =?us-ascii?Q?gQAqPA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c8fbd0b-fa2b-42bb-d325-08d9fc047c34
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 04:24:04.4478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8izBwkqhzNewhwHnfgGpjZ0KHw1F/TynQ+uT3AKxgjr5XlVogz48kqKScySvJ6C2M71C9yZV0yTG16y+ikI9Bnn/vutY7psQGYUOpK6RjZo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4295
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10273 signatures=685966
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=760
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203020018
X-Proofpoint-ORIG-GUID: TKLVgyXj_0e3l3vvD5d3YY_0jUJkRY2k
X-Proofpoint-GUID: TKLVgyXj_0e3l3vvD5d3YY_0jUJkRY2k
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> ACK by BRCM.

Please resubmit with message removed as requested by Christoph.

-- 
Martin K. Petersen	Oracle Linux Engineering
