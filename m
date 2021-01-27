Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D34C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 06:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81B8820731
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 06:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbhA0Gbo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 01:31:44 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56922 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233837AbhA0DMo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 22:12:44 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R39beq104138;
        Wed, 27 Jan 2021 03:11:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=24SKVujtOkTe6q++EUxlTCJsqNuWE5sNALMo9a5kG4U=;
 b=wG2ooHYjqXDdYYv61TbwCGn1dRt7hVZnlEShp7BwaQEwKv4IbDNAFjhpKQU1wV906SbF
 8OnEY4frT29A9gTFgJ6xoajRhTPqnpnIEvq5Fe/5zfHicDI5YbXRzihsbmVme8idVaUO
 YEnXay5FLd/sH2deXHnBBiaZFpAeg2+0I69WJ8SnGWuGeSioL+2bupBDFNZf98MXaKrW
 NUcUf0ut/QRvr7Xbwukc8d7hLpHaj5lmvBxIzArgFvgXelupRWxciP1oj+wmG9btr376
 07RduCH2I/ebDjjRtL9Owzhz01BgYEf3bohQskVujboH+PtmW+fmhn+MOU5dov9TZ7KC kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 3689aan5ue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 03:11:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R34W0Q021739;
        Wed, 27 Jan 2021 03:11:49 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by aserp3020.oracle.com with ESMTP id 368wpyqcnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 03:11:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ot/nbHCQRSCKFkKHCG1NNuHLVRtXIKKQo6yW2CFV8icPn6q1uw5SOlDfT6tQi0gi0iVcv0kJkE46W9l/oOxdLLed5rgHmHoFnIVkLSBwCR0peDCihVkGxIqXIJ4KmV9pKgC/uiY5w2bDpVJBNGO2NgR9HAq7fM0v++r3rSmPa3pnUgvmMdTDX1IVEv8Vg8hGzdcifaC4/r0Cqji1mXynAeYfJaQuAkSCxW/GLWB7eFpkFXeOWXqri99Mbf/l2BZKc8FDQ7CA3Ea+JG4KGjl2KMy02EB4jVx2eVTZ46LclBaoqnZQCAB0jQnKu228S1ugDs0QIsaXCG9w42Drmi3Ndw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=24SKVujtOkTe6q++EUxlTCJsqNuWE5sNALMo9a5kG4U=;
 b=ACyWlWfDZZkQTzKKkAcQj+ggir8sJ7pIIUGKcifXoQ9leK3Q7RKA7GdK5WMlgbYc1d4m4NxDKS1Zrffz1CEWBJkxoZraAOA15k9kbjBvgkm6eFz9bbF4cxVAWZj8XnbNXtR/FQbkB6je0Qx2B9WZQdRfUVgEFl0NeoZDfhu+c6LuH9t1AEeCazJM+OdMZ+WbD16cB2vtmalNmbc04nDY6DfwBLOrsXulhsYEfVQZD8RXsUg8ze01LPrTV54FIXeg6sN2YR6mJ0yhPsyssk0zmSz0ub7szAQknFQemKVf2nEpL40iHdabNRtSBZ1zh29g/BsZ3NTpQqZnvde5tiPH5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=24SKVujtOkTe6q++EUxlTCJsqNuWE5sNALMo9a5kG4U=;
 b=hgPWzHX/lc9Ke/4U2sb411A2t+0oLJegxjgjgtnh/LdeJRE8bgnoSKbf24L8TavsL9bPD8b8Gtmi//NKETebR/Uv+XzISOjriaRhSC70O3SRkvOMPDaDFpVi1jNT5Svh2DEvd7hb8xoyl+BbgTgoKG4Ui5s+o/mXzty8yQ9wrhM=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4423.namprd10.prod.outlook.com (2603:10b6:510:40::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Wed, 27 Jan
 2021 03:11:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 03:11:47 +0000
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] ncr53c8xx: Fixup typos
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15z3jxee2.fsf@ca-mkp.ca.oracle.com>
References: <20210125085415.70574-1-hare@suse.de>
Date:   Tue, 26 Jan 2021 22:11:44 -0500
In-Reply-To: <20210125085415.70574-1-hare@suse.de> (Hannes Reinecke's message
        of "Mon, 25 Jan 2021 09:54:15 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CY4PR14CA0025.namprd14.prod.outlook.com
 (2603:10b6:903:101::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CY4PR14CA0025.namprd14.prod.outlook.com (2603:10b6:903:101::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15 via Frontend Transport; Wed, 27 Jan 2021 03:11:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67ec68cd-f7c2-4a5b-510a-08d8c2714816
X-MS-TrafficTypeDiagnostic: PH0PR10MB4423:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4423E1EF3997D86ACDEACEFF8EBB9@PH0PR10MB4423.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v8dlRd5AhDqMzeu8XLDEp4gJkVl4G0tOP0V3vQ5XQr9/DQLi1S1z8BWXd+BMgfVDwpNXlki3/Eb0Q8aoSrYTd5Vd+9eLSVW9pu2iyQmgvymK7X/hIcuspKQYD2hIS7wjYsQG9EOqAz5bhH3AmPrtIu0hWrmXjedXT99z12CFduFvYwV7g87WNNT4L3u2sopFYk0pYYumOQoRsVZy3ssVUF5LM+Fueti58QC7m/9L5sn507ZpoQ5m9CW1tR7GoyyME//thheQN6KNPT0IhIC3hoWhnBxazfQiSKuerCCropWvoeJkI4qP4HrhBpWlq4JqhEiLODkRiBXQ4Lo5w6XCxoImFBqBMz197qbeBq9QUQ8b6iTFC7kJ92/3Uocyl5kEN2MgiNQxqiWmEVNc6EnLwEUxbIeIy17FbCZ4/WrJPepNh5BC0a74iatFhaLWVA6h8UvpJImzvq1sVpzfTHBXMUdwiUJX//zEAPzpJCQqnExGr6N2DVdo1HCurPnbZFjaW2OoZL+K8c/Sau3pLARzNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(366004)(346002)(136003)(396003)(52116002)(558084003)(5660300002)(2906002)(7696005)(8936002)(36916002)(478600001)(66946007)(16526019)(6916009)(956004)(4326008)(66476007)(66556008)(26005)(54906003)(8676002)(186003)(86362001)(55016002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XyieX+eq8otSSLNNcXqt2gssb081MwRBDB3CD0UcsftzGnDWgrBCDt6GgALE?=
 =?us-ascii?Q?jft1uzKxdgLuzbRxfoVqv49Mi6G2CO35w8665x+/FvGT3LCWRdVi8Y7yQ8NK?=
 =?us-ascii?Q?NVFFOpLrvZD3DiWTEQyXc6p1HVbPYnbKE+gVuLNbJAWLp3c9RCapK1kz3wGd?=
 =?us-ascii?Q?8++p6kG3WRoP32NPtYm12setxMo5I83HWXHfVnYXSOw9u1D26p0DqcaOhzni?=
 =?us-ascii?Q?48T09oYjZfaYaJPGQYUGL9w8OGo931CFa6vMH3UpRXY37H8CHApPJmsxyAoc?=
 =?us-ascii?Q?s3EBW4oeLTwZ7FGgt5fVZk0CskrSr9si9hhiQNXOaspaKMdW/IPXoeubKm2o?=
 =?us-ascii?Q?YXf1Xvtwdm7HsVQj7BQNINOCe2syBPy7MOBd5qkN9CCXEBFE4E/bHjq0Y8RD?=
 =?us-ascii?Q?UrGa4F7yDpF8ag6YBNVqDFlQ12Dd0TjWLA2g9d0z1a3MYiyHE30SlW7/mckh?=
 =?us-ascii?Q?CuF5vTnI6y7xpR+zvb5bFsnTukemTC6juVXTS0iNf5yArVwDB2OROvm/pt98?=
 =?us-ascii?Q?Cl97nkCA1CDwFMyaehiy4+qo7RrwLg4BqNGa9xd0J8lW7GrghPGlNi/4xADJ?=
 =?us-ascii?Q?pb/jyQWD7TqENnMOaJEehXUyq9s1nSxF8utE/QTNXhF734k6XOotOqo6fVP9?=
 =?us-ascii?Q?Ebi4ileO2lTYZ9GaUu+K7oWFlJszD2xiISnvKMRIZmMEeeeTpDx+JKNUAJhi?=
 =?us-ascii?Q?91txZNgobWcVOdqLeZS7JCnB4y2r7XYD/uHUD0j7j85mKbRM3lgA7FxBya/N?=
 =?us-ascii?Q?9H6CdDGuQurULG/DPYWp/WuajrStuAYqstQtjOBsnubm6IeRsay4sbT1WqMb?=
 =?us-ascii?Q?DWAPUDXDIrxCC2QdInqO9dNUIvAnz2H+B3UZoLY0q2mlv60he/knU5SUfZo+?=
 =?us-ascii?Q?XMrHF/E7tjjT/pvCtQRF0tbbUhjoCDCF7pCpK+E2E3D6kr/LftQ9qLFzp4Jo?=
 =?us-ascii?Q?+/7RFMkOb2PDNPx07G6nowEhlyd7W9EEegosWu05YCFZ62HPU1WTcxTZoXSS?=
 =?us-ascii?Q?KBNOwG8jNLo7dEXqyQ6qFwiikkywQqHbIUhasohkQJl8TDaCy3JWc0ZtAkQ5?=
 =?us-ascii?Q?Kjpl/9vh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67ec68cd-f7c2-4a5b-510a-08d8c2714816
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 03:11:47.0505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ejc9ZUsGOEWuqJk8vxdG5w1pV6ehYl9dMUY9zjsUYZA2WLrAmnH29FI9zhfvspyAreGqrFKSswAK3uxzAeMY4b9mmwYtEh522LjyfVmQPGs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4423
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270017
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> The patch to switch using SAM status values had some typos; fix them
> up.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
