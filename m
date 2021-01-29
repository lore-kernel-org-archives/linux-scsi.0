Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10414C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 18:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD48B64E00
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 18:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbhA2Slt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 13:41:49 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33326 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbhA2Sll (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2021 13:41:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TIa7oW017627;
        Fri, 29 Jan 2021 18:40:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=n5uUGHpHydbmTrzht9dddo8ei+0oNrIAoX0dU9e7URs=;
 b=d1/l4Zl+VRJ6ehcFbNgVcGZbO7vX8zOTtQzZGnleIg3y5aluIy970Stwjgu0tChlYZxA
 Eqwh2jfr69q8u6zfD1WGTSImGR6//CiZUSfd6+Uh4E3V3+ZGFw0dT3svfIg3Fu3Vuyb5
 3tIwaPsnu8YZbZy10+YnWjfakUacV33J57RAGGc7lJZrqbCyqc+tuns64L4X9fYgcvC5
 adDO9L3B7URLjH/5gtOe7LnoL12WMvKKjxfAZ9Ee7urroZbtB8lmWAE19zXChUg6pXJP
 f6Zo4N5Gmun6XIquWI2z7xxxtb34jhJwDoqDIgeCnZCTGzeD0HO6cQEDtcp+AHtjHjeE mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36cmf8925x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 18:40:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TITxxC157661;
        Fri, 29 Jan 2021 18:38:52 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 36ceuh204t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 18:38:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hs9jGkeV8Ho9aWoznW00E2DhcLLEmHi7g4VvvCHQL/9giu+4sgCAFbp+Ld/x+5waggJ9sS1QK1GtUXqAknwt0pz0joqxCZSBFgQt5l1baea/xwc1aiXCRlDP1Gi+PFBndHxrhhLDMqvfk1Od/S8mAGhRXjvBNoFt43rmmb+5gK+rEk+PzjYpUNqcKrfdur5VYLeeZ/oWPDrRDrhJS0JLNd8CYWc/wknaZ3kvIKpcW1HKymZGB9f1cSYhmIEO3MIvmADdgFXEHhJZ3V2YAiAMOS6OAWGl1hdaaSj698YT2vAy0Pd0BUZ6r5YNKiyxN6RVkFseK/UlwpEPi1F3ryOn9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5uUGHpHydbmTrzht9dddo8ei+0oNrIAoX0dU9e7URs=;
 b=Mk7T3T2YQ2W5Wske1F4rOu/QQNdyI1sUeBfXn+aE38XRfAHfIIpmG4JG4WjIKAeIMsek5G6DYi5Lz3uFeu6DcXzEYnscO2ewIoRFX9/uDBvgu40jkZ4Bqy+epTiezZFF8gnvGQuut+gKae6eN8qskmi5E7Yq6TC+e2VuN0oAnX5fJB037maCZPu81oLgQWuiRcHsNRVBli+1BJYsgBFgQ3FBrzNDzH/5eatbww0IbEUM28UTvSkSvTMq/9o5wxqFPYcEqpHC18IYPwhw/oxyD2KTNkswHRB/FCJoFKAIKsR+cN9hG0nWcwr3KGtdHFdodzF+Ao8UDwVzy2dMGrZWvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5uUGHpHydbmTrzht9dddo8ei+0oNrIAoX0dU9e7URs=;
 b=Fn07wMtDltnTHGhFKNsmNRpjSM9Be6xvhv9YOTX4CNZ+CX5Glz/BbLI0sk8ARJIVnwxaUyZm5PupTwCe58eZCOjXVOxR1NWVMTYCksLRKQ9TC2slSqTTFKdf+PFmK4ZYHr/AfUWPC6Klnw0Jvmdfs/mXVI9m5azSZWHmDKak1Gk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4773.namprd10.prod.outlook.com (2603:10b6:510:3e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Fri, 29 Jan
 2021 18:38:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3805.021; Fri, 29 Jan 2021
 18:38:50 +0000
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] scsi: lpfc: Fix 'physical' typos
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pn1nziz3.fsf@ca-mkp.ca.oracle.com>
References: <20210126211248.2920028-1-helgaas@kernel.org>
Date:   Fri, 29 Jan 2021 13:38:46 -0500
In-Reply-To: <20210126211248.2920028-1-helgaas@kernel.org> (Bjorn Helgaas's
        message of "Tue, 26 Jan 2021 15:12:48 -0600")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH2PR18CA0029.namprd18.prod.outlook.com
 (2603:10b6:610:4f::39) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH2PR18CA0029.namprd18.prod.outlook.com (2603:10b6:610:4f::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Fri, 29 Jan 2021 18:38:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7aee1d70-cc88-47bb-083e-08d8c4851f15
X-MS-TrafficTypeDiagnostic: PH0PR10MB4773:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4773F6E4677802514AF0C30E8EB99@PH0PR10MB4773.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dUENlYDqyhj+kDvr46mpp5L+z4CsHpKI3r5qaOYJTYBssLU/wh/s0COP3B3AoxcMgrEgXu2qWdolVFZABawxiInf+CEBGkomjYSF3A9N0Mbuo09+22+bSqvUaVpBKxtyzxoji7sLj66Dw8mmpR4wLRpy+BV0PtCiSDO1DWpZXVcQOyCPEvzV1t3o+2N2C+RtT8vszTSDi8pDkq8aJHHqdY9+cKYRrYkIM+htPbQote+aC2F1nzrz7z+DN1cKjFpOjk7GFYRdfdib9vFafwCyGjlplty5gG3CmKZE1eO1CvMJf5PkrvbfCp81ZE/nt2RqlKW56yYuPxECnUPbwscgG63AKS2UriJuWw219XbuQ+9Vzzm8elNOFhuk5s+nhsPWaDSvOsw4P2TV7m8lVx1f2/sXbUsHWmNk2Q0y1gsOO4doxdQ5koopj3Es6tlzJMY3seUiBQiRvgG04Srr3dL30FxuNTP5wGlk8x62gzvHUyxS167YuilkBvL+t8LufaiDPSZEgLoTKEcoiEwrhqXXMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(39860400002)(346002)(136003)(6666004)(8936002)(86362001)(316002)(55016002)(54906003)(558084003)(956004)(6916009)(5660300002)(66556008)(66476007)(478600001)(66946007)(4326008)(7696005)(52116002)(36916002)(2906002)(16526019)(8676002)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zeUGzuDcBfyXDB3cYYnSAgJ6bptRNXltLje1HEBms4JdStIKFryvjl3E1agK?=
 =?us-ascii?Q?pJK2Hq6XN3Ygoj+F3IbQDWn7CV0zmrQyCtCUYtsVhHrurEvOIWDE3cDg1rHU?=
 =?us-ascii?Q?5IVS2U9FJqpDdTN9V1xC0i2xix4KxpC7Z5L/TvuusPwozQXIhxwikBExSZeS?=
 =?us-ascii?Q?FBTo8fch3FLqaNkVKVEgWyox89vbHasnl+YytwBeH2z1FuFPbuHw1GjBQkTX?=
 =?us-ascii?Q?lMvqoz5bcsRYv58+76nH4UAj/L4iFRinIfk07HC1hBO4CRjveqXJqOcyQX4D?=
 =?us-ascii?Q?WL7Qav5oGUVGeOqu6iZgxnMcJUfOPS4rajipctUXXRSO1NkUovP8yn8RNJtv?=
 =?us-ascii?Q?LJAZJkaPfl5KmYB1ghhPZmKsRZmdSrL3SMzXlL8hYEJJdgpO6Ma6GTao6bLh?=
 =?us-ascii?Q?W412R8GqaNkbJXRjnKr4z1G7zMyi0vi7G9GMm+KPJixVu+Yd0UnxzQbJWS0x?=
 =?us-ascii?Q?COMm+FHY9GPioCwQV4KxBFBVvXW7qf1yqFfm2isJ7IHrR4FA1ZgAOkvQipFy?=
 =?us-ascii?Q?SYVs4RRHi5HadgUTEVbaQ7ntiIBgPVcE8dF7A3RLJyYE+SD2sgjAxxtdpOY9?=
 =?us-ascii?Q?qooVUexP3CTIFN+ghab+kHeXFJq1wBbJbAEycEzZOgr91AMD6t99KOIobv2u?=
 =?us-ascii?Q?vRrrcz5QlvpasBa5lHxo1+EFjIcFc0nNbVI0Yb2AykRTRNWJ6AcpB/lp3txR?=
 =?us-ascii?Q?SLqLPWPznR58P/+08hti4Fntzcso/Dbq6SW71uB59D5pCFyiDFvPeaHgnxwX?=
 =?us-ascii?Q?A25h7Ik3nxp1BwI1KUf49Q1jj/5pDxsHOC8RuMyPJyODIU3vzNTHapxGrTwf?=
 =?us-ascii?Q?/CxLr0wOGVlYkT8CV1GNZGZeKTgL7JrTnbqN82FRq2p/IVOJSSYVA/DP5vG/?=
 =?us-ascii?Q?20bdkCW8DCWitxRfDq0y2sDObtfqFp96WU2bcDGqgMal9KAy3MQ7Sgj2GKZZ?=
 =?us-ascii?Q?JbZVCBsYZxJjq4Rp1JzkKDF/5LQF5hP8EDg6rxSDoZxyq6Zl7CLqfrXbnxP7?=
 =?us-ascii?Q?e6FGMvX8dNKpAxD4qCnpWvsOxZ3nkB8PNveB7xJUEJjRLL0M9DgM26oTu7Db?=
 =?us-ascii?Q?3wAo7tcX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aee1d70-cc88-47bb-083e-08d8c4851f15
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 18:38:50.5346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k8cCMENljrobH0bhmihpS/3HEdZkufLu+eFEMXpWvQ9SiKwW6Agf1+apHWmbxFrHf0n+Er+WuwF3OxtErAo73UJjcZkn2rKCvFSeyoY9tSs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4773
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290091
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290091
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bjorn,

> Fix misspellings of "physical".

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
