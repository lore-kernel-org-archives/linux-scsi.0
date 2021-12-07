Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A12AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 03:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbhLGDj3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 22:39:29 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:24416 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231591AbhLGDj2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 22:39:28 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5QwH007515;
        Tue, 7 Dec 2021 03:35:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ihPhhucbZcFsgBkE4RRWoYPIUhfn70WpndaYUYjfySY=;
 b=Xpma7H7lCOvW3moq4VDOcJSsVEwTRDKOccrVp2sRcoi0ZG1xtF41ROKgGMl2YFqNeCHG
 c9PcE6NaOksfCleFh0NNuvV7GcO1Qzp5rpUaJno1TXwCV5hEeFmjuoP8SafJs5vOXZ3g
 WYZlTNuHAJYA9IATZm2TSroAg5/PVPYqL/iZFM/VtCTFMCJl3AC8fUs9/6QBS7MukYi9
 hTNN+MmpXaj2uUooSCkblu+xcN4HReK3j28WziEnP9WldQEziAo+TWJQ9Q7oRwcqYIIR
 4fIo9MEsu1KKjLawTzJRmlXUKFOeFE/gNnB9S+CYXeL6Nqk/uLwiEUNY5tTnKXpNXZ5D eg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csd2ybwsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 03:35:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B73VD2n060482;
        Tue, 7 Dec 2021 03:35:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by aserp3030.oracle.com with ESMTP id 3csc4spryh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 03:35:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fS+y8hAWgupb9K9CtgaDtbSabYACRJGtk8ucSReupEE3dI4406Q8p2Y6BeHwSh8D5qc0Afyb/irGzlFGOZuot+P8iq7aZH2rE2fYiPA3eoUmCZPxsggOlUJ5v80rgO7B+Om/s8oKbqG2N4/Es2EoU1yZgsr69YopFnGXKPj4Zx9bEvkyiPmyN8ScQFeoovmZ+Jrw0Z1kB0sQHdR6a1dKWQB9lPymxE00iRGRomNOpzbX8YUwlmUau57Fn9/lJBI0x+0dKN+RpiycJLPeWXklSIjUkFu1WCYx55gp7+GQNJzH1M7mU2hBWP8E6eDIX4iyWsi6hVf+dhZMD0oHYBmX0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ihPhhucbZcFsgBkE4RRWoYPIUhfn70WpndaYUYjfySY=;
 b=Vxv5sHp3SWdbGheVo1XXXJdb2XPLqnm0Pi5aHf5gkS6VE1ZwdXHCMeT/EEOLYsVKfcVauUfpbHz6FZNPcfDbDtxYr7GGR55rtbUBqsWLbb1VIibtt+txZ2UU4s4dFEiL9yz90weBlvMF/azHlUMieGmaNRJjPkcCYsqKXV9rHX9CThYG5K2Zn8rNIu0OFdTpBsv+gOcwg0nIgDBIJjo9q7n9DhTS1gWIxdUPQ4mJ4MlX5598ScH8Ehf2EMaYdeyf69dG2bYcAqmSVjnr30xHG5mAU9WiNuIgOF+ow+FoRGh6Ghv1wm5RoNOgAfZeubgsoykoLFQ7JDOCPHn8KjxL2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihPhhucbZcFsgBkE4RRWoYPIUhfn70WpndaYUYjfySY=;
 b=EajIWrVqM9a/o156+OqDx85ruduQbmklyBgVmef7hNW6HCk5C5fkkgvZmTyWMP6tBXaFPv6EjTNQ3uwvIjSZPkuVl/BwkVejPdMFdqL8PftuViJ0xP7CaEu4ynC0Mp5oc+zumEu10IzRRPBgMgp6+xTHESsXIz6rGZxZ9GMtBDg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5419.namprd10.prod.outlook.com (2603:10b6:510:d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 03:35:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e%6]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 03:35:55 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/9] lpfc: Update lpfc to revision 14.0.0.4
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0ght7cf.fsf@ca-mkp.ca.oracle.com>
References: <20211204002644.116455-1-jsmart2021@gmail.com>
Date:   Mon, 06 Dec 2021 22:35:53 -0500
In-Reply-To: <20211204002644.116455-1-jsmart2021@gmail.com> (James Smart's
        message of "Fri, 3 Dec 2021 16:26:35 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0173.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.2) by SA0PR11CA0173.namprd11.prod.outlook.com (2603:10b6:806:1bb::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Tue, 7 Dec 2021 03:35:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed068e2a-954c-4205-a495-08d9b932acf8
X-MS-TrafficTypeDiagnostic: PH0PR10MB5419:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5419E02F83E00FE63FE0389F8E6E9@PH0PR10MB5419.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q9D8XskzPigcUaQ/qmFHZYXH5GCbD5hBMsIDBr9W3/a9trEDuG5QRBcEUwujD+/W2Cqws84fk6kwyK5SC4+2JRr3z19yyAXVQxYbeOjQ0VE4KEASI4O2XEGLpOrqXYahmhk49HdDcuHwOphxUtUIDE9esvFYUfjJCghvR4K4OlxueTOO3iVHF7jJ8n1DxwCS838CDUCbtDmmYefnxM+9kkAMBgjY8qUQeC436qNLbNQbYnXsQ9Jk2bWM+cZjLWEX5ibsqrO/tIWAnY9lbW8udCOYI3ksQ1su2LRvOTE5afnkyJB07Uu5H7qbGKGQVW7s53lUPh/I4whjMd2temy+fir1gF36ZhzH9Q+/Og0kL6lW8rTZ+H+dfU/3dU9m3bbPoz9xgbhEl4voeGOFsIxiEX0Bi0HTIir8zOCiNJEBcMFX/eY7ll2nV+FInxLUB+pXZ2DnzVC0TglxdszYc2A9S8gCcRcSb6BJoE1MNAfOlPKu3oMOOGovmxldMMHituhpKuM9lGtsqframienpvgd2Vhs2nFQ47r7tmZdsiDWpFaFyrISGxRKpS9qrs7RBMClEo7241P5XJ2GKgHcs6U/w83ucK28Dd60LxOuQILkaZd0beAZXAi+NjawEPVI8fXte5rlO1JHNOewjp82DBa5xM1K/qwhQuS4qOJZpCFODh9as3wmMLo7MT8IZZn5Gfc2kstlp9LMI7bb8PgRbdPfKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(4326008)(66946007)(55016003)(186003)(66476007)(66556008)(558084003)(8676002)(508600001)(26005)(86362001)(7696005)(36916002)(83380400001)(52116002)(5660300002)(38350700002)(316002)(38100700002)(956004)(2906002)(6916009)(15650500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q3KSx+4sowTWslyEOY1O98u09AbZlqAemTt/rIXMUjoKjUTsWuBQEHQ4Yh+6?=
 =?us-ascii?Q?TVpc0n9Mz3bUvP063vcJxbvQTefmgtAL4iv81Zg+45j+5IZHZvS1mBlp6Cno?=
 =?us-ascii?Q?pu/xJ5xIxiFtI6IL87aRp2G6PoWek729m9/mSLUbj+P+FeLWRhb4tgpLtJD1?=
 =?us-ascii?Q?tMJiwlifV13ECyIwuC3uFMecPzh2B5tGaAfp3jnShGZnX89pXohhJ4m4URth?=
 =?us-ascii?Q?Yt59Vua1Z+AI/u+i9F+l1b+h9dybtyrvtM0YcJGVijIQI2fbSyCE90McaYft?=
 =?us-ascii?Q?5H/TMSc4S1rYgibYesIymy6YzbL/dNASs5Thq1ZLzZWVIysVCLK8cE85iTlV?=
 =?us-ascii?Q?ZZdk0NrixoUo8wjn0GRUWNyZ47U5NjgsEwdaAMHyKtvfco47xGnaTtqsMfQp?=
 =?us-ascii?Q?Ya+CRLbbSBRfBH7xYBcqJ6ZUFqk2IPpOB48q+j04XZG+vOfSLittWMMEiHgN?=
 =?us-ascii?Q?GhPHtgvz+r4kzf38CkFHGtzgxbQQlje99T9G9gtcRVRC90VRapS6gkMNmlfK?=
 =?us-ascii?Q?53Wv5Hg0FDyJc2rPA67LZP8iF94kJL5LB4NhVEPQORlbRDbAabccbtiN7Wch?=
 =?us-ascii?Q?SXMxBXXbeH0R86XajNJZ7PHUn7CGAsPb7GLw2sAvk1NM0FadJT3fmsBytKU+?=
 =?us-ascii?Q?BqDJZvTQRAnCtcSiUDXFMzZlAPs9l40E/CFhWsr5+K6KqtLuXD6igCKEWNwr?=
 =?us-ascii?Q?2ZF11dzYYsNYJhqJUxR9gfSHaK9Vzc0phbeBAdMpA3+JrOgSD0JLUSauQosS?=
 =?us-ascii?Q?S+JtDsJjHAj3mQtqgLuv+Jk6ZqmJ+H1y+yyt+9xOxEd9QHBsj9RJqVtAElJA?=
 =?us-ascii?Q?jYxBV/fFYFK8YNOQgebAiigB+8hTMILBhcFaFanIc+V8gYMsXNqxbqK/PkfH?=
 =?us-ascii?Q?Z3tk7IaQdYL9kZ/Tnqi3NnyX7KvCPNtUwH1kTSBxUHsO/IaSgrB8FDBmu4QY?=
 =?us-ascii?Q?Z54m5JOi1SeKM3wR6CLZFYY+ds9OXLWWQtJpeWJImHv77RLW8Icm4Abu3ahj?=
 =?us-ascii?Q?8AsSMAr/c6TJNSFfT74naV3qbj88kKHEvX4CFIKPw8pYz9kcUuUvPoMnlI4b?=
 =?us-ascii?Q?EAejC5c42c8QfV3+atvaPo/oVAu17OEFOYo//pJYE84tEeAUi05zEqT/iO2V?=
 =?us-ascii?Q?g9RkvhcMoqbI+qVDLzX9icCp6AhNDjCu9rC+S9ywZeo+eBnBZIrn0HGx3RHf?=
 =?us-ascii?Q?1MwZpmPq/wUMVfgGvosZwEj75AMbvozjHSVmXMxYr2nYoKX2ObvopE4zgrQd?=
 =?us-ascii?Q?BVoAMeJH/QT1UvFntoIgB7iFGr6SRyqfjwccFcsHHR+TaxpiSNVXbramlWzy?=
 =?us-ascii?Q?mmRed4kL0/eYSYfqRjUv1TJXcCQ68+1pFR/SHsy1EUPcqZ3vtXUUTajgSb6C?=
 =?us-ascii?Q?aZMylUPD4QMN6QDvjtiX3nAqTWU3OEKoUNlNEXoLdswoJwETKXUmzmzsBdnF?=
 =?us-ascii?Q?RamNR82u3ErBDDvY1cBazWABkvLwm76fpmxTmR7+mG8MB245u7u5jfgWJF9o?=
 =?us-ascii?Q?EdOyEwB8W5f6nLMmX9iwb7lQPKa9mk4uu140A8EnkyMsif4QVLI4RboW8FcU?=
 =?us-ascii?Q?fDl3C9WrJsXexxw/OFoVTCzcUXwrD8uGA3rdu5XSDETvMRV3vM86ZMjEF6SH?=
 =?us-ascii?Q?38mNN/io1B1l6+/slOK3W+7RIIVhlV94rAawWq3xz+toSu7lZt+wqQVDvZu5?=
 =?us-ascii?Q?4ovShw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed068e2a-954c-4205-a495-08d9b932acf8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 03:35:55.2052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CuDlefRXOQ7lZUFNovVC4wxTd5jlM9sog3RSX1ACqKth2h07bTOYlWaxFr2qsHXVM09Zl7h8eK0Zf8gJiL1gim8P2FR8xZQD6kmlJg8iU2A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5419
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=749
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070020
X-Proofpoint-GUID: 3Fx1OWOogAcvdsofp1l62yScjus4AyBs
X-Proofpoint-ORIG-GUID: 3Fx1OWOogAcvdsofp1l62yScjus4AyBs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Update lpfc to revision 14.0.0.4

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
