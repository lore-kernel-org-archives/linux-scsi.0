Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EEDC433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 17:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B7862145D
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 17:03:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="fXUGYdlk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgGCRD4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 13:03:56 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.1]:59586 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726747AbgGCRDy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 13:03:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1593795828; i=@ts.fujitsu.com;
        bh=k4GcSw6YQQFn7KVnAFLG2NTU/Wk46EsBH+KkZZQv9Ug=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=fXUGYdlkjEvftGO8YzUqzSkkxppNx5yOixgYbNp3QzCZ7ffXsq8RpcxvVKj+oVHI+
         yS57pUPPWcTRn3/IOTbHfo//GL9ERrzEsrEXYAp2w5Xv4U3TKtveDPZOGvBswP+ntP
         cTYeciPFRdj+wcZarG/T0k+4up5j35QITXEnwNAHuFmzSjf03QaqQNH8nsSIMjF40h
         d9ydhoyrjLc2IH7x3w8pVATlEWPcmh928HYpHQTHC63ZJcrzPukGqwmUkHpT67VF/p
         KIIz3FGfHoGakXgGiatyBleacz6IP30t5PGOjTIoP+6QaPOlQnG9ijA8L9FOW7rIHe
         POZTloHiMVftg==
Received: from [100.113.2.20] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-a.eu-central-1.aws.symcld.net id 24/72-07993-4F46FFE5; Fri, 03 Jul 2020 17:03:48 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRWlGSWpSXmKPExsViZ8MxVfdzyv8
  4gycXbSw29nNYdF/fwWax/Pg/Jou/k26wWrQufcvkwOoxbdIpNo+PT2+xeHzeJBfAHMWamZeU
  X5HAmvHy5DfmgnexFTsm9rM2MK7x7mLk4hASmMQo0Xj2BRuE088oMe/4JeYuRk4OYYFEiZN7N
  zOBJEQE3jJKrDkwhxEkISRgK7H85CV2EJtNwEBixaT7LCA2r4CjxLq524FsDg4WARWJL1NkQE
  xRgXCJZyv8ISoEJU7OfAJWwSlgJ7HkgRBImFnATGLe5ofMELa4xK0n85kgbHmJ7W/nME9g5Ju
  FpHsWkpZZSFpmIWlZwMiyitEyqSgzPaMkNzEzR9fQwEDX0NBY11DXyMhML7FKN1EvtVQ3OTWv
  pCgRKKuXWF6sV1yZm5yTopeXWrKJERjeKYWMj3Ywnn79Qe8QoyQHk5Ior1nc/zghvqT8lMqMx
  OKM+KLSnNTiQ4wyHBxKEryVyUA5waLU9NSKtMwcYKzBpCU4eJREeJmTgNK8xQWJucWZ6RCpU4
  y6HDuPzlvELMSSl5+XKiXOWwUyQwCkKKM0D24ELO4vMcpKCfMyMjAwCPEUpBblZpagyr9iFOd
  gVBLmtQaZwpOZVwK36RXQEUxAR3jJ/wM5oiQRISXVwCQ2u/q/X5gHb1i7cwUDe+uUG7M3WH44
  zag/84hSmnSNp2ncHfvZ/RJbEmz/Ht1wJrTp4ZLskKMBs94EOORMf3uRWz2h/PKl07l808vSG
  G/4uC/y8Ehkjfj3dv/V99sMZ/Bc32efWv+4xcJNPX/Ox0S/oowl3ntOKMXNirU9yci/admpVC
  N7XYHfJz5/UI4r064STIws2aZTXfvQv9jAs9Plgsm0kCnfLy+dXLJwb27lqpZJ16ZFxK2S+qz
  0atUv1oXn0wJubu2KTNjQlu3/qXFq79vSrUm2PstWFZtKJOd3a134+ZiVtXgny6y/aStSGt7P
  WVjLnjvx1uHiie/nbj9jvkiY3SE6Y0mYTI+wthJLcUaioRZzUXEiAMjAINd2AwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-2.tower-232.messagelabs.com!1593795827!187963!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 10129 invoked from network); 3 Jul 2020 17:03:47 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-2.tower-232.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 3 Jul 2020 17:03:47 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 063H3lxx011542;
        Fri, 3 Jul 2020 18:03:47 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id E52E1204A1;
        Fri,  3 Jul 2020 19:03:46 +0200 (CEST)
