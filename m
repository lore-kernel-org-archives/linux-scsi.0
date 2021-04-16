Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62858C43460
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42B51613CC
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238346AbhDPCwV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:52:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38964 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238233AbhDPCwP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:52:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2masZ046783;
        Fri, 16 Apr 2021 02:51:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=gir15zSJLVvhvS8XEohZgpZulblANy58vgkIYKIwtDM=;
 b=FRf25AqxiXYoQwUAtsYw8UcOhGgTXJsM6DZ9oFLM8GKru7lEZRhdQrgEQda61OdF2l1A
 Jr64U266OiYfrDRetM7E8Opm9YrlCOo02nbKb9u4q92mT4hT6xeyy9q5UVfRIHnD7zl6
 3BinqIHX8H0IgDjncC+EAT4tobRsSOwyx4xtRhUEfuAzNd2RKG51BCMDl+3KJ0xt2b2q
 6/O75uf9ISkG6CGCv7yfYVmtymHFHcvVT83891dbX1lXjCkeaaB5APaTz6j0UNVTiBHf
 oc/a60z1TizxtE01a2aSars5ZEtPfe/pAbYT/5F7yEEzfArqLu2zc4CfbKd4z1LKoHLH rA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37u3ymqpm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2pcrI044945;
        Fri, 16 Apr 2021 02:51:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 37unswhm3s-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DojKNqYPAu1EsZiJBXM9A1x+aG2c+3buFxWo8wb2Ykc+ETBuoGsM6bWvPneJBqRpNQnNkQqTkEcKj7IiEZkkv53xS1rMLA/xdj1Gou8/kUXJCwD5kMlWVgFT5eVlBW48L9Z1tfCeZfdZ6IciLjwJmfraK5Lp+/2SEFCXGHkoDHlD+WCCiv6RwaZyw4cWU1qRb0VgZQfvk9Ctu091B0esEijYLQYBcmZHFxv5mIRLFulOZtitXErLJzkCt+Dpcvor0kpVzFnZ/pho4yxTrHYgSe6m7eW13j2124mdDcHRipF4/0iy/FU7uUIq3wntXELcf5MngM6KnOyyAc47Cnkmfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gir15zSJLVvhvS8XEohZgpZulblANy58vgkIYKIwtDM=;
 b=ny73eTuMZI6LQ7cVXDAYLePx/vwDlwOVh//0yAupwfANXDKM+EEM5qu+kbdJ/Zf+zPakULQxgw/X4CePPQfF1h1j+w4ORWqeMKFLC1mq/s/9iuNoWTvJandHzUzL683FqHCP9VbnQiMs/6mvmanTtZxqtv2M17wULdZ89S41pworCZ6fTh8gIsd6ybkflnzo/6KuQ4CWNP1KN/bCFogI5s79ClEyJm+o3yuY2O9w2snEq2S+XpHf8fr1VUaUhmdpF2aCGVbnQKPFX9UNHxBjdksJQ6p0YU7ERzY2RnJ1YhgE5sY1qLeXKGR2KsgKtP0/XrAQlgXuOlpT2YTcOh+0Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gir15zSJLVvhvS8XEohZgpZulblANy58vgkIYKIwtDM=;
 b=EMwfbdvj5k0H7lz30R6Y+LcNCUGPEnLIAG4IEitxQeGDUANkXa4P2E+j95es5bqmoceZahtsDwWhurcQEbmHAV4BzGslSzHZUtAiiSOypkp7EW4yXHJCdjXtrqStnrgNOAZzaOTCR1nQNksp0nKTfNLkCGDazc1eMN3ngD/dnCQ=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 02:51:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:51:38 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Luo Jiaxing <luojiaxing@huawei.com>, jejb@linux.ibm.com,
        jinpu.wang@cloud.ionos.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/2] scsi: pm8001: tiny clean up patches
