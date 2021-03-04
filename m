Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA47C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 03:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1794F64EDB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 03:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbhCDD3e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 22:29:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36644 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbhCDD3C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 22:29:02 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1243ItrF006546;
        Thu, 4 Mar 2021 03:28:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=y759+fBHAXTKK4DiYYq5O62iHIHakuflLEfZudgZBuI=;
 b=nUzMxR/h9Noy1A5uNAKDxyJjbytMsm3NOpzNVbi6vRj5rOVzRRDNE1FZGiksD9D6bKt4
 dh7AOT0NoabEM5sahgDXLTzRF6voaBZge8PY/XOptY2PVwh38lJ25Ym0HSMX7kjv+q30
 o+DtD/OaSfT9EFY6VhS1vphifsEwvGQaO1gE5qCP1QCTZBdNnhsGO7uSceBUGA+UcE8b
 BG/4pFwSt6ud31DdczPatws7x/rCy4nqSJq8Jm0UXXM1AGL3XZjj1DZSjw9R2U02E42e
 JVsbxgw4W8wzGMWrZqGjzUQrii01iFikETQews5QpxZ9fbUhq8YT7fzdtDTc7f+3sf/Y ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36yeqn5kdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 03:28:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1243L4Wo013075;
        Thu, 4 Mar 2021 03:28:12 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by userp3030.oracle.com with ESMTP id 3700108vjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 03:28:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVbWxckWxi/gDFfO+UeInbfnYPlGEwvUU2gX5rJ5dBc36clNqDA6t7ZEehzgWFafK3RhMd6srg8xJBvfUDfwQwJVb1aivSBs/lI1LCCyVLbxuAGAZFGn0ckOGfHTyMrBdz5yqjc04ebgtsqExaQ72c15tRn7dFAqhBmTgHKy0b5WTBIUZzUU1i0khjcbI4d4tDznq0UEQ+XqTAx1O6pDEcnK5k7nMFh9TmWqyoTMOYi9zPyfI6KuSwewi96k3FxsInEGP2C77OG82eYUAwmpg3NfVS1BOHmZZnvEDYWPSFOJDXHtdDg5Zd/OCdu9EKvAFnP9km2pzOaglZVbC0e4ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y759+fBHAXTKK4DiYYq5O62iHIHakuflLEfZudgZBuI=;
 b=j7MBmBlxuheSgGl4E66RJzHnouyL5H0wKUR5jZDHOUNaa/tjlP66HMG0lcj3qpB29jfvj6ie52EiD5O9Gbgr9eaKe01zDTzjpQWphKXm8rZvnioOWUfFNYqunlAPVPIsKJ71W6XIlWq1wp5DmUbLveP6PF3rX+7HLBYke5CvVZwMlNjWy6xTEMGRlYCFsT2poSbBSCGLQoGK1p/ZHzuixMs/HrgwdzJpaHy1ge52TZC3NiDPyqkMpr0wkCv+2dEhxfI8W2hl5mse7ehT179wt/436hkogY7tn/l5armT70C+zlUKjosGYz/ont288/1kgjNrrDcVlrfOPq66E/XCBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y759+fBHAXTKK4DiYYq5O62iHIHakuflLEfZudgZBuI=;
 b=J6UvfbykpkdJY5+gCVut5aFdTGSmGCNPpIJWZNydaxWMF+5ygAptMwJfkf+cJPOQ0fd5GkyV++y6e6Uxl+jpcjbp5/ZZj9dvRfu8NfwAH2sUZ0gOGZgxTsVScDW4Ic1J1SmUihv8LwEYMCY7i/ozs3wam07uifKCkttvCYlgvR0=
