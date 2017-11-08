From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/17] lpfc: Fix crash after bad bar setup on driver
 attachment
Date: Wed, 8 Nov 2017 10:24:09 +0100
Message-ID: <6321f4f8-6243-d502-3b96-2e00cf5e1192@suse.de>
References: <20171103225628.24716-1-jsmart2021@gmail.com>
 <20171103225628.24716-5-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171103225628.24716-5-jsmart2021@gmail.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On 11/03/2017 11:56 PM, James Smart wrote:
> In test cases where an instance of the driver is detached and
> reattached, the driver will crash on reattachment. There is a
> compound if statement that will skip over the bar setup if
> the pci_resource_start call is not successful. The driver
> erroneously returns success to its bar setup in this scenario
> even though the bars aren't properly configured.
> 
> Rework the offending code segment for proper initialization steps.
> If the pci_resource_start call fails, -ENOMEM is now returned.
> 
> Sample stack:
> 
> rport-5:0-10: blocked FC remote port time out: removing rport
> BUG: unable to handle kernel NULL pointer dereference at           (null)
> ... lpfc_sli4_wait_bmbx_ready+0x32/0x70 [lpfc]
> ...
> ...  RIP: 0010:...  ... lpfc_sli4_wait_bmbx_ready+0x32/0x70 [lpfc]
>  Call Trace:
>   ... lpfc_sli4_post_sync_mbox+0x106/0x4d0 [lpfc]
>   ... ? __alloc_pages_nodemask+0x176/0x420
>   ... ? __kmalloc+0x2e/0x230
>   ... lpfc_sli_issue_mbox_s4+0x533/0x720 [lpfc]
>   ... ? mempool_alloc+0x69/0x170
>   ... ? dma_generic_alloc_coherent+0x8f/0x140
>   ... lpfc_sli_issue_mbox+0xf/0x20 [lpfc]
>   ... lpfc_sli4_driver_resource_setup+0xa6f/0x1130 [lpfc]
>   ... ? lpfc_pci_probe_one+0x23e/0x16f0 [lpfc]
>   ... lpfc_pci_probe_one+0x445/0x16f0 [lpfc]
>   ... local_pci_probe+0x45/0xa0
>   ... work_for_cpu_fn+0x14/0x20
>   ... process_one_work+0x17a/0x440
> 
> Cc: <stable@vger.kernel.org> # 4.12+
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 84 ++++++++++++++++++++++++++-----------------
>  1 file changed, 51 insertions(+), 33 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
