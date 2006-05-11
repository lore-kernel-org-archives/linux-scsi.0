From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH -mm] BusLogic gcc 4.1 warning fixes
Date: Thu, 11 May 2006 10:12:31 -0700
Message-ID: <20060511101231.1ef72659.akpm@osdl.org>
References: <200605101728.k4AHSTIM004411@dwalker1.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030376AbWEKRP0@vger.kernel.org>
In-Reply-To: <200605101728.k4AHSTIM004411@dwalker1.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Daniel Walker <dwalker@mvista.com> wrote:
>
> This at least makes the used away of the failure .
> ---
> 
> 
> I just commented out BusLogic_AbortCommand because the code that uses it is 
> commented out the same way .. It could just be removed .
> 
> Fixes the following warnings,
> 
> drivers/scsi/BusLogic.c: In function 'BusLogic_init':
> drivers/scsi/BusLogic.c:2302: warning: ignoring return value of 'scsi_add_host', declared with attribute warn_unused_result
> drivers/scsi/BusLogic.c: At top level:
> drivers/scsi/BusLogic.c:2963: warning: 'BusLogic_AbortCommand' defined but not used
> 
> Signed-Off-By: Daniel Walker <dwalker@mvista.com>
> 
> Index: linux-2.6.16/drivers/scsi/BusLogic.c
> ===================================================================
> --- linux-2.6.16.orig/drivers/scsi/BusLogic.c
> +++ linux-2.6.16/drivers/scsi/BusLogic.c
> @@ -2299,7 +2299,8 @@ static int __init BusLogic_init(void)
>  				scsi_host_put(Host);
>  			} else {
>  				BusLogic_InitializeHostStructure(HostAdapter, Host);
> -				scsi_add_host(Host, HostAdapter->PCI_Device ? &HostAdapter->PCI_Device->dev : NULL);
> +				if (scsi_add_host(Host, HostAdapter->PCI_Device ? &HostAdapter->PCI_Device->dev : NULL))
> +					printk(KERN_WARNING "BusLogic: scsi_add_host() failed!\n");
>  				scsi_scan_host(Host);
>  				BusLogicHostAdapterCount++;
>  			}
> @@ -2955,6 +2956,7 @@ static int BusLogic_QueueCommand(struct 
>  }

Methinks that if scsi_add_host() fails we'll need to do more serious things
here - we cannot just go ahead and pretend that it worked.

So it's best to leave the warning there for now.

The appropriate recovery code is just a few lines up from here - reusing
that might be appropriate.  And while you're there, this function should
return -Esomething if it failed, rather than pretending to work.
