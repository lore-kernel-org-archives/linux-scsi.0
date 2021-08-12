Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA507C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 17:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF45160EB9
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 17:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbhHLRV7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 13:21:59 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:22628 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229905AbhHLRV6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Aug 2021 13:21:58 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17CHH2gQ032497;
        Thu, 12 Aug 2021 17:21:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=plKCw0MaUjq6kVVu9wlk/TxdeR4GeuIRDaxwPoMmlRc=;
 b=vskfxbyJjut6LEPbqHDldKgG76gP1tpHPsJS3C1+zJuOy3MNlPmGKUJ1023CgJ0VSm3O
 wZ1wkoeHx85jOk5iJSRPTVWB7QiMa0NVCv2PCwFH1BmUUR1il0Y1oxDe6+g4H32oHrtt
 micHzCJ4kcepgE6XGfpxp40eCXT2u6gwoy/qcF/eLw9dVLr1xbShrevDJcLceEmfkYQJ
 aw3ICwg6xB8Z6iSPJ5FsLZ/hO3R1ZNfLkQRSB0TdSKqHdEX6+lB38umzGxCfUvpo2dH1
 gFupVsy+IhoJWa3k9o2WvDMq+93ezMU6RXDSF07/ZFujVFVj1BBH2sUMQGCfU4VKG5Qs hA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=plKCw0MaUjq6kVVu9wlk/TxdeR4GeuIRDaxwPoMmlRc=;
 b=VEvEE7cvpbpAUOefgtekGHh6OnR9ZZqSuUw99uteBQVaLVpNa1HqH0CEOBBD9TMX8dVF
 c/iNkm7oFUxYiHYeQFUgURWv/RGfDatgfewVGOrVqioPSfiHB0ssLnhcnjKq/QBvRFCK
 kW1VJabrlVSeTAXjCPb/r+4HjIS2RxumTXTav5QlJqtmYdBbOi7pFbi+TfVj5UXzS5AA
 awH69BGAjvb6/i51iUJwt0UqRBGOvVgR3DyoK+I5HILkQjejfXh/UjAb9LYiUT6yJBOT
 JLgKST6PECB5nyMjTnH3IfYFsXSutj7B3aVCv/44nAaIQIzRaNfcccz53yq++AdpSCKE Kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aceuduewp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 17:21:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17CHKXEX195027;
        Thu, 12 Aug 2021 17:21:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by aserp3020.oracle.com with ESMTP id 3accrcgv23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 17:21:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gz4JK7yUfmxpnNEyaa5G/6pvqhTVsjNRh/J/e9gppEtH+8hYH3rmhgqkt/bOAC+yRqknipmRPxSdJIySXrj8moeTBV+yolu61nXpxnL00r/N3zsW3dTeGEJXamQgWSWGQjQonXb/CPfHQ21+EElLMZcRIrYW8kJ12K71SogZ+OTfNd/8IlCFe0f86y3PHAULLtpxwvs1GKyW7QTH5LTS8Xo9cRkQa1xLViAG1PGc6Lbal2aOJw7miU8kN7+6yfyOxeSjh8WlLx39cZuuE44O6shXIAFspj2zbXPLMBmJxPCDUIij+WGRMdJggnc2uuUW2YIKcw91rsaBCUiWPGwIGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=plKCw0MaUjq6kVVu9wlk/TxdeR4GeuIRDaxwPoMmlRc=;
 b=ZYf/BmbapaJQZD7k3V8Khxlj91TDlR5LV64alORk06ves5Gz3nPvdGMFCRVAcaaj1ib0jcrhAmFyZTDNU0OuEey3gTWTCFm8hU1Szhim8cApi5+WSGnCO9pnjKEXzbxpJFHBU6e/8uuK47diwmcPud4gzqAUeSJyEpTAQClmUqpYr04A6laAxaQUef5AEF3780dTBpybhwFU6RCmA6dlhuuBG+2H50EVfbwRdoBUvwUjPdxtyl8O+P/yepP4TdQRGp5VXxUJCdkdXei71/c0mEziblB06MYaNalIqi/mmgxXBbFEHCE2pY+R5AX29HNFoM8fkZO2R1sIq5VUf2NtlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=plKCw0MaUjq6kVVu9wlk/TxdeR4GeuIRDaxwPoMmlRc=;
 b=MXOSwdQ/UoCDWfN0rMGFuCiq3v7kJcbQMS9aNROJH9AHXIJ9HSm0R/RJDPRuqAQP3zDZYNbLnmJynLdRJe3LPRGXRObuUtw86S0KccAN5wZFytQMGbWtIth3g9G9edKPLUofgr+eQrMJcas+BDIhr12K5WKI0w27dilyY/ZH/Vs=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5401.namprd10.prod.outlook.com (2603:10b6:510:e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Thu, 12 Aug
 2021 17:21:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.017; Thu, 12 Aug 2021
 17:21:28 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v5 0/5] Initial support for multi-actuator HDDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1eyshs3.fsf@ca-mkp.ca.oracle.com>
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
        <a968069d-07df-396e-8ac6-04dfe3ee3040@kernel.dk>
