Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62016C47080
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 02:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EDFF60720
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 02:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhFBCsV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 22:48:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57166 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhFBCsV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 22:48:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1522hsne021403;
        Wed, 2 Jun 2021 02:46:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=8vN34jFc3NE3aQH8DPosidfnIUe5bDHRu+3y3EbwHpU=;
 b=wYRrz4vOHAfvZAKRCiBE4hcZAHL0mUaj8usREualnmg/4L7LHtxqv5D+UZbhG826MuKn
 zOxz9pVOLg6dUDX2f5EcyEfIjcEcj6VmaT9zs3F6h0X1wFmd9t8LoGLsR/X0qjg9jSTy
 c/y35RUIOn0ss8pWkLDan0hHwhE6Ec1GOrRd9SQAS647/nq4nwr9VzEJHEhWQW1EGd0a
 MI6nL60d5QZT2o9se6R+n1AHYyDKJmS+vKzDEDHO9taxPNLd8l43tBOFNxVdF+cw008m
 E3t+caNpd9iEB5yB0I+49KkKwLviunEbkGExpJa8cNwrbi38WajEzgUjoLfUFJN/w6Y/ sA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 38udjmq6ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 02:46:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1522itAU145945;
        Wed, 2 Jun 2021 02:46:37 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by aserp3030.oracle.com with ESMTP id 38ubndnrky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 02:46:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axHzV35PKfs07fI4Ypq/r21rEdvYNMplSD5wZ8MdJkyXK9lNLa+FzsfFg4oOok2duWbbDqAWh6nL5+16ubggGjxvgHBd7+/WkrURMmegOfGDSeunBYqCMwpLkZDPhdyy3KnEQ0T2eIrslA5TWQQa+coa3LYDcZkYP3CxaadeAquApGXbevIfEsJFWFBBlpTp2KcpRkvK8rO9Uuus0DrKxTn0u458RSfiodKI5kGvm0ZVLJ2zwJwy7H73bei9eauk7a3N0IgKOuEDKgOmmKdHOhfPhHWPJfIjFYcmNhdk7UftVniImlaksemyw5WLTd1RoGMO2T9fnwQSj7SaDE9jgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vN34jFc3NE3aQH8DPosidfnIUe5bDHRu+3y3EbwHpU=;
 b=hS+cM/HQQrEdZBSWCQyW/3sKCJAZIVqKjzDj0+ZLpp9CC8ywkM/usO8FJGVmC+aKqJ4LRF1xBU64GOzXsAeAwmLlHpQuxrGU2hissRyg0vuFgztiFfwBnJO/QPlw/0WydFz2TVby0NXG16xhRb5+dja+3RWof3IaurbU+muV8bMzGky2RCRoxp7j4s1QPDfqqfmqLtdXUZIqUbcA+u7guEgcertQvBEt+iXfII5iizBvm8Y2eTHvrz0a60VC6jDilpZkHrONTd3aFowmrCGO3hjI0E/txqbuQ/yXnOWM7lk+Wik0OybpTpeweqO8ogxJruvnbbW4ORyFTNYtlKVY0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vN34jFc3NE3aQH8DPosidfnIUe5bDHRu+3y3EbwHpU=;
 b=TrodCsSnmNrY/r2BC0Ia/k9jJFXNTS/7SfEonKkuTALMMdquI5kDLtRazHREW2MOugvncguPBH4wRA5CHY+chJo5EZ7+9OWo6ffz6nC+hkIE5bR1o+lRLFm0tuo5rw8/fT8s00tXid3h6lQ/fVpVu6L2KGtLoMZL2PVNHLfuDHo=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4438.namprd10.prod.outlook.com (2603:10b6:510:36::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 02:46:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 02:46:35 +0000
To:     Javed Hasan <jhasan@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH] qedf: Update the max_id value in host structure.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1im2xq90q.fsf@ca-mkp.ca.oracle.com>
References: <20210528003206.22709-1-jhasan@marvell.com>
Date:   Tue, 01 Jun 2021 22:46:32 -0400
In-Reply-To: <20210528003206.22709-1-jhasan@marvell.com> (Javed Hasan's
        message of "Thu, 27 May 2021 17:32:06 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR11CA0097.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR11CA0097.namprd11.prod.outlook.com (2603:10b6:a03:f4::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 2 Jun 2021 02:46:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a528eab5-e3d5-4d06-ed97-08d92570a2f2
X-MS-TrafficTypeDiagnostic: PH0PR10MB4438:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB443808DEFABA3D1B4DF93B248E3D9@PH0PR10MB4438.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nUpd9mYSuOd1b5JV816ohvc3YruNEzujiVqXZ/cE9j81YlOcHOkDWoOr8Z+LvvVXr1jg09GBPdA9/XUP3wdLTiN9QAPZWgfl9Gjwbthnq/f0CuicrPsGYJJha7HRv9a9J18SCgjoybLDoYcmrvTilQ/0TRBDm+sjyRiKmZreXGfd6fSj3Y/mS8mOyoFXA4LER8pLim1bw1SZgbTBmTrbcBFUcyDVIunBiMElmMbXa0+4eE04PUzWMIdNExmQ8t1H8BEDHhF3clFnnS+gSdXFhsvaudle4eXuw8z2MbvHBxvoS5/8yiQw5M2EFEsz6wswuQOTcJPFLrpQfds768Vm6b7wuJIAVzQgNNKNd0lzK+ShOzFZEyu4/CI9AglTi2piRSJpKLqkn7SVfJLZxtySsNyjEhQ9XYddXkB6o+BmbJaJ2sYaC7U7RDsWk6/MZ6tx4KI36JS+Z/qsvqD7fBANt8qEfq0g4CHDTRepLqwIDZGHdVJ6NsfIexbCosSwPoyqruTnqLrK7QfM8ePJclFz+kqMN6EKBO++lAQDS86ujmbBGyjWVZmcjGJ+xTsVRbQwcdHp95MaWRL8txQD4dQdxN9f3Xshw9rIYv+NG+t4HDnQtFbsqGij/GjZ0GKcUKJdjpuIjPL+/zfQyucF5U8s8xsjyB+ZHylNB8jn4pcQ/74=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(39860400002)(396003)(366004)(38350700002)(83380400001)(5660300002)(4744005)(55016002)(956004)(15650500001)(186003)(16526019)(66946007)(66476007)(66556008)(478600001)(2906002)(26005)(316002)(54906003)(52116002)(7696005)(36916002)(38100700002)(6916009)(86362001)(8676002)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uP2QGgabe77yN8t6OXTYjDQXzfWVpH1MlqHR4JFEFZIOMJ1vJScYhiXNO9+6?=
 =?us-ascii?Q?0yDlIbVKTQrZ5kRd5ZoJRjwn8EdHllRj/BAPQvKci4LaE8WYoytoNJEG6Yo7?=
 =?us-ascii?Q?ZABkKJTzt8xu1+E5TnFa0zy7rrFK6Mo+G1gScJ6X8tq1NK0CLjTYRkUarmcm?=
 =?us-ascii?Q?dx/sqP0nGSX0z/szehTeUy0O0QanLfG6e+WzqpHR2qXQfILCTB2efp0iz2Za?=
 =?us-ascii?Q?92bbNmm7WFFrdA7Pc0wWo6gTbmcMcA8YZFV0xkxF5ZrLwdcSOOG1JhXVtZ4J?=
 =?us-ascii?Q?5nmENjGbS01NMzx1UVnUffSpDuT5YiAqdTqKR4No//aJ0tc84ZJsIO8P4msC?=
 =?us-ascii?Q?tdhZjoHaiq/XcX4Kp/NRYR7KtAdEFuAWsrEcWSSIdPUcTitgUJBq7j3q40nw?=
 =?us-ascii?Q?dWybeLmlpC27snPkO69GreyAM7K23p1Np+Un4j/X2AeOtwHc9kXacyrygG3w?=
 =?us-ascii?Q?yOUb09wIfMGYuyDxP6sPyXKnpx0UVfR54n164kf5bBUniTMjRHTeus+SEQ0Q?=
 =?us-ascii?Q?+OGcr5aXebSZJ9lFbqGbCqeF5O8dp6HBI37gMDPE+LLG8fYWLTKMWV2YjEHI?=
 =?us-ascii?Q?v6B9h0jJXVT62QgvuKMZM3NDFElJzrkHu7LuxgbY+TXsE6SaAwQCS2Ic/gxc?=
 =?us-ascii?Q?E7skGqILV9sI5SmYaqSwcTcaaK3M+2dluc7KxZ1vYtqqOP9oe4Zd3/OP7Nlz?=
 =?us-ascii?Q?1veE35DEzHMOJAo7cZORbH7Uin+znyxqyGoYGcQC+wJO7bF2K52g8G41aaKm?=
 =?us-ascii?Q?rl+NmvrBS/MhUj2rvX1DpdfwZU6uC4Op0LAXd9BhviS0FTlK6reHVt4Q/w8o?=
 =?us-ascii?Q?elrNR/0zJLZRYqJ/5ptKWPcI13cO5hf5sOhk/PB0WycYsw9+fO+AEGSd+E/t?=
 =?us-ascii?Q?3WjUlJgL7ayw6/lUTd4b+cMPTiIkz+LHFGNatKrFI+1XaZBUlCezmkCZAPFD?=
 =?us-ascii?Q?2q68mAXSFwCCPhMHZXAnM8BhnzUXkd1XQT1t6+SZ4aAc7Lo0s+SgcgdWuZfB?=
 =?us-ascii?Q?ND6AfWiqi1zdikWL6rAPlP+ZdiQ+vQtU4GXl7WDrvAN0kUQh+fPbVH2a/VNY?=
 =?us-ascii?Q?fslUsMvYoV5hy/IPvEKs+FlvTRU5RONHSz3MbeABHCTOYNPL1rjk9Dq+3+bd?=
 =?us-ascii?Q?kujo8HGpbXwH2tgmEntI9GBqpAOVOMweAEOqR7avP/xxdIKYukjDG8nag+4B?=
 =?us-ascii?Q?PcRHPtPxyfsN8XKYuxYoUBRKvyWH0zFRzVjCWRE/Zgv3ZSm/NmLZYUH0ZVSV?=
 =?us-ascii?Q?RGxOA9zdf6ZK0VrEWqG1UgR1pPqNTF2IF56/Tj2pr2DMPCRpZDLvGKX3pgE3?=
 =?us-ascii?Q?pqnJApSlWtYGIfNLTeKhPoev?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a528eab5-e3d5-4d06-ed97-08d92570a2f2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 02:46:35.1404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /qjLb5yCkFNArzIG5Qx8iWhKf5XAA41gw29zVBPw0dLea9sMeNnLFsXA6XNjRlVlFM0/kMvBbtCtyZX991D2CY21kVrS45jc65YkGt+wpRk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4438
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=985 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020015
X-Proofpoint-GUID: -Hxj5ef00a4YgjCz7n-T3sVI9ufS-Af8
X-Proofpoint-ORIG-GUID: -Hxj5ef00a4YgjCz7n-T3sVI9ufS-Af8
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Javed!

> From: Saurav Kashyap <saurav.kashyap@cavium.com>
>
>  - Update the max_id value in host structure.
>
> Signed-off-by: Saurav Kashyap <saurav.kashyap@cavium.com>

This patch is missing your Signed-off-by: as well as a description of
why max_id needs to be updated.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
