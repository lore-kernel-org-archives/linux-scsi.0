Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAAA0C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 23:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B84BC61056
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 23:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbhJEXyX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 19:54:23 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:22310 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230188AbhJEXyW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 19:54:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1633477950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bCExj5BJPxAGg46aZddowd3FKAXnLNzJZhmZ7EWbxN4=;
        b=RNnu2bX0zRCUQfNYSIdYdA359I5JUSjyd8eShbiUHrtf4ygrpen5D7rKmsI7W58Jo0MghQ
        axQZ1O6Lvv/rbjdwOXjzgBHHswqIDYu4v3+9OWFyc+FQtSMduAxZJtFW0dK3VDEQWL0cmf
        fjQ4bUlUMkIrJH62sw+70qm6XowUAuw=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2175.outbound.protection.outlook.com [104.47.17.175])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-18-5oFDQ8McMHSJ1fh1ccFe2Q-1; Wed, 06 Oct 2021 01:52:29 +0200
X-MC-Unique: 5oFDQ8McMHSJ1fh1ccFe2Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BV/E0KkLOv5cEZ1yXQNSxvRmV9PqZ4giqHmtNhJGLXyIQDbet5dbXhFYfMh0Lz8fWr9mOCLIz/6B6AXhlziqjqawekLn59tub1nuytUqIxvXfywzk3iDceX/kfG0CnnkxPbVJO+uvRZetGAMbK+V8rcjfOLoqxMC4CEY6pg+ck6MwnC0HhW/GOXl7pcQuDntEixlAyVZco5jN4KnITIoCpqGKP885f1ej2FBg3BYWmfQPpkhK1CBXIbtT2F9Gmfaa0kBJXdgTV2MlUg9TqakZDQTT65YQoMdKl6P3sCtVN6b+TMDu4nHeGepWM0Muqmrm24w+1n3J5EEDszZWgPRVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bCExj5BJPxAGg46aZddowd3FKAXnLNzJZhmZ7EWbxN4=;
 b=f5eVumjlffQKISGMLpmlrJ/xyhL1rdlP5xdJYg6yaVo+NirYcNlRJ7hjja4eL5YtneP73tbarI0sj+yeuvA62HiYqRWy9RiGYsDR5yJmLQkk6Oa1XiDy5og6Hxuuvj7m/Y2C+NLQC9kdFvVvRvy96a7jy5HQyxOd8b//PWf0DGHab+KbJ41vbE8Fiy5W5tz2gIOW6NZ8TOeSDIS7NVHKsaARn2hVBUkByt/IL3oDqP5wpiAsBbPXd2u7GTgdFV4LvmmSY0ptSTeuWe5XlaDICY5dYr2V43Ff4bLHAvn7sXPtAH07NHA5HpWpXj9NFVbIHUArkSxoXM+oqfoGUV2zSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM5PR04MB3266.eurprd04.prod.outlook.com (2603:10a6:206:6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.16; Tue, 5 Oct
 2021 23:52:28 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 23:52:28 +0000
Subject: Re: [PATCH v2 44/84] libiscsi: Call scsi_done() directly
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210929220600.3509089-1-bvanassche@acm.org>
 <20210929220600.3509089-45-bvanassche@acm.org>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <d53a14f6-850b-0fc2-597d-d3dcbe48a7c0@suse.com>
Date:   Tue, 5 Oct 2021 16:52:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210929220600.3509089-45-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR0101CA0008.eurprd01.prod.exchangelabs.com
 (2603:10a6:206:16::21) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
