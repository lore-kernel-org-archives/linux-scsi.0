Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61661C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 18:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 289106191F
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 18:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhC2SdZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 14:33:25 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:24123 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231468AbhC2SdW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Mar 2021 14:33:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617042800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rmfNr4zolun+cmb+mkLrKpdNg52v27eLxePAB1sbPAI=;
        b=R5hIkRYDfUM1Lm/wREjWPki2cpGpKjQQlIVF8/PdGCsk/t1L7EsyquzxMXrMjDZJs9k4LU
        gp6dOSiP2YlGHqvrRyTspeTuq3B7kC9dHvHI5JliYaow5qAlHu7ZBBULE6iTSkgfgDTQEf
        u9W7nqxaiNOMO8ZJRVTmSR6aoQZxeiY=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2052.outbound.protection.outlook.com [104.47.0.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-20-ntjX3YdOMrOZAmEHIw4ung-1; Mon, 29 Mar 2021 20:33:19 +0200
X-MC-Unique: ntjX3YdOMrOZAmEHIw4ung-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GWLW2GMzpmSJL9cE0BD4xqDEBuAwxGoDPi9AHpceLGcSkGr0eYIbjgdEN4NlmMP2g72mNiuNhQDnkSu7RQlNhQGJaMZb9lzPCptlXkM/ARh+/u2ydM1k14XrzqZ4fuJpPD2yD1Kf1KljmQjUzO8HAIRLUCygAWF2oX74za9UyVqV4X31ZxV1CL9QrwfBR8EW1Ek03K2HnXeSc+vlEQqQHkpf/kq9FOhXB28dqvgGE0XSIIDQyJ/ueRJi/Mt2tpC0rnid8jCv5/FupK3RBr0g0LBtpO/9jjjg/Agy5pwAggebb3Zglro6QltKmf709Qu70ua5R4jFFy9/0OWb8+uPPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLdLSkZXDvSru0i15PIXXPVLc6WaexO/jB38hTiUPMY=;
 b=J3HKSW7K9tcVjVbo5uPidD0iLwoKyamRbQlS8widqGF+8BcWblXa+yspFIM+w+0lrHvpqYguteoAvL2/ieYBxtndJKf9/KOKJBJNBH/7cWawKNUPPT+AXHxrHiboGqF/5IWCzpt+Zpi6XIKkUz/d7yYrWwh5MMCIRhxM6y8BGSWoPHygOiNFESCPDgbHSYqf6fXREiGNAeoGuzS8y9okxyEL+woK7/kA5BdduJnDdJ9+PgDFwyZVmf7aBGO7uRYISiCgKGuJtGReK320EcxrXzE8VlqglrSP2h1x4WSQ9zDgRL9Gyr8K2nIG4fzD4RkbYShxgFyjOsbA9I/npFcLSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB6693.eurprd04.prod.outlook.com (2603:10a6:20b:d9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.30; Mon, 29 Mar
 2021 18:33:17 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%6]) with mapi id 15.20.3955.027; Mon, 29 Mar 2021
 18:33:17 +0000
Subject: Re: [PATCH] Fix fnic driver to remove bogus ratelimit messages.
To:     Joe Perches <joe@perches.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC:     Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20210323172756.5743-1-lduncan@suse.com>
 <279f149ce68566db234e9537b308e26dae78a03f.camel@perches.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <b40f6418-55aa-5318-0da5-c41f12f05386@suse.com>
