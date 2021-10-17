Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE641C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EEF461058
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244888AbhJQCrZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Oct 2021 22:47:25 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:58224 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244886AbhJQCrZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Oct 2021 22:47:25 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19GNc7Dm025626;
        Sun, 17 Oct 2021 02:45:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=6npf+wsGMc+YnSWkoZCB1/A6nFFOiWrv3Kwoo9eOfC0=;
 b=olpKlEs5/sz1OWvKpxKZRidh1mrlHBNep9s7kKzwf6H2NXyJkv98atCHM5WC0uZBSgGR
 +UOLk/Kj9gwafgSnGgX7W37vlOZCho0fXEjICOKEiDveBEVtdZfSTppQP/t8bQYPLYoc
 0No4VY4Ua7+xz9y6dr7aeB4UhYEcAdVg8qYglTC27BO89FuqhngJoX4r25SiQYNTWnWg
 YNypGaBPg5ISj/96mnmqYULWyPOJrLBTKoN8xfRlDn1jN43fLMXwiOR8p0Kxz0pq1aYW
 iaxyLeMlN7mNWZfFxqIbFXHnSdC5XkcrtbBz3jT2BjGHstSi3yjFgVnzoEYR5PKebX2H Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bqqjc9r03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:45:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19H2ZL90042028;
        Sun, 17 Oct 2021 02:45:10 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3030.oracle.com with ESMTP id 3bqkutrw6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:45:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPu9KUb7as0DEfgVRR7GOvJMIQdMqcE/eiq1a94qe5aNQ7+yKsRnD1gtEA80wVHSgz2fK9TJzsT3mbObnFz8LANRgG8r1VU7bl74WaraBUwnQCBpWn70XbVzDKklWCanN8e8PmnuUFw2p0ljGbT65iJ/ZkHFljJgiXp3Uv02zcOvgCiKHXsm0H6QgqpsuEaz5h9I+JztGs0UHweQAuY/00gl2cxNXYBwc6b6ImTPj12Iqk283FAMXD/ezN1y7sXfnsdvGopxko8uyOraAqsuPFueWT96KuvuqVn0PLwgZOgjKXO86GjoGNIdBEMkAH0mJ5bfwWI04XB5WQ5Ubx8j1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6npf+wsGMc+YnSWkoZCB1/A6nFFOiWrv3Kwoo9eOfC0=;
 b=aOGYsHmeKgIxn/UWJKF5UkffD0S6BSJmFuKz6TpvT+s5Ri+fvZpZquUW45ATpfxR+An274fSCVzb917N3nuzd/Wg21JQmwAi39IE2q7fcvqUYzhLq/Od6GGRr911knRXqrTyL3dbbD8Ns7UCFvqTQVC5SOghM1D9W1IYm4AjzESfeH8+pynA/Sc3Pm/2cVZLGgOWhRi4H+yR+RDzjt1YjNr7ETYN83LjUKBkbvDyJZRZPxoJ1QGPRo3zmI/4WFuQfR/OitU2NVfr2RpZqoHBBx8evCfk5+AzfDUItpI7D9gNCJsn1tmxpGp5TQKt+aDT0YpzIqVEgpMyw+GgnNJ39A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6npf+wsGMc+YnSWkoZCB1/A6nFFOiWrv3Kwoo9eOfC0=;
 b=XcVHheqUj1jHpfvpFp90yXPd8WQ+PMsi3PEu1I0vtkvOkw9aUWWFO8QDEQT0oY+9p/JaYCCZc/levPHA4sR3qE8zQS1Pmek/Eb6DRa7wGLYuyPUvFkQDnkkAPzL+krGn7EqaVAgaGzeLKGhgykBOKDScuCqsvm5s7J/+Y6fQf6U=
