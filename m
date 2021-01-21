Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C0BC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 05:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D9D02389B
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 05:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbhAUF4o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 00:56:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46814 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbhAUDbI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 22:31:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L3UGXL194860;
        Thu, 21 Jan 2021 03:30:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=OvIvNhMAJKWz40HP0HmIXb5SFa0j0r77aKP0AyfPTu0=;
 b=w9NR+V2FAQNTbgB8MKQl9A8FGD8JSmgtJJps6QWfcgE3IHIiVODEhS3M5seDW84kvrFr
 2A5iljJvREtzeVGUO++qsISXfnQ8OS/vM78RjY4hACLCzZbcxxQVMo3/PjIYwkEIRRSK
 OTB8UliaWwAg8LfBTjuvu2b97d6MZV1xd0qWFZmtFzLvXzy0gWnn5TybZcoADLIYwaL9
 eCh+ZPeaNHdLXLNNPe0a+FTcfFB86jUgWm1XApV0+b48koXlL6dQdoE2JuSJMatB5U3h
 PPaMjhIfyFuGTvCnBl2Cfi0ssQRU2X0qra+AdLGY9+rI/l0OKclEcFytgPi8nUK3Gjes 4g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3668qmwcdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 03:30:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L3AgXc112264;
        Thu, 21 Jan 2021 03:28:13 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by aserp3030.oracle.com with ESMTP id 3668qwaabt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 03:28:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W4LI6TY+0psPCljNiNG7EhG1ucjPIsiCCOD3R12/ItV0tddlEhBh6Pe6iXtpN/yCOL0LjUo9wXBq0/v5w4Ua7zO8DHNg2qFtiTEjatMvp0zAIzLgggklQAZbNMe5GUY0djZTGi+OyC8Kcri3DXgd0omKM6k18C0M8eKsyqUplf1rSlCqKmlgWFVvw9mB/sgg3Re9qX7uu7hDPxLx/TQtsSVMGDMhbL+/OmVvCeKtCHisrYH0QE6ePJmE6pr1Slte3nwSH/fTlwH6hxKVP6qRMnvEf8B7ldYYWDqAFeEd5f6IC8A0i5KkcPnkX6556wEHO5DafTcMDNEQe3FTUcGKkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OvIvNhMAJKWz40HP0HmIXb5SFa0j0r77aKP0AyfPTu0=;
 b=iRQSAGc472VJUR1/Jxp3mLKbz1xPZOTAunTOgm7THoBjReg3rz6fT6UlTHnubciKFqEo6/6N/H5FV+rCP/TnLUK+gZ83VMOXkMJJU6XgiEuYnb/zWXNc8CzXNlZ7V+azfbX4LRGE3CBSPDY2mGa/8NLCKwSoxkGT1dd18TQjqXo1b6z5ICtH6vRUEKkiAUFe4XNbaKvO5zi6ABbzD6xd8ylmiVNx9hM96klCdxWDu2t3S7b9Z1YoBexypH2WSfFgMtUou9u8SSSox31PRGzCZmNaAh/MkdmW6sGyst4Jv6EgLgaxvFXPISCL24Q+UHpds1OdYuqcG2NA7uuB5VXWtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OvIvNhMAJKWz40HP0HmIXb5SFa0j0r77aKP0AyfPTu0=;
 b=SABBVoBiXmuHFhTvS1/VuCsklT5pUpjdP1Z+S9fewi2NxBrapHuNRipyJF/Pci9BBtW/4cyZxvXHbrPeHSRic9so/zh0xUE99tH7tTlCIqKDWMUhTI6UAOpfeQqq+2rXw7jWMq09Ut95jIJMNNbN4XKVtQw3AeI21SYYct3KJYo=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4440.namprd10.prod.outlook.com (2603:10b6:510:35::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Thu, 21 Jan
 2021 03:28:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.013; Thu, 21 Jan 2021
 03:28:11 +0000
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v11 0/3] Three changes related with UFS clock scaling
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <1611137065-14266-1-git-send-email-cang@codeaurora.org> (Can
        Guo's message of "Wed, 20 Jan 2021 02:04:20 -0800")
Organization: Oracle Corporation
Message-ID: <yq1turbezqn.fsf@ca-mkp.ca.oracle.com>
References: <1611137065-14266-1-git-send-email-cang@codeaurora.org>
Date:   Wed, 20 Jan 2021 22:28:06 -0500
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH2PR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:610:4e::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH2PR02CA0011.namprd02.prod.outlook.com (2603:10b6:610:4e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 03:28:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cb99e79-5765-4881-a059-08d8bdbc9414
X-MS-TrafficTypeDiagnostic: PH0PR10MB4440:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4440CC7617D1EF7B424E7FB78EA19@PH0PR10MB4440.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F6vm+K/MDFTY0i5CXaTzHksgrtz6xpLf9qGZxzRCPM8yFDZnducaOjtZu+WtLdaVzMmHuwZFMlW0F40BEx7+0xtxLNTVtCoUPblMsLu1Z3UwusP+0+S33vOUmC3ZHzJJmo4S+yYJpbmzsgunu7N6OszSK9RgJOUv2MfxzKWmylvKjDz3it6Zq0BVN22Q7TeyqlkRjRBaic0c6WWXSNUTV0QI2ZYMK+cZGsoOpQcz5JZRSSEz6DWF5b7yFKkMCGAkr6JyRuCmlZl2rPLfWUghNwMjgJUxQQKcNDhXLx+78USyeG0Sl/807im8JXnpLTOLNc0VzOFDeZENXA1jSBLmv/1v1S8+X1ndZg7D0wicgiaGCK7xu43QujnpKimIIOgAcvz/bvhtjCRX7qQ/K2xaYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(346002)(376002)(396003)(8676002)(508600001)(7696005)(52116002)(36916002)(956004)(8936002)(6666004)(4326008)(316002)(6916009)(26005)(16526019)(186003)(4744005)(55016002)(66476007)(66556008)(86362001)(2906002)(66946007)(83380400001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bfNxP+Y8qYsmswrNGDaKWaNdFF6mB28+6c/34YfXs5iBI3gToHqaQhCsvx5y?=
 =?us-ascii?Q?AHF/vSdsuuwxoMZOyhNB9s5Iv9cMSaXeiYnwfXIipbn6KWi5vAlindYRFZFA?=
 =?us-ascii?Q?tb94chZ8KHs/iEfKMQSV+ewpGn7+w9CVguSrqpUq3N2qyHCjGlgq5bicW8TB?=
 =?us-ascii?Q?4/Z32P3PJVJa0PkQmCBOdAc2cjg9gbl7CC91IlwnnlBiSGGBFg3mSM9EjwY0?=
 =?us-ascii?Q?L7QbsTsUNoszdc3bQApAD2e5fz4GcIIkAuPodN+XLopGRA6m1GAokzKFr5yK?=
 =?us-ascii?Q?A4+0CsipW506SpB89r3CK4Gu5+CkoDOWef2FY0n7Sq1n8Jxfux8XX6YVllPl?=
 =?us-ascii?Q?sCRY/QJrrvpNHhkQ0Oa/1s104Ea2TsvvudFfBFQLYy8nsoxWtJ95tMQaSqt9?=
 =?us-ascii?Q?XN+/nTm5iasGpYN8SQImRclIJenQL+xt9yUJPCNzjSEcGko+7jt+lWtiv5SQ?=
 =?us-ascii?Q?wxB/MMSeTihPn3aQCx3+UCcjTtamEt5OVs9lbsKvK8Eve4XeyaPfTlhcaqZi?=
 =?us-ascii?Q?wVJK/2e93PDXks55RDjhCtnvvVXDuDjbyYzfF7BlSutxTK9+1+pxn/3JGUev?=
 =?us-ascii?Q?g4utvM9FxST98wz9IJmJatiaHnXyTkfHy8SAgnvLDaJGcpPL2T1anRIqgAQ9?=
 =?us-ascii?Q?Q3MJkMj7TOy8sPgMuTCWxIVokklqX2S630zva2K5Mrxv6G3maQkyk9CrPT5o?=
 =?us-ascii?Q?Ric6O03rWU1x27QQJtxTOa+88YfalwBs3hlOLLsKUR3wDkq91et8LlfNBizc?=
 =?us-ascii?Q?hbs0JJWbmHMFIE4GVJUkIbXjcOiKnBU1W46GgK8bB5fKCpJTQH8SCC9XCBHM?=
 =?us-ascii?Q?2x9r3FEXwLCks/xrB1bTlqLuW49Mq9Mi+LgL1kh6JXAm5yk7PDeNDdkU82Cl?=
 =?us-ascii?Q?LmLxMLo8c7YhBbjCFN6pXzRCm4hBZL9+Rn821USqwmg4YRlqAqs8i3as0xVG?=
 =?us-ascii?Q?UtjXdlVqN1D477MgEw8CFpjQwD3uLNf47oQ6gHrgBvVtU5deEfagNyT9YuSt?=
 =?us-ascii?Q?IUYe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cb99e79-5765-4881-a059-08d8bdbc9414
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 03:28:11.0578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yLLwCGOV7BNdSE8OCVNatcWfsTNq212Z0inJVDEzIHJJxjH0AVjmhCfNYRGDUI2CgBSXv/+DstfdsWuzHmXvv7fcF61QlreiQUkBRzvLOk4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4440
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can,

> This series is made based on 5.12/scsi-queue branch.
>
> Current devfreq framework allows sysfs nodes like governor, min_freq
> and max_freq to be changed even after devfreq device is suspended.
> Meanwhile, devfreq_suspend_device() cannot/wouldn't synchronize clock
> scaling which has already been invoked through devfreq sysfs nodes
> menitioned above.  It means that clock scaling invoked through these
> devfreq sysfs nodes can happen at any time regardless of the state of
> UFS host and/or device.  We need to control and synchronize clock
> scaling in this scenario.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
