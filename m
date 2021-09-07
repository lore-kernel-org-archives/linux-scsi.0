Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62190C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 15:59:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AEC360F25
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 15:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbhIGQAf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Sep 2021 12:00:35 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:21126 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231667AbhIGQAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2021 12:00:34 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 187En7FB017694;
        Tue, 7 Sep 2021 15:59:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=OYCXWaL7C1I5qPY3hlftl1MUBfwCbhIB8nXepSEw63Q=;
 b=uQb7yqslcR67CmHQd/oQSYvBx4pStsunYZnYVndWNuZkZ8O/gDyf49QN83r1leuxqSjN
 OhtLGgUMHOB6jdz50vINT8sJIp1bAwBwarIN4dDKeg1escEA+mXTJMRbBijpXhTuM7zT
 Xrep/FIQox/Dsaw+B3qP/kUdD1acO89vdOAeEtRY5FlqDicWT+q+4bvIVa+vRBz0gYsN
 Goel0xHcDFLF85WhjDkeT4vmNT9g9SgcCW15ol8Wkud1GXldB2/0OOmGD9Eee9mmSK3r
 U93b+35jxkD/n4BpO80DhHz2z87UI2blPPSXZGXO+IEQbF8GwLj9kNH0IzCJGNUKVCmt VA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=OYCXWaL7C1I5qPY3hlftl1MUBfwCbhIB8nXepSEw63Q=;
 b=SceTMWSysZje05haxLTtoBVN17upLc+yaKC4meM8B71crKgVIPJ9GdQ2xDYtXdVa5+Od
 UlTdZ8uUiU5XVqEtwo5zyjN19baylqPjANV+UsUdWwASzzclW6dpY69ylPC+BqM5M+1L
 YGea6A3J5AWT4OuoNpCcXnXtESh4UxZfkbi8e+qoaBpi8LhclWvmKkD6InEN1JKIDXe4
 0MJAUqAHSPcdrX/wZjDtDXgpmiPsms4a6/ctwOItyP/gARaUl5oYAWrSwnaAr0lz/A6i
 HIMAUSdwp4qMo9BQ74dc6VmQ6umMv7Vic6AYZVOOIDEPzdMUjhrBs1vDdP969zT8e3Vy qA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ax0vf1u2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Sep 2021 15:59:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 187FuAxA096989;
        Tue, 7 Sep 2021 15:59:12 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by aserp3030.oracle.com with ESMTP id 3auxudw4s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Sep 2021 15:59:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrHxWnYaDfgtAgVcF0Iv/l83VWd6IhLjMRWumt/AaJ+KWzEai1rHJYb3UCQ9KmL3VhIeRI1Rm5sQWzVXIKIglGYiwxUjL8iS7qlFMnW6RjCFZCXpUGJAr5yKRtkC0huS5EIi7k6Kwqq71l9axgIVDDN5T3Ze4RppKSfSC2GsYz+syAbVJBieEiQB9gMOEjWa+k9xy1hZADiM+VcB7AgDeTKZxFPzjIsVSjt3J6aPGbtlfRYn+xTylGl25ufruHLeTN3i1B5Hs82DWM3EYR0OLyc5EgY+/LgYYPrngBrVrbJ0KtaUyH2rSrL8psuAwkOwBOvKebkoTHFarms3oD0SPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=OYCXWaL7C1I5qPY3hlftl1MUBfwCbhIB8nXepSEw63Q=;
 b=Hw5qjzujIcogvdWppVbmztCaaaamrqUoUYLFoti91pOqX2H+RcLpS0zEXhtyr4f7+dD6rFGs1QgFS49yQNPDHdDmr5mGTmn9uDDZMIpcZJE5/stJswvmcLzyOKClqcSZyfbidqECoEdXs+6LGx8eKBnDeOVIh9mfYl+m8gHIqE+RIztEh+FZliBN1ViCmOe1qBa+E5Qn6m9YDrl/3gIch/uuJ9PuIBQg4Lmj0dQJdC67o7SLrkONfXkB9kC/FIG0XhSUx69mWOHHGKPRhsUuiy/fbNAHNkRAzbdJlfCiET8HO9TH3R/KPQ/vo886yk4RphvV9F2gjwQUsnpiTyTnWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OYCXWaL7C1I5qPY3hlftl1MUBfwCbhIB8nXepSEw63Q=;
 b=mcoiJ8yIONxEdB1vUlMaJYC8tKYQmO+AeG3zBBrNXAOl3Jrsoyr67S5MqBqqq0mpIvWhhX18ZsqM5SuF3JHazvI/bn8Tdk+YlV0JnJKNh8/NeUPX6SL13iX/MDho0UdFlY4uJMy5C+PXn9EO3sjIlwwh0t60ZChKCJNIYJUCziE=
