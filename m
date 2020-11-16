Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F062C4742C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 08:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B093722240
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 08:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgKPIGf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 03:06:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:60918 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbgKPIGf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 03:06:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 85856AC2E;
        Mon, 16 Nov 2020 08:06:33 +0000 (UTC)
Subject: Re: [PATCH v4 13/19] lpfc: vmid: Functions to manage vmids
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
References: <1604895845-2587-1-git-send-email-muneendra.kumar@broadcom.com>
 <1604895845-2587-14-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <1aaba5fd-2afc-f375-c671-d225bd99a211@suse.de>
Date:   Mon, 16 Nov 2020 09:06:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1604895845-2587-14-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/20 5:23 AM, Muneendra wrote:
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
> v4:
> No change
> 
> v3:
> No change
> 
> v2:
> Ported the patch on top of 5.10/scsi-queue
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c | 139 ++++++++++++++++++++++++++++++++++
>   1 file changed, 139 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 7bc1fd69b715..e5a1056cc575 100644
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
> @@ -4485,6 +4486,144 @@ void lpfc_poll_timeout(struct timer_list *t)
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
> +{
> +	struct lpfc_vmid *vmp;
> +	u16 count = 0;
> +
> +	while (count < LPFC_VMID_HASH_SIZE) {
> +		vmp = vport->hash_table[hash];
> +		if (vmp) {
> +			if (strncmp(&vmp->host_vmid[0], buf, 16) == 0)
> +				return vmp;
> +		} else {
> +			return NULL;
> +		}
> +		/* search the next available slot and continue till entry */
> +		/* is found */
> +		count++;
> +		hash++;
> +
> +		/* or the end is reached */
> +		if (hash == LPFC_VMID_HASH_SIZE)
> +			hash = 0;
> +	}
> +	return NULL;
> +}

Have you considered using generic function, eg from
include/linux/hashtable.h?
Or is the hash function part of the spec, and doesn't match the generic one?

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
> +int
> +lpfc_put_vmid_in_hashtable(struct lpfc_vport *vport, u32 hash,
> +			   struct lpfc_vmid *vmp)
> +{
> +	int count = 0;
> +
> +	while (count < LPFC_VMID_HASH_SIZE) {
> +		if (!vport->hash_table[hash]) {
> +			vport->hash_table[hash] = vmp;
> +			vmp->hash_index = hash;
> +			return 1;
> +		}
> +		/* if the slot is already occupied, a collision has occurred. */
> +		/* Store in the next available slot */
> +		count++;
> +		hash++;
> +		/* table is full */
> +		if (hash == LPFC_VMID_HASH_SIZE)
> +			hash = 0;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * lpfc_vmid_hash_fn- creates a hash value of the UUID
> + * @uuid: uuid associated with the VE
> + * @len: length of the UUID
> + * Returns the calculated hash value
> + */
> +int lpfc_vmid_hash_fn(char *vmid, int len)
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
> +void lpfc_vmid_update_entry(struct lpfc_vport *vport, struct scsi_cmnd
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
> +void lpfc_vmid_assign_cs_ctl(struct lpfc_vport *vport, struct lpfc_vmid *vmid)
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
> +		if (!pvmid)
> +			vmid->un.cs_ctl_vmid = pvmid->un.cs_ctl_vmid;
> +		else
> +			vmid->un.cs_ctl_vmid = lpfc_vmid_get_cs_ctl(vport);
> +	}
> +}
> +
>   /**
>    * lpfc_queuecommand - scsi_host_template queuecommand entry point
>    * @cmnd: Pointer to scsi_cmnd data structure.
> 

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
