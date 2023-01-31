Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A558C636D3
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Jan 2023 02:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjAaCuV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 21:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjAaCuU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 21:50:20 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5879029170;
        Mon, 30 Jan 2023 18:50:18 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30UMi8Jg016644;
        Tue, 31 Jan 2023 02:50:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=7fSj7ByM7JlNgD3rrANNp5oeILqWd7bo9pvqrwOaP/E=;
 b=oHKv2qewezfpdC0xxMrfo9VEZMl0wR/XjWjM60PF6lZSZXsiefj+u0sZA63QAScJEvrf
 /UHnYmSfid0x8R7xmSVhjBeiYXLhkhFzVLPOSuCgNtEExAmxo9O9JTFa+elu1Zc4ap/s
 b1YER0M4rSZj8IP/18CWnGpD0u7upVM1yYDrKw1Jo8Y6M4NnnEGqxghbvghSm1smdfPB
 FoENvDWrkRd98zCbeqluOu88KhqCTu40aZm+gYI5O4sY4CSeN+vCS04ao/5jMkgHyV2m
 b6BLEgpIRlzS618hQIT3lPQ7natUoRCgnZc6SyrHJDI4uIgXGwDkGeT/GaEazYVHS9gp Cg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvp14g5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 02:50:06 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30V03LvZ027555;
        Tue, 31 Jan 2023 02:50:05 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nct5c9n87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 02:50:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OzqG6YZfLig/ABaI0LQAa4MDn/E4ftfMaofCG/dnAttQ2SFQKZuHff0HUucK7sY1l6k3/dTh5s8h9fS97SJq5Gy4pvxkKXBo50Q9vP54eVO3WkzbyvfkQnS+WNbGtqZxhLBTSnegcwloCpsH4lzCx4HJ1rxvhsUWRnKtEyG9kxV1sVYOBtvMAOcSQYlU5RYWFBParW23X9U098zFHNX+MVl73uqjtWNiJTROkVorjBM4yYlEmFWhxFQeGzuxmlWWvMCsxQloBknwUrrQsrgOoaOL2QO+hx3IqaC18XDJEtKJuv7omqm9lvIttOZrbT9jYuhbHlqwEPMzD2cyowykcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7fSj7ByM7JlNgD3rrANNp5oeILqWd7bo9pvqrwOaP/E=;
 b=LGxYixU3ecAdrKICRB3VpuThuGUtLLyjMatZ/JPt9ZaFNxc0nNNHmx3TdegBSZgGgNaj6M1njDqjKC656eRpzfGygwftUZT77OoxdYbC4nwI44ggAxpY/T6io7wJmHa0jifPALaZ2eB+Yp3Vpn3tQnRAFGDe/vORmYSAf8MhRgx/qNVQrroyQE+Z9PtN/H3WW5Hvu0/j4SM71PwAbQhD1b0iWgUumxwNiMQmETizdsMbZpeEvqspJPi4yT85idsC8LGNiYcSfmUPd/DkCFjIfYX2REeJ60xo+N4ALg6Hi/x2JPJoiY7RypvwBkzwHPybOkbnY/whWvMSdV/1cL4M9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7fSj7ByM7JlNgD3rrANNp5oeILqWd7bo9pvqrwOaP/E=;
 b=yxSJjIEBQzWOP/iYWAI92ok+LaqIkIEzBuc4346IdUT/2uKSYMKT2cRNpP4kS76JtxLnTV5CwAj/clI6RJVjcOlH1zKteqGAaFdPRWWyn5pI9DNDm09pgLO9D8ONVA/mds18amfkI45JXR+OPzkdLjWFYhtRYZYXmWTQE4LEZIs=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB7097.namprd10.prod.outlook.com (2603:10b6:510:28f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.10; Tue, 31 Jan
 2023 02:50:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%4]) with mapi id 15.20.6064.020; Tue, 31 Jan 2023
 02:50:03 +0000
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bkmfe88c.fsf@ca-mkp.ca.oracle.com>
References: <20230124190308.127318-2-niklas.cassel@wdc.com>
        <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org>
        <731aeacc-74c0-396b-efa0-f9ae950566d8@opensource.wdc.com>
        <873e0213-94b5-0d81-a8aa-4671241e198c@acm.org>
        <4c345d8b-7efa-85c9-fe1c-1124ea5d9de6@opensource.wdc.com>
        <5066441f-e265-ed64-fa39-f77a931ab998@acm.org>
        <275993f1-f9e8-e7a8-e901-2f7d3a6bb501@opensource.wdc.com>
        <e8324901-7c18-153f-b47f-112a394832bd@acm.org>
        <Y9Gd0eI1t8V61yzO@x1-carbon>
        <86de1e78-0ff2-be70-f592-673bce76e5ac@opensource.wdc.com>
        <Y9KF5z/v0Qp5E4sI@x1-carbon>
        <7f0a2464-673a-f64a-4ebb-e599c3123a24@acm.org>
        <29b50dbd-76e9-cdce-4227-a22223850c9a@opensource.wdc.com>
        <c8ef76be-c285-c797-5bdb-3a960821048b@opensource.wdc.com>
        <ddc88fa1-5aaa-4123-e43b-18dc37f477e9@acm.org>
        <049a7e88-89d1-804f-a0b5-9e5d93d505f7@opensource.wdc.com>
        <b77d5e44-bc1e-7524-7e09-a609ba471dbc@acm.org>
        <4e803108-9526-6a75-f209-789a06ef52f9@opensource.wdc.com>
        <yq1r0veh2fa.fsf@ca-mkp.ca.oracle.com>
        <f8320ff3-0f52-aa0c-635e-c1e7c28ffe25@opensource.wdc.com>
