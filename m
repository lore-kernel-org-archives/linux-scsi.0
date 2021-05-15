Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D245C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 02:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5FC86141E
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 02:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235789AbhEOCn6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 22:43:58 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51080 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235775AbhEOCnz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 22:43:55 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F2Y0vB105939;
        Sat, 15 May 2021 02:42:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=geQorn3F6OPGR2sZxuaU7fzCNrV9fBcCgH8jUTR+z5c=;
 b=jwFeDKje0JjQv8R6UGwK49DUuqaT+WYblalAgHxZsB1Sz+3+OCMF0Pm9Y8egWSBpggYa
 Q8ooY35TtJENutEzZHnjoow3nwDn0didJuNahhY3mcIPmLyLtkBY2qEweb4M+KC2CoMZ
 3FjZRxLxoLLmHXa6sZGtt5Qa4UK+j/4tB4xZ9/hJv1n//djrXgbVmM5I9gtt4ZHIQgkU
 ACgu1M2lmPC2NkvipFQill1SggW0uEyD11ED6qLFZw9XE0qKKj/GN5nasvfERYQWLHoW
 jZBSvJk1XL6R3H8UGRh65zpDRIb/SJwdT1O8GhjiqDCcIQEzFJgRI1tuA6v0H+GcQgdB yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38j3tb82hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 02:42:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F2eATJ125861;
        Sat, 15 May 2021 02:42:28 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2046.outbound.protection.outlook.com [104.47.74.46])
        by userp3020.oracle.com with ESMTP id 38j5mj02w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 02:42:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ki9EHRSSAnyEg8mLM6/zgONFnRFDg9khj+hEh3MaMBmAm/7+IfrBhyi8ihWllVw+L8ab8qvqDfA+vGTviN9HuKNIdN1JnIr7spuJEVVoJJLvvTWqiGI84boWvRR29Ez3W77vvlqc/eMD2JvNWCVXgGKmbL73KlQcfrkcm7rJWGGGraA838fIlF8cWCyXrhs8J7G3xFqNPSuNLfyKwbHh8pXAajSrmGgwuXvP5wdsGo9yhV/XMCe7tIXbcNsiyk6KosMwboyixh1jhHfNn8wYVGwMwW+4hKnRgq5y5qTBK+uhqS2dj1mhYQYaoiVWioWU7ZUk1IcJDAO3Lw3g8ChA2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=geQorn3F6OPGR2sZxuaU7fzCNrV9fBcCgH8jUTR+z5c=;
 b=aPA+bO2mvjxohWFuloR0EuXiSqAgHC1BC2NgDKenLzrpmSn9qVGWXuZBa+ALb2/ziaA8cQ23GryVQhCww8JBQqxNjRmhpLvDkvkJmW2p4B/PNiqxyYwSsgfPXvAJYyBk8Z5Gf6cLPdIUO+yrSYueyaSH/Ge242hLlu8UlegWEmIGLOClt9vhzy9/zeBs7BLZYuGcozgw++rZzqPZqmpvn4flQsdF/i3KrgRt5q0xc4klM36HVRwT/yNIj21hdKhq1Kdh3bGd2VrFQCx2IfOv6x9NucnF4Gh44LVxIrrB+U4yv7rBkdhvWTZAkdRA7sqxc1oqJdBOcI97oOsoDzUR0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=geQorn3F6OPGR2sZxuaU7fzCNrV9fBcCgH8jUTR+z5c=;
 b=B3Eldz1CSiMpaB+lWY+Ur+KZcmWW6SoyLH8HknypZhTDhU28FV79KsAOy7490a+j065pvMfaRC/QoycvnK/UpDiYY66p9wbrBp0QI2SOKzm+Y2adhbSQzK1JtollagABxv9fmHp6Lh8086FpTTCIbWNpqKSTKsulpYb4fMRxGAQ=
