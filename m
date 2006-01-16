From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] sym53c8xx_2: fix compilation on alpha
Date: Sun, 15 Jan 2006 18:27:20 -0600
Message-ID: <1137371240.3511.17.camel@mulgrave>
References: <20060116000035.GA3794@mipter.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:18373 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932141AbWAPA1b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Jan 2006 19:27:31 -0500
In-Reply-To: <20060116000035.GA3794@mipter.zuzino.mipt.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@trained-monkey.org>, Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-scsi@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>

On Mon, 2006-01-16 at 03:00 +0300, Alexey Dobriyan wrote:
>   CC [M]  drivers/scsi/sym53c8xx_2/sym_fw.o
> In file included from drivers/scsi/sym53c8xx_2/sym_glue.h:59,
>                  from drivers/scsi/sym53c8xx_2/sym_fw.c:40:
> include/scsi/scsi_transport_spi.h:57: error: field `dv_mutex' has incomplete type
> --- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
> +++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
> @@ -39,6 +39,7 @@
>   */
>  
>  #include <linux/slab.h>
> +#include <linux/mutex.h>

Actually, this isn't the right fix.  The problem lies in the conversion
of the transport class from semaphore to mutex, so the include belongs
in scsi_transport_spi.h

In theory, it could be a simple 'struct mutex' declaration, since no
driver ever uses it, but I'm afraid gcc might not be happy dereferencing
members of a structure containing a type of unknown size (even if it is
at the end).

James

diff --git a/include/scsi/scsi_transport_spi.h b/include/scsi/scsi_transport_spi.h
--- a/include/scsi/scsi_transport_spi.h
+++ b/include/scsi/scsi_transport_spi.h
@@ -21,6 +21,7 @@
 #define SCSI_TRANSPORT_SPI_H
 
 #include <linux/config.h>
+#include <linux/mutex.h>
 #include <linux/transport_class.h>
 
 struct scsi_transport_template;


