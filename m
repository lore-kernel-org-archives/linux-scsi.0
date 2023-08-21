Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D8BEE49A0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 22:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbjHUWJI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 18:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjHUWJH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 18:09:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F9E10E
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 15:09:06 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37LFxKae031496;
        Mon, 21 Aug 2023 22:08:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=7d2lv1uEbxFBG+wFYW1A2xeb2EA+xbf1OJIGykX03Xg=;
 b=DHgklP5XsRrvKN7sMQkYH46mDdn1TvMTUU1KNaXhI3MscJlXkEYCiMdrZWLPkGgrSyMa
 rYYiMS1hbOaRk3N+jjP6sUtXrVQNlsNhIskzu6Ygrk+QH1ppGFn8cSjCkoqdztL+Lf3k
 pxx504B3JdmCu8Qo0rSxb2O/1SYu9ZvGwA2LH0oIhYO6cpwnLz79u9i6Jdji6heAsF2/
 xlroJk5eEKV6hSlUyKZKC769RU9WttDzvEMl1C3p3lOt4o6psrXrEP2D5cqPiVEOdEbo
 9QAbNfSUhwbZOw+R0WHOV0gdl7DRBibZeIBsEX7j60+8yrYv0gUfJZQ4xfsYpnE0wmRD wg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjnscc17n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 22:08:54 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37LLZfhq017633;
        Mon, 21 Aug 2023 22:08:54 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm6ahs5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 22:08:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVTNATZCdTQLLWDd4wbRkHd43s4cWb3K5JKCaFPzT/yc0USHU5YQsr4Lf4xvTTQauYbU7OsvZ0irs9t1nZ+iU+na0lHxqsynDJbV2nyPLhskMS+7eqXUci46J09C4BgFqEvBXel6IsycKp4SSY+sjRriUr6JE1rYJfN4hYD1apxbaAh/3rQ0/GOJCxVlkSQSncLiKXlYO3OiZBntiCWSUB1ckNGJnTNFq9Z9SP7hgAjzGq1KM+uBCduqgC+GnosXl8sE7ZWlr/19kjznvDtkOaqM+eIN1cC3VAGTkH0vGdvZMXmY9odbcHx66wpCLTGPjCwPtnkhDHk+TpG/Y808/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7d2lv1uEbxFBG+wFYW1A2xeb2EA+xbf1OJIGykX03Xg=;
 b=Kc7PaakRQXwLjM//CNZvextIMqcoURE5k1WkkFbCzvbSxSE9IecGQPj+SNZiKzIoMMNniOrnlmSjY8Wfb/mGVomLkYG6ZwpYZUKYa+x0Ap51qTKKgjAzCCurv4dNgEsMGY25d5jsWCMye/sTl622Sggu+l9o6gE7WBBuzDOU25lcVxrfWw1oYeLKMpnf2b0QCgfoHxnmVhmXZUWcEew72hB1Mloa7AwmB4iqP+5pXRaEj5qkWsehO7IX0o8nTOVlY/36ZLbmfzmQX1gGhcC0HTg0hbcZO0v+HBk1x+FlcpoD4auIMeoyhuxUk4SM3uYsl27DDbevaB5nOqlsSZWqlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7d2lv1uEbxFBG+wFYW1A2xeb2EA+xbf1OJIGykX03Xg=;
 b=rIyIj9WbQnCyt1DgjyAZBaeJQ4/t2R85a+PbGzIw6ylnF7+5+hq3TLJIxKRoXRNvYhmdAYBtLeA51J7oCbvNLS5jDEP6DsyzhIXGJ1KBqRH8ja0GHucb0zVQd5+uQshFUHOvZ+QRwWZ3DaEYoxmBI/UvKwtvS7kNGuIxiRr8vSo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB5383.namprd10.prod.outlook.com (2603:10b6:408:124::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Mon, 21 Aug
 2023 22:08:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.022; Mon, 21 Aug 2023
 22:08:52 +0000
To:     Don Brace <don.brace@microchip.com>
Cc:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <jeremy.reeves@microchip.com>,
        <david.strahan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/9] smartpqi: reformat to align with oob driver
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o7j05ae9.fsf@ca-mkp.ca.oracle.com>
References: <20230817131232.86754-1-don.brace@microchip.com>
        <20230817131232.86754-2-don.brace@microchip.com>
Date:   Mon, 21 Aug 2023 18:08:49 -0400
In-Reply-To: <20230817131232.86754-2-don.brace@microchip.com> (Don Brace's
        message of "Thu, 17 Aug 2023 08:12:24 -0500")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0025.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB5383:EE_
