Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CCD1C433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA30623132
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbhAMFe2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 00:34:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55724 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbhAMFe1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 00:34:27 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5OsqI051900;
        Wed, 13 Jan 2021 05:33:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=T/7eyT2O7+V0ZgpWgrlnfwfPsCaSBJHCBoEYPciyvVA=;
 b=urtxHhjnfk4smRPeBXzzguRXIAR2FNYr/PSGEWgKcUAfUbfAPfoQqYl4osRyTZtQHqxM
 HILfVvvAWY5cX+UB8FCTrmrdtPCuycJx3IW3k4eVB1zwnTJQUGmYoqwhnJo5y7K7Tk4V
 hqu38bRj2uJt9eY1smOwJ90eP2qzE2lPZszIbGrX6q21HUexIsCQjK7B9oqrRXOWAOBc
 8mlg81J3sdP2I7fN8SwZJmaEMCMXIdQQxKArRmOhNXg6/nFevZ3PXAoeGywC5/RJsZ3q
 j9z2g6e6grscpA21IuNkx+0zedpCcUdo+4/EYYm6OQldcYI3g2noNyEK7JwPMlxhNQYg TA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 360kcysmw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:33:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5Q6Du102952;
        Wed, 13 Jan 2021 05:31:28 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3030.oracle.com with ESMTP id 360kf0024j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:31:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gpuZR9Ig2v7YMSyLIbkuhvbcPbWyvLwY47tfg3/L3wzKRyZoO1S8p1DS4te0oCutuDiUVPUO98wVh4I3rv9omNIhZFIFjspMNPldWrMkO61Ya/bLqysa4S+HPcmQyaCgX7m6HRNOMjL/c7uTOAt7F04QeHjLxIZ3GvTJLZjkMkZUl2yQorR6iiGbrlad3Sb9kZCSLfjq/JxZD4IK75C1Bc29MaZZeJ8EOevKul0LgF5ORTOSS/A4xImfyDBawFArMwXH4lxsijT5ueaVGxSvZ2YD2hYIuLoBzV5ZnCrALh0y42Amt/OpMwBeWldWcpqXABOVx5ntzE8y0qLJCZ16DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T/7eyT2O7+V0ZgpWgrlnfwfPsCaSBJHCBoEYPciyvVA=;
 b=MKkhxVfbyw8kkUTG9aoPLu9XkRy2v8ImDqjW9Z3TRMpzJbP/ecjlv8Vr2Fp8AJtPprdr9shOdn8cmweJ50EPAJ8PadGLRldEj0LKvNgECciAYYAMOIQYsr2kNnZhkg5v34NEZzKVgCFEKA8XBvKykogAKD37N39o4s/crik6f2agWpBbri+xQCQPvfRCmH6mviubVWvk1UTAij9Yjq0ATDzln5nwCe0ZA1rfHwd8/JWnfROhMKFqGyZHta+3kibOuIxs2i0u+MwThu/KpdRBvMYpovmo5Oz5IKYf+VzWyURmEo+mzzVya3c9d8Ieh5vvwkLa2DLGAnDOdgqc7q3uPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T/7eyT2O7+V0ZgpWgrlnfwfPsCaSBJHCBoEYPciyvVA=;
 b=qaE2mFx3uVqjmWN0cQ/KPNtYZGsY3Bx9RapYKav1vfW58IOLM+/ZW1CfRlT8IHOuI1zZxkDlHVOaIUW0w+h9monetUDVNxxK+erPgTvT+8ak0BOIIE0dzIjAXS3ZCf0+xh6ZHFoFr5eLKAwZbm6REZO1JcNfYYhHR3BNn9nvhqc=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4694.namprd10.prod.outlook.com (2603:10b6:510:3e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Wed, 13 Jan
 2021 05:31:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.009; Wed, 13 Jan 2021
 05:31:26 +0000
To:     John Garry <john.garry@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        "Artur Paszkiewicz" <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH] MAINTAINERS: Remove intel-linux-scu@intel.com for INTEL
 C600 SAS DRIVER
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8ht2yjf.fsf@ca-mkp.ca.oracle.com>
References: <1610449890-198089-1-git-send-email-john.garry@huawei.com>
Date:   Wed, 13 Jan 2021 00:31:23 -0500
In-Reply-To: <1610449890-198089-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Tue, 12 Jan 2021 19:11:30 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0501CA0143.namprd05.prod.outlook.com
 (2603:10b6:803:2c::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0501CA0143.namprd05.prod.outlook.com (2603:10b6:803:2c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.4 via Frontend Transport; Wed, 13 Jan 2021 05:31:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f325a8c6-f46b-4e3f-ee27-08d8b78478b2
X-MS-TrafficTypeDiagnostic: PH0PR10MB4694:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4694A842F6E5529DAF626AEE8EA90@PH0PR10MB4694.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P9S5MfJgNeW9noczDeAWD348vYZvXwIy8GCVzFErd82DarAxB2rt/st+GvOLHtAV36tcRcEwjwaDmgK0yeD8JtwEKbG2hYA5QHqkn6AiiNsACoI8u2ivlUjZxb36VWxEaBJCoStIFVmsetW9rx2Hw18Ez0XNVUyP2GMNBItARnLViPBqFnHAl67Ctd4GLq4M57cCJLVpVx6R6z5enXaHVzbATRnuilteO2F5eVy8UAK5jdQu7ozi1GQLvGbIDEc1+7EtA8m8qyuTMNgAcE7ePUIPnkwMC/1ihR1adG3uZlT5dQWqyyO0h4+AE3Es8MAgE4XNnPfUKqKS+7dxelsSqBwPmtJVwLpiQx2QHIQoO32tEd+QHMxNhFyV4HnL8TSPXSJH4W9LGj+CjeI3bgu96A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(376002)(396003)(39850400004)(55016002)(66556008)(54906003)(66476007)(316002)(66946007)(186003)(8676002)(16526019)(4326008)(86362001)(956004)(5660300002)(7696005)(6916009)(52116002)(8936002)(2906002)(36916002)(478600001)(26005)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sM3WsBJmzzMyeEhFB4V4XcuZm0+XwJ3/OlOAFmdh5kgOlrAS6fgGbCDyukAm?=
 =?us-ascii?Q?MWUog1JpALWTif2kOfXzj7Q6vDoQjPQJb9m8JGzENQ2T64PqP+JW3UN8j6y1?=
 =?us-ascii?Q?KzNZGa7ArGL91QCgWrjbuhg7UMOREfrY+fzNCjKIApAeYWS0Pou7mi+wubG5?=
 =?us-ascii?Q?qXuqqqjIeIoc5jXqDJO78HCx71w1LJOwSDTeoe73zanz/6gQinC0EtjvJcVf?=
 =?us-ascii?Q?yqIWPIM3uw1K8fPZleCGomM0ldqVqyNubR2IXqrOINsO5fOkfJfZI0mv1U6K?=
 =?us-ascii?Q?qPGH5IDCDfqPE16LjnBq3wz6eoOpdBRakrhMsylQkjBxS7SnE8rtEGQRKxrS?=
 =?us-ascii?Q?lWZuLi5muKqOm3FQNNEkiR75lntBtipVchl5MU9adaoZ0/Tqgn+Ctkm4kBJK?=
 =?us-ascii?Q?QEA5yXfbZandRLQ7MgA7h97z+X36Pj6rtnYTr4+vcjkP0AXubWfTCABA/Y0m?=
 =?us-ascii?Q?ky+Uc9A9oU2NPvC2OnMzjGkPBMHBZa+R7+Od0MhSr7bvv3Ugx9qzW6lwtuh8?=
 =?us-ascii?Q?tzvaDWjg+HqnRr9yd2ueugTmqA5KUSki75TlAqvr7h2Xo5UnjBKSGH+GSxL3?=
 =?us-ascii?Q?u+IX+LX9IgaUO/ai7ktpIvcNFOXMysW52JVI5ncchX1pZUAnia1VhiogGNTM?=
 =?us-ascii?Q?TYrSi9iCWVIJ5+qaoII45QRIQCvUyCUA6yTlGcZWfqDYGXBUYNF7WE/8sIuF?=
 =?us-ascii?Q?Ft0blFRCbxGb1Envsgl40/fqVMtsn8z7OV+fDjDRJ2h2RCsCk3EIYzU5NBHV?=
 =?us-ascii?Q?eLO+kdmx36lFYLuCaQz2WGTNGyPnC+TiWG/Jigd03eIwrZdLJJaS7KN7HIjk?=
 =?us-ascii?Q?4czD7VrXLlFPBMZMgAjfhct6A49uuvLq9kOEQp3eO8/MJHPyFcu66W730VMn?=
 =?us-ascii?Q?iMz2mTl22Cmxs5GGw7KoXQk5CIjkpZDR7VhZO0S6e2yIIO0RzV2aBoJ6DRUi?=
 =?us-ascii?Q?y01su/V9F7/32aj7h64sTu37OqHSeP9wYBbRx5L+OV0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 05:31:26.0736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: f325a8c6-f46b-4e3f-ee27-08d8b78478b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SCuE1KoMPKn50YenYxhY5F44N2cbxeZFfOMJE4trpzrzzcl/tv7NTx32CYyUWpVK/1WO3n4MhA52xAQB7zcb8f2YN+l0kmfoSgw3Sn2MZpQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4694
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130032
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> The mail address intel-linux-scu@intel.com bounces for Ahmed and I, so
> just remove it.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
