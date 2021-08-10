Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25CB4C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0360D60551
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhHJED4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 00:03:56 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:64012 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229459AbhHJEDz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 00:03:55 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A41ZY5008358;
        Tue, 10 Aug 2021 04:03:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=3K+CwGRPIKp7U/dzskAEvGqBqSZxoA/Vu5CsMXEjxcQ=;
 b=TSNAO5cChjBNcPF6p4Pii1YkjFF7EyBUtDkiQFxpmN4cJ2O1PumdztE1UM3UKhD3chEa
 wUXzW6px2D8XpFWqNlbwMkgyjLTA04VLJOaWz9zgaEbieYwyKJXBw094d3mIzbVONi8c
 Pn4q8SJoIDKsnYT4giB2U0qOgigWlm5qQcRVZqrbzUDi6c8/S67IMvgq5jCubkS2DlgM
 gf/HzEkbcHrKtKET6/O+lwwl8qE/ufcLZ+vsNzf4MISYiuc6d+qzk3yM7xli2OW8thqH
 HFe45Ax0x64egcC2Yf2FaVRvMU6WX9ckFNv4YnP27sLwO0YADYIPKB1L4piPvJxwfcss Vw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=3K+CwGRPIKp7U/dzskAEvGqBqSZxoA/Vu5CsMXEjxcQ=;
 b=Zb8syXXG/95hcdLXx624Mw/xevya1fJ51B3FyXNApRaEu5rr8XIM2Ia+DeRThh5Klr0Z
 9eFtJAfz67No57fPODGg92/YFDDGEqEECoudGnqtR88VXxx3YkrqUTcsIIMkpahbtmDA
 6c+4Pogz84U1c3/3CxAximagC2SWeIXF4BaXE2vWBujuvraesQ+X2PKA9u6zfhcHwxoW
 SEO7ym3FzjPjcmCSMhQV/ErPSfeJ4utNnqsv3aaOrPmaAEcWI8lT+6hlgovCGQx/ddsa
 mvQ0P574Bfsep98QH/rNLwBsk1Iaw0MJRkqwQYDKyKSCm/KBAvqFH1ktXdzp3ekPnuuU WQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aav18jv2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 04:03:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A3xAS6155996;
        Tue, 10 Aug 2021 04:03:26 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by userp3020.oracle.com with ESMTP id 3aa3xsbxtq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 04:03:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J9vEg7+GbLmQifEaXb61StvC0aBbTVdpsz903tdGk686FYbuG5Dbg5S1R1SEzbmEgSiVtKyRopTCJftwgtDQonBh5Cw1qs32HJ4R/hO95asD912Y6zVrn+emKXvjj8VMe8BJmL3fTIoSkysc55SsxmWSAmaaeGoQxHDtQM6QsNRlhJCeFmOFBxAf6igGCMosvy+7sPe/rVys9PTWs79hp8pQvyz/06G+UKdddFw6Re5frNpN6ZpVDcVLRWq+QFMdBxThA3SeuT9dnRZ0KOUMurfIRLlkc7r9NONaKzrOvhIP5IDExE2CJlbXUIE3RE7go04GkDoVIQAn80RknN5wpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3K+CwGRPIKp7U/dzskAEvGqBqSZxoA/Vu5CsMXEjxcQ=;
 b=gUywi/3swYF6oV8rO5Ma8f+p781ZN8VACKbLbJ2hfm5f+89AQc8vAVqsemL4a64yr7Uxl10B0V+7mOXhw8k048vmBCbe5IkHVTPEAIJVcsJKkfix0SDoLHqKLjKwOR5qLOagGyO5dYzWdRh8tujHbdXoDVbd4AZeP7wnqwDG65xksttvCuf0L1+Ey4n70GF1k3krEwSHuQhR2q9aOeS8EIkdSAq+v4jv5GKNsWCreKLnYgJ3DK/tRlh79kHvv8pT8NtNOU3ocAFJ9FAy5lzsBCCxUDyY/fDZtUP92s9xpBogcHLJbUsbNadaP2YeDuch5b+d7sEG0IpBM8qFwa4fYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3K+CwGRPIKp7U/dzskAEvGqBqSZxoA/Vu5CsMXEjxcQ=;
 b=CdeEJayUXnPzgL+IL813dBT2rLZJnzN0X+28NV1BD+N1ReVRhPVbBsVucpCqG3zXNoMexCcCafaSi/7G3CJK5jfnR52pSf2RLTqD0J88W9ZAi+Je8MdlBB+EkiS4GIL7E0ogEklRzE3oZV8izEO5mGgwTP3Yzqrx4UxaE2oP2vs=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4600.namprd10.prod.outlook.com (2603:10b6:510:36::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 10 Aug
 2021 04:03:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 04:03:23 +0000
To:     Avri Altman <avri.altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>
Subject: Re: [PATCH 0/4] scsi: ufs: Few HPB fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsviuetb.fsf@ca-mkp.ca.oracle.com>
References: <20210808090024.21721-1-avri.altman@wdc.com>
Date:   Tue, 10 Aug 2021 00:03:21 -0400
In-Reply-To: <20210808090024.21721-1-avri.altman@wdc.com> (Avri Altman's
        message of "Sun, 8 Aug 2021 12:00:20 +0300")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY5PR04CA0002.namprd04.prod.outlook.com (2603:10b6:a03:1d0::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 04:03:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa4de3e2-8644-4cd2-3de0-08d95bb3cc67
X-MS-TrafficTypeDiagnostic: PH0PR10MB4600:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4600672B06B7AA77A05EF6128EF79@PH0PR10MB4600.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f3eeFhgSmE9istddgDDRi6SSyoY53P3SSIh+y99ARv3i0OaURI+pybRNRETeARlv2FztkwgOmCHpscUsHdL++og89s0kDxVKbLG+Vpkv/VRusHb1DgvmdhdTvoPkmdjWD9mviDo3xvzSpuj58rotGRWjU4X9lR+LDpA+NtJfsbpatyc6X5+seGDUF5B9kGvsHvN+uSIFhqNttGbCM2rvqtfzznrL5TQ0WOnvJPb6yXsOB6x1rWawWP+XUGR7mVnIfP+57K3ZrpYIEIshTXqsTRrXrBT4C6V71sMnHLGYQJzSvvH27fl9PbG/tb00rYu70s0elRNU6Q0Iz+jpYxHq7GRWosHhrZhi45Tus4ejdc+KZ6r+lgjuMFFVzNOLmF0NehNZdZRTprv8gkgQpCIxyT7i2u1vdebq7Cu3mR9FTMisgFg8V1gE8BB+mPu8vG/zIYUOfV5Pocip1UhmeQGrHRM34YPnSQxKA2FPxdtjZ2DNLLBeovX3LlX0GQG13U+hHyh1YeV+Jhx9aoGrTtmMuKng3FvDqBC6nt4cBbTrjCiEpF1mvxgi/F4TLYYBDRU2liRgxJYpjnwKlG4RGQKNt/DF4jlZaPEVy2xoTrqVc4RNt0MGGnQKzFXl880UkqEJ988Mqjbj3iHPkN6/uQmkq1lnRbgFZVjv1fSyKN/RQQO7SIg8z4WoJZ1qZ9WgeI07J1wOPSnT670ptfRaX+0Heg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(136003)(346002)(376002)(396003)(558084003)(26005)(8936002)(5660300002)(478600001)(4326008)(6916009)(8676002)(2906002)(86362001)(55016002)(54906003)(7696005)(36916002)(186003)(316002)(38350700002)(38100700002)(66476007)(52116002)(66946007)(956004)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HzreCgT/jZTSKdmgh98I+Z+bTr5LauJ70h1ZjT2/EeSC5mg03SRufmvciZO6?=
 =?us-ascii?Q?WlAc3tOOw4LuTyK/vLUkEll4MV7Zv0iJiEtv8jAnbJA8ChoZhXfJyzKvwxCx?=
 =?us-ascii?Q?7ugQuau1CkhLYAS9rgmKPfUD4DsztMKJBmX2LK1td/RTDbIr6XJjSj+Ow2pJ?=
 =?us-ascii?Q?ZwhwbNNKYa04C6T/QP2Ll1mSL0pWydQhJ4jd8innWGNSRn5mITqDPBy4oYBS?=
 =?us-ascii?Q?emlWkCkkYpgstBp8zamJidfoO8vc7m0/tyKcbrrt25ROCxMJq1TglJqZxjtB?=
 =?us-ascii?Q?YlDixWrW05pCI2EQawbkPgnoxaaysRh8rCytJWnCUfOY8azxOLOovuPKzC8a?=
 =?us-ascii?Q?HBVdzmgZLj0NoCndF2YZSNe91IMquUoxd/PUUpP1dTxBxdfGOdniiT1rR503?=
 =?us-ascii?Q?SFvh7etZ9UGZFQSSunY0oSUCoTxCHD0E2d83ccpFg3xX9gQtHyr7i+xwGEoC?=
 =?us-ascii?Q?WalO0Oj7tnuFsMVznag+8QKzThCflX3f0J+ht8jlBSKysBW0TImalJwhzl51?=
 =?us-ascii?Q?e6EdkH1t3MKEu+zpzfSHIKmwZS58D6nIlQDEett0560bfsUWELMjyuQNXkDm?=
 =?us-ascii?Q?DZe9LMVqhvrRk+zd+OefSY0OXrTtP9G+gjQnKq+RGE4x/uVYaRl4fopEVcJl?=
 =?us-ascii?Q?IciWmqKQwML5sO21kKAvGA0L1BTrspH5r2sHqXtNE6zIrxXFzBtfpl/rPSyx?=
 =?us-ascii?Q?AXG6t07uvf6Q4SE9PqCQIJ/IMo7aCFEQXeV/LTYHpuzjuQXNkyo0vAC+1V01?=
 =?us-ascii?Q?i9/Ya2ko8E75l3AhtJ/M9f/OlQ4ZW1FOvu2Yz6ljjN3QpX2TNBeow+cvHXCS?=
 =?us-ascii?Q?ETh/v1ZjrQwDwO4yWyFYIFIHSOoq6ji4ocv0VDGdRvH4vf/keeDngSGAkv6D?=
 =?us-ascii?Q?Pzjsj+Oy6t0N+4OQDkfxZpwa7XAf//29O8eA1nqsm7dePYx6wtl3viu2rgnG?=
 =?us-ascii?Q?BkERVY6KOqCTaOw2Obv7YQP59opCGKhWMb0PrrSjSI3d13TdoQNMqFByjTG4?=
 =?us-ascii?Q?MGvBujMH4M1nBeu8RWPBOpfmsB8aXZrtGw7fXQ4f8pZPr6Dmyldxagj6/v0+?=
 =?us-ascii?Q?adWUwyLOcpmsUANCO2RDGyWGky6UqRcaARm0qSpPHBgh2JdfIEinIYOasSDV?=
 =?us-ascii?Q?OycZlF7JqNdiURrfKg5/scOujqhIZmSH6VgVz5ryQBVd0S2giQ0rjdIJ9uH3?=
 =?us-ascii?Q?gInbbQH00lsiv0B8pneTAovlZQ+vT6ET00MjeXJpMij/QWofU4W1kdNg1TXL?=
 =?us-ascii?Q?0Ri6OHSlGYDQbQcKTDWWrwNVWKrWUb58TWGJU0oWw2s7n8KibjFZN4+ZO6mg?=
 =?us-ascii?Q?vl8E3Mip6fKeHpcdBXZunJuJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4de3e2-8644-4cd2-3de0-08d95bb3cc67
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 04:03:23.7601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uhv5a/EdJ8bRUQkARax773tmGr/Tc0BK5ju+elOpoAd+eWs3fHfBvo8/7Rx2LspTj2bdeGHb7ilM9OdK+cokcpLNqMVFwdQfpXag4va9HnU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4600
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=828 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100024
X-Proofpoint-ORIG-GUID: UoCVflz2XXfCPmT5e972u325DYinnBIX
X-Proofpoint-GUID: UoCVflz2XXfCPmT5e972u325DYinnBIX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Avri,

> This patch series include several hpb fixes, most of them host mode.
> Please consider this patch series for kernel v5.15.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
