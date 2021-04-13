Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FCC8C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 03:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 413BA61222
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 03:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241785AbhDMDNC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 23:13:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38090 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237629AbhDMDNC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Apr 2021 23:13:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D3AVbr047834;
        Tue, 13 Apr 2021 03:12:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=sFvj77NQEHMHoVav+rGRKjx7ZM+mWlHN0sjW80DV8O8=;
 b=KCR3gvXpzyZnG+kUYm+H5+c14fFJlkZnCMlQQjtQJmtax0KfrrfhOt0x5TKE+fFJ9Er7
 flRmFZaEk7EAaOYLk18mOQGPYAXLUZmdlTYLQahJcbYe9kl4STCtR3yxgd0AXIqSoTx9
 bCly6EvCNQLJk8FKtxnATcHR2izKMImXapDscwphh6M18vbiVmxUlVK77KFgxmzu6/qr
 6YpiQSqVri70URh//VxOV5CYfKZ3//uRGLsGJwrjAcXcR1T9TWgdxRu4ymxWYSdLoGMM
 6bgPBagi32EcLl4PTzAVAnctTcIJhSFRem03upKqRHng9IY+QcN/EIDlq4byzgAzqkR5 Yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37u3erdnh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 03:12:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D3BRPh085762;
        Tue, 13 Apr 2021 03:12:34 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2053.outbound.protection.outlook.com [104.47.44.53])
        by userp3020.oracle.com with ESMTP id 37unsru19e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 03:12:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PhFpSqJG/yqqKpXIMq3YVMHH6JBhIo/llTNgFSgMe0CIqOb487qnvMGibBOVjNQ+pz2gEUolPQuotAylG7he6UwCRgNvwxQppwOce98B1LjlDfkRg0hKPU0xLzLk2m9BOIh1LbCqx6HKhHS1MB2OJeavI1bbPSIslbhV9rbLmuOsYQ6ZagYee9HdTRSgSQu/swyu02O7GktdjTS5VXlqK7e07SZE1Zvppdi1lMbVMVgwgfP/E/3xPUxDyAK/bl3vs7nHFz6s2Yqjsr1pJ3d6uw7DibDIYLfQgnewCSA2w5c5J4d5N5XPYqMKgLZxilNOX9i+I9lOvXIwFjpdPYXPow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFvj77NQEHMHoVav+rGRKjx7ZM+mWlHN0sjW80DV8O8=;
 b=SxmNChQlpHF9WFy0VytxttJdrm4wLq2cyhxNXppd7GU/JyxOaYVBSZHaSVjOFRwzLVKkHatsgqBeb5BF+pJmE0ihTDDXlACUJq/0sWBKhI58m8+AdXnQNZawuYwTz8M7Q8/j1v/d5URLdMpLVFmrYVyBJJedRsEStbU7SfiLpaEnfLB4vKaway21/SdUTfndLAmyQmtfIo0ZUJElhJfD2MmTiWWgBGc3NX4o2Mpw93W5LYjjSL4PddTeypUA/uOVw9yx1krGgLIpsl2qoKA2zlNTn4HRklu0i82/d+S7tfQtHucLeDMYQ2aVVfEmhjY/pH8YoIz3p01+d/M+EDrIMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFvj77NQEHMHoVav+rGRKjx7ZM+mWlHN0sjW80DV8O8=;
 b=nikjMFNVc7AERx/ENiUK9JtGPSx8Wy8Pj+vqgUT/qhJNBs2D3dYyPmB2ifZQmLbONvEZtxnxOAxxb39BYpVJF7WardiYhsOI45fIdCaPLjMpjF+UQCvKAiKoa1dh6PDdEaqOsJbDKO8DTMdV831A6nBYfw98oXPuisR637SB1lQ=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4454.namprd10.prod.outlook.com (2603:10b6:510:3a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 03:12:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 03:12:32 +0000
To:     John Garry <john.garry@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.orgc>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH 0/6] hisi_sas: Some misc patches
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eefe98tl.fsf@ca-mkp.ca.oracle.com>
References: <1617709711-195853-1-git-send-email-john.garry@huawei.com>
Date:   Mon, 12 Apr 2021 23:12:29 -0400
In-Reply-To: <1617709711-195853-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Tue, 6 Apr 2021 19:48:25 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:806:20::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR03CA0022.namprd03.prod.outlook.com (2603:10b6:806:20::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 03:12:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7b095e1-b3c1-4e0d-18f3-08d8fe29fa8b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4454:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4454A4E845D89F5904830FEC8E4F9@PH0PR10MB4454.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qdf5pEpDMpgHCdOhx3Y2rdwqW94bAZxP4pPk9936GfRiVzkXvvHECLMGgsSeh5UU3F9XBf/m2MVYHY2V7E0U2lP8yItyW+ajzGt9X1KiS2IR+UvN/FvmsbNWSSS62FDGodxZ/9GPynLpnVRF5+XflWzpiZ5HuI051Dhq8B4cScbflLtkL60UfIn91VVcfOeY7TgZQtzUCOTVvDQ260HJigTolXIOqnphTwsbgs9uPlb9sQc1wSfOFXmc0gnFGRuUUpajfWo25KO1AHQ2wDjIm07SrH/tEA9VFTHOXlSm8+wJNuwH+7k44D03sT/3kSQ1givUz/EAnauF6I4qLq41ZZBFB4nyj/rfWmjTM5ZTF6viFG38TmAbEOmmMB7hhiP5V7rDv4RMM8mI5XntFt7FEPMD4qJETePFnDnnP+zW8XDlqYYEsGi2PPbBawPhNXw0HSDSDz+HhwHTiTAaYn8HJr7ZpAHGH/+rt3BraDUF3gnnf8X2yNeM5TxXzo+dYNRrldWU/fx3g7s5/P2xeUOI9JD63iNZuk0BJaBxlHfNfvjpuQUan8xiOrRnXyg+wDrN6LzhNg0degQwlC2po5DpSRmVtPUsRGMCeHEmoJ08lRUYfKmGJPCAfRfMZcD/AosxrQFKqq5yzEnwq4ubCJqRpZPFhWjjvbex953l0xs61bE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(396003)(366004)(39860400002)(186003)(26005)(66946007)(52116002)(36916002)(8676002)(16526019)(7696005)(956004)(6916009)(54906003)(316002)(66556008)(66476007)(4326008)(4744005)(478600001)(86362001)(38350700002)(8936002)(38100700002)(55016002)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5bnW154q0+5hveCb/oVMlXdDqch78tVeJSTk7eeioEhowgWTmcrOu4BOAKAw?=
 =?us-ascii?Q?yySZqIpL/22INVSW+5FL6JNy3nJU3mQmiSsQgPhs/vji8H2dEcSOLDfFB8/f?=
 =?us-ascii?Q?pgie+jvJCFaQ0KLc4V7ikElCsRngvbGL4Rk4bioOcYRk0g+3ka/7ZDeh4wK6?=
 =?us-ascii?Q?jgT0gsUdrlmbr5pZk/pKBupTjRaHnlg3HM+hVkIXikxv4jmBcfSBljQNFt7h?=
 =?us-ascii?Q?eo01C+84LAbyhzb/FGk+coVR5dbklddLv+6esR7y2fSRQ6RgBftR3Bpx+s5O?=
 =?us-ascii?Q?2IXeYru9Omr1eyOGESgBlvMmsZbucuFfN3Fh2Z6iQGkgDNzFJAfDOortDxlx?=
 =?us-ascii?Q?xa4T3plBl1iFq9Pp4QsEkodJth15o857NGKxjnGHxD5hHN4ooMimXfoGn59Y?=
 =?us-ascii?Q?6NuUJKHDqcwpHchlLqmYNz1t/TJ5tj0U75hHjDzpVEusXpPtZkF9QTupWLvK?=
 =?us-ascii?Q?o2oul2KqHR2HZW9b77L9SDzx99MGJNkodpeEtyu+6/HRNH51mUhcVYy/SR9k?=
 =?us-ascii?Q?rLAZU3GEBNFmeMwhYE5gy3r4zpWLbbbJYTrKZSCdrVUT72Kevg0VAuWcqfZU?=
 =?us-ascii?Q?ByfF1OV7mwTMNQpJwfC3rlgMamuCuNaR94bi6YDrdX902vWs/5IFLvENylvM?=
 =?us-ascii?Q?REo3VIRERetf1AGstg2vtxNbC3+kvSeZ4IHiJE+tho9LbN9bbAh8PrtBX0rt?=
 =?us-ascii?Q?hiVSHyPypPFKfbv3uIif7VQ5tk0TRmntDLmqOJ5D7KEUq3s16AABabYpvXJo?=
 =?us-ascii?Q?YDAhjeVx6e5v/dRBxaeBIrPHc2u3WSiaJP0Mkuxl0m9o/ijOkV9+Myw08mFj?=
 =?us-ascii?Q?kjzI/6HvigBz64x0Xeb0AvdMjM9UGjZDq39/qxvIutqNk2UhTr5wJiMBfihI?=
 =?us-ascii?Q?sIIimrl7cnNbLqIILr1eGcsxN050W3RmR2MIG4Jzbg5QalVqwyEDRALCU4vr?=
 =?us-ascii?Q?6UXz0kgyr39NCNU1YwswM3reToi1kSR1lXcm1KXWZKt1ltwyDYgNoWE+Lv6p?=
 =?us-ascii?Q?eOulnBN14hYej3hOOu+5SFeqmdDu2gaVUtGBAiXHJfnKqiwfn07IayY62Ocl?=
 =?us-ascii?Q?0BdEFDLvOZhYTMlqQG49/KBJ9aBtJIwHIkMiEk41ZxctHP9taOa9/ynO4QBc?=
 =?us-ascii?Q?WQNH5HVm6hTSi0eDXt8okjq4SRPxQCNa6aJpMaVauS2i+a2SBliSt5vDSr1u?=
 =?us-ascii?Q?FdHhhZxQOthCUyPTHgv0O4e3m3MKKNIQ7RrFQkAS+3skzdXtqJgNmeYYzeia?=
 =?us-ascii?Q?iC3woSzqRV61bdnHiI7Y6T//JqD/RFtVt1Iz0kF+AmqAxNtsAthqoeWRF61O?=
 =?us-ascii?Q?xEqUAYjg1fGPgIeq2mWpZz+4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7b095e1-b3c1-4e0d-18f3-08d8fe29fa8b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 03:12:32.5032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HDES297bBDQuW55v2mNL336z/wodKbwlFwG3KeC33Wr9yOEbg+WhDqjOEnYVJJWReCtDiqH0CLJtdL9rbUJ8hOVZtiB7i2jAQFegqkiMcHU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4454
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130021
X-Proofpoint-ORIG-GUID: glxWaXSY-6ZKj8swZGvx4OTFx5Cau4RS
X-Proofpoint-GUID: glxWaXSY-6ZKj8swZGvx4OTFx5Cau4RS
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1011
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> This series contains some more minor patches for the driver, including:
> - Improve debugfs code to snapshot registers prior to reset
> - Fix probe error path
> - Remove unused code
> - Print SAS address in some error logs to assist debugging

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
