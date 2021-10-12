Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C62C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 17:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D668961074
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 17:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbhJLRzs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 13:55:48 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:8978 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229810AbhJLRzs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 13:55:48 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CHhPKD002244;
        Tue, 12 Oct 2021 17:53:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=1+/H9x5rtxCAwe/A0g6Bvo9+YmABG2FexRwqRK8jFYQ=;
 b=pEw6Am5A2cEXcdFX65G8maC4RX4r8nUNq0YSctjDp1NaO0VUMpXuDoJgXpSghcm8pD7k
 ZoOgFR6CdSbidNGCP+uax5GoplDCLY0HB3/5DcvzHpFEdKjiB9TO5tXQ+kkRdnk1/+R9
 M2BB3sPTfHIfm4VyMiL4XY2j1Ppc9hJyppj0QgvQbXAUXeBpl/VdrfUGk8+0u2jLUSM/
 LhdT4N1v0ZBCgOw1yvrR2/eifiC0zwep0JbnpsIK+OamFtDRlkSyvpytZwJz/7NrhSZG
 bcxGcYhTiufgb2CXa03nkHvArYfjB3tkBEb9P0drM47ZA7uyUuqKVFepjUfu+NfdXjuk Ug== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmv41qpkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 17:53:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CHeRBw094382;
        Tue, 12 Oct 2021 17:53:37 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2175.outbound.protection.outlook.com [104.47.73.175])
        by aserp3030.oracle.com with ESMTP id 3bkyxs3cc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 17:53:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JRobItfWLlngpMI0strwvZ0Ua0+1eF5FDKwSEEFBwlVgbxEKsBrx+nter1FHSYFO8ZqZv6K2ysvbcZ11xw1h+TkEgsSPw3CTQQHJTE6DbBsoPP+A2CmvA2N4Xi36bgWXbOHq4zXfsMh7ox6j01HU2MsNDubqw9YJV7ljMeXjEO/VVEsOOPFlyJq/EDoknBzl3LEy5u2et5FaRZf+nBafBz7g5vOUSCOjqhrzhpey0GyXFNIn7ev/OtTnrwlBENUizy5DaLIMfuJW0Dvtt/r6dYuOkftuCtkiUZ3UORhUYMIaILdyioEB/Cw5weJSsKc7xR/gxWzxrJNPV2jbpyrkSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1+/H9x5rtxCAwe/A0g6Bvo9+YmABG2FexRwqRK8jFYQ=;
 b=YPCDWwn4gRf/hcNXZ8RMp3DteHapU+SVs5nwB7c26w28jLyPpoNQzKHX/h35hh7eEW+PZ5ZktCn/fygM5i5zTXuuGknqhzud8cIerYR0oBKSDnOTZCMo0Wrp1gl495+oo7ff9qKvTlfW9osXrLn8NGnNqbJCi4JJxEPbEwN6fJF7V2rhW8iSNOmGsOpXU3oipKcLaM4zs9R3g9vL9nIcGGchFbENckhsuBti1pQrztpEAq4RG4asRNiuOi3LlG8U7ZDahfp9N0vbQNwxYOs0HxN/DrDFVr1qlzStc3X0f4FxRmPFzeQbUiyk6JXqXxFq1CU4wBj5UqP0c74/0RTCTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1+/H9x5rtxCAwe/A0g6Bvo9+YmABG2FexRwqRK8jFYQ=;
 b=tahuO9WX7PLHn+5X3WHqbxKG+mRQjG0yLqNg/DfTi3HXmNbL5Op6KvV9Qv17tJSZ7YPhvzP7CQXk3ZUhU1qC/IUXHuEU1wODn1FrvoOSK5Co2jg+VU/F4NkoTfthSoHsrZTRhm+cBXd3qurAItmljOJpNqZyDzyRo23UKhZ9I/8=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4486.namprd10.prod.outlook.com (2603:10b6:510:42::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 17:53:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 17:53:35 +0000
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2] scsi: ufs: core: Fix synchronization between
 scsi_unjam_host() and ufshcd_queuecommand()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18ryyqgdn.fsf@ca-mkp.ca.oracle.com>