Received: from [192.168.20.3] (73.25.22.216) by AM5PR0101CA0008.eurprd01.prod.exchangelabs.com (2603:10a6:206:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Tue, 5 Oct 2021 23:52:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b9e5a98-6c5c-4b12-f55b-08d9885b300e
X-MS-TrafficTypeDiagnostic: AM5PR04MB3266:
X-Microsoft-Antispam-PRVS: <AM5PR04MB326674E4B7C9B6E3AAAC5FD6DAAF9@AM5PR04MB3266.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:425;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GTUb0NNTBzswK9jKCDQY/zSAjp+qQPJah8LgCUuCc9kG9QlRc+XoFe6+vs9uE8f8QzhrFDDFDbnkPmrhC9ss7rCwd+7z/ONGxv0qJ/io+T86yIENiqbilLJYhhufcVU7QjeXHWeo5RG1LmEAswbDYLtEA6n9Ch9F6PK4Ve8sH9K7nOvBgwKe7MSuQmiqyIW5jCweS6L0w0YxU5B4olQGiqNgnOlnmabxcZy9QXHkk5j/+KFz0ASNh53si8aIqsl0HcqIA/PCGLE69MDbDvR+b0KCea7LzvqDlJL7WIiYYEz0KfrewP6xlqk24NUcQWtO71YlY6GqASktJvKOVj1pLm2RAQyqLM2BgV6oIYwetOg1eC1D+C4iCo1XRdu+gI0wn8YT+rO0Nh9iDixfDSV4IMLSwLMk4OkVZ39CZVjQ+lpKfVfrnSRFxgwKlasHy7uNqbEGIOFRKmuETX83BnXWKfeFYbccIcoa43b5/PZSFu8p2/VmabgIAwBpB8IUEdHrfUyaM1nRQ5cGOWpvhNaK2zasSOC9cRjKDt1MrDWZzzj+Mz4M9Eud2EgDxeq7VFzMtiR3nDprVTbT61r1NM5tK2FiKfamNJRs/SwTRj/kHqCjGr2N3oye3bqgUqP82eV+zx0uZf1hkGMWH5xtKh8v85GhO4+XHPLyQu2hIOQzNk9Al1GnK55BJtjSGBqhRucckbqoFcEMzHZPInCSsDvRYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(83380400001)(54906003)(36756003)(508600001)(6486002)(8936002)(8676002)(53546011)(26005)(16576012)(2906002)(316002)(110136005)(31696002)(66946007)(186003)(4326008)(956004)(5660300002)(86362001)(2616005)(38100700002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TkU5RTRaTXlvZEwxNXc5ZUo2T2ZXSzRsVER1SXdrdkJqbGZxWVpNUkNuL1ZO?=
 =?utf-8?B?L1pnQWdNN0hlUVBaYzlzUzBwNUtHREcyejVWaDFEUkd2eFd5UFFMZXFpR1Zi?=
 =?utf-8?B?YkQ1elFSTzQxQUJ4b280d0twMmV5OHNaUGtFQnlPMU9vUHl0YWt5anFmQ2Nq?=
 =?utf-8?B?M0tLcyt1VTgyMXRTdmcwSkJOVnlvZmsyTno4NlIzTTJiRDJOY3B3VU5IZlVB?=
 =?utf-8?B?c2JZWlArUlVaL3FSeVB6eWtvUzRZdGlMeEJyN3FnZ3Joc3JHbUlxcDR0TldE?=
 =?utf-8?B?RVpPVElBd3BnNUxjaCs1ZlpUNWI1MEN4TDF3MkV2ZW5Hclp3bDlSR1QzR0Vk?=
 =?utf-8?B?bFhQV3pXUHFOYm1vRU94UkJWR1RPMmlUNzhOM1F5SDVoNFZ3SDBRcG9CZjRi?=
 =?utf-8?B?T1ozbThlVFpvUjJWZCtCanpVR0Z6dGx1QitlUnRvNlJHZ2RCeTNDNnlKdmRO?=
 =?utf-8?B?VnYvMWdOcUZUYUc0VnJnVUxrWS8rVjFqUk9KWEQxbkV2U0hFOFp5T2g3TkJQ?=
 =?utf-8?B?UWwvVW9zMTcyem9wSmh0NnZlUmZMd0lxRnFSbXEzYTJpRGNndjlzWnk2aEtu?=
 =?utf-8?B?VENVc212Mng4VExMcXE5SzlseEtRbzAxdCtMbUxzQndiNVRTU1BBMkFucmNU?=
 =?utf-8?B?blQ1UzNXNXNnQnIrNVY4OUxTbGdYcytLOGZ1L1I1Sy94cnI2Mk5SVVNxM1ZD?=
 =?utf-8?B?aDR1QnMxcmpsRjB1WXFLU2tYaCtFS1J3ZFYrQ2ZpR29UdlZ3Y21SWDRUMDli?=
 =?utf-8?B?eXFTSG9NUi9hbm5Icjg0eUFNbjM0YXlkenFmQytPb0NHdm0xek5EMUhoY1hV?=
 =?utf-8?B?ZE9udzNyckJKQWZlWG9qUjE4STYrKzJuU29samR3TEkveEwyTXdKeURSMmVH?=
 =?utf-8?B?WUo2QjdFNEg1SlFBWDBjUC8wRDZVOGw4bm1uWjBEY3EzenE1RHVHRlVBSFlL?=
 =?utf-8?B?RVYxS0FzSy8yYW9qOC9NTGJ5OTNBd0Zhb29ZVlQyOTVsYlQ4eXpwUHV3OXNM?=
 =?utf-8?B?aG9XMENLcnAvWHJGeEQ0cU9PKy8wczUyT1NkeFRTMVAvTkh3OVNMbFA1bUMx?=
 =?utf-8?B?MG1GQ0oxQjBjSFd3cjVwZFExdGlQcGhmMk81VmFzZVNVQ2xaeHp6U2Q4VmZj?=
 =?utf-8?B?TWQyU3Z6bEFQMmtUZlRUYnllZ21wQXgwK1hHMlRwaU5Ma1hIWEZISXIwbVRh?=
 =?utf-8?B?dkJYRGVMWHp6ejltNktwZlR2Y21sVWZ0d3l2OHV2UEZoQmRQWGdOajgxY2dp?=
 =?utf-8?B?M0VxVHRocUREODVNckxiVmg0QTZzZHhEaGxIVVFodG5CeTVFbjNBYldJVzR6?=
 =?utf-8?B?aDAzRG1CLzFKT09XdFltVFJCbjZVMzBXUDBPMGVyeUlKY2t0MlZRbnNHMDFW?=
 =?utf-8?B?UFVzWVhSQmc1blU0dzlOajUreWFodjI0cnBqSE52S093SkhZbjMyMks4Z3gz?=
 =?utf-8?B?ZS9PVmRMVjRibmJORWo4ejhaWjRBbWdiakx4QzN2SEltWkZJcWJWb1NDN053?=
 =?utf-8?B?M093dFZmRC9qS3BvcE5IRmRnWjI0YU4rWmlDQ1FvdXA1Z0t3UVZNdG5NcDM4?=
 =?utf-8?B?elkxL3ZRdm1GSGR4OUVkODBuV3dTaDIxLzlJWlEzc1VRKzhCekFiYWVQY0Z2?=
 =?utf-8?B?SjdHS1Nha1JRM1hmSDJncUR4L0Jpa0VNTUR4NmFBc1hML2pOQ1BxbnQzN2lj?=
 =?utf-8?B?QmNtblpKYTVNOWw5MjgrdmN3MW1JekI2dWduellqYWovZ2FmdldTVXFwam95?=
 =?utf-8?Q?VU9+cgrTxb/ag63P0h7cP3GA0gWn/5a2unSILb5?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b9e5a98-6c5c-4b12-f55b-08d9885b300e
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 23:52:28.1142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lvOL6PDQIq3wAE94AoD5SNgF88MGVf+26wTDF8OekCb77B43CKDdySMHdEHhIWJDnT8gZy27flm29JKw5kXTnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3266
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/21 3:05 PM, Bart Van Assche wrote:
> Conditional statements are faster than indirect calls. Hence call
> scsi_done() directly.
> 
> Reviewed-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/libiscsi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 712a45368385..7beedc59d0c6 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -468,7 +468,7 @@ static void iscsi_free_task(struct iscsi_task *task)
>  		 * it will decide how to return sc to scsi-ml.
>  		 */
>  		if (oldstate != ISCSI_TASK_REQUEUE_SCSIQ)
> -			sc->scsi_done(sc);
> +			scsi_done(sc);
>  	}
>  }
>  
> @@ -1807,7 +1807,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>  	ISCSI_DBG_SESSION(session, "iscsi: cmd 0x%x is not queued (%d)\n",
>  			  sc->cmnd[0], reason);
>  	scsi_set_resid(sc, scsi_bufflen(sc));
> -	sc->scsi_done(sc);
> +	scsi_done(sc);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(iscsi_queuecommand);
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

