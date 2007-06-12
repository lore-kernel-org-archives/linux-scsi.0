From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH]is_power_of_2-scsi/NCR53C9x.c
Date: Tue, 12 Jun 2007 05:50:00 -0600
Message-ID: <20070612114959.GD11591@parisc-linux.org>
References: <1181625877.11780.24.camel@merlin.linuxcoe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60140 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbXFLLuB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jun 2007 07:50:01 -0400
Content-Disposition: inline
In-Reply-To: <1181625877.11780.24.camel@merlin.linuxcoe.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vignesh babu <vignesh.babu@wipro.com>
Cc: linux-scsi@vger.kernel.org, Kernel Janitors List <kernel-janitors@lists.osdl.org>

On Tue, Jun 12, 2007 at 10:54:36AM +0530, vignesh babu wrote:
> @@ -1651,7 +1652,7 @@ static inline int reconnect_target(struct NCR_ESP *esp, struct ESP_regs *eregs)
>  	if(!(it & me))
>  		return -1;
>  	it &= ~me;
> -	if(it & (it - 1))
> +	if(!is_power_of_2(it))
>  		return -1;
>  	while(!(it & 1))
>  		targ++, it >>= 1;

I think you actually want to do:

-	if(!(it & me))
-		return -1;
 	it &= ~me;
-	if(it & (it - 1))
+	if (!is_power_of_2(it))
 		return -1;

as it looks to me like the first test is checking for the n != 0 case in
is_power_of_two().

Not that it'll matter much -- AIUI, this driver is scheduled for
deletion soon.
