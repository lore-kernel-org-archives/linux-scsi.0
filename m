From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 04/14] qla2xxx: Use IOCB interface to submit
 non-critical MBX.
Date: Wed, 8 Feb 2017 18:48:02 +0000
Message-ID: <1486579669.16026.14.camel@sandisk.com>
References: <1486161655-2307-1-git-send-email-himanshu.madhani@cavium.com>
         <1486161655-2307-5-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:8697 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751584AbdBHTO4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 14:14:56 -0500
In-Reply-To: <1486161655-2307-5-git-send-email-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <EB75C37A1977B147B1092ED50C161B2B@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>

On Fri, 2017-02-03 at 14:40 -0800, Himanshu Madhani wrote:
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index db6bd92..4225256 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -10,6 +10,29 @@
>  #include <linux/delay.h>
>  #include <linux/gfp.h>
>  
> +static struct mb_cmd_name {
> +	uint16_t cmd;
> +	char *str;
> +} mb_str[] = {
> +	{0xffff,		"unknown"},
> +	{MBC_GET_PORT_DATABASE,	"GPDB"},
> +	{MBC_GET_ID_LIST,	"GIDList"},
> +	{MBC_GET_LINK_PRIV_STATS, "Stats"},
> +};
> +
> +static char *mb_to_str(uint16_t cmd)
> +{
> +	int i;
> +	struct mb_cmd_name *e;
> +
> +	for (i = 0; i < ARRAY_SIZE(mb_str); i++) {
> +		e = mb_str + i;
> +		if (cmd == e->cmd)
> +			return e->str;
> +	}
> +	return mb_str[0].str; /* unknown */
> +}

Please use const char * instead of char * in the struct definition and for
the mb_to_str() function return type. Please also leave out the element with
index 0xffff from the mb_str[] array and make mb_to_str() return "unknown"
instead of mb_str[0].str if lookup fails.

Bart.
