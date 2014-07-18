From: poma <pomidorabelisima@gmail.com>
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69 kmem_cache_create+0x1a9/0x330()
Date: Fri, 18 Jul 2014 22:16:15 +0200
Message-ID: <53C9808F.5040906@gmail.com>
References: <53C8DF7F.5060707@gmail.com> <53C8FD95.5020302@gmail.com>	 <20140718132104.GK27940@esperanza> <20140718141747.GA23272@lst.de>	 <53C97D34.5040707@gmail.com> <1405714046.30262.10.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405714046.30262.10.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Vladimir Davydov <vdavydov@parallels.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>, Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 18.07.2014 22:07, James Bottomley wrote:
> On Fri, 2014-07-18 at 22:01 +0200, poma wrote:
>> On 18.07.2014 16:17, Christoph Hellwig wrote:
>>> On Fri, Jul 18, 2014 at 05:21:04PM +0400, Vladimir Davydov wrote:
>>>> Slab warns, because the name of the cache being created contains spaces.
>>>> The "bad" cache is created by scsi_get_host_cmd_pool. Its name
>>>> (pool->cmd_name) is initialized by scsi_alloc_host_cmd_pool as follows:
>>>>
>>>> 	pool->cmd_name = kasprintf(GFP_KERNEL, "%s_cmd", hostt->name);
>>>>
>>>> So, if hostt->name contains spaces, the cache name will also contain
>>>> spaces and we'll get the warning. And hostt->name can contain spaces,
>>>> e.g. virtscsi_host_template_single.name="Virtio SCSI HBA".
>>>
>>> Or might not even be present.  I'll send a patch to replace it with
>>> ->proc_name, which must not contain spaces and is generally shorter
>>> as well.
>>>
>>
>> Is this what you thought?
>
> No, he means this, if you want to try it.
>
> James
>
> ---
>
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 88d46fe..eb07a9b 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -368,8 +368,8 @@ scsi_alloc_host_cmd_pool(struct Scsi_Host *shost)
>   	if (!pool)
>   		return NULL;
>
> -	pool->cmd_name = kasprintf(GFP_KERNEL, "%s_cmd", hostt->name);
> -	pool->sense_name = kasprintf(GFP_KERNEL, "%s_sense", hostt->name);
> +	pool->cmd_name = kasprintf(GFP_KERNEL, "%s_cmd", hostt->proc_name);
> +	pool->sense_name = kasprintf(GFP_KERNEL, "%s_sense", hostt->proc_name);
>   	if (!pool->cmd_name || !pool->sense_name) {
>   		scsi_free_host_cmd_pool(pool);
>   		return NULL;
>
>

Man, I just now read it correctly - "So, if hostt->name contains spaces".
Thanks.

I'll be back.
