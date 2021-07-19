Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3724FC636C8
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 02:32:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18F0E610CB
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 02:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbhGSCfV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Jul 2021 22:35:21 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:12028 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233807AbhGSCfS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Jul 2021 22:35:18 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16J2IJbD032766;
        Mon, 19 Jul 2021 02:32:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=72OKZ3qDOF5Z6FnO535sKshmOUbSth0GUi3oVk2MzjI=;
 b=POYGEOmOdhjVQcIh7nMqHM3YUfYZJHbRRtFFZ7p4GsboHAvIdxcMKG+t7rLHVXMXxDaW
 IgbYGM86OdOuybaNmyTCwBtisIY/ct+diidRmwtMSzSweiL6mXw4EBBXrmclGUof1V8V
 h3N5w+kO3tqSe4Gshh2PRJgjChlLqC0uFwkrnsaVOoPHpKvkCErxsrcP7s/g9Whvt5Md
 ruN9JvwjFqoa4pRGk4VjbC8HXjoZl/3SHpfv5Zd0WzHSKDFIjzMkP7HLmmVwm20mUZcw
 Fv/UjmyPNY5a+TLa8Ptxf48ZSJDRTV2TbDfe0Av41rPTiv8Ms6QbIS9fkLGDQvtKIrz2 eg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=72OKZ3qDOF5Z6FnO535sKshmOUbSth0GUi3oVk2MzjI=;
 b=g73Fe8GXzgAkOD6nLPpIP6R+Mam+NobaFBwL+2XwjCCgCH27MNolx2qZkujkTSD0rXXq
 iJ3CrZTD5kqiH4HLyn4eG4ZXH0JKLGO0x2a5e5LlfR2iC/2a9I+uaRMZyh1nyVzN6BIS
 HiUTx2yScRYvrhzdmVzaQpcHtLOqFcH2izafUqYix6TSaP7lxSLEZUmydpavQfjSFwYk
 ZHvPGtRHIW4PRWQa3pvzslSPmMfK7P+bJbbAD0bs/ydu7aiQKBYQHUJhxTofF1NTEnnF
 7lw/sGw7kDHOqA/ITd57aGXznAjTVQJPxxbuQpYezkxdQA0GiabuWCaL2nvEbZYvHYo3 Vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39vpkwrcd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 02:32:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16J2EweZ142767;
        Mon, 19 Jul 2021 02:32:17 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by aserp3020.oracle.com with ESMTP id 39uq13uns3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 02:32:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evdCm/BNhWMdrNAgPDH6nhvYVxQGIDhI1Ti18l0rYQ4R7rMfux5/OQBEvCdM/Yb1RlPhjK+mqk54tsOEaveTrSmYsfjlSNQBcPLSUveLK/HY32qVpXurnXES8wtfxcDm8RpJqXKeKNdi7JkiNCIp/xCHWhwzZ1T9K75CWJqwND0sOxwaQnZaruMXWU44R4OoBD8yHbj8ohssp9T70d4+JuhMovMzJvLU4O7yj/zoN2sLFrch6XpQ0zsNusHSIgQ64Ajpwuqnc2m3+gv7HI16RuXgGOxAZ4MXGyCZnaOxjjfHjaFLtsRKPfLqcG1O++hN1BPvHeGGY71XYDpuEYw2Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=72OKZ3qDOF5Z6FnO535sKshmOUbSth0GUi3oVk2MzjI=;
 b=Mg9dhFp5dKwhw/9kOa9LcaZS7OrJNGOqle6Zw++3I9E6ruhCi5ykn3oHhbFdEWK9+++Ae+Dje+/+ACsg8sL3pIqVjXTetIF7M5xvIArV/PtJlfALnKXxtMRgspo9vBjpOI6bGOJ6Kat/36m08mPqw4cIIUtbZDaYFmC2V++siwjsOEI/MlB+s3IKt5aW4B0PwiroKwm1+mfWLcNM7msYzMxy7CS1DNWW/A0Uxr9DRHePBmZJ2MlD1LO2Pq+Kspi+ilnEMfmT1rKgG6t9LYgp6DmjRaxWBLujY4RPwNBs05lwnIDeYXkvSDdC+FwaA1ustZ/Mf/5RMP4SpaDNa6RmTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=72OKZ3qDOF5Z6FnO535sKshmOUbSth0GUi3oVk2MzjI=;
 b=TEQtpw1xLxNrA2Wxh58lYk0VOtQjj3OTSS6Qkaq6S3VP21eMPtrNp5q6xWuLKv5c11CDTg0EfvRrDRyNJi9iM0VdsQXd6B7wCKgP18nv1voGt1HQ1DlTILCOy5gOZf+OMsyHEwZwKyhYPrXi7VFveFJnO8w3XZFYHpbwMYRymMQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4487.namprd10.prod.outlook.com (2603:10b6:510:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.32; Mon, 19 Jul
 2021 02:31:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 02:31:15 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 00/20] lpfc: Update lpfc to revision 12.8.0.11
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sg0byqzd.fsf@ca-mkp.ca.oracle.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
Date:   Sun, 18 Jul 2021 22:31:12 -0400
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com> (James Smart's
        message of "Wed, 7 Jul 2021 11:43:31 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0123.namprd13.prod.outlook.com
 (2603:10b6:806:27::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR13CA0123.namprd13.prod.outlook.com (2603:10b6:806:27::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.13 via Frontend Transport; Mon, 19 Jul 2021 02:31:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e151c169-6446-4023-d089-08d94a5d4874
X-MS-TrafficTypeDiagnostic: PH0PR10MB4487:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44870901868E41359DCAD3918EE19@PH0PR10MB4487.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W6RImhsN+h3nTBZeUPFV83lZZm3WXfk5odkiEjirT4vK/+36TP+DrwKwrSaRjvSe4iHmcF08inbP3wbCI5hjxGy1nSsIAlTmTHkFpUR0uMangaazK6gEvQZH1pgSkeabSC41B/NdUfK4CeueTpUY8uZuJwKuIItatSNUrpC9CzbQSX9dFJ2gB99FQLPwjCE94TCGdQXmW61t9J7RT5zCsRdohoV2CSVaM0qdX6JKp9XcLqfqZ4sj6ASoXLLOReGphFi8auPOXw6uBQIXJIf9o5AvLX3fPqiM203rCqvJ3pYHzkgv7VdCvi7voxt4/w0TuJY7DqekXd6mXXvcNb50aQHus5uk3VQoxG8pQW7lu4wT1MsVk/1lCg6qpSu4Hmm1dwzf4X+5Yfi4N43OGycmdyu7Ol2GMuItkk9AZgz+lAn8A+Okg2nQli/w9aKjI0vQNYjtjnxNWDiSFqJZZK7BAToQJm4yKtF3BW1wMAvnTn3wsB1mwqFl6seH30/FrCOBZFfY/4WoAyYM679BACnt2rQsMuPzcsGFyYF+aT2HQ/9XiwEG/o5/mFIoX7K/mFmFElYykHAKvSCDIH0gfS77FQFyB3K3C5lIULSo5dp6s6alH1Csdk9r9T3tqurSVrNN4k/QUMvc+THP2Wv791hwp6cSnHJw+/alHIzMxPtQfx0/YfUpNIRN/GywcH++QNl+XPZeK7byxeeo6yW5Pkd1Wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(396003)(376002)(366004)(38100700002)(38350700002)(86362001)(15650500001)(4326008)(36916002)(7696005)(55016002)(52116002)(5660300002)(8676002)(316002)(956004)(83380400001)(186003)(26005)(478600001)(558084003)(6916009)(2906002)(8936002)(66946007)(66476007)(66556008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nXEm1NJJ+40Hr1iiqMUnLz/WvwjIRtnrJQHcj+eS1dEFiD7epM16+AHch9kx?=
 =?us-ascii?Q?TtVysV4kCIvUI1GBa1Mrly5jbIeiTk/r+lIg7pw7B9QrbyjrrXGWWXFp07g/?=
 =?us-ascii?Q?jRPyXEgi2IhjJ+7A32tj1q3bkxJqpwLgUs4y9kQE5QX4++FPL9SYZa1rJSMD?=
 =?us-ascii?Q?Ts43eDhfyg8668V/jVFtwqMc2k0q5L44xkI1/lidi0i2KsukWq3ULGWYsSoa?=
 =?us-ascii?Q?kWj5xdOAMUy3NiDVTrGTHKmQfZMjhzS7TMxgu2Syz6sMCjHlZW/KmYDa5uLh?=
 =?us-ascii?Q?XOn46r7klk9F4Gx2oB/tQWYgqJ5Kc5G5PjrlTgxYTjntLxGm6sH/vV8TcdNX?=
 =?us-ascii?Q?D+vsdroP9UeQUYogBMy8dvJkj06Qd9T/LaZjdhRWW+RIEX7cXbw1TXyMpbYM?=
 =?us-ascii?Q?1qADONJ24+aXW1GtdLttyEZn4+YQ3jqpbWVDaEdfDxQ3Upj71rL8F9IIOYEu?=
 =?us-ascii?Q?DdBAXpRxQVDo8h0i//bOwwPbR5W9yMOaaEEqHHmTnFHhGrhuLG3YKL6Uhld1?=
 =?us-ascii?Q?lMrb517MUcYNWAcQozyM4G5c7W0vn6z1cVGM2XFxGC1RVeJIib8dxEQxrTKt?=
 =?us-ascii?Q?98VGW4JqSZURZq7yg/D29sds5Zb2/x9nHurZ7Pljgs1BbZSF/PfXLXM2pByw?=
 =?us-ascii?Q?iD3Be2XIXgBWoZD6e6xUEIbLTHQIiyaOJpE/GTsygWOYgLOKMSneAKrL9VK/?=
 =?us-ascii?Q?gjghYqCJ+pF20AA4okUB4X+q1+Z6gP2omiyleHeknULgZ2BI0Ma3CWBHC294?=
 =?us-ascii?Q?46MIQNsuHmRZjePJ1L5AXqnYH9sH8Hz9aN+9D67BJkmojextdhplQdZvoFH1?=
 =?us-ascii?Q?53ALQEpxyWeIEpoWdXnE3sGIIXzbLRjCzqAStkDzcQYLBqAoYiFTNR7QtYZc?=
 =?us-ascii?Q?f6wiYqzPMBfET1zHWNyI0VMLGIa73JytxKaopNqUkF5es9mOu7g/SkA/DWv2?=
 =?us-ascii?Q?Uo92F8zff7i6fXkH1MOt6iBD8/ZexrbCLy+9qBcLv2mie297qI/KGN/BgGfZ?=
 =?us-ascii?Q?uFXuCbdRWoS2WXAZuKIb+6UOjPiJ+clnHYEL3pbkst5f5yA97Bt8zSkor8qs?=
 =?us-ascii?Q?6gbYLKaVH8Jd7BINVHF53wUJ7iWBsafcpxfkjnzf4MkgKomrOvL9Ui+COcFa?=
 =?us-ascii?Q?G8SOMMCobwzZ18yAvXNtB+gWLTl/sUGSSVjHNLJm6a0WpYR4j4CHsMgDP4Mg?=
 =?us-ascii?Q?5ixpWqoZaYvPHFfwDuhPWZNzCzPlGOk6RXD1vwjkfDDNX+hE07OQPJsjOm6l?=
 =?us-ascii?Q?8+VC3J+42vzvvGbQ1yk2trrAuL8bYlgaf6VdXMXmuzPsO+QU2Xhdp5EcIdta?=
 =?us-ascii?Q?yruJ3tpC6idHEmoO56u0WN4s?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e151c169-6446-4023-d089-08d94a5d4874
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 02:31:15.8580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v1EgSYXUKeqFBJvd/urFjHLIEaB7jOL3QGBiDo7HXoe9Ao9PTICP1PO3QeCOTX1h8BjOCf6475fPwducQissJ/GFxW+Mta7KHB4pJ/hfIzA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4487
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10049 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=972 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107190012
X-Proofpoint-ORIG-GUID: Az6tx0ST45g0Ey1wteQLfv2gPuvLd23z
X-Proofpoint-GUID: Az6tx0ST45g0Ey1wteQLfv2gPuvLd23z
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Update lpfc to revision 12.8.0.11

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
