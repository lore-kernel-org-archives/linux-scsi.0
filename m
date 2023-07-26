Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A0BDEB64DD
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 01:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjGZBfO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 21:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjGZBfN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 21:35:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7F82699
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 18:35:10 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PJIsvT025954;
        Wed, 26 Jul 2023 01:35:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=/3LlhTa54g04S8PjL2k2zg5YXWmtLn0vcdNdDPIIm+Q=;
 b=X/kYnsk2d5zyZCxFBM3MzESveLfSpkUSDz0BSV+0q7SG2MqBe+3webGvB8E7VLkZw87i
 fbIbTGAORKywffZzoRMKRzHpvntCNuUQmSfoXcIt/xDshvvF3MZ9zIZAxvF52syMdmOg
 GZtBGPzR4xls9ckQeh8qqIr1Z2FFlg8YPqIpvWo3sjSMtlx0mhr+55EyC3j1ju4FDhl4
 Ty6unLWHH35ZAesAl+OovE2vv/Yupr0X3iDcGC6KSOzr51cuI+aqfsNNqwrpEX1rKcWn
 9zRAQMWgg1wc9Qagb7s+eQwk2dUm3qZ0tsTJlqf7bYnAzQLpbqBZDHdwTN8smvkPgbtq 4g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s075d6f2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 01:35:03 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36Q0QEQ5029437;
        Wed, 26 Jul 2023 01:35:03 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j5j668-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 01:35:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R2UaJLBSmq2OzA+J0lZfHltKfblIQno+kUQWVDJD+7KvViwwf5nuu4NzP29qMucIaEvu1hzBzNYM2E4joWtlr4yPIbKoWLZv6Ya3+QytPgrSuMR/GqUh/4AEPZiiqcnq8FNxk/ZZh3ssSUqVZ3qTDA24gBGyBVkL9+6NUJVSL1fsgS2DT3XH65jZsZHKmKDwdZ6BXrUqe4HIz5n0FEEJeVQxG1w7fY3v7t06Rnup3ATo8L1VNhjTtuwgItwCiHAKD1YP5+j+dpzNyvGf8ZMefs1lB5j8v6nyhY3tR+oa+EK9l2nMoOic6YGLvORhnPWDASD7XgXY3sB0+cl6GfZtRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/3LlhTa54g04S8PjL2k2zg5YXWmtLn0vcdNdDPIIm+Q=;
 b=SQU20xaXdWWOArZqNTgav3xa+4lITMGBnTzMWvfpC6KsEC+0ls/SL5P5wDhUrlH3QApt2iDJJXU8Hk+iIPcM7eEwRKvOGWH+kGZuxhT5kSaCMdg+pHwvg+XrieXWtah2cVb3SfCZaeZWS64b4FxjzurEidUMNgsRw0yQLxp8DzYrzJuQGHUQpkvlQPs7dOmYHglQyIeDz5uvjpsa3IoYy8bCvPPk+XD84OoVuoEJk+NVYWXp/HY3k1pB2Td3/OhbsaRciG9YV0LEhlmpKdPk16dgPCqb2bknH1q5ZfIp+251G8jyzrKNVaB7oaYvmPqfAZHljsI1yl9r0HFkVAthqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/3LlhTa54g04S8PjL2k2zg5YXWmtLn0vcdNdDPIIm+Q=;
 b=xi3p/Q1toinvkwJm4LadfM7qPavkBxTf758x0SYDbVDXl7enku9e4Qks8qMGxy62nwnUHriNgJWvuhrnzTtcO15KgrwtHcBYzcZ9q4FWnwo6Ic9zmi55dHTEKMA6Xw2C03I1hjw1b22hpAqkvp2OCK+24ecIOBjZii2oRMwzFyw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB5135.namprd10.prod.outlook.com (2603:10b6:5:38e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.35; Wed, 26 Jul
 2023 01:35:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2dff:95b6:e767:d012]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2dff:95b6:e767:d012%4]) with mapi id 15.20.6631.026; Wed, 26 Jul 2023
 01:35:00 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v2 0/2] Fix residual handling in two SCSI LLDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1edkvzc91.fsf@ca-mkp.ca.oracle.com>
