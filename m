Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC49EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 03:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1FA26138F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 03:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243929AbhI2DaN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 23:30:13 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:44274 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244018AbhI2DaI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 23:30:08 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T3EIlG027750;
        Wed, 29 Sep 2021 03:28:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=fpBKsyX4mztoOTlpMziDHfXXHVCqXXg9wo6pmLb81iw=;
 b=W7BjgxAtgUgj9XlSk1/uCF5S1kpyJfIm4StoALRtRo18cwe6tU3XSxioT0zTDN5R812K
 j4mJhxb9/zU9d+sfg1hascryimq+czf0P63pgyoC/FfPCYMGhvIStHrN3J4xkQe0r1sg
 AlBT5YR7R2X0zcGhpSKxxG4XxEIR5X5LqliSVWxzLLIqoBqci0K9lxsHB3IyND1HtGVm
 dm5fxA0N65GvfQcwulZiYhQpaE/+9hRliM7kEfqe73JDoGxMjoKpy1m7Z0imhOzTIrrw
 HSuAQYNaP+q4eD2SEvkAyADOemG+GakeG2sg10lBFYV526I2zT5O5pBCp1b5DZN086fc iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbj90tnc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 03:28:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T3QRRh082305;
        Wed, 29 Sep 2021 03:28:25 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by userp3030.oracle.com with ESMTP id 3bc3bj9rjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 03:28:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EV7VRtLaRZwxUe5yp2B+CJZB/fiADgF9eQscZwbTkuxqe8I05xqkDVIqlJNDYfZIUEStgCKN99lQmj9Wa/d/SBtYQDd/uoshRkXajavXYJ97EEOzDuBVkwXVEB/rnqYRfoBecu3CiEnOo8TySoIOhOiurhRUQpfAWNmebl+drhRGfKUB9ndJINMOlwHsr3FQQa+NIpBYsoy+ifmI7cabicL+CreK8TCGRMzlW9Eg4uH6EQCa2j01OAOCthpMkp7jUDHRDMI+48ZM02HnsyuA3gZjW3+I7o53ml8HQG+s3XpBnWCDK7B5eO1I8plctbHvj4GNOQbPxPdy88c88REo8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=fpBKsyX4mztoOTlpMziDHfXXHVCqXXg9wo6pmLb81iw=;
 b=ZJoGk9b5LrdAH6BBp6gIHTxgVHgXEkzo4NW2Dx64Eeh3DUsKFPETJiRFJccdgvkHzZErclahSWNchjJGtbzSGpGDDfF72TS0SQhZtMvZcNqZ6hGh2JF1G0wqFs8qO8mW/DKxf12v/9kPUNYfGvd5BZs9xQmjo0Eq+iY4hV0D5KBj8KcPcaf7Dn2KtbHvTcVtBhJNRREoD+m2NYd01LpR6lWCrfQpBCHATP+1wc5KhmUYBbsuiLZyxSjoev14dtSyYC7mYo7c5icU+VDf2eDjpT+zLmBimSeZWNZFWd2QG+Y2VBE9xO9Ofaiy+b05zV5th5Enl6Rr6TcjsuImC8atyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpBKsyX4mztoOTlpMziDHfXXHVCqXXg9wo6pmLb81iw=;
 b=Ru4nI43JQgYSyYA+obHMOsiN/YJr6wtxwVZHQ1Qt13XNC75aJpj+DsDuOcWb1/GAKX/lhYgVJL8KLzvRE7sFKzbq3F0fDacYlA3U4rOmxkptpI+DuX6qPVNsbF6YcuGW4SKjgBcY76CuZXxgNnkoJEadJOuWBH61oVkZl0WKpUI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4552.namprd10.prod.outlook.com (2603:10b6:510:42::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 29 Sep
 2021 03:28:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 03:28:23 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org,
        Nigel Kirkland <nkirkland2304@gmail.com>
Subject: Re: [PATCH] lpfc: Add support for optional pldv handling
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135pof4c3.fsf@ca-mkp.ca.oracle.com>
References: <20210927183518.22130-1-jsmart2021@gmail.com>
Date:   Tue, 28 Sep 2021 23:28:21 -0400
In-Reply-To: <20210927183518.22130-1-jsmart2021@gmail.com> (James Smart's
        message of "Mon, 27 Sep 2021 11:35:18 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0014.namprd05.prod.outlook.com
 (2603:10b6:803:40::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.46) by SN4PR0501CA0014.namprd05.prod.outlook.com (2603:10b6:803:40::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 03:28:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fdc7a6dc-69af-4865-51a9-08d982f93121
X-MS-TrafficTypeDiagnostic: PH0PR10MB4552:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45524B91BC685B4ABB1E46188EA99@PH0PR10MB4552.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rDCMffR9IQWhHoSWvBKflZ6JhCyCsqw0HH4SNMqT1aKuERTYzCALUqdd/lGXODniovlnuUv4VyKtOijGMECeZ7HyWq6udl1AscQGVcsiyrtm8KwHo5Q+U28h2qSYpXHYVk34UN/MgJTc6ZF5lnBOykwbOYPohj8EizKWwuJUMobD+0x9Ap0P97R3Z2+Iw7WANisdg/fyzZsShuBQLNpWIK760/Vq066FAz0kpPXzpgdAk0pzEU2TmlA4Oz0HA8HrZT8iaf771pU9PgDaDHdExoVW8lap/cuAhxtYXjv4Npivh4IKoWUwrPK8dN7lLuKYr9Yf0H3gFeiE61ApkWDwgXc4x/jSN/9HZ+0i3MPaPqV6CNQ9xnGExgm/mff050c6gdDAp6e2BM47W/RM9JGvAzEudZFlwHBEjPucQPYiIGzrgAUj+vhYJns6Fw1XbZyEFCcu0QokGSWPei9sALEmNaclbTxB1kXFlVhXNrdNpD82d7vGac+WaneRlKqZY3AD+cUaqjqGPWa9cGcRBHJ4rr6uhHAhCwWSv46NU74p3gKspuQSPI2agc4yXfc2YAMXtk76VLiHRoCfRuDUYnXwuNT7OYvHbFx0DV2FL3iHZcegx8gOgoynd+JT5LucYSSKS6QC+vtXxiFgSFUxI+e1HSgaPUpPle3qriMBjx/c+PLibdZAxncU7RftC7w3r/sDMiJffnuK5RbtQwCwNa8irA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(7696005)(4744005)(186003)(36916002)(6916009)(26005)(4326008)(8676002)(956004)(508600001)(316002)(86362001)(2906002)(38350700002)(66946007)(38100700002)(8936002)(5660300002)(55016002)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qdjI4yaokODlRlm+PzTiAX9Pj/qSxttYR7EwAoq+WY6VRr80A+NlQFl+6Q84?=
 =?us-ascii?Q?EC3tdE6wCp+wRY+AgEtZTkGI39Z718yCJJ5suqDrZhzUcj3+eyhqD5Rrme8O?=
 =?us-ascii?Q?l6MWqnF91ONizPT/355O+ngBITwaIBiXhfi5FIvXkhJMB+6CtZE6eWOGQx6L?=
 =?us-ascii?Q?VzYzG7p1Ys6FCdixropZD+ZuzwIx0+3MOjhGSTJ8xc5XgYs1f5o8QOAFFuZS?=
 =?us-ascii?Q?VQVhvnDD+TGuQKgU5JtNLNV6LEG6b1xmhs+lbD1WOrHkgmBxACtNsvTFIS7j?=
 =?us-ascii?Q?6Jo90c3+4DVzaA+h9eelXBUs3+2Aoys6HFzi9xgBcTSaAgsQ/d6KJiolu+9v?=
 =?us-ascii?Q?UQGUFIM/Q0VtuPVEqh6fS3Lw0Ix+tlLlS7yx6Ci9AvcJdOhSEQGoqqw49/zq?=
 =?us-ascii?Q?hhW9RKe/Fomax5Oz8ktAWFYXi+u53ffCGnKjpdZ3+CRTYcyeilHrVURKMvS2?=
 =?us-ascii?Q?buAZ0ycrhUgOdTkOR/mlN956pdAwKtONND+Mb2duMd7fwja9KGOOrvXZ3RU/?=
 =?us-ascii?Q?h1Ww7Kwb8kRiaZLRpczeSVX2JpqPirngZRh4usA7CgWM9DHu+7YW3mMyB5gU?=
 =?us-ascii?Q?LU5FVOgrjodTJ/7uhjIjXWtC3v32iCjx9SwfPLZO7gKA/HVYQ9PHs1z0mWJG?=
 =?us-ascii?Q?95WnQ0V/LEx2Xlb/YS5SZ7l7LZAGoSU7VB5lCFUwbGe0WaxXEEINfK2WEGQ/?=
 =?us-ascii?Q?uVXQIF0D4cpj7gUf2EQxMxIWbVmS6iuBKOerAXp8VfSgdzbQE/t/O2hUxxvQ?=
 =?us-ascii?Q?Jk5Sa6YdcQx1QsnmAbBYiZaqA4dCqbIyrNrBjbY/37An7UxYKlAXX2C2p7KB?=
 =?us-ascii?Q?0G/knnYKrwgD1IdQ5etdYCNLqQlup+9V0tzMH5h/rikBsIaz/E2/weqXv+JC?=
 =?us-ascii?Q?FhVdTAn98QmcwQaAyL6ZibQFWLfPSvh05YGPCllB4S7dfeawXor2GmW/6OWY?=
 =?us-ascii?Q?xQgfQrpZHnoYend4QwRj4r3kwpd80bwgbJO7VlmxLr8SbvP8cDS7I6t2CPIS?=
 =?us-ascii?Q?7BJ4sIcrCxqX07zZdvNvWh8GS9L1g0pqccrnkd7fo9VudR5EUsHSQgzAzG4L?=
 =?us-ascii?Q?vgzP2wFMTa5iccHrT1/XaiVQdE6HZlH9Cr6Gl6s3yEYHtZoTseTpHyQrdoOo?=
 =?us-ascii?Q?GPisAB21/JGRXymTztbpoRvdyVnYy7gzMz/IrEJ8n+MexSnn4bHbIx8Z2Juh?=
 =?us-ascii?Q?a+HUBEwEElMCjQjEEJL5FPCeBzitgznFLpzgXpTFNwATtaIM3ZSkgwVR6sY4?=
 =?us-ascii?Q?jCRFPblRglsnSCw7e0c0+AAjwRCqciinyJA+aVwTf6pqpfYbneUIzuzI1XHy?=
 =?us-ascii?Q?RWLcJOKkircKJLGaiobWa9hs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdc7a6dc-69af-4865-51a9-08d982f93121
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 03:28:23.3157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wT59HGn/gkr5JXocE0vfujhINaj1csQuhev0B7BFUF0CL6hQbg0xCfH1aeN7j2P861AU2kVmiALzCWGGdg1fzV29hSP7Wac+IoPnJtJEK6U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4552
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=963 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290019
X-Proofpoint-GUID: 8LXATg5l40MTW_ZLssAdNkuxPLRylt3B
X-Proofpoint-ORIG-GUID: 8LXATg5l40MTW_ZLssAdNkuxPLRylt3B
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> At adapter attachment or SLI port initialization, read the
> SLIPORT_STATUS register to check for pldv_enable. If found, the driver
> will perform a PCIe configuration space write when attaching to an SLI
> port instance that is an LPe32000 series adapter.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
