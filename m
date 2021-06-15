Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6396BC2B9F4
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 02:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36BA4613F9
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 02:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhFOCaK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Jun 2021 22:30:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53786 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbhFOCaJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jun 2021 22:30:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15F2PbsQ178679;
        Tue, 15 Jun 2021 02:28:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=2AdNdsp18yFHK7hUy6dxb+Mrf/4WdPe1UY+ACxyCwlg=;
 b=xmmYlcR4lZaL1L1X3GXHhjJNI7AG/GMcZFqUw3kr6nflISHN2sgK+uLV5TIpdjRDzfCH
 EDqbrN6aiRbMlSREeGjfrX0UYetoTCFi7kYwMS48zfmx4DrldSPyxooZB42ldAganeEw
 LvDjU3rzNQFiVUeuj91jzg5LClZu6Uy9pmZME0vYWtUIJSVA2wJ8+llnDfT85SDlsSId
 d7hvgMPZZDYaAyRL42ThSgTCYWw3YWfnudgJrjyDu5ryKq4CJ2ARHyonFbD+XiL9ZYck
 JzYQLm7q5kw6GE696hTtw7e098Rzfif3w22+7usU+hOkKaVTFB7fQ50t3/Pf92iHsq1B WQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 394mbscx6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Jun 2021 02:28:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15F2FEhm064332;
        Tue, 15 Jun 2021 02:28:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by aserp3030.oracle.com with ESMTP id 3959ck33q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Jun 2021 02:28:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YmbHbMkjsghe6OQ0L7brY02rz/yOeDtAGfKEWpVxvqCuk3zV8XJveSLTJeoKpAYalTEZ/2hHNiBVv14TQTZghfY9yzT7WijdULaQBMNb0EPxUjzipswLVhIMyqzEtizB2RE7Ugj1U856plW0NfsO/0oy2QMckycaMzOYMK6kbi1ksMDKZek3Ipd18XRJ+11qOPZ1C5agLvFC5Yvsc4hVwIhdx3vOzEWNbCc+mP65vLbRZ7mhP4k9TFAQ0dOg4eA5UB7lu/MBtotPL11r/yX8v06R6ir+F4EeDUJv9Xk2AXkpz8kdVWfSADBBVFPVSdiWRTXmaP/TtTk7d5+KdvMB+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2AdNdsp18yFHK7hUy6dxb+Mrf/4WdPe1UY+ACxyCwlg=;
 b=SutuCByOwwbFMWq3GfKuV0voLPu5ZzX0gSZ/9cR5+0pLD3YOsTZpP0H7YbyrKJH+FhAQIr4qTojuBLo/favCdvCqejILD/2SfTmJenBi3tRQfOCIdfSzj7B8ckEJodvVXSvaVpZPrJSmd18XUpp8ohMIwjaR/DaNyONmZXzyNHFaojnhcpFz3m800jYnr/H9JTWOIuDvnoY6a0kjUhwNcDWILJOh7Gq0uert49VKfUOX0x56PA+AqQ2f002RGxV2PmNETztx+VCl5ba6CCSvcM2QSpR8QMMzbW2sX5q6xtNJF+BFGZpnVpC7dJ73gGoWxLG9NDnVBXjQLf5wXjBmyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2AdNdsp18yFHK7hUy6dxb+Mrf/4WdPe1UY+ACxyCwlg=;
 b=oB/rROEhUuLxPWkZNinNrbZuV81f7y5hTkfO6XZnjk2I+G6kxkcKpgur9mtFj12OsLg1vLMZRPQqt/q0y/a6GeEYss0kcxmhDm68V9u26Iz//5n87V1IUDC9Q9DN31wobKGIIOaQM/WNUovSJbwftTN0JlrcEebo33IStiEBZ/k=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4582.namprd10.prod.outlook.com (2603:10b6:510:39::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Tue, 15 Jun
 2021 02:28:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.025; Tue, 15 Jun 2021
 02:28:00 +0000
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>
Subject: Re: [PATCH 06/15] scsi: zfcp: Use the proper SCSI midlayer
 interfaces for PI
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eed3an0e.fsf@ca-mkp.ca.oracle.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
        <20210609033929.3815-7-martin.petersen@oracle.com>
        <YMdoondMcc31A2vJ@t480-pf1aa2c2.linux.ibm.com>