References: <20230724200843.3376570-1-bvanassche@acm.org>
Date:   Tue, 25 Jul 2023 21:34:58 -0400
In-Reply-To: <20230724200843.3376570-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Mon, 24 Jul 2023 13:08:28 -0700")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0273.namprd03.prod.outlook.com
 (2603:10b6:5:3ad::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB5135:EE_
X-MS-Office365-Filtering-Correlation-Id: f4a38d75-ab62-4af8-fc77-08db8d78871a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vPKk4T0rnsOzlg/msFRShEDfhn3eY7n4O21HjoaSpKJ/Uq6SxNW0OXS4ouF8UYkvHKpE7NQi5CHt3bAL8K1N8GMgR5969R3x4fveLIoK3Ne56ZmpCSwz/PoNGNYEI9CJKTUEyTOO9c6bRujLwFQutmHZHMT+LlJd6ol4agO5A04i8ZNMOqlmQl2VCymYEVngenMeUyAWBK7TU6+7HhWRIDj6pz8Ek1mEgYKosf9n2JVWRMWIEpBamXtkdpaF/xZTCQrZupLWCHNUQPaI1SfYlOID/eOtUD5YvwuYr34GpV+kkSKVhSNbI2pDmK0yBakQOCnvadfauIr4n5uWQKurq4CBSyyWw30Al6EFZ+Ze8lpuchpz1rOgM/EPYq80hhIyeXFPRep2wTeiQUY/pABmka9cgCbrh6fJECdiQUNT1vfmb1RapF00NOQhkXGSgH7wrphtsPEJ4VZfv9LTiceYUnCwdV9/7btuStkzt4dYH+S/b8FGzZ1nqlXlb21S5SpNovKTFq9AlZVdXe4mDuEGwkexknSer2C3hb8phkcgf9I9HQHYTcYyZuRhJNtiRcLG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(366004)(396003)(136003)(376002)(451199021)(8936002)(8676002)(5660300002)(41300700001)(316002)(6916009)(4326008)(2906002)(54906003)(66946007)(66556008)(66476007)(478600001)(6486002)(36916002)(6512007)(26005)(6506007)(186003)(558084003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XcSixyYc1DaBmNS8wBwz34Vz1yw5Ho4ccInUf772bmvHdxYS1b0Dn2yN/J0M?=
 =?us-ascii?Q?/R25o+INh9xygLTPeqRr63wbtVH3nxikAiIysSHAUrI8aTCEHsLFR4ALiE8Y?=
 =?us-ascii?Q?gx+VpZKMmec2Idae9abAu8y7B0/9POJJQzKpCunspO2ue41zclLms0w8S19I?=
 =?us-ascii?Q?843SkFM+fLU/4n7SbeoVI6krNrNLCZ1/8l3b9F67t8ZzAmX/x9wvCP5bzpYd?=
 =?us-ascii?Q?GouGtSufvujpLcZeBTveh9mGjFEZAWIzkY7SyJV10pGQkfHHENSOyjWz4Jmj?=
 =?us-ascii?Q?pUIcGcotoCnQVbxyXAT6XJQ/uElZ/VK+DdsImcca+G0wg70BYWTwPZK1A1R4?=
 =?us-ascii?Q?Mp6XE+59U9Nvswthv7mZ31jYtRDLFHGNFQ2cyxSvHcMqozn77faFw0Uuvwcy?=
 =?us-ascii?Q?4TFssgSkVLQ55cEl/nosvlElCr5tyMUiSqsvjqHAZwcHDGPvEfiTYrYdlvXK?=
 =?us-ascii?Q?L6fzFLH2wrm1N76hb6KC7Ri2zCubeTbkHP3ZvB/R+FXexZwKSaqmrOppihDD?=
 =?us-ascii?Q?HCSWGIus5PkehNVEYMEE1NaevHZHZvmknd1ReParN0HBUGjRNy/0ng9HwmKn?=
 =?us-ascii?Q?ZGYiQ6gQI8ABihqDUO+oqLGrWioFHnMrxETiPylNTve1LpKXnw6BnW1TnxQg?=
 =?us-ascii?Q?xcbEBXccWDUKTmwlLdKH3EIZyNGR1LIV8I+OD4mht+uNVArk1/i5zp9cBeMd?=
 =?us-ascii?Q?7TBQmhOLBIRjTo/CEBV11YNhAxZF+aYVryluzKjPnFgnqkxJnxjH+NAD30PN?=
 =?us-ascii?Q?M7u8LIvBv5MHG12WFY3jREIsTPH75nNk/1hudLD+Mg2T/GJ+KFp3F5fz/RJs?=
 =?us-ascii?Q?IkEJlC2Q4XuHNdEkCAwXhMjJMzFnPnPGn3+GbIgxI5EkhEcRoLkW+PWlEEtH?=
 =?us-ascii?Q?t5ntO3ivuLGtGdxGY/o2RDkIjh8hZYmKS68TDaK3MRF8mN3+aWc3DTnHvioh?=
 =?us-ascii?Q?kzOSj5Ucfw5LOMkvWO8G0pXXHgCeuoiphEVF0vVuIkIJPRg/FkbQDVsffhtg?=
 =?us-ascii?Q?nWas7RO776/yhhL+uReU+sBdAkna76VrH/mrDGUVCzTnZN65E0wkclDSfRa6?=
 =?us-ascii?Q?XcIob2MkA5waYvJdcq7EYLQ8fdy3efs4CJPCvKWWfK6RUqdy1iCrpETigl43?=
 =?us-ascii?Q?8jMge7qvqJPTN0/7rlX2T2afqsiOEqH8inezGsrlzFHWhpXko0NjLGLnXjZQ?=
 =?us-ascii?Q?Jo3CsQsevdMxspn0sZwrniWw4dbZGn0oxyO8Z0kKYiENG7l15fsOd0jO4Q3t?=
 =?us-ascii?Q?9oFuDqjvtoiUWVxXfc2bUlsLornlvpzwbVbcFqa2JiW32FHOWp9wQq5xB+Tc?=
 =?us-ascii?Q?hOlWTRRXG3AXr4HLYspRjA03gUpGwHuz2BfAoyJ7U8amadG+J/hMg8Yj3iZW?=
 =?us-ascii?Q?uF3357Y0QD5vvOATJ8kvOM5xpavdAqkX/f9ozLa1HvphHGQJvAqGFCdOsIV/?=
 =?us-ascii?Q?a1QLYiJOAFDJoeooTcubb/N9WXLnoL9i978jn0+fV9V/YOWLXfjrgLPkKiSY?=
 =?us-ascii?Q?PlxnOjzxaVFhCx7zRqn6iqAoDC6DxXQ6RhcOBiiqUkYYaDXaSNC+LUCyr+5j?=
 =?us-ascii?Q?B60luDCxPPNtXbTTt2ygeVAiE67VzaoQKtMSmWfla9sF6X9Wi1QawDfB6ULP?=
 =?us-ascii?Q?Zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Nj+gxUkpxhx6qPTslQgVzB63Y8sYQy/+RPPt6KaYuuYstnXGIzx4DFnAr5sn3sQ6fw05URjwdw952DMjyLGPza1nR9/HVQfE+UNy884KuHM2YDMGfI7mtwCcV2U9X7ySU9GbHs9dDi+YBhyGOw9ym9KZWQRcHefYbk6GCxvMZEjdHtwIDmVfb5xjZ5EVqpqpsg3AvAaSKV1S9xuaucY4BBZKhkoInnwuJu7udPV0G+RPBI+CXOrxFJmusyCy0ddJlNjCHZR0v1G+N1ZpvA++hnOb0TxxaRWLf+IEZSp7RlbbQUk4eKNONN+iRTpYHwhLOSOdsuDE9sgnRpJw5p0ZPDiJNsLn+NnxGRvR9QxygXEWaPQyB0BJv9S9eCBpUmvcXCDriFaIwCXbRYJX76traoDJYVXRAT0Xe2gNRXW9ChVSG7HkRzvSUSNlXcC8jshVj6NjOgLRBy90TmCjdfJASf53vKLgpuf23hiJ2lDpUZy74w0UgHuuBX11EYNEtZf8gl3wXF6a8Ufgqs+cFqd9gy5rhoQCgdTgc4NZhk+hVpnYWWklPyInTivWdNSQODEZOSU5v54tV7iVS8txs7F3g0aKZwlcQ10p4Qsk/4Di2OGaAH2g2IONflQajfglJnG2/l/8/bMIWyXchkkCNgX6AkcFrXwi5I79hqEiM77htcqkTuzG1F7z7J75etX7+ybwgfwzlzH3PRWaoomvrLgGBlDGlK4EO8Dqaqa6cXzXPTL4SUL/fagLQ7wTvilyN0+nhGy43r+IayJb+yVPMp/v/hlciuV6gaWcZUzRH8/0Njsk4PfUHUQFyUk8DAqdBfe2ztbjl6tJIZCvaajjlKq/0w==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4a38d75-ab62-4af8-fc77-08db8d78871a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2023 01:35:00.7461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +nfOfUxSj9eZ1jSK7c740JD6M+32zv8XDBz6sD7DSggXzMGx3u+ZGG1Aai7N6jtxhl1kMD5TFZ9Dp5Ucg4y70DUBiI4eK9Qzgs7/8wvvtYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5135
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_14,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxlogscore=558 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307260013
X-Proofpoint-ORIG-GUID: jp2nhlCJ5hF1P72jX9DR9xo2kL17uono
X-Proofpoint-GUID: jp2nhlCJ5hF1P72jX9DR9xo2kL17uono
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This patch series fixes the documentation of scsi_set_resid() and also
> fixes residual handling in two SCSI LLDs. Please consider this patch
> series for the next merge window.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
