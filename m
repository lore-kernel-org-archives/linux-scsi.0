Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38FEC636CB
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 01:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFBB361168
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 01:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbhGSBGi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Jul 2021 21:06:38 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48496 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233720AbhGSBGi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Jul 2021 21:06:38 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16J11e1W023674;
        Mon, 19 Jul 2021 01:03:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=dyqse/lOmor6eWtwnWwo4sw0DH2cu7ZYGjI4KZaHRlQ=;
 b=bjHdXhxSO04RFSPnossMVsIfxN3mUqYUQGS3cdCzMyvuRQcE6YQRIXzbygD6i2tlZE6I
 iMprTZovlt7iVOr3v+sn01vocpzgkacGP0MVB27p2J7sNuA+KiOwjdQeMTRgfH1hWPgM
 dJR+hHORnRuv7QtI1NiPuJ+GxQyqE7Zamw/hfWTvRoww3mHH2JlH4id4VnD3vPvmyTfy
 YEqc9pPO8ocYJg1LvoiaAlUJLr5D6xEk8rGVGXXKind/5yTgIS2DnQoA/u5NsMz54lum
 hOIohsPV9SPgXgtzC2h+UnJxVmr8Th8hmjesfx6JbaHWIpwi+OUBJHfAt5z8W+E+M5Mu dw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=dyqse/lOmor6eWtwnWwo4sw0DH2cu7ZYGjI4KZaHRlQ=;
 b=P9JENswNpu39BQvN7gEpF+t4yEE4nkR2POZmQvTyGwsCOM2i3CD+Gfg7VB3loOIl8TuT
 UlBFKIZtW1CdvpifJKKdVMFP4KRs2Etr9Gs06M9BeTSww0nzRYbMuZ5FmxJGX7yZGTXE
 SmmO4jk+js7hwWZ26770oRWxSnttuYx3xK3HvvaHlB70hiuXBhRap71d+Tc3BFG7Wwul
 4w7isIoFJ4GVDGf5Ndb6I/kKdKnQCkFlys2SRO06NGDscbd5f1vqU+gB0y56IFjfo0Zt
 B1txHzWqrN/4Jqc77gswH/YWhxSnswB3D9VITC7TSksP4CSin9mcle4KSJx5c0eBRdOU 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39up031ux8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 01:03:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16J108ZH191281;
        Mon, 19 Jul 2021 01:03:35 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3020.oracle.com with ESMTP id 39v8yrm7c5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 01:03:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTdTdZw5KqY54J/Abv6KHWkxReAvD6SNYj/eWGMGRpWSRCWLB++0WgtWRVLtTcnOERR7924sUuj/hcZqoNrWEHq/22YZF0eEH9310sFk//Z+boQ1vqB+F9dfeJ4gzMCT0mBqDGpZrL1VyaoWAA2Uq/HdQZ2JoqS+w0ZKgSiVNTJAe+zQLyJXlUoLlCt/REXVF9W1bcjBEPsKGC4CkxZjH9zVgcaUt5TKaBmjvy+RphdyimZVVpFSf4GQps7oO6AYmyJCVqkJkrCFHfFBkVRBrLdD/aH40cG6XJPtdzRz1tgR77eiH/GdlDJu/99WI3mvt8HBODmlCbyW388D7b31Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyqse/lOmor6eWtwnWwo4sw0DH2cu7ZYGjI4KZaHRlQ=;
 b=Gm2C6vWBHR8al/1YBdx6kvfaEgd1OEL0Fb3/O9Jxj+kBWXAaTecwfGmzo1YoHsHEQJUzw/z71TsqiCNNDjqHLnRxBW/V2WvrTisjNtRLzkRB6SoUuIiDpLJcXxzkzpA/e9v/EhID3Q0x910BEXf5JwpmdaTBkoB1ykrBEFgM3PNw5MtX7xU+lTlN9l9tg7yQItCzzomPSQimRRHfzw+nmG5QvMaxi1ZebZ5fxvgS63zkyZxQQNdo6u7JQM9tqgYswdCdF8OW216CTf1qi3ccxrYd18slRtcka+DKCSYbcQdbFlelKQxrnuhjziCDLJAg2nvwWY/AE5ZJK4Bj6ZFMBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyqse/lOmor6eWtwnWwo4sw0DH2cu7ZYGjI4KZaHRlQ=;
 b=QEnMt52GH5iIfZwhN8pI8Vb3SfMPNhZ0soK4qJZoWzX4XqQ0u4DPAMa+PHHbmAlkc+MmSKB+0LjWyKrv0i1vai0zCQhtPE2taucjbFQeDiqZFh+iCVlH0cD4+LZGJ4uUpCRxIqPSiQSnAQ19b+rd4r+voBaAYpZfexEGMExYPI8=
