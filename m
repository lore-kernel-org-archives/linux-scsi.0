Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F1EC433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 03:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C07B64E5B
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 03:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhBWDpE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:45:04 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56832 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbhBWDpC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2021 22:45:02 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N3hgDk181423;
        Tue, 23 Feb 2021 03:44:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=7bSSizhrJsjGxU27lYE2qelPDgbIOhUxaGFkTv1SzrY=;
 b=kZW5Wj7JhWT7zIEB0E8K4Y737HctEpTPpP/YAjMBHa7ZfsTAj8Vh7nT17H/ChrqXU0Zg
 Wl4MtGodKPhhQW58khoFvJ1n+cOu4sD1PNTpz1movgtkLl0MVrGkTsd7qkRUwNf/ecir
 qPKSTaBX/seBoPn7Qcq1vNRTe+TbYi+1UmVO0Xck9EVD3KISmXD7gLr4qZI9XtrXOnPw
 PRVcSQu5OeqVwlWIuwJtH8N4/kNzTy0mDy6+EUnz5aWnwbX1/WDx1wLTEn7B8f1os6Xb
 EnHNBZMf6Wt4mm7S9d7tRplUCy5NP999AffMMVqNjAAfHPxrfByI71DuoxU5Je+KVegY Jg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36tsuqwt76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 03:44:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N3QJaS107082;
        Tue, 23 Feb 2021 03:44:05 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by userp3020.oracle.com with ESMTP id 36uc6r5uc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 03:44:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PcSHtRJaUMCfnFu3r6IoP2UiaAisfCi+37aUlfYCqnPZd4LEDfEZ+UnFPpmVFfgGQu6C/e7/I9dayXPbPutAnIy/PYjsMwGiZ69ntVcQEl0iNh0D3EpGlQeUo4bO2tfTjt2nJYKTekCuz/fgobyC6XZT3zU+QVvbkMboLYs8Z08NhK5AmzCUE+I6NqKHNKRxmQXbXQnx0biL70GUg5zbPV/OYMQl3nVYpNTuw/2OczfLGaPiRMcbqYne6bjNMk5MMf5KvVXUmo3i+BoQrKWUkjewnB8Z7eR7IaCndcwdMYnPCZf76vzH19/Fvo8qSHRAk7yAzknQORwxToyCEmw04A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bSSizhrJsjGxU27lYE2qelPDgbIOhUxaGFkTv1SzrY=;
 b=ChpsHnME/rZNy30faDao/V4NArLSuU/YNZAJ0TIufSX13MdqI3hBaCje0GhDRSJtgkT2U7rYdZpDi7OClbxK0TNPxooLoPCL7RCdAQV6slFrG5N8cvaO/T1zk1BNd2bhMQV0HKv6+UbmyxvFiJWL6LS55h9lyDklhGLXKYXBQyhy+vR6IRD0nhCCE+UhIhOeTPbfezy0yqT7jaAxw7tmldwnKNRo/r1maYH21N8rQY7KEolNxQEUOocZiU2/dqg0zW2svBzkntQqcDgZgvTAPoVtp9nm0QwpssGdcovFbN55KSCj5WgA/eFpwAQNg2DYBdzH+NsGHuw9/VcLQmiUvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bSSizhrJsjGxU27lYE2qelPDgbIOhUxaGFkTv1SzrY=;
 b=ONSZTw/DNVq+1hRthXpvRlasSY5bHaDeIM6rm0uQP38mHVCZFIR0UJsQWw+DTBKzvAwgAv+vXvBfv+Vz4IsRSBnlsFCh6iHDlNnpLXkRXyjSy+z5TxQQUJKxQz1vrXAFXdCu1WOEn/BAd/2so17Br5/NUVOpnR8ZTtwkJq7+QgU=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4454.namprd10.prod.outlook.com (2603:10b6:510:3a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Tue, 23 Feb
 2021 03:44:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 03:44:03 +0000
To:     Don Brace <don.brace@microchip.com>
Cc:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] hpsa: correct dev cmds outstanding for retried cmds
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18s7ffnyg.fsf@ca-mkp.ca.oracle.com>
References: <161342801747.29388.13045495968308188518.stgit@brunhilda>
Date:   Mon, 22 Feb 2021 22:44:00 -0500
In-Reply-To: <161342801747.29388.13045495968308188518.stgit@brunhilda> (Don
        Brace's message of "Mon, 15 Feb 2021 16:26:57 -0600")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN2PR01CA0076.prod.exchangelabs.com (2603:10b6:800::44) To
 PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN2PR01CA0076.prod.exchangelabs.com (2603:10b6:800::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.30 via Frontend Transport; Tue, 23 Feb 2021 03:44:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 052b1fc9-19c4-4659-ceb8-08d8d7ad4358
X-MS-TrafficTypeDiagnostic: PH0PR10MB4454:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44543F04956A9D2712CF748A8E809@PH0PR10MB4454.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ytNxL2S4qMH9WacqhSoOLVfXPQIyqpCzX1C26kWbswJkZ5q2P/dQmdg5r2A/2hb93o34o7gaquodwU2vUQ4T1gsqiMpeeunsmiWNTRsIZHqd2Vx6DWh0MYFfD1rbm7ZFlhoinRGklxOlpePHxJs91IA8LZX6sysNMrAygXHaPkdNI9YfW/ppuJjosGD12Eo+zLjTnoVn0WCI+n1eoiPATfPV6cIN9l4dreomcddFvhDpeWukG8uek+7/LlRkSxIu+kqicrbQtHsEkPv+mTxckczlW2yBIjLpLt/YfYehyx621NiNBWx+IcIrzKy0fel+BAXX2BNKvZveKFGos3ESTyQegIHVTsGcBXGYRZ3A6CJCWsj8fBuhyQkc2oI19V0u1g8F5IsDyzwEXW79JI7M3bdVFXyumazf9Ct+MzNTvEM0/Vzol4j93I4bkICv99yeMR0u1ozAMU40gjXygpXdMoQG7OybyGYboJWEB/SgCNrPptkWx9D5PeSWlOizW4+q2MmhyIOMG8jAfJG7mF77+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(366004)(396003)(376002)(86362001)(956004)(8936002)(7696005)(52116002)(316002)(36916002)(8676002)(6916009)(4326008)(66556008)(2906002)(186003)(7416002)(66476007)(54906003)(66946007)(478600001)(558084003)(5660300002)(16526019)(26005)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oE/XVAQvKWyZgecF8y/nfRo6vuFn0PDY2LuawIKhroSVDiylqLwwisl1x6of?=
 =?us-ascii?Q?9IlhhKKObT8O34gf601SYAQzkBHqW5tsDXpa4SCCLpo5rhXU7TOCyZX9wVd8?=
 =?us-ascii?Q?JpkkjndjafrCd65HrR14PprnPn4P9gC0tW10nA2AdVdNNxEsHBbIeleZD2Za?=
 =?us-ascii?Q?l1Ja7SbhERcXGsyeZx9AK9YoQAuXU6emFIU6H46KBxQO8jTV7ettV1+o2rrK?=
 =?us-ascii?Q?oE1TMiCe+D8cPH4+UiM4tD/CXy7K/ZKbPWwL3HGseHzlomR+Cw9YiCtSwRNT?=
 =?us-ascii?Q?mnkit4AlJNnKVubX0RsBr/aRiJdOkIdxFalXg2+BdyUQq/xn9bX+9eV2pXEF?=
 =?us-ascii?Q?7krJSWS367uANdZHoYUnccVjbvUjieSuFSDOhuv2A57FnfxdFAlYRX8/1adm?=
 =?us-ascii?Q?VYi8vLgthP0kaQHYob7JcShO3U+PPLjz8HFKaC4BSbkMRYnvAmoMgKDuQuCc?=
 =?us-ascii?Q?GZjroVJqVaU9yOnY8d103KmEH4TUWR0i3la7LW6pJjoC8lSUuU00mtMu4kIx?=
 =?us-ascii?Q?YTy20Gl0m0nTcROChKJ/XJcH2m5bu3NYK9YccJruOrQZC9GAv5AWO3u7sfCL?=
 =?us-ascii?Q?U199fRRkvM0L2OoaZZQniYMnSZEDAo7/xpsLtPb1hIMYrYlhHMZrs+PUB8CA?=
 =?us-ascii?Q?l1Jxd9OqlFfrk43Ccy9scfQNqnsdw73UZm9rjspWzNh27T90GtupWo2sLiup?=
 =?us-ascii?Q?8V/bfJ7Qpq6rvw4qC9fMws48XoIR62qbJcDSlMSMbbBwmCDndLluip8aYTMb?=
 =?us-ascii?Q?vGUQaqbYtUvuOcQRs4dxh8nd6GEbQASRFfumk/YV6jmmsXgdsxEhWjfeWkyY?=
 =?us-ascii?Q?8mqUAnyCIc37gEoetDZk6QhPjD/7Purl6XQY62+8sYUpalZ12V4YsBJyXPnb?=
 =?us-ascii?Q?0wZmsfipiKS1PDVbAk8vfmxYYq8PMbCSPbaaYyau4bJeyE4RMy5ynsC1Vw5+?=
 =?us-ascii?Q?JGG/a5W+XSzUtt+WkX+np9dXVScejDDk97UlmO8NjC9APEe2XTe/MDWy1JVP?=
 =?us-ascii?Q?Woxv5hYA32L1Nlzz4t8ukSATpfmm7vowWlmrncFDh7wZ91ag41PuFSmSEvor?=
 =?us-ascii?Q?ywjlOxsco9u8nGZhZyh6vY0PFOjq8+DxqtIrzbIdsT/WbVrkRS9t/26jQsE1?=
 =?us-ascii?Q?JgLhz96nP6XwQvRkI/uyiBTiGwjtOBHq61y0gDlNz420k4TANa8x5nOQtATd?=
 =?us-ascii?Q?8SqkHW33r/qWU6INXkPoKCwvm5PYxb9TmDgNnI9oARWPW1uVu8pDzIPkpYkx?=
 =?us-ascii?Q?SMQ89ESlUjkAJ4WFcY+AFd7JqyjwJ53aC8P6cSFqMCl5TzbEJJQtvNtXThzG?=
 =?us-ascii?Q?u4ULY+z7aZRKsDStwl8xzNuK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 052b1fc9-19c4-4659-ceb8-08d8d7ad4358
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 03:44:03.3367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eer6GUNzsc5PwlppPFwzr7/fs/faFzBbgQCy+8LEfv3OZvAlgbgA3uQIDBwajkVnv2X0IpRCt9LMfB22YZ4gRuR8Dv3TDEXeLFdISeINbxw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4454
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230027
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1011 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230028
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Don,

> Prevent incrementing device->commands_outstanding for ioaccel command
> retries that are driver initiated.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
