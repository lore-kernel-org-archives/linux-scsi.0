From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2] scsi: wd7000: print sector number as 64-bit
Date: Tue, 21 Jun 2016 02:14:58 -0700
Message-ID: <1466500498.26558.12.camel@perches.com>
References: <20160621090249.774301-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay0134.hostedemail.com ([216.40.44.134]:37754 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751604AbcFUJPC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2016 05:15:02 -0400
In-Reply-To: <20160621090249.774301-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2016-06-21 at 11:02 +0200, Arnd Bergmann wrote:
> Enabling format checking in dprintk() shows that wd7000_biosparam
> uses an incorrect format string for sector_t:

trivia:

> diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
[]
> @@ -192,7 +192,7 @@
> =A0#ifdef WD7000_DEBUG
> =A0#define dprintk printk
> =A0#else
> -#define dprintk(format,args...)
> +#define dprintk	no_printk
> =A0#endif

It'd be nicer if both defines were the same form

#ifdef WD7000_DEBUG
#define dprintk		printk
#else
#define dprintk		no_printk
#endif


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