Authentication-Results: interlog.com; dkim=none (message not signed)
 header.d=none;interlog.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4423.namprd10.prod.outlook.com (2603:10b6:510:40::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Thu, 4 Mar
 2021 03:28:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3912.018; Thu, 4 Mar 2021
 03:28:10 +0000
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, kashyap.desai@broadcom.com
Subject: Re: [PATCH] scsi_debug: iopoll: fix cmd duration calc
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtvjha2p.fsf@ca-mkp.ca.oracle.com>
References: <20210304014107.307625-1-dgilbert@interlog.com>
Date:   Wed, 03 Mar 2021 22:28:08 -0500
In-Reply-To: <20210304014107.307625-1-dgilbert@interlog.com> (Douglas
        Gilbert's message of "Wed, 3 Mar 2021 20:41:07 -0500")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY3PR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:a03:254::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY3PR05CA0014.namprd05.prod.outlook.com (2603:10b6:a03:254::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Thu, 4 Mar 2021 03:28:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6131a3bd-7743-4c61-4df8-08d8debd88f6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4423:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4423F4267C518139AFA6AEDE8E979@PH0PR10MB4423.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qhqUCjJTekK5IcEKFLe98563yhFrDJTELYjwaItl2hVYUwz4elvZ5mesmSgeJTNRmmKFO2ks3ZTrYlQ4RV37/U5k18SmHYYh9ucVnDM5E+b0RKDgL4B6xj76ysBtPO4vvvFAAXorzVcL5GSSbcQJX5wUI1CVN7jk3S0s5Jb1QR9ZJwczQC9PqbJSfMAosC5LU4CPfl3yAMpYP3iujN4mqmJ8dBRVH2uVcmLys8Nm7rG9a5ytfzjpXmf/Rs80ReXVyqxF5Xkw+YzpwzffQ/62jOWlyTzt3ebAY8darwsSc7jh7f7P+rRTwAtuCdsbVX6k4S0Iy7hKPv0QoNiUEn7VMsp39w/4gaxjw6T2GDejh5DDZNqrQjPO/36AEiQUk4aTQTwNYZPwsPK49jQZtOfL2budv1EIUtcDA4l0zJPjVsoMrJx1JJVJCFVTU5Qggh8stpkyfYN+QeQnR5W0oEZ3/i+O2BDMZALdLF5TC3QsrpB/gvXdmx6s/EmOUT+/alnLkF2GYXqWKX5jxAwCe9W/Nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(346002)(136003)(39860400002)(2906002)(316002)(8936002)(8676002)(55016002)(4326008)(956004)(478600001)(86362001)(36916002)(66556008)(66946007)(66476007)(7696005)(26005)(52116002)(5660300002)(186003)(16526019)(6916009)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yGmDPMeeqXrZyzqY8oIO9Q14D7GG2atnAPOiVsRIyu08Wuu/aQub/28CuxfK?=
 =?us-ascii?Q?SIj+31xF22OLtzh3aHfk40TMC78Buv7c1UB/WOMg9G5TIR+JQ0il2axAAeAJ?=
 =?us-ascii?Q?yjf0OrE0I2PA2WOsJ9LrRaovfPeY5DuI9DKPz8BVXCtjcIgGFYb7Yl9AnEWO?=
 =?us-ascii?Q?TrB81wC0TR704PTRUmrpLYabeGilUF2JE17oiZ2KGu5yDWnSIY8QvS8GM2Qp?=
 =?us-ascii?Q?M5kJYBhaeeR+mziKgsSlzwCuiEKq8VOg7JzYrD0RezNU/pYB1nSrGWWUbdRS?=
 =?us-ascii?Q?Z0kHK7GVm2azw8lkoLGxcECOGyTFMbe0gR+Oj8Y2eVQLjloQuD+5BxeZUyZP?=
 =?us-ascii?Q?woskWSGMTp1QMyuWuyM4IlRjL+YEhtx//2MwiXxVGZlC6Y1UE1+DxkIsJEzx?=
 =?us-ascii?Q?nFZMb+rfQ3fV/l58H8/r40UP1tMmCEQm6DBgt2GbPb7V4pJT2Kc94RSfayXq?=
 =?us-ascii?Q?pktqt0SIc4mRsJOn1t+WJEkj+9RNTRkmYdKBNo1eZnqWYMX42N/YVderZHEZ?=
 =?us-ascii?Q?GiVAayOzyjuwdzA3670hIlmGH5H7OUthSE80AVa+L1EgXff0avJqE3uzSuco?=
 =?us-ascii?Q?OI/tMEo7JZjBWuItVetC7Awq5kGaSBkyifzDF+kQKaSTExSaFvX+89Ux9lna?=
 =?us-ascii?Q?XsM49lnOuRj3lDlYzHGLNr7D3Z2b93CC7J5Fars448iJ78kqS+zFCSpqlSG7?=
 =?us-ascii?Q?lBir4EgS5SLdFmKO8mXw18RuaBOygGuCMBEsoVj5E8PSDz0yz/3YV3jvKyRt?=
 =?us-ascii?Q?2HfMbidGqJzq8JHMkRUBmfUUZHgkKKhdoqMidjTrzKXKDDC2koN8R061vY3y?=
 =?us-ascii?Q?6CcMd5K9z8lwYZIzK8WBytkDwMpUZ8S8IC2Frpmlm/5FCcEmy75a9SE6NWHC?=
 =?us-ascii?Q?eBK2iXr2CPLu9ZiO2ikqw4QJYuVXEnPx0NSywuzP2ABRFYT03BNjO3ZrqB1f?=
 =?us-ascii?Q?mUJaU6y4FXCFe1C7/ihqTGELAAZcvo9DRBby4ioy1S0eO/Q/9iVQa8dlPF+B?=
 =?us-ascii?Q?aIvovh5PU9eWVWtqhNDATeX9cSem6soNnH5b8D8ycM82SVwY8qaF8s+BrYBe?=
 =?us-ascii?Q?DndNmoSjNMLod9RCh4Otu29Z8X8pkJw34JtRGmoitb2aN4EM8VXgXU+2MPU+?=
 =?us-ascii?Q?Xeq0RkH7uCHTMqDeoQfCe8eUQrjEV0Zx0fY6i/2hU/Z4OmEonpgqzN2Yy/Ix?=
 =?us-ascii?Q?uRtfBGuXO4+taWXaZQLY2RfaevyhWTgUI6Otk+RTnoHEXLo908da3lGUQGkJ?=
 =?us-ascii?Q?wcflm++Pi9NPob5xuazldM+WRHVdW0u3/ppmQXTQHKiOFggREjhalRYi+1U+?=
 =?us-ascii?Q?2EGpZFUklGD/99hTbivjpcc8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6131a3bd-7743-4c61-4df8-08d8debd88f6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2021 03:28:10.1799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X7X3/OxmLxYBzX6vsE4EmLsfVCZKYSXSsxOY39o7dekSh8dKl7GchZcsUyyvSN/PZ57ZM5r6M/msnfs9OQzk57mg4ANu6+iib6BZSvB36d0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4423
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103040012
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 suspectscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103040012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Douglas,

> In some cases, sdebug_defer::cmpl_ts (completion timestamp) wasn't
> being properly set when REQ_HIPRI was given. Fix that and improve code
> to only call ktime_get_boottime_ns() for commands with REQ_HIPRI set
> as cmpl_ts is only used in that case.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
