Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6252C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B8A2239D4
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732806AbhAOECK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 23:02:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46746 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731101AbhAOECJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 23:02:09 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F3sCpI030867;
        Fri, 15 Jan 2021 04:01:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=7IS50l/WK+fNRNEpBfMZ1D5u9tBT6kiDiXO0vkcfXSY=;
 b=YTsk+P7t1T4o/qWtQUBG2p6Haxax9cdCkF15ayPMOcMQaz7f1BESqFJROWQs0SU3U7pF
 1Lc9mZlEwg2eEIyoYY4/+nejERlaQHlaEpQDWO85aCWN7hCmEqaEQwCYmUaCF4F5LW9j
 rPkJqqAbwTexblf0vXXQrROBZxIYU/Wj87BwheLG3BvGgWgQGZg967acIGk8nXYrqhBo
 47qdPH76aKZTjzLDAF2w/sThcOmFe92LXFrKohT85PLhX/VEjiH+u72yGtkhwVBRCIsh
 2Lm6ZXfNdxON+muskspLpbY+rXbjpwYPbrXVbLwApq/Um2lj+QIEUwa2DUeyvry98IlI Ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 360kd037fa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:01:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F3svdo164929;
        Fri, 15 Jan 2021 04:01:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by userp3030.oracle.com with ESMTP id 360kepacgb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:01:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fSGGSFTj5J9nETSFPwsJGYAmc2GYCdbGYoyhg/AqQX0d1K/YpGbWG+bd1x3KdF543e1KDwIOsztMvzBfjMMQ7Zacyka65NlSc+csvbkQWfdT2XA21imsBwbCVrAcFTsILS7wYiPsa+MnLKAnh+J6IUUn7TLTk3tCld75vJHZij3+N4xBzcT6uglZwr4cKeZNCnnDf6ksBCNUWFQKux7FeMwJOwSdgwRyUbkyApMWjstw7Wjsp+ORiuihB0p3h3MsGM9rTuU/xQu3FR8gdNae/kep/4YW2CuFozEwdhXF+4BwbrGx20J193L4Zkq3ReJrNcAKoVjPN7WE2c4igaO4Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7IS50l/WK+fNRNEpBfMZ1D5u9tBT6kiDiXO0vkcfXSY=;
 b=aHoCWViySXbb6TZ0UlKaQ3J2zOj7thGcMtK3FPkxU36UnEhn57tdo1hIzeB8hdmmPH48uFo3L+ZVWgdzN0OpOlH9MhDdOp2BiT12GEDjSmAPWbYkuYUlZHzDsC5muW+u5mroDLRWRbMULvOvSpJuD1Bbcebm50aqlDd0BOHBv5cgH6payEHn3dJWgSl+GzJbIlE6kIfcp6mwAYbEsk7LVKZs6USniJEIiVaZwIxcbEx5iKI1hqZKotIyktmn3Gq6cEpmS6LC41oK1jeFiCroQykdPK9Ql0ARwCSHUZQMA3KyBbx/KQbs+j+3E8z9ZgSNi19OZ0iLkR2XoQO8QKdBAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7IS50l/WK+fNRNEpBfMZ1D5u9tBT6kiDiXO0vkcfXSY=;
 b=yRfSYuFUiUfytNkQQq5y+O87B3DMsv0R9TYKVoBkY4yqXlnDQRNs0VWKIvayBPEOGnAd0ub2pO66LFBv5otlXLrWuhtOPdIJgY3O7kLLwZEoRnvg9xzTXdEBDSa0SZktgQ27gHUgjfFHZV38QuEwOORd7xOmqAlW4ZkilIIQ5B0=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4712.namprd10.prod.outlook.com (2603:10b6:510:3f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Fri, 15 Jan
 2021 04:01:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 04:01:15 +0000
To:     Muneendra <muneendra.kumar@broadcom.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, hare@suse.de, jsmart2021@gmail.com,
        emilne@redhat.com, mkumar@redhat.com
Subject: Re: [PATCH v8 0/5] scsi: Support to handle Intermittent errors
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11remsvba.fsf@ca-mkp.ca.oracle.com>
References: <1609969748-17684-1-git-send-email-muneendra.kumar@broadcom.com>
Date:   Thu, 14 Jan 2021 23:01:12 -0500
In-Reply-To: <1609969748-17684-1-git-send-email-muneendra.kumar@broadcom.com>
        (Muneendra's message of "Thu, 7 Jan 2021 03:19:03 +0530")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR11CA0009.namprd11.prod.outlook.com
 (2603:10b6:806:6e::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR11CA0009.namprd11.prod.outlook.com (2603:10b6:806:6e::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20 via Frontend Transport; Fri, 15 Jan 2021 04:01:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 087d0dca-7c6c-4915-6204-08d8b90a3441
X-MS-TrafficTypeDiagnostic: PH0PR10MB4712:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4712D05C7D7CD5C1E552D4D98EA70@PH0PR10MB4712.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Ce+zorYFG4JR/SLE7fC0Vn+1oTwq0yEpPylSCgqtP5I2SCnTaU6kB+NHS40PoNV//9ANuQ6yLP0VA0t4J0KpKiQu9eFbwCQyCuUkVZTZK5RxeeR+A9LgunDDWc9K4Kne5U0ddzAkGLOaJ2rZPI2hPJdc0XgQDFM4LN7YDOY40veAnds8y15WifyqGsSy8Tu9nNCW+BY1dSz5JtwB24sVoEnOMmcJsw6lkM0RaYwM+5OGRuDs+fwunuItohugcwQWrKnFdt9VEesb6FOeXNPmA0kxS+k1gPwKVgPWawJp2llRHjUgsHbohQn++E3JM6fZ1jwWj3Dkc8oK83YRFS1MxdgOfB+reEhZ/Tm6fYKCgUpPDgwDmAzQEnVKsuOoCrE3AAN4BCBaw6W0ed+1Kt/Dw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39850400004)(376002)(136003)(396003)(55016002)(478600001)(5660300002)(16526019)(316002)(4326008)(2906002)(8936002)(6916009)(36916002)(66476007)(7696005)(26005)(66946007)(956004)(52116002)(66556008)(186003)(8676002)(558084003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ATkufv+9WAPDhGRlFpAmNGQOxnnz4h2/HAhyyMy/371dwIBJ2VIt1cJ5qc7S?=
 =?us-ascii?Q?6yda4DQwA/OeEUnijPHCJqZT1qhUEjOtSkqaFYLEGeYfF3ZU57sPtW7qjrJH?=
 =?us-ascii?Q?vdpMt0Epx7cNovX1EGaEdh2eUb3KuowKqNkKqaHfYfWPOmii4buZJ69Z+A6O?=
 =?us-ascii?Q?iNl042cggeZgLzKoXrk8Td6cJ0ca0En5yFAGU5Po6yl/pllwME0xL4uEhW/3?=
 =?us-ascii?Q?jBaixnaIseX3xNfrNwoPVTKzXo4fUqAZOMlmQkQ83Z+zs30CrZ5svhIMgZBI?=
 =?us-ascii?Q?SmCt5VoWTKEvTn2Z10gA4+iLjTBAVFf2lvFf4dqSiw2BzySRMokmSQgR4+Qb?=
 =?us-ascii?Q?S8i3N+IoWdd1oIAI4CZoUWKeqnbzM+tVoWExR3FRWAPSQ14CoCX7sOl1LQhI?=
 =?us-ascii?Q?efVws/GHWqdfbZb0LMW34dX6Lhr1yvA9PI79byGJSqIqIagG6ftr9yxH1h69?=
 =?us-ascii?Q?NpYUUTl+xW8l1QDm8Jk91RKGBVR3BVpa6cJSPmDlOnBeX5jRDakYZmEG9w9I?=
 =?us-ascii?Q?WafXfqrOOiArqMctkvZrfUdHYkFDhQajLoqiu0Zryl67+ATy0ifRDbezJ01v?=
 =?us-ascii?Q?79nUL2x+HS/kYmYyHUr2PB8xPg+7lInGXt5p3YwwFEhk7AQXobMiJD+xes/H?=
 =?us-ascii?Q?lTDC6MmOpAuZbVXu1apUBityB5AO0xPyKRlVW4xOO5cNbmT6ePYBMeetOiey?=
 =?us-ascii?Q?bG9SvEPayTu8GZseS3MHlHPVW1PfyRYdrFsFYoRSQKGgOyn3DiDnh1ycy3OT?=
 =?us-ascii?Q?/Z7SpxtZ+G0M9xJgkfLOyu54JPPenVDoFId+THkFJJseLZD4Xrj5jtbK5/i5?=
 =?us-ascii?Q?AjFSeHi3YaUb1QcWEWjf4Uk2qz10xBS8HjdHonUwXRvQhNQCcF6U+CMmM7qF?=
 =?us-ascii?Q?N2jaKQy6/ULf53cLqmx8ChuPWNXSSw26IGNoSLXCt2zwmjL95GMCrbVARoOI?=
 =?us-ascii?Q?b3Eq06q7pZAcgw9J0KpdOwhky44D1sJxhXrSw90lLpE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 087d0dca-7c6c-4915-6204-08d8b90a3441
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 04:01:15.2836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6xvtTn6COo08HtByK/UXYmKjFsqKJYYdTKLXi4Cwg3reFZLLpvVYy3ZDybYhr2gl0aqEwEEFbXLDum9XUC29lFgkKcDeriX+vdN+eGu2u4A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4712
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=904 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Muneendra,

> This patch adds a support to prevent retries of all the io's after an
> abort succeeds on a particular device when transport connectivity to
> the device is encountering intermittent errors.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
