Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 756C0C6FA8F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 03:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbjHYDAb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 23:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbjHYDAO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 23:00:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4732810F
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 20:00:12 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37P2StWr008572;
        Fri, 25 Aug 2023 02:59:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=8oBi1m9me4uQwaPljFQ5kaZm0eyd4e2WEUTq6ru0BV4=;
 b=2QXxS3CpFIngWWw8pl8qDJO5U1SdlrHkDHFlNokb4TgNlNmjz0VEN4P59yK43elqcJUK
 N6ti94OqdyuKbRybvvhnCJrkCnf2/J3Wcc4LrCwb7KjdG43dG1XDjg1O6nmRF7YpdvX3
 pR3il/R8OQuIa8b5s9Z20y6rC6IuLel8wf425MUviXGCZzBL/HWuvXwRDZtEbFv7fkqR
 pa4BbEFtlbJY9o0CS71zmWOdph2lq2AtyM4En5yyUxUvZg6kUrneMPaDqy4+nRccmjfR
 SZj4jB3d/k2Y9z5xo4MRYYNlYz9YRGAuhx+nHOom57zIGZgfbW1EVeHFK/MQ1tkKIZ81 LA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn1yvwj5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 02:59:53 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37P0f05H005875;
        Fri, 25 Aug 2023 02:59:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1yu1mdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 02:59:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ELBEoxz/Xn1+KBupLGKE2tk0WjolL2FGhA6UK4g7Yq7bK93ued2Anewk/xELo7sfRhBDDN9ZfHKN5fAoPYMOI9IX4Gy9fZJgp6S1K9RxZ8lOeJSZBQbbh4JtxYKbupBMbzey+vE94EEZ3y8LZxRd7MLTB7GqLtKXVAY2FwQpnFlezzSKxJswdYN9X82EOs4wXQOJupg+OtUHpBVNDFZDujgm89oMUEva0d5zqKwmfl3EjgTGBZgsOQ5z9oL2St9vVBmFVNo+5ljf7FFTZrR+fPOLA6n6OCHtOowNdmJ3Oz8R/sJM2ZU8kV0JNCGYSq9euNDfxrm8i3kOB4NWYd8XOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8oBi1m9me4uQwaPljFQ5kaZm0eyd4e2WEUTq6ru0BV4=;
 b=mNKX1ALeqdMuh4LB/UGhGHdv9q7baXxe+tWsg4LJZ5mU3+JDs3apu7VsNNnJh0+5tEBur/BO7pn5+8GSjmsYbp2yPuTPHoqswJOP+2FIIwW4sYSExNlbrckvIbm6aQm8bTwAg/vPtih1Edn87UKbJwpTHpYunuHFiaZV9r+CPssTU3Yc/XFRA5dMUvCmdcbT1NIfagzDlpQs1AGkDiHzf31Uk7UQbFQiQ9NAmkrL3kt/6l4y9WdHl1jrvo9AfbPqZkksYBhcL+eb9p9DaHUqe7vKahUHbJv6sJ8e0ILAfaeI6KiQ18ye4hUzZnLs3Vrmkv2pbf9727+2MwDqt4BRzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8oBi1m9me4uQwaPljFQ5kaZm0eyd4e2WEUTq6ru0BV4=;
 b=R6M7QGGLdUR/96yk7ia1lJBS6Tb/YnbmnXLJs5tYEmzeHDiStswMgUY9SGJ7JT0T9mBljlx1nIWRyQoy6GkELCtqiEZdxKLvHVgPPr2uyOqMzTJ47LVmQ/HK33blyoHLxh/Cf5+JaDMIW9ZbGaD93cTKZC8O1yEeCUU2HAoEJ6s=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by BLAPR10MB4833.namprd10.prod.outlook.com (2603:10b6:208:333::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Fri, 25 Aug
 2023 02:59:50 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::7f4b:5874:8553:55a6]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::7f4b:5874:8553:55a6%3]) with mapi id 15.20.6699.028; Fri, 25 Aug 2023
 02:59:49 +0000
To:     Don Brace <don.brace@microchip.com>
Cc:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <jeremy.reeves@microchip.com>,
        <david.strahan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] smartpqi updates
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1jztj25ew.fsf@ca-mkp.ca.oracle.com>
References: <20230824155812.789913-1-don.brace@microchip.com>
Date:   Thu, 24 Aug 2023 22:59:47 -0400
In-Reply-To: <20230824155812.789913-1-don.brace@microchip.com> (Don Brace's
        message of "Thu, 24 Aug 2023 10:58:04 -0500")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0117.namprd03.prod.outlook.com
 (2603:10b6:a03:333::32) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|BLAPR10MB4833:EE_
