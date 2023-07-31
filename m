Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 394BBC41513
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 18:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbjGaSwS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 14:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjGaSwQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 14:52:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E23B18F;
        Mon, 31 Jul 2023 11:52:15 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36VDTGsG014486;
        Mon, 31 Jul 2023 18:51:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=lResbmgqTZP2oWHAQD9Yvv2hI33RhY5P+ad+79ZJqeQ=;
 b=COM/Hx4IrM65DNNEV8sHh0YSki67Fs5BNJy0w38r6u8wYNqjXIiGAFJQDz9VPfxmgIvO
 7yzXJYDxUzK/zKnNC4VbIiZIMK78KjxVKS03xUAC6gS412yWHSlZQwl0GuQyqmbCJke9
 /mmzcnrr5VYJmxjgEjQqIF68929AdMbiIoDTJPrGeqvZrY7Tn224thmsQy2zAlzFX6XQ
 lKP1H/HYnsoGuaMMQauSlJzJrxXBi0z78d8KjkHzt155tgn9tViflwm3roxnpzsRhP/i
 X6x4IfH/rmih5PPLFh+0rRHMVvpdbO36uhIL6ewI8rreP0gZo47bbQbMb5ecBJPEXM1m UQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4s6e3bdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jul 2023 18:51:42 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36VHlAGh000723;
        Mon, 31 Jul 2023 18:51:41 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s753atq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jul 2023 18:51:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uv9A+vYdvWHkrDHExS/ocKxwd8vzda5dPLpUD+6ResoExqNIlo0kapWBNBK+En1vfHOCgtkQGp63alUs1CiEsdP+c8QwmIi8eHiKHNbHfAew5LVxg+il2Mmz5nbzxTOvlVN0tLMf9twcAQta5+5/hi3ynEkFWLetRkGdJtNWLEKaMUcZOMEL/CbC05xFQzj9ipklhPF+kivpVOLMroFe+eSp8ty8Hk+/uj5o9TssMYeNZs9rZwguWj8fQshg1XPIRVm1yiOWxVqU3d84U20iDE9DlqIjo7bQTMjBPKN6jZqcwc+D/osqw1mr3Cs9a2o1r1o/QQd8qfs0vnHlpzMF3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lResbmgqTZP2oWHAQD9Yvv2hI33RhY5P+ad+79ZJqeQ=;
 b=XnvAzXkyd8gQvxZ78jSYvU8sjxhTAFC+tSXd2EjgLz/A7xnAYzIuKPA2E5Oi63qnzRVjUqEfqNQ8rhMwTHiTfMolH3UKG6ue/j0XCzQA+qbrKxcEA+fXVKoemNaV6oJx3Dk/1qCbUbD1+FfMQbb2tb0YWLjQcU3x0VmsmIk+mRYPMM3zqbnimiwNFqyaRwsE9DI27C6Y+0/u9KDtRWfVqEy5TD9npmGo2bnyj8UUTnfWwMdfLjqTl8eyTme0XXzenT5QEy7EQcLBv0FPoxEZSng4dUUJoYMBTFGOhFmivY2dhT4yL+OqvTTQaRuaUEQzNRX8AODzX2Vfl5YbTcJClQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lResbmgqTZP2oWHAQD9Yvv2hI33RhY5P+ad+79ZJqeQ=;
 b=hS82I79vPEWFzNa6lij1thN685JT95nFX3CYSOucSjLkYHBFhdKmqxGbcSzZmmXlSRqtvh7OrrXsxijRlTdCdS3R5yT8RIydrMcI0YdFv9zvYKeZRpqsOswyTwIxN6W0D9H+PDkBjUgobUumO9qMfsp9wHgml3qviWjg+tjYk3Q=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ2PR10MB7618.namprd10.prod.outlook.com (2603:10b6:a03:548::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.42; Mon, 31 Jul
 2023 18:51:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2dff:95b6:e767:d012]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2dff:95b6:e767:d012%4]) with mapi id 15.20.6631.041; Mon, 31 Jul 2023
 18:51:39 +0000
