Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBB6C48BCF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 03:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 560AA61420
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 03:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhFJDU2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 23:20:28 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20766 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230059AbhFJDSC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 23:18:02 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15A3Bewd007230;
        Thu, 10 Jun 2021 03:11:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=nZVgur3dNMcgin6TJfAVYLjCE0H74ULR4STZugMTXP4=;
 b=Evy577wVPDU4SLKs8pwhJ16m6v8wvavXuCviffnDp7KoqlVSSQmH8E+KUAFz5b6BUwhx
 UDmfWR8DvPYz2zYboo2l2YrkaxG6RrTfZutKwHA1saIvxqTG3tGSPR6qXEqIzlXBFmz+
 rAIzHFo5POT53Epgqjc0bLZDL4vHh+T+BDgalozOscoxwbf+YxFs1yjkyEc4zBp067uk
 GswwygBOW4J/s/q4tZsj/4LKao+x76ptNF0X2dh8QV/bCW6SoD/iUXmnzLbZyoXU7fbK
 C0rpZAh0+DURph9q2XXM26UCjrZRqKmzS9L5flfStMVEe6mPB19tzAXywZrCznewB9QQ Tg== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 392jmw0gk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 03:11:40 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15A3BdnC029349;
        Thu, 10 Jun 2021 03:11:39 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by aserp3030.oracle.com with ESMTP id 38yyac6jch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 03:11:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5vAe4eLfBiBHCZCyJ+T8rVjYTuGJW3mS1p4qatMw8pmpB+CqOFEguNHUrP+34neMRcNuEQUQ5JhZPF+pjMzLXa4kYESK23Sd6lkVgh24xx/pMXyaajZs3UBkQLO7TFmhdv62siyNKU1iuMSNcR0QI/HrTdFx0z9qbUZi6N/eZI0WdYsNRI8Y+fdMObhVDCwUomLnjbig8DNKspmKtELCerCjUvdZBEaNdZ/J/CLjjG6PF7hpeZjP6bLln2NkTdLozrowkFr2bAS5O1B9RHrX6ESWmv9xyWQt3n3e6WGN/3+Ea80DukB+g95qF2b0n1eA+qOoBZWbnz/EmF/qCSekw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZVgur3dNMcgin6TJfAVYLjCE0H74ULR4STZugMTXP4=;
 b=QMuADeXM6RHb9oLAMpyHDjv54M5wbBZFSJ0/DQBDWnwUw15/DtoMblmVfz41G+wUbpzy0fklM6tTIgy9oYKvYA6giZqMycoHjFOx7xajCIYlImNfGufC3Rak69v5zMCg7/vdl1C1IDLbER17riiV2bef2Pqv6OfjyOAf3w91QX1L/9j4KyYlmNpXy4VEuLMSE6WOXe3Ugqsr1RrBS6kOitSDQ817EjNqu6XAyrSGDqa0/5xXe9F0avUiqcxgOd6Y9PbiEP0VLOWOeQeSLa8TLQPLpRoBezXdxG/IN9BzpD6zVuJme/Z6L5MIlehqwKLQigb2+fnWkI1WCFABqOT+9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZVgur3dNMcgin6TJfAVYLjCE0H74ULR4STZugMTXP4=;
 b=s7ckfFrR9ul6o6lxxqA6f6sXF8WZGIHPCFAbfYSs3nlr0C5XbUWMcCuiMvg1k/2mWMJfZ4Y+Q+FkhwPiZJEmXvb4nabex6VJjKotQRZW9rrue0qi9SqzXeY9z+1iu6XufWF/ZWjVRtVlxMD2+zl7uiTWEbxfOXWwyvR/YCeZA9M=