References: <20211008084048.257498-1-adrian.hunter@intel.com>
Date:   Tue, 12 Oct 2021 13:53:33 -0400
In-Reply-To: <20211008084048.257498-1-adrian.hunter@intel.com> (Adrian
        Hunter's message of "Fri, 8 Oct 2021 11:40:48 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0062.namprd11.prod.outlook.com
 (2603:10b6:806:d2::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.12) by SA0PR11CA0062.namprd11.prod.outlook.com (2603:10b6:806:d2::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Tue, 12 Oct 2021 17:53:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05b17bb0-13cc-417f-5636-08d98da93657
X-MS-TrafficTypeDiagnostic: PH0PR10MB4486:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4486AA14695B2B81C384C6A58EB69@PH0PR10MB4486.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NY+irz6cJNDokoF4AHb7SWhKOiKXFMKk8HGs7O39HceZrAPRl5Tm2hBN5ntv52F1xs9NjD7dMw4PNpKjbTu3nqF18iyQdEvZtEFNHhfAX5KGorGciN40oVt2PNWVYWZ0oPy2iUPCLN1yy9aNEJsVBm0xsFjVwb0bpClBptzs07P61Eyaio2lxVbR5aC0uEHSdzkfx4SVHtkbhrCB2YnISRDoxhVLZP26lwDtgwXsyYen+OhWYBi4InDjqa3Svm2E8Nrmeb4tjplGG+xXKniCNKw9z2ZlxMpc2O5Xe67TcGXMATH2BrjRSyCo75fV9uy942YPZpFLfohceTFERfqrEvM8m0Pfpjsqdyi+vK0tqvmkZj0XE4BNo24Eqvypjqe2wOUCAT39g8trCoDZwW5WUQcdyTiBqIOSkDSsWO1fpvylIi1rRdtj4KO7+YgFX48mkWWJzK43HhiyF7KD/A5ewN5AmeGrsnXChU/9joBuncKFmk+4wKeeLeHVs+CN2BDJH4x3RIA1IoxCohkxcGHSMFS/TupPmVzVao4t7TBrcGG4DrP5HKfyyctCWb6LfX1NcBlaTL1+z61Z1LEq11Z1zIKVV6dAffTTaOL7Vob7lHHDPk7lequi9v+AcxaMOaZ3xRk4r0qaJM31pNTl6lVwxmp1nFqwhCrIylL+FKGzW+Ta7iGNTY0MBZW5Mknsq/SlZ1QcKVJJMz2GntZXMIbh0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(54906003)(8676002)(86362001)(66946007)(55016002)(83380400001)(8936002)(66476007)(7696005)(52116002)(36916002)(4744005)(66556008)(2906002)(5660300002)(4326008)(186003)(6916009)(26005)(38350700002)(316002)(38100700002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JvqDuOwDbowuOvM852QMwE5HLAoksI1CHcNt7p6Po4PYLhKco8t8h8PkFWlB?=
 =?us-ascii?Q?u2c0uQQNLsHdFEDBCnJeQJD/9hRRS5lRoil0Aka1e8bBsRM4RutLqXITwxUd?=
 =?us-ascii?Q?zSyQtesAaP8T5Z6bN1CowiHTCMeJQ3PBGfH83GVEPKjJOeNhsuZBHKMc+GdM?=
 =?us-ascii?Q?jabUxgMGZx97+EH/s6w2CULS9L4Lgrj/WsunKKX+6fnj5QrCfFM8OFiUdlQv?=
 =?us-ascii?Q?Ak8mUKrdH58aB8tiAVlF5f0yHsmUzLhzjtgf/SGm8kW3Mg2B/xrWrcwjQ+W/?=
 =?us-ascii?Q?YCo/g7jDXexFrBvEAg3zE1W2spZlRBC/pxIDQTWuXfgwAA1peLOgcUQOLHVl?=
 =?us-ascii?Q?eoy1R+6rbaAHg+dwZ1yM79q+U+kGFnG8sWifCuT8ia6PDwxYxSP6UYstZfQ/?=
 =?us-ascii?Q?osAz8nL6FRk+fR4o8lK3+d1pNYmKjHbXnhks9Bv8v2KE+GiPYLRetptjwehF?=
 =?us-ascii?Q?11Ewv9ZoLOmidJ7fzkyuLwmmkAd4naAaec+TSewubZTwXzf5QvHA0zpBGEDd?=
 =?us-ascii?Q?ytfB4uPBM42lpG7rpR7GhWw0r8Sb+t3G0j55NrJ+Pz9dfvbv6tUL7xzIyrJW?=
 =?us-ascii?Q?NhlqaxQkl9eXycG1GfaMUpleAT45nLXG1ua6dyY+Ac1V4rcRz8qjecXNyzrT?=
 =?us-ascii?Q?WmfLQXkRAVgdOK7rnXWxQFKbD/iEkaVl3hgTd1nSblk5WKL57J4csfb0j53H?=
 =?us-ascii?Q?laUa7OlAnD5o+IMHSg2g4Hsw4Sog5NdwLG3ayiSGsOaot057mNSKNKyznHvT?=
 =?us-ascii?Q?M7WlMCLc4kXf0FQqoPNkTkGiWVm04LmgT7Q/0yS06nf4RSmcCcUyVjsiwaLF?=
 =?us-ascii?Q?dYR4mOzKBqQhmeyvlgBrdoA7n+GzKiziX9czgmdnmdk0NTlIFXQaVfBL88KQ?=
 =?us-ascii?Q?2UT5qOSJlJZO8KPUUCHkPtSknBHjU4BO9k7YrA79160YiJTCwVGCAwhqOoqK?=
 =?us-ascii?Q?QilKLc240oyOirtKNq+eH1UVE2sFV2HRXET7HI6W20in1G4KMPM5ATskSdIR?=
 =?us-ascii?Q?HHxpD4FwmhTJXHrX34kwyhwpsjosiLFN3bem53M0z9psEfrea2iMiYbp8IwF?=
 =?us-ascii?Q?YHcXELA4EdWzWJUmUOEjat50YxzYS82KbOcaOVWJH0WTc4G/IloHaqPwzbfk?=
 =?us-ascii?Q?9yDEb6PygfmiYsFiFX6ZJgeR7/blULwJyIla/2cubSypnQytQEqu6/lonXCs?=
 =?us-ascii?Q?3EbdEkCEzZ9ecf96AHRisgx3qh2xC9QeMU0i8b91cU3Wio7IDTH+m9ltfxM7?=
 =?us-ascii?Q?JWFAmte0y3BIsiBeg7q9k7zyWpTzwmnyR1M8blhlNC2/IlWxI6YA0st3Zw/j?=
 =?us-ascii?Q?LcqPX9Anz7gBYekbUMIYkRYy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05b17bb0-13cc-417f-5636-08d98da93657
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 17:53:35.1194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nfIyDlJVzO//v2HidNw4m//82qZir041XtrPXFYV4Z1/e3DH8PN8OQIECUvEhXK9jcrKNSxYAOVx/v8CEgPRsyrYnNrn8q7wYYjKWxXa4JI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4486
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120096
X-Proofpoint-ORIG-GUID: kdPW4jnHSzq2kNbMgqj06O3StGYN3BE9
X-Proofpoint-GUID: kdPW4jnHSzq2kNbMgqj06O3StGYN3BE9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Adrian,

> The SCSI error handler calls scsi_unjam_host() which can call the queue
> function ufshcd_queuecommand() indirectly. The error handler changes the
> state to UFSHCD_STATE_RESET while running, but error interrupts that
> happen while the error handler is running could change the state to
> UFSHCD_STATE_EH_SCHEDULED_NON_FATAL which would allow requests to go
> through ufshcd_queuecommand() even though the error handler is running.
> Block that hole by checking whether the error handler is in progress.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
