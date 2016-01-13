From: Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: klist: fix starting point removed bug in klist iterators
Date: Wed, 13 Jan 2016 09:11:54 -0800
Message-ID: <20160113171154.GA29535@kroah.com>
References: <1452701431.2363.12.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452701431.2363.12.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Ewan D. Milne" <emilne@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 13, 2016 at 08:10:31AM -0800, James Bottomley wrote:
> The starting node for a klist iteration is often passed in from
> somewhere way above the klist infrastructure, meaning there's no
> guarantee the node is still on the list.  We've seen this in SCSI where
> we use bus_find_device() to iterate through a list of devices.  In the
> face of heavy hotplug activity, the last device returned by
> bus_find_device() can be removed before the next call.  This leads to
> 
> Dec  3 13:22:02 localhost kernel: WARNING: CPU: 2 PID: 28073 at include/linux/kref.h:47 klist_iter_init_node+0x3d/0x50()
> Dec  3 13:22:02 localhost kernel: Modules linked in: scsi_debug x86_pkg_temp_thermal kvm_intel kvm irqbypass crc32c_intel joydev iTCO_wdt dcdbas ipmi_devintf acpi_power_meter iTCO_vendor_support ipmi_si imsghandler pcspkr wmi acpi_cpufreq tpm_tis tpm shpchp lpc_ich mfd_core nfsd nfs_acl lockd grace sunrpc tg3 ptp pps_core
> Dec  3 13:22:02 localhost kernel: CPU: 2 PID: 28073 Comm: cat Not tainted 4.4.0-rc1+ #2
> Dec  3 13:22:02 localhost kernel: Hardware name: Dell Inc. PowerEdge R320/08VT7V, BIOS 2.0.22 11/19/2013
> Dec  3 13:22:02 localhost kernel: ffffffff81a20e77 ffff880613acfd18 ffffffff81321eef 0000000000000000
> Dec  3 13:22:02 localhost kernel: ffff880613acfd50 ffffffff8107ca52 ffff88061176b198 0000000000000000
> Dec  3 13:22:02 localhost kernel: ffffffff814542b0 ffff880610cfb100 ffff88061176b198 ffff880613acfd60
> Dec  3 13:22:02 localhost kernel: Call Trace:
> Dec  3 13:22:02 localhost kernel: [<ffffffff81321eef>] dump_stack+0x44/0x55
> Dec  3 13:22:02 localhost kernel: [<ffffffff8107ca52>] warn_slowpath_common+0x82/0xc0
> Dec  3 13:22:02 localhost kernel: [<ffffffff814542b0>] ? proc_scsi_show+0x20/0x20
> Dec  3 13:22:02 localhost kernel: [<ffffffff8107cb4a>] warn_slowpath_null+0x1a/0x20
> Dec  3 13:22:02 localhost kernel: [<ffffffff8167225d>] klist_iter_init_node+0x3d/0x50
> Dec  3 13:22:02 localhost kernel: [<ffffffff81421d41>] bus_find_device+0x51/0xb0
> Dec  3 13:22:02 localhost kernel: [<ffffffff814545ad>] scsi_seq_next+0x2d/0x40
> [...]
> 
> And an eventual crash. It can actually occur in any hotplug system
> which has a device finder and a starting device.
> 
> We can fix this globally by making sure the starting node for
> klist_iter_init_node() is actually a member of the list before using it
> (and by starting from the beginning if it isn't).
> 
> Reported-by: Ewan D. Milne <emilne@redhat.com>
> Tested-by: Ewan D. Milne <emilne@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> ---
> 
> diff --git a/lib/klist.c b/lib/klist.c
> index d74cf7a..0507fa5 100644
> --- a/lib/klist.c
> +++ b/lib/klist.c
> @@ -282,9 +282,9 @@ void klist_iter_init_node(struct klist *k, struct klist_iter *i,
>  			  struct klist_node *n)
>  {
>  	i->i_klist = k;
> -	i->i_cur = n;
> -	if (n)
> -		kref_get(&n->n_ref);
> +	i->i_cur = NULL;
> +	if (n && kref_get_unless_zero(&n->n_ref))
> +		i->i_cur = n;
>  }
>  EXPORT_SYMBOL_GPL(klist_iter_init_node);

Thanks for this, looks good, I'll queue it up after 4.5-rc1 is out.

greg k-h
