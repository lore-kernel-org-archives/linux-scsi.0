Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4D6C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 03:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 773DA6140B
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 03:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhJEDPH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 23:15:07 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:32528 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230462AbhJEDPG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 23:15:06 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19527po9004475;
        Tue, 5 Oct 2021 03:13:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=LZbL7dEdTw3hfMlvST0WwU3qrHht369CbpxMhyOd8ak=;
 b=RZmFlOPkWR0eKaIkDCq9RP2loWUUM1QkugGXNJ+GF17IxAGefssEthEgUtismV9/GW1k
 VHAhiCp0LW6j6XTpey6IDzdJDFKOQvYcWsL70B+aYbGinMVc7MmZUKJFGxna+uTBfuri
 2kdt7JCglPmV1drXpI5OCiuX4Gy4O4HTj1SNvsmG8DwwFbXNgzdgxztCjKtG/kc3nsve
 ivhBrT5KKLAcSBj93WWFPX6LY1tdUKsYezSZtwnoJu3jrjsbcM4qC5jFkPydXRPMaDHI
 DoQysAxOnPPzElOCH0LfW42tySc2EDr0w82yFGjJYBBcem4fY8laiEPN9qHAmp3Pn6PN cA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg43dv087-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 03:13:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19539tMs044630;
        Tue, 5 Oct 2021 03:13:15 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2176.outbound.protection.outlook.com [104.47.73.176])
        by aserp3030.oracle.com with ESMTP id 3bev7sk9yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 03:13:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6vQ3Ynp1lGGmgAiztssO5axtee1iQfG8APe7GBrUHbi5nRzEbqWEKj4HxI+WroZ7L7FslhOcnu59FwsQFczDxgLwpc8sqSM8T3pNg1buPR8jCPI13NoYSExNE5KrP0N50MVWpRxPVzgU4QBwNopHc/lPKFWT1VQi6Gu4aPeMJeytuJmQh/O3n1vyRRIAuf7lSvVxcw9zi2Z8RVyzWsEGEvJCOtVy5WsZ2EDJ6DSt3ULAgokoJ3FapKqGEEV4xD99uLrrBgnP8AGALEpHy3v+Ein5YbOtYwbEdsVrs31UFL6MvZnzen1Rbjodrh9w+9pNTtcTto3ke1M4wQy057I1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LZbL7dEdTw3hfMlvST0WwU3qrHht369CbpxMhyOd8ak=;
 b=es7oxq+agHbANu6vtYGeSA0Y8IzGdO0aGVvuQlumYEm9AVVg/93WPvhNCyBch4Vj5QykWuG6gqNpoi9duZYiQQQTn/qsZXG0yyo3TbvfNL9h+Tv2do7UgWCAfnQR5HqtyOUCtWGewzWTOJhvgVIPIb21bTlpGeLu3aG9EtNBhV8zSg0k4weKIDd4qePGXNafMoH7NVNasrw1X4joifH0Ss/xn9f6gtxRo8vM04gbrQ2+e50fqr64Y2TdDiTOL5oxwMF4T7saCRrcTEpe2saPQ9sbzrzPZVhVoX0aLBJiHNN5l+i3hrtawIQ3G4sqoUCk8QZKNF4QcfjI5R70Kmr0Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZbL7dEdTw3hfMlvST0WwU3qrHht369CbpxMhyOd8ak=;
 b=RN24UBSrI25AkcVh4ObKpNcmSMvdqUL+MJqdI5qk1tpTXCfoXvmWp2WRKIfHp+Y3Vvf58gf+teX53EToxZ6IiCbPLt0+vM6+/UW3ZWx0sbzfQNNFv3PVLsco/J+KDNqhBuYG3XnmC8lTI5wI9VbMUdjg2ryGTw3Dh1NDbczKrEI=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Tue, 5 Oct
 2021 03:13:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 03:13:13 +0000
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH] scsi: target: core: Make logs less verbose
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6jo88qo.fsf@ca-mkp.ca.oracle.com>
References: <20210929114959.705852-1-k.shelekhin@yadro.com>
Date:   Mon, 04 Oct 2021 23:13:11 -0400
In-Reply-To: <20210929114959.705852-1-k.shelekhin@yadro.com> (Konstantin
        Shelekhin's message of "Wed, 29 Sep 2021 14:50:00 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0158.namprd04.prod.outlook.com
 (2603:10b6:806:125::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.0) by SN7PR04CA0158.namprd04.prod.outlook.com (2603:10b6:806:125::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend Transport; Tue, 5 Oct 2021 03:13:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff74bb10-0a2d-43f7-78e6-08d987ae1123
X-MS-TrafficTypeDiagnostic: PH0PR10MB4614:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46143DCDC339CB70838BAF238EAF9@PH0PR10MB4614.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EUIiR2WzXtmdf6dSHml9ozqBhAEWvLBzTgATdwL20yNnwm/K+jIwaDpA/J+RTTN5v/y0KQj0n4FR4tr9mrRZ3RSpxkpYhTJmI2qUKrV+4Cdhl+ZiBY5AyR0Ohd9piE8oGk0XlBNGUUvUvA4itj7pU367Ihh7WZd78I1U/kI/6cq0LtrLr7YncgFbU2cZP7BVb5YZjxPmjCw618NVd0Jivs2eD73PqHj1zZPsmjYHCZi0jVvYKNUYlcylBEdctXXltupC+5PbXfzuGcuD+5XxNPlF4q6/hMEoJHxLQ3ec59F6aFlqZ5GSnIhdc+PIhPoeUnG5d5nC+RDCONE5r+XaNGsYslXc2pLlLEZ8B8fEAdMG8T0soXc8oFQgYR4rRM9gg/ITjiLefsj5+B8lsY3Y/rnOG4v7+WBTBawl1i6R31s/z5Uy2TDYdteF2xnsxGuizw7UhZu/XtSw79rpckbri8Uj565+uI50ky0pK7uXWlYF+hdECiM1lEPAIiYi5bgYv7+ZnBepMpzpGKyxu0mtmjWIPlXxQ1smtAhBthpaOfuiHANI6T3/7xg1yjx+Zwvi9dVayTdpqFkN/uFU+DO2gho+VomPrMdRscnwnZ2k2impf2W9LolJ4F+TjGoGGIBY+xEFXOEZsD1LPEGejfC9vRMFrlBEXYUflBYijEMZprD0Dxdi7fORkDgDxPc+bnzSVx9zUaTMbjGoW0Jm8J5fhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(5660300002)(4326008)(558084003)(508600001)(316002)(54906003)(38100700002)(86362001)(186003)(8676002)(36916002)(26005)(6916009)(66476007)(52116002)(38350700002)(66556008)(7696005)(2906002)(83380400001)(66946007)(956004)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jPkeW6BKQ8dAo8oXpzmFGRl0JDQM8zccrU7RwpLZnegEs2P3JoVCV6bvCc5L?=
 =?us-ascii?Q?9kegFOKsJBetVDiv7NzvC5ic1PdOtzSqroDMLGHZ723zA8n10GEFOwV3hTkN?=
 =?us-ascii?Q?W9glmtlt6STWqWQS98sGzMXYjnrkNGMmkl/lIXU6rwqMnjpNeJPL0wpHgBQ6?=
 =?us-ascii?Q?TGzisewTiZGxNEu0FWJPu2x75DT7Jkij0n5ZXIALeizAqPjOlVkz9Cxzjeib?=
 =?us-ascii?Q?wSYuUPo8xsOWCpXW1fIba5oF0RUKoYdJfenfS05mzX3Lk32ysXcUR7RQAdoT?=
 =?us-ascii?Q?AdBzqq0A2L4Hx+s/JVt8CP5z8uXT5ibGYpGrkJsPUcAb0NjpgLxDA5Lkadp/?=
 =?us-ascii?Q?JwtF+N9WrW49Tbqt8ulKqR5qanq9k25w5GHcEMew1x6Kmy1ngsWVyuLxwBz6?=
 =?us-ascii?Q?7F16ponJ9GltS6uso9JtIQHR27H1xM0qwOGsAPVMMAD0nJcqKy4iVjCQ/ssM?=
 =?us-ascii?Q?4UeqgiSlTlOHXaE0nhLn7cpsM2TWOp2smxOXRTJafwrkG4L3CEMlAoO3rNi4?=
 =?us-ascii?Q?VCHlWTL4k4sZDnU5pzB8oIoZsd468UIMZCigJB8to4kpM+VGRIzGtraCLAC4?=
 =?us-ascii?Q?vS/tVO/eJ3Q+bHmuWRaCGCQTjsWkhw+PbJLNtNLhRi4r4emLN1VrmXq5E55+?=
 =?us-ascii?Q?oUL7uSF5lYq1C6M6ME7O8E2P88QAn30vqBL4dGiZXynzWKj09Df14217krKk?=
 =?us-ascii?Q?F31DqtXHcq1vIBWMPSNMd4kcwqZUaehjD44+O+FZH2zrq6/9skYR/4HoOiMF?=
 =?us-ascii?Q?EL45ey9HcC4lMUNXcN/D191N3/R0i0yYXGcLHbp/uHQ77lIEao5XP1p+Q5Mk?=
 =?us-ascii?Q?7heCuiS+MrNEnueIBH25vRPHYcsoM9r81vdFVqFlG64DfxX+/KoxMB3lN1xL?=
 =?us-ascii?Q?VrtaPW0EHPmikF/JfUvCVpWsODd03iDxkXtcnLTFr1aWb766HrL3wI5jqdCz?=
 =?us-ascii?Q?k9q065Bcr7PRnCjda0Yn3hcfSa8eGIVbTP/3G/8lhGXqWxS0Ocl84K3CLLx7?=
 =?us-ascii?Q?LoHPXfgh7RA2tzHbFYqUB7t3fq+DXF9u7PjQDCmxnveaoWkvSVhQDGk1LgeY?=
 =?us-ascii?Q?hMpo990S+6RICBrC5mcRw6zapKgkUzSGd+ZFBm+RwY3MqwR71QO0vEiiriGR?=
 =?us-ascii?Q?AAYYKVr7YqHYg50HB1HRqFQ7CNbOB/pt5EzI55+wqGZCAOfItSJkh5xSLyAx?=
 =?us-ascii?Q?6hIMdmH4ydkbKajJJR9vkyx8MMXLuSVW6YSpR0rGDkEtlAhHq5i2z8fuK3KM?=
 =?us-ascii?Q?gGdkBvNw+XOPRojv0edt9otYMYWbqAM0IOTWz/g8xm2EFOfVCGR02gGgBGLe?=
 =?us-ascii?Q?3K6gF7kn2GikSeu7bDwLaBZz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff74bb10-0a2d-43f7-78e6-08d987ae1123
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 03:13:13.2616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cFLmz/Vui2Dg5XU1cFsbJ80pgfeH/5TUGH3Y9cHAeya7PNZqfzpHAmpP2MfmtoBhgERKOIS1mGdoTNEsO6f/C0QxSZWGGJNxcq5yvCW3OZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=910 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050016
X-Proofpoint-GUID: bEtJvzn9_2ny02BvVyJH-F3uDVJaz2v8
X-Proofpoint-ORIG-GUID: bEtJvzn9_2ny02BvVyJH-F3uDVJaz2v8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Konstantin,

> Change the log level of the following message to debug:
>
> 	Unsupported SCSI Opcode 0xXX, sending CHECK_CONDITION.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