Authentication-Results: roeck-us.net; dkim=none (message not signed)
 header.d=none;roeck-us.net; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4696.namprd10.prod.outlook.com (2603:10b6:510:3d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 15 May
 2021 02:42:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 02:42:25 +0000
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qedf: Drop unnecessary NULL checks after
 container_of
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11ra8btvc.fsf@ca-mkp.ca.oracle.com>
References: <20210510041211.2051325-1-linux@roeck-us.net>
Date:   Fri, 14 May 2021 22:42:23 -0400
In-Reply-To: <20210510041211.2051325-1-linux@roeck-us.net> (Guenter Roeck's
        message of "Sun, 9 May 2021 21:12:11 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0044.namprd05.prod.outlook.com (2603:10b6:a03:33f::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Sat, 15 May 2021 02:42:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f5fa6a1-e523-4f3c-50a8-08d9174b12f0
X-MS-TrafficTypeDiagnostic: PH0PR10MB4696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4696062B43B1A14811B125838E2F9@PH0PR10MB4696.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S93ua4MoH6RwgmZavr0jCgYkOfUw0iyyQRWKZwj1j7RJ0I+VuCqPWcZbDL5D+EEe4N8Ind/3PMb8lINS+T8ScWR2ukMNDlS2z61CUX89GCadU3bVMs959bEoHndvBj00c2PiPfhBGECmzz2G51Qahv44ANSjxr9wyLy2lrs0BMr8mRxaCwJlIB2VLz5MoFAaSMzjTPOEs3cs/kbt4sZp4/PcHT+zfHuFvGPtEkfxVjgcUiJa9L02rDouea2k5EimYnuUR9ZRT4a6Qe8hXTZuxco9r1qLRY3OO4OwD5KJQSfIbR0JtVAH2Htw5geROHGdtpzi0ICK9qqc3uPkK3CYci0Kb7qwferJ/e96P7kL/+RH3lemhEGuKAGiys4LaeyXIfAXF8rYrHcJd38RZgZmqwNCt+5T7k4AStrw/NP5pIDpoDAthyS6mNdbnXjbY653pDxVNu5OWDU84+O3p0XnxtTIHQiC9ijNLcaEHWC/GkOzDZ2x3YecYM0L1pr3+Md1krCEsXX9ExBDQew0bS6r0WHGI7ROBjTwz/JNh31Tep2JB+QwLJCWh/Hcr9Rex4czyU9leOm9I6ZwOwDYlNk857kfemESMN4lAXykdhxZbCsz33UZFAnZ+tUwgbf1fsBw890fz6oerV8eVqfUKbLzIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(396003)(346002)(376002)(55016002)(186003)(956004)(38100700002)(38350700002)(7696005)(26005)(5660300002)(4744005)(8936002)(52116002)(8676002)(66476007)(86362001)(316002)(36916002)(2906002)(478600001)(66946007)(66556008)(6916009)(4326008)(54906003)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?J4PKiYxWVZudp7vo5OdUOM5P7WJMgWKOGLvujVa+HsoDwetra5Fl1ik3vp7J?=
 =?us-ascii?Q?mfBaH5uKZ81OJjPxmbDXG9yTYADwPjeR5JzpVpR9fXZqpvtojOD2jUK1y6Zo?=
 =?us-ascii?Q?C7IBtyoSWqJ5zxCZhu3hrbl3+YAwX523jHC9HQptqsJpigwUKSeR1x5MB81K?=
 =?us-ascii?Q?KaSiL5ApQxQIT28rfUco5fIemSIFZK4/F34dGGg7HKWHeV8q2Egll9tuqms6?=
 =?us-ascii?Q?TQX/xzYc2iqaYhF3On7q7DQ5T4fpuDxf4qyaoTH7f/PMwbr5tK4BJRPQDn3g?=
 =?us-ascii?Q?ZQZD8C0YpDhsByHlpt51j4Ll8pDodxoMFvDTCWYJL5Hv6zQw0s/Cmy//bTZz?=
 =?us-ascii?Q?b9MhZgLm0kzy7xmYibCx3yc2socXIwB1vZJ7aOmFoy8xHrWT59QVrDs4U7sA?=
 =?us-ascii?Q?8czBcZOioHTI7OE+eqmUh9ZjPlrL0rIz8vV35B8SDLkBlhBGetZewS8dbJ1Q?=
 =?us-ascii?Q?YjLNrEyv9Bq5OJwJGGCFB+68wjFEZym+0Lf7EjFLhtfoY2f9vJQ3zLWUHka8?=
 =?us-ascii?Q?zx2AmSB2ARH7ZatwzVMa9CfSs2bBK9n3U5tdY7jl+3ROGdDwt2LjVlsGQ3CZ?=
 =?us-ascii?Q?sOFKxXl0VC+HJDG4OtnWeJlaNqAtAUzzlr9Cizn/kENR33p5uCCUbdkoq3FD?=
 =?us-ascii?Q?m/iyuevUVig7b3iFMGjfG0Ib+LWRCeqZZ1WPfCXaZyI614eRYxDtNhC2pDbk?=
 =?us-ascii?Q?UifCoL2QEgUliRsZqLSVQM4DJqCWGLw/pRniwXZXkm43oOYp32xYE4hSPhUo?=
 =?us-ascii?Q?BbQVfuvD64LEtK5QwaTwej0M66dAFPruPNmMEnqpPuzFgtX285w4Hf7b57pl?=
 =?us-ascii?Q?uPn3jj0i7PX5Id+3akObvSX8a99eBdiBb2A0R0NpXA/jzYGluV/CRh6VQJQR?=
 =?us-ascii?Q?AxdgFFN1JfIV9IWFVGCdNKi/4HSqb/v60f30O7QSRaTYleM28WsUpoKJZrMY?=
 =?us-ascii?Q?0za/auaLEQr3R5rDU4ct9QlmTudV9XBhorJSBhr8u32rU6gT/8tbQhXPfBq7?=
 =?us-ascii?Q?pYGSEG6dqzBcgwpfHmwi9/2NmNi1wUFj/EvzcFW/ong/+xsO/BUGFOfSoiG3?=
 =?us-ascii?Q?XTtT10tQKW1QwB8Xn/++HfRA94wRFNbxpjITPNLAgzfoxDb+QR4vHsIOLD81?=
 =?us-ascii?Q?sUb9qeyIHzUh2Uq4ToKyxJ/0PHOFKUcZDHNUiV6l/idL4q51Hti9U1EBGC+l?=
 =?us-ascii?Q?nQv9USj8YUIqNAReIXdBdS+dee5oGMF6N4HuXPwOD+b7SQns3pnbkU/dy0ig?=
 =?us-ascii?Q?RucevvUg+GFkDonVbl8nzzs5YrWBahhjKI9KSGTxhFzG6wiSWsDXpvo5mPdx?=
 =?us-ascii?Q?d7CXNrbQ8UuKyl66yb6HsTTT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f5fa6a1-e523-4f3c-50a8-08d9174b12f0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 02:42:25.8456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JcFltEcqwOJ8OWGwrPmx6LOm+tRy90jRpxjOxWIXjtEyKp/kepgQjUWO8bxP9Qdj5HIkSMyN3LdfMFAnbc0H2SX2KWvBF2qWMLhTrXo+U/c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4696
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150017
X-Proofpoint-ORIG-GUID: hvliplZXumBsN7KUXWFjK2nIB5DB3j9E
X-Proofpoint-GUID: hvliplZXumBsN7KUXWFjK2nIB5DB3j9E
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 adultscore=0 clxscore=1011 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Guenter,

> The result of container_of() operations is never NULL unless the
> embedded element is the first element of the structure, which is not
> the case here.  The NULL checks are therefore unnecessary and
> misleading. Remove them.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
