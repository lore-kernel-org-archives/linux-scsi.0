Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF29DC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 10:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiLIKXn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 05:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLIKXl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 05:23:41 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A180F5917A
        for <linux-scsi@vger.kernel.org>; Fri,  9 Dec 2022 02:23:40 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B97nowc026922;
        Fri, 9 Dec 2022 10:23:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=bbhko923xdiJjkPVt38+vN5FcSRxpKxWJU5Ce0nYteE=;
 b=I0mVr/efKzWBZC4s36V+zMl5w4agdeaKl1GQSh+yMW076g6KS+UE7oZHIMA4TbC/Q1mz
 nIcWWdggbOTK0CRY2doogktq/l17bKht5S3s8zyJGdnPlqQlUSlAtqrgc5cnE1nPEd4s
 MacPu9a5R9Aw5nmVqFhFRdLs4MW8GuDdETx2kgRCM1bzZ9v9U52YACOjALAiT1xNiO3R
 ZAuKeAhSQz3vx/GAn6WvPh66JmRtpKzjnKtLALzz9sO+0xArMZpdhM1jNGAkmW4HtGYf
 N0GJIjMhReATy06fM2x62gG3rRbfEU+1OyXdHd2FjC3y2+b6mc+LlpwXE2Jqpy+roVcQ +A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maud74xhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:23:31 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B9878QO019639;
        Fri, 9 Dec 2022 10:23:30 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa8k54n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:23:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pdvp/4qLNPplrlVLUeE01+efooW2WULxB5LrEi0ZIbN2sRMcHZ4xbwJMonYA+7YD78PL8o4PjV+HCLHvxDEH2IQiAgiD6o4EVUCQClZx6RjSY/hn00fjjRvqUBNOrjtYU5MNt3FcspmZc4AnJxRtCJwuTyyVVnAQXT1lyLlLIKKcKkoj8Jqs/Wtv8IPSDXzVOc/UXVFMPItElecCvdx98oksTce8sr1T5RpWhb+W3L/WfXawyAQJSoPEnLfAAgiV/0Fiv38SjLrfCcvas07fTdhogRoBWyB1RgHGKBTlq55rTJgKMleLFKapag2e6pfLDd1C5nLViqFamx00K6mzQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bbhko923xdiJjkPVt38+vN5FcSRxpKxWJU5Ce0nYteE=;
 b=Y6YCPA4ksInMo1oeeOBzeD6FqSKFqKLu4NzESzk/FOTclerlPWWT2YW0918/q5njEfT64b8EWskHvc97ZnNqJwPTeu5aFfSZR81IgVj8BrSXtGKKg6l1BFZqxwBgfAAeomI3PABArlWeHH516+APRgw3ybwoK9oLVYIlJiiS9+1JmQLxgpJeKXVCQvyKtpHtNp9cuaa1xod2jP7u7qsLtvvnRLsHNY0zumLy+6EDWs3m36X8tNhcH1Yrc1cJYRAIs5lY4hYRiavf24W7z9IO57zq/mQrqxlmacNhzaV2Eh4IYTY9ZO6wHvRwKdAhQNzdoB9y29YzeqgCrYJfN/1Iqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbhko923xdiJjkPVt38+vN5FcSRxpKxWJU5Ce0nYteE=;
 b=y5oWinOX0X1u8FelCGDS4G7NSTaKG7b/QM3ozfa4bF4rbsqUm2KGR7OC+HEPdn2Cm4OD7w5E2mwP1pNHk7CmpJPkZpxzrKmzel4wpkNDNmnVXahnX6B6A5cciVrGQKtMTYBvJnd5ETY80sje7bdrwy0wj0s1GH/ZK2UWFDwFbyc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BL3PR10MB6116.namprd10.prod.outlook.com (2603:10b6:208:3bb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 10:23:28 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 10:23:28 +0000
Message-ID: <0ca90183-95b6-5bbb-ae71-4bb6be1b0c33@oracle.com>
Date:   Fri, 9 Dec 2022 10:23:24 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 14/15] scsi: cxlflash: Convert to scsi_execute_args/cmd
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-15-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221209061325.705999-15-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0172.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BL3PR10MB6116:EE_
X-MS-Office365-Filtering-Correlation-Id: eab21a89-a590-4ab7-f0b4-08dad9cf69ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rthsj8txZdrwJUaPs3GGhaPD3xK6abkXv85Fu/ORXIScuyNQ3CAi+iKNZOhkUHa/NLLnAVuAWXWGHuDifwCsEFiwOV4Xitq4c8Ewe8Qf1bPfikWFCp9Nk9IYQW5XVfAOXt2elMCG9TjCgAJNohm5jnRGepdP3PsegVzMQx1Ie1qWWmGd30/74TV7GY1bCdOGtXgvrd2TW/ceJKzbtuDGARFgIArdQcterDJ1QXPgVFbRG7LTKBbfGHX4ndeoSGRuoiQpbXqmOk02yi107XRoIp/KcZsHZvsptF8Ju9NgEsjCH6K1agN9rHL+GhKnA+uDfGLAchhwfm2egiNTJOgA7a+b1cTrDquMCjmAwlknSFAjKfkY/ZQ16etgY1GQYLw3cPB7wUp6rVdpBxBL1BlTNdHw1crvCb5yFgUu/zuQXu/FLJI7lL60iFIsDF1tGVlubrmw3mz0IMKz5kDqs25fs/tKSmirEbiOPTELjpagfOWop85JABxSY2cyUUMgALWpYeHDILhJLKxlRoU5yQYJtjWbvJ3vFIbyWcEY6xxSGtOSuVfs0SRECsqSr5MAAQGU+DcBGP9MGcRGR2YUBBQtqdUFFW2KzBb3jKsdJuYHk3gIcwLpiwVBVymRxDze4lnjLRMI1aifPdasZcup2v+nmRwGALsYafPAn537kINiR0JCJ17ZaKqQ+d2WWqGB8IZkDQDoNsUDfrp60nBBtCq9qnv37pp3j4sVHnLvcvyBCFU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199015)(31686004)(478600001)(6666004)(6486002)(36916002)(5660300002)(6512007)(186003)(38100700002)(6506007)(8936002)(26005)(2906002)(558084003)(86362001)(31696002)(53546011)(8676002)(316002)(41300700001)(36756003)(66476007)(2616005)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDFocjFiVFgxbmNwd0x4c3RUa1hYZTN1UDdXWkE2RzJJd2F1bDZOd2paUU5x?=
 =?utf-8?B?NDFSamVpQVAwTlU5anVsbThSQzJVS21XcHFKclJwTUNld3dLVjNFVTBORGVO?=
 =?utf-8?B?bzUxVE13R0JaRWdqRGxrMEh5eVVzOGlvbDdSa2hHWjkxTkZ0K0M5Nzk2K0Nt?=
 =?utf-8?B?UHowNFNHNkoxNzRFK3hya3dtMlAyQUhvMmZWL3k4ZzUxVEtlbThOMUE3L2dk?=
 =?utf-8?B?TTFsaVp3SEdRWkxQY3BMVXUyZ015bDZhOUJiZmZoMmpFVUhyVUtlRmU2RVlo?=
 =?utf-8?B?ampuYjV5SDIwUDNuV2VRcE9BQkRERlVBcUFvRzB3SVQ3TWwwYUN6dUpGMXlx?=
 =?utf-8?B?NDdIbVJ4bkVBK3k1cnB1S3FPbXNXK0hyZVhQTkRVWjZML2FxQWdMSzFUMnBT?=
 =?utf-8?B?VGExSHFCTytvSHh6Q0JjQ3M2YUMrcDZCMkFmQWF2UGlESDJ0eEhXckRFRFlE?=
 =?utf-8?B?V0JxT3REUklQTWZPc0dDQ0UxaWpsTG5uenZuZ1pjRko5R3JFNmdLTEMrb1Yx?=
 =?utf-8?B?MGxoOTZ6YjNTUlpZbC9QTnAzcTlWQ0VNOTAwRElwY2h3ak1nOXJpRUFEZWJa?=
 =?utf-8?B?Q1RlVU81eGdEMnB5TEVYbytvV3JScWh2WE9hNE5FdkEwOGNQNHRML0FoNVVG?=
 =?utf-8?B?SWU2YlVCQmN4OWNjeVhjTENha3ZtWFBYZk9RUWFjZ1JxdjlSSkl0MS9jUE00?=
 =?utf-8?B?M1ZjeEJUQUMrM2FHNFAvV2lUaXgySXpLU1ZlcmdhS1lwbW5ENGZHZ0JGZDRM?=
 =?utf-8?B?ZU9XQVBKTEhUUGJwY2dwTDk4UEVJSzdSUGNhWm5aLzVXV25mNWZ4S1hvQTBZ?=
 =?utf-8?B?VEE5TWllb2ZDZEo1cmRTWmpzSFpZajJyNkM1a0x5NDJpRGhweS9IdVVENGNI?=
 =?utf-8?B?OE1jY3doUWREcjMxY1VXOFFtdGlYZWZHc3JQV3dYaFREUFpIenBReTNjcmFt?=
 =?utf-8?B?TFI2Z1ZkSUh5K0lwUWpRRmp0REk4dWREZWdyOHhiZTIycmtHalFlOEVSRjNV?=
 =?utf-8?B?MkUzRXdvWHczRGFoSGtPODB3VFFlNXlvSm5mTnVaL0lOMk9heTdyR2JFS0Jh?=
 =?utf-8?B?TlBEaURHT0YvWDd5cG1lU0FGd2JkektPZGFYYmVJbFUvR1JZUVRJUmJzWVNU?=
 =?utf-8?B?ak1YdDJmRVdpRE5yZ1I4SWR6bFhUYm1vQU0vV2ZYNG8vdGkwbkRHUHBlZHJ6?=
 =?utf-8?B?dGxqWlo4VThsVzJBTW9TaXdqU1IwektDWm1HaEJiUUNCWC9TM3BZNlREMzVR?=
 =?utf-8?B?SldoL05nLzBQWUkxcXVwZGY4eVdJSE9JcGxGS2xKZ1piTFRzS2J6ZStFNFMv?=
 =?utf-8?B?aEtjTlZGWC9DZVJEVFpSVzQvbjhUMWo1T0V5Y0VsTEF3eUhCSnN4WE81WlRk?=
 =?utf-8?B?djUwb210MTU4eDE0VFE0T0x1bmFrNFhSZW9uYWhqYnVkWUxsUk91SzVPczZV?=
 =?utf-8?B?d1BqM2E2Ym14b2xhcXVrS2xlVVhmQm1hQno3L0ZJOEI3ZnJpaGdtYm16ZHZI?=
 =?utf-8?B?dHQ2dC9haS9YRnYrRmtNSzdkWVMxZ2E5eFA4STlORXJVZm9TdVZCWXhTcmRP?=
 =?utf-8?B?MElLNERtRXd4eDFHUWtidTVCbSsrTXRia3NFNkVWM2czby95T0pqWkZvSjlB?=
 =?utf-8?B?QWczTEFsOEljTGEwV01odlU3VVlFdHYyUStKQlE5aWNadmowY2hRZlVUeDBK?=
 =?utf-8?B?UGRUZzg0UjNOVHkwQld4SmN3cS9iLzQvUDRaWVc2RWtIR0kxQVZQREtsaEMr?=
 =?utf-8?B?RlZOQk5BUzdvN0FkdFlWK0hlcVBZNXkxeFJOUm0yZGdlWEZFWnYxcHd5bG9R?=
 =?utf-8?B?UWRHRHZoN0N6QU9jYUpoY2NDdWp0YUM2OVI3NmZ0TExZWEEvTVMycU9QdWpr?=
 =?utf-8?B?a2tzSmd2ZEF4K25lWUZnYm1iUHpzUlpndWE0TDRyemdOcG8vZDF6MDBYeFRB?=
 =?utf-8?B?aUVUREJ3ekYrMVlBaldTaWdCSDAyeWZyUnVpVjNTVEFKS0d0cFMvbmg4TGdI?=
 =?utf-8?B?RE9udzlON3U4aFIzZmlYSnJYN2FNejBTNXdURGE3bXRuSHQ0V1R2OWs2VWtu?=
 =?utf-8?B?QWxrSlhPektxMHBiNC8wNG11UzdJZnpHSy9WVmNyOWlWZVFMN2JCb0V5eE4z?=
 =?utf-8?B?dUdFU09sVGdIVjg2dUZHYmg0MWxoSkE4aE1LYWl5M1gwV2tBMmRPc0tjNnlz?=
 =?utf-8?B?d0E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eab21a89-a590-4ab7-f0b4-08dad9cf69ab
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 10:23:28.3470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0dRqL8OKvXZDFlT9uxR+V0NBsUguVb/Fv+NRl1GoTQUF6R02hh/EjHuuFgAsMDJOZERxqm8VxkMwCjJ5Pvl2wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6116
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_04,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090066
X-Proofpoint-GUID: CcWvqxiRmKWn3pGP6A7dgRQ2EOwNWAcd
X-Proofpoint-ORIG-GUID: CcWvqxiRmKWn3pGP6A7dgRQ2EOwNWAcd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/12/2022 06:13, Mike Christie wrote:
> scsi_execute is going to be removed. Convert cxlflash to
> use scsi_execute_args/cmd.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>

FWIW:

Reviewed-by: John Garry <john.g.garry@oracle.com>
