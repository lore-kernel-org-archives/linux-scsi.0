Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB0FC48BE8
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A6816120A
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235135AbhFSCjI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 22:39:08 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:35960 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235233AbhFSCjG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 22:39:06 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J2Vcfi005506;
        Sat, 19 Jun 2021 02:36:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=wNWvIksagMEpDgbMrzmYPsbD9Lh8UJm/Oe0Qx824zT4=;
 b=QNyeTv/RCSLVTWShmdsOzHFy8VIR91bRYli5ub4Wi1IMnDHsGS71df6UWXHMEhcO8Pe0
 y2bFmv25BDTJRWjEurNBvgVP3N7E7mpHzuYD8ND7GtHIzo4pkwa/gRQVSb+F2F27atBX
 FH4LNm1HVxGp6nOtX8Eu3M4Ch68aNQwxz0MfVhCYqMbjFqBjSCRND2b2cDLfWbCWBqgz
 VSHJik5YWBBd75bRqSdCWLa9/EF/uXmMqmCKqvkAmnUKKT424VgOjc4CRJ7u/vhHctfb
 blLRUklcql4iQ19ajvJm1Qox6q0N2gZCajJmGcFzPi7hqnKxqr7IATb/cpmAlPgFeCF7 Xw== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39970bg154-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:36:50 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15J2anW3041605;
        Sat, 19 Jun 2021 02:36:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by userp3030.oracle.com with ESMTP id 3995psayt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:36:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=APfYpUHuu5lYUt/5u5cyz5aayjsZa5tYM9FuBrd4o1iAAfY/D+zmQJUALGHxJAX8ta4l4e+FbpSRCSWtz/0YW3qt1+qjQl62zmV93J9+zOC+UqV4dP9S3RQwdkbjpoQX12RyfmQREasv0O/Z+zMRCbjV3QaUsCJ4/sp0q84WoHcFPycgV6C38Hhr1FtjcyUXusXP9LP13YTWpaoYjnj/BaqNKHGSWDKy9sgiH4b1d0m+hY4tR8kobdBd2Y6mQmDHgTwX3+NEaQDyJ6Bg4pY6bKHBkLPNDxTikJxw0C1/xtfTObvUFxx+nyYihoIawrWHWqK86GMbQ+IHdW15JXuqrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNWvIksagMEpDgbMrzmYPsbD9Lh8UJm/Oe0Qx824zT4=;
 b=OQ0vI7cB7RYCrDYAI9toqDMTcrDP8Aed3WMnL2wHxiZXKnQaBn+7l6jJTIy0QkO3Vubrj8SDwggodzczBQ5EJGKtbgEO5YroAnT4biFvGbmT9G9UyD6fXYoxSMZPw7ct7G/K6DP/BR8K8Mz1AIhUIzTsMEZeIYX+3hsi2ZDacm47T4j9c2zXpUMiFNbSeTNT+Ws1/Eb4f5L7g9R2c6a9ystX1gw1yUzsNpWGkaSDh4jY7tld3evUp6E5TDlMKOstWg2JiewjpZXcWVs9CpAIuxJO6k0kDQSjL2H7+7v+ce5CJMizIK353YeFUf83zSFOzaymwGu87W0sWKRFGb3oMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNWvIksagMEpDgbMrzmYPsbD9Lh8UJm/Oe0Qx824zT4=;
 b=TrF8AZ6uhzNmMMMwjBbN/E6izvHByOJBOEKK6JqQ8/fCAkRBP8Uzg4npkRiRN4wsHAreUCqhQocnP35xiXoplNRCfeat47E6jMkWaEDHN0NRt6GEuup6ZRDTtk4/88aE9OOERm86N61u6HXBdJ9221IOJ+dHIIROMAkwb1FC6nw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Sat, 19 Jun
 2021 02:36:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.022; Sat, 19 Jun 2021
 02:36:46 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, gaurav.srivastava@broadcom.com,
        linux-mm@kvack.org, muneendra.kumar@broadcom.com, hare@suse.de,
        martin.petersen@oracle.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] lpfc: Fix build error in lpfc_scsi.c
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsxey40a.fsf@ca-mkp.ca.oracle.com>
References: <20210618171842.79710-1-jsmart2021@gmail.com>
Date:   Fri, 18 Jun 2021 22:36:42 -0400
In-Reply-To: <20210618171842.79710-1-jsmart2021@gmail.com> (James Smart's
        message of "Fri, 18 Jun 2021 10:18:42 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN6PR08CA0009.namprd08.prod.outlook.com
 (2603:10b6:805:66::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN6PR08CA0009.namprd08.prod.outlook.com (2603:10b6:805:66::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Sat, 19 Jun 2021 02:36:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d385187-fbd1-4f3d-6285-08d932cb155c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB459724228EC43ABF5CF1653D8E0C9@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0UToLgu35Z349mTpAZ8m6Mjg2ZPX7CGMMNE+2yS2KUxLwel3mu+G2yL0PIDm1WYZuHTpF+ndbUGL96FXSHpdsxhET6WyLpcbHQSpc2g/HfIG11jslDHKKunR66PE8C1HmmAirFsTOPhtxqdUmH6biGk2v1SYurxI5zp22KR9Pm688reABzw6tGXLgWNTMhU9OWirSaxFZBEqH5iLtqkvMuYkmSYa97XRl1zVBo6Z6aHk+HTInwMGFpxEUiV5ge/QVy+3uGUnRUkhQ0Q46YVsj0vqXZmkEGxpeF2Ud/vGqgZRBNM+heI2EfLrSOl4JO905QPHSRAE4rMtuwCDbIHW5n015hPvlWqfq5wK+suk3wb9JFfL+mYXU3t8m4Zc5fR3a08td5MqDCphBn+RpKs4XTbodv3PtEeiSVaoAj2502yDCG4mjkOfLtsTboy5EiUncrlw3LQLVkJ8rA4WfTqtecBXTf6Mu6/L71Y2AugUQ9ZSAql3SsaB29QN2RsngekMBGtNUzaBMtbH9TjPolk2svuf+Qhlq58+4+tTrasZ+3e6Fh8s/HI9WfMsiKT6nIOXlJ0kbfHjsgsLcWygw7Bd9EhGto/1KBc8VAGko3ewWHP/q7lLPcaMMsDBRrnjxBDm31qa5dkwliSnaPsDmrUTkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(136003)(346002)(558084003)(66476007)(8676002)(66556008)(66946007)(8936002)(26005)(86362001)(36916002)(4326008)(7696005)(52116002)(55016002)(478600001)(6916009)(6666004)(186003)(16526019)(956004)(316002)(38350700002)(5660300002)(38100700002)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iH8kO91hLLZLdonvJ3k9sfYg/Q5nyTS4X5p2KzdeYdZd/eu76e7bavmIASgC?=
 =?us-ascii?Q?fT6QCTlbhmODEc64gY0OI9sYOILbjNoe7x48V8rzhqzU6CO6EJMBkJeWdqbQ?=
 =?us-ascii?Q?JFZBUXvNe9lsNwCWDrMurT8O7AEGZv/E+F57pu6XQ1LhR/r/CsiNid0Tgeuc?=
 =?us-ascii?Q?k8R8SeW9gqobl0irsHl7F9PGW/Znf+n8FG0+njAVHB8NyCk45gqTx4OawusU?=
 =?us-ascii?Q?a+MVc8p5EgU+WQBB+6K3av81oNVVfgiru+U1sDao/Pej58D+NaRdwboPQTDF?=
 =?us-ascii?Q?/R0g6srPCGqcLkL43YdFaMSqITdADLu0GPHYT2hvOjFCJ3t0/Huu048316JH?=
 =?us-ascii?Q?Z3/C4f/ltLsXpUhA8J8BCuRHCUNlyYFKbGXRNwSeNVgGFlmGFHuY4bjHn3wP?=
 =?us-ascii?Q?A5R+qkHUWKHj77cnYNx4UfXig3TvhRQWTGDVt4s3QBiQe8XJ2YYJDPcgCseQ?=
 =?us-ascii?Q?RukZFAu8ywcq6jKqj4YIv4d5KYTluFznCyQQ6GYMUdhgoiKYhDQGEoC+2mUy?=
 =?us-ascii?Q?yxxaTv5DnuW4jnPWEEj0qIwlg3HfzWIMEEPch6j+Vrv18wn+2mjQYUpockym?=
 =?us-ascii?Q?GblnRyC14rrwJhz9Xcuv6xWKFJ/KllBtmumyVJzCfwpa9jzdZnBOK3dq11MT?=
 =?us-ascii?Q?Mivvd9fAytb9hh0Jnh6ZgdqcW+pb870Z3yHNvF3ihsffztAVtdlGiHAMfr/a?=
 =?us-ascii?Q?Aj2DmpR2COrkqsuwviF3mu6+Yx7wX+hBSnf2R3R5nhtVzNeHOPtGQLliDSGl?=
 =?us-ascii?Q?3nVT67XPxIxyfBSRRf1CxYX9jKsSqAX7ERWO6e/W2kaf4C/45UdDW4Ewxikh?=
 =?us-ascii?Q?OmkmXDhCaZSf9mKKJVeof5GUWaxgcBb+pm2NfL70Og0CoS93DRJfqbzuRGsa?=
 =?us-ascii?Q?XqJOGWb3IToiOwnAHG4M18DHWrGY5GzO9WTDR3vySpHYpezktVMowKgahM1O?=
 =?us-ascii?Q?5bgKfn2mRInmrLDjozeh260Ulb87Uhn2MKd2iPsy6MN6vvN9ZrpAtJ0h4UpD?=
 =?us-ascii?Q?6yYGXAqYtG+RmRrC/RjLTdg9myTrQEwQsDL6lJXcGJPZuSUADk9XxPPTs9c/?=
 =?us-ascii?Q?fX4+p7Q3rddtD3J5ClkKc3ZwMytGowN3+XXh7PC89D8N5piFiioAPShz5zsC?=
 =?us-ascii?Q?QOfd2TGDxofixT6r8KtOu3mf/AqcHcfoqzkB8vYlaxC9WGUf4JumqTwynObE?=
 =?us-ascii?Q?4rGxDzHC41GHheA1FpZwGReD0f5EXF31W7qMqqy4mKL4bHURSora2X/NgrKn?=
 =?us-ascii?Q?enBEjQoIvV95SVooIKVSufSnlJYJjUpVE/V4O5oidX7eUi10nDzV+yCWBaLa?=
 =?us-ascii?Q?951X/v2v5ykZBlUd98CblxSD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d385187-fbd1-4f3d-6285-08d932cb155c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 02:36:46.8538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nH181iy2kQmrEXxeti2tnup92Zueh5pbt45mpmof/mVCuePF6pft1Q7Uulb8ctyVP7ZuXZje9NhJM6D77V4fMPzvYtWZQBAMvG2YvvRpGAg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106190011
X-Proofpoint-GUID: ux5J2-0utH1-jBSDYWGrNkuvNcj_CLMG
X-Proofpoint-ORIG-GUID: ux5J2-0utH1-jBSDYWGrNkuvNcj_CLMG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Integration with VMID patches resulted in a build error when
> CONFIG_DEBUG_FS is disabled and driver option CONFIG_SCSI_LPFC_DEBUG_FS
> is disabled.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
