Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CDE0C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 05:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbiBHFck (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 00:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346999AbiBHEmb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2022 23:42:31 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5060C0401E5
        for <linux-scsi@vger.kernel.org>; Mon,  7 Feb 2022 20:42:30 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2184L2tb011038;
        Tue, 8 Feb 2022 04:40:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=rE6Zkuv/enx70T7ZxOJyVh0lyYoIpe+o6GOreHXfn/Y=;
 b=O1Z56/jvrNbnrEnOTbiK7w6WkM1g3Q3rQ5avI/PeltoLsPdRzLkpJHxTZJ1uWpsbnwky
 nv0IAuVhckPMiiIP4rog+2wODS8SVz1aANFrReg1EeqoL985i40qOuqkgleoRpPRNQ1S
 WytAIkr7D8tKfIuYMle4YyB/5Cs3pvoFoib72s4k/7UgQd6qHEQFsSXMWV079nN8DBAS
 L2zkA8VqIpFeHabV8NDk3ddhrn3FgIrfg7RoIwzCtNZhMNT8T3xP3T9+6UVsxpH/3I+7
 fUpHehkpyAWUDU3w7e33XLusdY5WHN70oCgEWHsgkcpLGK7m9haT4Nge9jU5sMzHJhWf 1w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3hdsr2p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 04:40:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2184ZVsI129611;
        Tue, 8 Feb 2022 04:40:16 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 3e1h25dymt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 04:40:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G9/Ei2Fn8RBf0NSzcO+4rVCeo5xYq4qr1JOBBuXmM8QocwNb/OF34FRcMVbomUkrtoPLv11+C8Emk62AnDB11m0yfEDhWYcecTzLzG1vTQuDCwS/FQPJwCsftqwahV135GUZY2Uy+ScY75CBHL4fkLY1cW4feRXTRbCT5DLJd7t0AxJDbDBQrgK1Dk6/h0P2kRh6gCoMh7FbkalMWOzok0ZkvQkjeCCEFqM9s/MNZw7Z8wcDhbKzfBcBDZTuqCO1PzBzYfOF9221z2mL5qEjUMimlulD30GPbsB58oXk1+CWizQIh/sj8nn3fvaC9CXOCYRMft/M+rZxHAMJAvNB6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rE6Zkuv/enx70T7ZxOJyVh0lyYoIpe+o6GOreHXfn/Y=;
 b=gfPOtuNB+bEPQ0++XJjP9CXhai1CwsfeHslGp4V4bRuI5jMX6EhB/zcqueaUiZHi8ESRza7DylrrZbocQOZduLgwd1tM1VUR3vRRSsT731rqhkxKaBfOi+gCnxvB28/qHUUVTO6bL9z7HipzoZ+FzGIaHGZlcU5u+caERiPXUfhu2UqXHizaLXvPzu/j2rQr0G9LonKvMONyT0G+fgFK/zAsX8dbD2yxC4PqxRtl98GB0dBr0TGpTwKojO5L6FHmVOjaoGsxBWq0WnsDwCqvwFiUVe64A5MBkCOPkiRRMgNOzipBk5+kVd8p0uPL3MS49ENOvgxHr+mvAsyDw5afqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rE6Zkuv/enx70T7ZxOJyVh0lyYoIpe+o6GOreHXfn/Y=;
 b=G631ji4/chj/u8mOoKovDzmeynWft1CAekxC9iSRKP2TaJ+NV24gepmIf5DChhRZpGxIpkOIIaFHWaVj2bQckFPpBYSzuEqAueVMOMksNUAXt+B4qkgOmihRteoGv+D6oFA/7TbLRosm/4OsHYA0URy2ljnqFiRC0hcF+Y2x7nA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN6PR10MB3437.namprd10.prod.outlook.com (2603:10b6:805:d0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Tue, 8 Feb
 2022 04:40:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2d45:d1bd:ebb9:48d1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2d45:d1bd:ebb9:48d1%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 04:40:14 +0000
To:     Don Brace <don.brace@microchip.com>
Cc:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 00/18] smartpqi updates
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r18evunm.fsf@ca-mkp.ca.oracle.com>
References: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
Date:   Mon, 07 Feb 2022 23:40:12 -0500
In-Reply-To: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
        (Don Brace's message of "Tue, 1 Feb 2022 15:47:47 -0600")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR08CA0017.namprd08.prod.outlook.com
 (2603:10b6:805:66::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5adf9b35-9c9e-48c6-ed93-08d9eabd1940
X-MS-TrafficTypeDiagnostic: SN6PR10MB3437:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB3437D40B0572B1AB60E017BE8E2D9@SN6PR10MB3437.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vu7nF8luBrLdizSaEuC43AAWit9TJcGugqQ6t8Myl6ayJ2CU3iPKiOmciaOwq9oyo0zSigfRYRJD3majL+EPSgXZGlASF9DhPPugo+AQVTnHteGnpHId7ZniC2LZoJx0B2eqFlxT4ssoZbYxRhaz8xHm7hKx8U64m9XmjDq87iF2Zxq88+ANmF+5pbcv3syIb2ZFk1mPUeQ6/n6VWhYhVs3jAu2np2voOYl1r/BzxvRvEB6Q65sMhJVrKWtXaJXsYh0A2Xr0KhQcHq2vB6OAwTAvEkL/cvZYy4DcjXpQh984P9RVjk0wQXCsG2tUlmdM4J9fpqYTJdLQy3tnEPkWWqUqBULP9Jex6vvdxqxtZkbX5KqaDYVlPGEf50ym29voU2UndDypBwc04DNyo3BLRaft/vf2lXf9Gq4jG9gtZHbsMnTgEMIOmc+fY29XbTHN6n7FKk6YKyA2fHkpGUnJmsnzivjqS2EJW8/+mFnaZnsGver+FZraDRoml8tZpPAXxihL4K7466pm1oVoTSyqeqgrbsNnnMXv4DK1ZgPKNMXwGNbNCFts2P+4IRtKKqdrF1zLtIb/a2Q2rT+rfO0XsoQ5hZxljgI4KdaZPgts9gYTkJLbUPncCcIj6hm/Ig+QbsW5wnhALWWeJh+jzCMqu+WHGp350zfxvcVgDx1bKJIN3JcijdqS7SCoSZIK0J+CMX3MLG6XVwLphqu9dKpFNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(86362001)(558084003)(54906003)(6916009)(7416002)(2906002)(66946007)(38350700002)(38100700002)(52116002)(36916002)(6506007)(8936002)(66476007)(6512007)(8676002)(4326008)(66556008)(6486002)(316002)(186003)(26005)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kfoUfL2Z92D4PW/KqpDh1mHqfOZsIhNArgpyD89gZqgjA5vlmMytzSgv3dpZ?=
 =?us-ascii?Q?d3HIJDyVy+Ex8wbXRZnddFg1xsBByUtHplF5Wa+uGYAigzHx2VrW2m8Pqggd?=
 =?us-ascii?Q?pY1VfeG0EnAfQ8wweuyNA9VzNHd/xwP4UA5WHoIoJoCyATsAepDWEkYpB/0W?=
 =?us-ascii?Q?Fw44mwn/tEV/KqdF+FdF5fXFnJbKpgXVdfT0mSI76bpVvoQh8WLo5qCVrad9?=
 =?us-ascii?Q?wrZumJ9yOZ23rNlA6h+4paVK6iGu/LZwqrVXvZ3DKRkkWmL3NM9dGXWZ5jYc?=
 =?us-ascii?Q?/74iyixSWP1OBjUb2Eu7R+1NEG7FGDkYwuE/cMjarTlWipYqoS2pJhMZHpO7?=
 =?us-ascii?Q?2hbEXFHVHTRnIXC12lrshptmXX0DIN7nq+3rMT0lP+bW3nBCak+a7hbH44CM?=
 =?us-ascii?Q?+4HG/aiZT9ENW4Xsm8sbW13NA1tXhff0EpEvfesIElMUz524vWnEPC32p7b7?=
 =?us-ascii?Q?y7pnvgiJ4M5ZUnx19dviBa8V3fhsWwhCrNToNUt/PyGOa95s7TLyOhVOco83?=
 =?us-ascii?Q?A+ZdDfmKX4Xy3OdaFLgqEBKyUK3aVjJiY/89DtYU4j71zU1Y5oX4tDw9Go0k?=
 =?us-ascii?Q?/UEyd8RLppmVuTwrA1KHFZjaZGXWDIoBcSkSj+S8Kuy67CR5PaXSFnSmVvB2?=
 =?us-ascii?Q?f+FcA0hial5iIuaq2J8kzYdGmL5dcsh//9GwfthBO2KfQPVeIA1SQ+TgD/y0?=
 =?us-ascii?Q?+dI+oOe9ue8Hj3HHHO603FKunJivQ17JxDJnRF1z7T/wtVYG+Nnz2j840WN3?=
 =?us-ascii?Q?oEp0NWGQq3XqG61zBmmzA/BV9i9VQG48qGnYwyORBzt3dyTELewhK/Tn1Q5V?=
 =?us-ascii?Q?fxwI48oVx7ryz5B1EIBLYYV0tzpr8sje27aiBo2LLOtuZG1yQiVVHsjR0sBC?=
 =?us-ascii?Q?H2iI/F7u0HdbfcUwYbBt5DQNv4RBuB9N64h9xPn7LS4pE+P0384x3WOGOCwU?=
 =?us-ascii?Q?kNncQuChW1GQ5JmkfyUOSFZ93QfRoOnn8myFAsCHOAeR+puDhVpkcFeS5vI7?=
 =?us-ascii?Q?lLJplZyicWmN4i+mCMS0HjZ69kSgJVFjipQ/oU5aOAeGI9Epz9MJ5AiaRrK1?=
 =?us-ascii?Q?tW4peLQqaJtRpdQDxkLN1t3eOgA9G/91VvpIW1PtgtfCAO2bCv55OTzbx3Ai?=
 =?us-ascii?Q?qhkIhgtwlRQHnkwzxotxXUFoJ9yvZL2ykZkrF8K1XPZLHT33IMJCEtRlVC8X?=
 =?us-ascii?Q?qFUIS9tyq46T+kS+A8oRLz0pCc2FmszocO1hpsbySXdxOkWmCjryBw3cUat6?=
 =?us-ascii?Q?m9IDSx6VCYeQOhJmns4M4rvvCiar6pKos7FphzNEgNRJH89Mmul3bsMRnipH?=
 =?us-ascii?Q?Do8nDEjO+uf6/osYRnkin1vFaS6VV2aHCDUA0e3NM7yu9X52FRgTzgyWbAfK?=
 =?us-ascii?Q?MJN7A/Hwud+tioBFnTCXqyO76BKlKz3v6mroSZs4YMTKf4hMq+OAZJM6/rtk?=
 =?us-ascii?Q?1/Ug30ut+zXs5pPCg8ROwU8I+nMRP9wMVXAofD0NC81zoyxBhPSyfocFtEDU?=
 =?us-ascii?Q?c1N/v8d46LChrVVAwdBh/D54LT/CfbY5PyciFyN4WXEjKVxc/AoI80CN5/CE?=
 =?us-ascii?Q?cRAKQFod72h/eJmMUqODZBb7MEDFu5g3ZqvamGull6RFfxS+ZKEBWrQxFUhH?=
 =?us-ascii?Q?3g8oFGSuhk6PnusFMi1wid3exSLsoJCtehFiv4PNsA2Thbx5rzyZ0cdumOJU?=
 =?us-ascii?Q?1qkiKg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5adf9b35-9c9e-48c6-ed93-08d9eabd1940
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 04:40:14.4277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eiujvboM9/m8m4LQKgG1B8czpnbp6lsE3JszNo96lsKamnknmv3drrHnfH6BYY4Wp127zeErGxWAZspfN8nP1n8R2UenR6QELv6wg+PNRJw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3437
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10251 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=811 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080023
X-Proofpoint-GUID: Wye9HyjPnQCn2KmhhqgP6_ht6A-1LlwA
X-Proofpoint-ORIG-GUID: Wye9HyjPnQCn2KmhhqgP6_ht6A-1LlwA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Don,

>  * Bump the driver version to 2.1.14-035

Applied to 5.18/scsi-staging, thanks!

Next time please run checkpatch!

-- 
Martin K. Petersen	Oracle Linux Engineering
