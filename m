Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422EFC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:04:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EDB06115B
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237978AbhDPCE7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:04:59 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46016 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235043AbhDPCE7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:04:59 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G1xpDp179305;
        Fri, 16 Apr 2021 02:04:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=eMz14EXbDyPZgWL4xOqWA/ntiIrGckrwVQwi1TLEtN0=;
 b=hcAL5XRZ0XEAQD146DzWXKIPVNVUKYl5dSEQZ8eC3QkECiANe7LjySgfMs5uzCyqaPPj
 OMrOrcWqtEWG6rfSPLdtYJEwZeWGErCjyO3ikZYTk8/Gtov4uQobNDSx7pc0X3vkfHJD
 ewJpu6LE3zWLC+8bdAngsj1ZLfTMMGBNmmKtSZceZAoMcz/51SRm5ytDyRyOaw596N2N
 l/BEoFyr2RRQsJBuzM56zz5VwyiPx9Gd1DAGYODXBpGm1VZtpzJyDwlq9opqQ4MzXfzJ
 /DINnFRgBg1J+oPO6mjr9+0e9PmUTfHvJEN4tvTI1/KZfBVmdcM8JfsIBl/jZHP76P79 3w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37u1hbqsau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:04:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G20VfW193260;
        Fri, 16 Apr 2021 02:04:01 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by userp3030.oracle.com with ESMTP id 37uny1vwe0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:04:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a73it3rcucHT5JBLLspQFtIdWss40CBGtpQ7EA7l+rN5IPg6JkEXImUvxNvooJ+JMxqBpiDHqjKPZIJ9EjQogb2USNb0MwM4cM0tWW5Gt0TMJWQ23NSLmbbwjIswmFUtVrQ5pO2ejxi0UOaSckyGsspoWEB1UyOEsoD7XBrlFP+CIfLxE7RCyQ4okgtsnMb5Qthm9YW9dSxIaHYsPmUPuLzqL1gmjV2sokYor5KBwtf7bbuToXMx8UQAVQOlQba5tIok3IRVlbXU/kSUs6kdpTcaksoVq0YLGNI/aHRdbriFhre9WjpEdQ4GFXPKvP7QThv6Fm3Y/1NMS3kHVpUF9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eMz14EXbDyPZgWL4xOqWA/ntiIrGckrwVQwi1TLEtN0=;
 b=i5FwupseZixFqWOalHhyRJDjfAopDw60ngLHcrwDzBuYYZ4hAtsXS9aM56SsUBw0OIS2voxQO3kft6X2pluUM256C/cJNRwwO9YYjea+wEtgDtHURIsUPXlGSd57es08PLwNbvIDkDwP4HmECWQMLLiMsDhxg/+jvgzrONZqGVxnnrlLAasT7Fn7lO4HakFSlCx6l5DPGZFnre7DH88W/avdy+7TLOpvC+tV72tPag4F/ZLoaDypn9BTSyuF9z3QGzq5Dwe81W78dtwMfd1RFtjHl1F3q8xX9bRphhkLspqnqSi0tOoHoKUn3wGZbPoMIyNZKNYXBNCHTi3s127LCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eMz14EXbDyPZgWL4xOqWA/ntiIrGckrwVQwi1TLEtN0=;
 b=b+71fFIr+PIJ7x5Ar3akInUsS2uOvLsvxY1Q5675S5KF5OcB7HJiAKmbIFtgRWECnriu4CpbsS5kUD8qOiVLe9HJkjq3MNV4JlB7Py47kUPdoelbOtUpQvQ4H1QjojL/yIfNh55QZRinUQHSoPnDWWYPzELLZ6D6nRCum8UYBYY=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4775.namprd10.prod.outlook.com (2603:10b6:510:38::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Fri, 16 Apr
 2021 02:03:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:03:59 +0000
To:     Don Brace <don.brace@microchip.com>
Cc:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/2] smartpqi fix static checker issues
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czuv0yv0.fsf@ca-mkp.ca.oracle.com>
References: <161850488487.7302.7018870513204678832.stgit@brunhilda>
Date:   Thu, 15 Apr 2021 22:03:56 -0400
In-Reply-To: <161850488487.7302.7018870513204678832.stgit@brunhilda> (Don
        Brace's message of "Thu, 15 Apr 2021 11:41:58 -0500")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR02CA0051.namprd02.prod.outlook.com
 (2603:10b6:a03:54::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR02CA0051.namprd02.prod.outlook.com (2603:10b6:a03:54::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:03:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b93872e-a95f-4df3-827d-08d9007be624
X-MS-TrafficTypeDiagnostic: PH0PR10MB4775:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4775F0129D9735F16DB00E7B8E4C9@PH0PR10MB4775.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZSdxIuCPJ1XqEPNyrTC0wQkjvhIl/2Pu7qEVmZbMBITWIjFmdE1e4Vo+QhNUcAYSdBxkdNuf7BgaMO2CdK36iOqBb+1psJGVGtP6q/waRd0ZQZ7VeAv+pirfHRcJapdSLGIMt8cC8+0z2n0CiDZzSz55hp4nmvobJlUUworIs/byKh9WAxZk+nWSPMqFIXknytP4ZlYhuglnqhowkVMK37x9ErUxetQpkETnMSKYIy/d0RSvCdA0mSqHI1V/NSdYg7wo00xE7BOkvqqj1MHu+cMAeML0XmgwLsN/PfAc0CM/CyxMDcOpDkHoQ8pYCJQOmUNeJtQKa+R3YDPNpaEptzdLb8oA8s6Y/EhKNpJQV82iiXJlI/u+JOGyN9/vVIflEfSGiB7IXq8Cd5x1svT/kAtSSvGisXA/UHaSrMqAtskZj2CnEmrPbGhyGTq0U+hubIC1sZ+miVzcq2gZ5tvW9ClEsYwqaUa/abcxl2BshTI1HYIp9CDBWpZNoC8x5wQYN/p5yJ29mXYaJz44EEnyoStVnh4JUA7Noxsy0OyX8cF3GLXd7dtd3q7pfeOIPY4mTwlruV7BBMcTKT+C5Os4RebtQ9M9MgxMmF5haVQfyPM/8bEjH90ddHEAFV0IBcDmAOpXGLZmpy14SDwnqArWu1C4y5nyWs5Ghk0rHjKnwLY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(346002)(366004)(396003)(5660300002)(66556008)(86362001)(558084003)(66476007)(66946007)(316002)(38100700002)(36916002)(8676002)(52116002)(38350700002)(4326008)(7696005)(55016002)(7416002)(54906003)(83380400001)(2906002)(16526019)(186003)(26005)(478600001)(8936002)(956004)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?S8EuP5JyBrKSsQ6j1oWfQ0hRQrVPiT8GuE0yFIbu20tC0wkGJyMo9krpqlrl?=
 =?us-ascii?Q?+/Oi37RsKtE8eUD9Mx97RYWvBlN230Anda4Z6Lzb0jjz+nkqBIpVBvdL4uC2?=
 =?us-ascii?Q?D5jOlQkYVjcJgr3p4sndUyTQGeg5V1eJ1EmuDNhBys/6gDcUo43O5KC8aqqY?=
 =?us-ascii?Q?pKOIgGzQL2Gh1Fep+jd/vyAr7wiXKekQhG9b5pHTVaA2X83yRX2Gp0svlt6G?=
 =?us-ascii?Q?qw/XYJB+KPSSNaHCx3guKtMaA+c9sQ6/10LTdXr11ocM/DK3LKzbA96nqTPu?=
 =?us-ascii?Q?p/ixz9Ve8oAb0jw8e8ngg3FbXFB2WutdUF233SzisVMdsdvoCFlixYdJa0IS?=
 =?us-ascii?Q?bTD1D73XvvmdWY7wyDn7F5GllASx9QETca09TrBL46evG3QmEtz6N5bk3tJv?=
 =?us-ascii?Q?fSNTM1FlEaPsgtb1oiYhOnVAAbVFqqPvztYm0mW0TrWOKFWBz6QhtjXhquwb?=
 =?us-ascii?Q?So0BhgDmHwk9WQbtYcbO7HZ2q6rlqAcsW/Dhu78NJTtU3ujFqW8jJQ7foA3M?=
 =?us-ascii?Q?1/UildiJJCBse2HE3jrksVzmFxT+lwOodHCkSY30j65wADhU06AEBTiX0E0A?=
 =?us-ascii?Q?ARLNAN+W4j3KSyaBSKb1Ng9sLTZawp074pQyzhN6iHZiLGqmrvYS5h+gWepN?=
 =?us-ascii?Q?HhUgALSA6PJqF5wZ7RuBEkusgktnLwcUPqa4+HGFt3XH4xkiQuqtH7xDHnEM?=
 =?us-ascii?Q?j6QxlxOpAggiAmjoLtvj6BC+JYkXMFNz1NqGzeHViha7apCTmtNbVmRqrb8U?=
 =?us-ascii?Q?Urz3wwW4Thjx21lsQXcUJUiBI+2DGmaG+br9TkRcdlvvc3clGhhyA8FgXGCp?=
 =?us-ascii?Q?8V7Jndaj+EtzszB23EcLPOSuexmIrSfedBewuQf1f09qfpzWQnc4T2ArUe5z?=
 =?us-ascii?Q?yE5+XpVggPXU/B2lwx43Khxgj9tV5fVA4IaHCBX8G4X8bksi8cPHh0wO9uhi?=
 =?us-ascii?Q?mvGK29U53WpUlEOu9mEAl4g+pXO43UD9EPbtNmQp02eAHSG75wMGu2mmM4uK?=
 =?us-ascii?Q?rGMiOcSktr19XjNra0U5eA0VmjP63aO3Kef8MUKxcTR5lVJlTtFnatjyYpWG?=
 =?us-ascii?Q?v7kCbn1ww1ONr1OLZF82u4XO5yC1NPpaLmtFqTPzoyCvoR8mT/tJncskNxM8?=
 =?us-ascii?Q?kEqjuMFO8WRZhWQYj/ULc6+OFnERHk2el0CxU488GcvbHhsT+3zultj7VkMx?=
 =?us-ascii?Q?MMec59+rbvG7EKpY7vf4GPbykDN4wC/3zjjENPI8HmYS7J2ldQ+ZVSXgulDE?=
 =?us-ascii?Q?ctxxZoNPwS7myPChSdnYV4pkAtsIQUH3st0uCJSVsMztZ4uvqmsaM/asY/qo?=
 =?us-ascii?Q?KOgkkSR42TI3OdZ1sFVlhafj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b93872e-a95f-4df3-827d-08d9007be624
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:03:59.2970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zm1sVNoa2guhXBnfstTDuDt7GP5tBT8GSpNtmnLXSRYp1JlCxgp3UpSPDhyCllebwCmcY4x0SggKKnQxZ+NO5NiH0qfmMu8USq7TPls8shE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4775
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160014
X-Proofpoint-GUID: v1h8i-08k0Urg2DaWwjnAHrgKjLu48Dz
X-Proofpoint-ORIG-GUID: v1h8i-08k0Urg2DaWwjnAHrgKjLu48Dz
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Don,

> This set corrects two static checker warnings found by Dan Carpenter
> <dan.carpenter@oracle.com>

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