Authentication-Results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4470.namprd10.prod.outlook.com (2603:10b6:510:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Mon, 19 Jul
 2021 01:03:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 01:03:33 +0000
To:     David Sterba <dsterba@suse.cz>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        martin.petersen@oracle.com
Subject: Re: Missing message prefix in target_core_device.c
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1fv15or.fsf@ca-mkp.ca.oracle.com>
References: <20210630135026.GP2610@twin.jikos.cz>
Date:   Sun, 18 Jul 2021 21:03:30 -0400
In-Reply-To: <20210630135026.GP2610@twin.jikos.cz> (David Sterba's message of
        "Wed, 30 Jun 2021 15:50:26 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0701CA0001.namprd07.prod.outlook.com
 (2603:10b6:803:28::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0701CA0001.namprd07.prod.outlook.com (2603:10b6:803:28::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 01:03:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17d3e70b-f250-421a-6218-08d94a5107de
X-MS-TrafficTypeDiagnostic: PH0PR10MB4470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4470D5CEE4C5B2007C8983C98EE19@PH0PR10MB4470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4lht64yLsziqZE7M6s0Y3k7wKQjanehD3t0r9I+dcBzSD40Em08LMllIOq0p8FDgrPfERAipJ0PnvoDSAEercDrbpikHWKmn1oMwDztReKGvOeeq7//qiVNfhU+xcV1rNmKzhAt4zDenbcm8/b91RIQ5qk4A+GQJpYQarjojCFB+ZlZUvV/jB+2pmf0t5DMo8XlrkXaBi8SWFmboWge8OFKxZSMeGeIqP/RcJBAHtGEcCfYppn1nY+MEwPZ1yFdbCJcv7ev0+hQwXj2RgdQfPLh4u1Gedqea4OCSWLnDDhiBI89oTcZ8TT9O9n1ffhEkOIsArtC/T7xWw4AtUx1TT2x8KFPMAyZgqtx5RnPaptXBdILOfYXBMz0snNfVPEcrYbFcMBlKjqZjWW6CLNGyoJ7azCP4bwWYxPvbJBN3wxc/q/itQ+yaSU5xTzHtu/pfNidGBG4Lq/OU/HpE2Oj3BojhRyVyzBygSWKaWHw0RWqbkSvMphnzFvHs8ZSVtbqtlFJ925eRa6qFZMR01dKi7egXDsBXWsGdajh+Q4hDjwZLVteH4efjZ+QKWhtyiSpbuvYqT+Tn8JDeLjxXrxXtX7+RrUzNAEHEusxRs8syya4YiBbZFr8guKD9ufBBHXx8sd5ft2OFzWMI9yZpOqj+1lGHn4n7Xl+5oQxHtd7UR1VgqCymDqs8Q9NDCHBIcBIrUQrYA4ejHfxVOYfWgSgsqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(366004)(39860400002)(376002)(6916009)(5660300002)(55016002)(4326008)(8936002)(2906002)(38350700002)(38100700002)(186003)(7696005)(66946007)(478600001)(36916002)(8676002)(52116002)(316002)(66476007)(66556008)(86362001)(107886003)(26005)(4744005)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hWKEttpeidr4JrFMS5wtjR5XBA1YWK5+xv0wXz9w25BB7mv+jsL6vxjJK+LE?=
 =?us-ascii?Q?55+Uus0Q8rraz1oZtn6Bx0050CyvKTim6tqykZeOVuz/iPR3SEw5KILTvo1Y?=
 =?us-ascii?Q?49mPKNKwNNBit05BxYFxAU95UnCoZODJ+2oEd6w90anvjuWzP013hvjHkPGR?=
 =?us-ascii?Q?hLSAgh+KzMJVCxEgZXbCySrbeU8IzYDJpn4HOlvlG4nV9dDBVQYwQn25rsvV?=
 =?us-ascii?Q?6SkbM6bGKk3UkORlaWqTTLafMxF3SUNswaYU9pGgdvF4sWHxRZOugOV9wZ0L?=
 =?us-ascii?Q?FLRCv5+F+OrXKtYD8qWUqbFG11MDYe9u8veY5ChUfGHeC3/PCTtB+A+Z+cqS?=
 =?us-ascii?Q?5IRAYPDxrb5B8HJF040/w5ZDo09xULEFvcXgM8o4YVE3j84iaqQsY5LqIU5V?=
 =?us-ascii?Q?J1i8qyi5YQMMDV632nDdfQg8SnYc4lmpByfZoVrwF5sxKOgUHtMKPelk6n+F?=
 =?us-ascii?Q?aGmEZZq61Lj9QQOlw08oUQod55TbbTczYP1L3LLblL0CQ6lsVy3mwxwCSD0y?=
 =?us-ascii?Q?FWzIfO0DCUr90oJsxm/s5rGhzKM7Kq37GYM67p7mPw3po6UU6r7vvtS7/S7w?=
 =?us-ascii?Q?Uvb0wWbbhx8WKuTWfYi/p7XFeoHCfnlnWbg8H0xNxpXlXEFiHPzxNRJtbdNx?=
 =?us-ascii?Q?AqoPbnveAuUEdcXvgrN1DYpna1nGDBt3xCHe3yj37fP1M9xg7cR3Nzeoo7tW?=
 =?us-ascii?Q?ybVkAVk+qXYxdPt64HWL9rNrsEVOO8QSoqSAJn4zFaaRJxEpiVY9L0tEz07V?=
 =?us-ascii?Q?UYM7TkqtyGroerke2tQJvhJO5vKUPSm48jYK7fBG70ENoXDOFyiZle4k8MCe?=
 =?us-ascii?Q?Vlu6pPM0S08GgCu6teNdq3Vrzkk+Ad89G0Open8H1Z6cxG2YxdNDPvLy6rRH?=
 =?us-ascii?Q?W0UCmdzkDt1/rB/IT5148udQqxpgJHmaqzUkWGBpMg83gP5ed6EDVHX17P2m?=
 =?us-ascii?Q?7+zPn7ZSfZawLJ0VmrjbszLZKdod34A+y2PzVD41KX1YIfCmxXy/88ItJM8e?=
 =?us-ascii?Q?Imm+nYkjo90KF9T5upiZJjHQX4nbJOEY79ZPM9iTBr87c72Cy2fWvvMnHdS9?=
 =?us-ascii?Q?bxHrnB8/iluPqh59ofoxLamParR1JQVBBMet7w9untaVmCGZWG/nku0NGfvS?=
 =?us-ascii?Q?HyWFkqYbfkzKpfA1OE4q4pRxa+5R/ObnP0doEQW9FyP0jJGoyQ9fUD/9oaa2?=
 =?us-ascii?Q?1/N9FdG6gYNo//FnaJQewlC2VXtpN6Gu0twMJTaZJZdpUwv0KWXDLU3Akgm6?=
 =?us-ascii?Q?q0qyjcaHIhljotdXZ2AZ4hVIYT/Yt/OlB6OFTgwuKl2wm6uEjOf4erx8AoNo?=
 =?us-ascii?Q?yaDoyXNeD4xR9/lE2CWFmuPa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17d3e70b-f250-421a-6218-08d94a5107de
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 01:03:33.5910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QClBLrqaB9cRp2F+mNaKCDwscFh+Sjidrlf291XbLYXyOIE1mpphoPywriBX9mH42h1Uz3zoWVPzQhoDEoqOQPDg/oqtaWB4tWZsG2e4EOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10049 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107190004
X-Proofpoint-GUID: 9OXjXHTW8wYaL0QUXrdXyX3VxDX3hRg_
X-Proofpoint-ORIG-GUID: 9OXjXHTW8wYaL0QUXrdXyX3VxDX3hRg_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


David,

>   "Rounding down aligned max_sectors from 4294967295 to 4294967288"
>
> but without a prefix, printed from drivers/target/target_core_device.c.
> It's pr_info so the prefix should be defined at the top of the file as
> pr_fmt and it'll be picked by the pr_* macros automatically.
>
> I'm not sending a patch as I don't know what would be the preferred
> prefix, eg. drivers/target/target_core_user.c prints "tcmu daemon" but
> does not use pr_*, and there are several bare printk calls in the same
> file.  This should be unified in some way but I'm not familiar with the
> target code.

I agree that the target subsystem could do with some improvements in
this area. Many different drivers and components, no consistency in how
things are logged.

Would be a great project for someone. I'll put it on the list.

-- 
Martin K. Petersen	Oracle Linux Engineering
