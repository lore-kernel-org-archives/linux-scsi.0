Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B13C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 08:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 373FF61040
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 08:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbhJMIfi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 04:35:38 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:45196 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229830AbhJMIfh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Oct 2021 04:35:37 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19D8EC1I028314;
        Wed, 13 Oct 2021 08:33:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=5DBj+QTPtiyrknq8piI0h/j2jXGjXQVeqy16dqOz/lA=;
 b=azaht7RO5V5yxBRdf1neFxFGgqjAZjmtkLUt9m3jv31g5cAKnZSsAto6stIcC/b4KtzI
 fLvSZ4w53asgufkzZ9y/mX6l1YZsmMTkgcNBs/LPVVoAr2DuPMI6RcIpmPgaaRJfff5i
 TMffiF1iNbW09S2vbdkKe1xIaG+KmTrPEmvPTCWqSCXKiV46/0cPB5rcVezGYyLI7CVZ
 5H15iIa3NX06UCqzRk4mSQzC6CZJj6ZrIED6/p24gtIDHHNg4OhA6iRvgUEitLSAEqUo
 +wQU8z3IJBlawUQCqFvUFWH8L6EbGQARFDSYHZJVaYILBUvnDs5sTh/ZrFXuOZQeqY0b /A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbjae3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 08:33:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19D8V9a0159294;
        Wed, 13 Oct 2021 08:33:28 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2177.outbound.protection.outlook.com [104.47.73.177])
        by userp3030.oracle.com with ESMTP id 3bkyvacw42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 08:33:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MCBdtQmLWCO941PzcuXzn/8Uo4JMSfFvjSMBCGDVgcmxTIts1a+8lTCJGVV1So5c+s3lDaF7zLakaeF91iIdrCB7l8sb4e50LHpLCqBqzNRK/cWRsquUUwEsCUkv/lh5O1/6tzDEoo0NiFICzbhXVfdkL1QG0/L6z1VoZwN2iwo6z+7LBOs/YIBAn5lFm9UXmOSTU6bLF03R/lEpjbxKrw1go7pqwxPPeWOqHs9c/aVMAG7LUPgdAU0pvbqYoQb5M8GUNwlV7IQ/eKy5VNqNN9X+UUMjcj7VtARM4IzZlWfMvkdir06w3NOj4tSXYxsjlO6vvHJshPzLJS5UO9Dm2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5DBj+QTPtiyrknq8piI0h/j2jXGjXQVeqy16dqOz/lA=;
 b=Sx8xVhV5SkN1SzbbYvVJmmaSafl+NOpPrxB6SND5SYixHWTdwArY7D2pChL6cDC1CoBU5TZMoi0yE6RiHP5gFvWhkoDZoQAse36uGkTdaJ2J0RYKZHJhqzWdG5ME8//R9U46Oo51UQGbTaNnUavlKJUNbCZvfXGix2Wf8FmhDr1dCRe5WgOfIe8sj8MuF4t2bai1st03CP7R+C/5Pn2rKS5NkssGVEKnWUq6mqkCcpX55n+HOYceNxgbG3yfvbeKky30bne4a8Wc8T859G0ZZmhQokPpYdG8r5DCaHquQEKiNkEYZ4XYH2a4wWi29tuHbmh/KRi8yoSGLqCM1fsQuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DBj+QTPtiyrknq8piI0h/j2jXGjXQVeqy16dqOz/lA=;
 b=OWf8JU2vDmy3CBsN89SuF0z5Jc4OQ7k0dM54cL1x2aYbnr+I9UhdHVdC4ohDXubErzvjXuGGF+Kq63cAqBD1mjZ6rFfgd8dkHYX1xvNc7OcQHxMw8p603k9Fwfd/9foa0kP0dFf2CpgmM1k3bny4Xuq3lgO/7+Ocob85hQb3Reo=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2319.namprd10.prod.outlook.com
 (2603:10b6:301:34::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 13 Oct
 2021 08:33:26 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4587.027; Wed, 13 Oct 2021
 08:33:26 +0000
Date:   Wed, 13 Oct 2021 11:33:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: clean up mpi3mr_print_ioc_info()
Message-ID: <20211013083309.GI8429@kadam>
References: <20210916132605.GF25094@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916132605.GF25094@kili>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0057.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::9)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNAP275CA0057.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Wed, 13 Oct 2021 08:33:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7842665b-40b8-4741-850d-08d98e242022
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2319:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB231991086E222B3C26D4082F8EB79@MWHPR1001MB2319.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:901;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1JnvzoDn/Zpz42rBg3kYViGQsLrfdkBw1I2BxwG0B44poBei8YUJiq0e1+MWvvXmoqqm5eUVt77azumna4qFun/i1LMNLcNyfTg7cuWBHuD0gkeu16o60JzyweL0aObBvOLRU9MeWR5Y3IzIw39Z+iKZJA5/wactTIsR/OTKtebWUq2wHKaa/FVsnoESFkUREo1v3tVYe85tJ651AiY30O4MprGC9Hh2nfACvaNQvQ6b6AAlhBbGVXqJ1p5INv8q8U/bsnksQI9wpELYBcbhmLaVWt6ajgZpvOtPlZ46VgaHmEF9gx5iM6ZJQBTNNgXpeH60dcv8hcTwD4PxY22SXTBOpJtKunay9Lu5qT4M6Vlr2o0XL9UutOqa9UGBTCFV5x6WvRnZhzF0lLKOmG2dht6pqwAY2O86bA9CncfI1IcPk3iUVtJ1TKvpu2Zzu78KI/aoCcgVdqFfqpJf43XSwzM6F0NZIFdKmoCm5BlsC6i//R6o2A3Zx2vqHBfRS/PChnRlh8o6E6UQRLGOgEWfqVn9HqBfzTqvFheazUpFFJ0/inasg6FiV6grSTlN1ogcj6VZXxO+84xO3V/WfVIyKKFroBw3aORou/eTV1mVU/bHb5g/8kvcI+/UBeSLL0+nngOUK0bO0tJKcRUOsQn8VVf1+4Wu8RcUwsD4W+VJ32gxfa24Sw3B1yX4juRcDnXLoYP25VQfLxfEd33VMq/fX9usu0NO0LkAHrIZHAZH268=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(66946007)(5660300002)(186003)(8676002)(508600001)(66556008)(956004)(9686003)(66476007)(6496006)(55016002)(9576002)(4326008)(33656002)(8936002)(38350700002)(52116002)(44832011)(38100700002)(86362001)(6666004)(33716001)(1076003)(83380400001)(26005)(6916009)(2906002)(316002)(4744005)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aRRLyUBFPhbHfN9+o4A/JpVWM1+W3JOGWKNdJOCcDK6pKJpVLN46SzVuKOSi?=
 =?us-ascii?Q?sucbVCuXYm3g81/lHB750xmav+fsWGKGw/H4D29Wj5+Itp+mPaE5q4xh9Hlx?=
 =?us-ascii?Q?EVwZHpIK34DGv4Hixde9CLxt+pg3WopzMkEY14cuqRSDkoMofh3YyFzfMRdP?=
 =?us-ascii?Q?PeE7N/45G+txvLI3cHlXRIveoHHHAkJTboaXnBIC2BFV2u45+vM5lHtjiRdA?=
 =?us-ascii?Q?pvFzUHZojIBJ/+YZrKxe6Dr2eG5emmQQe48PkMW2KJZ6udwleuNIXJVM1FtQ?=
 =?us-ascii?Q?dAlHNY+o150pz0QgqsHBo488opgpk2jXWTId7KBey2GQGNVKn0ndaB0e2cYQ?=
 =?us-ascii?Q?QmlBHLC1LHIeLpxbSKMWq0cMH+B/Bc7ROI3bEHyIuMitDAPabGAxR2xxFbka?=
 =?us-ascii?Q?XzF0JUOJ8ec/XyD9MlTZUWvYqOFRZn4EbhvEyIXBn/m2S5jo0fVisLim4auK?=
 =?us-ascii?Q?zLr+DtZTzYXWPQepckAl8w9bgNO3SDdiOSSbnOMEDi+gGXwQvCTumdgJPew+?=
 =?us-ascii?Q?JRsEqfI23eZsNM3HRTpj8ij0XMlH3fCgNYe7BqpHr22mqZDU6rC4yuEU9GwE?=
 =?us-ascii?Q?wLcXNa7mqu9ptqeyCeCmesyhtUHL7JVLexvv7LqlEjKQqEZtxwU/RhzNOMT8?=
 =?us-ascii?Q?icCPwstKv/l/eCBZFbxEMlh5OGCft7PS7M5hnmXfgLw9s35MGt16++Cm/O7F?=
 =?us-ascii?Q?4ew4PadhkO0Tpge6DcyjeUUpMBaiOongvN4xa8lia2rjLgM/VLts2x5qaXdA?=
 =?us-ascii?Q?P7yWKZOmExsL/1xZssnOiC7sNV0acjvGffB8DI51Qs0V7V42tKQhTs+5g4/G?=
 =?us-ascii?Q?qBixzfeENdsFzO0JtA4mOc2ytHFaU0TmH+T1KiJEzOOW7zhAc9OjYOYw17PR?=
 =?us-ascii?Q?96yQKRe2Zxy2YkQvjpEIJUaVAQcRBOaC3TA+G3bdu4DBVOgVIOGdfT85Ekj5?=
 =?us-ascii?Q?LJM3uQVwd+fWD9K5lw55/k6vWl6qabDTZ1G2t4xaJIezJUpJKRnIumyb34Pb?=
 =?us-ascii?Q?69aWtUW2IvLATqZa+T4CEkWT41q8Nk3OV64Ea33OFgYsx0oGI3PwJv2mknS0?=
 =?us-ascii?Q?/wUdHfklIuV4eCXHXUHRUwhwcp8AW1jtw/uDtxbKpnczBik10Hzkr7eYFWXL?=
 =?us-ascii?Q?YpdIuDtp7IsboDRczmptOA/RpSzAhtmrpD93W0VKQaZLfIiLTn+rEgwezPmq?=
 =?us-ascii?Q?y3j0LaEYjCt/xyZzWi4BBHfjBtKRb8TphPSjYBYdCN2JZk6qpO4pvyrJvN9F?=
 =?us-ascii?Q?UZodCFoOi+vDboLF3V1x5VAppvz+SIumVxXAGErznidaybc91WAQzvsvbxHH?=
 =?us-ascii?Q?GYn28K74UTxkY45OaJxyjJ6Z?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7842665b-40b8-4741-850d-08d98e242022
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 08:33:26.3313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CreVvqO8+FjhNa3VgDsfUV77pFMz5pzJ1/MhEC2SJwjstOi8J7XfXv/z+TgHFL6o0+TBKHX1cBJX7ZVjkNRV6t0BJa+7kho5v/7dfnuuT1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2319
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=778
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110130057
X-Proofpoint-GUID: JouRJXOtJGKjQOJeuzTqBpUohRtYVf55
X-Proofpoint-ORIG-GUID: JouRJXOtJGKjQOJeuzTqBpUohRtYVf55
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 16, 2021 at 04:26:05PM +0300, Dan Carpenter wrote:
> @@ -3046,34 +3045,21 @@ mpi3mr_print_ioc_info(struct mpi3mr_ioc *mrioc)
>  	for (i = 0; i < ARRAY_SIZE(mpi3mr_protocols); i++) {
>  		if (mrioc->facts.protocol_flags &
>  		    mpi3mr_protocols[i].protocol) {
> -			if (is_string_nonempty &&
> -			    (bytes_wrote < sizeof(protocol)))
> -				bytes_wrote += snprintf(protocol + bytes_wrote,
> -				    (sizeof(protocol) - bytes_wrote), ",");
> -
> -			if (bytes_wrote < sizeof(protocol))
> -				bytes_wrote += snprintf(protocol + bytes_wrote,
> -				    (sizeof(protocol) - bytes_wrote), "%s",

Part of the reason I sent this patch is because the
"bytes_wrote < sizeof(protocol)" comparison is off by one.  It should
have been "bytes_wrote <= sizeof(protocol)".  Being off by one is
harmless here.

I should have written about this in the commit message.  I really messed
this one up all sorts of different ways.  :/  I'll try do better in the
future.

regards,
dan carpenter

