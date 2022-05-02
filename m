Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D99C2C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 21:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387761AbiEBVrc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 17:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351705AbiEBVra (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 17:47:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D6AF69
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 14:43:59 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242ISu4N027626;
        Mon, 2 May 2022 21:43:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=deuargvLkNgxARnUteq8GXzwKyTgUz5shqxCxYn6qBM=;
 b=dVh6jRJ75XMXafDNRqj41bLON96oCsNkIaOvgb3DeqPLjqSeU9ZKhfqkXlfbsqov9adP
 2C8QMYGw2Q6tsbWJ+SY9UpxZqxvTMwwTeuPjG/WNKzD5nMk8hDKRTMdd76d/uwLjZUyO
 bJ0PaCM8borJCFxWzNPJ1VQk2CXnVcPM5UWPkgQT/bJl6V/J6WCs0PmLqYj0smOH7iDz
 +g80qqLlFlbuX0N8SlmrvS9V8XfjSuboYUDjVIX1CUSn1ZKM6p23dAzyGWeSzIIi255S
 k9ogZBE8OqZQw52xWpJVMSab6QzLRsUnkVbJ4jZRbHWMdgIXD8K6xS9TxlKJetEzWxAG 9A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruw2cetq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 May 2022 21:43:49 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 242LaOdS002775;
        Mon, 2 May 2022 21:43:48 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj8ef7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 May 2022 21:43:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HonPB7KhsNmZbuC1Lou7zkeCCkKyrMVZtT0EP93nYsqWH6JkrcT4UaLZxuOk9XDP+02nVxG/csfC+xvU4ePbvfeiKTnV1e4MnimQ/f2vYlhjx71ctrQjNQGVmAYwy6vm8RmQhDuMq8kOqZwaYq66lanOoCwKHsvCWvnoPrpDMw4LSlUyoWQnAj6AxOYCpIhFdIwOOPk8N2g9ntBmTUHzOK3jDwniUcfJgMaHjxL1Y0J8PrK8gpQ2EN+QCcGjxG+axhMhlLi1/Xu6EYAUxywduuhLIQCcAox8D9U+VY76I882umTI2hbB/bAgtGS/pVxs4cCBN9Oriz8VaQiCGGIkvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=deuargvLkNgxARnUteq8GXzwKyTgUz5shqxCxYn6qBM=;
 b=Nu3nQiSKEDZfupNj4Kc3NPCmcLPHE+/HRoVmo7mYKaA3BFp5bkLC5hVigsPYhP0v2UGBEBxtpzcHuueD61tgRJpJd/rVR8Zmv3Fqb3XqITvyQrNnfG+wnl/8tP1dUsXjmatZk6ngO2IYbUR84D2yA5zo6abWK2tlOtg5tSwByFgipLOzF4qWA0tdb02LNWq5pdbsxnPHhBkfhehhL3tRsJqMVoOZpohz8YoRy0eSrmhQKQbA9x/MY+pL9SE7tG2uNzRQJMFtyhUmJZQkl2UNDzyxmp20d+1SVqPvDvXILcmcwHl7ReCptFq6REXnpXyKPxxxW3yQCF3mapcGb3FIPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=deuargvLkNgxARnUteq8GXzwKyTgUz5shqxCxYn6qBM=;
 b=nP4Bqp5x3O0MR0h91P5ydX96PKeV5IB1Z0LT0xvgVXjZSK4NbJZYrRhL02EtjDXpGY4UgJCiBayNHKEuSPGFi1k9XO3TNtooFynzU8URcvPu3BEUHN76CTV2wz6K4yn30Y3rDfY3lebW6HuVN2ugdh2kxVGC5Htc/6N3XhMI7lc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN2PR10MB4365.namprd10.prod.outlook.com (2603:10b6:208:199::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Mon, 2 May
 2022 21:43:45 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5186.028; Mon, 2 May 2022
 21:43:44 +0000
To:     Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        bvanassche@acm.org, hch@lst.de, hare@suse.de,
        himanshu.madhani@oracle.com, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, chandrakanth.patil@broadcom.com,
        sreekanth.reddy@broadcom.com, prayas.patel@broadcom.com
Subject: Re: [PATCH v7 0/8] mpi3mr: add BSG interface support for controller
 management
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtfzd30a.fsf@ca-mkp.ca.oracle.com>
References: <20220429211641.642010-1-sumit.saxena@broadcom.com>
Date:   Mon, 02 May 2022 17:43:42 -0400
In-Reply-To: <20220429211641.642010-1-sumit.saxena@broadcom.com> (Sumit
        Saxena's message of "Fri, 29 Apr 2022 17:16:33 -0400")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0047.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f820a00e-f5ed-48dc-5b67-08da2c84d4ee
X-MS-TrafficTypeDiagnostic: MN2PR10MB4365:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB43656BE46389996A1AFDB1138EC19@MN2PR10MB4365.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ct5qwm+S3tWj0tL+vnRiSKW0vVGnyG3193xKs8GDZMroVf86e/TpguB/aI8OX/YL5DhxZOk4VcF+8ZQWdQZuS/iMK/I5+NaLSldEMFJO2TpELhJFC0stknI8N5PdWMUaAWd6ZD0/EXFm1+x8NjD131463MdAgwlGqIDYgJuN2d3rQrq97eCVuGF19ITYcKKyCMhH2WVshGGteb9z6n73RfNNJH3YoPlKaSryn/CjkD3lS3oA9EJVcpr8TfpbVLwiYA47Q+Tfdhif/FWXAV74PM34wsRvx0V7SnZf4tzojwSCdiUz3RLN+xCgPgvZcB61RNdwYAH0uPivDl1xvH5uJ6L8rp6Ow0Jl7LfVMnSSWL1UO9peLuZ+TTFhwNd7r8AcNGAvC3qslhPzgkNp6+51K9jUOwrWJSkPKz6uZGDJCtkf/t/Uei7CthrQ7+SIt4XUSfRdXbMJI2PRBDRivN8pWGRdIPy/ReyUmoq/evGLOgB/H91rktjiRSktWDrmTazAALu5QHn/Nk2In8l6skWHT2iQWajxSDlsptZQ5iY+s3r4IVicKKXedjFLpRkE+DAKEA3uAy9gvlyHJf3vVqdC+OOVIR4JrlEdayMnuor4jcYilCtAEppVBamW05yFxjPRc/2I1MURYxw77tihiT8s1981OFa529/++jqLgvQGFmi3E7xRXow3KkpqqQRquY+aCLTD44nBNs0oQajs3jbhLtpRmxneVGzQNDOlhaYOD+g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(186003)(5660300002)(8676002)(4326008)(7416002)(66476007)(66556008)(66946007)(2906002)(86362001)(6916009)(38350700002)(52116002)(36916002)(38100700002)(6486002)(508600001)(316002)(558084003)(6512007)(26005)(6506007)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bpXrdZDC7VHgMJq/GPaSGOzfCAABjwnL9AZ4lFLRCY55EdX8p7ccJsSolMRy?=
 =?us-ascii?Q?r4AUjLV+wXYFzs4w557BnhEfYSRRue1Z7tFuzJI/h+Y028u57wBOZ5+1k94E?=
 =?us-ascii?Q?urHcUHjn9GZTY5mkOSVOgPEXfNjoSl+PTOILsb2sMcIO5neY1hjp4Jd/ExZj?=
 =?us-ascii?Q?7coxk4quNEUIHhaJE1JcrOJrLXk+wWVtlakV24IlDr5MeXRnVn5m+a5fL4EI?=
 =?us-ascii?Q?BugQoTOYdv9YJz98ZXBeDa6Q318+NLKKCbAcGRwCxDMpWKZBVWsdUPUzScMC?=
 =?us-ascii?Q?Q8bAekITqlE34jP56nSNOif/bHxOuiRjw2wX4lwtrNoC8+q3T2V6q7HqbSX4?=
 =?us-ascii?Q?00eKT5f5R7SVMu9QByaob5A/Cj0H1N5YBUCUNidvPTOQiZYCsFjQcDW0B2GL?=
 =?us-ascii?Q?+kHEUh8q8W9aiShbH2kwKikVfu4AemSkxow7YzBGjR4i8P0m1tQQs0r4F4XM?=
 =?us-ascii?Q?JwfzSiO0ss7QaV8ZI+zEwP3ADc4Pl9LuY5XHypklBdPHUUq/TXMeAXlalNSl?=
 =?us-ascii?Q?sdxTE75kAtRWQTyhADzAb6xtveaiHLPXiUDget3twArCZXBZQzRg+DCivelM?=
 =?us-ascii?Q?hNrNiCGmWBvQXiSm+t1jLmLdeR17i3UfJvp01HrO9phgVedIYudG/MrjnUiZ?=
 =?us-ascii?Q?W3nfo/65wITDNyBFnV6vtOY25dzRPmEKA3q5ROXk53sk7fD+qydIHKZTwrwg?=
 =?us-ascii?Q?WZXpqPxsvnv72iWJxdrJVhhjvdtYYOlkGTfhbcD2v5AxLq7haWcJe7hmwmGU?=
 =?us-ascii?Q?n4019PqjCKUr4XTFw2t9z0Z2d9693IFdnF4XfDztaLcceG3zlDEQ+8eUvdhh?=
 =?us-ascii?Q?Sw4M+Vhlqy8dryeoLLEn1JuNJV9V6Zqos7znXgi1oUHNulNfjRLhx92MUna3?=
 =?us-ascii?Q?+fWvOMyVX2HQC/MXz44W8AbzVBASqCkdAjOVNYtvGzJwsBqWwdFE6GiwLywt?=
 =?us-ascii?Q?NIFo36/iZm5XoacqJwmg+FMG3dyocPZAMyTYJuS+bzqX63zhB56uBrgldPjs?=
 =?us-ascii?Q?dgmVImfuaDcCyKgWLe30GsxzA4Cq5kseqv4q7u2m/LJGeR5caJITquwlapcp?=
 =?us-ascii?Q?1TZKFlYiEsdBwP+T19ysUZX1DJcuf2nwSlLtIqHe1/2thAypjZvS9+vszi+B?=
 =?us-ascii?Q?IXqUssqbszrINf+ricPEw3Z3bx2yIFuHGEBfH1Rzg8ut5Ee368lJ6xDHP0QL?=
 =?us-ascii?Q?oZ+rpQDMau83QDgm5YENSLAcFqx6+5qZBCS6SwE47ucsQVPtmu4XhRP7e2qD?=
 =?us-ascii?Q?TK+XRE+T5gKPNfQh5ehfNy2ENG1QePFZs6vsMlitkKZyhxCvg20AlICUo/dT?=
 =?us-ascii?Q?n8ERe9ZSGVAHqm+jY/GFsTOoB/BfBFEu0Q8yi3lEDWZlCi+9A76rFkRrGV1R?=
 =?us-ascii?Q?qR5WM2qRP5xlgSXKcDAxxnFPOLN3ypaVcx0JVeIG/4QoSUBXjELQux2NXSCz?=
 =?us-ascii?Q?I6EJuG1Axn3SVreCiUOJxeHKYZyA/FgVEPl+PtRsXWk/R/PHd+rp0sgnrLeh?=
 =?us-ascii?Q?hgBHadu/hmYDfKCcKmTjLv3vCh0EsrkWoPa1SPf1PeKQEHLpXKU5eSwCxN0B?=
 =?us-ascii?Q?zlIjWOkTSr3bKWbzcBMDqw72MOkgf2jSpED0L3LHLA3WB+3h3xiVcSRIs51Z?=
 =?us-ascii?Q?yFZoZ7kOB+6fdWQwTczQTwStmzSRNU613d5xkFhiB14edQcvX0oylQ7y7ewM?=
 =?us-ascii?Q?yv1WRbNLoCoAuac6zlRiEhVD4PVbBdbweNJ3rQKzvUsHgJmpJfidISvvdoZJ?=
 =?us-ascii?Q?yZAN+SjcdixDnUxhhA1+opqsZ/sC3nk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f820a00e-f5ed-48dc-5b67-08da2c84d4ee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 21:43:44.8385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: awFLWCBf1s5jriKKvfwk01mnaz2GXMcovucOaaBUzsunrFRdtlfkYojSPpiT5icPrsTte8yA3dzzEnJEgQ3RcCcIypItNXlbfg7nDC4bqDg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4365
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-02_07:2022-05-02,2022-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=511 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205020159
X-Proofpoint-GUID: 5U3x-93FeMwDvgrpJwYam8hi2HEFUgc6
X-Proofpoint-ORIG-GUID: 5U3x-93FeMwDvgrpJwYam8hi2HEFUgc6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sumit,

> This patchset adds BSG interface support for controller
> management. BSG layer facilitates communication/data exchange 
> between application and driver/firmware through BSG device node.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