Date:   Mon, 14 Jun 2021 22:27:57 -0400
In-Reply-To: <YMdoondMcc31A2vJ@t480-pf1aa2c2.linux.ibm.com> (Benjamin Block's
        message of "Mon, 14 Jun 2021 16:33:06 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN6PR16CA0071.namprd16.prod.outlook.com
 (2603:10b6:805:ca::48) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN6PR16CA0071.namprd16.prod.outlook.com (2603:10b6:805:ca::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Tue, 15 Jun 2021 02:28:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a77f375-a4d9-4b42-3875-08d92fa53226
X-MS-TrafficTypeDiagnostic: PH0PR10MB4582:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB458276B49F6AD9388B2F6F158E309@PH0PR10MB4582.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g+61Bql6vkWT/le27DT0BKR8xL1nfWhyp4hHTfxwUqJezx9tfL+Zhud1n3gF+fCxFxHl+zHkYh6CS9ZWINekGZj+iak+wdo9/ghli1sByGlD/DsjjRcp/s6cwYPdrCRtRmJNawUoP9xd00UtVWLcx7c87HP7oGOHhDCdDXwqgJOyMQRtxFwHLgPxN+lTs3ZHdFeLvT6lVr7OfIZHYQBMpZFezJrhWXyWvCegjoQOUrj0l6VT3391rs+aXUOEBkNrJF5QTYSRqXo7XGnCi3ohqZfdX0ePM5dQCIovJ8Ta9CddOZZ4YyeaLp/q38pO1hGP5tzBRontHrmkywVgbGLkkDD0tPQqfcX7xCRoIcB2biqEfrIDbqgqwt3Jyi2IoAS7hzTPobAOgZjr5w1FMagNLKkzoDKqYNeQ3K7Dma6F6tio20tcIvZCGox+52y+be7X3AK1Szub8AZfgdTgFKuI/7DyTFRAp7Mebb/2FTTy8O1xAGsRF2+W5e4lhP0ePH2F212cXrdkSML9cl/cKEw2J0PAAnBNTuspMPeN7temcJY/hLE+IFqzGIKnlpoLMZ/1KTmjA8A9LcfRa2UjOJQR/Nm3IwGL0+k46jFFwrQDL04Cw6wH36243YMRO15nH8m8NOKBMImpLDOiK8QYYo4BKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(39860400002)(396003)(366004)(26005)(2906002)(6666004)(54906003)(6916009)(38100700002)(38350700002)(52116002)(83380400001)(4744005)(36916002)(5660300002)(478600001)(7696005)(186003)(16526019)(316002)(66556008)(66476007)(86362001)(55016002)(66946007)(956004)(8676002)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q1ToNW4JRAkDpFYLyEg7CNuygSnv55i5m6jO6o0+HK156o55y0bU+ETiqqwt?=
 =?us-ascii?Q?APG/328Pt+XCm0cVlJxKHSqQtv933pJFh5QbgU9y8S0RZGpt4VfmLo39gDL6?=
 =?us-ascii?Q?3l87jyMRQyEqN+sgSygFg6par+tND1mSmc7G3qGeKnq4slC9zgsu1c0Gc+wY?=
 =?us-ascii?Q?OJ4c1XadAW3iCcDVBgu1QX2ON/a9/Oc5lMdlJTeUupANXW7ofSFNeCACt0x5?=
 =?us-ascii?Q?0hnOMrt1Qn5XwSHn9qO4c/yDGVgGi8sQYXApQPWslUn1ZcKF3nK5xB8CM2m0?=
 =?us-ascii?Q?exsE128nJvlW/D7/SfSpfQ71Hhb1hdRovUQ6Zydc29/cuJiW1uQDlXmLTVYC?=
 =?us-ascii?Q?lAeLsP08z1s7J6si73lT3SQ4VKbOR03VkJWjs0UFAuZjr8KKG/ZEEDBrO37h?=
 =?us-ascii?Q?woITsl/3TgR8TiyIg5wWYZ7L3UuW2kfgGkF2n2/2eecWrTEglzxCYfrZKtZ1?=
 =?us-ascii?Q?bdt21yftLkPWMEPTFlNKqraahu9dAg/5dyfkDWvvNDWYwl5hj0NSfGlmfqpm?=
 =?us-ascii?Q?f7UWyjqR3Me8V5z4ajtLe/esiQrxgCHrBe4e6U9JACvjnVA+ZyNZElWwJzez?=
 =?us-ascii?Q?P5cC2Wylr+qihJlAbaelIeqD5F4YCkjyU2Zmdpu5LItYQi5ZrXzzsnWMBPJt?=
 =?us-ascii?Q?DORHm/gGKvoK18e0GI35il7AZ2ZxTlMhRGVsOVotqY5//Q0sktYvd4bOWJFf?=
 =?us-ascii?Q?OgvX4OvAZ/Dlr+71r9QGKi45h86PgZ+T/QtEiT96I8Ej12XKYswIQBAEk7Pp?=
 =?us-ascii?Q?7i6P1DfprAAo0K5n5hRCBH1WLsxdUbcAo7pDOR0sksR8Hga4nfHLlix8myX3?=
 =?us-ascii?Q?x+yjceewWY4jwtg/cOIsIc8VcR1kOuQzo3FkUPsP76fd102zVdbN1AdGr22V?=
 =?us-ascii?Q?0sYOvwNgyro5cTKJm2opETH7rFVh9PYisyoM/X1nCzIp6rpH4xg5Wme3AJxO?=
 =?us-ascii?Q?n/PA+eypc2Dozs8t28q14wdTah2ZcIe7y+sbvJeisEzYmpstkyyHEepcLBNI?=
 =?us-ascii?Q?lyCBo+M9NGxORSBSFajn3DcT/Uq0lTeNCc+A8mmuE6kQUrsi93CHze0RJxPq?=
 =?us-ascii?Q?IRa9smUNbyix7cp/Xs4+R4XF0l1GTmjOUQ5esfL3jHO6L8saSdd9kBI60HgQ?=
 =?us-ascii?Q?lu7z7+QCt4jUnZ+kyJSU++OPeQIer3wTwa/XQ2xH8/023+RDpv0ZCXh9B0As?=
 =?us-ascii?Q?2eUB+Qi/xEBOybvNMPCFplq2FRm2lJKyrQgw55vbrFuaLCxtujESwmmLPgNP?=
 =?us-ascii?Q?EvCz+BZswaTtwvUmXKlIyF+J++DkfwXujbpNHRtoeesuyYr4pHfcxpv3C1o2?=
 =?us-ascii?Q?Mj9vNLDrgvTi/hLDP4cEVbmW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a77f375-a4d9-4b42-3875-08d92fa53226
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 02:28:00.8285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ftXVbCfydWtEE4luLsPG7D1of3w0/5ozVw3DyjA4KFHQ5sDsbQRSAq01Rya7d3TLYsiFGXnZRkyvgf1enAy+Up7iY7UIRZE44IPuLQCXRIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4582
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10015 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxlogscore=767 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106150013
X-Proofpoint-ORIG-GUID: jl0KNHgB7JQuTRPeXBSAToyc1KvgRQ4x
X-Proofpoint-GUID: jl0KNHgB7JQuTRPeXBSAToyc1KvgRQ4x
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10015 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 impostorscore=0
 malwarescore=0 mlxlogscore=955 mlxscore=0 suspectscore=0 phishscore=0
 spamscore=0 priorityscore=1501 adultscore=0 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106150013
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Benjamin,

> please set me and Steffen on CC next time for zfcp.

Sure.

> Out of curiosity, do you have any idea whether there is any storage
> that offers DIF with a different Logical Block Size than 512 (I
> haven't see any, although, that doesn't say much)? Just re-read some
> parts of our HBA specs and we probably would be in trouble, if it
> does, with how we do things here.

I have a few that are 4Kn+8. It wouldn't say these are very common, the
16-bit CRC isn't that great with 4K blocks.

To address the block size issue we defined a couple of new protection
formats in NVMe. These allow for 32 and 64-bit CRCs, larger reference
tags, etc. However, these enhancements have yet to percolate down into
SCSI/SBC.

-- 
Martin K. Petersen	Oracle Linux Engineering
