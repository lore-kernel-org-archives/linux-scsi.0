Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09521C63798
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 18:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7C1061380
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 18:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhGVRUl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 13:20:41 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:22150 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229878AbhGVRUk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jul 2021 13:20:40 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MHv7Bj031165;
        Thu, 22 Jul 2021 18:01:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=2H3TSNyah9ocGG/YF/6p1pi+Kw6e1lglgNh5DUIY4qo=;
 b=mCw9TXRT4CtW+YDv5W7WknfcCx/RPgvB5U+CyfkEf5/hXHAFmUA22SsL3hxqUcRQPXe+
 q89trQwu87BGf6P03zLWsyrvXrpR2t9qb2CxZnS4BPq7tOwnG/wPESwvA9ZlSAPoC2re
 41ImRsTmj2bAFV9/WMrxnIMd4aV1e2hF8gDPYHS6hsZfKQ99gmWEA/RhcWNrToTsfi3+
 k0VeSVwgmxWU8sbyMIE2oMjYt69ItKFPkWLKX4okIWO5PK3CDZvVV+RQDNcSfs4y/YZ6
 qiNzCyF+1qbFQHZz2bWSlTcSTDccxq9Eo+A+IKaFm/z++2kQQhIkawnN1RuH9lJCE+mF 4g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=2H3TSNyah9ocGG/YF/6p1pi+Kw6e1lglgNh5DUIY4qo=;
 b=NcZyLnHr7DuBArHKQVW80FE2lecANQfAJB65RukGBzAtz3tl3KXDKJx5GnsC6ZV4oYWg
 yJI9I0uJTe2qv4JHJ3Q0MiqrthweX7C294Zl3lL2Mnzq+i8b1vzyyP3oqkrK9B+uA3c+
 qoMB9fB8altKFDUtpszOO+LqGCtwgUg5NVe8szLEpwalKZ6LHDkn6mj+tn2HikzMTFht
 xLnwg+eeVWNcfFn38mGFr9g31XRfz21IbFveyp6GIMYYjm7dOIeD1+4A2O8ZDTZ05ysQ
 a7F1IapYxkZbAoRitcKIM4Frz2SN5jWPwmStfA4sCIyAfqpA4v5gEv8lopEPP42Lyxph dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39y37t9jwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 18:01:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16MHtQaA088898;
        Thu, 22 Jul 2021 18:01:03 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by aserp3030.oracle.com with ESMTP id 39wunpcq50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 18:01:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bQ5mh+ZXDPLQS+gn9ebg8s2jEkSwq6sRSATzYPAaD7EDWu5eX0nzwOJeoG2wKrKveVR6az/1QvtEmrpJ1aDLPeuE/WHUkTBcN0bDzxQMTPh7hj5U4BCg0Rq2Ok89V1S+r4oxLhPS6bbYRDq3VTVdYX5poFh/CnF1HnHGTR1RI5lEwc2LNl/LVDGlJex1AWX97orQJAgQerkUKHSMDcQ+LAIZdDdy2cam7x+g8K1piR2qfZhI+SQW65rZQaktiGtwDMNRzD0aXujpIDdUlvqPRVT0tMuPY/DnFxK6LSnjXAY66wA1vifclfU67HkxOcI5LkAodUG/gpYyh62g8PzI3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2H3TSNyah9ocGG/YF/6p1pi+Kw6e1lglgNh5DUIY4qo=;
 b=K0cj1Evh94mDRz+2pxusZS4f9IYh1l+G3ErQ9cZ/oKO/Ju41KdskRi8b7CkWygVxbohcWFr+0AeVCysSOt2fx9Qs7+B+7nZpcQX3oKiLktMK39iGdIAbwGh1j++H/La1LqJlOLsIRS25MwJiDUcnh5Ee6gZ6FhI9lX8xGFb6CXvNuYFzTexQUCAL80oadFnru8PDttudWPOwg/wK2zhInMKlN/26Pu23osCkD7DvRLydJ7PjCSK+/GEKk+NRrXQBcGE1/WzX1i8TJjoYGtI6Cm701dENI2bgWbbWw9WLVvg+kf2vVV+Sc+TWvnvw/9l2VxOIqbIlz7RO4IVkmFdbKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2H3TSNyah9ocGG/YF/6p1pi+Kw6e1lglgNh5DUIY4qo=;
 b=RNIny4gKl+p58Ntyo0tqu8w43KhHDjtNy3ztzAo+CX6axk5h0CKb4lxNShXIWx9lflT4ur+9Zj/Eed5iyilZDDLN9sHpjpCDRgzU4D8PbDUO9Lz/Gi1k02O6euGk5mH3QGSeeL2jIHIwuTSHlCjNtITqY0hKUGZvGpigqR1ILZk=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Thu, 22 Jul
 2021 18:01:01 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4331.034; Thu, 22 Jul 2021
 18:01:01 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 12/24] block: add a queue_max_sectors_bytes helper
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tukmw7o2.fsf@ca-mkp.ca.oracle.com>
References: <20210712054816.4147559-1-hch@lst.de>
        <20210712054816.4147559-13-hch@lst.de>
