From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] be2iscsi: Moving to pci_pools v3
Date: Mon, 28 Sep 2009 13:44:12 -0500
Message-ID: <4AC103FC.2040701@cs.wisc.edu>
References: <20090922025217.GA19987@serverengines.com>	 <4ABA550F.1000504@cs.wisc.edu> <1253982622.27401.25.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55491 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbZI1SoT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Sep 2009 14:44:19 -0400
In-Reply-To: <1253982622.27401.25.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Jayamohan Kalickal <jayamohank@serverengines.com>, linux-scsi@vger.kernel.org

On 09/26/2009 11:30 AM, James Bottomley wrote:
> On Wed, 2009-09-23 at 12:04 -0500, Mike Christie wrote:
>> On 09/21/2009 09:52 PM, Jayamohan Kallickal wrote:
>>>    This patch contains changes to use pci_pools for iscsi hdr
>>> instead of pci_alloc_consistent. Here we alloc and free to pool
>>> for every IO
>>>
>>> v3:
>>> - Remove cleanup loop in beiscsi_session_destroy
>>> - Fixup for allocation failure handling in beiscsi_alloc_pdu
>>> - Removed unused variable in beiscsi_session_destroy.
>>>
>>> Signed-off-by: Jayamohan Kallickal<jayamohank@serverengines.com>
>> Thanks for fixing those issues.
>>
>> Reviewed-by: Mike Christie<michaelc@cs.wisc.edu>
>
> Actually, this isn't building correctly for me in my 32 bit environme=
nt:
>
> drivers/scsi/be2iscsi/be_main.c: In function =E2=80=98beiscsi_alloc_p=
du=E2=80=99:
> drivers/scsi/be2iscsi/be_main.c:2885: warning: passing argument 3 of
> =E2=80=98dma_pool_alloc=E2=80=99 from incompatible pointer type
>
> The problem is this unsigned long long definition of a64: dma_addr_t =
is
> only a long (32 bits) on this platform.
>
> This patch fixes the problem for me ... I'll just fold it in if
> everyone's OK with it.
>
> James
>
> ---
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/=
be_main.c
> index 4299a46..4f1aca3 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -2881,13 +2881,15 @@ static int beiscsi_alloc_pdu(struct iscsi_tas=
k *task, uint8_t opcode)
>   	struct hwi_controller *phwi_ctrlr;
>   	itt_t itt;
>   	struct beiscsi_session *beiscsi_sess =3D beiscsi_conn->beiscsi_ses=
s;
> +	dma_addr_t paddr;
>
>   	io_task->cmd_bhs =3D pci_pool_alloc(beiscsi_sess->bhs_pool,
> -					  GFP_KERNEL,
> -					&io_task->bhs_pa.u.a64.address);
> +					  GFP_KERNEL,&paddr);
> +
>   	if (!io_task->cmd_bhs)
>   		return -ENOMEM;
>
> +	io_task->bhs_pa.u.a64.address =3D paddr;
>   	io_task->pwrb_handle =3D alloc_wrb_handle(phba,
>   						beiscsi_conn->beiscsi_conn_cid,
>   						task->itt);
>
>

Looks ok to me.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
