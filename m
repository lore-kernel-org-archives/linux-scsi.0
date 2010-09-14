From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] SCSI: fix qla4xxx build on PPC
Date: Tue, 14 Sep 2010 14:14:38 +0200
Message-ID: <4C8F672E.6050504@suse.cz>
References: <1284466375-9501-1-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63925 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab0INMOr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2010 08:14:47 -0400
In-Reply-To: <1284466375-9501-1-git-send-email-jslaby@suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Cc: James.Bottomley@suse.de, iscsi-driver@qlogic.com, linux-scsi@vger.kernel.org, jirislaby@gmail.com, linux-kernel@vger.kernel.org, Ravi Anand <ravi.anand@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

On 09/14/2010 02:12 PM, Jiri Slaby wrote:
> We use read/write[bslq] but do not include linux/io.h. This causes
> build failures on PPC. Include that file.

Just in case you want to include the failure:
drivers/scsi/qla4xxx/ql4_nx.c: In function 'qla4_8xxx_pci_mem_read_direct':
drivers/scsi/qla4xxx/ql4_nx.c:716:3: error: implicit declaration of
function 'readq'
drivers/scsi/qla4xxx/ql4_nx.c: In function 'qla4_8xxx_pci_mem_write_direct':
drivers/scsi/qla4xxx/ql4_nx.c:787:3: error: implicit declaration of
function 'writeq'

> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Ravi Anand <ravi.anand@qlogic.com>
> Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> ---
>  drivers/scsi/qla4xxx/ql4_nx.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
> index 5d4a382..449256f 100644
> --- a/drivers/scsi/qla4xxx/ql4_nx.c
> +++ b/drivers/scsi/qla4xxx/ql4_nx.c
> @@ -5,6 +5,7 @@
>   * See LICENSE.qla4xxx for copyright and licensing details.
>   */
>  #include <linux/delay.h>
> +#include <linux/io.h>
>  #include <linux/pci.h>
>  #include "ql4_def.h"
>  #include "ql4_glbl.h"

thanks,
-- 
js
suse labs
