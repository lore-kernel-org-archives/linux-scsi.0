From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: shouldn't "irq" be module_param_array instead of module_param
 in scsi/gdth.c ?
Date: Sun, 30 Jan 2005 08:48:45 -0800
Message-ID: <41FD0FED.9000806@osdl.org>
References: <Pine.LNX.4.62.0501301653480.2731@dragon.hygekrogen.localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:24005 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261734AbVA3Q5Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Jan 2005 11:57:25 -0500
In-Reply-To: <Pine.LNX.4.62.0501301653480.2731@dragon.hygekrogen.localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <juhl-lkml@dif.dk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Achim Leubner <achim_leubner@adaptec.com>, Boji Tony Kannanthanam <boji.t.kannanthanam@intel.com>, Johannes Dinner <johannes_dinner@adaptec.com>, linux-scsi@vger.kernel.org

Jesper Juhl wrote:
> This little warning made me take a closer look : 
> drivers/scsi/gdth.c:645: warning: return from incompatible pointer type
> 
> And line 645 looks like this :
> 
> module_param(irq, int, 0);
> 
> looking a bit up in the file I find :
> 
> /* IRQ list for GDT3000/3020 EISA controllers */
> static int irq[MAXHA] __initdata =
> {0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
>  0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
> 
> That certainly looks like an array to me, so I'm wondering if something 
> like this patch would be correct?  I'm not familliar enough with 
> module_param* to be completely confident, but this silences the warning.
> 
> Signed-off-by: Jesper Juhl <juhl-lkml@dif.dk>
> 
> --- linux-2.6.11-rc2-bk7-orig/drivers/scsi/gdth.c	2005-01-22 21:59:46.000000000 +0100
> +++ linux-2.6.11-rc2-bk7/drivers/scsi/gdth.c	2005-01-30 16:52:45.000000000 +0100
> @@ -642,7 +642,7 @@ static int probe_eisa_isa = 0;
>  static int force_dma32 = 0;
>  
>  /* parameters for modprobe/insmod */
> -module_param(irq, int, 0);
> +module_param_array(irq, int, NULL, 0);
>  module_param(disable, int, 0);
>  module_param(reserve_mode, int, 0);
>  module_param_array(reserve_list, int, NULL, 0);

Yep, same as:
http://marc.theaimsgroup.com/?l=linux-scsi&m=110540330511653&w=2

-- 
~Randy
