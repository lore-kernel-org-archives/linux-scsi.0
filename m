Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4272BC433ED
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 03:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B376610A2
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 03:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348287AbhDGDRX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 23:17:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40624 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348264AbhDGDRU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 23:17:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1373CB3c048046;
        Wed, 7 Apr 2021 03:16:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=PlHzwmLzZrhkGsfed0lk/LQ3aKRekAlrE5KT6i7hONE=;
 b=Up/6eRxJn1mKCezvYMtJvbUeD54/mDXViSBdzRqwrXkikpUCfA0wToMcelpW5Kkwf9J7
 VXbvATXYELvyznSrX/sc2V5IhKIirqiHEzaaR0mpkV8Qw2wHzlxV3T+ogqV7PBNzAArR
 +gcpETloZdzLUm0ZsbfWQf84fI8JHU+hLX74eV6hpGQH9d/196OIqCWmGD3Pg5VLs3AX
 uHpEHu3TUUXBwDFyYT3YhW7CXbfTXbd0/JNIcqFCGgdHHu674kFmD5FzgEKKIGlTCTXC
 jibXmI+4i3cKBGZay92e+38AlV7olR1w3h6+d0DLZbWAPVxVKOfF6DGDHnAchyQtE85A 6w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37rvag90u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Apr 2021 03:16:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1373BUJm181216;
        Wed, 7 Apr 2021 03:16:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3020.oracle.com with ESMTP id 37rvb36ddv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Apr 2021 03:16:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jj3ZKqzezrsC3Vrvyau9xRrFzBdebMAX4zScXcA3Cas6VbkXrRMNQQXDUqXolzm+FW08OEjtJamuv0jOXUXjJFecyKkAInl370A/NAV1l8lFwkio1eWGibm/bdpgJCsxd8bpwKRMNZf4/Sy1BW3BwVoXtID+WSV2ASLLbOZFLzXEJ9eJG1jZxS1pvGytCJHHyaNMa5QN6yS77zhT6UvRQ5f/CcvB4g1+h3xW1Cird9VCHFqIf4mCtbPAlVtP1/InyqQmDiW2SGnkYGkKNuk0mcy5VE6Mg4E2fBtvIhHMawKX6u5S9Wzz4U0wiLHx/4Zp6tMoNV7Lo5RenEPtvSAytQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PlHzwmLzZrhkGsfed0lk/LQ3aKRekAlrE5KT6i7hONE=;
 b=mKCXdjQ9n0LKHyYZiMpD4rSE98WR9e1oaT8ljBtcfCOVub3MAYU+cNH+WInQgP9GVHVH3fm1sxcytmpEP5HLrD/6uc3PHC0ADaxutfygqIVwxNKrg2doEKPBENPfqhBo0nCXcDBc5CntCiQbF+bInkPDj4qff97EZQLPZI0ZjOPJFf5Sk1W3e1eC7gdSh5JPGLrl19ySF6Gpxi2oXo5yyRoeVF5wnZBNGrBR4rDGgXzEetjpys3Rr9fHY2QCIz0t2PI1LgEAMAx8HUlRqAFGWIOdCeMg/mtGyiel9V+hFs12VyPbDhv6AeogZCJY/vlIpMV1+t2mZyhdowW4H1U27A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PlHzwmLzZrhkGsfed0lk/LQ3aKRekAlrE5KT6i7hONE=;
 b=TpZmeuMGq+upuORGCD7FTbFGOB8AmBGGcha6QwFV43rEM693nlRydPCEqH5IcLgzcRlg0Ih5HQbr/kr1RMsFj4ulPU2308QnL8MaqDmo5eSD2fBBHKJJ88FsaGe5tfl/3EwKRMp3hGcLvphCdNFbqVhPGNic/qBiAQ0Bt/CZIVA=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR1001MB2207.namprd10.prod.outlook.com (2603:10b6:301:36::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Wed, 7 Apr
 2021 03:16:31 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::6091:8d07:2f26:cf44]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::6091:8d07:2f26:cf44%5]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 03:16:31 +0000
