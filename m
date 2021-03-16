Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 005F9C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 02:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7D5E64F69
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 02:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbhCPCd3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 22:33:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33372 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234643AbhCPCdR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 22:33:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G2U4FD013290;
        Tue, 16 Mar 2021 02:30:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=67ayGYyPGk5h+zUTA5QWC8yNcymjn9Y/E/omlWbnN04=;
 b=OoCinySZXNzID8WaHK5D4UluCS+SwBwMle1brAqyYZSKHgagv7bajcLOankb5FVVekwo
 B6scfh/JQ/anKMSUB+8hFo2EaDlEKtb4kwpCheYVCpULMLF6xAdw84W1ClxpNHB00tEn
 8jQbUJNGw7dpLrAVr40cTYNJf/ydwnnRCmUx6OO/TjU0wx5dF0393PNLRcxxvgQccyIs
 q4zR+6B0L09QCGYssq8ZOpAGX2lcMNe4Djphg4EZyyNXcYwCxwQvd8xFEYNhluzihHgI
 UKQpnq2CF4+X7M/7ymZRQ8nAMrfFCELbpHYhr3s02ZXl2vX4TlSe/EIvIZgGt0b5y+zN lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 378p1np21d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 02:30:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G2PeEb011624;
        Tue, 16 Mar 2021 02:30:03 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 3797a0mbyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 02:30:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nfhTe1Sz/yRwwcvJy+Qe5faRnaxqgUah9NQ13pkOiX3hEQ4hCmVV6vUvO5LIAPWHMXYbvBraDY10cyLcPiTpFLOzXs9/LQxLgIhEl1qvGB8uH6Sbhq6VSmxOtKUJ37Z0ciYODIf9xTNUsLcO7GWmqdL7ju9wdHsCpTrDP2BDZRHPZf6S+XaT8HLF8+klXf3aEdxpjyh9LMZRmngS2+rPjNgQLKUMZPiJqmOpWnGplzSq1pQ/HKuYGOrRU1kcEoAWhcOrjNq3v4R0Hs6fdhrYaoEJY/9AALMfAaW3nA4V3csoZSnhfquTnVb9M3fDCPkoDXMGfD38U5ClT4cA6KW4Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67ayGYyPGk5h+zUTA5QWC8yNcymjn9Y/E/omlWbnN04=;
 b=kTg2Ags0DKDOIqzNQUm8Iq50pN8wosxTfijqC1r0meoMe9nwY1A5ErhMzZRab5+TKE2qrvllXEiv70Dwej+WwEIn9hO7KlyKbtKIXdSqTPsK/Qd7nYOGZea4miDVGPTwM00dQmZeoMLGRda8qCTNwHaN/rAyqtawlbeT7/9HA+4c1zUFPbbungQvf8YJPlIzW8M3gsevtCFnxKVLmUN+lMjfbGIDl5d9JT3yjRv4b5s7CKmCmAeHA8nPdvIS2hGzuysJgLVBFyNycJlpTaO5cO0Rz9ggOzkO8BEpTfHfX3ZqUvz+5tL+INc/iD2/qG0gYmwNeLCo6etVr/MioWENYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67ayGYyPGk5h+zUTA5QWC8yNcymjn9Y/E/omlWbnN04=;
 b=baAJi8rTnbGqrpkBQK+O7F7GuJ/kJ0lulYO2TMHkapyVREm01MAC8XO7h7MXA16G53/g+w/xPj/YTGlMtHv7Cz8Jp+Z2/F6pR/ZNSMG6PitPYZv1+Xwn8vlbyHYsNxmkHgPQpVTbP6tlfaEu0EQhe7VB3+GP+2bIuv8yBNoRpM0=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4565.namprd10.prod.outlook.com (2603:10b6:510:31::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Tue, 16 Mar
 2021 02:30:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 02:30:00 +0000
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Adam Radford <aradford@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ali Akcaagac <aliakc@web.de>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andre Hedrick <andre@suse.com>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Anil Veerabhadrappa <anilgv@broadcom.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bas Vermeulen <bvermeul@blackstar.xs4all.nl>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Brian Macy <bmacy@sunshinecomputing.com>,
        Christoph Hellwig <hch@lst.de>,
        "C.L. Huang" <ching@tekram.com.tw>, dc395x@twibble.org,
        de Melo <acme@conectiva.com.br>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Dimitris Michailidis <dm@chelsio.com>,
        Doug Ledford <dledford@redhat.com>,
        Eddie Wai <eddie.wai@broadcom.com>,
        Erich Chen <erich@tekram.com.tw>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Smart <james.smart@broadcom.com>,
        Jamie Lenehan <lenehan@twibble.org>,
        Jan Kotas <jank@cadence.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        Joel Jacobson <linux@3ware.com>, Karen Xie <kxie@chelsio.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Kurt Garloff <garloff@suse.de>,
        "Leonard N. Zubkoff" <lnz@dandelion.com>,
        linux-drivers@broadcom.com, Linux GmbH <hare@suse.com>,
        linux-scsi@vger.kernel.org,
        Manish Rangankar <mrangankar@marvell.com>,
        Marcelo Tosatti <marcelo@conectiva.com.br>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@avagotech.com,
        MPT-FusionLinux.pdl@broadcom.com,
        Nathaniel Clark <nate@misrule.us>,
        "Nicholas A. Bellinger" <nab@kernel.org>,
        Nilesh Javali <njavali@marvell.com>,
        Oliver Neukum <oliver@neukum.org>,
        QLogic-Storage-Upstream@qlogic.com,
        Santosh Yaraganavi <santosh.sy@samsung.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vinayak Holikatti <h.vinayak@samsung.com>,
        Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 00/30] [Set 2] Rid W=1 warnings in SCSI
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15z1r6db8.fsf@ca-mkp.ca.oracle.com>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
Date:   Mon, 15 Mar 2021 22:29:57 -0400
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org> (Lee Jones's
        message of "Fri, 12 Mar 2021 09:47:08 +0000")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY5PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY5PR04CA0013.namprd04.prod.outlook.com (2603:10b6:a03:1d0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 02:29:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86d45e75-2aa0-4c80-97dc-08d8e823657f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4565:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45654A942932203A5CDA2B168E6B9@PH0PR10MB4565.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XFfaWch+/R7XN0GRNcR5amJXWl3Iq2wZeedOREqy8o0qAywR0URFg4er/y9ssyCipjxpyOmcaqTQcZfg4vMR90vDZpMzbxu85MtmlH9NPOesP1odZebs+upbxvDmmDOue8VQ4PKnQqvYg1zf+CUazHv/0Cbb2WOI7yExlcZqyUXO+rVa8Og+9Wqrfw4kLytnH0W7YdYXlieeNhz62KAn5CW7txdR8gmg9rfNqSsTqEpJ5aQxEHshjqyG9SBXHtGSGT6JYQRy3vjOn9HnK8YEklz3azN1JJfG6zXHDKtkuyIW1zJD8Q3bTehhIsjdPkO/H7ZSCK6blsAssEx8SrbpsBGReJ+0FsafmotNx0of3XI+NkE0Z9C5pKqbc4Cj/S++awuOVMNjETvSEgFVNi9trdSVcds9fTxmnTftwEYV4y/alrmfqelephCvfnbMFjJbCVbjPrY51fgi7TSMp8AS8vbICjr4ifkykSpjic4dwqbLOoGOTjNgSADmML3q5Uuh2uwk2yP041SW6RXx0Bw4HMYpfwGzgkAlCepvh+A9Pp/pl1h7EnWj7x5c2MhJYBup
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(376002)(366004)(136003)(316002)(36916002)(86362001)(52116002)(26005)(7696005)(956004)(83380400001)(54906003)(55016002)(66476007)(8936002)(186003)(6916009)(7406005)(16526019)(478600001)(66556008)(8676002)(5660300002)(7416002)(66946007)(7366002)(2906002)(558084003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ies6HeDKLgO2LehGscsTJ0fGZZ4BG9aUA+PUGn0RoL6muNSI3pps6to/V1j4?=
 =?us-ascii?Q?ZaCaGffgNLoyzs6rGHCuBKTjdxbg2dX2WFqgdD0Z1mfmGKciu/RUo/xsBm9/?=
 =?us-ascii?Q?m6stfUkJ+9S8l2LrZLLkkpgM2EVB+9OzQkKMAkqqsLsz7reNNYy6ErZRrGUs?=
 =?us-ascii?Q?NMfW/+QYpZm/fZ/VEBM/Vb1Csgv1WjNPTn1+Q9mD0FJDSYibFoa3ifdIKKDO?=
 =?us-ascii?Q?kyWbMxp4WpM86XDSZ0IerqZ3PdvMkNlJn+/TLuMCcyOqDZmCxrYTlHxZDtN1?=
 =?us-ascii?Q?rNQptcP8/SCrexMwvneXwg50Vp/evyewoPFT1iyoWO0BcZK+dZzFd1hGvBGu?=
 =?us-ascii?Q?KIsLj1CE86pgXgbxVmc0ZzcvmwodV42QaL+AIeuRYPen2O4s6Woo8kuk18Gy?=
 =?us-ascii?Q?0PDXB3PMDnmYLctNaW5lWB7QG7+Ttidl2DpD2BXCfKyFiIypmnscHMUoC7vC?=
 =?us-ascii?Q?eZqbmuu64l52DjZeuoqe+Juqh2+N2I9LJOPZAybio/jTE3duLffw9Ys2ONAM?=
 =?us-ascii?Q?Fpyfvf/xhDMDm8ccIZT2ShtC/0LVFWryQfx4AuNJbehz1dHNUibIMUluefso?=
 =?us-ascii?Q?LcgTqdFCEInBaPOe+JaPfaMe1VQl/1gdb+p4jw8nxIaK1xICgqtJi2sa6NX3?=
 =?us-ascii?Q?UGzv1MbF8XOgEHr9z1yJFjp4r0RlURBO97nB3lbhk/Gk/wI2L8xztpn/1LNC?=
 =?us-ascii?Q?GA6eTG5re6LrryaRvM/AigbByz+8MPU+uUHfYm83E4FS1pi/nJ5zYKMIfIV2?=
 =?us-ascii?Q?FxQ12GUsPhj0mjMu7oOFocqjFI07ZgcdFrLTe+QL9O6wBmoF+/N2I96fQuyk?=
 =?us-ascii?Q?/TIS82knFVvyrLDFyyp0oAD6mZLHdQryCfUKNaE5PF8qZvfUhygfXXprLeMP?=
 =?us-ascii?Q?pSPA2BWyoLoZ/2zHVf7+9wc6/m27FsXk7VxqrDyH6e+JENjtVVyI8hZ3dzho?=
 =?us-ascii?Q?6svSHEStVzY4SLPtnOC3aMxT0wfZsTja9m9wYc0Ueb6N6psKM5HM2Af4ozAp?=
 =?us-ascii?Q?zRBDCzq16R5fP4+dGpLJqoAKYCvtPzrpe2C1Rz4PHCTo8TVt4CjMfQTBdxZw?=
 =?us-ascii?Q?lKY8cFKvPPsdLJW3d9M+lavsSgNiU2mu1WeFSoHAs4jeaFP+XexBJnEqq4Ni?=
 =?us-ascii?Q?cP/0sxhiDPFVACOQ5+Kj4z3IMyDZh5WzA8jTC2aLNDxBcHaRdERtlgNR6/Rw?=
 =?us-ascii?Q?0YU4ib2yRLbqPp4/L05UunyyRbf73mxdtcE4WY7oCVdDRkfC5zcxNhrs2JQ1?=
 =?us-ascii?Q?4+0l6gxSHCyRthcgwQshB7HVlpxIP2GR7fsF0kVdh3jZCuDgTu5MuqdGCk/M?=
 =?us-ascii?Q?OLxnlMkbE6B7g4SpkdBQuAep?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86d45e75-2aa0-4c80-97dc-08d8e823657f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 02:29:59.8888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Epn2asMRc+i91msDRXSsGZi7+4cHumHGQ4FqgnT78TWu6U7iyJbnKpzGr8J3GLm9HQTul3L0hJT5dlth40z22VPN62WAbNuOrfqjK4FxOFU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4565
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160016
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1011 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Lee,

> This set is part of a larger effort attempting to clean-up W=1 kernel
> builds, which are currently overwhelmingly riddled with niggly little
> warnings.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
