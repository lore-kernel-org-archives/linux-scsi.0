Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79DB4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 498EA60238
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239052AbhIND5v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:57:51 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:20720 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238366AbhIND5u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:57:50 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18E37AKK020204;
        Tue, 14 Sep 2021 03:56:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=SsPTjnABhGkyKg9ztUoWMcmdL87XYgMcC+ydJACK5v8=;
 b=mvn5n4Ibq0MFfwcBqgWZC1a53J8hz8bfZ3WQ3rSLSjHsejhEskh1adpJHB9oWq/Mon+M
 S+TyLs0v4lZl6eNkg0nocDJWZpeGq3Sr1N8bmUG8VGz9u6feyA6f8By9TOgpbnabbdHc
 pqLMR/RO3gSCtMLOs0wchpwdopT00U+YaXJP9ZqNHAoqnYLGMjpaYL2d+ZjyaEWt9kXi
 RN7dzoLvcCsGo41QQdAwU00XahF/n1RoF4lSCEWHHQV/I18is6aeC90Ns0gtrtszLEca
 C7gr48sNCtzey43c7TjIgw9gnuRpRZJkia7kcrSHkKR7eZC6iPxzG/4SztDNnJkjJnAq Qg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=SsPTjnABhGkyKg9ztUoWMcmdL87XYgMcC+ydJACK5v8=;
 b=RKfRboElggVGHTZGiPN+MvHsJsTZhsdXtRRWy0veZI4xaCz+/fcqkC2YE+rvvTL7il3r
 VzvL2cgKOcflmpHpbHllMrfi3bfX3xGbCY6BMbKILHBjEty+ITYBwVNu5xWtfLX5dJv9
 ScwRK4+7lpOQb4wLpeknYHMKuCK6shd4VFx/Tg0PCIUrKdc+gwg0n9T4t0uusZ5oeqHi
 LE935FajyC8eVFgVQ6KwfuI0tmyIGYTCES5pAbV5MP4Pqw6gezWVNcVh5cxnI/eaVk9E
 P83LTyA47Jk4czCJvJk5F9Hic1d9HUn05bqdQT+ruXzZB8Fp6U6EmTilZplIcYN59Ut/ SA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2kj5r32f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:56:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3oVQB174883;
        Tue, 14 Sep 2021 03:56:27 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2043.outbound.protection.outlook.com [104.47.74.43])
        by aserp3030.oracle.com with ESMTP id 3b0jgcev60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:56:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zo4Iil7QdaMEREOilbSGQf00RyvwHJEWeUqj4vU6m5p1C6B5LyNZTY24groyUzHDdYmi6bXnCgFZVomjj+hTK7uMx8hmkfK2kbYxQhhlnsho0ce0ufGLt+W72dbyqPXnds0LvIO+JobutOkBoSVQ+A8AbKjL1Totub0utB077sos5XlEDwUO7O8IAwiMalkPtZWK3wLlJJiVqb0DAyWvGFqPkBGRVycnocciDNpVoLuUSiPkZWpV8vSGSDxFcIrDCKuSXJW1t9zjtFUcRrhlwR6I+zkFBbxkSj3LvEWqTJLsjr0w9I1ymY60HH/pUbFjZCznViDnQbfH78SCBXol7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SsPTjnABhGkyKg9ztUoWMcmdL87XYgMcC+ydJACK5v8=;
 b=f+Hq/jRsP/hvlnHgYBmTuYJWFzfs4X2q+icDbV0AOKU+//MJS//etCFNjUkVIHeT4jOlti9QYGbKfa7tbPjCJZXswSU7B9Iv+WvqPqeJ5ReP+d5hakrpv5LamFAKv6RH/x60kRWKpybdCo15bQLjzCK8JHzW1JaUFAd7Rom5QK9+8wfTu+UmmNRWghafsblu+ef0OZnLuRbeCHDlB20PMsNPdbRBiP2zuF2PiAjIQUAucDGqf9xIVQ3aeJyDhoXimC0UOiUPkOo2PLieRj7xhnxY8MkmuUCXqesKc7Gf4fG9HpbOoQSK6KzM7PTddF8NXeAzua+3OLC+uvIQghz/wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SsPTjnABhGkyKg9ztUoWMcmdL87XYgMcC+ydJACK5v8=;
 b=P/KYF3GcyFj/q09SVYoVfoW4j15XQs8PYt5cgfZwR1EvxRVEndigIorWnq+/dfLSdjWKqwIFnUjihH2G9M1npYA7NlwgDFCtpIpjdVbSjFwDm/kidCBR1vnPJGdQpV/vFyPW3OPXPNLdkZtnH1M8sbkMxqwHKRkoBJjuYTf+1AE=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5452.namprd10.prod.outlook.com (2603:10b6:510:d4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 03:56:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:56:26 +0000
To:     John Garry <john.garry@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH 0/5] hisi_sas: Some misc patches for next
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0jjzu75.fsf@ca-mkp.ca.oracle.com>
References: <1629799260-120116-1-git-send-email-john.garry@huawei.com>
Date:   Mon, 13 Sep 2021 23:56:24 -0400
In-Reply-To: <1629799260-120116-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Tue, 24 Aug 2021 18:00:55 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0097.namprd11.prod.outlook.com
 (2603:10b6:806:d1::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.7) by SA0PR11CA0097.namprd11.prod.outlook.com (2603:10b6:806:d1::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 03:56:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fb1ed01-8d09-4409-82f3-08d977339fe5
X-MS-TrafficTypeDiagnostic: PH0PR10MB5452:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB545289384E8C8D84F19EC4A48EDA9@PH0PR10MB5452.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:425;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: osY2hBiLSq/Qq06UUkXqr/djQq5neP/3rf+FMZ9b97kPeSLH5I0rPthHdswcLf5wOyqzSpWCQJJqH2RCEB0+zGOtfqXu0Ek5WtfbRZw499JD335NvcCg5vPN+DTBY865hrDefB87VS7+j+BottevT89jeApAYiLw0TPjQcPt2AJcSIE+FSc86wjIFIzJc9EolHn9qAsVRynS1KLieGGuwAfpuVS3Ecs3zFJ7D7D10uBHB1q0bV0L/Pgr7NVfj/2RhKdmuC81Aem7piAXrUw7cH/XPQUbPYBHj1Gi/YmGY7lc4h+kmrHJAhBr3p7G5EHwchrq7RbWW6g6NMQHyxw73UiSE4JewfJYr4t2k6vWECXvGJZKsKStWSN//hBlEGGLvcj9MslnNffcsqEOb3UrTSGLW8ZhapmlOB5+WASbCpkEbi9vYAFQaCAo83OEZWlbF7docPf8GOc2tCPDbXmJCBOrubibniJ2ti+5jP+qfSXJpEu88AC44vLI1OyaEjQyKy3ZMWfkAoQcg7RooLM62U6qoJh4CaTrIfoxr/zDPM9yJiTtVkYrL72KE55o3lprSqJTftQ3kUF8Dyc1X4SIpssWtBeUyHybr2V+BLcHdMKZTav2NTpqWwyBusfdsjWwrBgnngAeWHIs6bWAPpwWGpvtsiZuXPMK2xTQ1LJRLEKbkOwi3dpDSIixjT+9xVWQmOuFxu316X1nawcmTSclrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(376002)(346002)(39860400002)(366004)(6916009)(558084003)(316002)(66946007)(66476007)(956004)(38100700002)(2906002)(186003)(54906003)(4326008)(55016002)(5660300002)(36916002)(26005)(86362001)(8936002)(8676002)(478600001)(7696005)(66556008)(38350700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0Jc88GDLI+FSP7VDChqnT1tYMdmAiaQ4RkR7qa6peVc+4+2s1Agn5lABeY+S?=
 =?us-ascii?Q?KI04zKxdQe5jKhlafauA8I0hSPhSebME4oLPCcha9nZbquAsZVHqNslyHBmH?=
 =?us-ascii?Q?+7ueOEaXfqkBzq8bFf1n+cVxsueXpjTXd/UxIsqBladythakKjVdWt4x6zmh?=
 =?us-ascii?Q?UWc3D1VpycQIWTd1zeSyMC8yf+yWbu8eE1JdZJI2k7lApsi8pOQKLMwmHUpS?=
 =?us-ascii?Q?as0VGvznAmoxethTnw6nvTP6S8gEFyzJG8CdeBnVmk79TmjOSpZ961kvCZtk?=
 =?us-ascii?Q?4g7kTnweoMCCb2g7YpAednsXUFfEkE9XOhAniixCV1kUa8rWRfjRpS6/oVJe?=
 =?us-ascii?Q?p0cFLgIsbadsygscp0G4IcCwM6oafUjnDrj2MFtKZwlFB59D9mb7p0rzhLPl?=
 =?us-ascii?Q?+rAOt/MpKn5032YPRMSpSOiaJKDwiI4g8f2PEUb855YlPMlAvZdqZ7fp0wfI?=
 =?us-ascii?Q?3ReDoVN/G3Gan4nKA8z1r8/jnDvRlwNLkNHKigNUGCrU+4sOyLuZx6IjAtt4?=
 =?us-ascii?Q?tX+EU7CrPKvkQcD8tTb/Tqzv9cfrORlhdYD/1WeITGjrTecpbOoJdonJKkQX?=
 =?us-ascii?Q?TVTRbooBKg3XiE6mbHiFvUXakc4zprYUOHsrY4QY7V9nyZfOtLH/cxhx9S0u?=
 =?us-ascii?Q?f5sF55haBOxZk1Zk9NP+j5r1V/LHnccLuPVjcn5KxV03ygHhROPQFhBA6AR7?=
 =?us-ascii?Q?eF8sbwArJPKpn8s1I6oOB9BPpQXUdXdb83++cIKgxUxSvxyAbIhAriy/hSqb?=
 =?us-ascii?Q?WsI+RpddyDIR1w52G3TlFDz6TY+co2a4GyvCI2rCWbirvebiibqGSDU/q39s?=
 =?us-ascii?Q?ioKHG3yqiJrWWahuCWjH6CDmxgAUGXhDaVwAOoHWujeU7I63YNIlvg7OnSTn?=
 =?us-ascii?Q?r2TOehvijBvY6CEcIAKQaRDcRLybCEl+/CU0Zc5EeLVbYBZi4wSOrZghWszO?=
 =?us-ascii?Q?xQdJqg43RCMlA+WezFcnfhcUIdGagy5vq2Ah9XrJ+4BPheLn3fFhZdd5Kg7G?=
 =?us-ascii?Q?cn0rexil7UfbkzavT9QHOo8JTtij1DtZSlt4zNxBbkqqXJiY8v9vnbk/iDQ4?=
 =?us-ascii?Q?AQLcE4SbfkP9l43+q66M/Xl+oz9SJRKwmpY21zXIZ6l+tWVYpDnAXdMeGR3X?=
 =?us-ascii?Q?jDFbWbdryy3zcFhghvRuTuSLNpVvu+TMSNGEfR2VHfWLqu4N9l7NKC+9ezXY?=
 =?us-ascii?Q?+ME7IDs5PQzaUibs56yzo3dCbEcpPG/VYEDOjysjMEnxTL5AZDnJYoYCgADP?=
 =?us-ascii?Q?M0dir7hoxAaY09NGGu7uZABiuYFMM9eaJVVRfE4ccuz2y3Z19a8yEJPvm6xP?=
 =?us-ascii?Q?2xeg2fEEuw3JPWKVn34v8jzh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fb1ed01-8d09-4409-82f3-08d977339fe5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:56:26.0994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AtN8q9CZ0HykHaONJB1DC0NsRDn83RVI8BRB4zPF9tquIX4+BntY+Gmh3wPm3ZAzmzMO2h7rF474H8FeedtU8tkgv6AH/kIBVL6oaFu72d0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5452
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140021
X-Proofpoint-ORIG-GUID: KIT3E7maS2ftWiUlY6kV9ttdAjaUI27N
X-Proofpoint-GUID: KIT3E7maS2ftWiUlY6kV9ttdAjaUI27N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> This series contains some minor misc patches, including:
> - Fix debugfs dump index
> - Stop printing #hw queues
> - Use PCI managed functions
> - Some timer changes

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