Date:   Thu, 22 Jul 2021 14:00:57 -0400
In-Reply-To: <20210712054816.4147559-13-hch@lst.de> (Christoph Hellwig's
        message of "Mon, 12 Jul 2021 07:48:04 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0094.namprd04.prod.outlook.com
 (2603:10b6:806:122::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7PR04CA0094.namprd04.prod.outlook.com (2603:10b6:806:122::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Thu, 22 Jul 2021 18:01:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 532c009a-8f62-4000-89e9-08d94d3aaa8b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4806:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB480658AB5701DCAA25F5C4648EE49@PH0PR10MB4806.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P8KD/boD1utPEVXuc6eSY5WMSqYW7u0oFuHRYTBR4NtQJpX+zZnfI+bdkfsJO8yOD+Bg/lwP7f28/a+ksoU/46g4YfdrTihjHoRy3lScKffzZu2Tkwk6L53giR0kNQBxbI7Hpwncfu/u8Bc0ehe/8R0iPps35wrUaMegkozFFh8TfwLB6gbwDHZSg9thOpvVJAOOk8lIJsL4srtdjqoudVSNx3f5NVaKOubXIaQvO+C08RCanPZxTTgBo2fvL907n1l4fPyMnGRCvDdaaKq4V0O0i0TmlEcoURM6obo14Aaxi6ttf3H7kp371FG5shWMCTxki0u3aaQ77KNTNnI7oAJaEi7ee7xV1W+RA413570MQG/AGEEO2Xts77NtE8XA9hHtXb6W8+tAWAApuQqnUw9K/d82EbA25R7DymXzFe2ge6abjdT9hU6/nK4Nh6BKdoFq0LzbYZ1JCwiBIHyzvhNFHjAiccz5stUfahncveHqkUtd52WXnWK70BAop5vzO3fMRGKeCD59YQxHqb6Gkwcs1QOutnzTSmA5HP98qSQ13KzqR5P3ILBQH5jMnB+evmzcv28iJF5jo5UFyBabXLAm0rq7qgR16iB05qrjZs/nDkW5/iDg6U2+PdHRFFNPB6tlRLxBsw6aZuARfel3HZfbYfjAAtcw+MnWiWQIyeB3tvxFu130GWTmaGkZikNgoAxsSZ+bxy3cqEsM8S0h/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(136003)(396003)(5660300002)(4326008)(54906003)(316002)(186003)(86362001)(6916009)(83380400001)(66476007)(66556008)(558084003)(36916002)(2906002)(956004)(478600001)(66946007)(7696005)(6666004)(26005)(52116002)(55016002)(38350700002)(38100700002)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f1VC6RJ9JN9EIEt+XeoOXnRp4vGklaJWWMNS8xY870fj7j6/G1ZjjjJYsIf0?=
 =?us-ascii?Q?YDIotwsx7sGh7VLwU4sLnAfkGONFv4PyT79Kspu3xOuNJREvRvSHy8QaaoOY?=
 =?us-ascii?Q?8zgTXq5joC4UpEj4O0e8vePAjj/tkfghAmn4Q7vDsPATsOJ5IonMlsSG0DdC?=
 =?us-ascii?Q?bBeiDhIPo3ncn7dr5nZ7cfbX+FI3LgIDL6Njlig9unkXIPPtgcDerWclZR+6?=
 =?us-ascii?Q?uOc8KdzPZjKfShvWfARls5tnKyKfPOkUIAzDz44ZEHwbFZBY/do/g+9CAgJf?=
 =?us-ascii?Q?cQ6fyBJIOy+1F+NR+G6EutaFhW2VTtrXE0dLBZjTsTBGzc4JHNmbDPSP8m+h?=
 =?us-ascii?Q?VQUbQwDSoylB9EWWwfuSJO9/9YqbPN2dFUHyHL7nEyfNsRxyW8pdlLtqG+Fe?=
 =?us-ascii?Q?sE36Rm4TayRxW+QydnorF3MB0OZghfHN0sk+Gl2ZGPkPcZsFKuw8TG2T2I8V?=
 =?us-ascii?Q?Nfedm9nUO11GGQXaHkE4Wmai0D32Xo8ZrJORmg8SWRGkMoKuZMxduOkPlOqe?=
 =?us-ascii?Q?IeSIBcNchVQOVHhzM3z7qRh2cPskacYGAeXAzpxmixzWGnx1NSVEcFf+aHkY?=
 =?us-ascii?Q?GJY2GpqxffyP9l9191xqlvvSNOEEhV0gtNfBUUflAhBzRZDEbdlbzghGLPsO?=
 =?us-ascii?Q?7P0XCUlw5gMqHqpgqUs6sRgW5DrRIedadM6j0TlxL/C7SqAxPMGiQNsrSZKQ?=
 =?us-ascii?Q?54klQZRrnTKDzuqO2y3IkWOSIgn3p634IVUrx+1PKQKHF8rN1CgXlgoGmADk?=
 =?us-ascii?Q?8yoZ+ZlY7IPzk4BZPSIkU+kKLO3rh9H5w09K8uhk81vu5IhI31jLbOj1yrdG?=
 =?us-ascii?Q?0P0kdRK6P2MsLq1RtwChEWPYo9GnXSerc7vb4AzNyiRpfHU06XiSFxcI0pKT?=
 =?us-ascii?Q?UrM+EH4e0wzEaiWu2Dsk6ftp+7btqYNiKULZ4bbFmCgk48v+KHmD3Eluztoc?=
 =?us-ascii?Q?xuXBoFSm3xfbLdHObHnJqhO05yOauKuQIhHfyTGg/qUFtO0G54CYbWH4eSie?=
 =?us-ascii?Q?4pa0XBba1emg8GI+/cokCfSTMce/KOL4jNsxNr8F4/xLdAf87SCxaUogh+k7?=
 =?us-ascii?Q?e5Zdwgagal8jtFiD1o5p5eNBHNMV/brAGfgkmL3BiEtqh8WxKDALkEbredF8?=
 =?us-ascii?Q?fzRdA8mhjMkxQmjsnmL5e7wUYxudga3LHR8gFmCgLy8yqwLQcY0Cra43eF3g?=
 =?us-ascii?Q?ROn0Qn2i/d64UNc+sd9FP5YlDTt/QGL5yodJladsRu0M8JuiVZk2/YuBWhMY?=
 =?us-ascii?Q?EBjkFLr/p/goufHOnuRWv9jWUgeDMyq/C/XlRtvyJzX8wwg6a27qsRiJUmcA?=
 =?us-ascii?Q?ZfFy6w1mCf5PQXfdsmTjEYba?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 532c009a-8f62-4000-89e9-08d94d3aaa8b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 18:01:01.5683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vtPCex0KCfSoSp2a7aDzksMk7/1mIhCZgp3c1bPtfFFIiSIkR3hQRseuVhxUAawkOkW2rjNxq9Lt+waiwVN+7b5PezHpFBFGNInDb3j5CqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10053 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107220117
X-Proofpoint-ORIG-GUID: i-IuildHarRBNzhPMBlpm5XfVYetnFAK
X-Proofpoint-GUID: i-IuildHarRBNzhPMBlpm5XfVYetnFAK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> +static inline int queue_max_sectors_bytes(struct request_queue *q)
> +{
> +	return min_t(unsigned int, queue_max_sectors(q), INT_MAX >> 9) << 9;
> +}
> +

Maybe simply queue_max_bytes()?

-- 
Martin K. Petersen	Oracle Linux Engineering
