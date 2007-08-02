From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix two potential mem leaks in MPT Fusion
 (mpt_attach())
Date: Wed, 1 Aug 2007 17:26:53 -0700
Message-ID: <20070801172653.1fd44e99.akpm@linux-foundation.org>
References: <200708020155.33690.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44210 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753068AbXHBA1E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 20:27:04 -0400
In-Reply-To: <200708020155.33690.jesper.juhl@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Eric Moore <Eric.Moore@lsi.com>, DL-MPTFusionLinux@lsi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, support@lsi.com, mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Thu, 2 Aug 2007 01:55:33 +0200
Jesper Juhl <jesper.juhl@gmail.com> wrote:

> Greetings & Salutations,
> 
> The Coverity checker spotted two potential memory leaks in 
> drivers/message/fusion/mptbase.c::mpt_attach().
> 
> There are two returns that may leak the storage allocated for 
> 'ioc' (sizeof(MPT_ADAPTER) bytes).
> A simple fix would be to simply add two kfree() calls before 
> the return statements, but a better fix (that this patch 
> implements) is to reorder the code so that if we hit the first 
> return condition we don't have to do the allocation at all and 
> then just add a kfree() call for the second case.
> 
> Please consider applying.  Patch has been compile tested only.
> 
> 

umm,

> ---
> 
>  drivers/message/fusion/mptbase.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index e866dac..f9bb705 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -1393,18 +1393,18 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
>  	struct proc_dir_entry *dent, *ent;
>  #endif
>  
> +	if (mpt_debug_level)
> +		printk(KERN_INFO MYNAM ": mpt_debug_level=%xh\n", mpt_debug_level);
> +
> +	if (pci_enable_device(pdev))
> +		return r;
> +
>  	ioc = kzalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);

Why on earth is that using GFP_ATOMIC?  This function later goes on to
create procfs files and such things.




y'know, we could have a debug option which will spit warnings if someone
does a !__GFP_WAIT allocation while !in_atomic() (only works if
CONFIG_PREEMPT).  

But please, make it depend on !CONFIG_AKPM.  I shudder to think about all
the stuff it would pick up.


