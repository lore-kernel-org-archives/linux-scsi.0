From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] isci: correct erroneous for_each_isci_host macro
Date: Mon, 20 Jan 2014 10:25:46 -0800
Message-ID: <CAA9_cmcXNC0WJ-4RgabLPtGU5=UGKZnVvpQneFaPmvqTRZZEfw@mail.gmail.com>
References: <20140120165450.15332.39118.stgit@gklab-154-244.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140120165450.15332.39118.stgit@gklab-154-244.igk.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, "dave.jiang" <dave.jiang@intel.com>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Baldysiak, Pawel" <pawel.baldysiak@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 20, 2014 at 8:54 AM, Lukasz Dorau <lukasz.dorau@intel.com> wrote:
> In the first place, the loop 'for' in the macro 'for_each_isci_host'
> (drivers/scsi/isci/host.h:314) is incorrect, because it accesses
> the 3rd element of 2 element array. After the 2nd iteration it executes
> the instruction:
>         ihost = to_pci_info(pdev)->hosts[2]
> (while the size of the 'hosts' array equals 2) and reads an
> out of range element.
>
> In the second place, because of the following GCC v4.8 bug:
> http://marc.info/?l=linux-kernel&m=138998871911336&w=2
> this loop is incorrectly compiled by GCC v4.8.
> As a result, on platforms with two SCU controllers,
> the loop at drivers/scsi/isci/init.c:717 is executed
> more times than it can be (for i=0,1 and 2).
> It causes the following oops after 'rmmod isci':
>

Surprised those bugs lasted this long... some comments below.

> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<ffffffff8131360b>] __list_add+0x1b/0xc0
> Oops: 0000 [#1] SMP
> RIP: 0010:[<ffffffff8131360b>]  [<ffffffff8131360b>] __list_add+0x1b/0xc0
> Call Trace:
>   [<ffffffff81661b84>] __mutex_lock_slowpath+0x114/0x1b0
>   [<ffffffff81661c3f>] mutex_lock+0x1f/0x30
>   [<ffffffffa03e97cb>] sas_disable_events+0x1b/0x50 [libsas]
>   [<ffffffffa03e9818>] sas_unregister_ha+0x18/0x60 [libsas]
>   [<ffffffffa040316e>] isci_unregister+0x1e/0x40 [isci]
>   [<ffffffffa0403efd>] isci_pci_remove+0x5d/0x100 [isci]
>   [<ffffffff813391cb>] pci_device_remove+0x3b/0xb0
>   [<ffffffff813fbf7f>] __device_release_driver+0x7f/0xf0
>   [<ffffffff813fc8f8>] driver_detach+0xa8/0xb0
>   [<ffffffff813fbb8b>] bus_remove_driver+0x9b/0x120
>   [<ffffffff813fcf2c>] driver_unregister+0x2c/0x50
>   [<ffffffff813381f3>] pci_unregister_driver+0x23/0x80
>   [<ffffffffa04152f8>] isci_exit+0x10/0x1e [isci]
>   [<ffffffff810d199b>] SyS_delete_module+0x16b/0x2d0
>   [<ffffffff81012a21>] ? do_notify_resume+0x61/0xa0
>   [<ffffffff8166ce29>] system_call_fastpath+0x16/0x1b
>
> The loop has been corrected.
> This patch fixes the above oops.
>
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> Reviewed-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
> Tested-by: Lukasz Dorau <lukasz.dorau@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/scsi/isci/host.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
> index 4911310..95adf31 100644
> --- a/drivers/scsi/isci/host.h
> +++ b/drivers/scsi/isci/host.h
> @@ -311,9 +311,9 @@ static inline struct Scsi_Host *to_shost(struct isci_host *ihost)
>  }
>
>  #define for_each_isci_host(id, ihost, pdev) \
> -       for (id = 0, ihost = to_pci_info(pdev)->hosts[id]; \
> -            id < ARRAY_SIZE(to_pci_info(pdev)->hosts) && ihost; \
> -            ihost = to_pci_info(pdev)->hosts[++id])
> +       for (id = 0, ihost = to_pci_info(pdev)->hosts[0]; \

No need to initialize ihost here since we assign and check it later.

> +            (id < ARRAY_SIZE(to_pci_info(pdev)->hosts)) && \

Just use SCI_MAX_CONTROLLERS here.

> +            (ihost = to_pci_info(pdev)->hosts[id]); id++)

--
Dan