Date:   Mon, 29 Mar 2021 11:33:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <279f149ce68566db234e9537b308e26dae78a03f.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM0PR02CA0021.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::34) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM0PR02CA0021.eurprd02.prod.outlook.com (2603:10a6:208:3e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29 via Frontend Transport; Mon, 29 Mar 2021 18:33:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aea4557c-eefb-4d3e-3964-08d8f2e11dac
X-MS-TrafficTypeDiagnostic: AM6PR04MB6693:
X-Microsoft-Antispam-PRVS: <AM6PR04MB66933E50A9CAE9F3575E7A38DA7E9@AM6PR04MB6693.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:198;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZkGAMEycIeIPt1GHW5e5lJnK2jNQ7wAvNZ8cXBY3ZhPgklq7hAfudpowMOi/Z5HoRo1j5Q5/NP0nTpqi5YvW94YOozUkURtG7X5zqh9yRTfqcEanv4x0SH/9erj+7AZ+9Uby72GBSp1o0RA9yiEZCB7JQIrWyljvQGQzNvAkxbbUigXrqjBTp0Psz9ygMcrqrtCD8dd3/hzKEzr/saQ9XKVo8CMsSPWZSQArCDlZCwex41AlZFceelMadjVLTe8zCabX7io09LQWwTTS2svspr+ZjEGNZGiksCWGUVaRADYnyGpG3tC9eBYYTusM0oIl+rgB7NYNNyX1jcw2T/vQ9iIzbNI3bxc8nGQgILXLQT3DG7O2b1Wav2CqYONXqYSPmZJJd1xtKoP2snMUAzhVP06L9ELSrvvmd9jvAe2W4TFq0MpYrma9IcAUxfI5i1kgcfCp44uR7uf7MWE2cEwjdg6BkbY0Ida2FfrcbU3JRioZjhj4TiEg7V6spFS4L/E65IAnPiufn12EP00rcob9kyxMpGXctXtLabF8QW+jNd6AA8mtKq4AbZRH5MjBf8+anGkA4iYhHQzF9k2gqeI45/RZ/l9eXgbKtDBNbE3Drjk2UcmBQCUfTcAvSy8Pz2w8F8lxApkyXvHzSbPIHJHUXGzSeUMXOviJXttN7zG6MKJgCh59ZfPBpTldU7R/bsImF3wUxyaefRPOnfTK6+92Nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39850400004)(366004)(346002)(396003)(376002)(86362001)(15650500001)(5660300002)(16526019)(8936002)(8676002)(186003)(54906003)(31686004)(83380400001)(2906002)(6486002)(26005)(66946007)(53546011)(36756003)(956004)(478600001)(4326008)(38100700001)(316002)(52116002)(2616005)(30864003)(66556008)(31696002)(6666004)(16576012)(66476007)(43740500002)(45980500001)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ZVSR474CsVANQ8vtNaO0yGXvm5aprDZYHfhPWLhGjvmdkwAPml7DbzlI2Kyy?=
 =?us-ascii?Q?nqRnlXCXeLs7a5wlJ9WEoGY6hy/49O/c5gUdaPUzNt2M3y/jqhIU5rR7Eg3M?=
 =?us-ascii?Q?Wh11a4lCBGyTzkr9PEa4WHZVZZ5JhEdOLkT9q/kOMwJFvPK/YWKT1mXRiCwl?=
 =?us-ascii?Q?09d5v5yTu96u2/6wcZ2FIH+HjZyDsTS7GRfZJnFN9PnvHjuQa8p3lLPVdDZM?=
 =?us-ascii?Q?sAsz/Q5tswZgbiefB8hKXU4jQ6pWt9Xm7lXNhyrdw3mOPbUiGgqFGdQ1i8Sd?=
 =?us-ascii?Q?EOcH07y+N0iWKwFahmMhB8n+KvVu1IXU06aHBsH2697EuZZryxV8GYa3Mfhp?=
 =?us-ascii?Q?dKI2eUyo09os0h/KR6nmQ2yKjihZgJJklfFYTHUkiynBvwLfTUc73p+lVbgP?=
 =?us-ascii?Q?NA/LCGdcwJEszQS0vIAPyqMK4fDVNklVB4WqKvLYWGETA/sycQ7v1wxjXEri?=
 =?us-ascii?Q?3T1nf75zhnh6PLtOm7XzZiG+y3GrFQ/lsN9iV+mm8NaVxmzaMn6ikAijUJP2?=
 =?us-ascii?Q?SdhfMUSZP6iXozhT41M+Yu4NYBi2+/sKuxdXYwAxFgWRevxeyBew3/PmKfTJ?=
 =?us-ascii?Q?x7syH8T5zWqDyRIHCyijDK+dnlhAu9GabhVhtuXz+jIr7af3B8sGoKBnqU1w?=
 =?us-ascii?Q?HoFsQGxfcoySoIUHoFMMQDkg/vonfEkpOEdWIuC7FT7DrrC/gIfvK65unpRR?=
 =?us-ascii?Q?wXfydm38bZgnxHiPsvbZp5Q/2bRUpX9Qua7Xe1xQ9teNlrEBk1bqCwyBbvj9?=
 =?us-ascii?Q?Gzvjyo6L3e6J0jtC5b9+kcLTB4eRD93xZTPzRApE6lWuEx5aZH0KKynmi5/G?=
 =?us-ascii?Q?IfZ0/GgT4P5bZEVVebKCy1Gn7gwqqZ2aQO24qcBESlOxO6sAvu2Bs4RTzIv6?=
 =?us-ascii?Q?w51/pfNK3lwZWP7spDmm4cogZPz6oztTQPjT/SKchIkri6kZpGXlW1rvB1RL?=
 =?us-ascii?Q?SCSZz71hunJYJd25Rv+QXpiCUb0IYsRAJRy4Mq6wdpkKtsTlRPtlLQTD1GLF?=
 =?us-ascii?Q?vMLaOAhEcp2FnUyfw7hbp6JSdqap3QJBtzxnAvMYAGa0P99q6iOKmNspxqWI?=
 =?us-ascii?Q?ZGULArgQhDqeNeuu82qHa+6UJ1Pg7CnFA+V8dmrQeC3zratI3GoifxfcnX6L?=
 =?us-ascii?Q?/CJle6EB3sZIgkIdLL77pYyhrRldoVfh04DuqncGtBzHxWuKXPXdMLpWq2iJ?=
 =?us-ascii?Q?JaaPM5UmBCaFUQVlajeQ1ZY5iAim0UYhdpwVkBy9GgEbpav99QCWQPBEvi1i?=
 =?us-ascii?Q?fCeCrN+a/WXAIr4T7EjVAOPpMK9rbc8Df+asufUHqG5qpbHMajJDODqQGaEy?=
 =?us-ascii?Q?WOHj3aNj90AxWPIbHRCBlBYx?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aea4557c-eefb-4d3e-3964-08d8f2e11dac
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 18:33:16.9534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YLIF9MjXnj8bhCnGmuKTb3GiZShhmY0pGd+QQVlHTc9VfDU1+Xl2P8Jac+MIco9/TuepGHhbRQvmMnUGzeT8wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6693
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/24/21 3:41 PM, Joe Perches wrote:
> On Tue, 2021-03-23 at 10:27 -0700, lduncan@suse.com wrote:
>> From: Lee Duncan <lduncan@suse.com>
>>
>> Commit b43abcbbd5b1 ("scsi: fnic: Ratelimit printks to avoid
>> looding when vlan is not set by the switch.i") added
>> printk_ratelimit() in front of a couple of debug-mode
>> messages, to reduce logging overrun when debugging the
>> driver. The code:
>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (printk_=
ratelimit())
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0FNIC_FCS_DBG(KERN_DEBUG, fnic->lport=
->host,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0"Start VLAN Discovery\n");
>>
>> ends up calling printk_ratelimit() quite often, triggering
>> many kernel messages about callbacks being surpressed.
>>
>> The fix is to decompose FNIC_FCS_DBG(), then change the order
>> of checks so that printk_ratelimit() is only called if
>> driver debugging is enabled.
>=20
> Please make sure to cc the fnic maintainers when submitting patches
> to their drivers.
>=20
> $ ./scripts/get_maintainer.pl drivers/scsi/fnic/
> Satish Kharat <satishkh@cisco.com> (supporter:CISCO FCOE HBA DRIVER)
> Sesidhar Baddela <sebaddel@cisco.com> (supporter:CISCO FCOE HBA DRIVER)
> Karan Tilak Kumar <kartilak@cisco.com> (supporter:CISCO FCOE HBA DRIVER)
> "James E.J. Bottomley" <jejb@linux.ibm.com> (maintainer:SCSI SUBSYSTEM)
> "Martin K. Petersen" <martin.petersen@oracle.com> (maintainer:SCSI SUBSYS=
TEM)
> linux-scsi@vger.kernel.org (open list:CISCO FCOE HBA DRIVER)
> linux-kernel@vger.kernel.org (open list)
>=20
>=20
> My preference would be to rewrite the FNIC_<FOO>_DBG macros to use
> a single fnic_dbg macro and add a new fnic_dbg_ratelimited macro.
>=20
> Something like the below:
>=20
> This converts a few uses at KERN_INFO to KERN_DEBUG, only uses fnic
> and adds a macro concatenation instead of multiple macros.
>=20
> Miscellanea:
>=20
> o Add missing newlines
> o Coalesce formats
> o Align arguments
>=20
> ---
>=20
> compile tested only
>=20
>  drivers/scsi/fnic/fnic.h      |  45 +++----
>  drivers/scsi/fnic/fnic_fcs.c  |  92 +++++---------
>  drivers/scsi/fnic/fnic_isr.c  |   9 +-
>  drivers/scsi/fnic/fnic_main.c |   9 +-
>  drivers/scsi/fnic/fnic_scsi.c | 280 ++++++++++++++++--------------------=
------
>  5 files changed, 162 insertions(+), 273 deletions(-)
>=20
> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> index 69f373b53132..f12cd6ed9296 100644
> --- a/drivers/scsi/fnic/fnic.h
> +++ b/drivers/scsi/fnic/fnic.h
> @@ -130,36 +130,27 @@
>  extern unsigned int fnic_log_level;
>  extern unsigned int io_completions;
> =20
> -#define FNIC_MAIN_LOGGING 0x01
> -#define FNIC_FCS_LOGGING 0x02
> -#define FNIC_SCSI_LOGGING 0x04
> -#define FNIC_ISR_LOGGING 0x08
> -
> -#define FNIC_CHECK_LOGGING(LEVEL, CMD)				\
> -do {								\
> -	if (unlikely(fnic_log_level & LEVEL))			\
> -		do {						\
> -			CMD;					\
> -		} while (0);					\
> +#define FNIC_DBG_MAIN	0x01
> +#define FNIC_DBG_FCS	0x02
> +#define FNIC_DBG_SCSI	0x04
> +#define FNIC_DBG_ISR	0x08
> +
> +#define fnic_dbg(fnic, TYPE, fmt, ...)					\
> +do {									\
> +	if (unlikely(fnic_log_level & FNIC_DBG_##TYPE))			\
> +		shost_printk(KERN_DEBUG, (fnic)->lport->host,		\
> +			     fmt, ##__VA_ARGS__);			\
>  } while (0)
> =20
> -#define FNIC_MAIN_DBG(kern_level, host, fmt, args...)		\
> -	FNIC_CHECK_LOGGING(FNIC_MAIN_LOGGING,			\
> -			 shost_printk(kern_level, host, fmt, ##args);)
> -
> -#define FNIC_FCS_DBG(kern_level, host, fmt, args...)		\
> -	FNIC_CHECK_LOGGING(FNIC_FCS_LOGGING,			\
> -			 shost_printk(kern_level, host, fmt, ##args);)
> -
> -#define FNIC_SCSI_DBG(kern_level, host, fmt, args...)		\
> -	FNIC_CHECK_LOGGING(FNIC_SCSI_LOGGING,			\
> -			 shost_printk(kern_level, host, fmt, ##args);)
> -
> -#define FNIC_ISR_DBG(kern_level, host, fmt, args...)		\
> -	FNIC_CHECK_LOGGING(FNIC_ISR_LOGGING,			\
> -			 shost_printk(kern_level, host, fmt, ##args);)
> +#define fnic_dbg_ratelimited(fnic, TYPE, fmt, ...)			\
> +do {									\
> +	if (unlikely(fnic_log_level & FNIC_DBG_##TYPE) &&		\
> +	    printk_ratelimit())						\
> +		shost_printk(KERN_DEBUG, (fnic)->lport->host,		\
> +			     fmt, ##__VA_ARGS__);			\
> +} while (0)
> =20
> -#define FNIC_MAIN_NOTE(kern_level, host, fmt, args...)          \
> +#define FNIC_MAIN_NOTE(kern_level, host, fmt, args...)	\
>  	shost_printk(kern_level, host, fmt, ##args)
> =20
>  extern const char *fnic_state_str[];
> diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
> index 881c4823d7e2..81eb278ea025 100644
> --- a/drivers/scsi/fnic/fnic_fcs.c
> +++ b/drivers/scsi/fnic/fnic_fcs.c
> @@ -75,9 +75,8 @@ void fnic_handle_link(struct work_struct *work)
>  	atomic64_set(&fnic->fnic_stats.misc_stats.current_port_speed,
>  			new_port_speed);
>  	if (old_port_speed !=3D new_port_speed)
> -		FNIC_MAIN_DBG(KERN_INFO, fnic->lport->host,
> -				"Current vnic speed set to :  %llu\n",
> -				new_port_speed);
> +		fnic_dbg(fnic, MAIN, "Current vnic speed set to: %llu\n",
> +			 new_port_speed);
> =20
>  	switch (vnic_dev_port_speed(fnic->vdev)) {
>  	case DCEM_PORTSPEED_10G:
> @@ -125,8 +124,7 @@ void fnic_handle_link(struct work_struct *work)
>  					"Link Status:UP_DOWN_UP",
>  					strlen("Link_Status:UP_DOWN_UP")
>  					);
> -				FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
> -					     "link down\n");
> +				fnic_dbg(fnic, FCS, "link down\n");
>  				fcoe_ctlr_link_down(&fnic->ctlr);
>  				if (fnic->config.flags & VFCF_FIP_CAPABLE) {
>  					/* start FCoE VLAN discovery */
> @@ -140,8 +138,7 @@ void fnic_handle_link(struct work_struct *work)
>  					fnic_fcoe_send_vlan_req(fnic);
>  					return;
>  				}
> -				FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
> -					     "link up\n");
> +				fnic_dbg(fnic, FCS, "link up\n");
>  				fcoe_ctlr_link_up(&fnic->ctlr);
>  			} else {
>  				/* UP -> UP */
> @@ -164,7 +161,7 @@ void fnic_handle_link(struct work_struct *work)
>  			fnic_fcoe_send_vlan_req(fnic);
>  			return;
>  		}
> -		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, "link up\n");
> +		fnic_dbg(fnic, FCS, "link up\n");
>  		fnic_fc_trace_set_data(fnic->lport->host->host_no, FNIC_FC_LE,
>  			"Link Status: DOWN_UP", strlen("Link Status: DOWN_UP"));
>  		fcoe_ctlr_link_up(&fnic->ctlr);
> @@ -172,14 +169,14 @@ void fnic_handle_link(struct work_struct *work)
>  		/* UP -> DOWN */
>  		fnic->lport->host_stats.link_failure_count++;
>  		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> -		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, "link down\n");
> +		fnic_dbg(fnic, FCS, "link down\n");
>  		fnic_fc_trace_set_data(
>  			fnic->lport->host->host_no, FNIC_FC_LE,
>  			"Link Status: UP_DOWN",
>  			strlen("Link Status: UP_DOWN"));
>  		if (fnic->config.flags & VFCF_FIP_CAPABLE) {
> -			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
> -				"deleting fip-timer during link-down\n");
> +			fnic_dbg(fnic, FCS,
> +				 "deleting fip-timer during link-down\n");
>  			del_timer_sync(&fnic->fip_timer);
>  		}
>  		fcoe_ctlr_link_down(&fnic->ctlr);
> @@ -281,13 +278,12 @@ void fnic_handle_event(struct work_struct *work)
>  			spin_lock_irqsave(&fnic->fnic_lock, flags);
>  			break;
>  		case FNIC_EVT_START_FCF_DISC:
> -			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
> -				  "Start FCF Discovery\n");
> +			fnic_dbg(fnic, FCS, "Start FCF Discovery\n");
>  			fnic_fcoe_start_fcf_disc(fnic);
>  			break;
>  		default:
> -			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
> -				  "Unknown event 0x%x\n", fevt->event);
> +			fnic_dbg(fnic, FCS, "Unknown event 0x%x\n",
> +				 fevt->event);
>  			break;
>  		}
>  		kfree(fevt);
> @@ -380,9 +376,7 @@ static void fnic_fcoe_send_vlan_req(struct fnic *fnic=
)
>  	fnic_fcoe_reset_vlans(fnic);
>  	fnic->set_vlan(fnic, 0);
> =20
> -	if (printk_ratelimit())
> -		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host,
> -			  "Sending VLAN request...\n");
> +	fnic_dbg_ratelimited(fnic, FCS, "Sending VLAN request...\n");
> =20
>  	skb =3D dev_alloc_skb(sizeof(struct fip_vlan));
>  	if (!skb)
> @@ -434,14 +428,12 @@ static void fnic_fcoe_process_vlan_resp(struct fnic=
 *fnic, struct sk_buff *skb)
>  	u64 sol_time;
>  	unsigned long flags;
> =20
> -	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host,
> -		  "Received VLAN response...\n");
> +	fnic_dbg(fnic, FCS, "Received VLAN response...\n");
> =20
>  	fiph =3D (struct fip_header *) skb->data;
> =20
> -	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host,
> -		  "Received VLAN response... OP 0x%x SUB_OP 0x%x\n",
> -		  ntohs(fiph->fip_op), fiph->fip_subcode);
> +	fnic_dbg(fnic, FCS, "Received VLAN response... OP 0x%x SUB_OP 0x%x\n",
> +		 ntohs(fiph->fip_op), fiph->fip_subcode);
> =20
>  	rlen =3D ntohs(fiph->fip_dl_len) * 4;
>  	fnic_fcoe_reset_vlans(fnic);
> @@ -474,8 +466,7 @@ static void fnic_fcoe_process_vlan_resp(struct fnic *=
fnic, struct sk_buff *skb)
>  	if (list_empty(&fnic->vlans)) {
>  		/* retry from timer */
>  		atomic64_inc(&fnic_stats->vlan_stats.resp_withno_vlanID);
> -		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host,
> -			  "No VLAN descriptors in FIP VLAN response\n");
> +		fnic_dbg(fnic, FCS, "No VLAN descriptors in FIP VLAN response\n");
>  		spin_unlock_irqrestore(&fnic->vlans_lock, flags);
>  		goto out;
>  	}
> @@ -732,7 +723,7 @@ void fnic_update_mac_locked(struct fnic *fnic, u8 *ne=
w)
>  		new =3D ctl;
>  	if (ether_addr_equal(data, new))
>  		return;
> -	FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, "update_mac %pM\n", new);
> +	fnic_dbg(fnic, FCS, "update_mac %pM\n", new);
>  	if (!is_zero_ether_addr(data) && !ether_addr_equal(data, ctl))
>  		vnic_dev_del_addr(fnic->vdev, data);
>  	memcpy(data, new, ETH_ALEN);
> @@ -774,8 +765,7 @@ void fnic_set_port_id(struct fc_lport *lport, u32 por=
t_id, struct fc_frame *fp)
>  	u8 *mac;
>  	int ret;
> =20
> -	FNIC_FCS_DBG(KERN_DEBUG, lport->host, "set port_id %x fp %p\n",
> -		     port_id, fp);
> +	fnic_dbg(fnic, FCS, "set port_id %x fp %p\n", port_id, fp);
> =20
>  	/*
>  	 * If we're clearing the FC_ID, change to use the ctl_src_addr.
> @@ -801,10 +791,8 @@ void fnic_set_port_id(struct fc_lport *lport, u32 po=
rt_id, struct fc_frame *fp)
>  	if (fnic->state =3D=3D FNIC_IN_ETH_MODE || fnic->state =3D=3D FNIC_IN_F=
C_MODE)
>  		fnic->state =3D FNIC_IN_ETH_TRANS_FC_MODE;
>  	else {
> -		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
> -			     "Unexpected fnic state %s while"
> -			     " processing flogi resp\n",
> -			     fnic_state_to_str(fnic->state));
> +		fnic_dbg(fnic, FCS, "Unexpected fnic state %s while processing flogi r=
esp\n",
> +			 fnic_state_to_str(fnic->state));
>  		spin_unlock_irq(&fnic->fnic_lock);
>  		return;
>  	}
> @@ -881,8 +869,7 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *r=
q, struct cq_desc
>  		skb_trim(skb, bytes_written);
>  		if (!fcs_ok) {
>  			atomic64_inc(&fnic_stats->misc_stats.frame_errors);
> -			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
> -				     "fcs error.  dropping packet.\n");
> +			fnic_dbg(fnic, FCS, "fcs error - dropping packet\n");
>  			goto drop;
>  		}
>  		if (fnic_import_rq_eth_pkt(fnic, skb))
> @@ -897,12 +884,9 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *=
rq, struct cq_desc
> =20
>  	if (!fcs_ok || packet_error || !fcoe_fc_crc_ok || fcoe_enc_error) {
>  		atomic64_inc(&fnic_stats->misc_stats.frame_errors);
> -		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
> -			     "fnic rq_cmpl fcoe x%x fcsok x%x"
> -			     " pkterr x%x fcoe_fc_crc_ok x%x, fcoe_enc_err"
> -			     " x%x\n",
> -			     fcoe, fcs_ok, packet_error,
> -			     fcoe_fc_crc_ok, fcoe_enc_error);
> +		fnic_dbg(fnic, FCS, "fnic rq_cmpl fcoe x%x fcsok x%x pkterr x%x fcoe_f=
c_crc_ok x%x, fcoe_enc_err x%x\n",
> +			 fcoe, fcs_ok, packet_error,
> +			 fcoe_fc_crc_ok, fcoe_enc_error);
>  		goto drop;
>  	}
> =20
> @@ -978,8 +962,7 @@ int fnic_alloc_rq_frame(struct vnic_rq *rq)
>  	len =3D FC_FRAME_HEADROOM + FC_MAX_FRAME + FC_FRAME_TAILROOM;
>  	skb =3D dev_alloc_skb(len);
>  	if (!skb) {
> -		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
> -			     "Unable to allocate RQ sk_buff\n");
> +		fnic_dbg(fnic, FCS, "Unable to allocate RQ sk_buff\n");
>  		return -ENOMEM;
>  	}
>  	skb_reset_mac_header(skb);
> @@ -1343,29 +1326,23 @@ void fnic_handle_fip_timer(struct fnic *fnic)
>  	if (list_empty(&fnic->vlans)) {
>  		spin_unlock_irqrestore(&fnic->vlans_lock, flags);
>  		/* no vlans available, try again */
> -		if (printk_ratelimit())
> -			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
> -				  "Start VLAN Discovery\n");
> +		fnic_dbg_ratelimited(fnic, FCS, "Start VLAN Discovery\n");
>  		fnic_event_enq(fnic, FNIC_EVT_START_VLAN_DISC);
>  		return;
>  	}
> =20
>  	vlan =3D list_first_entry(&fnic->vlans, struct fcoe_vlan, list);
> -	FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
> -		  "fip_timer: vlan %d state %d sol_count %d\n",
> -		  vlan->vid, vlan->state, vlan->sol_count);
> +	fnic_dbg(fnic, FCS, "fip_timer: vlan %d state %d sol_count %d\n",
> +		 vlan->vid, vlan->state, vlan->sol_count);
>  	switch (vlan->state) {
>  	case FIP_VLAN_USED:
> -		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
> -			  "FIP VLAN is selected for FC transaction\n");
> +		fnic_dbg(fnic, FCS, "FIP VLAN is selected for FC transaction\n");
>  		spin_unlock_irqrestore(&fnic->vlans_lock, flags);
>  		break;
>  	case FIP_VLAN_FAILED:
>  		spin_unlock_irqrestore(&fnic->vlans_lock, flags);
>  		/* if all vlans are in failed state, restart vlan disc */
> -		if (printk_ratelimit())
> -			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
> -				  "Start VLAN Discovery\n");
> +		fnic_dbg_ratelimited(fnic, FCS, "Start VLAN Discovery\n");
>  		fnic_event_enq(fnic, FNIC_EVT_START_VLAN_DISC);
>  		break;
>  	case FIP_VLAN_SENT:
> @@ -1374,9 +1351,8 @@ void fnic_handle_fip_timer(struct fnic *fnic)
>  			 * no response on this vlan, remove  from the list.
>  			 * Try the next vlan
>  			 */
> -			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host,
> -				  "Dequeue this VLAN ID %d from list\n",
> -				  vlan->vid);
> +			fnic_dbg(fnic, FCS, "Dequeue this VLAN ID %d from list\n",
> +				 vlan->vid);
>  			list_del(&vlan->list);
>  			kfree(vlan);
>  			vlan =3D NULL;
> @@ -1384,9 +1360,7 @@ void fnic_handle_fip_timer(struct fnic *fnic)
>  				/* we exhausted all vlans, restart vlan disc */
>  				spin_unlock_irqrestore(&fnic->vlans_lock,
>  							flags);
> -				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host,
> -					  "fip_timer: vlan list empty, "
> -					  "trigger vlan disc\n");
> +				fnic_dbg(fnic, FCS, "fip_timer: vlan list empty, trigger vlan disc\n=
");
>  				fnic_event_enq(fnic, FNIC_EVT_START_VLAN_DISC);
>  				return;
>  			}
> diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
> index 2fb2731f50fb..dbd86ddd3418 100644
> --- a/drivers/scsi/fnic/fnic_isr.c
> +++ b/drivers/scsi/fnic/fnic_isr.c
> @@ -263,8 +263,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
>  			fnic->intr_count =3D vecs;
>  			fnic->err_intr_offset =3D FNIC_MSIX_ERR_NOTIFY;
> =20
> -			FNIC_ISR_DBG(KERN_DEBUG, fnic->lport->host,
> -				     "Using MSI-X Interrupts\n");
> +			fnic_dbg(fnic, ISR, "Using MSI-X Interrupts\n");
>  			vnic_dev_set_intr_mode(fnic->vdev,
>  					       VNIC_DEV_INTR_MODE_MSIX);
>  			return 0;
> @@ -289,8 +288,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
>  		fnic->intr_count =3D 1;
>  		fnic->err_intr_offset =3D 0;
> =20
> -		FNIC_ISR_DBG(KERN_DEBUG, fnic->lport->host,
> -			     "Using MSI Interrupts\n");
> +		fnic_dbg(fnic, ISR, "Using MSI Interrupts\n");
>  		vnic_dev_set_intr_mode(fnic->vdev, VNIC_DEV_INTR_MODE_MSI);
> =20
>  		return 0;
> @@ -315,8 +313,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
>  		fnic->cq_count =3D 3;
>  		fnic->intr_count =3D 3;
> =20
> -		FNIC_ISR_DBG(KERN_DEBUG, fnic->lport->host,
> -			     "Using Legacy Interrupts\n");
> +		fnic_dbg(fnic, ISR, "Using Legacy Interrupts\n");
>  		vnic_dev_set_intr_mode(fnic->vdev, VNIC_DEV_INTR_MODE_INTX);
> =20
>  		return 0;
> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.=
c
> index 186c3ab4456b..dd6bb5643ebb 100644
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c
> @@ -220,9 +220,7 @@ static struct fc_host_statistics *fnic_get_stats(stru=
ct Scsi_Host *host)
>  	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> =20
>  	if (ret) {
> -		FNIC_MAIN_DBG(KERN_DEBUG, fnic->lport->host,
> -			      "fnic: Get vnic stats failed"
> -			      " 0x%x", ret);
> +		fnic_dbg(fnic, MAIN, "fnic: Get vnic stats failed 0x%x\n", ret);
>  		return stats;
>  	}
>  	vs =3D fnic->stats;
> @@ -332,9 +330,8 @@ static void fnic_reset_host_stats(struct Scsi_Host *h=
ost)
>  	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> =20
>  	if (ret) {
> -		FNIC_MAIN_DBG(KERN_DEBUG, fnic->lport->host,
> -				"fnic: Reset vnic stats failed"
> -				" 0x%x", ret);
> +		fnic_dbg(fnic, MAIN, "fnic: Reset vnic stats failed 0x%x\n",
> +			 ret);
>  		return;
>  	}
>  	fnic->stats_reset_time =3D jiffies;
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.=
c
> index e619a82f921b..3809e57792aa 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -240,12 +240,10 @@ int fnic_fw_reset_handler(struct fnic *fnic)
> =20
>  	if (!ret) {
>  		atomic64_inc(&fnic->fnic_stats.reset_stats.fw_resets);
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			      "Issued fw reset\n");
> +		fnic_dbg(fnic, SCSI, "Issued fw reset\n");
>  	} else {
>  		fnic_clear_state_flags(fnic, FNIC_FLAGS_FWRESET);
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			      "Failed to issue fw reset\n");
> +		fnic_dbg(fnic, SCSI, "Failed to issue fw reset\n");
>  	}
> =20
>  	return ret;
> @@ -288,15 +286,13 @@ int fnic_flogi_reg_handler(struct fnic *fnic, u32 f=
c_id)
>  						fc_id, gw_mac,
>  						fnic->data_src_addr,
>  						lp->r_a_tov, lp->e_d_tov);
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			      "FLOGI FIP reg issued fcid %x src %pM dest %pM\n",
> -			      fc_id, fnic->data_src_addr, gw_mac);
> +		fnic_dbg(fnic, SCSI, "FLOGI FIP reg issued fcid %x src %pM dest %pM\n"=
,
> +			 fc_id, fnic->data_src_addr, gw_mac);
>  	} else {
>  		fnic_queue_wq_copy_desc_flogi_reg(wq, SCSI_NO_TAG,
>  						  format, fc_id, gw_mac);
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			      "FLOGI reg issued fcid %x map %d dest %pM\n",
> -			      fc_id, fnic->ctlr.map_dest, gw_mac);
> +		fnic_dbg(fnic, SCSI, "FLOGI reg issued fcid %x map %d dest %pM\n",
> +			 fc_id, fnic->ctlr.map_dest, gw_mac);
>  	}
> =20
>  	atomic64_inc(&fnic->fnic_stats.fw_stats.active_fw_reqs);
> @@ -373,8 +369,8 @@ static inline int fnic_queue_wq_copy_desc(struct fnic=
 *fnic,
> =20
>  	if (unlikely(!vnic_wq_copy_desc_avail(wq))) {
>  		spin_unlock_irqrestore(&fnic->wq_copy_lock[0], intr_flags);
> -		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
> -			  "fnic_queue_wq_copy_desc failure - no descriptors\n");
> +		fnic_dbg(fnic, SCSI, "%s: failure - no descriptors\n",
> +			 __func__);
>  		atomic64_inc(&misc_stats->io_cpwq_alloc_failures);
>  		return SCSI_MLQUEUE_HOST_BUSY;
>  	}
> @@ -445,8 +441,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc=
, void (*done)(struct scsi_
> =20
>  	rport =3D starget_to_rport(scsi_target(sc->device));
>  	if (!rport) {
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -				"returning DID_NO_CONNECT for IO as rport is NULL\n");
> +		fnic_dbg(fnic, SCSI, "returning DID_NO_CONNECT for IO as rport is NULL=
\n");
>  		sc->result =3D DID_NO_CONNECT << 16;
>  		done(sc);
>  		return 0;
> @@ -454,8 +449,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc=
, void (*done)(struct scsi_
> =20
>  	ret =3D fc_remote_port_chkready(rport);
>  	if (ret) {
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -				"rport is not ready\n");
> +		fnic_dbg(fnic, SCSI, "rport is not ready\n");
>  		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
>  		sc->result =3D ret;
>  		done(sc);
> @@ -464,9 +458,8 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc=
, void (*done)(struct scsi_
> =20
>  	rp =3D rport->dd_data;
>  	if (!rp || rp->rp_state =3D=3D RPORT_ST_DELETE) {
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			"rport 0x%x removed, returning DID_NO_CONNECT\n",
> -			rport->port_id);
> +		fnic_dbg(fnic, SCSI, "rport 0x%x removed, returning DID_NO_CONNECT\n",
> +			 rport->port_id);
> =20
>  		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
>  		sc->result =3D DID_NO_CONNECT<<16;
> @@ -475,9 +468,8 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc=
, void (*done)(struct scsi_
>  	}
> =20
>  	if (rp->rp_state !=3D RPORT_ST_READY) {
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			"rport 0x%x in state 0x%x, returning DID_IMM_RETRY\n",
> -			rport->port_id, rp->rp_state);
> +		fnic_dbg(fnic, SCSI, "rport 0x%x in state 0x%x, returning DID_IMM_RETR=
Y\n",
> +			 rport->port_id, rp->rp_state);
> =20
>  		sc->result =3D DID_IMM_RETRY << 16;
>  		done(sc);
> @@ -650,15 +642,12 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct =
fnic *fnic,
>  	if (fnic->state =3D=3D FNIC_IN_FC_TRANS_ETH_MODE) {
>  		/* Check status of reset completion */
>  		if (!hdr_status) {
> -			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -				      "reset cmpl success\n");
> +			fnic_dbg(fnic, SCSI, "reset cmpl success\n");
>  			/* Ready to send flogi out */
>  			fnic->state =3D FNIC_IN_ETH_MODE;
>  		} else {
> -			FNIC_SCSI_DBG(KERN_DEBUG,
> -				      fnic->lport->host,
> -				      "fnic fw_reset : failed %s\n",
> -				      fnic_fcpio_status_to_str(hdr_status));
> +			fnic_dbg(fnic, SCSI, "fnic fw_reset : failed %s\n",
> +				 fnic_fcpio_status_to_str(hdr_status));
> =20
>  			/*
>  			 * Unable to change to eth mode, cannot send out flogi
> @@ -671,10 +660,8 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct f=
nic *fnic,
>  			ret =3D -1;
>  		}
>  	} else {
> -		FNIC_SCSI_DBG(KERN_DEBUG,
> -			      fnic->lport->host,
> -			      "Unexpected state %s while processing"
> -			      " reset cmpl\n", fnic_state_to_str(fnic->state));
> +		fnic_dbg(fnic, SCSI, "Unexpected state %s while processing reset cmpl\=
n",
> +			 fnic_state_to_str(fnic->state));
>  		atomic64_inc(&reset_stats->fw_reset_failures);
>  		ret =3D -1;
>  	}
> @@ -725,22 +712,17 @@ static int fnic_fcpio_flogi_reg_cmpl_handler(struct=
 fnic *fnic,
> =20
>  		/* Check flogi registration completion status */
>  		if (!hdr_status) {
> -			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -				      "flog reg succeeded\n");
> +			fnic_dbg(fnic, SCSI, "flog reg succeeded\n");
>  			fnic->state =3D FNIC_IN_FC_MODE;
>  		} else {
> -			FNIC_SCSI_DBG(KERN_DEBUG,
> -				      fnic->lport->host,
> -				      "fnic flogi reg :failed %s\n",
> -				      fnic_fcpio_status_to_str(hdr_status));
> +			fnic_dbg(fnic, SCSI, "fnic flogi reg :failed %s\n",
> +				 fnic_fcpio_status_to_str(hdr_status));
>  			fnic->state =3D FNIC_IN_ETH_MODE;
>  			ret =3D -1;
>  		}
>  	} else {
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			      "Unexpected fnic state %s while"
> -			      " processing flogi reg completion\n",
> -			      fnic_state_to_str(fnic->state));
> +		fnic_dbg(fnic, SCSI, "Unexpected fnic state %s while processing flogi =
reg completion\n",
> +			 fnic_state_to_str(fnic->state));
>  		ret =3D -1;
>  	}
> =20
> @@ -901,14 +883,11 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fn=
ic *fnic,
>  		if(FCPIO_ABORTED =3D=3D hdr_status)
>  			CMD_FLAGS(sc) |=3D FNIC_IO_ABORTED;
> =20
> -		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
> -			"icmnd_cmpl abts pending "
> -			  "hdr status =3D %s tag =3D 0x%x sc =3D 0x%p "
> -			  "scsi_status =3D %x residual =3D %d\n",
> -			  fnic_fcpio_status_to_str(hdr_status),
> -			  id, sc,
> -			  icmnd_cmpl->scsi_status,
> -			  icmnd_cmpl->residual);
> +		fnic_dbg(fnic, SCSI, "icmnd_cmpl abts pending hdr status =3D %s tag =
=3D 0x%x sc =3D 0x%p scsi_status =3D %x residual =3D %d\n",
> +			 fnic_fcpio_status_to_str(hdr_status),
> +			 id, sc,
> +			 icmnd_cmpl->scsi_status,
> +			 icmnd_cmpl->residual);
>  		return;
>  	}
> =20
> @@ -1114,9 +1093,8 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fni=
c *fnic,
>  	if ((id & FNIC_TAG_ABORT) && (id & FNIC_TAG_DEV_RST)) {
>  		/* Abort and terminate completion of device reset req */
>  		/* REVISIT : Add asserts about various flags */
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			      "dev reset abts cmpl recd. id %x status %s\n",
> -			      id, fnic_fcpio_status_to_str(hdr_status));
> +		fnic_dbg(fnic, SCSI, "dev reset abts cmpl recd. id %x status %s\n",
> +			 id, fnic_fcpio_status_to_str(hdr_status));
>  		CMD_STATE(sc) =3D FNIC_IOREQ_ABTS_COMPLETE;
>  		CMD_ABTS_STATUS(sc) =3D hdr_status;
>  		CMD_FLAGS(sc) |=3D FNIC_DEV_RST_DONE;
> @@ -1136,9 +1114,8 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fni=
c *fnic,
>  					&term_stats->terminate_fw_timeouts);
>  			break;
>  		case FCPIO_ITMF_REJECTED:
> -			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
> -				"abort reject recd. id %d\n",
> -				(int)(id & FNIC_TAG_MASK));
> +			fnic_dbg(fnic, SCSI, "abort reject recd. id %d\n",
> +				 (int)(id & FNIC_TAG_MASK));
>  			break;
>  		case FCPIO_IO_NOT_FOUND:
>  			if (CMD_FLAGS(sc) & FNIC_IO_ABTS_ISSUED)
> @@ -1171,10 +1148,9 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fn=
ic *fnic,
>  		if (!(CMD_FLAGS(sc) & (FNIC_IO_ABORTED | FNIC_IO_DONE)))
>  			atomic64_inc(&misc_stats->no_icmnd_itmf_cmpls);
> =20
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			      "abts cmpl recd. id %d status %s\n",
> -			      (int)(id & FNIC_TAG_MASK),
> -			      fnic_fcpio_status_to_str(hdr_status));
> +		fnic_dbg(fnic, SCSI, "abts cmpl recd. id %d status %s\n",
> +			 (int)(id & FNIC_TAG_MASK),
> +			 fnic_fcpio_status_to_str(hdr_status));
> =20
>  		/*
>  		 * If scsi_eh thread is blocked waiting for abts to complete,
> @@ -1185,8 +1161,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fni=
c *fnic,
>  			complete(io_req->abts_done);
>  			spin_unlock_irqrestore(io_lock, flags);
>  		} else {
> -			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -				      "abts cmpl, completing IO\n");
> +			fnic_dbg(fnic, SCSI, "abts cmpl, completing IO\n");
>  			CMD_SP(sc) =3D NULL;
>  			sc->result =3D (DID_ERROR << 16);
> =20
> @@ -1227,11 +1202,9 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fn=
ic *fnic,
>  				  jiffies_to_msecs(jiffies - start_time),
>  				  desc, 0,
>  				  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
> -			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -				"Terminate pending "
> -				"dev reset cmpl recd. id %d status %s\n",
> -				(int)(id & FNIC_TAG_MASK),
> -				fnic_fcpio_status_to_str(hdr_status));
> +			fnic_dbg(fnic, SCSI, "Terminate pending dev reset cmpl recd. id %d st=
atus %s\n",
> +				 (int)(id & FNIC_TAG_MASK),
> +				 fnic_fcpio_status_to_str(hdr_status));
>  			return;
>  		}
>  		if (CMD_FLAGS(sc) & FNIC_DEV_RST_TIMED_OUT) {
> @@ -1242,19 +1215,16 @@ static void fnic_fcpio_itmf_cmpl_handler(struct f=
nic *fnic,
>  				  jiffies_to_msecs(jiffies - start_time),
>  				  desc, 0,
>  				  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
> -			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -				"dev reset cmpl recd after time out. "
> -				"id %d status %s\n",
> -				(int)(id & FNIC_TAG_MASK),
> -				fnic_fcpio_status_to_str(hdr_status));
> +			fnic_dbg(fnic, SCSI, "dev reset cmpl recd after time out. id %d statu=
s %s\n",
> +				 (int)(id & FNIC_TAG_MASK),
> +				 fnic_fcpio_status_to_str(hdr_status));
>  			return;
>  		}
>  		CMD_STATE(sc) =3D FNIC_IOREQ_CMD_COMPLETE;
>  		CMD_FLAGS(sc) |=3D FNIC_DEV_RST_DONE;
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			      "dev reset cmpl recd. id %d status %s\n",
> -			      (int)(id & FNIC_TAG_MASK),
> -			      fnic_fcpio_status_to_str(hdr_status));
> +		fnic_dbg(fnic, SCSI, "dev reset cmpl recd. id %d status %s\n",
> +			 (int)(id & FNIC_TAG_MASK),
> +			 fnic_fcpio_status_to_str(hdr_status));
>  		if (io_req->dr_done)
>  			complete(io_req->dr_done);
>  		spin_unlock_irqrestore(io_lock, flags);
> @@ -1313,9 +1283,8 @@ static int fnic_fcpio_cmpl_handler(struct vnic_dev =
*vdev,
>  		break;
> =20
>  	default:
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			      "firmware completion type %d\n",
> -			      desc->hdr.type);
> +		fnic_dbg(fnic, SCSI, "firmware completion type %d\n",
> +			 desc->hdr.type);
>  		break;
>  	}
> =20
> @@ -1419,10 +1388,9 @@ static void fnic_cleanup_io(struct fnic *fnic, int=
 exclude_id)
>  		mempool_free(io_req, fnic->io_req_pool);
> =20
>  		sc->result =3D DID_TRANSPORT_DISRUPTED << 16;
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			      "%s: tag:0x%x : sc:0x%p duration =3D %lu DID_TRANSPORT_DISRUPTE=
D\n",
> -			      __func__, sc->request->tag, sc,
> -			      (jiffies - start_time));
> +		fnic_dbg(fnic, SCSI, "%s: tag:0x%x : sc:0x%p duration =3D %lu DID_TRAN=
SPORT_DISRUPTED\n",
> +			 __func__, sc->request->tag, sc,
> +			 (jiffies - start_time));
> =20
>  		if (atomic64_read(&fnic->io_cmpl_skip))
>  			atomic64_dec(&fnic->io_cmpl_skip);
> @@ -1495,8 +1463,7 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_co=
py *wq,
> =20
>  wq_copy_cleanup_scsi_cmd:
>  	sc->result =3D DID_NO_CONNECT << 16;
> -	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, "wq_copy_cleanup_handler:"
> -		      " DID_NO_CONNECT\n");
> +	fnic_dbg(fnic, SCSI, "wq_copy_cleanup_handler: DID_NO_CONNECT\n");
> =20
>  	if (sc->scsi_done) {
>  		FNIC_TRACE(fnic_wq_copy_cleanup_handler,
> @@ -1537,8 +1504,7 @@ static inline int fnic_queue_abort_io_req(struct fn=
ic *fnic, int tag,
>  	if (!vnic_wq_copy_desc_avail(wq)) {
>  		spin_unlock_irqrestore(&fnic->wq_copy_lock[0], flags);
>  		atomic_dec(&fnic->in_flight);
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			"fnic_queue_abort_io_req: failure: no descriptors\n");
> +		fnic_dbg(fnic, SCSI, "%s: failure: no descriptors\n", __func__);
>  		atomic64_inc(&misc_stats->abts_cpwq_alloc_failures);
>  		return 1;
>  	}
> @@ -1572,10 +1538,7 @@ static void fnic_rport_exch_reset(struct fnic *fni=
c, u32 port_id)
>  	struct scsi_lun fc_lun;
>  	enum fnic_ioreq_state old_ioreq_state;
> =20
> -	FNIC_SCSI_DBG(KERN_DEBUG,
> -		      fnic->lport->host,
> -		      "fnic_rport_exch_reset called portid 0x%06x\n",
> -		      port_id);
> +	fnic_dbg(fnic, SCSI, "%s: called portid 0x%06x\n", __func__, port_id);
> =20
>  	if (fnic->in_remove)
>  		return;
> @@ -1599,9 +1562,8 @@ static void fnic_rport_exch_reset(struct fnic *fnic=
, u32 port_id)
> =20
>  		if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
>  			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
> -			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			"fnic_rport_exch_reset dev rst not pending sc 0x%p\n",
> -			sc);
> +			fnic_dbg(fnic, SCSI, "%s: dev rst not pending sc 0x%p\n",
> +				 __func__, sc);
>  			spin_unlock_irqrestore(io_lock, flags);
>  			continue;
>  		}
> @@ -1634,15 +1596,13 @@ static void fnic_rport_exch_reset(struct fnic *fn=
ic, u32 port_id)
>  		if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET) {
>  			atomic64_inc(&reset_stats->device_reset_terminates);
>  			abt_tag =3D (tag | FNIC_TAG_DEV_RST);
> -			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			"fnic_rport_exch_reset dev rst sc 0x%p\n",
> -			sc);
> +			fnic_dbg(fnic, SCSI, "%s: dev rst sc 0x%p\n",
> +				 __func__, sc);
>  		}
> =20
>  		BUG_ON(io_req->abts_done);
> =20
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			      "fnic_rport_reset_exch: Issuing abts\n");
> +		fnic_dbg(fnic, SCSI, "fnic_rport_reset_exch: Issuing abts\n");
> =20
>  		spin_unlock_irqrestore(io_lock, flags);
> =20
> @@ -1713,11 +1673,9 @@ void fnic_terminate_rport_io(struct fc_rport *rpor=
t)
>  		return;
>  	}
>  	fnic =3D lport_priv(lport);
> -	FNIC_SCSI_DBG(KERN_DEBUG,
> -		      fnic->lport->host, "fnic_terminate_rport_io called"
> -		      " wwpn 0x%llx, wwnn0x%llx, rport 0x%p, portid 0x%06x\n",
> -		      rport->port_name, rport->node_name, rport,
> -		      rport->port_id);
> +	fnic_dbg(fnic, SCSI, "%s: called wwpn 0x%llx, wwnn0x%llx, rport 0x%p, p=
ortid 0x%06x\n",
> +		 __func__,
> +		 rport->port_name, rport->node_name, rport, rport->port_id);
> =20
>  	if (fnic->in_remove)
>  		return;
> @@ -1749,9 +1707,8 @@ void fnic_terminate_rport_io(struct fc_rport *rport=
)
> =20
>  		if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
>  			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
> -			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			"fnic_terminate_rport_io dev rst not pending sc 0x%p\n",
> -			sc);
> +			fnic_dbg(fnic, SCSI, "%s: dev rst not pending sc 0x%p\n",
> +				 __func__, sc);
>  			spin_unlock_irqrestore(io_lock, flags);
>  			continue;
>  		}
> @@ -1770,11 +1727,9 @@ void fnic_terminate_rport_io(struct fc_rport *rpor=
t)
>  			fnic_ioreq_state_to_str(CMD_STATE(sc)));
>  		}
>  		if (!(CMD_FLAGS(sc) & FNIC_IO_ISSUED)) {
> -			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
> -				  "fnic_terminate_rport_io "
> -				  "IO not yet issued %p tag 0x%x flags "
> -				  "%x state %d\n",
> -				  sc, tag, CMD_FLAGS(sc), CMD_STATE(sc));
> +			fnic_dbg(fnic, SCSI, "%s: IO not yet issued %p tag 0x%x flags %x stat=
e %d\n",
> +				 __func__,
> +				 sc, tag, CMD_FLAGS(sc), CMD_STATE(sc));
>  		}
>  		old_ioreq_state =3D CMD_STATE(sc);
>  		CMD_STATE(sc) =3D FNIC_IOREQ_ABTS_PENDING;
> @@ -1782,15 +1737,13 @@ void fnic_terminate_rport_io(struct fc_rport *rpo=
rt)
>  		if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET) {
>  			atomic64_inc(&reset_stats->device_reset_terminates);
>  			abt_tag =3D (tag | FNIC_TAG_DEV_RST);
> -			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			"fnic_terminate_rport_io dev rst sc 0x%p\n", sc);
> +			fnic_dbg(fnic, SCSI, "%s: dev rst sc 0x%p\n",
> +				 __func__, sc);
>  		}
> =20
>  		BUG_ON(io_req->abts_done);
> =20
> -		FNIC_SCSI_DBG(KERN_DEBUG,
> -			      fnic->lport->host,
> -			      "fnic_terminate_rport_io: Issuing abts\n");
> +		fnic_dbg(fnic, SCSI, "%s: Issuing abts\n", __func__);
> =20
>  		spin_unlock_irqrestore(io_lock, flags);
> =20
> @@ -1864,10 +1817,8 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
> =20
>  	rport =3D starget_to_rport(scsi_target(sc->device));
>  	tag =3D sc->request->tag;
> -	FNIC_SCSI_DBG(KERN_DEBUG,
> -		fnic->lport->host,
> -		"Abort Cmd called FCID 0x%x, LUN 0x%llx TAG %x flags %x\n",
> -		rport->port_id, sc->device->lun, tag, CMD_FLAGS(sc));
> +	fnic_dbg(fnic, SCSI, "Abort Cmd called FCID 0x%x, LUN 0x%llx TAG %x fla=
gs %x\n",
> +		 rport->port_id, sc->device->lun, tag, CMD_FLAGS(sc));
> =20
>  	CMD_FLAGS(sc) =3D FNIC_NO_FLAGS;
> =20
> @@ -1919,8 +1870,8 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
>  	else
>  		atomic64_inc(&abts_stats->abort_issued_greater_than_60_sec);
> =20
> -	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
> -		"CBD Opcode: %02x Abort issued time: %lu msec\n", sc->cmnd[0], abt_iss=
ued_time);
> +	fnic_dbg(fnic, SCSI, "CBD Opcode: %02x Abort issued time: %lu msec\n",
> +		 sc->cmnd[0], abt_issued_time);
>  	/*
>  	 * Command is still pending, need to abort it
>  	 * If the firmware completes the command after this point,
> @@ -2009,8 +1960,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
> =20
>  	if (!(CMD_FLAGS(sc) & (FNIC_IO_ABORTED | FNIC_IO_DONE))) {
>  		spin_unlock_irqrestore(io_lock, flags);
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			"Issuing Host reset due to out of order IO\n");
> +		fnic_dbg(fnic, SCSI, "Issuing Host reset due to out of order IO\n");
> =20
>  		ret =3D FAILED;
>  		goto fnic_abort_cmd_end;
> @@ -2057,10 +2007,8 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
>  		  (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
>  		  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
> =20
> -	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -		      "Returning from abort cmd type %x %s\n", task_req,
> -		      (ret =3D=3D SUCCESS) ?
> -		      "SUCCESS" : "FAILED");
> +	fnic_dbg(fnic, SCSI, "Returning from abort cmd type %x %s\n",
> +		 task_req, (ret =3D=3D SUCCESS) ? "SUCCESS" : "FAILED");
>  	return ret;
>  }
> =20
> @@ -2090,8 +2038,7 @@ static inline int fnic_queue_dr_io_req(struct fnic =
*fnic,
>  		free_wq_copy_descs(fnic, wq);
> =20
>  	if (!vnic_wq_copy_desc_avail(wq)) {
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			  "queue_dr_io_req failure - no descriptors\n");
> +		fnic_dbg(fnic, SCSI, "queue_dr_io_req failure - no descriptors\n");
>  		atomic64_inc(&misc_stats->devrst_cpwq_alloc_failures);
>  		ret =3D -EAGAIN;
>  		goto lr_io_req_end;
> @@ -2164,9 +2111,8 @@ static int fnic_clean_pending_aborts(struct fnic *f=
nic,
>  		 * Found IO that is still pending with firmware and
>  		 * belongs to the LUN that we are resetting
>  		 */
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			      "Found IO in %s on lun\n",
> -			      fnic_ioreq_state_to_str(CMD_STATE(sc)));
> +		fnic_dbg(fnic, SCSI, "Found IO in %s on lun\n",
> +			 fnic_ioreq_state_to_str(CMD_STATE(sc)));
> =20
>  		if (CMD_STATE(sc) =3D=3D FNIC_IOREQ_ABTS_PENDING) {
>  			spin_unlock_irqrestore(io_lock, flags);
> @@ -2174,9 +2120,8 @@ static int fnic_clean_pending_aborts(struct fnic *f=
nic,
>  		}
>  		if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
>  			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
> -			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
> -				"%s dev rst not pending sc 0x%p\n", __func__,
> -				sc);
> +			fnic_dbg(fnic, SCSI, "%s: dev rst not pending sc 0x%p\n",
> +				 __func__, sc);
>  			spin_unlock_irqrestore(io_lock, flags);
>  			continue;
>  		}
> @@ -2200,8 +2145,8 @@ static int fnic_clean_pending_aborts(struct fnic *f=
nic,
>  		abt_tag =3D tag;
>  		if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET) {
>  			abt_tag |=3D FNIC_TAG_DEV_RST;
> -			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
> -				  "%s: dev rst sc 0x%p\n", __func__, sc);
> +			fnic_dbg(fnic, SCSI, "%s: dev rst sc 0x%p\n",
> +				 __func__, sc);
>  		}
> =20
>  		CMD_ABTS_STATUS(sc) =3D FCPIO_INVALID_CODE;
> @@ -2356,9 +2301,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  	atomic64_inc(&reset_stats->device_resets);
> =20
>  	rport =3D starget_to_rport(scsi_target(sc->device));
> -	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -		      "Device reset called FCID 0x%x, LUN 0x%llx sc 0x%p\n",
> -		      rport->port_id, sc->device->lun, sc);
> +	fnic_dbg(fnic, SCSI, "Device reset called FCID 0x%x, LUN 0x%llx sc 0x%p=
\n",
> +		 rport->port_id, sc->device->lun, sc);
> =20
>  	if (lp->state !=3D LPORT_ST_READY || !(lp->link_up))
>  		goto fnic_device_reset_end;
> @@ -2407,7 +2351,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  	CMD_LR_STATUS(sc) =3D FCPIO_INVALID_CODE;
>  	spin_unlock_irqrestore(io_lock, flags);
> =20
> -	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, "TAG %x\n", tag);
> +	fnic_dbg(fnic, SCSI, "TAG %x\n", tag);
> =20
>  	/*
>  	 * issue the device reset, if enqueue failed, clean up the ioreq
> @@ -2435,8 +2379,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  	io_req =3D (struct fnic_io_req *)CMD_SP(sc);
>  	if (!io_req) {
>  		spin_unlock_irqrestore(io_lock, flags);
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -				"io_req is null tag 0x%x sc 0x%p\n", tag, sc);
> +		fnic_dbg(fnic, SCSI, "io_req is null tag 0x%x sc 0x%p\n",
> +			 tag, sc);
>  		goto fnic_device_reset_end;
>  	}
>  	io_req->dr_done =3D NULL;
> @@ -2449,8 +2393,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  	 */
>  	if (status =3D=3D FCPIO_INVALID_CODE) {
>  		atomic64_inc(&reset_stats->device_reset_timeouts);
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			      "Device reset timed out\n");
> +		fnic_dbg(fnic, SCSI, "Device reset timed out\n");
>  		CMD_FLAGS(sc) |=3D FNIC_DEV_RST_TIMED_OUT;
>  		spin_unlock_irqrestore(io_lock, flags);
>  		int_to_scsilun(sc->device->lun, &fc_lun);
> @@ -2477,9 +2420,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  				CMD_STATE(sc) =3D FNIC_IOREQ_ABTS_PENDING;
>  				io_req->abts_done =3D &tm_done;
>  				spin_unlock_irqrestore(io_lock, flags);
> -				FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -				"Abort and terminate issued on Device reset "
> -				"tag 0x%x sc 0x%p\n", tag, sc);
> +				fnic_dbg(fnic, SCSI, "Abort and terminate issued on Device reset tag=
 0x%x sc 0x%p\n",
> +					 tag, sc);
>  				break;
>  			}
>  		}
> @@ -2503,9 +2445,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  	/* Completed, but not successful, clean up the io_req, return fail */
>  	if (status !=3D FCPIO_SUCCESS) {
>  		spin_lock_irqsave(io_lock, flags);
> -		FNIC_SCSI_DBG(KERN_DEBUG,
> -			      fnic->lport->host,
> -			      "Device reset completed - failed\n");
> +		fnic_dbg(fnic, SCSI, "Device reset completed - failed\n");
>  		io_req =3D (struct fnic_io_req *)CMD_SP(sc);
>  		goto fnic_device_reset_clean;
>  	}
> @@ -2520,9 +2460,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  	if (fnic_clean_pending_aborts(fnic, sc, new_sc)) {
>  		spin_lock_irqsave(io_lock, flags);
>  		io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			      "Device reset failed"
> -			      " since could not abort all IOs\n");
> +		fnic_dbg(fnic, SCSI, "Device reset failed since could not abort all IO=
s\n");
>  		goto fnic_device_reset_clean;
>  	}
> =20
> @@ -2558,10 +2496,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  	if (unlikely(tag_gen_flag))
>  		fnic_scsi_host_end_tag(fnic, sc);
> =20
> -	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -		      "Returning from device reset %s\n",
> -		      (ret =3D=3D SUCCESS) ?
> -		      "SUCCESS" : "FAILED");
> +	fnic_dbg(fnic, SCSI, "Returning from device reset %s\n",
> +		 (ret =3D=3D SUCCESS) ? "SUCCESS" : "FAILED");
> =20
>  	if (ret =3D=3D FAILED)
>  		atomic64_inc(&reset_stats->device_reset_failures);
> @@ -2581,8 +2517,7 @@ int fnic_reset(struct Scsi_Host *shost)
>  	fnic =3D lport_priv(lp);
>  	reset_stats =3D &fnic->fnic_stats.reset_stats;
> =20
> -	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -		      "fnic_reset called\n");
> +	fnic_dbg(fnic, SCSI, "%s: called\n", __func__);
> =20
>  	atomic64_inc(&reset_stats->fnic_resets);
> =20
> @@ -2592,10 +2527,8 @@ int fnic_reset(struct Scsi_Host *shost)
>  	 */
>  	ret =3D fc_lport_reset(lp);
> =20
> -	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -		      "Returning from fnic reset %s\n",
> -		      (ret =3D=3D 0) ?
> -		      "SUCCESS" : "FAILED");
> +	fnic_dbg(fnic, SCSI, "Returning from fnic reset %s\n",
> +		 (ret =3D=3D 0) ? "SUCCESS" : "FAILED");
> =20
>  	if (ret =3D=3D 0)
>  		atomic64_inc(&reset_stats->fnic_reset_completions);
> @@ -2628,8 +2561,7 @@ int fnic_host_reset(struct scsi_cmnd *sc)
>  		fnic->internal_reset_inprogress =3D true;
>  	} else {
>  		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> -		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -			"host reset in progress skipping another host reset\n");
> +		fnic_dbg(fnic, SCSI, "host reset in progress skipping another host res=
et\n");
>  		return SUCCESS;
>  	}
>  	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> @@ -2703,10 +2635,9 @@ void fnic_scsi_abort_io(struct fc_lport *lp)
> =20
>  	spin_lock_irqsave(&fnic->fnic_lock, flags);
>  	fnic->remove_wait =3D NULL;
> -	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -		      "fnic_scsi_abort_io %s\n",
> -		      (fnic->state =3D=3D FNIC_IN_ETH_MODE) ?
> -		      "SUCCESS" : "FAILED");
> +	fnic_dbg(fnic, SCSI, "%s: %s\n",
> +		 __func__,
> +		 (fnic->state =3D=3D FNIC_IN_ETH_MODE) ? "SUCCESS" : "FAILED");
>  	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> =20
>  }
> @@ -2819,9 +2750,8 @@ int fnic_is_abts_pending(struct fnic *fnic, struct =
scsi_cmnd *lr_sc)
>  		 * Found IO that is still pending with firmware and
>  		 * belongs to the LUN that we are resetting
>  		 */
> -		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
> -			      "Found IO in %s on lun\n",
> -			      fnic_ioreq_state_to_str(CMD_STATE(sc)));
> +		fnic_dbg(fnic, SCSI, "Found IO in %s on lun\n",
> +			 fnic_ioreq_state_to_str(CMD_STATE(sc)));
> =20
>  		if (CMD_STATE(sc) =3D=3D FNIC_IOREQ_ABTS_PENDING)
>  			ret =3D 1;
>=20

No more responses on this?

Can we either mege my fix (planning to redesign later), or follow
through on your suggested fix?

I believe my fix has a review already.

Thanks.
--=20
Lee Duncan

