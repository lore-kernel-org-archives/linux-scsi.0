From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 0/2] aic94xx: Supermicro motherboards support
Date: Sat, 14 Oct 2006 18:21:46 -0700 (PDT)
Message-ID: <20061015012146.62933.qmail@web31809.mail.mud.yahoo.com>
References: <20061015023100.390ee1b7@manowar.localnet>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31809.mail.mud.yahoo.com ([68.142.207.72]:56179 "HELO
	web31809.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1752320AbWJOBVr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Oct 2006 21:21:47 -0400
In-Reply-To: <20061015023100.390ee1b7@manowar.localnet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergey Kononenko <sergk@sergk.org.ua>, linux-scsi@vger.kernel.org

--- Sergey Kononenko <sergk@sergk.org.ua> wrote:
> Hello,
> 
> The aic94xx driver in current mainline kernel don't work with
> controllers integrated in some of Supermicro motherboards (i have
> tested only on X6DHR-3G2) due to two reasons:
> - driver do not contain corresponding PCI id (9005:041F)
> - driver can not find flash on controller.
> 
> Patches which i send now ordered to resolve this problems.
> 
> First one is a simple and just add pci id, but second one is a bit
> controversial.
> 
> The following code from function asd_flash_getid (aic94xx_sds.c)
> 
> 	reg = asd_read_reg_dword(asd_ha, EXSICNFGR);
> 
>         if (!(reg & FLASHEX)) {
>                 ASD_DPRINTK("flash doesn't exist\n");
>                 return -ENOENT;
>         }
> 
> failed with error on controllers in supermicro motherboards.
> Looks like flag FLASHEX did not set on such devices, however flash chip
> present and without above if statement in code drivers works normally
> on supermicro controllers.
> 
> As i found this code was commented out in original driver by Luben
> Tuikov with following comment:
> 
> /*     Early (current?) SuperMicro mainboards, X6DHR-3G2 and X6DH3-G2
>        have a bug whereby RS104 is missing (not installed) and RS103
>        is installed, causing FLASHEX to be 0. */
> /*     if (!(reg & FLASHEX)) { */
> /*             ASD_DPRINTK("flash doesn't exist\n"); */
> /*             return -ENOENT; */
> /*     } */
> 
> May be it is possible to write separate code for checking
> availability of flash chip especially for supermicro
> motherboards, but i don't know hot it possible and don't know what is
> RS104, RS103 and difference between it.

RSxyz stands for "resistor xyz" in the schematic diagrams.
This is a hardware bug in the (early?) SuperMicro mainboards.
It dates from last year, 20 October 2005.

This is the commit from my git tree:

commit 433484ee805a953793cc33efa890cb24ef4afe1a
Author: Luben Tuikov <luben_tuikov@adaptec.com>
Date:   Thu Oct 20 18:11:30 2005 -0400

    Fix around buggy mainboards reporting Flash memory present
    Early (current?) SuperMicro mainboards, X6DHR-3G2 and X6DH3-G2
    have a bug whereby RS104 is missing (not installed) and RS103
    is installed, causing FLASHEX to be 0.
    
    Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

> But more likely that check of FLASHEX can be removed safely from code

Yes, you can remove it safely.

    Luben


> because below there is another more generic check for flash chip via
> pci config probe.
> 
> This solution works perfect in my case, also it was in original code,
> however i think this second patch would be tested on some other
> varieties of aic94xx hardware.
> 
> --
> Sergey Kononenko
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

