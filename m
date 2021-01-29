Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70A22C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 18:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28F2C64DE2
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 18:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbhA2S45 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 13:56:57 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44876 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhA2S4z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2021 13:56:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TIZDB3016916;
        Fri, 29 Jan 2021 18:55:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ECZ5MQs2jDi6t5wXzRN7YyY5RzTVHVcOsJMn9VaJ+X8=;
 b=BxT6xrDe0MiVvW1TYzGmXyj4UoE7Vcl2HW7OGW+UbxBjrz8M7WOYgXQu2pxRjAFjR8wo
 tfrnQsy+zAek/VcULxIZpmTkLnf+a0LNHIW6ZN4jTSeLNzd/AVz1/OM9MKq84fjflhe5
 WoKzFlwq8qzmCtiOAQXtmxsKOu8SflDrYU9hQsaTZdJGwTipV2XOy2YtkJX0+5PgSakz
 tdhVMRHlwEQqzund9Fw7Pp5l7YCm1V/Gr5w1D2K7kh2Xs5kYNJadruqVS4PCYWuWFHrw
 xLpsnxNN5YzHNGIshdikA5q2xkWZR00TCgz5xScjePoZVKJnmsVCDmsDgQ6f0zq8iB0V 4Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36cmf893t1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 18:55:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TIUMIL110017;
        Fri, 29 Jan 2021 18:55:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3030.oracle.com with ESMTP id 368wr2awak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 18:55:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ga4tamICCNflg1vjt+iHYApOFHuMtJDVVx0lycEu0mSixJXRdA6nDsp/368ZxSxm1odtSBMyVyHAr8NigfsG7OB0UNXMsuFEvaPp6hif2nCGXvzzYcU2Jq4vQtdHKedLuuHJWXX58cC129bCfNMmEhR76CYJ5sD0TvCwwBHfEv/MYMI1/UrbLu8iC4mujlFcWsoJ3BBWcv28BBQqHro475HHF5utZj31SzS8iUG+CIpUv1qGiOTzg95Aw7HG2imEpbmhNZdDZ3JgTgBBqIsdW+CShyOdcvPLP1RquBFXCAAVJoqzK41tL7QwdKSYZFgkNMzLLmnHvGSHpy3FVSmhJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ECZ5MQs2jDi6t5wXzRN7YyY5RzTVHVcOsJMn9VaJ+X8=;
 b=X/lMU9R1zdXUTwFtnVfMay9DiIDLrWr4uHDTyacY4+xMT8PbkDLNZjywNxmODQpfvsW8AOZJ4rsv5syMUsv4J62ZBZvgCFcfHxjq14j4D78QWTR/5bP8SSniOFmak5dDyllBF/0Dq5ucV1S8SHNPNG81sKv061nIEo4sc14m85RiYQhoVcmxBUgPO8eyOkuz8RF5ojuDv7xMzWuVKYw2tplo0fSyPVFXRN4FGsCnVAAJHmSKjgQaRqWH9YQ3kSZzH9po6ai31Drf8XlYxY8pRQqFh5K39+19BDZSKLnj//MKGYFfe4zm2Gw+VPpTUdL93ow2E9xfV7rtjl7TETlYJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ECZ5MQs2jDi6t5wXzRN7YyY5RzTVHVcOsJMn9VaJ+X8=;
 b=Ejym8AbOpNjzNeMGlfSDiqlNr3No6o8AiP1PaV5K23BWu2BUfIiWj9/KNt7fDw+Y4QXTkr8P9SNOjrdpXnOU8rHEgLsvq4PCTzUmyjPp9TlnFe50zJZIoVSRMzNLAMGcC3jR7my+dC9Q7sg/hn4T2j6Nj0Cl2FOM1+A8xkA/Byo=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4405.namprd10.prod.outlook.com (2603:10b6:510:40::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.19; Fri, 29 Jan
 2021 18:55:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3805.021; Fri, 29 Jan 2021
 18:55:43 +0000
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Joe Perches <joe@perches.com>,
        Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        Pia Eichinger <pia.eichinger@st.oth-regensburg.de>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: adjust to gdth scsi driver removal
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czxnzi6y.fsf@ca-mkp.ca.oracle.com>
References: <20210129052829.13642-1-lukas.bulwahn@gmail.com>
Date:   Fri, 29 Jan 2021 13:55:39 -0500
In-Reply-To: <20210129052829.13642-1-lukas.bulwahn@gmail.com> (Lukas Bulwahn's
        message of "Fri, 29 Jan 2021 06:28:29 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CO2PR04CA0169.namprd04.prod.outlook.com
 (2603:10b6:104:4::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CO2PR04CA0169.namprd04.prod.outlook.com (2603:10b6:104:4::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Fri, 29 Jan 2021 18:55:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d71fbfd7-19d9-4180-f07b-08d8c4877ad9
X-MS-TrafficTypeDiagnostic: PH0PR10MB4405:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44051B38E33FB140BFAE171F8EB99@PH0PR10MB4405.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ky28aii0hrdZm1brnVC+mZxsYsETmDRrUehgA+bx+Are+tp6XiCE4qCImNoDJpDgG1eMgAuMdzPeHfgIP8rIuPc+xeAeGkYiOgF4EYIxisoQ0H4f69d/2kCvT3foMSUpuJY/A06Qoc6GKc05edJzrVCdae4iHNWrBZHYVEm30aPdu5MhW4cPFFVWRfC5Tkgu9FgKDk8UMtmjcBhGqSKLUG9xghDjTd+1rTahOOZX1qLg/alElNla1HnJuAm3iX4VzGf4VgdcHv5o/hXzjSYKpn0f73kLdf2tCiKjhYtGNId1bXYUcgH9/wQurE2mjtlT2eZ4lvkGZzze4Ev6ZKyopaVqGECoZegiPMf8BKIJ/e/kc4DbrzVzTdqg4e+OWzrOuIacN+G32yDWMGX0biua0/YQkNl2ci/F9jhfAMepNX8vlEKHDXUwddcAgmwlto2FmppmCitMxQFb1xTc41QejZtKD7C3mXKk90W1mAIjMfGx0SSFD6nRPcOVYkhZOLqKT6/dIiIfbN6Kc9jZNOdoMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(346002)(136003)(396003)(86362001)(83380400001)(956004)(66556008)(6916009)(558084003)(26005)(5660300002)(16526019)(55016002)(186003)(8936002)(66476007)(66946007)(6666004)(478600001)(316002)(8676002)(36916002)(2906002)(7696005)(52116002)(54906003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ECMPF7DMoMmXg0Z3qhr1D8PIxOkt0tegwALo1bKqaw3SERtB9wfhLtxNfSkR?=
 =?us-ascii?Q?9jztAYlgtSk5trPdEjAOOcmX2dsYVXTTYajs4bGUawpjc7bdP0Pb376/reCh?=
 =?us-ascii?Q?pTCle9ZlCWySvJm8j0h2RZA0TKeczPdhstWBHz9p3ePJslaKF3OJfj3ZWA+N?=
 =?us-ascii?Q?d+8ubh4RBGWT/Y2zS9tmifOqWIV/QR0m7SIZtX/wHLYf6O4h6siZQi7PehM4?=
 =?us-ascii?Q?CgKggAb+EC4DscVv33oWZ9CjgbGeyx64g8I/gi4GgCqOLnIsdsfvqnhzjQpB?=
 =?us-ascii?Q?AXH1C+U64C8LCzwiKQbck+GVEjxeqyEoX2pvM0WpvTwza2DsA+tMPlZwUgsJ?=
 =?us-ascii?Q?pNu8KSNtsUlFHyjkk3ajMfdbES1AY+bwMl0bhMQG2lZ7MSkyL2kQU+SjeXVX?=
 =?us-ascii?Q?zwGdZ5KlUMceEXcynXeuAjrvRYaYCmFe14uQd38qEqGTkCfu5UBdjrGzsyoO?=
 =?us-ascii?Q?MoB6TInLBD0xHFztXYRmizqy1RC32YTZXWZpFGX4zfcxPM+jbnnXFoClz1cd?=
 =?us-ascii?Q?IRYsJzWbyPKtmzHox6o1pQSQNypw5rTcESetYhHKlsbor1gE45STNd2Vdp5g?=
 =?us-ascii?Q?5RzMttFEyOrkrjWgA8QkrtwZV7AWq3lB3ZfADjHxs3h/pfaogKyo2G8ggIB/?=
 =?us-ascii?Q?csVqCrv1CI4OljtH1MJuQKGUDZWf5q3B1S3OTi0I4nl0+JIZo+hs2HGZmDq4?=
 =?us-ascii?Q?FQ7bL71kbUC312UTijq7o9AS0NTMbAEPPpkNfrmqyWrRAj0YfWY08DdMhIDa?=
 =?us-ascii?Q?e8esEVe3XY1cqUmN1BJGaMx9rqFMy4bSWAlBNB3Sa1/Ika3zxu2/tox2jlmj?=
 =?us-ascii?Q?g91CcahssmOa/M2/6BCbZVhKgw/R35RkIzfph7i+5jjwuQHYg8lVIMZ0Ac4h?=
 =?us-ascii?Q?/VaC/QufxK08blvH0o+DGQ6bAm5k3nE1JMdMf8lQSj4Mu+6UM5ka4NpCZd17?=
 =?us-ascii?Q?Zx558eVSxSC+zHdtCXzbedun0qPduWd4QyG7VrrBQADbJFX+wfkAXAm3ia74?=
 =?us-ascii?Q?I5T/ZJjvdleZTKBjkdBcCO3a5qZcT4LULpz8W8Eoq4kKO4C0JIlL7fTAOWLb?=
 =?us-ascii?Q?NDu9dJnT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d71fbfd7-19d9-4180-f07b-08d8c4877ad9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 18:55:43.4862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zh0Fd/tYEBrhD4g0FvUaNWYf/cxb0zv3J01GnJFagL2Qjfdqr7UTecrTouqvbBNViB01TJMnO2Sfxrv/rNghWFmX0Gle5pcJDCbITkfFaZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4405
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=811 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290091
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=991 lowpriorityscore=0
 spamscore=0 clxscore=1011 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290091
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Lukas,

> Commit 0653c358d2dc ("scsi: Drop gdth driver") misses to adjust MAINTAINERS.
>
> Hence, ./scripts/get_maintainer.pl --self-test=patterns complains:
>
>   warning: no file matches F:    drivers/scsi/gdt*

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
