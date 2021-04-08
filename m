Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 153FAC433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 08:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD6FB61159
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 08:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhDHIgK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 04:36:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:43206 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhDHIgJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Apr 2021 04:36:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D0263B028;
        Thu,  8 Apr 2021 08:35:57 +0000 (UTC)
Subject: Re: [PATCH v9 08/13] lpfc: vmid: Functions to manage vmids
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
References: <1617750397-26466-1-git-send-email-muneendra.kumar@broadcom.com>
 <1617750397-26466-9-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <c937966d-7357-e772-b4f2-4e02a59c06db@suse.de>
Date:   Thu, 8 Apr 2021 10:35:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1617750397-26466-9-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/21 1:06 AM, Muneendra wrote:
> From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
> 
> This patch contains the routines to save, retrieve and remove the vmids
> from the data structure. A hash table is used to save the vmids and
> the corresponding UUIDs associated with the application/VMs.
> 
> Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v9:
> Added changes for implementing kernel based hashtable
> 
> v8:
> Added correct return value and error codes
> 
> v7:
> No change
> 
> v6:
> Added Forward declarations and functions to static
> 
> v5:
> Changed Return code to non-numeric/Symbol
> 
> v4:
> No change
> 
> v3:
> No change
> 
> v2:
> Ported the patch on top of 5.10/scsi-queue
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c | 118 ++++++++++++++++++++++++++++++++++
>   1 file changed, 118 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 0868cb38d5b0..f81178464436 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -28,6 +28,7 @@
>   #include <asm/unaligned.h>
>   #include <linux/t10-pi.h>
>   #include <linux/crc-t10dif.h>
> +#include <linux/blk-cgroup.h>
>   #include <net/checksum.h>
>   
>   #include <scsi/scsi.h>
> @@ -86,6 +87,14 @@ static void
>   lpfc_release_scsi_buf_s3(struct lpfc_hba *phba, struct lpfc_io_buf *psb);
>   static int
>   lpfc_prot_group_type(struct lpfc_hba *phba, struct scsi_cmnd *sc);
> +static void
> +lpfc_put_vmid_in_hashtable(struct lpfc_vport *vport, u32 hash,
> +			   struct lpfc_vmid *vmp);
> +static void lpfc_vmid_update_entry(struct lpfc_vport *vport, struct scsi_cmnd
> +				   *cmd, struct lpfc_vmid *vmp,
> +				   union lpfc_vmid_io_tag *tag);
> +static void lpfc_vmid_assign_cs_ctl(struct lpfc_vport *vport,
> +				    struct lpfc_vmid *vmid);
>   
>   static inline unsigned
>   lpfc_cmd_blksize(struct scsi_cmnd *sc)
> @@ -5145,6 +5154,115 @@ void lpfc_poll_timeout(struct timer_list *t)
>   	}
>   }
>   
> +/*
> + * lpfc_get_vmid_from_hastable - search the UUID in the hash table
> + * @vport: The virtual port for which this call is being executed.
> + * @hash: calculated hash value
> + * @buf: uuid associated with the VE
> + * Returns the vmid entry associated with the UUID
> + * Make sure to acquire the appropriate lock before invoking this routine.
> + */
> +struct lpfc_vmid *lpfc_get_vmid_from_hastable(struct lpfc_vport *vport,
> +					      u32 hash, u8 *buf)

lpfc_get_vmid_from_hashtable(), please.

> +{
> +	struct lpfc_vmid *vmp;
> +
> +	hash_for_each_possible(vport->hash_table, vmp, hnode, hash) {
> +		if (memcmp(&vmp->host_vmid[0], buf, 16) == 0)
> +			return vmp;
> +	}
> +	return NULL;
> +}
> +
> +/*
> + * lpfc_put_vmid_from_hastable - put the VMID in the hash table
> + * @vport: The virtual port for which this call is being executed.
> + * @hash - calculated hash value
> + * @vmp: Pointer to a VMID entry representing a VM sending IO
> + *
> + * This routine will insert the newly acquired vmid entity in the hash table.
> + * Make sure to acquire the appropriate lock before invoking this routine.
> + */
> +static void
> +lpfc_put_vmid_in_hashtable(struct lpfc_vport *vport, u32 hash,
> +			   struct lpfc_vmid *vmp)
> +{
> +	hash_add(vport->hash_table, &vmp->hnode, hash);
> +}
> +

Similar here; lpfc_put_vmid_in_hashtable()

> +/*
> + * lpfc_vmid_hash_fn - creates a hash value of the UUID
> + * @vmid: uuid associated with the VE
> + * @len: length of the vmid string
> + * Returns the calculated hash value
> + */
> +int lpfc_vmid_hash_fn(const char *vmid, int len)
> +{
> +	int c;
> +	int hash = 0;
> +
> +	if (len == 0)
> +		return 0;
> +	while (len--) {
> +		c = *vmid++;
> +		if (c >= 'A' && c <= 'Z')
> +			c += 'a' - 'A';
> +
> +		hash = (hash + (c << LPFC_VMID_HASH_SHIFT) +
> +			(c >> LPFC_VMID_HASH_SHIFT)) * 19;
> +	}
> +
> +	return hash & LPFC_VMID_HASH_MASK;
> +}
> +
> +/*
> + * lpfc_vmid_update_entry - update the vmid entry in the hash table
> + * @vport: The virtual port for which this call is being executed.
> + * @cmd: address of scsi cmmd descriptor
> + * @vmp: Pointer to a VMID entry representing a VM sending IO
> + * @tag: VMID tag
> + */
> +static void lpfc_vmid_update_entry(struct lpfc_vport *vport, struct scsi_cmnd
> +				   *cmd, struct lpfc_vmid *vmp,
> +				   union lpfc_vmid_io_tag *tag)
> +{
> +	u64 *lta;
> +
> +	if (vport->vmid_priority_tagging)
> +		tag->cs_ctl_vmid = vmp->un.cs_ctl_vmid;
> +	else
> +		tag->app_id = vmp->un.app_id;
> +
> +	if (cmd->sc_data_direction == DMA_TO_DEVICE)
> +		vmp->io_wr_cnt++;
> +	else
> +		vmp->io_rd_cnt++;
> +
> +	/* update the last access timestamp in the table */
> +	lta = per_cpu_ptr(vmp->last_io_time, raw_smp_processor_id());
> +	*lta = jiffies;
> +}
> +
> +static void lpfc_vmid_assign_cs_ctl(struct lpfc_vport *vport,
> +				    struct lpfc_vmid *vmid)
> +{
> +	u32 hash;
> +	struct lpfc_vmid *pvmid;
> +
> +	if (vport->port_type == LPFC_PHYSICAL_PORT) {
> +		vmid->un.cs_ctl_vmid = lpfc_vmid_get_cs_ctl(vport);
> +	} else {
> +		hash = lpfc_vmid_hash_fn(vmid->host_vmid, vmid->vmid_len);
> +		pvmid =
> +		    lpfc_get_vmid_from_hastable(vport->phba->pport, hash,
> +						vmid->host_vmid);
> +		if (pvmid)
> +			vmid->un.cs_ctl_vmid = pvmid->un.cs_ctl_vmid;
> +		else
> +			vmid->un.cs_ctl_vmid = lpfc_vmid_get_cs_ctl(vport);
> +	}
> +}
> +
>   /**
>    * lpfc_queuecommand - scsi_host_template queuecommand entry point
>    * @shost: kernel scsi host pointer.
> 

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