Authentication-Results: chelsio.com; dkim=none (message not signed)
 header.d=none;chelsio.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5530.namprd10.prod.outlook.com (2603:10b6:510:10c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Sun, 17 Oct
 2021 02:45:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Sun, 17 Oct 2021
 02:45:08 +0000
To:     Varun Prakash <varun@chelsio.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: cxgbit: enable Delayed ACK
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtn8fjyt.fsf@ca-mkp.ca.oracle.com>
References: <1634135109-5044-1-git-send-email-varun@chelsio.com>
Date:   Sat, 16 Oct 2021 22:45:06 -0400
In-Reply-To: <1634135109-5044-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Wed, 13 Oct 2021 19:55:09 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0111.namprd13.prod.outlook.com
 (2603:10b6:806:24::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by SA9PR13CA0111.namprd13.prod.outlook.com (2603:10b6:806:24::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.13 via Frontend Transport; Sun, 17 Oct 2021 02:45:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 774646a4-6717-4f03-270d-08d9911821a3
X-MS-TrafficTypeDiagnostic: PH0PR10MB5530:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB553036D7E505D0E62A1DE1398EBB9@PH0PR10MB5530.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ut/9++W58oLo94T1/JdNPHl6ft5zdydIXWmR4rSqILDuPuSGx5i6g0pFti2AYGtjZo6p8RIovDFdRJGZW0wsbjxZPe4bu1IzU9Kq8Vlq4BFT1Iul4i6EchGGVfh4rs+6E3ve44KN8ojObLiayTK1++ZiKpJJMvG7Xoc19CZuYptuFBtv6qmVVOmdPkUDaz4e7zCPFSj0j+T1L2z21/+phKV0KKXazfOCjhxnRHuu25xGa2JbvrRrbTcP4NTaIYWojcOLTeW882nkNx9jkthZ2zkN+jcVqDbqwkShTlSEKiQw3NOSqjN58Gz6FXMuHLgcMFQtwPhz+EWzFzHyEvVJuqA+C1RtloGxZW7uTbVG54d7BYXCXEIK/zSU6KzjEShX/s3aXIo3hP4mZZ6QISeIi0YuXah3EdT47WwWp1hAUnvSS3vdaGrnRHX7qrmfVKvZKPQm4f0kkWsoSS+T2odaG9mBt/chh3PSBPO8UH0aHfcGdGkF02RJD1pgJinuyYBxZD+z/10Ttb6/U3iJROnAMoy785xCXMH62y3iQRetUjViSO3LazHdQWxx2EiKKNGsXb6c1/1T+dYweZBpocU/jlypThvrq7EpWkPzs4Pc1NUCg31TkUZ0qN6G3kYSPP88UhZpd0UWmCE2PjzVogd8hhZAwgslqSTrih8zDaXpEwAbVXrW95oTgyRthe14LW78hk4ovBSFsb/3ikpbOiDpnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(4326008)(558084003)(2906002)(8936002)(186003)(55016002)(508600001)(8676002)(38100700002)(66946007)(26005)(7696005)(956004)(38350700002)(36916002)(6916009)(66556008)(66476007)(5660300002)(316002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I+Utqw4TXSvzOlj7mpVSEzUev7VVjP5T9OWtwgURmW354Fa1gj6rB3DJzucQ?=
 =?us-ascii?Q?bkTlOLI8l/ffauKqd6iHIiw2XI4JHcbnwK1wvTS7IR+y3/2h1/ABrybHx5ek?=
 =?us-ascii?Q?ipAkhzYVx6iZAm5NjAurvwDHbcGnvWJsoCztbmmODydqAZJNFMA8Dv4tp9Pd?=
 =?us-ascii?Q?XXGhASodzPHMwD17NThOzj1onRTkUKxkwUKHnVOGBirH4WP8iP8mNz0LKCy8?=
 =?us-ascii?Q?DC5GO56ilrGu2e8AIDgK2auaakIU2rSgJ0NAHw6FJtOqBIe72711GZajAGw9?=
 =?us-ascii?Q?PFqocIdKbLmQbqjQs/2TBb4qMj+hrPq2vOg1ZP4u/9OrQomFMendLFEiOFmj?=
 =?us-ascii?Q?1FIyK2gzDFkBPlGgJlVSkPUfiENk+ya2BQfKx0w1V85+L7EoKpkIZvQARJPA?=
 =?us-ascii?Q?qQZP81sEnOQcAOo2yoFY0esbAZqtbbK0zSGMLjIjOr82yx/bhxUm/DgJeoWV?=
 =?us-ascii?Q?ekkfRzNaaQFwwK4pSNhONFWoY/l4SiAe4VdLB/VXNMC9gTqUcxM4ltkbWo/I?=
 =?us-ascii?Q?ZR6xHlPO4RuIQFC6SaL3w9MHO7cqP+I9TMbAAOP3j8i0GN7eMxFOyFbPE+lg?=
 =?us-ascii?Q?z8ZgxuQ+ayAayKHQWB82FXSzREjbHuh9a3lSXo15vo9mWgbE051ffhVI7jIh?=
 =?us-ascii?Q?4RJT4mVeFsNX6S6duxxZ5azJvv9G82rfDloXP0PC8ZEreDXBQAXdutYPuB/R?=
 =?us-ascii?Q?kqLW+I0qRB+ISf/dja8nFUUrHsLqv6JuTxyi6bTSHTTHEvLPv0mKaW0h/9Ct?=
 =?us-ascii?Q?vF36wo//7DS2wnn4Cx9ymngT3r7BZHOCT1PICWnqkjq1ocGvowmQvtpEu5rE?=
 =?us-ascii?Q?zLpITBqTqST6ai/Thf+hyIM2uJDMdoe5rh5qG0pX6ykhfb0GXz9PrxkhmDvF?=
 =?us-ascii?Q?ciH5lt05xtI/EtCFM+geQRJwi7ORxC/UQJaNNmlFB37XEE9VFl85IO6smCwz?=
 =?us-ascii?Q?Xg9cZ29D7jO8iKI9I2yOXfSwnyMwz3w4IKb4ws4PX84UtNR3mfYg0uzj1AiU?=
 =?us-ascii?Q?uxYUF6jnIbeo1ziatE+QFYinB4GZU3MNWGiW04n6MmQlWtL4DH/gCCNEcJWE?=
 =?us-ascii?Q?XkR9Is+5qRBGgKtOxfrhfD2BItxlUS7+DtXorM4NmnG3GNvHM7nroeQqxRLa?=
 =?us-ascii?Q?Iv95icLBAnR36fSCVepz5KJ2G3A9O9hxCvAdukV0WDq37ydoclNMLxmLZVDM?=
 =?us-ascii?Q?wgSwGveCfJJDfqGOeHj2xkcK4Gw4Mf7A0W+bH1U3BpcvsnA8+eII3MtF9ymN?=
 =?us-ascii?Q?WegTbspxhsgyr9VRhAlY3lp1qwMs3sqx5bHRwz3wXecgvnQ6hVQ/S865V6kX?=
 =?us-ascii?Q?W2+yCjMlhuVrSZ7IVCoMCP/R?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 774646a4-6717-4f03-270d-08d9911821a3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 02:45:08.0702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FMwrmKVCscVkhIIhGpCuXZXhkdT2Jd5kG0xQ1ZaMOuB2/osa/rovL0Zk8cD511tNmlYT2HGEWw9zFBmkrobMwaoPd7dpgkQBtPio0cGDs4A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5530
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10139 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=810 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110170017
X-Proofpoint-GUID: ISfDJ4y9omoxEXvrj5sXXeNXqqCfaSqH
X-Proofpoint-ORIG-GUID: ISfDJ4y9omoxEXvrj5sXXeNXqqCfaSqH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Varun,

> Enable Delayed ACK to reduce the number of TCP ACKs.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
