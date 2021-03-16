Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2CC4C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76C2765078
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbhCPDOo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:14:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38250 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234590AbhCPDOR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:14:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G3Av9G075892;
        Tue, 16 Mar 2021 03:14:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=UINl6chfo92OoPWDURPZxrGMy7wTq/36a85TTeSJJGI=;
 b=ePdl3hBjvgtwH3rPYONGsF6MWSm5fXtNBCSzfqg+aXK2hTBsfLa4B6Nty76VOEYHtDrc
 RGZkh/fG5iYBDpxCOrKLYKBBtoRdQbgFNnsAuKq/5axtH3Hy6574TOm+6M5c3UzEEfcp
 AArLboS/wKcHdOYQWIy6WpGdP08r0vleF3RTN+KYjLh0E47ClUKQaop+RQMFUOs2xTOy
 cL+w5QRgnUI7i0usVO7SxOX9E2VeiL0Gxe4GkFZqABBtR6ImI9Rc/7HHPMmSvR5CL8eN
 Nt5WBjHEU+6TGUGrAFHhsM1rT4lKES72+FZ1QPpt9pPEKeZ0bK+cre5URzJTQO0zPrKN 0g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37a4ekk38f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:14:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G39dpT138106;
        Tue, 16 Mar 2021 03:14:06 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3020.oracle.com with ESMTP id 3797a0nadb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:14:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZYoxpECF6lnPRe0V+AYCQY/Y1phyLJVrCowZnYK7xfauBUF8TqiWbMX3dcmNGPpKVIVEGVBzCvYjXK/DYVl683dInTAvKXZvTZpj7VraQsEvwtLl4pp7pW8HzrBKt7TZ9xB7G3ss86xUeFrHM2zYjS3T286dhySkltZ+ro3223+E7CFPPzrcns4ziovF9NMFdqKuzE45S6zoSoLbc5gz2C3ToQ9rTDZnxlcA3rUi7QzCS1IgzoIOLzdnwf1Sw38YILMB4/h2hWyyGKHoxbuxpeCefc1FzFnd2tR9jkVHhpnI2O9RVIDrWZdpM1SRUrN59Q1S93ldWa1+22koSWT+RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UINl6chfo92OoPWDURPZxrGMy7wTq/36a85TTeSJJGI=;
 b=bdUQtx6s2m7EE50jlRlwjfd3kg+7uG/4JacNB9F2vBragOsJ4VrfZBYYYU7iBApJQ1KI2Sh9xeqzGXiC9W/IQThFpNmrq6eB+Db4UFuyC9dq+lOPleY25IpNCq9EIXZeSJJhwq0VpHti9tnmMeboU4g4gXiCZNKdiL3Tqe8ifHv6EkGEVl8qr2O+WpeOEYQ2GFSEU0NKh06xjBKKypmJZATZz2CPdKLvAg34+s/hSzl9qBmTQS3lNikve7usG3WYJ8MvWKQuWaHKBoruKl75oTYwSLphwy2uQ44W99R04rh5t8IcdZrFittcYXKTYcFthKE9FAKvtgsUaC19j/Z7xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UINl6chfo92OoPWDURPZxrGMy7wTq/36a85TTeSJJGI=;
 b=TwEgGF+K9UzYj6YwGU7Iga1RZ7hGdCcpbLLB308601cR3/57pV3Q0lOtAqhAYKIVQYbeutYrVZf0LdywzUkywjV1q8/yiROFWSVt/19670nSl46TVA8MDYaHTi8UGN3Z2JrD69z4I2BsEAKyp5dQqRIECCSoGZ/gBGKl88spbII=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4709.namprd10.prod.outlook.com (2603:10b6:510:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 03:14:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 03:14:04 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     hare@kernel.org, jejb@linux.ibm.com,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Fix a double free in myrs_cleanup
Date:   Mon, 15 Mar 2021 23:13:56 -0400
Message-Id: <161586434244.11995.15982572875490975002.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210311063005.9963-1-lyl2019@mail.ustc.edu.cn>
References: <20210311063005.9963-1-lyl2019@mail.ustc.edu.cn>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR03CA0119.namprd03.prod.outlook.com
 (2603:10b6:a03:333::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR03CA0119.namprd03.prod.outlook.com (2603:10b6:a03:333::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 03:14:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a4c95ab-383e-46b0-fe6c-08d8e8298ddb
X-MS-TrafficTypeDiagnostic: PH0PR10MB4709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4709F9AFB81E26358793221A8E6B9@PH0PR10MB4709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bbjDw8QiYh64/WldYvd4fGFdZTro612tXgnltv47OqNr6uyaNmaaISG6OvAU3XieUQMXcsQGEv3N0t46iqHeRp41uxb2xg/VFFtp1k2GJqPpIzFml8u9lTSLuQAFtbAVZHBWqkLHnD2Htn0ggJGfRIvCvdORGQxonz9CJ7gmTsAv3rWzq5U4YudLX9jOcoaog4IQzsTzz9DbpxokE1q2WiijnmGhVMX7ScxoiTN6eGJID7OZvA2UI7pNxGkDhvxWIoTpelPEn+38ANw4NBL26HQYFzhTN5Hm5CIBvRWaWNUTgg7X2oco1p+UgV50YpsOksUK5iq3y6ES1HcgKjw3TldJ4IUK/MW6evf3F/8bT8WKC4NQIQapQEIO3m5uUJ46nNk94Q9WNMXO8IUuP9Q3lItki9+1zTDzjRn8tUI4ofw0kXlHe9QTbEpsj6+f9QlVTro4IcYEB2vLlgKfdnBVsWhttN0bJtVd1v61YBDyFRoRn82JTO9BiFqiR7rPVDxvE+1rBGWpc5lCw6WPcW7rnY+mw/Cxgivv9V4fju+f227sKXRzICYUifIVWeBfaFDWsqyPvTPCrpe4cZIMBPMZbkkVRdgYzj2X77gJEPlYTfWAM4WweiDyYUVs/S395rIF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(558084003)(2616005)(26005)(478600001)(956004)(4326008)(6486002)(186003)(66946007)(103116003)(316002)(5660300002)(966005)(6916009)(8936002)(86362001)(8676002)(16526019)(6666004)(2906002)(36756003)(7696005)(52116002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y0JaUFBIMGx0U0ZYL3pob0RNYnRlZ04vSUhaVWJzUTJkNnE3ODB0czZiNFpE?=
 =?utf-8?B?VlFBeEpQRGhua08wbFUraDZ1K2EwQ0dwNnM0RXNCVFEwa0hXVU1EWFdCcENt?=
 =?utf-8?B?OFd2dUs2aTBnT3J4T1BhSFZiaHVEamNiamxTWlg1cmJPTVJSRlZmYng1TU1L?=
 =?utf-8?B?RWJEMGY3YXRzSmRPQ011elVPMngyc1ZpTkR3NWUwSXdEcjMwK1RzSi9NRG1Z?=
 =?utf-8?B?V0M5ZkxKQno2c1I3TjA0L3FMN25lYW1JRmFkRGhweXhabmUzMHhWak9hUUd6?=
 =?utf-8?B?cW5kSG9NdWYvOGh2R2lSV3YvYzRyZkZSZ1o5b2syL0pwc2lMbSsrUk83cFJ4?=
 =?utf-8?B?UXFQS0VlaWtmN0cvQVFYTVh6UnhwSDRUZit5Smp6QnQ2MVAzb2x1djNjYVBR?=
 =?utf-8?B?M2NTalNQdXI0MDdMN2NGNmowbXF2R0NOc2VST3dxS2lOUVNPc09qdHpVL3Az?=
 =?utf-8?B?Qzc0anhKTUdPLzl3MTl0Y2E4VTJWQmd3UGpPVjJrOGNoSktWREVXN3ZyZ0pL?=
 =?utf-8?B?c1Mxd3R0S2NaSUVVSURMYWx5a3ZBM1RNdHZqaFJrVmJXbjNuZ3AzR3h0ZnNu?=
 =?utf-8?B?M2VHc25Dc2ZQazhJRll5cWZ3bkp5VVExU0tac2xtc25uelBnM1FXMW94b3hC?=
 =?utf-8?B?cVJSMXAwSmJVTGw2b2dDZTc0Y29TVEJTR2hFajdCeWtuMmlpckJ1TGp6T0dh?=
 =?utf-8?B?bk9WVjdwWDgxSWpkcWNEQVlWekUvMkZOQTN4TitaWmo0VWJXb1FlNHhUM2NR?=
 =?utf-8?B?OVprZWg1UjdLUkp3c2hyOVg1QUZIZkZLa1ZiQ1lCd0MzaFFXZkFVc3VEM2U0?=
 =?utf-8?B?Vy9ZMDd0WHc1SzVSMjBWekNmTC9yRy9Vd1dHTUN5Z3dCK1RvR2x6QzlXVDRT?=
 =?utf-8?B?MG5VYWtMamFtU2NsclllY29Rc1NsQXRhckJzVGJydTQycjVHbHEyYnBOSTJm?=
 =?utf-8?B?MzM1b09rQ0RPT2xuby9mQXNxbVY4bGQweDlGdjRjL3VlOGRLZUxGWGhzMG9E?=
 =?utf-8?B?bUcyZldDU21zVmtxQmFzWUVvQWxFWHFNVXhlMG1aTDhwd3JWQmNEOEE2Q0hY?=
 =?utf-8?B?ZEM0ak0vWUhJUmd4YitjT2QramxGWXN5SXIzdng3c3lLOUdSME5NVS9pdXlJ?=
 =?utf-8?B?TXp4Rk5ZQWZIYmVuT05obkFaU1A0NW12dUMxaStxa0doSVVtNG8wTU1OSWFP?=
 =?utf-8?B?bVNvWUpmMk5kdHZwQ1RpMnBMUjhSajg3dVljeEZDY052c1MzQkxUQkZLbUVT?=
 =?utf-8?B?R3FkQlMzVlo5cDlBUUxtYUd1NTd5U2RZekRBNWtSZkRkeE5zNmk2WmxOMTVP?=
 =?utf-8?B?czdEZkZJMWJNQlRxb2JFblFsc2dJQmRXTXVLVFZRUHNUZHVlUkVYakV6K2NB?=
 =?utf-8?B?SkxuSkhzaEhiZWdKajZKWnAzZXREckdVMU5iSU0yRC8zRGpiTmpNUFN6Ym5t?=
 =?utf-8?B?VzgzN0psL21sQ3FkS0ROZktqWkxSd0oxbkJvNnlCSlo3dk10SkkwZXhaTjhL?=
 =?utf-8?B?S3E3cUxPc0lGY1plL1lGR0krVktpRGRDaEZGZkN5amdBa2laM05GT1lsQkpG?=
 =?utf-8?B?SXo3ZXRsRXg5SXFOYTNaR2RSU2dETENJbnVqRGFKTmd4clU1bmFPRlA0M21K?=
 =?utf-8?B?alFYajZjY080dkNNRHpFa3R2RUZ5RldrekxLc21BWHdrWjN4ZFpVa3lwclJT?=
 =?utf-8?B?NGxtRVlOMS9RVVl3TVdTZVMwS3A4QThjdWUrQ2ROc3pVRlhlMUJMaTQ1WjRQ?=
 =?utf-8?Q?hHcQASmdIi+cedmf6zOv+VINjw1CudFqin7sgPQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a4c95ab-383e-46b0-fe6c-08d8e8298ddb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 03:14:04.6025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b6IJlJfG6T1ILC9G7DcdslW0Y7BebgUfUvPbtu/beIf+sOFQoYdaTgYIAERy1lXLvvQH+HfDP5Dqh7qnx5JDYn5UOpQQvLu/zIQRQ+oiiiY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=856 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 10 Mar 2021 22:30:05 -0800, Lv Yunlong wrote:

> In myrs_cleanup, cs->mmio_base will be freed twice by
> iounmap().

Applied to 5.12/scsi-fixes, thanks!

[1/1] scsi: Fix a double free in myrs_cleanup
      https://git.kernel.org/mkp/scsi/c/2bb817712e2f

-- 
Martin K. Petersen	Oracle Linux Engineering
