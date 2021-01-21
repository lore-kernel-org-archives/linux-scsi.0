Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB92C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 05:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B02092389E
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 05:54:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbhAUFyz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 00:54:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52964 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbhAUDfT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 22:35:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L3TYOM018652;
        Thu, 21 Jan 2021 03:32:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=MY/aJQJXPOpKk7ezNJRgPboN93+ijNO53q2Z/8WBzSU=;
 b=BBtE3lL1R/mv2aEx0DkbT6B47060w6kce8FadsfI0a1DzrJSRoQDSmnrO4YM/llgvEAa
 u6urxAEcrsRe5d0pVj9799A+qOzfyolPe+JUqaVUZUiguqANRdiLp1tbQ7v8BSb9TMAB
 cnaZ3MqV7JWb2rfC64B4iuaXA0vgYrIfoKKcC3+krLA+GQsEMayT6NrgvMklj2aBU6Yy
 r0/kOsBFuo/va24+9JaLOjKPU32NBP4GMTLFPMs4W9/jFWmr3aknnICH2Tgs3r5Jl4Ca
 SnDYg5j24yIkPTdSB7bzkXZYthN3VXIDOUwOAcn+kaQFCqAcKvgjvE8k6023dtkGvqVC cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3668qadcju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 03:32:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L3AfxE112209;
        Thu, 21 Jan 2021 03:30:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by aserp3030.oracle.com with ESMTP id 3668qwabnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 03:30:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=amuFoa07apHYvr3cKe1yBSeCrdIyuEeM0qHjGK3g+GoRPGZu+/sYAm+ssp7HvjsyKTbX7WKXfaRCOA1h6guGs/jS0GgF5sSyoDFLWGiIfHYZJiq4Rl6wQXhl8Ozs4BP4w0j4XwhuqinYrk5PPnh84Lmde83xpxkyRoLq3+ZmZqovShCwG7fdQx5LM2OBsQ42Gb/vLdqHMvzcr7Ccxz5OhrAEmTeK2kBxd8pIFXduHf+N0gUJkLjVaU0009rNvPk0KPv7YncV33iIjjBKoBjQsDc7Stn4f5Rib30h2H09s5mqxH2TGH2+1R/t+SpV2z96iynecXHyp4vZ1zmoDGyJ3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MY/aJQJXPOpKk7ezNJRgPboN93+ijNO53q2Z/8WBzSU=;
 b=j+H3rp+3zM4zFgbOYGFVsmOJ0afHUWuh/Bgsv6EblAmvHD0hAxkvA9Oe3YODct6Kb5ToJ34Q31v1h9a0GcTK/xccnqErKBzfG8zFjdkSpBbTVXEcOmSOR7rI7C82dH/0azo3f0uOXxKqnwJ/9lVcnGi28sbDOYOh2KGTqmeKAYGY17EjpatQZLR/sOMLNQd5qpBKzP1Nv/hqjQXEWrfL7EurUwQjHABDo/DOGYg3felXy0IDFNcBNOUdZI2cfTh2auz27HDr7MLHkipsUmNEh/gwL4+dTCZNS+v6xlCxgLPu/m98NZp1Xm6XSQA4JdsyLSJSb9F0tMqe8zHf4BXcxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MY/aJQJXPOpKk7ezNJRgPboN93+ijNO53q2Z/8WBzSU=;
 b=TYswQ3K0DayH+5wdnz4eCv6KxsBmou80wKu0y1rvhLR17dMuCAu4rL5pwThZwyg9KDhM4UdtD3IiNQM0yfPVRNqAKPjkey8tztELufo7bsvFDDLfUI13WTNKbk7AFBcGe8Xs+lCAgwnc5U/1/mFqZR9ROOicERkH7Se/d30gj6c=