X-MS-Office365-Filtering-Correlation-Id: 2999a7f4-57e0-4162-de79-08dba293340e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rzWQggInJ9CMX0JWFwWLax4Ei77wu7wGap8JiHlqde20FO6giSVeNYa11KN9ITjh8oTsC5B+nOUmJKhAXz9zAsLThAOJwEkZ4DeSd34kpA3/o5Ufjs3ROeAz1xTBbOH6hCLPP1Wa09cElzwh6lZSpX393IEZYncIMoVLCyxtGiJtR+HQYnHMs0PavlMYvN+gtyOs0QGo3z1qNnVrQNYCAcGGqZjokR7kKFyGRXqlhMYFB7Q40lDc22XD+Rk0ymbN+SUIkEcr4ndlA0mQWsF5rcBkZ/fMkeTH35+WiRcBuWuga50KMOZX0LIjuNvj64QD2ZDd2w9GWFoBumz7HIZepw1q7885tEhxKF/w3dgfI+mh0lLnfq7Mek8/qThpuXe/f9q3hZQ16egkHXbJyDpd7TlzOK8MvWJEJ6i5ODa6CqxWCXS3mM2eG85PycJwesHygCSnvZTv60e/8UobvuUUHsp27B3hcO+mLBm/xlv49hRs5hETxCM3Qop9ZuWhnga3RpZ2yvgxxzk2NgRnyNWREtvIE6+UzjF2zK8tRqjdVS0Rh3wC2I4qWUk6zmh4fwV3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(346002)(39860400002)(366004)(186009)(1800799009)(451199024)(54906003)(6916009)(66476007)(66556008)(316002)(6512007)(66946007)(8676002)(8936002)(4326008)(41300700001)(478600001)(6666004)(38100700002)(36916002)(6506007)(6486002)(83380400001)(4744005)(2906002)(7416002)(86362001)(5660300002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SQS/30Tz0V90LjJyTiK+Rrn009LKwC2dUkk5ONx5UAnPPtfdrp8LHBiiqJ7l?=
 =?us-ascii?Q?L5VXJjjChLtOwwXXy4enmcrKOdCLMnU58cadkS4Lk48gtj8XwqzajAzgCUks?=
 =?us-ascii?Q?bQL8k7EGnaC4WJNYpTbjBDfLAzTPKoiqYGsprB+JjHxVjdFRLu4wcWGkscGG?=
 =?us-ascii?Q?p87JBMEd1i8swPgwQRT3q4GWDPA08tT29CzAWU9IaEHxG7GQXiDUmna1aWG9?=
 =?us-ascii?Q?nyCElDJMjLU7Dmu2Yvhsxgn4tYEXm/74vRfJyHeEwEikhOZGkV+HQcsxzJCC?=
 =?us-ascii?Q?N41ILSDnE9s4rQcVLv+tlcpW1Cj6J7krniG5U9jVN5zj93pxGZkJrQqbiW2M?=
 =?us-ascii?Q?7HNsWcUwevAuwulDfn8QCvF2XaQseCi08/tp8pqVKfGVWzx7/iiQs8oyir3t?=
 =?us-ascii?Q?DgRCD0PDr6pMNaOBzkIsfqLeHrlcamSyrWbfND17o36rwMtCqxCYn7m0BXzQ?=
 =?us-ascii?Q?aR0enZ3kNMXNK3zfSvwzeW3PFm4rmhmmlO/Z5LWX5L0EVsqf1bSz+EsBSOKH?=
 =?us-ascii?Q?iTkhEac3BRqDw7MlE6EPpYced5CbOzw2Cfc+VeSfddpxYQuqT5QR48VscY8B?=
 =?us-ascii?Q?+L4z0NptRvtbRgA8IHwAyWB1r9I/TRPCYJZh72SdW4kSMkWHgeFkUT10vFkb?=
 =?us-ascii?Q?m9E5ALhSu/ikGoTL57tbXwC4jsac3086Pe3Rwn4EZnWevwIPomGkcvNNxUQX?=
 =?us-ascii?Q?9g0Z3Qb7kWBv/HfiMiHPhEWJVir7IZBPBv5qtAxj/+UMtqSArNfXcBUywOR8?=
 =?us-ascii?Q?VpLMLbJ+j25upXe6KrTEBQx5YGt7Y8ipubaSBRXZQMU8Pck6fCQ9BAOE+Lu4?=
 =?us-ascii?Q?xfGqYHuCNXxud1HMcZiMdNE60VVQm6vQKb4kZIbM/sZWe9Bok4hoUJGIfEp7?=
 =?us-ascii?Q?nagipPq2du+sT3wpjQc5OW4h8mO1FRrtdWVLWmfIBHdGygd972qDAHuUmeks?=
 =?us-ascii?Q?a9PbWoyT7Ak+pNMgCJOHFafxDKsHaAOIz6cJFaqrB3J7+oxY1zqdVCjb4RAC?=
 =?us-ascii?Q?KlkUnerFaW48EjhEOpMGGxzQxyhQdZUz395mO766xhNfTNk299I4/ViL/lsy?=
 =?us-ascii?Q?xaTDXsnDFTmfHZhof7s5zwQNpOqIpg211VPWGybbKlcks9nz23Kbz0Y7u70o?=
 =?us-ascii?Q?FJ3rkD65ifz9RDBRqTcArbZBww3lua2DJ8OFnfp2zotb89yLp10b+4S6/GIL?=
 =?us-ascii?Q?Fs3+cw4+8Kd5VJ4SaQV6+DAWPIxyrvm+XAM5GgLhgwVCrlyQnB9kbmiO3svN?=
 =?us-ascii?Q?6LE3vl6XN7jl7MYtImSU2zEKF468rOZ5+CZyjTapzkHb9wBe2tDuiPC4JZRr?=
 =?us-ascii?Q?oE/EXxih8km/rCio7QIqte7YMspL1AsAgBP0uyDxmYK3MtJJguqARGEd81iG?=
 =?us-ascii?Q?S5qW6L99A3pj2BdYEF1lfH3nVVbB+P+t1jEsB7YxJtjn9eNhnbMbWAdq0v29?=
 =?us-ascii?Q?8PyHi9gN0Ij1TGt1HXCX73PE237rZvCw3XaexfyNdyOeM6YrPVVNOOwgzpeD?=
 =?us-ascii?Q?NhqGRgZ2xh533vECV4LpD094qsfZvNoHhPdCz2ynZdtuU/84wLq7Gsj42m9P?=
 =?us-ascii?Q?KZqUCYZtw5tQ2cM0Eri95IzxiMJEPnHa71F8CQtE6qibm4cPv6DsUuKG3bsb?=
 =?us-ascii?Q?dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?a5M6t2g+0NaTbFevuer7SjY2Cv6EopRWG0pNQ/VvuzZ3119QLJ+PQMwAhPfS?=
 =?us-ascii?Q?Z2saE1J+HoMKQtXHSAGgr5N9OkyxFBpXQPWzty5GuGDxmFY3pJB5XgpciC7h?=
 =?us-ascii?Q?47ueZB3cV9rytBOOPJ5fN5vvID+0mdBAq/nJYQg7SuTPaZkHZDdS0mI/V2VR?=
 =?us-ascii?Q?QDNFT49SVvEnStzkHCoNEIw2+7O0DqepXXYWyNsllJTEHbZuJF4GS73AlHvc?=
 =?us-ascii?Q?57/9UxSOIBarPscSE7MgQ8e1Hl2ImTt0yWmNfcAZ2J6o/18QhE+veW4ZU5Ih?=
 =?us-ascii?Q?DRkC00kb03p0qXeFH50MDfDEumRQZdDfiXk6ZcD0p60qo6w5qYozmI2f5kRQ?=
 =?us-ascii?Q?/c0VQ7yrt1R/aqQuZuTOn8r7rxeN+IZjDQJy8lDHcCR0AodDwq2AXigIkFsd?=
 =?us-ascii?Q?pJsd1A4PthyvlH53NxyBKQOXOTz2dq95oX+Acw9bT8KTHifv2qamnPumPzLj?=
 =?us-ascii?Q?gWvwtO0J7nwNzWA+/LEKyXt+39d5k1WQGas09VTI0BP66duxu+LbAy08F6+l?=
 =?us-ascii?Q?Lz7sFDC75M19uDhyYaaLM6qPzGWAosREh4njVHTcKcM9Z0i0u19zkB77Jd7u?=
 =?us-ascii?Q?aR46UiJEFP3d2qXsWFqbP+UZprjN+/rBB75wM+BPKPMPXP5BrSbFs/rcubtS?=
 =?us-ascii?Q?BKpRAra2x9VGaxYm4mpZrjmU8R5IxoapKsFZ/v8eLXTmzgkZ1y5nS+3kn14O?=
 =?us-ascii?Q?y4LmsFjiAkO3kHY3sWZ/ujeSA/Y2N9Q9BF3x+cbz6EUhUKZOBd9Nn28iCXvU?=
 =?us-ascii?Q?jLllXe/dMAgm7/0ceZbr22tokNshoi61+7dTc1ObeuDHFWMQ9wfSrVqmtmu6?=
 =?us-ascii?Q?BCmOxm5+NDdLA/AylXDU6kMG0DjDNGecgoMXoUgddnc8CTZRHDO8ol4Te6bd?=
 =?us-ascii?Q?0vjuddLVe2dWu0ku+zQG3qNKwWyj5joMKh/1P8aKLOtDl/CjlnFqM3qyxLEp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2999a7f4-57e0-4162-de79-08dba293340e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2023 22:08:52.1755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dm0UqOzwQiqL/9C/4j4F8J9DsJKMPMxd/gl2ShbE8tHZn9PMktrmVXSb1KdTZ2UF3GznczjJBOjsHSkoo3m7LNMIgO+Ul1uENhA6EsI8LWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5383
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-21_10,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=811 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308210204
X-Proofpoint-GUID: 5kpGqJTVRSS1uy5hu9bN3Zozz7S4r8A7
X-Proofpoint-ORIG-GUID: 5kpGqJTVRSS1uy5hu9bN3Zozz7S4r8A7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Don,

> Align with our oob driver to simplify patch management.

Sorry, we're not reformatting our driver to align with whatever you have
out-of-tree. I suggest you reformat your code base to match the
canonical implementation which happens to be the one in the Linux
kernel...

-- 
Martin K. Petersen	Oracle Linux Engineering