Authentication-Results: 163.com; dkim=none (message not signed)
 header.d=none;163.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4646.namprd10.prod.outlook.com (2603:10b6:510:38::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Thu, 10 Jun
 2021 03:11:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.022; Thu, 10 Jun 2021
 03:11:37 +0000
To:     lijian_8010a29@163.com
Cc:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: Re: [PATCH] scsi: lpfc: lpfc_attr: deleted the repeated word
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zgvyfmdq.fsf@ca-mkp.ca.oracle.com>
References: <20210609015757.290870-1-lijian_8010a29@163.com>
Date:   Wed, 09 Jun 2021 23:11:34 -0400
In-Reply-To: <20210609015757.290870-1-lijian_8010a29@163.com> (lijian's
        message of "Wed, 9 Jun 2021 09:57:57 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN7PR04CA0076.namprd04.prod.outlook.com
 (2603:10b6:806:121::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7PR04CA0076.namprd04.prod.outlook.com (2603:10b6:806:121::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Thu, 10 Jun 2021 03:11:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17d5d72d-e6de-4024-fc2f-08d92bbd75bf
X-MS-TrafficTypeDiagnostic: PH0PR10MB4646:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4646BABF2C4B9E82CECA51128E359@PH0PR10MB4646.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H7EVoBsm1m75pPLPyg87nJZX8BmZ7Hs1d5xbHGcTS3l2bNnM5lGPfW1aNXFxWf3TaspeflxBz47oljAwPr24QpDeEIzImabRdItgHD+5Qpu0cCIQW4vgkrvudBNr96LYpv39nA6vqK4Vxq/3VyDFMPa3Gaw7psZNUZfCSAFtWFNGw8XTOee0nOFC6J0FInLE9N8nPHk3DdCKHNt8xmECo6g/vlu+IdpvZelBqvIC7toMK46Mjb2lLuvLWUXLxRu5UtXnaxY5iOo/tPoFHipR49Q4oNDdEftEkIy30tua3D9GS4Tzl6Q1URfw5kuaJNtpxAC9dAyp/iSvjg8h1UuYNA3F5UNh6bQQdUDy++aJCW04ECkFjXsM1y20JuUjFeoqDOtVIER1Xx+uCPmWNGNC9gCcn0hOcsIVB1HhwvpMsnubg1iltlfMs0+Itj1BpJAgvhyENZ91suAbR3KFk0j7fXZIRv1DzKs75ScMJEMYV4E/E2DJ7/Xz8DOh8bDO5Wj0fEyFvwFG8hn3buTZS0pmAFraiZxwh48Lf5uy3I/E5EzXAlg/aqpYADJZME8UrRTIV1S25IdZy3lbtxAgZa/FHdYOj2Nt2PzR/kUzBLFsq4XJSdjkcJ9QLaudQhLnatihhvBq7p+7c7JxBOZKihZpvooKe+D2IW5XFxWS6IutD2/9mEGXHyO+mFrcw2+Lnhb4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(39860400002)(396003)(4744005)(5660300002)(4326008)(36916002)(38100700002)(38350700002)(16526019)(55016002)(186003)(66476007)(6916009)(316002)(66946007)(478600001)(8936002)(66556008)(86362001)(8676002)(956004)(52116002)(7696005)(2906002)(26005)(1491003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?059UyRV6uUDkEn6EWigEfEUZ8hE5z8vwqZFwKRRZJBVRXBreLWarZsCaqUNV?=
 =?us-ascii?Q?3wIMYfmqOnGJ4CjZ4wwYQS4RpYHjzb4mA6eB6M3qUledvyYibRVVYBV+j0Bs?=
 =?us-ascii?Q?PFA2my5KX8GpSsApIWTnXA5nasv35VW8cSQsrNJ35wIa+tAavw3y8dFSnXJC?=
 =?us-ascii?Q?KA7nK0DNGV5ttAMrwJAl2H02v4jm9gimmf06UHPN8DLhYi6aUCQphaGh9JNJ?=
 =?us-ascii?Q?e9g2jr4cBi5H2L1S5B+aRrTgFGQNJR51poIg7I2B1yj1UaUcej8PqQlAO515?=
 =?us-ascii?Q?g1KOmxypvu535iIXjCTma6FYl0UA4NaQwQXZP8oidzwEtIKuqHMJml/fziCK?=
 =?us-ascii?Q?jipq3DAejhPogGPEFFIaVVD+pArJ0eKY+hu6fvtvpzQzmVSR3uib8fJgY0QE?=
 =?us-ascii?Q?R6GALpuyYWFkLDxi1qLPgg85p7hlcKZM4UvW6z5m2qg7ZeK5PK5e4sRuShUm?=
 =?us-ascii?Q?lgiyWMcEHIne/OsOQxe9FeDbV4CzhvysEGrnh8DLLVUn8CDe7fsGzeJq8Tl6?=
 =?us-ascii?Q?j0dRV3cML6ETedoVj6wme3nGM04ZK5VVwKA7UAFXYdhQ7HgxgXWV+LhuC6Ya?=
 =?us-ascii?Q?2SKn3qE9CFbX3OVy+bH0yT4vQ9FQtR773a5Udlst1b2uGJje/s5X1pF5Jq70?=
 =?us-ascii?Q?BwJXZY4P9+Ha4JqUBkd2vpk+4NecM3ffBO3JPHamPG4lHupLGB1l69TiWUGu?=
 =?us-ascii?Q?6M8FE2eQumq31m1zOxOPPPkzja7Uein5hLw1GT+YAv2Cv6ei/29KpSi4jiCk?=
 =?us-ascii?Q?qm3F4GWJY03AwN1S8FLeVwdVAIc4Gt7i5wpF4KYZg2KD2RTU4ctA1TQBAmJy?=
 =?us-ascii?Q?GGZSOnNUMLIgaetHN35UIHdmQpsTT3ahFwh+oIAacvG49e6YRz+CyO5a6DvB?=
 =?us-ascii?Q?viVyRRS7HoMOEIgRTY/o11MWI/x/eZznwUh85CFSzZDib9oTGfuArmOYQtDi?=
 =?us-ascii?Q?YjJr3c/EytJOJwTk8x06QaS4TrlbFXjz2yZtJ8xeBq/9ZYrlKZw4VobCTAqz?=
 =?us-ascii?Q?ZUcC/AW0F4o21i7ZNqXDZPAPV2vNxEEiRuA26sU+FO+pDkh90N4pClY6MgKY?=
 =?us-ascii?Q?smLojfhysfeqxfP3Rr+d4E9/w3sjhrzmeAsQz9oMHK/8aoKikktE9lXkCgY2?=
 =?us-ascii?Q?lrmsk+kMCjdB4ruNxWhlqaHWJW3Byr0OF4K5Rv/5CeVuLaIHEm0V50JsfXFg?=
 =?us-ascii?Q?9L3l7O9Qpt3S/6B+ZMC2PykL6D2V8pArCD4k23dIVKITY78XoiVML5S5DaqP?=
 =?us-ascii?Q?Dl4s7F+QRXgl3vqGp5HxYej6ZKKf1XyLGbdoEtAzfe/B2aAq1BtpfW5Vusid?=
 =?us-ascii?Q?m2SgLaJRC3/2fTjjsdPKmKIr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17d5d72d-e6de-4024-fc2f-08d92bbd75bf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 03:11:37.5130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EOnR+6SlwCNICdmNNwLJRb4XTszn3L+TJwNGBvD1+LfY8VHydXhNvd9xZ9n6U/SDcBOxlGZl0xEv/ZN87wfsSODZ+VUgVr/l+t5Jz/Kkoqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4646
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=840 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100019
X-Proofpoint-GUID: 1QGfzCx60M2XLXCrM7KBUM_Rrj3eYtHw
X-Proofpoint-ORIG-GUID: 1QGfzCx60M2XLXCrM7KBUM_Rrj3eYtHw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


lijian_8010a29@163.com,

> From: lijian <lijian@yulong.com>

Please make sure your From: and Signed-off-by: match the address you are
submitting from. Also, please send one patch per driver.

>  /**
>   * lpfc_enable_bbcr_set: Sets an attribute value.
> - * @phba: pointer the the adapter structure.
> + * @phba: pointer the adapter structure.

This doesn't make any sense. That should be "pointer to the adapter
structure". Same problem throughout.

-- 
Martin K. Petersen	Oracle Linux Engineering
