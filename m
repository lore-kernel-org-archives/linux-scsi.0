Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E64C432BE
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Jul 2021 02:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BAEA60F3A
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Jul 2021 02:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236676AbhGaC3g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Jul 2021 22:29:36 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:59598 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231682AbhGaC3f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jul 2021 22:29:35 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16V2CuSk032372;
        Sat, 31 Jul 2021 02:29:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=YSul0KHuGGe/+kLtfYWOpKNe/doHF+putzp2G9X2p1Y=;
 b=EBKIvdvmfHLhUshAIieyeNd8UF9B632yw4cZvC5T/P2j8roxEufUPvD2LEq8YnPz32A/
 OYlGF82eDn52jZ61Ftw9zWql8QB0DBTntzvYmQ/mTV3XEj94XZgbXj8SJh0ygOgJpW6K
 ECETmhW/10iEyNHB8Eq+mA8kcrTkqhBqVuyhMnNOj05Glmaw0ozSh18SP0kTDLFjHvrL
 agxKA965r3TA3IxIo1Z7GVVCOvBulFFWF+iDwEDDZv5aeItUQQ3Chb1ajc5eTEcrRlG6
 bv2YN/+l2Gngmc3wDrC+19dqO8ZXa+NUXpQRnbnfOffgiDrs0o4j87972Aw6Sf1QKmq+ sw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=YSul0KHuGGe/+kLtfYWOpKNe/doHF+putzp2G9X2p1Y=;
 b=M+vRCynKiArMEZKuE55XZAS+b7NhhjAQakVpEt44ijpZG0ug2A03NOEH27hJ/VpX9jaX
 /ImteC073VDp939//KoymcVUN2mASvXZ5c3ZgtSfasJRBZR+CV6dAUFVYMmgYTKuEEsN
 gGTNTqK/mAb74Duo+EN0EkRqNE1j+2iTHYiC+1Dm01QKl2hUQcHpGqlE1Vw2PNLtMhLm
 bUFTm5Rv2Vgxy/d/259kUKNka/OW3UkNYy/ALd2qac6mUM8oyAKxFsE/rtxIJ2y4kwIo
 cdzfGJ8QjH9mbO30LV6Da/DnuRSmDC6r6LZ7UqhKC6ONxj4NnuZ+3b8L0ATKm9vQ22fl iQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a4w4180qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Jul 2021 02:29:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16V29rB8044982;
        Sat, 31 Jul 2021 02:29:21 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by aserp3030.oracle.com with ESMTP id 3a4vj8tck4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Jul 2021 02:29:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SmV8/goZs9BNMr/Az7DF23+oJpg3nul/ZPlQ1ncw9ABsCmuJ2GRv8etoOVZ1ijM9ayldTonuxjIr2w5PM1H7OeAPjcyokJE3F0g+4ya4j/nxNwkhYA6yKCLDqGl8db81ZbJ9saEu2FKeNZaJFzI7NHWRLLUTX4Ma/FaLV1nkRbl4Q03dN9KHiYwNAFPWS9orPUhCRLJFXJyVIjXOv6GZbHDw9CJje5U7a3j/3nkO0GevX34Ga3gJUrzRuPL3O2Rre7xL4IXEdEwWe90HXLg7BzmPXQIhl2eiyVvcjnljeVZEzNL29eavzEPbb0bBTZ2IZwPAufy0lypaMNGL2zwIiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSul0KHuGGe/+kLtfYWOpKNe/doHF+putzp2G9X2p1Y=;
 b=NPUrPNCQtW8x/B/eJqVvlDcWX6iKnfFzFNFwjPJAXBLRaWWcRDVLOESMDd/pV2s7wArRS/OJihNarNcsVkXuFqPK+KUDzwV5LFTlpLkuqXHXw6FVRnManSLQcpPOuzXDBoQHojimhlQQFUts10uprkQHl6Cs7RP1hQo9hhyZeXGjRfNoNE5ulyXGcFefZ9OaPjoZ3HjMz+hqRs9dRyEMBaED0L5Pgn9cYmWcaVeJuUIBUe2JaYME9VkcYKZzFaURrNedT+w3VZYtouL6QUVTDKuaY0TkvokIPygVMi8S8Tqf4j2EyVrSYusD8Fz/mlZz1NW7B23S8vn62HRu4rPE8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSul0KHuGGe/+kLtfYWOpKNe/doHF+putzp2G9X2p1Y=;
 b=sfzQIK99efefr1UOZ9wC1yIbW5Fp9d9Ch1GCr0LJs4riyNo5ptNe//BFAjNKcUotEYNq/6ixbFggH5anhu7ZLo5u2av7jP23JXW9wtZCA3DpNwt7m2u3jl1SSyzpUZb3eI4h1DmirgEbJPJ3g+7DfVIYhorvfTg+3L7zKegLbKc=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5482.namprd10.prod.outlook.com (2603:10b6:510:e4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Sat, 31 Jul
 2021 02:29:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.025; Sat, 31 Jul 2021
 02:29:20 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: bsg cleanup, part 2
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tukbmd44.fsf@ca-mkp.ca.oracle.com>
References: <20210729064845.1044147-1-hch@lst.de>
Date:   Fri, 30 Jul 2021 22:29:16 -0400
In-Reply-To: <20210729064845.1044147-1-hch@lst.de> (Christoph Hellwig's
        message of "Thu, 29 Jul 2021 08:48:41 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:e0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.10 via Frontend Transport; Sat, 31 Jul 2021 02:29:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f234af10-211b-491b-0bbc-08d953cb003f
X-MS-TrafficTypeDiagnostic: PH0PR10MB5482:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5482890FB2AD13D4B70900EC8EED9@PH0PR10MB5482.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u74F0shGG9n647maN5xrBrlz0XO+orOVh5l0/Y11S3N0rPusLo7c7YW06VtdiKHIOTpwSHbmXt0PxTf/ADYj1xU5MTPJj+QFMHrwfQMcuFpTFwGTrbMhKElRJcYh/FiR6lfmwadhVsLG5uFFIHeDQJxamJpSy+OO7LwgIcON3fkbDvH7kCx2qaMpRNPc1tM8qp3Pjwoj4UU2VSBqlNWXS7eFJcKkzz/sq6R+ZK1cSsQHpGMtLzkJ3DTnTzRYEwydbHMsACeJSR5nLVqFf1Q87NybeA3l78reKbMWqEqcYoQJolsIvKn/gmAXbMM+LGz2mcajFDaI2SrXC5ztOBxdL6v7lXEz+ge59GT0R4ilEOtvrX239RHD7wF69WH70LRvIGRn1vd6/aTMladCpMfOR3xdhX5uIXGYe/WyTgWBhN3mPcI+oKVb4TMvm9L3pXVIKlRThNl6Al96yUNJrrTe2XRZ1sfXPNVeh/J3MG6ldRLtWjZ2tLxrpbifySjBA4dEfFqYzJMS48AEgPo/zmCjw8gGKRkUWmiXhBZ0OBK081OWC8XDZLlX7l8+pKpHzb9RwTAb7yKNfh9ebDnHhXSK/8Oj3AjtDqjSbCL/R1mMcMGEk3FSQ3M/FwEF3l4fE+iXfqId/dmcBeIP2A56WukDF/PyhGS2o4Ltd/Ll6hOMSf+SFQrxVT/j7bKljIF+tSovNJhiP5eO1E1hz598mG6RtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(66556008)(66476007)(38350700002)(38100700002)(66946007)(6916009)(4744005)(6666004)(26005)(52116002)(316002)(956004)(8936002)(86362001)(7696005)(186003)(36916002)(508600001)(8676002)(5660300002)(55016002)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ITclqtE1NxZjRyMazNyVjZdD3wtn69u8T3HWr+IbKJpQHRvzuq+CWhsI6Gm9?=
 =?us-ascii?Q?v7MRw+YiDv3je/RU4fv4gVR4CJawrz1CzEOKG2AfP8qp10+Dg1hTZs7sSvhU?=
 =?us-ascii?Q?ss42e46/wHd7hsKwWzcJw0nLd8BuDI9QYffzVDCEByd/tpGcGIZZTqxW/DCY?=
 =?us-ascii?Q?iIn2rn7FpYmolQw7mGEHEMkr1kCrin287Z8Uhbxw+THQTzTjnjnEb/LKYjOw?=
 =?us-ascii?Q?qfpl4955uWsvtrw3zEvZu71nL89xvS+ZDYaNMegxWQhd2bY++dVZBHWmxcSw?=
 =?us-ascii?Q?Yw6GHmONApEhboeCGw1F2X67uO7XvRgcxdxn5IkyQHFxtTvgKvMuShv88PxY?=
 =?us-ascii?Q?qawJYMF0naaQj804pXLIwjEb2XxU7HtKc5CIPG+VfmO8NoERDrCNvMAfvre3?=
 =?us-ascii?Q?qzJjwmcjJV1aYEhueL0m5oeh6z9DT/4/DY8GypSrRv0E+noWNeu0dQcT/dof?=
 =?us-ascii?Q?LH+xLjQ8paVjUhwvLsG3yM9AIFNXFknKTX3JjwWyMN4X/rBCBqLgJFBjwgiU?=
 =?us-ascii?Q?JvvEzBmEpiU//d96bjroR88QiWvmU/okGEvWROOdTZb/uaByAnSadiqM2RT9?=
 =?us-ascii?Q?iB0p4av6O3gfUQC/DbCUXi0BZrQLIPvJdDUqp+3BlanbGAnKBEDUd3Vp0jHa?=
 =?us-ascii?Q?/jqs2uxNVCgNNH/W5eL2LyUu7O4olbrvE2Tyl02zKMh+SlLUBV7MKiA2auf8?=
 =?us-ascii?Q?IW2oQHND+NILzR7daluylzLUXDj2jJP0yi8xrjY4Wfr+17GwnzIaUtjwqCDi?=
 =?us-ascii?Q?KsmrDix88NEpmgRBL/eSXHTcmnL8MQi3x4giMnhj+NhkPPAFemUFsR95oHTs?=
 =?us-ascii?Q?4xUx3pezVXvhpBZJWX+UAErfvoUV8RA5lLXkZGmNgYGbWBz69pXJubFmUXsd?=
 =?us-ascii?Q?zTl40sdBCf6kbGGpJ6l8seJOF4vXa1NZ7NxrNIx/9imSp1bpUfWSeQTzEby4?=
 =?us-ascii?Q?M2S32QENMqOBtTYGVc4W7RRHydkNztcGPlteqcx8Kv5bJ3jOAvsgU+m6ZO3v?=
 =?us-ascii?Q?VhLMGxyRZkmhRiCdBQiWDkd4HMXRdRmZAeVvaq39G7o0uEc4h+DP/gXf2Xd6?=
 =?us-ascii?Q?PsZ3vcZgsRrHb9SAYaeSqAAzYVBIqgROn6SdmdkrDPTuTTiJgdGTNhQAqd3Z?=
 =?us-ascii?Q?TKs3hZItW0Vf6NwsC6kOtLvOOWGGa1oAWbVSuB3BxKebKuw1REJfEVUgmOQC?=
 =?us-ascii?Q?e+IZ/cr5iCcIB+xzZjlYEFG3aWS7qKj5ay+mEEsH/D3J8XINZ1k4tnhFRpPZ?=
 =?us-ascii?Q?gmMfFwrBsg6e5RKt8jUC1qRWYb0fDY75zjIVjPdZQobKjAYfF/7v/rSG+VJW?=
 =?us-ascii?Q?mf41DBMbl+CWsVUeVFiT6RO6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f234af10-211b-491b-0bbc-08d953cb003f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2021 02:29:19.9125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5gv733vyaE6dBohavWVimVYh1qYWgf+sZ6XzYLMfmTHxbEdQ628iOhcnSLp7/a8u4J4D/JDEloDnyqmceQT87Xq9AHipl04JpuV2yRFEEMs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5482
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10061 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=768 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107310009
X-Proofpoint-ORIG-GUID: I_OPpL4sGX4u3PAQSPVqYVzzHihe5MQL
X-Proofpoint-GUID: I_OPpL4sGX4u3PAQSPVqYVzzHihe5MQL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> this is the next round of bsg cleanups based on the previous scsi
> ioctl changes.  The biggest changes are major simplification of how
> the bsg nodes are created and found, and a simplification of the
> interface between the frontend in bsg.c and the two backends.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
