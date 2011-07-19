From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/20] target: Eliminate usage of struct se_mem
Date: Tue, 19 Jul 2011 00:56:30 -0400
Message-ID: <20110719045630.GA26652@infradead.org>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
 <1310174329-22228-7-git-send-email-agrover@redhat.com>
 <1310932648.26130.32.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33424
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059Ab1GSE4d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2011 00:56:33 -0400
Content-Disposition: inline
In-Reply-To: <1310932648.26130.32.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andy Grover <agrover@redhat.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Jul 17, 2011 at 12:57:28PM -0700, Nicholas A. Bellinger wrote:
> index 1645aab..2f89001 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -780,6 +780,7 @@ static int iscsit_allocate_iovecs(struct iscsi_cmd *cmd)
>  static int iscsit_alloc_buffs(struct iscsi_cmd *cmd)
>  {
>         struct scatterlist *sgl;
> +       unsigned char *buf;
>         u32 length = cmd->se_cmd.data_length;
>         int nents = DIV_ROUND_UP(length, PAGE_SIZE);
>         int i = 0, ret;
> @@ -804,6 +805,14 @@ static int iscsit_alloc_buffs(struct iscsi_cmd *cmd)
>                 if (!page)
>                         goto page_alloc_failed;
>  
> +               buf = kmap_atomic(page, KM_IRQ0);
> +               if (!buf) {
> +                       pr_err("kmap_atomic failed\n");
> +                       goto page_alloc_failed;
> +               }
> +               memset(buf, 0, buf_size);
> +               kunmap_atomic(buf, KM_IRQ0);
> +

This should use clear_highpage, or even better just the __GFP_ZERO flag
to the page allocator.

> @@ -3971,13 +3972,30 @@ transport_generic_get_mem(struct se_cmd *cmd)
>                 u32 page_len = min_t(u32, length, PAGE_SIZE);
>                 page = alloc_page(GFP_KERNEL);
>                 if (!page)
> -                       return -ENOMEM;
> +                       goto out;
> +
> +               buf = kmap_atomic(page, KM_IRQ0);
> +               if (!buf) {
> +                       pr_err("kmap_atomic failed\n");
> +                       goto out;
> +               }
> +               memset(buf, 0, page_len);
> +               kunmap_atomic(buf, KM_IRQ0);

Same here.

> > -		ret = transport_map_control_cmd_to_task(cmd);
> > +		ret = dev->transport->map_task_SG(task);
> >  		if (ret < 0)
> >  			return ret;
> 
> Calling dev->transport->map_task_SG() here for all cases is incorrect,
> and was triggering an OOPs during iscsi-target initial LUN scan..  Fixed
> with the following:
> 
> commit 93529985c9de3cd5ab40cb322da24a4d8372ad4c
> Author: Nicholas Bellinger <nab@linux-iscsi.org>
> Date:   Sat Jul 16 19:27:07 2011 -0700
> 
>     target: Fix incorrect usage of ->map_task_SG in transport_generic_new_cmd
>     
>     This patch fixes incorrect usage of ->map_task_SG() for all se_cmd descriptors
>     in transport_generic_new_cmd().  This introduced with commit:

Indeed.  But why did you also commit

	"target/iblock: Make iblock_map_task_SG only for SCF_SCSI_DATA_SG_IO_CDB"

which is a hacky workaround for the same issue inside iblock?


> -
> +       /*
> +        * Call transport_new_cmd_obj() to invoke transport_allocate_tasks()
> +        * and perform the memory map to backend subsystem devices.
> +        */
>         ret = transport_new_cmd_obj(cmd);

What is that comment supposed to help with?  It's rather confusing to
be honest.

