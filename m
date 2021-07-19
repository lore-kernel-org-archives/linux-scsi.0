Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4992BC636CA
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 02:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AEF16117A
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 02:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbhGSCsr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Jul 2021 22:48:47 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:63628 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233759AbhGSCsp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Jul 2021 22:48:45 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16J2ffGN027820;
        Mon, 19 Jul 2021 02:45:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=9x9AsF1gc7tjLOX0ydBjbeWfBPcg6+ZUafJ0Gk6uaos=;
 b=qdBRbi8Y6zwWYQrrVv3mI6qjXGvpnQMD9EyIdDS3xtjCoQZltFqDr+9bKXZVgFC87VnM
 Wv7l4qmrOyMgn/fdUsjmu9Zl9IN+rZNpAk2XvVMY+BRz+8C+q/PGebS+50PFIFhqq4Om
 L577vAIV3Qa+STwM3rG9Fmv1bpILbBN+AzoSqXNPuwB/7rYpjuV4MUlBW9BufBqJC/Wo
 Ua+TcCuQXsK0F05o2ftjapcproBotCjyTwl1mfj9ML4d/l1Xgxu1ENzJOMGDjcrMyFgz
 D6iDTNdeV8pkMamuBcCz4wpfieyL1ncKR9wC1lRD7BtSNluT8ckY8p558FRa4J6eS/u2 8Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=9x9AsF1gc7tjLOX0ydBjbeWfBPcg6+ZUafJ0Gk6uaos=;
 b=cc7rMd65eOPhR0sK5ZDOcqU4VoHFLx/Yt7yC4wk7SPPxnlef910Kw66n79wi8HrZTtPi
 9BZMEQDwX20+jwmdKy4R1UYHk6o+T5Hq6h7IhflYqeqlUvP5lRD6Ozme82lojH2xauFQ
 ZsRKod3enp/abozvd0s8YdCaWRdj3r4p0zCgkKq2h/V2dmSy7f+axfJr2ZzxkQiokmB+
 g9oYlmk9TiDu9bzqvnYetvVZb8s2EsNfUkK2k+PB4sYGKAvi7TlpZL5PznAH+J7KFBYH
 3iaNNh80EC5+cX2xZFX8tP8VqMCAWEYtj0tYIdVgG88sALDRZmXIwSNXRrUgvJ0Fsgeg 9Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39up031xsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 02:45:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16J2j0i7001608;
        Mon, 19 Jul 2021 02:45:13 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3020.oracle.com with ESMTP id 39uq13v5n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 02:45:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYJ8V/h/uGev65Fsw3I0kqQLLoNJu0H1JRwUtpZC9BSwuewPfAZ4hAiQRadLXnubakDH39eVITPzNq2g0S4mG7Go27TC1CWYXMxsW6rAiA6Sl1i0zfF1aBK9ClL6ZDRzDtQqFYic8LDex3jdpb8jCMqS929kl/lraNaYvRF+W/ZVXJ22ezhpFTDTudzSwPoyhZucHY++Hx4nT/Ig18Os3tp0oNwz7DgHRQDfKTjXKManhUuuQ5FDnGbwpLvh96NZKseD4/juqLYIa0po7n+tZVdX+LSJR251xYmyWmCE53so7MrWvKzkrK+A8ZiUuMKYoN20YExir762POEXCup/vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9x9AsF1gc7tjLOX0ydBjbeWfBPcg6+ZUafJ0Gk6uaos=;
 b=T34PJawsmxVKkpcUfD0MVNgJnpgJTsDdEPhEVMXVE2lfJAlZ5MFGNBLAbx5PUX3tkoaBYH9jSsdq6fjMyoWP3rv+xlBCCPyi4G82J1vymDK+U93CdRbi3Hi+Kvh38ivTCfMXxQUUvptlItzVm+sspT4ZWB22NeVUEfW5R8fidCv8qnFMuRlmh58Sks7VfptV4Yx2c/Zw1zq4eYBLAmYtwyd9wTroZRpB3YrH2YXhxTxyeaK+ww8k7Mp/mPhtGDsPGQD+kvGyozbcMulZEneTkX5r+bopz0SqhMriyUp6aOcw0/GVrlA5igu3/YhE/b1zIXKWmWseWAcJllwZD+J5Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9x9AsF1gc7tjLOX0ydBjbeWfBPcg6+ZUafJ0Gk6uaos=;
 b=AZAWPTERVw8ypS7zgaW3StyX+fyBhlgsDwBuUUsED/Hr+3ETCHXC5rneW47MCoAwMandXhPZP6OddQAEtJlLY0vXi66Md3uWJl3TF9hKzj9iINik5ca6sn96tpdL1lV/mnkATySfzE+E1xm22r2miieFhu1f+lVwnxC72K9ApG8=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5420.namprd10.prod.outlook.com (2603:10b6:510:d7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Mon, 19 Jul
 2021 02:45:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 02:45:10 +0000
To:     Don Brace <don.brace@microchip.com>
Cc:     <hch@infradead.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>,
        <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <balsundar.p@microchip.com>, <joseph.szczypek@hpe.com>,
        <jeff@canonical.com>, <POSWALD@suse.com>,
        <john.p.donnelly@oracle.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [smartpqi updates V3 PATCH 0/9] smartpqi updates
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtqjyqgz.fsf@ca-mkp.ca.oracle.com>
References: <20210714182847.50360-1-don.brace@microchip.com>
Date:   Sun, 18 Jul 2021 22:45:07 -0400
In-Reply-To: <20210714182847.50360-1-don.brace@microchip.com> (Don Brace's
        message of "Wed, 14 Jul 2021 13:28:38 -0500")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0032.namprd11.prod.outlook.com
 (2603:10b6:806:d0::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0032.namprd11.prod.outlook.com (2603:10b6:806:d0::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23 via Frontend Transport; Mon, 19 Jul 2021 02:45:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b548a37-6896-4a37-62c0-08d94a5f3a03
X-MS-TrafficTypeDiagnostic: PH0PR10MB5420:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5420DF8840C6E7D100AC16D98EE19@PH0PR10MB5420.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cU8Sb6IC/aXOBnuy9iWLctFccm/a2WSgJiAGUUHOe3LbtDiRM1eqZjk1+ubImZrphs8OIpWagsSFjIZCAyoBUfKzd05TC1ry6c95OvHsPee2P0Ikb3CRtCSopDu0ag9P9ICBLZnZhES1c1lxj6jZmJyOgU+hZ6oQtZG1W1H4FQSZhn6Kt1EBO55BhzR8hIobBRiWYWLZSG/ESOsI7RMLjoLtp2Z9RCP2Cwzb9uKaLk3+edoxUFEwM+RhhnX20ambGnPWQOX+SeO8UbWn8u5LUFm1eDHMM6g0D1Y6uFq3ypYxI0Cc0HvRc9Vp98OxZ4gWRTXs3il0swBPQ8e+FXfgW6UTuVWmx4VPyn4Y2tV95ylzTBvAuvoz06/ApiWEYpm2fGrQgSeoqT66XZ8Bd6o2cAOQ0WluussNM07mOKwdOWznaAH++y/JPKZWXih612+wdlRTVF9VOTeClm/RyYE3jgLvavYpywl4HatyRG25TI1Hriri1eaZVhGQ7qaFeGtCgRs3BxQYrULxxi8CtR0ExJVepZizGE9u3CxR0CMC68J1755TJlnok4psW1mZTT8zAL8ysrmwrdq91tv7OflSQvoF0/zJFa7NP5bq/4sUa73hiYWn7NO/5CVcMt6tWTC9bzLHZw0nJcLRU0I14Ce4SQtRlcfSYOtCPXsq+wC9LvgKOkJdo4Vrb5dVriS3pfNcjXe95yiHdDSpkrCBsNyNwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(396003)(136003)(6666004)(83380400001)(956004)(4744005)(15650500001)(478600001)(26005)(38100700002)(38350700002)(7416002)(54906003)(186003)(6916009)(52116002)(7696005)(36916002)(55016002)(316002)(86362001)(5660300002)(8676002)(66476007)(66946007)(2906002)(4326008)(66556008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C0z6yC5wk2NaDMW7hemUsP5RC9+zhZCPIugQZS2orx5UvD6Wb0F8V0GI3mrJ?=
 =?us-ascii?Q?IQPFcFTwY8hj3OV5xHpS7Weea6ofbpQbdeZ6cu0cwX7Lh2gEwSp6tOZyL/eT?=
 =?us-ascii?Q?RbdNRmvInBhgcAgh/mcvVU6TW4wguGio6n+NOnyFel09SGZbVcKbZ3aUghYs?=
 =?us-ascii?Q?fwmzH2tEeAC9myVtlXJJRXtrhL9IbmhtZ3Pm56f5PZSUl1AVQL36Jemhwvnv?=
 =?us-ascii?Q?w2TFMwulbFqGN0LieISZDecbTu0vzy8pb7/dXLcxpURmQqwOzXv2/0syKmOh?=
 =?us-ascii?Q?SQvuytkiEDY7vZvLVSnlw8sAv4D7aLWohf2rOZq13Wt8z7sFow3Q6afG4gGt?=
 =?us-ascii?Q?rZ2k++w2TmI6ZLXjBqpICkfqFj5cOwalfpBfVh3jDlUsYRHxeVzl3l+zlgvA?=
 =?us-ascii?Q?RKtjINtGhv98B0PzHMHrazpAVvmi/X35kRleAmLB7XawgcmEfecVfB4rcRKz?=
 =?us-ascii?Q?EZJT5SzQmyyVRo7DCfGdRVG5KE+Upj8nBlldUHELeirFUgutMBAlTBGzwckW?=
 =?us-ascii?Q?B2UyBqlQBAgHiZRAi/2CTEnH+NP4tQCWHPMN1ow1lwjclPJqpRwYc9fVkeEc?=
 =?us-ascii?Q?zB1NOoAHa8gFhuQqDiB9gNeWBqi39+gwKyhb2gz9m8q9+eTPPjfWL/Vkp0j1?=
 =?us-ascii?Q?fIzwsY5cH/uTkbr07/bez4irhj4w1Q/uftI2NHkgEcXPld23+Nrz4DaaT9j6?=
 =?us-ascii?Q?W4s/yLQdTvVTy4kKlVlZmsCZS73mbFUc7uPIn1q6sfNbLadTsnWA2NnuEdtC?=
 =?us-ascii?Q?q5TKn8qYMk9h4ovYBaC32Mlc2L0GVePWfsIFujlLPXynYbtN2WJBbgKTjecC?=
 =?us-ascii?Q?omtHtaUx19ABzXpSREdC8RmoI72jcIWCBuFhGzxAdIIlv9XQbs548+UcRlOf?=
 =?us-ascii?Q?OiK5pubnoT7Ww4KuhjUa13/0TXPXQTpvd4IxazQJ5RcDaytcqc3oWEhksTiE?=
 =?us-ascii?Q?tNUMasHCdGBmjK0D3fCRXf8i6uIImXUVpMmL/IoASSfMavY/PG6qoOmUcB/s?=
 =?us-ascii?Q?FxBYCPpxNbeFBZo1fCpRQIQ5CqFFhXdLPclU4PYMskCIq1H63aIz1jx2nOlE?=
 =?us-ascii?Q?00JXeRkxOYmtJkSk1PhYdzMW1dI/4LpWqo1GFGzMGS5AEw0WTJi0XeKI7RXZ?=
 =?us-ascii?Q?aJgaUypwBwkJsnQVT8qP9KmioVCYsYFoGITJ5EAeu7bQiBfRUxF/ykQ3G8Le?=
 =?us-ascii?Q?JZrVTG/+7CHpTTDpDqqyy1dtKCtGXxUQPvtXS4oRgKO/r90zxAjBwmeY/Zp4?=
 =?us-ascii?Q?GT7pEi7KO2K0zH82Mqq2voBAUO22UFuTQeYQ4kHg/y0did6qg4MAQaWIGYvo?=
 =?us-ascii?Q?g+tZ9cb2Hwuig9fqPQchdqEl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b548a37-6896-4a37-62c0-08d94a5f3a03
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 02:45:10.6101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W95IxjzueFkejK6Vn9XRTTWS4EKIqWO3JjhX6KOSUiAU8UCibvc01q+LToh/QuHZ6EdZvIFbukX5AAD+o1ThYYplLMCPQtJmkv1rgLPuHAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5420
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10049 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107190014
X-Proofpoint-GUID: Uqc9wRkgXFNa3uR85N2DdggC5Y87fEck
X-Proofpoint-ORIG-GUID: Uqc9wRkgXFNa3uR85N2DdggC5Y87fEck
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Don,

> Most of these patches consist of adding new PCI devices. The remainder
> are simple updates to correct some rare issues and clean up some
> driver messages.

Patches #3 and #4 are missing Signed-off-by: tags.

I can amend if you provide the relevant signoff chains for the patches
in question.

-- 
Martin K. Petersen	Oracle Linux Engineering
