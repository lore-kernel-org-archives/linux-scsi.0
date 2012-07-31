From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: spin_unlock_irq in interrupt handler fix
Date: Tue, 31 Jul 2012 10:21:44 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1207311006171.27888@axis700.grange>
References: <1342853283-32549-1-git-send-email-yefremov.denis@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1342853283-32549-1-git-send-email-yefremov.denis@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Denis Efremov <yefremov.denis@gmail.com>
Cc: Kurt Garloff <garloff@suse.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Wow, been ages since the last patch to this driver has hit my mail:-)

On Sat, 21 Jul 2012, Denis Efremov wrote:

> The replacement of spin_lock_irq/spin_unlock_irq pair in interrupt
> handler by spin_lock_irqsave/spin_lock_irqrestore pair.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>

Right, unconditionally enabling local IRQs in an ISR seems rude. BUT: 
unfortunately, it's not as easy as this. From DC390_Interrupt() 
dc390_DataOut_0() and dc390_DataIn_0() can be called, which also use 
spin_lock_irq() / spin_unlock_irq()... So, maybe adding a flags field to 
struct dc390_acb and using it on all 3 occasions would be the easiest and 
safest fix...

Thanks
Guennadi

> ---
>  drivers/scsi/tmscsim.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
> index a1baccc..0b9d68a 100644
> --- a/drivers/scsi/tmscsim.c
> +++ b/drivers/scsi/tmscsim.c
> @@ -654,6 +654,7 @@ DC390_Interrupt(void *dev_id)
>      u8  phase;
>      void   (*stateV)( struct dc390_acb*, struct dc390_srb*, u8 *);
>      u8  istate, istatus;
> +    unsigned long flags;
>  
>      sstatus = DC390_read8 (Scsi_Status);
>      if( !(sstatus & INTERRUPT) )
> @@ -665,7 +666,7 @@ DC390_Interrupt(void *dev_id)
>      //dstatus = DC390_read8 (DMA_Status);
>      //DC390_write32 (DMA_ScsiBusCtrl, EN_INT_ON_PCI_ABORT);
>  
> -    spin_lock_irq(pACB->pScsiHost->host_lock);
> +    spin_lock_irqsave(pACB->pScsiHost->host_lock, flags);
>  
>      istate = DC390_read8 (Intern_State);
>      istatus = DC390_read8 (INT_Status); /* This clears Scsi_Status, Intern_State and INT_Status ! */
> @@ -736,7 +737,7 @@ DC390_Interrupt(void *dev_id)
>      }
>  
>   unlock:
> -    spin_unlock_irq(pACB->pScsiHost->host_lock);
> +    spin_unlock_irqrestore(pACB->pScsiHost->host_lock, flags);
>      return IRQ_HANDLED;
>  }
>  
> -- 
> 1.7.7
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