Date:   Mon, 30 Jan 2023 21:49:59 -0500
In-Reply-To: <f8320ff3-0f52-aa0c-635e-c1e7c28ffe25@opensource.wdc.com> (Damien
        Le Moal's message of "Sun, 29 Jan 2023 12:52:30 +0900")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0163.namprd02.prod.outlook.com
 (2603:10b6:5:332::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: 40b2073c-7151-4766-53d3-08db0335da26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OXs8lSxYh/whhd/d51Bd16j8q54rUzG8lNtN1KVvkli2JRkhvIh7oAAOuoLrRLlvU9b1keauCahEGtKMuC2tm+trte8HrvNUZnHMDPhpPMB0PpvfrIwlMF4bGVHEXPnbaz+3OIlv6HloiuO2UZaSYcWvHJCpxeOWpIE1oQYSqsw6dl22ur3h1CNPAD9dL/XsBEioMDuqJYCOvDgqZ9NhE2/TFtXvkJur5tMMcJMHxIP6BGzx2lzPGL0PgKS5i8rUjRj+baOR5Un2RFiXyiWb5tTq/8RDQtjG4eIDjooqJQsxuBFrpdkwBmMIjqMEkGZiwPOtiems4bFwvqCG8RTMauZ0AdXOPQ/jHVN1bEkZkHCM75qku/2GGPj3dx+FwAPqWzec1ifBvVPOUs+JGXj3sXVUiEcdkFsSMbUfgl+wt+PCgPIVGZf47dcrh5kDut9bT0XTIGRY/h/yLpC1onDV3RrFLUcQtuHEijSWAHAxsnvYWzjCupDhPcWDLcV73F/8WfuMOrzUuZsO+TlhL+bTws55E58tZcvmcxuwB0AYI303yJ6SPb3+HwVulfNAYkF+X1iAR3TDFoT+WeHOIk917hLuergUat4oC3ZPKDFzhTRdSFheSeQabTQryn/RKyycCQeXFR13nd1N8sMserh1yQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199018)(41300700001)(38100700002)(86362001)(6666004)(6486002)(478600001)(36916002)(66946007)(6512007)(186003)(66556008)(26005)(6506007)(4326008)(8676002)(6916009)(66476007)(54906003)(316002)(2906002)(8936002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UKzdBdQFg8jA8On15Mlp6cTOjodCOgbvD4nmNQqfBSJ+ejYd8yPrtUe514uV?=
 =?us-ascii?Q?3ps4ldi9VF25pi5dYEFZ6vMdaBh822kTo0FuVq5R3GFn9VLnu1y9MyK5XBBV?=
 =?us-ascii?Q?YfQo8GVQGCYOj2SXgYmFzC2JsXAaE9tJDT2w2ODXM8jG2gJVPXvTYBvpdsI8?=
 =?us-ascii?Q?lRWk93zelzWsogYed+pioRFRgDDeGBZLwKvM60xFjjFV7tBSxLsXuIP2mcaU?=
 =?us-ascii?Q?KJlIMAtXykl2NU45JE0clxD+nxavt0abKJRzc2PCZhJRCWxDI/CbVZrsfnzl?=
 =?us-ascii?Q?04NC/dUSSrxIEgFJqNQCaUTz1fdjNZiV0PjJPC3rWDbPcmnFeO6nmAvGTVUK?=
 =?us-ascii?Q?78BRw25Xis6r1x0kdd65I6SXnn4UHsg8Ipdt/+Nq7KcT6RFpjFuH3b1PD2K3?=
 =?us-ascii?Q?HTErAPz6SJbDHZhwmNgQd1lTS5n2j1Lj+jqljtuJ3/NqIhLN8ZW5oEaWQXaH?=
 =?us-ascii?Q?PGyttbmDTwOVE/z85+XerlE3wpSNtSlpxKCpN4E0LjNba5VSQ/mTM3zr1dgC?=
 =?us-ascii?Q?DC+5RdpM/e9St8Pas26nw9bCCTkxfidUSHF5Qam3gCq7A+FMWf2cGL3Cgqs0?=
 =?us-ascii?Q?OQdo3lKX1bQmUfOq1yv8sjRTEyUCtotUjb2zWDGk7iV8S7fy/nDOcyAyv8oN?=
 =?us-ascii?Q?Qel2XNhQd5iPzrm/y6gYoo8bGTIhSp8XCDITvyOshpl9fGV9o1bNDuMiJ9pc?=
 =?us-ascii?Q?Ieq2Kv3UCQ47cFeHs5Cx42zfYR1KkSwKs/fAI8yj3zfXYmqeTCwOluGyPjrY?=
 =?us-ascii?Q?C901aU5awNM6ySzNTrZCLTqyYtLIXwncRG5NsoPY3dAweD2thMVzFRuFV/AH?=
 =?us-ascii?Q?K60+Mz+2DLgYT667DNEkqKfaCclvV4tXoJfrApLo8v/Ak+dEs7FdieRFb1lc?=
 =?us-ascii?Q?bmJePfjJCDZsdu/Hkh+uNBJTE+0lDif5vfjx8NAeWagHVEWf9ylqNfqRJHUN?=
 =?us-ascii?Q?MSHC5waVOH3yInbB/mzL8WtsiBkRegbYhQENXMbjPkUXsNz4y+JudgiXlzp3?=
 =?us-ascii?Q?pxKOWxjwzROM/Sia3Wulybcp/sV2zc+EbOHstP0JAnZUdSzYKNC+YFsxImCZ?=
 =?us-ascii?Q?O2yH7QxOQ1B5Fz6LJJz1i0PCLUr8I7VmrR9ca8REvGaPVDaM53EoaGAZSoiH?=
 =?us-ascii?Q?jYxZ0JgcfLjzCA+dRnEjWScnpZwfOK9CVK/0SI2tRljRpcKEhJ7onCSY+fRs?=
 =?us-ascii?Q?QXyzVgk6FZ7cu/NsGmB1sQlFoedp5pDQyM+qA4J4vrdS8wNIGwmGy6usF1v8?=
 =?us-ascii?Q?RiDvbFfNjyatkiB5TwG5aNw8Zt6kG4X3pV6DaBKRYD9ga7mARHywGnPfBAwW?=
 =?us-ascii?Q?ynFOb/3U6O8xzN2saDCkd8XTIZ8TCSA/m8Jz3vbsMGsqv+S1j1Vas+utlpbZ?=
 =?us-ascii?Q?MxGzW4jApGmP31YItvVU4nRZrD0AZwyLRf6LoxtqLnfvo0WnOI/qcsFxyCXw?=
 =?us-ascii?Q?8FuCFVUp2TeSxJjqF2teGJKNRhKu3FGw5yv6HQCXzAhIubWvvqKOqoaaEF3F?=
 =?us-ascii?Q?UtzJ533lpTRTckX0QiEvdNE58VTCjKNuOA3Gtnk6EeEPhvKk+JDnWgSlGKpU?=
 =?us-ascii?Q?A3fWo591i9znPxAM8XQjIc+Q5DcLpalMyvGUFHdiGQc8PRpxyvKCaTnkVwLY?=
 =?us-ascii?Q?qQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?y1vdf6Wl1+AYo7L3i3Vy7WPrP7QwS9ya01byYRw7kcfGgnIUzHLTcaBxhiFS?=
 =?us-ascii?Q?9k/NRhxLnYlJlAXssynl66m4+dLBlfvfBPF7OQ2zc2CN1c70kQyzuODL0VE1?=
 =?us-ascii?Q?iVkaBK2XqHpm+qZfk0JtOipaZctFoyWLR5AzAT5Vpmldtaqna4bK83iV3fI8?=
 =?us-ascii?Q?VAoh5VNhTRmGnVQqM0J3enUyxQXupLyUSG4Iuqpg+jHGRBwLAFw+uF+R6EOn?=
 =?us-ascii?Q?BybpJn2uj6nHQqVzp+afEtSIjbAWM2RoQbTmSeNkYfA3J4aUtqa9M6kUXnKU?=
 =?us-ascii?Q?V4LNcghlWenRAIRhhgWwZMlqhPttu5LQpZIhQLdmLRAElzPq1eoDjlV6KUd3?=
 =?us-ascii?Q?5A3Jo0IxLciuGxMFAcpudtHrf9uAQnU6DrTJjiM4C45Zt3EODBD6TpaSu4RV?=
 =?us-ascii?Q?rTCp1mV9bm04YfPiWy7aV66r3V3xRtqPBGwcsT7b/y4Mdu4mSxZ3JFeS9UOM?=
 =?us-ascii?Q?tYey/ZBIdaRkb2NaYizUA56RHuyp70CSqHgEf+1mkcnjPWgk5+LfKqIqHHhw?=
 =?us-ascii?Q?nLWOrbg5PNK4Za7x5WRsezmmJGZHrMzFvKtfTfaFUCwGD6vZu32DS+rhqS2e?=
 =?us-ascii?Q?qcUIZUno1zrkV4Pf4xc6qxO7wnndcHkJ8ncxCZLWWC5At3Ff9jcKp1+WbMtI?=
 =?us-ascii?Q?SL5K0Z5qILN/HDJYl0up671/+qfZo4TOCnOpfxM+g9/xxIu8h+ipTcAz9uyV?=
 =?us-ascii?Q?0OSBCcF1BQPWgx+dbrxHGguWlQAUMaGL6gGpRvMBRGnwcPzUvIxIDOMMtDKA?=
 =?us-ascii?Q?QFbV4i035usZbpTuCpeQiyvPOWzfnAACPFXg2SToMFWs2SuU/16yt40t7Qn9?=
 =?us-ascii?Q?yE5YETbi0geNz3R9VtvYYoRPOKHryEK9faEJKwhXt5Z2AHbwytRK8ETkn6jL?=
 =?us-ascii?Q?mkJcn18HNu6ixt5d4Imzeq/4Z2J0V11HFBY7frw8dnod1e9uKyOiAyIL7Ggv?=
 =?us-ascii?Q?DEFFvM2youVEXvUD37OA1A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40b2073c-7151-4766-53d3-08db0335da26
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 02:50:03.2714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z+4hkpOKad8QUpSJQtwblCJJ20W2Z0VjThRziHA8eiNtdQXl1CAjFg1wtpgvH9DCwwMoKU1JQ5gOKXiQBFKfc01vyZOnbSHgc3/6rDfE/I0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7097
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-30_19,2023-01-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=901 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301310024
X-Proofpoint-GUID: wBE3gCUIWp6XdE-NN900GRsZnagEo5Gt
X-Proofpoint-ORIG-GUID: wBE3gCUIWp6XdE-NN900GRsZnagEo5Gt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Makes sense. Though I think it will be hard to define a set of QoS
> hints that are useful for a wide range of applications, and even
> harder to convert the defined hint classes to CDL descriptors. I fear
> that we may end up with the same issues as IO hints/streams.

Hints mainly failed because non-Linux OSes had very different
expectations about how this was going to work. So that left device
vendors in a situation where they had to essentially support 3 different
approaches all implemented using the same protocol.

The challenge of being a general purpose OS is to come up with concepts
that are applicable in a variety of situations. Twiddling protocol
fields is the easy part.

I have a couple of experienced CDL users that I'd like to talk to and
try to get a better idea of what a suitable set of defaults might look
like.

> This hint applies to all priority classes and levels, that is, for the
> CDL case, we can enrich any priority with a hint that specifies the
> CDL index to use for an IO.

Yeah, I like that approach better.

-- 
Martin K. Petersen	Oracle Linux Engineering