Date:   Thu, 15 Apr 2021 22:51:16 -0400
Message-Id: <161853823944.16006.5150297963975644773.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1617886593-36421-1-git-send-email-luojiaxing@huawei.com>
References: <1617886593-36421-1-git-send-email-luojiaxing@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:6e::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0023.namprd11.prod.outlook.com (2603:10b6:806:6e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:51:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b3abf3c-b0a4-4f0e-9009-08d900828e4b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB456879A2E868DB6DF740E4948E4C9@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3e0u/UKx2sqtq/oEr/FYME3OMVGkBhyaCDXXOapNaJbbR3ZnI0pz/MfRkNREtEQjBWzjLjCw58nHMv2plyAtyVjwvA971btnsRRgm2jqZBK0pVSc12kD9BrsBNzjWhmkKOzIUlm9PahpJo4S3A7eyR3Q+mvghTQy+lt2/hy1BgW/Tgqhw7ba5BDmNkCSX4Xj1lMGQumxvo/heEh9+3RREYJ5zAE438iLwAurXMLPhrdbX1z4NoIDHBirpxo168/WKXK7pPu+5gghbpSnpCynUPfzQJ42XBTkkKDSpAOl4eddTYDN+TnVwamPq/3ybdZM8G8kij2Nuf/0dCga9KteuZRbO30lyhN05MBAqM08YiPkTJaOxcYhha/GgciXHTzTthLbeAqRpMzGKA2uz19vtTmZJW02ctGcQIPjamg+LvE6PbaJVaWlBPyoehinCaVDyAoWoA9Enf4FJUw1+9vfiIA3Cx7vIksbGKZNO2eGDtRs0GlxMrG9G/zl6w+sGfzFJEO0JJ82HCY2aVelvk6TvVXc9TPh8H5A10iW4Ok4feA8lxVFDOX6mYNaYGCk6NLBsYsyRMJNGGhn7zNwOIdJTUVS/EDS4QPSwFgjguzAkfAdrARSMziHVxwyL8RkJQpgr4sf5nNnw8Sw5q5YVUeNB+S+vDcbQn01DDESi42eHizee5HBTQMZT5/FOlivKpjTxcU3ZepmHIJiK9SvEgFaoSat8+i4U9gP/G2S8pzsCsA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(376002)(346002)(136003)(316002)(103116003)(6486002)(5660300002)(478600001)(26005)(2616005)(956004)(8936002)(16526019)(66946007)(66556008)(66476007)(86362001)(4326008)(8676002)(186003)(38100700002)(38350700002)(2906002)(36756003)(966005)(7696005)(6666004)(52116002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K21UcWNLRlFmZVFQRmxRUCtkWUhaSUdYVnAzTGZUNTZaVk5pek1WUUZGTzMx?=
 =?utf-8?B?UnJtNU5LUUQvdEhmak5oQXBaekJiUGpzMnZIaGRtVEhGWWZaQXBhRjk2Y2Rn?=
 =?utf-8?B?WnRzWEF0ME5hODgxQU1HYVpwTWJ5MW1ocjRsRllYdVljNElERTZoamZOdGU5?=
 =?utf-8?B?aEFhVXQ2QXhrZ3h4MkJxN3NuaEpBWWxTSWwvNkh5NW9lSVhENFpXUm8wRjJQ?=
 =?utf-8?B?eGxVOHQ2Q2QzcXF1SzJ6WUhsQk1uNjJoandWa3JmV2o3Y1paM01WYmU2Si81?=
 =?utf-8?B?OENxOVhMS3lZTzRUZkdxYlpVNFpqandsMnpXK1BYZHk5U0toaHZ0WWRPcWlR?=
 =?utf-8?B?cEI2bHc5NnpUb1lCd1VCNm90eDhCOUltTFNIN1VTcTB0dnQwRmNNWGdtcERC?=
 =?utf-8?B?OWk3RlV6RmV6Y002eTZVNjVoV2cydWk0Si9pRGd3U1hSSHZiRTJWUzF6dktH?=
 =?utf-8?B?R0JjVXZGTE9KRXMxQmJURmhManBSbm54RCt0UnFEMW9mSmRCbXU0U1FQMFJM?=
 =?utf-8?B?YWhHK093cGFQaUNzTEQyQ1psZnJtYnI0MkovU3lVekpjdXAzelpMWW5Md3dC?=
 =?utf-8?B?RG4zVUtuMDVPWmlIZ0N2OG15WUZqVEhhMlN0bEt3TENmeHc0U3dpSTk3Z1cr?=
 =?utf-8?B?K0xUcUJSZkoxdHdJNjJZcnZKQmZJZ1FtTEdJc2wrakpHVVAwTWtyMUZIZU55?=
 =?utf-8?B?bnV1emdVZExhU0Jzeml3UEpvekd1Z0dRUC9BSHhQMEl0aE1WOS9aM0RKYnNv?=
 =?utf-8?B?T0YvS3VSenUrQUdITURWb2xORHFPR0QvZ0dpT3VNN3RLalFxMlFrQ3RUbHVj?=
 =?utf-8?B?UTZ5R3U5aFh1N2Q1OGRKSkJqUDNYVzM5T2xqUTR1NjlJdFNwam4zZVV0aGUx?=
 =?utf-8?B?NjRMVWZMVVlyTGdaUmtWdFNGaEM4SnZZSTMwMmZ2ZE1IZXFOenJRMTZYSE9x?=
 =?utf-8?B?Uk9landwb3NRekdQWStaRkxFSmpocUg5Mk81dXJsc251bVI5eVJMaXZFRk53?=
 =?utf-8?B?UFNlbDNWcVRwWnVwNGxNdzZ2ZFc4Z3pqektxNHk2RWZvZUZ5aWg5ekN3eHl4?=
 =?utf-8?B?M3paaDR3bjNBUWtLa3BhY0YwalBpK0FJSmQ0OTVWUGw3aWcvZW9EeHdnRW9K?=
 =?utf-8?B?cEdkeWhaZS9vajZCOTl2KzJ0MkF4ODBVSWh6MitxSXFqbmR6Q2ZDWlhtY0Va?=
 =?utf-8?B?L1MrVE9SUVhvK29wL2wxSHdGVWVIVGRkdU9mZUYxZDVGMXVKQmwrbWJzeEF4?=
 =?utf-8?B?bm5QKzA1WlZkOVVnVHUvNnhtbVRSWXhRcnV5UlFKeTA5ekF5em1TQlJZWTFO?=
 =?utf-8?B?cmJxOUZuUnJRWVZiVnk3R3YwWGRzdUNIb0Y5bFpnR1ZlaG5kcFUzMm4rYVlq?=
 =?utf-8?B?bTZvUlA5WnZ0YkN3SlB6YUo3S08rNmNYeTFybm43bjd6QlQxMTRJSkpJaTg2?=
 =?utf-8?B?ZlRIZ282SEdraTBZK0Znd3Q0ZHFVZkJiMWNqcG95ZnpjSGM4S25lYXVUM2tM?=
 =?utf-8?B?QVQ2aFFIZUFQUXlodzdDVkpEbFdqMzZJQlRjb2o1aW50NnJPdWVlT3N5MElB?=
 =?utf-8?B?aW5FeERGWFpuck8xQ2JJLzZkamlzZGtNREJhbUNVK240bGRVTlI3QTB5TDY5?=
 =?utf-8?B?ZUNESnNpdjI4aWJZRTVXcEN4MCtCWGJ6VHcwOWZWTUs2R0NvcDVXLzRwZmF1?=
 =?utf-8?B?ajA1NHZqeXc0K1NQMVVZbWhXQ2M5ZWdDaEgwL2lsc1NmRTlGSjNnWTNOa0lP?=
 =?utf-8?Q?4W3ol+Yz7R3N2eAzJ/jkMbHEvn6nlB3Hq75iY/W?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b3abf3c-b0a4-4f0e-9009-08d900828e4b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:51:38.4403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XhtWiEVFdGsRDkbel6iTIWvhqpaDrCNloEH2ga66yvMOPQFoXHK6S96KzCS8LPqoWEHSUmMisw7jLZSiK5yMeqy/UA1lsYCJdI7w57qdt7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=894 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160022
X-Proofpoint-GUID: 4ECYxuZlFSCmZH1z6Jl1p9qXg8U3AOvL
X-Proofpoint-ORIG-GUID: 4ECYxuZlFSCmZH1z6Jl1p9qXg8U3AOvL
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 8 Apr 2021 20:56:31 +0800, Luo Jiaxing wrote:

> Several error is reported by checkpatch.pl, here are two patches to clean
> them up.

Applied to 5.13/scsi-queue, thanks!

[1/2] scsi: pm8001: clean up for white space
      https://git.kernel.org/mkp/scsi/c/8a23dbc60089
[2/2] scsi: pm8001: clean up for open brace
      https://git.kernel.org/mkp/scsi/c/fa5ac2beabad

-- 
Martin K. Petersen	Oracle Linux Engineering
