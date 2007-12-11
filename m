From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [2.6 patch] drivers/scsi/advansys.c section fix
Date: Tue, 11 Dec 2007 14:35:27 -0800
Message-ID: <20071211143527.a259a0ad.randy.dunlap@oracle.com>
References: <20071211222353.GZ14204@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:61522 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbXLKWhm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Dec 2007 17:37:42 -0500
In-Reply-To: <20071211222353.GZ14204@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: matthew@wil.cx, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 23:23:53 +0100 Adrian Bunk wrote:

> This patch fixes the following section mismatch with CONFIG_HOTPLUG=n:
> 
> <--  snip  -->
> 
> ...
> WARNING: vmlinux.o(.exit.text+0xcf8a): Section mismatch: reference to .init.data:_asc_def_iop_base (between 'advansys_isa_remove' and 'exit_this_scsi_driver')
> ...
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> e81cac11f9efe882a89708c298fa6268375b0221 
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 9dd3952..38a1ee2 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -13906,7 +13906,7 @@ static int advansys_release(struct Scsi_Host *shost)
>  
>  #define ASC_IOADR_TABLE_MAX_IX  11
>  
> -static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] __devinitdata = {
> +static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] = {
>  	0x100, 0x0110, 0x120, 0x0130, 0x140, 0x0150, 0x0190,
>  	0x0210, 0x0230, 0x0250, 0x0330
>  };
> 
> -

http://marc.info/?l=linux-scsi&m=119368247502255

Acked-by me.


---
~Randy
Features and documentation: http://lwn.net/Articles/260136/