Date:   Thu, 12 Aug 2021 13:21:24 -0400
In-Reply-To: <a968069d-07df-396e-8ac6-04dfe3ee3040@kernel.dk> (Jens Axboe's
        message of "Thu, 12 Aug 2021 11:10:46 -0600")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0209.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0209.namprd03.prod.outlook.com (2603:10b6:a03:2ef::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Thu, 12 Aug 2021 17:21:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38a04267-9b00-4e96-e955-08d95db59e7b
X-MS-TrafficTypeDiagnostic: PH0PR10MB5401:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54015F86974138907E83826A8EF99@PH0PR10MB5401.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D28Jmo17zAH8BUkGNM/+fIjPKv7G6qJaeZKhDXbON9SxbmciirbKAIIMyP9m/PFoO4MA7w/zxET38gkM5Fdb5JItxCDfUiVhew23wQPTIOnp6rnVTo9jDQYPFR/YYiEpbDTgE/ekk9mrwle1h+oBezzE102m1UCtmUtUVBX6YVk6wbamHKwDVPtOdWbn3HkIKTOPYFq1GO/0ltno1wO4BbNvGadGnHfD5CpKjQedT0ITkwvEty5q988Z3B9kqeJtUbtyJ7JYdJrD6O4XK3i5uK8SBemQvYIZbL8WUdPe0MRBEIwEpSp4a+XW5xvoCgf850tTxfucjCQJ3cDwv5wAE+Z0btC5mYEtbyQ3tSUdUpv7UjzqKR7t9k2zhHmASQoio+NbtF06JgU6KtvU8NP06Nqs5cgDDrn2qukYBCI3HPzHtc97mrx2ZmliGRd2ZvadSWTaZab3UdmjFiXqhuFxAg7ZLo9L7kcU/z73tajZyBpFfXzHXSSsT+XT/61eEyhnpIv31mEFLbmGlUaYvyZKEbZHtrPH8wCqLF5atfipu+XieMfPzaf5AcchFi6O69G0xSdfuyRdqbb/BM00RaW5ADdF9fFspNXVOsiAOH/i/RsGjQS5hhitQw1SbNtHUxWzMqL95CgT/Uf499oRzYkI2WkST6L0L2jw2nYzE5LiIAD+7CV5lmfZ2IdEx9kSfEKKYakJCSkMUI9Pj0AvlHNGUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(136003)(396003)(4326008)(6666004)(38350700002)(38100700002)(316002)(83380400001)(66556008)(54906003)(66476007)(2906002)(8936002)(66946007)(36916002)(7696005)(52116002)(186003)(55016002)(26005)(478600001)(5660300002)(956004)(6916009)(4744005)(86362001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fTM/iX7KzvsIf4CeCQBSqp8VZdn8bBzycD0HKvUfUumaKlVAwvnFO5/8HNyA?=
 =?us-ascii?Q?srF1eqlnrkDVBtdGf3/TklfBMta+ltBiBkArbHXemu1ujF0Hx2YEQjPxVRSs?=
 =?us-ascii?Q?w8wNWCkjHcI18I1FB+NIOjm258ecJO0wohDGC4kG8VpdAChaTIfP8qRXsERr?=
 =?us-ascii?Q?blQDOOpSaNFzBc+E8Krkqhi+FHjrirky5hNfvXZVWMf8RtSgl1XfDaCWfPX5?=
 =?us-ascii?Q?U2VM7KJ6RBuFPlX1ZF1xyg07dSYYrF8bp54KCCtfb7yE8Tm++3meHxcecxpU?=
 =?us-ascii?Q?INBM5l2nxlKRwGz28GfSxV6rBQV5fKRyyElAv0kHNf87m7MXWI1BVMe/j16m?=
 =?us-ascii?Q?GcQhNb8khi9gojOlt7KDcgWFr7cjHv++6VZWXMH98J+jZPSxWJ/HpbMCh4i0?=
 =?us-ascii?Q?IrWEF6FuHAFwzOgHCtPbsBelOvrmDF//6h2HJnKN64rsPHEesoLQI5gRt8s1?=
 =?us-ascii?Q?Jxq4iWwPcF0uESZ/Lbo4DwFcdymR/JA4NZg6+g44jGvNPwkojE3dRYhnCFzQ?=
 =?us-ascii?Q?CFwRhwEnpMV7uzgNZn/DcNdcDm1wT4UqDvz2akPITL4WpB3wDU6moCKktYz6?=
 =?us-ascii?Q?XsF1RFPMKUnvPRuYY+cuyRE+VikrLBYm/MGfgP7EDn4p9DtGevz6f7gYhBtT?=
 =?us-ascii?Q?m/5Nd2jSBKxnZhABms7vlVg18rXxTPXjX+ogl5euldWC9Ww850ZBpEVCLgNq?=
 =?us-ascii?Q?rB/5/q8QjHFkjO60CwCBrnhf1McVigocvTlqlrroFHoT0az3SC3nS7VU6hB0?=
 =?us-ascii?Q?KpOL/DMyAdsTjYH4pxp7O907AvHqg/QA5IKM0YgN5S2vrATgL2VEDXNxtvRr?=
 =?us-ascii?Q?1NDF8yHrq8ArMwOyJ5rW0CB4rzwfJvkcJDx6ZaiKUmijCpmE8rWPRp9dVL7z?=
 =?us-ascii?Q?1xUtvBHsm5OeJQYKXbZZf2vN2BJAj0di0TMQwBAhK2ei9d6MuJ7/0/YIqnZL?=
 =?us-ascii?Q?gqgFqxPfdLH7B4Ibq6AeLWQ/oQg8ZXEGRZFJTCTbIwurueAqQIv/YW/dFucI?=
 =?us-ascii?Q?9jA9J3KnVXezfZqPj8oAoc+4PjhuARKFpe4GDhT77VEVJLWenTrrzCXiVxn2?=
 =?us-ascii?Q?JgyUnsK4BFtMlj92PoG1FDhgyxyC+bDQD4c7H665l6M0wrS2OkUxQHOew3L4?=
 =?us-ascii?Q?jFBcVAEg8yEjK3+OdV5CbE59LBV0LhYlP79swInhKusSebS+SObvPHpz24rK?=
 =?us-ascii?Q?9Y7IsxM4WC9f8jO/3sEmKbNl+kZIOCcL9O0xDksAD31hXM7LdloK341w94Qc?=
 =?us-ascii?Q?IhhOyYLR39zUgHHWdXtKDZ+oYnh++p6yrgp8C7+tiXG7m0XBWbQVNqEGrVyj?=
 =?us-ascii?Q?eQLTuV3qdgnmVF7Yh5/h5zF0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38a04267-9b00-4e96-e955-08d95db59e7b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 17:21:28.0623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5+jCoVRc6/0+K9nSd66whKAZ1Je/wFG8oCxHkvQJY9IjBsh0Zb6O2RqJvHqNTATYfp2O0TgQ4OvpF9qE5gCQMVNu4V/3uHPIpuVecg1mT1c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5401
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=977
 malwarescore=0 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120113
X-Proofpoint-ORIG-GUID: dhSyKrC3VagxmBMbFj20n4Bua_D0IEBC
X-Proofpoint-GUID: dhSyKrC3VagxmBMbFj20n4Bua_D0IEBC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jens,

> This looks good to me now - are we taking this through the block tree?
> If so, would be nice to get a SCSI signoff on patch 2.

I'd like to do one more review pass. Also, it may be best to take patch
2 through my tree since I suspect it will interfere with my VPD shuffle.

-- 
Martin K. Petersen	Oracle Linux Engineering