Authentication-Results: netapp.com; dkim=none (message not signed)
 header.d=none;netapp.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3286.namprd10.prod.outlook.com (2603:10b6:a03:153::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 7 Sep
 2021 15:59:10 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::5cdf:33ab:8d17:9708]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::5cdf:33ab:8d17:9708%7]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 15:59:10 +0000
Subject: Re: [PATCH] I/O errors for ALUA state transitions
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Rajashekhar M A <rajs@netapp.com>
References: <20210907071605.48968-1-hare@suse.de>
From:   michael.christie@oracle.com
Message-ID: <0bc96e82-fdda-4187-148d-5b34f81d4942@oracle.com>
Date:   Tue, 7 Sep 2021 10:59:07 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
In-Reply-To: <20210907071605.48968-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0310.namprd03.prod.outlook.com (2603:10b6:8:2b::9)
 To BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
MIME-Version: 1.0
Received: from [20.15.0.3] (73.88.28.6) by DS7PR03CA0310.namprd03.prod.outlook.com (2603:10b6:8:2b::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.25 via Frontend Transport; Tue, 7 Sep 2021 15:59:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85c3abfc-1dd0-41a7-d0fb-08d972186e4c
X-MS-TrafficTypeDiagnostic: BYAPR10MB3286:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB328675F78D418FEF3186BD10F1D39@BYAPR10MB3286.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0vl9yOMmczFimdjEy8rX8Wnsile+RTgBg5otY3wl6Wct42mLRblI1edpX6AYjX3uCNSmWfHBZYDjFPx5E2hXtoFvrPlZy4k8I1zkuC1QpPHVsuW85wjWXDkguwI1BPwriIWTgvjle42Cu4NUcNNcNM1NySlrXr0JsWtQKAWW1+/CAxX9tEwXDLcJ4bi3V0uUzfXxFY5pjh3SUFCNeypL7jZ7s5bXTOTjOYYYPs0zena1cf7ygHs4tvIn6nZNH67A8csoWzu5sgKQBQ2+8DyD/HatgkL9cSMD93NK6oFcc5QoyXR9Bg1KT9RlP4sTB7XtFUm8jDzPvlqnO8xYW0UE/lVOyxnJSSgwDYEz6r9u9SSTXoPHU8U/EHBRCEZTo49VVhgAFnGJpvOW/RM86EXD/KXzQZ2Y8O/xURcJcX+hr01ILzDDL8ZFqNiwUBz5Zr9Ps9z4JTs0BeT7f8aZh21A5LLPPgaow0Zs2UlfJPzjAJ8MV/KSsZmUm0Y1L6ADlgHJl8GMx1F6Rmg/PBI2nS9DWM5xRS0YUGuiA157NedfGbinaLfOzGWIw2GqT+jezFiMu8/T3+LeXAD5A5OGLVCahOM3EafAiG6PKF1qip4J17ZI+LWHBvcOIoYeZHfDyLXb/Qmsy1GXvn6zHMht3SOWHH8zAwd5sHM2o4bfYOBjRFnE/16U5lzFuCUiiZJ0b/5pDjzjgqsQWE04u26DGPQTdDplzf6ZnkDdWiii980GLWc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(376002)(136003)(39860400002)(86362001)(4326008)(6706004)(186003)(5660300002)(110136005)(8936002)(316002)(16576012)(478600001)(8676002)(36756003)(31696002)(83380400001)(2616005)(53546011)(31686004)(956004)(38100700002)(2906002)(9686003)(26005)(54906003)(66556008)(66476007)(6486002)(66946007)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M25BSWJ1M1FMb1R0dXhKVVJVNlUvYWc3MUJRV1QwOWdNTE1GSUtRczV4Vjly?=
 =?utf-8?B?WmlWSnZNdnhvV3JieWd3NzRmVWdsdXdjT2xJelliL3JQTEoyQnlOZXhxdU83?=
 =?utf-8?B?MThNaFo0WG42cUR2QU92V3RmUU9RNTQrUXFnV3FMMk1tcU82dnB1OHJ5Z0Nq?=
 =?utf-8?B?WnlIM0M4cFBHUkh5RU5SdHRVVnhXWndTNmRWdzVzVFV5aDBpbTAxUElKb2NV?=
 =?utf-8?B?S1kvdG5uNVZnR1NRdlV1dVhHWDZkbXhkcXN4aUVaWnM5aUJVajQvOTVwZFgz?=
 =?utf-8?B?U3JQaHB5bnp3aUt1MlVsT3YvMlRqVndGWFlGcW5RTUEzSDU2aVk4WENaWlhN?=
 =?utf-8?B?OER5aXRwejgxZlpBK0txTjlXT0ZqZDFXSlU2ZHhEQjNiam9TNU5VeEVjcW81?=
 =?utf-8?B?Si94S245NjRub3A1TmtJMVpxZGxNVEp3V2tzeGUva3J1Q24xSFoxUktqcEk1?=
 =?utf-8?B?V2JkUGQzQm1iTXJBZFoyVncwT2JpMWM5a2pyeGVBci8rdlpnVXdQTlVqa1hX?=
 =?utf-8?B?Zy82enVrWnh5UUQrQ3pQMlhmQVB2Y0ZlM0YwWEJ2cC9KNGRobk1KQlZOem9z?=
 =?utf-8?B?QmhBQlUwT1ZqWlJRZUt0KzhtMzRJN3lsK3B5NHQ2R00zbnFnbXpLRWF0V2o2?=
 =?utf-8?B?b3g4cFhJZHVEOWxURW0zU2V1MjZJNEJpdGlHaXZTSnNFSlJiR21TTVJPcDRn?=
 =?utf-8?B?aGd6bkRiajdTamNGeVJ3dTRibitTdWxOS00wR0xLYytETk04VGoyZjBSVi9v?=
 =?utf-8?B?MGxXbFhPQm91S3J3ZWVzVmx1aFMvMmlINjlPTkY3YkE0RHY1ZE5PM2dUN01q?=
 =?utf-8?B?cXpoM0NyeFpzUGRBMVBHN1l4d29idXlWc1czYjE2Nk4zYmJJbWd4ell5UVYy?=
 =?utf-8?B?U3lVZmgzenZreVZNenlneGRYU0QwVGZ3Q3kvdlFOSnNJTEhzdmY2UW5ScjFr?=
 =?utf-8?B?TXdJZFFyZGhEV2RnZGs4TFNRa3FNejEwdGRVMGJpVUYwV2JxRmlJbUNpNG96?=
 =?utf-8?B?T29RQXFyQTJDK0RMUk1IbEVlL3h4SHMyQzBzUzRqQzNpYW53c0RvWXVrTFl3?=
 =?utf-8?B?Vk8xNStrc0J6RkxYdmFtaDN3b1Jxdzg3VWJvaHNwM2RmbTkyVUQwZ21Zck5K?=
 =?utf-8?B?QVJOeld4djRmUzJNNGRFZnJFRFM0cS9HM3ZyMGxCZ0dUWGNVeTRhR0pxZzJX?=
 =?utf-8?B?VlZtaFB2czRiZUlndHltNFBISlJrVU13eTVwWFFpdGVpUGxiWU85c0puLy85?=
 =?utf-8?B?U2R5NDdvMDBOczlnVHE0K1pzUDZSOXJIODZnYUZIU2MrK3hrRU5Va1lSRUR3?=
 =?utf-8?B?K2tyT0hPODY1cUF0QzlxelRZdTR5N2JDSHRVNWd5dmdxcWVhRGlkWGltSExr?=
 =?utf-8?B?QVNkZzU0U1pubzM4UHRlQjNSVGNITC9qdVZCWEdQYkNlOGxhTlVGTmFPYm41?=
 =?utf-8?B?c1hRZE1wRGFhN2ZhK1REZE44N3FoZHlhVS81enJabHNsaUZVb3BFY1ZMZEV2?=
 =?utf-8?B?bUs3N0s3b1VCOHcybUQzK0ducjFWcXZxZ0Nob2xBRVdQbzJROWxCK0QyN3RG?=
 =?utf-8?B?UnNabjNPM3c0MGVwbFJHcm82YmtGUjRuQW1QcW5oa2drUVRtUTBEb0NLQXRZ?=
 =?utf-8?B?NXhIcUVOUWhMclNrbnJpbVJFTEZJNEZRVHI2QnU2a3FzSWltQUlQSVhmckxS?=
 =?utf-8?B?cU8zRXdDWmh2YjIvb3lEaGt6dElkUy8zRVpZVnBOLzBWdEU1TDMrV3JXanJy?=
 =?utf-8?Q?jZKEXlXKtDxdMl8LYjssh2pM2GG4E6DA/L6TK6o?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85c3abfc-1dd0-41a7-d0fb-08d972186e4c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 15:59:10.7014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uRtwd/Z3BjNbIkawatmp5YwvW8yoyM2mv5Yax6vFFrxFjTMS0Xo/ivWnsqHzkXz0ejbpI4Fi0r5aR0oTbdpvUvP8yOMSi2N6+ZFu0Zzv4Uk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3286
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10099 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109070104
X-Proofpoint-GUID: wwHJKV-484PFIphA0w8pW9XJtTjrvhaO
X-Proofpoint-ORIG-GUID: wwHJKV-484PFIphA0w8pW9XJtTjrvhaO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/7/21 2:16 AM, Hannes Reinecke wrote:
> From: Rajashekhar M A <rajs@netapp.com>
> 
> When a host is configured with a few LUNs and IO is running,
> injecting FC faults repeatedly leads to path recovery problems.
> The LUNs have 4 paths each and 3 of them come back active after
> say an FC fault which makes two of the paths go down, instead of
> all 4. This happens after several iterations of continuous FC faults.
> 
> Reason here is that we're returning an I/O error whenever we're
> encountering sense code 06/04/0a (LOGICAL UNIT NOT ACCESSIBLE,
> ASYMMETRIC ACCESS STATE TRANSITION) instead of retrying.
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_error.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 03a2ff547b22..1185083105ae 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -594,10 +594,11 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
>  		    sshdr.asc == 0x3f && sshdr.ascq == 0x0e)
>  			return NEEDS_RETRY;
>  		/*
> -		 * if the device is in the process of becoming ready, we
> -		 * should retry.
> +		 * if the device is in the process of becoming ready, or
> +		 * transitions between ALUA states, we should retry.
>  		 */
> -		if ((sshdr.asc == 0x04) && (sshdr.ascq == 0x01))
> +		if ((sshdr.asc == 0x04) &&
> +		    (sshdr.ascq == 0x01 || sshdr.ascq == 0x0a))
>  			return NEEDS_RETRY;

Why put this here instead of in alua_check_sense with the other ALUA
state transition check?

