Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B7C1C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED7C264F1F
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbhCSDA7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 23:00:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37552 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233493AbhCSDAb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 23:00:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J2tsLt019226;
        Fri, 19 Mar 2021 02:58:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=aLRq90divF6wIwL30clJceTWzYANjRqogdwRl2T+2Mo=;
 b=SxVR8GCZQXELh/SziPEi6t8/u/gKh9CNL6swjABgVf7Id2WIQySljHproDYIUZMVEjSP
 4g/OrVuWxdzGplt1do5zGa7rcAltxedvaJyQPdoyB5kWvNepQUorGWVzPl9db2TH2i9j
 g1g4455sswEQ3w2wCA3ZzQSgODxDrWSsGlVQWHtxWp7N+0sB8OADlyBRke5+N7WbXN/f
 KGIGaVYMIka4gwg++uAKfRggy2Wdq/jAdWy1T6f8MgvNUnng0WlNsDnuAMqRZe7iQViQ
 og23Gv8WsWtb+2ag5VBoCNrIl4b/zrQ27QgzA5APnhQyRnevrqWaD1EFPo69EGdNL507 sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 378nbmhfpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 02:58:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J2o2Te076477;
        Fri, 19 Mar 2021 02:58:24 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 37cf2uyejw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 02:58:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cll8Q9m7pWK0EP42Be75WmRxdT37BLIlHQneFMbVeyqo1j3M/zS20dYCoOo33paka1529OPq2KpzohFg/tUePSSz82mlwm5VJtfQbAeumEx35IIQYSThEh7GtNxCPdSGl8+jrMBEaTuJx95N6NnoVibe3TQ7LrrkqOkyvq0oz+WXRoK96ttpKftC+DxSqVuah/6KV6dCZEut6JnuR158NMqOvi/+cpsjVnfVG1QDW32UYEXUah+5XMG58Kqj52HS90wHZm7H5FfozTtN2R7bXiRzVfKxaPUQXL/qJLF7L22HpYCEP07K/JLJJ3AYUi1eV1jOgMA8Jejzb4yZAGJQRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLRq90divF6wIwL30clJceTWzYANjRqogdwRl2T+2Mo=;
 b=Dj1pBGydS1cBoSUVXQm0GwKnWQy+YZlobg44jDD0P9xC6nYXdYLmfpbE/woK1lMAK5Z/lleSSHWl+ry7BrZpL+sUdFb9GvqMQTCNkBX9Lb6mf2Q+SpqdQqzB9UcLqTujuKupr3Yxo2+1eZAx66BzPSL3evq9OUohyqXk/D3USyM0twkKUDBnXC7qxZoTjzG9nDsOPicShynGdJdlaTxA6uZUQ1DezjoYN6hu+YIC2BaHKwI18eMSlrlRtppo09By1rTgxq/p81ZXZS5ZS3Bkw/BsLUT7ijYzrYYdFsHo+qXJHmam1yidNQAzi2f/8zZj1lXT70PWmuQrEjwtPXeJBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLRq90divF6wIwL30clJceTWzYANjRqogdwRl2T+2Mo=;
 b=yjRfeeGZo20lDSQld+fng8/+70yAqqt4g9O1up0uAfg7h1en6g9Jx7phtd1wNn9YfDPNWmnWGk8x7CNfsW5xIA7kn1DhigBNQu27BWRYI3zcRFGMTg7cFIOY8gSBcjyyTJauSnLE/8+fQ+/4Vga0ta6UlXdfbKfyNxmpov1yjp4=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4488.namprd10.prod.outlook.com (2603:10b6:510:35::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 02:58:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 02:58:22 +0000
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        c by <James.Bottomley@SteelEye.com>,
        GOTO Masanori <gotom@debian.or.jp>, gotom@debian.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Khalid Aziz <khalid@gonehiking.org>,
        "Leonard N. Zubkoff" <lnz@dandelion.com>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Richard Hirst <richard@sleepie.demon.co.uk>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: Re: [PATCH 0/8] [Set 3 v2] Rid W=1 warnings in SCSI
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15z1nq2fw.fsf@ca-mkp.ca.oracle.com>
References: <20210317091125.2910058-1-lee.jones@linaro.org>
Date:   Thu, 18 Mar 2021 22:58:19 -0400
In-Reply-To: <20210317091125.2910058-1-lee.jones@linaro.org> (Lee Jones's
        message of "Wed, 17 Mar 2021 09:11:17 +0000")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR03CA0319.namprd03.prod.outlook.com
 (2603:10b6:a03:39d::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0319.namprd03.prod.outlook.com (2603:10b6:a03:39d::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 02:58:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed1a813f-1e88-4246-6065-08d8ea82db58
X-MS-TrafficTypeDiagnostic: PH0PR10MB4488:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44880465ADE2A2A5BFA9FBC08E689@PH0PR10MB4488.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iJ739Bpo8tVMUp4tdG6TucnMIYBOT2PReGxgyoDoTQD9nJ2tse63ksyR0yyf7hwWt8q4xNexyBnjrhJztCpEZu68jj35m0pfW+d0opx61cB5wFAGssLOc5Whs6FPcND51pkhP2i9X4msnLOcqaw4SQPW/EX3HOhKg5cqquqmy9tcBvcHvFWFdrqCydD063lCDj+NjSey9LiWKwka2FB1B0Pa8Xa+1fNmJt7u4B8fxwgBio2oNyX0dAOxFv+klZzE6IH0QVcNLfOrmAdQ933l9zbm4xaGeCkDFMSXzLJohcir5KVHyt/m5EAlldGAIELfujT6qixfC5KPswN23Kl6mwE1dpvlJ9cZARQ9cGQQAaaDJf10pTjriwP0AhWwQFWQgLk3HwTZKq3NENOxpghUt4tZJosDhxlNA6YAYjpxCcSchoVFMmJRMtzqF221BBYVaxopRHq4IgPmMeuTuzu28s5O1gOMM0xwnPPSgAit4rCUlFW+VsAj48+kv6pEjeRnko1ItKw3+kQqIigE6385yH9fc8jtKPcXE+TGs+T6oqf62Q0unYR/ZbaRuLvI4DW8Dgh6Nz6Owci/edC2KvTBh8xx/2YGWy8U/cN/OdpBInhHvhNgW9Z2ryCwN5NMqPfufHR/22KvMVrQnsenwh/jrOE5NnFvAaVsd4m/6cDgYFM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(396003)(39860400002)(366004)(7696005)(83380400001)(26005)(316002)(16526019)(186003)(5660300002)(36916002)(52116002)(86362001)(55016002)(8936002)(54906003)(66556008)(66946007)(4326008)(2906002)(7416002)(66476007)(956004)(558084003)(6916009)(8676002)(478600001)(38100700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4fpdzHYKBK5l4Rakpgla4mg2ylCW16bBgilAOgEzK9A1xsuIB1MFSSSMXgrF?=
 =?us-ascii?Q?HC+LB4/ycdWj/fPW9b8qqCuHoOIb4HOVH3CH2lrMcYkkv/JJGA+lixR4Uadq?=
 =?us-ascii?Q?usgJ072/BMEVfxc49xgIVQLNn41VmfA9cO91tKy2Q+fgt1uRVTRB0gSGkMe5?=
 =?us-ascii?Q?MCDLgbI8GSsMKCNkYdEi9qG5VbIIWBGTjDLfNyl58NrS9tRbfRRSsi4ajfWD?=
 =?us-ascii?Q?1t/pEy5tdAuRGFLUEz01HTW9hq8UvjDrShvCCHZMmpMl/qyNFafvrS7eS/hP?=
 =?us-ascii?Q?WTtidT4/5jmWxL9pNETOB59ohQIFqdGKADec+phnY6YLRMc7jp57c7Hat+iK?=
 =?us-ascii?Q?7Fil9jTKX0cM9FKfJce9rZCQ3D8iNWdv6hPi8hU4a3qDzQAxyJyiOGwXrCIN?=
 =?us-ascii?Q?RcfbZPBbS1Em3VVt8W446dVYw4oHARIJEdZrz14HhRVidxPTpOIH+CqamiOQ?=
 =?us-ascii?Q?v+8RueWD36ZehS1nP0TvZdLn8CYodd7SNefRexHa2y+3sRVOVDHy34oKKCJ8?=
 =?us-ascii?Q?sjoBPrLtlYTFFIPU2NgjNmwk/MXWXp4ymkdIqENZxlLspWAT3fWzyIPNPJi6?=
 =?us-ascii?Q?OkDk3/wSTRnD2EUYUn+KNOhk++C2x6phtwq4JpUAFNwyz3iEdK6o+jNj3WgS?=
 =?us-ascii?Q?0u7dk/1LuJBmabkp+Gw5hH01A8d40ilF3uATZOYVBnMpwH8m0Se8yLnEoh8x?=
 =?us-ascii?Q?VLxW8TpyB11bmnRU+XBctBjhcYExlvPovdGo8noZJLOwCRFmiaRWSSWzHPh0?=
 =?us-ascii?Q?oR29pNSqSpKqEdHGz6K0nQUE+YBQ7myDITVTg+d4vOpbIYEAVXz+KZsxChMl?=
 =?us-ascii?Q?HqEmudSfP0OFVm1C9nTp6Jw+9eFIvV/5lRUf2/ov7GFjLwSKt/yGYBizqoA6?=
 =?us-ascii?Q?vKFqzasudiCVpDo9yevDyd0xpuUYCBiujIgPI50XO86ePnXbVMa3VVhKYqgr?=
 =?us-ascii?Q?XInvXF2kh0SzR6yfeD7SPe7HW2kE70NGfzwLlWp0ggahdmVNmS8BRdPdZdlQ?=
 =?us-ascii?Q?J/25IVWeFjy9fxJLnFGXYMp/1fco/yRIrSjlHHAdp3Z4E1k7dy0HoDHr+JCD?=
 =?us-ascii?Q?LEGT/5ZYBbo3zU85lj6OVPlHsRoniOJelO3+7uKo2IHyTZVWgiFRxaSrER/j?=
 =?us-ascii?Q?sF0EQ8+7squvQ3mmMJW6JPQwsQ339kR+33j8EfPATX+fU8eVnK3TDLEsFnSa?=
 =?us-ascii?Q?qUCwKFFiXwEAsjqa9pvVV2mCJyDUNg6jcVjb7IWnavkIaDQEXKGxWA0y9oP2?=
 =?us-ascii?Q?0kb/AVKSBPUN4LF7DlujubNwnlV17XzK/lzLHw72NEuJAT+Mwe0mh4aFrE3a?=
 =?us-ascii?Q?Vrd27MgyOIpeChrr5tDL2INo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed1a813f-1e88-4246-6065-08d8ea82db58
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 02:58:22.0889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yRtWp5YWgrO6NVyhgrJ7wxycmcJV8aeFIih0nnf+JoSWEhZuwSGiOToxCzClKFlvMg7b6yUawN4u4EmLZkQ0ZgvCDYU5e7ggU6G3f5dOAS0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4488
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190020
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 impostorscore=0
 malwarescore=0 adultscore=0 mlxscore=0 clxscore=1011 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Lee,

> This set contains functional changes.
>
> This set is part of a larger effort attempting to clean-up W=1
> kernel builds, which are currently overwhelmingly riddled with
> niggly little warnings.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