X-MS-Office365-Filtering-Correlation-Id: f4abfe80-6d50-4f65-6493-08dba51758e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PCYl695YmvuDqyrpZvWtrRtaBRjOshSwT7kusEdrDpZgqJ6vRlVmDGNKcH/suNRGi2qWhjVY8GclOrcOhMEpPv5TEDRRkMgV18xrRyFRYiU5Iu80kw6KsOUbKPhEegWJuF8FF/DFsH8GzbEfcGlbsAiSr5mPr3+5PyqGsa52b+UqQzrfZWYbBnXLw4J++owRVqM51Li4lwlwSQ8yFkfsXWTR2FtSmJSrnGCve1Y5lJQnBhJ3IV6U2c2k3bj/i8BaKupgG5fl6fc3B+DreyfUtJLXLhkmE8ZgRmTI8h1ClVbjq3LQo7ton7xXwikbtZXKCAIMkyV+oB2kqFgLx0pDAo0dO5024lMigRAVtt7OzENkB1WXEKp2BVEZ/Lw/a587BVtmnn2uY2sr8LvUw7EfbUPqITqFPLj/N1ajoSw1Zf5BzsPeEoYOOa/gkZVaQ7dWL+t6HF+GXhJnuO1B88zOr+XQRgmzSELH8XECEVcJotpGFBfhL9BdO5DOxulkfxBhfZ5W2kfAk791DDJir2Pn70J9bu94NK8EDCsK9anFlV2ETQqG/hFiYXsGnuQlNhWn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(39860400002)(396003)(136003)(346002)(186009)(1800799009)(451199024)(5660300002)(4326008)(8676002)(8936002)(4744005)(7416002)(26005)(38100700002)(66556008)(66946007)(66476007)(54906003)(6916009)(316002)(478600001)(41300700001)(6512007)(6506007)(2906002)(86362001)(36916002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QkgOcNTZDoT4MnxbIIN0cvWPiSNChc+vTXWMPJ0nbQ9ovw5+nPcEdWECJoI4?=
 =?us-ascii?Q?5rXHkJfuHNUTjW7EORPu5bC3ssA52gmsCazoIDkPek3yVbZzpi+ai33iNH5R?=
 =?us-ascii?Q?yjkeg7oVNzxjeRkOTt3ncjS0d/KL3hH9/xook/ZdeBakd01P5QkoYub9tj/Y?=
 =?us-ascii?Q?niB/nfkIDHNdQirmGDV/YNAViBMMu1Jqwt1ERy8ouEgHJLY3cJJxMHsvIxJT?=
 =?us-ascii?Q?BahQKrntRHanFSRwT19lUq9yzYM4EYlOPMin/dsVL6JYJhfIWHbQ7iiZuF1a?=
 =?us-ascii?Q?U6FsAJKTDMmFegWpDJndCdSHpqYrkbErT+s9lMzLVyiLRJTuvKs/sacprTet?=
 =?us-ascii?Q?M82IkVCYQ1XxZM+vekmhSjPOwD/3H8a8AFIsDnpg5xK1IyPhodwBEL2OsjVr?=
 =?us-ascii?Q?bJmYkDFYF+Y5sbWogOmukRDsL0fP03H4KgBQ8BT2wNOM3tMrQc+6psvehKqV?=
 =?us-ascii?Q?F7xnwwBNRV//8ecZ6NJWdPefoY9rR2PuFLZE2yC9synICaNQ8u5l2IHfRcVb?=
 =?us-ascii?Q?+lcZGG+mTaS8aCqfDJN3dihRrjJE14MtmMl/YBjLL7ptQfIp+TKzkepjKvmM?=
 =?us-ascii?Q?M4oaTpTMiYxq8l5J5q4XLYRbW0FuJLd+CQIzJai75fi/daHeSEdk0M8rTqvA?=
 =?us-ascii?Q?ZD0oI8BS9gNDU27bMqPfEbaS3u+k85vOBJp0M+cAO4BEU6hEG1bMitjza6si?=
 =?us-ascii?Q?wvfzVgj/VJCaOa4VnN1wvJj7u32U7lfS042ml0SFp+2vT+pivBHIEB2ORJQ6?=
 =?us-ascii?Q?s60uNvpAP9MFYRczBSp+uELIxzFi3JjuqMZKyGLq1H3D9m2Bc8cl07hOxrkd?=
 =?us-ascii?Q?8kKt36txTPgMIEodmSIsIfkXy2snjBef1pEMghyxbwYD6spBotlTxoUDnE3r?=
 =?us-ascii?Q?uJTLfeq4/EQuMfK+31iXMXgbwlMJ4z999mBTXWuo1yazcKc9VFNHPEktnyHj?=
 =?us-ascii?Q?DUg+QbRql4kuAS9FEmWI69W1bQr4aLhba+cabCZW524079dblEEOxIY2TN4G?=
 =?us-ascii?Q?gVvDC6S8Zod2jjoJCMS9g0U5bkDBHRUY2hpoWS+38Fmgj5Kl770L7q9sJUuZ?=
 =?us-ascii?Q?EzWJtK9qlHctlAcD3o9aEMDSIW89m4NXe4HPW8NpOcFTn5ag0A7AukFqvfw9?=
 =?us-ascii?Q?8vbe4UXzaQrxbWRg9iRbTi2bN29Rqew1GoZ62IzW7YyiqUz8U2IveuxsVieb?=
 =?us-ascii?Q?9CVYmFIqS2KwSZZ5ojPFNspzGto6UIHlhaKIkCI+Xn5Vu+CHUqIIBL/aVbWT?=
 =?us-ascii?Q?XDZ23cMF6TB7CWLxyUwMjevvg3cSdLTgSMNcxY1bNh9TweYzoUUd4avSsS+L?=
 =?us-ascii?Q?RUeqicBv3aeNmE6nXgOnHy7gTJmpcL+y4avaUcB1BohNdF1zNTY74FIzELiv?=
 =?us-ascii?Q?EM041jWsW1ocnySFEoqf4rZQbybxEaV0sjTRTjJoqycIb1BRKK3q7djEMGaI?=
 =?us-ascii?Q?4CgOFT0mitkh58E+B6phm+eCscd4kg5jrTyS5AMvml6qlJvtwa9AOwJgK60l?=
 =?us-ascii?Q?X7abCLqLrB31Fe90HqP8pzqZvviwaA2/143ZQ1ZaVQzieeLGOezQJwsv8wL/?=
 =?us-ascii?Q?eRNO/Da8MhspXT3hDYdTwSKm7whHEQBSEf5mDNk7albWGbL3KxLjYFXUTc9k?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?xrXY31lC0+/+5gBaX1IlcrQONdeEKK6IwPvwaJHHpzOPp8pYyo15Lq5F44O4?=
 =?us-ascii?Q?QP7zW3VOEqIPLGeipljv3yA/qFKqgLscLAwfpDAS2tbhg/i16X0rWM0IyFhg?=
 =?us-ascii?Q?B+NZAfDuC1ySKgHEV66zRqWZdKOGHiEIrepXGI6fp6MQxXKjJG0FMKVJ91RE?=
 =?us-ascii?Q?2JpSOrv88K0RB9q7Go/mGrG5zsAzsV4b8FVNM5kGezLnIPdn+W1ykSZ90fzT?=
 =?us-ascii?Q?BfCkC/sqCliPIWfBgrK5uSXLEb6QxQjAY8vOEeZa4uGOYXJOmA5U1woIxo0H?=
 =?us-ascii?Q?n8sak93mn5xOrstw/LS7s25eP86DChp9jgwily9ihEa6U4yx40OZGj2Ywc5i?=
 =?us-ascii?Q?UX5zmVApEqwhCha+Rb+xWY1UgKdQHJKBgsQcL9fS+bQL/iiTP3TN//8dcyv7?=
 =?us-ascii?Q?0dAr1kQBpGewVfxRUptMvfJ7ZEa2CT7yOL9s9Rwk4XtjvbjOwatrKGMbPnMa?=
 =?us-ascii?Q?Q2fu4yTBQ9khLg2ybOTXTcrzVV5BXliLCPsYfnJiLcEaPbrdn6tF28y6HLP1?=
 =?us-ascii?Q?hgxQcn+vni5rkzsbe3YWXz0hzM07gj77pzjn4e6fLz995ah9SLvqskNIqgxF?=
 =?us-ascii?Q?67GILbgGCsJe2WZpUslqUI7TQKcKoHKoVg0OWsetLMfgj+ioTIqmnev1kbXG?=
 =?us-ascii?Q?DEZHHVOgw6EdCC8ng7uM40qMyvCtc3a6GtIKV1Pv/RdA0UOqi9dnauha2kDz?=
 =?us-ascii?Q?VAB92JrnaHFjdAg3ijc0qj7ADOlNx/28xX3F0GS1t4SVIRcYyWXxKbdVqHgC?=
 =?us-ascii?Q?leHubv7wpKddDmsaE8WB6DhlyOvbX/wDPhTAGUfnxmmfvekDb8Vr4aXFIw91?=
 =?us-ascii?Q?kMLxyzBZwYp62lDjgBEg2I2eRG3tQV8J7sY1gQZEk07YCV+jU5lmqRyHADFo?=
 =?us-ascii?Q?Dp8LHUVCs8MON7ruZmzi6AX3oAZ4PLrUVQ73PCzqHQGbMDjD2qE7BDXrPCLe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4abfe80-6d50-4f65-6493-08dba51758e0
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2023 02:59:49.8289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VNhnDArTeexzEtedtvT5gjcVo9ipCWgV9Q60fjoTEdmNpoLZT2udInvsW7KXbttb7TwKSRbIMddnSnuS5E5MZZWICwmj06CDw3apeYqURlA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4833
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_01,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 mlxlogscore=519 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308250021
X-Proofpoint-GUID: C3WzuMiq1cT3VF3TaV8cYH-VXjmrN8sa
X-Proofpoint-ORIG-GUID: C3WzuMiq1cT3VF3TaV8cYH-VXjmrN8sa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Don,

> The biggest functional change to smartpqi is the addition of an abort
> handler. Some customers were complaining about I/O stalls to all
> devices when only one device is reset. Adding an abort handler helps
> to prevent I/O stalls to all devices.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
