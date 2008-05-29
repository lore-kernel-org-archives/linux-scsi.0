From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scsi: remove CDROM not ready printk
Date: Thu, 29 May 2008 00:41:54 -0700
Message-ID: <20080529004154.bbc7b1d4.akpm@linux-foundation.org>
References: <alpine.LFD.1.10.0805271502370.3985@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179AbYE2HmX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 May 2008 03:42:23 -0400
In-Reply-To: <alpine.LFD.1.10.0805271502370.3985@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jerry Stralko <gerb.stralko@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 27 May 2008 15:02:43 -0400 (EDT) Jerry Stralko <gerb.stralko@gmail.com> wrote:

> Hello,

let's cc a scsi list which exists ;)

>    This printk was spamming my dmesg and /var/log/message.  Is there a 
> reason we have this printk?  Can we simply remove it?
> 
> 
> Signed-off-by: Jerry Stralko <gerb.stralko@gmail.com>
> ---
> 
> 
> diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
> index ae87d08..c37fb1c 100644
> --- a/drivers/scsi/sr_ioctl.c
> +++ b/drivers/scsi/sr_ioctl.c
> @@ -238,8 +238,6 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
>   					break;
>   				}
>   			}
> -			if (!cgc->quiet)
> -				printk(KERN_INFO "%s: CDROM not ready.  Make sure there is a disc in the drive.\n", cd->cdi.name);
>   #ifdef DEBUG
>   			scsi_print_sense_hdr("sr", &sshdr);
>   #endif

The answer may be that you need to enable cgc->quiet.  If that is
user-enableable - I can't work out how from a quick grep.

