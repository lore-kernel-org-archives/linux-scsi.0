From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/2] scsi: nsp32: add __printf attribute to logging
 functions
Date: Sat, 20 May 2017 04:35:36 -0700
Message-ID: <1495280136.27714.6.camel@perches.com>
References: <20170520111628.24787-1-nicolas.iooss_linux@m4x.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay0088.hostedemail.com ([216.40.44.88]:56528 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750831AbdETLfm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 20 May 2017 07:35:42 -0400
In-Reply-To: <20170520111628.24787-1-nicolas.iooss_linux@m4x.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>, GOTO Masanori <gotom@debian.or.jp>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, 2017-05-20 at 13:16 +0200, Nicolas Iooss wrote:
> nsp32_message() and nsp32_dmessage() use printf format strings in order
> to format a message. Adding __printf attributes helps to detect errors
> in such format strings at build time, like:
> 
>     drivers/scsi/nsp32.c:3314:23: error: format '%ld' expects argument
>     of type 'long int', but argument 6 has type 'pm_message_t {aka
>     struct pm_message}' [-Werror=format=]
>       nsp32_msg(KERN_INFO,
>       "pci-suspend: pdev=0x%p, state=%ld, slot=%s, host=0x%p",
>       pdev, state, pci_name(pdev), host);
> 
> Fix all format string errors which were reported by gcc.
[]
> diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
[]
> @@ -321,7 +323,8 @@ static struct scsi_host_template nsp32_template = {
>  
>  #define NSP32_DEBUG_BUF_LEN		100
>  
> -static void nsp32_message(const char *func, int line, char *type, char *fmt, ...)
> +static __printf(4, 5)
> +void nsp32_message(const char *func, int line, char *type, const char *fmt, ...)
>  {
>  	va_list args;
>  	char buf[NSP32_DEBUG_BUF_LEN];

These could also use vsprintf extension %pV instead of
vsnprintf to a
temporary buffer and then using "%s, <tmp>"

etc...

Does anyone actually have or use these cards any longer?