Authentication-Results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4440.namprd10.prod.outlook.com (2603:10b6:510:35::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Thu, 21 Jan
 2021 03:29:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.013; Thu, 21 Jan 2021
 03:29:58 +0000
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>
Subject: Re: [PATCH v3 0/3] scsi: ufs: Cleanup and refactor clock scaling
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtx3ezmd.fsf@ca-mkp.ca.oracle.com>
References: <20210120150142.5049-1-stanley.chu@mediatek.com>
Date:   Wed, 20 Jan 2021 22:29:54 -0500
In-Reply-To: <20210120150142.5049-1-stanley.chu@mediatek.com> (Stanley Chu's
        message of "Wed, 20 Jan 2021 23:01:39 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH2PR16CA0029.namprd16.prod.outlook.com
 (2603:10b6:610:50::39) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH2PR16CA0029.namprd16.prod.outlook.com (2603:10b6:610:50::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 03:29:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bd9c62d-d4a4-4d1d-1f66-08d8bdbcd435
X-MS-TrafficTypeDiagnostic: PH0PR10MB4440:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4440C132B079C696A37145818EA19@PH0PR10MB4440.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lvqd3vk07T9HJfGOpUxAqzZernPQgrFWBswOYTZmGAQH8ZbXNkE7yKSXBPKQNg+xXoAcaaf+FbMp+fwtg0eghFRuMEhWHBtpziz2ZcHbq+iMO9MGdXAYwkVQxY3IXc6YieOysquL/xhU0Gyd5YNAjI5nwFmJ43sR4fNDef3fR5WAy8/auQJ/pqkkwiT36/b9iJ5Xu06OOUQ52ydOETsgpkk3MXdicsl/P5dO2Nlze5U2VQchM6MitOYJuoiDo8zD+kd7QekIjMjBIbQNAMvu1fM5qLJhh3V3c7VZfAglhV1PI/SdsSYVu1W9AEGYGkCFeUXe3R3/9C1ZIpHXUWjte0t2eutJ6eyvRFDpzyV/42J280TeOl9wUuHThVJD9ixVoZjWsWQFYIjRPWvIe9L/rA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(346002)(376002)(396003)(8676002)(508600001)(7696005)(52116002)(36916002)(956004)(8936002)(6666004)(4326008)(316002)(6916009)(54906003)(7416002)(26005)(558084003)(16526019)(186003)(55016002)(66476007)(66556008)(86362001)(2906002)(66946007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CK3JYwf6mHFiJ5MYLwVnME+rFqlQgu91q+6Fk33LQqfbvtCvTUgBBv7YxJnT?=
 =?us-ascii?Q?oKFKLhxKtf+jeVp1n+u8QLBES+Q+P0FRM2r0JItTsBj4izEErnxhsTHuWuvS?=
 =?us-ascii?Q?3KwFx56guH8ZK2ffzKc3RN5YLD1o1orluzhdI7f/jHFadl5SQzKRQhX4MsWI?=
 =?us-ascii?Q?o7h8hQLAxHfQpQD6MwlYhD/jACRBPqxtqoenmde5gGZGZTIfQrXf0lolej/K?=
 =?us-ascii?Q?qMGnSoP8nfIw1maVDuvr60SzZchh87WcM54EkAddjv6SqJdVbDl8Wf9Qy5dU?=
 =?us-ascii?Q?ePBss3awasFtnEpDRAqD5UW9VpmJ36aysDAg8Ry1hCSvy9oacnghrY3SuMrG?=
 =?us-ascii?Q?67Brx/MsHvzNxpcmPPEEQJCg5tytfQc8MU1DwEFocCEMHREOvF00qA1uRZ52?=
 =?us-ascii?Q?x6pYtkJS8kRPesWkEFSrRFiiRuucHGAVKUDypYm/DlgKGHtDtEGuRGtM31gL?=
 =?us-ascii?Q?sEgWZHDpTZaMrW1FnzkoJocFPANhpwqzhRlc9d0u1zYyguz4XFSaJfQ5kPGJ?=
 =?us-ascii?Q?pAWGaQH5lmPOLmcOPClS/N4cnOotFeCRBz0NCUR03/HW0UP0De3FXwvAiHv/?=
 =?us-ascii?Q?VVraRKkFP69DcHjB/5YcaRANvzwBbtwwDpJqmKl8IZutpNEQK9F0wrItAr8e?=
 =?us-ascii?Q?ymI9P8L5C8r/IZO2zwuQwLeYvUTMjLvYHyfC3+7VBlAKzqJhvF3/sP8BuGwn?=
 =?us-ascii?Q?7wvffAY6IFPXfImqfJZzjCmQQoQew1h3+23X8w31vhz/kJZ6Dw+BEyZ1xbBl?=
 =?us-ascii?Q?WkfwyxJkn1AXuwanjULRyagKYLlnMVvuEZt/mVPMULlsObEs0XY8OcimrKrA?=
 =?us-ascii?Q?MBRAiCXIuOxchL3QlYtQ+ohif5sj61+l0S/CpjrRjGobDOe7NtNn25zktqSi?=
 =?us-ascii?Q?ZOQ/BWuDKknXJnzU95+t0TlkPhos56iY3IY7/i34A6fcE5NNrfT7f9Flzu9F?=
 =?us-ascii?Q?EYeyE/g2qP7jSpZlFhvBZgLacDgrENRCO5DarO3vySa2d1Elyl6noOn/IkPl?=
 =?us-ascii?Q?GTHO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd9c62d-d4a4-4d1d-1f66-08d8bdbcd435
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 03:29:58.5812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ceo8OR4dHZWkmZoNOAkqeiyauP3N780CwS7vmMFQ6fqx8fbOWIYFKbLQLH7pNvvBRmNqXM5ejYkum0U6ZwxWA/OG3oDY2UJYSNlrUmeqIzQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4440
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Stanley,

> This series cleans up and refactors clk-scaling feature, and shall not
> change any functionality.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
