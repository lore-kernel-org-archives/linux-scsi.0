Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32959C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB97F2070A
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbhA0Fh1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 00:37:27 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52334 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239282AbhA0Ejk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 23:39:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4TqxZ081715;
        Wed, 27 Jan 2021 04:38:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ygceJPRqasReVCfWi4jJ9iiYtsWartIb1DdHJk3Jol8=;
 b=vkU+T7EwKy7cWiGFx661wedamMeUrNVC0Zi8szTuLmkwCwUYcEGWjoxBOmeC/8yC8aK7
 dpkVKZ3xo+FOvjB9MSA14B3iiaYDo5x3mohNA47vQ1aalbHt8K1jrQrx1KEBkk4imNSe
 UNAoy1UTWXfJ9//x6kPoCtDC1OyaDJ6jtrHTeXnrId36SB92yFvnr0AiUqYPMPyZk6n5
 Tlkc9nqnAkmAW5BpfyqjvwI+/sjD+S9V1ytbGcrmnSZJKA400NlJTDsdJYDFX3sOH3Yg
 oKjdtDdGDx1xw9/6+CwjT4RLnvNfV7nuZU2eT0b17v8vcts3jg+3xrb7Dv/yOQFHLIDL KQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 368b7qw5sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:38:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4a712053096;
        Wed, 27 Jan 2021 04:36:56 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by userp3030.oracle.com with ESMTP id 368wqxaudm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:36:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Buf1b6PWXBJ8BXuuwIJLPj9Sx5ljuvv5h1x6OJeLNuGsT24EmYWVgGuqFh2Va0hADt7z2oOOzvl02ldB5LmqHesWtxWvvDTgUIdYhYDZHorXV2bcf3mvFXA2vSXyKg24/4Cy3E1VAnvPfcQALOd2ArT82M5EPh3RfIkSIgFouh67gU3eCQphxidx/B4lcYSJmfn740k9bk+f1aES1KGzLtPEfmVcQWfYd57gHkhJsuz7dPbVlvyKmZYgBNmwXUqWiYJKvcoT2f8AH4VXacVDJlTKrr6FaUtxd5v0452lCRXgryFIC9R/4wBdYxQ5mTj7diJXnyTrHpILwyxEoEdOKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygceJPRqasReVCfWi4jJ9iiYtsWartIb1DdHJk3Jol8=;
 b=Jdwup0nqU///qkGZ+cGJRHq/raUBFybvWorL3ekOava4XCpxQ2Lgx/D/ntc5ZAM+WacTQdRZMa55pTIPzPQEhHbI/HX0uDDAK76Lkq3vimea7aUlT9MbTouwdLsdSDH+kFx2ypkmeqao9JLJYLDDbuIKzTvzZvbBum1ru/lyp/hvQQ7m/Hhu6iV1I2jOUMrf0mI+29A+Zgr/VSDCxzOtbGtcj7vuzEJ4Avf8tPWPp3mkF6I5mdqoxDJY9YQR841w08ThgcB3lz6nwWowcIlOddzTq2PfeW3k0fW9yKYeHDkXZbOHN4S/GLoxyABqRKLFdULJX5bwCj5zcu5/c4VHjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygceJPRqasReVCfWi4jJ9iiYtsWartIb1DdHJk3Jol8=;
 b=vHOxf7Wc+cDXdmAErv6ldG+RqmPALlc24wQN0XDxNEeLx/osUmCGSA1geCjS65c1RIIH6Tu/HzasLOfK/lZoLeLUZe4smQIKb7SlElPG/UqpqcIVBybKjLlplZzpnC151PDu/tAosjNkYZQKxhxn1ga1R7WEl5s748TzKRJqqHQ=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4709.namprd10.prod.outlook.com (2603:10b6:510:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14; Wed, 27 Jan
 2021 04:36:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 04:36:54 +0000
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v2] scsi: target: core: check SR field in REPORT LUNS
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tur3knh1.fsf@ca-mkp.ca.oracle.com>
References: <20210120102700.5514-1-d.bogdanov@yadro.com>
Date:   Tue, 26 Jan 2021 23:36:52 -0500
In-Reply-To: <20210120102700.5514-1-d.bogdanov@yadro.com> (Dmitry Bogdanov's
        message of "Wed, 20 Jan 2021 13:27:00 +0300")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY5PR17CA0054.namprd17.prod.outlook.com
 (2603:10b6:a03:167::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY5PR17CA0054.namprd17.prod.outlook.com (2603:10b6:a03:167::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 04:36:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5f012ff-281e-4ceb-12ba-08d8c27d2c3b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47099C3EF41281602AE56C508EBB9@PH0PR10MB4709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7tFZ3C3YWXNhBnPnGpe3q7O0s3+9T3hMjmqDzfnf5n7qnikn7NoLHEusVNUMy9Y83R3sgPl/QI9koavwd2mV2un5VkF8FbKb/x1X9JJy3UCa3s+iANQaqc4TTgArl/zZjIlNJYA1N1MA13MbtnaH2euGSqULUAW+VpY+kDFBJBK2fDESfueatiOQCkDEs910eEF09eYHLr4q/fgG5oKc+DfkZXCMWJgD0tSNHC7VtxmUVoaKqX8a7cUuBYE+AKQX/x5+gA3SboKwfEDfE+LVvBKCr2Acnle58jNLw+VLvgy8SA5QliRTXPNdczz79nQ6bGgrbguh8FOmP+YfXP9ANr9tnaXVchqlE/+UytCgnLt65O04t06+pHq+vT3TfOwpCMwqdaQ6/o6V4OfWsKcoiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(346002)(39860400002)(376002)(2906002)(54906003)(66476007)(52116002)(66946007)(66556008)(55016002)(5660300002)(4744005)(316002)(8676002)(16526019)(6916009)(186003)(26005)(8936002)(4326008)(36916002)(83380400001)(7696005)(956004)(86362001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?AQZ2YihqV53O6OPAnrtETC56tSUbsAzJvZSw4rGFrBId9Rtrn8l09HWqYtrd?=
 =?us-ascii?Q?ID5DmW7Lj5WDi5UO5VpEegmVor5V49xl8WloBRG/MWiBqwQa4m8AbQUp0Rpa?=
 =?us-ascii?Q?zHG1fQYsQFzWrm4Jr7xjMziAcZUzHsz+FCEQwuaEgpu8Am5BkUSy4iGPzObF?=
 =?us-ascii?Q?mQyyyrAmFbr/rvoCAnbVzohEZEcR2J36x21jauCxoTyRkFLpzMjgDPQ1onID?=
 =?us-ascii?Q?mvaJ9vhv/dU6HyCCxGvzcyHwpO7sraZC6VMPy+s7h24R7iLpXm4kv10vlJi3?=
 =?us-ascii?Q?K2Kku+ZPR2W8gBghn+jUn5aovHfzbxci8/9wQ0PzAGlQ+EAriWDj5f20uWBJ?=
 =?us-ascii?Q?8Uo1Y66sPPfFsC15xzrz68JYhkbR83YdiTo5tvsBMMaQerxQrhYhPfYXSVWl?=
 =?us-ascii?Q?FyWzygR6haEKQl+urLrLt/4AnrgoAt9ZxdgNyHFsnj1dK5z+tuP9sZzESehU?=
 =?us-ascii?Q?kLo//7n3RA8EVsQYEh0xl8Y0cjV4WMNvXvyN5emJoL9Z2m7khhu3SXzxNtQl?=
 =?us-ascii?Q?Xxp0gSQn7OKq7kCaVd9sNmgZDgJPWzAyddU1HDdGxj+3lBJmcPGBYHHfEtSS?=
 =?us-ascii?Q?wm43nSNQxkr51yCmqCx244blm3patxYUGM9hnSXLhmBwKSk/5ZYkbjNZb6ol?=
 =?us-ascii?Q?UBNmC3Dhj+VrdWqhH5+26hOgopWHbZ1KTVzVtBSW+N4XO2KAsbeAZjOSAVSi?=
 =?us-ascii?Q?K+jCkRBYM7KFm4Oy8s1f254PRbZeOlvhJnukqxbhcEw+yLMM6eJiZ9PLGPtN?=
 =?us-ascii?Q?78G3+Y8LnbrHhR2D3UP+N+AjfRIVupPll1nbf4JMaB8Fo8+60QDSJy8Ypj38?=
 =?us-ascii?Q?BUjMV8dtAyrl9iCbemis8CqrxPFEIjXSH3x77IJsNbodDQf7sCQw+LUaGdXM?=
 =?us-ascii?Q?Kq/aWFPq1cR+/SYXzE/hIeglKutNOhcJyNNRICwfqjh7o/mQECQ6hm3JTmw7?=
 =?us-ascii?Q?39jxZJ00PP459C21ozpOhEFCPQ8w8pvhsbQw0gYh2fXGeNof+XWu+EXdz+MS?=
 =?us-ascii?Q?25VYi0VQ7f+MWTk5k4s9xLvrydFBN4LF3i/sWN5sdKpvlh2ziH58UdsmsRuV?=
 =?us-ascii?Q?WLQTBgMU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5f012ff-281e-4ceb-12ba-08d8c27d2c3b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 04:36:54.3048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tJXD7uCnz+xJRCU/oLk4b+YP26Z1u6NUZaUDe6dkrCCCH1KwR7NH6whGobter9d+uMx5OEGBdXrr/m05I3PJ9vTrM51K3VuGEenaTnmtJj8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270025
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dmitry,

> +	switch (sr) {
> +	case SCSI_SELECT_WELLKNOWN:
> +	case SCSI_SELECT_ADMINISTRATIVE:
> +	case SCSI_SELECT_SUBSIDIARY:
> +		/* report empty lun list */
> +		goto out;

I'm a bit concerned about things inadvertently breaking if we return an
empty list for the well known LUNs.

-- 
Martin K. Petersen	Oracle Linux Engineering