To:     <Don.Brace@microchip.com>
Cc:     <Kevin.Barnett@microchip.com>, <Scott.Teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <Scott.Benesh@microchip.com>,
        <Gerry.Morong@microchip.com>, <Mahesh.Rajashekhara@microchip.com>,
        <Mike.McGowen@microchip.com>, <Murthy.Bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH V5 00/31] smartpqi updates
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0peaiqa.fsf@ca-mkp.ca.oracle.com>
References: <161549045434.25025.17473629602756431540.stgit@brunhilda>
        <SN6PR11MB2848AD3FEF26573EC0BB7207E1769@SN6PR11MB2848.namprd11.prod.outlook.com>
Date:   Tue, 06 Apr 2021 23:16:28 -0400
In-Reply-To: <SN6PR11MB2848AD3FEF26573EC0BB7207E1769@SN6PR11MB2848.namprd11.prod.outlook.com>
        (Don Brace's message of "Tue, 6 Apr 2021 19:55:52 +0000")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR07CA0072.namprd07.prod.outlook.com
 (2603:10b6:a03:60::49) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR07CA0072.namprd07.prod.outlook.com (2603:10b6:a03:60::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 03:16:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8ff155f-59dd-4edb-236d-08d8f9738a7e
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2207:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2207B31A9202C15F89D51C008E759@MWHPR1001MB2207.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GJpboZVsNxVQjguYqYecH+lnGi7NkR9+YgcKEAWuzZwNrgLwG59H0t/suO5EkhXspqWZoBi0/jSjpW6GAhIoFq68OefqW3HzH4Bu8I5b62Jx25pGptQFYaHY2Ccb2sPLKPzfLv3jz5K8eAYEWGqTS3rJoTCRILzWnlfORBsdfGtUlcwkMs3oZVcveTIsDrq2E9nwKldqbhBwpYcA422QYv0T6wDtg9diBkXwmHZaQHi9jV8nMbt38sau93R42SsVe0n6Rayth6nb4y+th6acsX1LoWRujV4KsrVPqVYPo9cCYSXAeGOhFHdnq9zg5Wj/aJhO4O52FHFE1FRxdn4uNAy11J4F5Ql4UHL5Xc9Yj3Nldm/oRsLbC/NhQZ6yz9cDk31kEj4CqmWeg3ScR9AA2x9Htkwx1Pz9CxjkvdeF4qDBiMY/DWTGzhlKS9I/3WsEZx7i5f0yXgp3Aep3xJSRoPcVovBk9ef1nSbXh5PoB//+2oC3BJGow4wGqNh1zX4zhqlC/oPICUqHpvk2MXWYlflqX66o00BES7BWcrV8o4XdD86isCA4PQmSdtUPsk9pFpd+R/dn9c5YPKU0k7nAhoZAoz5o50PHagfoOaAZtFdfaTAiO0C5IkKmuEAZ8L43ddpGwQL6I1QOLS92v5ZoFqk9P9+KNWL1W2/QiLb1uN/uKqfJCpEgCgoFbBa/TPxD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(346002)(136003)(376002)(2906002)(956004)(8676002)(558084003)(38100700001)(55016002)(6916009)(66946007)(66476007)(8936002)(26005)(316002)(38350700001)(7696005)(52116002)(36916002)(4326008)(86362001)(54906003)(7416002)(5660300002)(186003)(16526019)(66556008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4uzEUXIR4+rKCb3o657pveXWVhrk0CE/O7+ib0UwlJMyhnwxtNjU8b9iZBnp?=
 =?us-ascii?Q?pzQKb1iv0j8JqOPIdwghD1F/yGMmCS81DbgXyBZHPkRXdSuctMdiLGiiZMsV?=
 =?us-ascii?Q?z3Ow1qXd+tdSZv9u9Uu4mz7zYkQpwE8H+TUeEljem7cekuyqpjtbioxLfd/b?=
 =?us-ascii?Q?+P+AnuKsfAqsGvZYozXw63XD2BICTpCFtX3bpbo1IA0Y/LywU1HVuQ5LnEOv?=
 =?us-ascii?Q?347ezrzemNkwBaJXmV/Rjt/p8Stat3zVzI4X6vuTahIt7XnDcT3/JoTxpMqI?=
 =?us-ascii?Q?q6BqSj+81GKGkRskdOa2A6ERvQ77Jj5RZ7YoGcqPkQm7RwTUoYonfUBo4UjQ?=
 =?us-ascii?Q?Fp6s7KMDsa3Nb0iO21zXpocoiijO8hp9387RocQNatoJgmdH/tOJy19cOAgs?=
 =?us-ascii?Q?Y7ROQDtkj3BTxggbJ3loAQzsgTUMe5BUMNePT2TXkmghmiwXUwhUkPjWWL/2?=
 =?us-ascii?Q?XMhhD/3uX2iE0bD3/qwmxtDgCk990+8Jyz2pwpEsvTQAUJlH5uMYuekWH4aJ?=
 =?us-ascii?Q?F+dGnoG4TaHhB3fFPF+4N9gON1SQvHFaiy61XiVvP4MKuEmciUIGZpzW+dIZ?=
 =?us-ascii?Q?+9Yp8tDQdxpmxeS7lhBM/UwUtYcAseqVQQ9w9ErGYSbM2eTxo6Ue+LJiT3eM?=
 =?us-ascii?Q?UtnXkcRqh9boGge6uHPFyZ3s4MqmyoHu/6CiAxmn/uaplnEYeuXrOs7+O8Q3?=
 =?us-ascii?Q?ZSbUT06kkXLyvVuioffxdiyVsacEdGPzX3vGjDYRjAhMAHCe0bUtOyCMfkXD?=
 =?us-ascii?Q?8kf2C6uq2xPFsSXx5NB6zQxQxleKlHjWZOIdy3R7JPGdHvzTaLUBSRf0qpTe?=
 =?us-ascii?Q?vmgHs/di21n2tGsdNnynpgInb9ARtYVplYAjmVXuLz+Q5wEsiFsPs4wCFKzy?=
 =?us-ascii?Q?77c9nPaBbCiQ9dHqXu4KvuCstSlxl1hcJmWlf1//mf71wXyEJr+OW1zcJYkI?=
 =?us-ascii?Q?3Se7i3FBd4IEf1P5Bm+4b0RQHQY6aN8cZ9jvWxGzY7rvYhCL+GCpiZ6F369Q?=
 =?us-ascii?Q?Gwe2Y1tlXaLQD+wx1gi7LJqeyf30eX5gWvip6c4aFMTWyrsqg1GsXs2VT3P4?=
 =?us-ascii?Q?AxCBaMKI4Zm7nn95nDB2QaBJe0TxUGqsKV7/otOdb7+4rHeNatZnLO2wxjkA?=
 =?us-ascii?Q?pvHNH0oIVRgwlTgkVVHYYnp7Hbtm945tuLGy7GAgHK53/SGzUQkmQQ2VlKUQ?=
 =?us-ascii?Q?2V6nBZt81iPUq1jPDAb2nPpjPlWxxQ502GnrKecYVPQ/mmqety8LNY/QAuCg?=
 =?us-ascii?Q?1LWyJ8pnJlOWQ9BdNXgpE0HQoTsu4JX312Z5QH9fZHVouZ7xbMo9bVkGi6b0?=
 =?us-ascii?Q?+zx3nEdn2q3HgQAtdxQ39p3w?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8ff155f-59dd-4edb-236d-08d8f9738a7e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 03:16:31.5372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hKvV8S4pZzlIdsCB874J2Tgy89urubvdoDZ+bqXnU5ej+R1nv5hynMTvKsNAyjAvNfZjg4HRO1Vk82Few4rQPi31PAXYeAwfqr75+ZGkSTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2207
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9946 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=962
 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104070021
X-Proofpoint-GUID: 7-OMFY15MTV3jESJr4VrRImHemXYlQoi
X-Proofpoint-ORIG-GUID: 7-OMFY15MTV3jESJr4VrRImHemXYlQoi
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9946 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 spamscore=0 phishscore=0 clxscore=1011 bulkscore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104070021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Don,

> Gentle ping.
>
> Wondering how the reviews are going?

It's been sitting in 5.13/scsi-staging for a few days. Waiting for the
static code analyzers to do their thing.

-- 
Martin K. Petersen	Oracle Linux Engineering