To:     Niklas Cassel <nks@flawful.org>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 00/10] libata: remove references to 'old' error handler
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11qgnrk2u.fsf@ca-mkp.ca.oracle.com>
References: <20230731143432.58886-1-nks@flawful.org>
Date:   Mon, 31 Jul 2023 14:51:37 -0400
In-Reply-To: <20230731143432.58886-1-nks@flawful.org> (Niklas Cassel's message
        of "Mon, 31 Jul 2023 16:34:11 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ2PR10MB7618:EE_
X-MS-Office365-Filtering-Correlation-Id: 80ed6025-299c-4f29-538b-08db91f72c69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PPKDZ4fLNFpPNwytGXEISEZTLzUqCvc531nomq4AZpzeK8Sh6Vwu7v9j362SFYI4v2URjVdPKx3Pz1Aew5wjV4VHXrzxsII9PKCHJx1xpPXQMIksmBKMsUYREJ1xDXqRZyqnkdL5YQrlDqmYLnrctK9KhIqHCNhBl2coyrDANNjRKXOEDlk09rDfOGz+HNYHqcagYMFAaMqHSKtAiaEViF8XcKj4MV1Thc+w/w9ESVSLz9i6ctIOb/jCOkcPAEe42bdR54pQI+FfkZTL549fKxL22nUXOyfny4RmitgtxRvESDh7kzIx+iGl0DNGU92tAC3GXxDRRJ992SjhLN8CEHFXfN+9wLxwsC0TXlEhNnWCk5SUwxYF7vmWgw5HB6cKoR24Bgzz5RXLYPyYLZ8D9ugm5bGCUxPytVXPLYQloGj9UUZ0A4I5dGRpBPwFasRWIngoKoZJT+jdTykEz/iAP78kDr9485D9+Q0wtCWM3IyompiFeObZi1+5RUTRPCB0SmESiyBx9wH9EE1yxFO+cD4vJU03oSIiae2AEuwjWDsofi8kB++6VkF6hXTvB+Vq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(39860400002)(136003)(376002)(346002)(451199021)(2906002)(66476007)(66946007)(6916009)(66556008)(4326008)(5660300002)(4744005)(54906003)(41300700001)(316002)(7416002)(6486002)(36916002)(8936002)(6506007)(8676002)(26005)(186003)(478600001)(38100700002)(6512007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VtNJuulTWUHzwgX9gTy8EnMAXxTDbFAo0sZhEsI/qGaXezvS3EB2G7dWmxzO?=
 =?us-ascii?Q?BZKFQttPOT+MHcPST/u8F2CMFdq0vOGBHpkQkUry6DMitJhRjbKXdX7OVqKn?=
 =?us-ascii?Q?TXDFViwi/KGl1ke9i3uQUt1lnKS4WUNKaEcNYkdcrk9MMN/FvyUOhMEA3YLO?=
 =?us-ascii?Q?4nkau4pOEuiqOJRrSP3yxuCSYGGRYrK8dzJTgRkXosijUr9QGHJvGsPcHbrS?=
 =?us-ascii?Q?DCz1LiPsRdJmgAh7n6GdsyqiNL24a92F3wnxYNMrmMUwCSN52IfAvnYcMvKz?=
 =?us-ascii?Q?MZ7/8YGGXWtyO7mjuHy0Zwe4YroI/EyKZRGCpKlA0GWwy/nRkwk5CCPV2zz0?=
 =?us-ascii?Q?VTJET54tcE6tt7dRe7xhaW8+phJo91B4etm9RdbmeDo7C5chdpJME06KjZjH?=
 =?us-ascii?Q?1KlDN4QyTlAcKq/c6S1oBlexVB/3tqDKN5p7u4t4I2ndaN1lZVzvHVRc+ww8?=
 =?us-ascii?Q?K3G5dgFR/YnMNsgRYe9m/jkuXLDfz9iMn7D1tsnOdCDCJMsK/Gnvw1ayz0Xo?=
 =?us-ascii?Q?jEGVeRjfMAeTpX5ytQX8zYuNqtzIhiSNYZyCdx2qCAOk7QyIjh3N67Dr0NEQ?=
 =?us-ascii?Q?NkFbOsqRfh/qIqfhqkkFVaDGcgtM20MJbb8Ovwk5lwtjNmK91/l+79JgaYnH?=
 =?us-ascii?Q?MPKv2/isFvnc3xy4ehdQ1TGO5Z9l1v9LKvOAB731gYxWewazWviKVS1DVY3z?=
 =?us-ascii?Q?40906KzmgnwgI2oyfuewHeNKnlPUNqs1TCqsOuDf1qCGuDD6NZw4d6QMdmVk?=
 =?us-ascii?Q?QlQxg+mTWkR00P0SnalR8ZQRwX84ZAeZTc6Q1LqD3rLpC2iCZq3sw481iVEJ?=
 =?us-ascii?Q?/lzmEEUK5VaYbMhob98U/pGUo86M7k1iZgUMN4aNRbZ07VJlArUhhusR2/iI?=
 =?us-ascii?Q?O6ZAq/kqjbQQUeQWXFEeoMOV4sb2KoD3G8mhPGjAe0dvGJAKB7cSifG9nRQo?=
 =?us-ascii?Q?pIHSUi+g1o97VctMC9Hc4KvHcVfof5KEEyN2Bo5I72MFtJV0xGxx75aY5/xF?=
 =?us-ascii?Q?8Yx81NujHNK0o/XzAewm76GZalORP9JrRPJyXPbiQJRARZyeSLJiESlIQ8v/?=
 =?us-ascii?Q?BiTXWUN1fEhqU3rM+M41P/Xd5Don2qN1GV65w8dKJqi7Vo5pj3rt0SxGrA2S?=
 =?us-ascii?Q?kYV9+xjuDIp9boS3n6V8UTw3fuoSMPelHyDxx3nBesgwKopKDy14cto9x0p+?=
 =?us-ascii?Q?DzBaAEG7w2URXnKuOoAmVokPBMcLEoCOJE6PuiZwrZhrOjDD3WsmW+4Jc0lI?=
 =?us-ascii?Q?Z+VafV3SZl0Jht6f6FZEc18lLfftibc95d5emHxtpEFpIYdhT0QnqK8K4C2+?=
 =?us-ascii?Q?Oh9MvlOwZec2UN/BPNwCOv8poSRlJZWIYy4HOG4KhfKIToh4XQF235v3h9Wg?=
 =?us-ascii?Q?53uaJIsxWLeSsUTGGLhicmzeKq2X+S9gg1huGU6+wDI4mZQTTYIZGAsWueY/?=
 =?us-ascii?Q?ILsPqaXNxKnt9SofaO8oiB+t172cYffF/yxcLy+dOagG4oiQVAUovfpEqrnV?=
 =?us-ascii?Q?9JDxMoohR+ln/xx8Sco99VLVEy3g3TBUGqvY97IW1sUjjjC9Q1Le4sUBkhMK?=
 =?us-ascii?Q?hBjoYQ6oV0a+wfF6ABhV0pQZw2hM29fUOfzsBRyqDWFKCedpFlnaA3f7r0wg?=
 =?us-ascii?Q?Lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?sZwP0AQAL+MoCOLRFz6u4IVQM2iJEfz3Xgw+tu/Rqm55LejgybPtk6cPfDW0?=
 =?us-ascii?Q?iM1fLrIbcBHci9c//WXLyoWhy+ABaVSjRothlO9CpOuI/f98M62ot1y9leX4?=
 =?us-ascii?Q?j8gEvICT9FzVB2IPYsbM4GSlfbhHoNdAor4NRHN4n/xy0/Me3zcUgc5S6Slr?=
 =?us-ascii?Q?+YqnnyuKkhtblhwwPoSso5jHCtLvgrWSo9WQndeWtvMH4bD1PJ36PJpxYXc/?=
 =?us-ascii?Q?gLnQC67eQqbig+/MKfyGoRb6ztoavFKHQ8qL81767tnPd9fXSoZ1BDYykA+r?=
 =?us-ascii?Q?niIcrLd4I+lOE94ilUGMQEGNndRqaZAOVwk092RmheJO6W0/dEY+20R/hq3M?=
 =?us-ascii?Q?+iGqvt6KhQ72yDyoMNuMf4gU5a4Jc1Fr9RuUzyh5x07XAHy8cJo252vYpxDG?=
 =?us-ascii?Q?e+QXkLFUhKXx5MPbixA7wyTc5K8zKHV8Dc25jVRyC1Dcgucw81HwPxWqvxen?=
 =?us-ascii?Q?sBYlnxvM8JQfFm0Zi1DSWeneFTGzKO2lWkmpOLEwZnC4cuaQAbMdQWlT4oaw?=
 =?us-ascii?Q?WsOhY6XY5YrUQ4zsNkVJ+S9a6lDTGeoviPxNov4smhEvGlxr4xP9zVGsM9I8?=
 =?us-ascii?Q?q4QXMNsZr7X3iMtMXZvc+exvpCSP/sTTaq+K6GQYyMvel9EirR8/BdP9DGh4?=
 =?us-ascii?Q?AZkf1ruI13fEN3dEAJqMtbwMCM0jnneQImPmnpniiVq6C3oEGQEpxikkGP9R?=
 =?us-ascii?Q?5dHYMVNEV7TM1FfGhwyMJvvOIWrS8U18hQm4EXrzkxKGLQxlh1d7P/ukIta3?=
 =?us-ascii?Q?MlNU2pMSEj3OG9/04COuWKcWc16HeKQXEggFj+TfTGjEJ51LjxpEjEJaR/IA?=
 =?us-ascii?Q?IiArsGfqor5vjvRr675crrmJbdT1VFJ5wM5dDuxtPBErxuU4CDaQ4P2vROV1?=
 =?us-ascii?Q?+mnp5NMXyMeIa+eKFWG6rBhvpPwwBwTfA2fcdKjICqQTq40HwjaBrfYnmWTA?=
 =?us-ascii?Q?JjAwG6JqccznMQv1mMbdIhhCVRg2wJF/nxdtR5wlqPCo/JUftV64JlWvgHJ5?=
 =?us-ascii?Q?2P9t?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80ed6025-299c-4f29-538b-08db91f72c69
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2023 18:51:39.2287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 88bhDq0y/HMttfuf0GO9Kcnpp4e96Nj8IRt6oimSR1RJE5YBDEj9pHLSGSed8ZgAh0YOExKxdvvv5ADYIr6FSIrqsq/IOkLMtqnHr3AjNLA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7618
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-31_12,2023-07-31_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307310170
X-Proofpoint-GUID: V24B8P1AYIsrwFNSzbfl0m6NuMnp0dIg
X-Proofpoint-ORIG-GUID: V24B8P1AYIsrwFNSzbfl0m6NuMnp0dIg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Niklas,

> now that the ipr driver has been modified to not hook into libata
> all drivers now use the 'new' error handler, so we can remove any
> references to it. And do a general cleanup to remove callbacks
> which are no longer needed.

LGTM.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