Subject: Re: [RFC PATCH] scsi: target: tcmu: add compat mode for 32bit
 userspace on 64bit kernel
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200703165831.8479-1-bstroesser@ts.fujitsu.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <6d5bf05a-256d-40b1-a067-c6704aeda3d8@ts.fujitsu.com>
Date:   Fri, 3 Jul 2020 19:03:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200703165831.8479-1-bstroesser@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sorry, the patch works fine on x64_64, but does not compile on i686.
That will of course be fixed in a final version.

Bodo

On 2020-07-03 18:58, Bodo Stroesser wrote:
> This patch is made on top of Martin's for-next tree plus my RFC PATCH
> series "scsi: target: tcmu: Add TMR notification for tcmu"
> 
> When using tcmu it might happen, that userspace application cannot be
> built as 64 bit program even on a 64 bit host due to existing 32 bit
> libraries that must be used, e.g. for compression, encryption,
> deduplication, ...
> 
> Currently this only works with manual changes in userspace include
> file target_core_user.h due to a missing padding field in
> struct tcmu_cmd_entry. Additionally one has to change uio.h because
> 32-bit userspace interprets struct iovec to have 8 byte size while
> 64-bit kernel creates it with 16 byte size.
> 
> This patch tries to add CONFIG_COMPAT support in tcmu to avoid header
> file editing.
> 
> During mmap() of the command ring and data area of tcmu_dev's
> uio device, tcmu checks and saves the value returned from
> in_compat_syscall(). That way it allows multiple tasks to mmap()
> only if they are of same type (32-/64-bit).
> 
> During SCSI command processing tcmu now creates tcmu_cmd_entry
> records according to the saved type of the userspace program.
> 
> Offset and size of data fields in tcmu_cmd_entry differ between 32-bit
> and 64-bit only in the req part.
> The field cdb_off (i__u64) is on a 4-byte boundary in 32-bit, while
> in 64-bit it is on the next 8-byte boundary.
> The same is true for the start of the "struct iovec iov[]" array,
> which additionally contains 8 vs. 16 byte array entries in 32-bit vs.
> 64-bit mode.
> 
> Since difference are not too many, I just inserted changes into
> existing code where necessary instead of writing a full set of
> compat_* functions.
> 
> This patch is tested on x86_64.
> 
> Open questions:
>   1) is the use in_compat_syscall() the right way to retrieve the
>      32- / 64-bit mode on all architectures?
>   2) Is the way how struct tcmu_cmd_entry changes between 32-bit and
>      64-bit the same on all architectures? Especially, are __u64 fields
>      4-/8-byte aligned for 32-/64-bit mode on all architectures?
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> ---
>   drivers/target/target_core_user.c | 154 ++++++++++++++++++++++++++++++++------
>   1 file changed, 133 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 1082c5882dc6..92738775b029 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -21,6 +21,7 @@
>   #include <linux/configfs.h>
>   #include <linux/mutex.h>
>   #include <linux/workqueue.h>
> +#include <linux/compat.h>
>   #include <net/genetlink.h>
>   #include <scsi/scsi_common.h>
>   #include <scsi/scsi_proto.h>
> @@ -136,6 +137,11 @@ struct tcmu_dev {
>   	uint32_t max_blocks;
>   	size_t ring_size;
>   
> +#ifdef CONFIG_COMPAT
> +	bool compat;
> +	bool new_open;
> +#endif
> +
>   	struct mutex cmdr_lock;
>   	struct list_head qfull_queue;
>   	struct list_head tmr_queue;
> @@ -194,6 +200,32 @@ struct tcmu_tmr {
>   	int16_t tmr_cmd_ids[0];
>   };
>   
> +#ifdef CONFIG_COMPAT
> +struct tcmu_compat_cmd_entry {
> +	struct tcmu_cmd_entry_hdr hdr;
> +
> +	union {
> +		struct {
> +			__u32 iov_cnt;
> +			__u32 iov_bidi_cnt;
> +			__u32 iov_dif_cnt;
> +			__u64 cdb_off;
> +			__u64 __pad1;
> +			__u64 __pad2;
> +			struct compat_iovec iov[0];
> +		} __packed req;
> +		struct {
> +			__u8 scsi_status;
> +			__u8 __pad1;
> +			__u16 __pad2;
> +			__u32 read_len;
> +			char sense_buffer[TCMU_SENSE_BUFFERSIZE];
> +		} rsp;
> +	};
> +
> +} __packed;
> +#endif
> +
>   /*
>    * To avoid dead lock the mutex lock order should always be:
>    *
> @@ -671,6 +703,26 @@ static inline size_t iov_tail(struct iovec *iov)
>   	return (size_t)iov->iov_base + iov->iov_len;
>   }
>   
> +#ifdef CONFIG_COMPAT
> +static inline void compat_new_iov(struct iovec **iov, int *iov_cnt)
> +{
> +	struct compat_iovec **c_iov = (struct compat_iovec **)iov;
> +
> +	if (*iov_cnt != 0)
> +		(*c_iov)++;
> +	(*iov_cnt)++;
> +
> +	memset(*c_iov, 0, sizeof(struct compat_iovec));
> +}
> +
> +static inline size_t compat_iov_tail(struct iovec *iov)
> +{
> +	struct compat_iovec *c_iov = (struct compat_iovec *)iov;
> +
> +	return (size_t)c_iov->iov_base + c_iov->iov_len;
> +}
> +#endif
> +
>   static void scatter_data_area(struct tcmu_dev *udev,
>   	struct tcmu_cmd *tcmu_cmd, struct scatterlist *data_sg,
>   	unsigned int data_nents, struct iovec **iov,
> @@ -705,13 +757,39 @@ static void scatter_data_area(struct tcmu_dev *udev,
>   			to_offset = get_block_offset_user(udev, dbi,
>   					block_remaining);
>   
> +			copy_bytes = min_t(size_t, sg_remaining,
> +					block_remaining);
> +			if (copy_data) {
> +				offset = DATA_BLOCK_SIZE - block_remaining;
> +				memcpy(to + offset,
> +				       from + sg->length - sg_remaining,
> +				       copy_bytes);
> +			}
> +			sg_remaining -= copy_bytes;
> +			block_remaining -= copy_bytes;
> +
>   			/*
>   			 * The following code will gather and map the blocks
>   			 * to the same iovec when the blocks are all next to
>   			 * each other.
>   			 */
> -			copy_bytes = min_t(size_t, sg_remaining,
> -					block_remaining);
> +			if (IS_ENABLED(CONFIG_COMPAT) && udev->compat) {
> +				struct compat_iovec *c_iov;
> +
> +				if (*iov_cnt != 0 &&
> +				    to_offset == compat_iov_tail(*iov)) {
> +					c_iov = (struct compat_iovec *)*iov;
> +					c_iov->iov_len += copy_bytes;
> +				} else {
> +					compat_new_iov(iov, iov_cnt);
> +					c_iov = (struct compat_iovec *)*iov;
> +					c_iov->iov_base =
> +						(compat_uptr_t)to_offset;
> +					c_iov->iov_len = copy_bytes;
> +				}
> +				continue;
> +			}
> +
>   			if (*iov_cnt != 0 &&
>   			    to_offset == iov_tail(*iov)) {
>   				/*
> @@ -730,16 +808,6 @@ static void scatter_data_area(struct tcmu_dev *udev,
>   				(*iov)->iov_base = (void __user *)to_offset;
>   				(*iov)->iov_len = copy_bytes;
>   			}
> -
> -			if (copy_data) {
> -				offset = DATA_BLOCK_SIZE - block_remaining;
> -				memcpy(to + offset,
> -				       from + sg->length - sg_remaining,
> -				       copy_bytes);
> -			}
> -
> -			sg_remaining -= copy_bytes;
> -			block_remaining -= copy_bytes;
>   		}
>   		kunmap_atomic(from - sg->offset);
>   	}
> @@ -879,8 +947,13 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
>   	return tcmu_get_empty_blocks(udev, cmd);
>   }
>   
> -static inline size_t tcmu_cmd_get_base_cmd_size(size_t iov_cnt)
> +static inline size_t tcmu_cmd_get_base_cmd_size(struct tcmu_dev *dev,
> +						size_t iov_cnt)
>   {
> +	if (IS_ENABLED(CONFIG_COMPAT) && dev->compat) {
> +		return max(offsetof(struct tcmu_compat_cmd_entry, req.iov[iov_cnt]),
> +				sizeof(struct tcmu_compat_cmd_entry));
> +	}
>   	return max(offsetof(struct tcmu_cmd_entry, req.iov[iov_cnt]),
>   			sizeof(struct tcmu_cmd_entry));
>   }
> @@ -1016,7 +1089,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
>   	 * The size will be recalculated later as actually needed to save
>   	 * cmd area memories.
>   	 */
> -	base_command_size = tcmu_cmd_get_base_cmd_size(tcmu_cmd->dbi_cnt);
> +	base_command_size = tcmu_cmd_get_base_cmd_size(udev, tcmu_cmd->dbi_cnt);
>   	command_size = tcmu_cmd_get_cmd_size(tcmu_cmd, base_command_size);
>   
>   	if (!list_empty(&udev->qfull_queue))
> @@ -1049,7 +1122,13 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
>   
>   	/* Handle allocating space from the data area */
>   	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
> -	iov = &entry->req.iov[0];
> +	if (IS_ENABLED(CONFIG_COMPAT) && udev->compat) {
> +		struct compat_iovec *c_iov;
> +
> +		c_iov = &((struct tcmu_compat_cmd_entry *)entry)->req.iov[0];
> +		iov = (struct iovec *)c_iov;
> +	} else
> +		iov = &entry->req.iov[0];
>   	iov_cnt = 0;
>   	copy_to_data_area = (se_cmd->data_direction == DMA_TO_DEVICE
>   		|| se_cmd->se_cmd_flags & SCF_BIDI);
> @@ -1061,7 +1140,10 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
>   	/* Handle BIDI commands */
>   	iov_cnt = 0;
>   	if (se_cmd->se_cmd_flags & SCF_BIDI) {
> -		iov++;
> +		if (IS_ENABLED(CONFIG_COMPAT) && udev->compat)
> +			iov = (struct iovec *)((struct compat_iovec *)iov + 1);
> +		else
> +			iov++;
>   		scatter_data_area(udev, tcmu_cmd, se_cmd->t_bidi_data_sg,
>   				  se_cmd->t_bidi_data_nents, &iov, &iov_cnt,
>   				  false);
> @@ -1089,7 +1171,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
>   	 * Recalaulate the command's base size and size according
>   	 * to the actual needs
>   	 */
> -	base_command_size = tcmu_cmd_get_base_cmd_size(entry->req.iov_cnt +
> +	base_command_size = tcmu_cmd_get_base_cmd_size(udev, entry->req.iov_cnt +
>   						       entry->req.iov_bidi_cnt);
>   	command_size = tcmu_cmd_get_cmd_size(tcmu_cmd, base_command_size);
>   
> @@ -1098,7 +1180,12 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
>   	/* All offsets relative to mb_addr, not start of entry! */
>   	cdb_off = CMDR_OFF + cmd_head + base_command_size;
>   	memcpy((void *) mb + cdb_off, se_cmd->t_task_cdb, scsi_command_size(se_cmd->t_task_cdb));
> -	entry->req.cdb_off = cdb_off;
> +
> +	if (IS_ENABLED(CONFIG_COMPAT) && udev->compat)
> +		((struct tcmu_compat_cmd_entry *)entry)->req.cdb_off = cdb_off;
> +	else
> +		entry->req.cdb_off = cdb_off;
> +
>   	tcmu_flush_dcache_range(entry, command_size);
>   
>   	UPDATE_HEAD(mb->cmd_head, command_size, udev->cmdr_size);
> @@ -1730,6 +1817,8 @@ static const struct vm_operations_struct tcmu_vm_ops = {
>   	.fault = tcmu_vma_fault,
>   };
>   
> +static void __tcmu_reset_ring(struct tcmu_dev *, u8);
> +
>   static int tcmu_mmap(struct uio_info *info, struct vm_area_struct *vma)
>   {
>   	struct tcmu_dev *udev = container_of(info, struct tcmu_dev, uio_info);
> @@ -1743,6 +1832,23 @@ static int tcmu_mmap(struct uio_info *info, struct vm_area_struct *vma)
>   	if (vma_pages(vma) != (udev->ring_size >> PAGE_SHIFT))
>   		return -EINVAL;
>   
> +#ifdef CONFIG_COMPAT
> +	mutex_lock(&udev->cmdr_lock);
> +	if (udev->new_open) {
> +		if (in_compat_syscall() != udev->compat) {
> +			udev->compat = !udev->compat;
> +			__tcmu_reset_ring(udev, 1);
> +		}
> +		udev->new_open = false;
> +	} else if (in_compat_syscall() != udev->compat) {
> +		mutex_unlock(&udev->cmdr_lock);
> +		return -EINVAL;
> +	}
> +	mutex_unlock(&udev->cmdr_lock);
> +
> +	pr_debug("mmap() successful on %s, compat = %d\n", udev->name, udev->compat);
> +#endif
> +
>   	return 0;
>   }
>   
> @@ -1753,6 +1859,9 @@ static int tcmu_open(struct uio_info *info, struct inode *inode)
>   	/* O_EXCL not supported for char devs, so fake it? */
>   	if (test_and_set_bit(TCMU_DEV_BIT_OPEN, &udev->flags))
>   		return -EBUSY;
> +#ifdef CONFIG_COMPAT
> +	udev->new_open = true;
> +#endif
>   
>   	udev->inode = inode;
>   	kref_get(&udev->kref);
> @@ -2210,14 +2319,12 @@ static void tcmu_block_dev(struct tcmu_dev *udev)
>   	mutex_unlock(&udev->cmdr_lock);
>   }
>   
> -static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
> +static void __tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
>   {
>   	struct tcmu_mailbox *mb;
>   	struct tcmu_cmd *cmd;
>   	int i;
>   
> -	mutex_lock(&udev->cmdr_lock);
> -
>   	idr_for_each_entry(&udev->commands, cmd, i) {
>   		pr_debug("removing cmd %u on dev %s from ring (is expired %d)\n",
>   			  cmd->cmd_id, udev->name,
> @@ -2266,7 +2373,12 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
>   	tcmu_remove_all_queued_tmr(udev);
>   
>   	run_qfull_queue(udev, false);
> +}
>   
> +static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
> +{
> +	mutex_lock(&udev->cmdr_lock);
> +	__tcmu_reset_ring(udev, err_level);
>   	mutex_unlock(&udev->cmdr_lock);
>   }
>   
> 
