From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] scsi: ses: Fix out-of-bounds memory access in
 ses_enclosure_data_process()
Date: Mon, 20 May 2019 10:41:43 -0400
Message-ID: <1fd39969-4413-2f11-86b2-729787680efa@redhat.com>
References: <20190501180535.26718-1-longman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190501180535.26718-1-longman@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 5/1/19 2:05 PM, Waiman Long wrote:
> KASAN has found a slab-out-of-bounds error in ses_enclosure_data_process().
>
> [   27.298092] BUG: KASAN: slab-out-of-bounds in ses_enclosure_data_process+0x919/0xe80 [ses]
> [   27.306407] Read of size 1 at addr ffff8807c99048b1 by task systemd-udevd/1563
> [   27.315173] CPU: 18 PID: 1563 Comm: systemd-udevd Not tainted 4.18.0-80.23.el8.x86_64+debug #1
> [   27.323835] Hardware name: HPE ProLiant XL450 Gen10/ProLiant XL450 Gen10, BIOS U40 10/02/2018
> [   27.332410] Call Trace:
>   :
> [   27.348557]  kasan_report.cold.6+0x92/0x1a6
> [   27.352771]  ses_enclosure_data_process+0x919/0xe80 [ses]
> [   27.358211]  ? kfree+0xd6/0x2e0
> [   27.361376]  ses_intf_add+0xa23/0xef1 [ses]
> [   27.365590]  ? class_dev_iter_next+0x6c/0xc0
> [   27.370034]  class_interface_register+0x298/0x400
> [   27.374769]  ? tsc_cs_mark_unstable+0x60/0x60
> [   27.379163]  ? class_dev_iter_exit+0x10/0x10
> [   27.384857]  ? 0xffffffffc0838000
> [   27.389580]  ses_init+0x12/0x1000 [ses]
> [   27.394832]  do_one_initcall+0xe9/0x5fd
>   :
> [   27.562322] Allocated by task 1563:
> [   27.562330]  kasan_kmalloc+0xbf/0xe0
> [   27.569433]  __kmalloc+0x150/0x360
> [   27.572858]  ses_intf_add+0x76a/0xef1 [ses]
> [   27.577068]  class_interface_register+0x298/0x400
> [   27.581803]  ses_init+0x12/0x1000 [ses]
> [   27.587053]  do_one_initcall+0xe9/0x5fd
> [   27.592309]  do_init_module+0x1f2/0x710
> [   27.597564]  load_module+0x3e19/0x5910
> [   27.601336]  __do_sys_init_module+0x1dd/0x260
> [   27.606673]  do_syscall_64+0xa5/0x4a0
> [   27.610359]  entry_SYSCALL_64_after_hwframe+0x6a/0xdf
>   :
> [   27.624932] The buggy address belongs to the object at ffff8807c9904400
>                 which belongs to the cache kmalloc-2048 of size 2048
> [   27.637701] The buggy address is located 1201 bytes inside of
>                 2048-byte region [ffff8807c9904400, ffff8807c9904c00)
> [   27.649683] The buggy address belongs to the page:
> [   27.654503] page:ffffea001f264000 count:1 mapcount:0 mapping:ffff880107c15d80 index:0x0 compound_mapcount: 0
> [   27.664393] flags: 0x17ffffc0008100(slab|head)
> [   27.668865] raw: 0017ffffc0008100 dead000000000100 dead000000000200 ffff880107c15d80
> [   27.676656] raw: 0000000000000000 00000000800f000f 00000001ffffffff 0000000000000000
> [   27.684444] page dumped because: kasan: bad access detected
>
> The out-of-bounds memory access happens to ses_dev->page10 which has a
> size of 1200 bytes in this case. The invalid memory access happens in:
>
>  600 if (addl_desc_ptr &&
>  601     /* only find additional descriptions for specific devices */
>  602     (type_ptr[0] == ENCLOSURE_COMPONENT_DEVICE ||
>  603      type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE ||
>  604      type_ptr[0] == ENCLOSURE_COMPONENT_SAS_EXPANDER ||
>  605      /* these elements are optional */
>  606      type_ptr[0] == ENCLOSURE_COMPONENT_SCSI_TARGET_PORT ||
>  607      type_ptr[0] == ENCLOSURE_COMPONENT_SCSI_INITIATOR_PORT ||
>  608      type_ptr[0] == ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONICS))
>  609         addl_desc_ptr += addl_desc_ptr[1] + 2; <-- here
>
> To fix the out-of-bounds memory access, code is now added to make sure
> that addl_desc_ptr will never point to an address outside of its bounds.
>
> With this patch, the KASAN warning is gone.
>
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  drivers/scsi/ses.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index 0fc39224ce1e..dbc9acc2df2f 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -605,9 +605,14 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
>  			     /* these elements are optional */
>  			     type_ptr[0] == ENCLOSURE_COMPONENT_SCSI_TARGET_PORT ||
>  			     type_ptr[0] == ENCLOSURE_COMPONENT_SCSI_INITIATOR_PORT ||
> -			     type_ptr[0] == ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONICS))
> +			     type_ptr[0] == ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONICS)) {
>  				addl_desc_ptr += addl_desc_ptr[1] + 2;
>  
> +				/* Ensure no out-of-bounds memory access */
> +				if (addl_desc_ptr >= ses_dev->page10 +
> +						     ses_dev->page10_len)
> +					addl_desc_ptr = NULL;
> +			}
>  		}
>  	}
>  	kfree(buf);

Ping! Any comment on this patch.

Cheers,
Longman
