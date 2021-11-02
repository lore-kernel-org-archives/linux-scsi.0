Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09DFAC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 21:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBB566109F
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 21:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhKBVY0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 17:24:26 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:60622 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhKBVYZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 17:24:25 -0400
Received: from mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19])
        by mail-1.ca.inter.net (Postfix) with ESMTP id BA4EC2EA9D1;
        Tue,  2 Nov 2021 17:21:47 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19]) (amavisd-new, port 10024)
        with ESMTP id KPC76aglJgkm; Tue,  2 Nov 2021 17:21:47 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-208-241.dyn.295.ca [45.58.208.241])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id A80282EA7FE;
        Tue,  2 Nov 2021 17:21:46 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v2] scsi: scsi_debug: fix type in min_t to avoid stack OOB
To:     George Kennedy <george.kennedy@oracle.com>,
        gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
References: <1635861997-987-1-git-send-email-george.kennedy@oracle.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <1cc05731-41b4-35f7-e6c2-56ea711dfb76@interlog.com>
Date:   Tue, 2 Nov 2021 17:21:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1635861997-987-1-git-send-email-george.kennedy@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-11-02 10:06 a.m., George Kennedy wrote:
> Change min_t() to use type "unsigned int" instead of type "int" to
> avoid stack out of bounds. With min_t() type "int" the values get
> sign extended and the larger value gets used causing stack out of bounds.
> 
> BUG: KASAN: stack-out-of-bounds in memcpy include/linux/fortify-string.h:191 [inline]
> BUG: KASAN: stack-out-of-bounds in sg_copy_buffer+0x1de/0x240 lib/scatterlist.c:976
> Read of size 127 at addr ffff888072607128 by task syz-executor.7/18707
> 
> CPU: 1 PID: 18707 Comm: syz-executor.7 Not tainted 5.15.0-syzk #1
> Hardware name: Red Hat KVM, BIOS 1.13.0-2
> Call Trace:
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:106
>   print_address_description.constprop.9+0x28/0x160 mm/kasan/report.c:256
>   __kasan_report mm/kasan/report.c:442 [inline]
>   kasan_report.cold.14+0x7d/0x117 mm/kasan/report.c:459
>   check_region_inline mm/kasan/generic.c:183 [inline]
>   kasan_check_range+0x1a3/0x210 mm/kasan/generic.c:189
>   memcpy+0x23/0x60 mm/kasan/shadow.c:65
>   memcpy include/linux/fortify-string.h:191 [inline]
>   sg_copy_buffer+0x1de/0x240 lib/scatterlist.c:976
>   sg_copy_from_buffer+0x33/0x40 lib/scatterlist.c:1000
>   fill_from_dev_buffer.part.34+0x82/0x130 drivers/scsi/scsi_debug.c:1162
>   fill_from_dev_buffer drivers/scsi/scsi_debug.c:1888 [inline]
>   resp_readcap16+0x365/0x3b0 drivers/scsi/scsi_debug.c:1887
>   schedule_resp+0x4d8/0x1a70 drivers/scsi/scsi_debug.c:5478
>   scsi_debug_queuecommand+0x8c9/0x1ec0 drivers/scsi/scsi_debug.c:7533
>   scsi_dispatch_cmd drivers/scsi/scsi_lib.c:1520 [inline]
>   scsi_queue_rq+0x16b0/0x2d40 drivers/scsi/scsi_lib.c:1699
>   blk_mq_dispatch_rq_list+0xb9b/0x2700 block/blk-mq.c:1639
>   __blk_mq_sched_dispatch_requests+0x28f/0x590 block/blk-mq-sched.c:325
>   blk_mq_sched_dispatch_requests+0x105/0x190 block/blk-mq-sched.c:358
>   __blk_mq_run_hw_queue+0xe5/0x150 block/blk-mq.c:1761
>   __blk_mq_delay_run_hw_queue+0x4f8/0x5c0 block/blk-mq.c:1838
>   blk_mq_run_hw_queue+0x18d/0x350 block/blk-mq.c:1891
>   blk_mq_sched_insert_request+0x3db/0x4e0 block/blk-mq-sched.c:474
>   blk_execute_rq_nowait+0x16b/0x1c0 block/blk-exec.c:62
>   sg_common_write.isra.18+0xeb3/0x2000 drivers/scsi/sg.c:836
>   sg_new_write.isra.19+0x570/0x8c0 drivers/scsi/sg.c:774
>   sg_ioctl_common+0x14d6/0x2710 drivers/scsi/sg.c:939
>   sg_ioctl+0xa2/0x180 drivers/scsi/sg.c:1165
>   vfs_ioctl fs/ioctl.c:51 [inline]
>   __do_sys_ioctl fs/ioctl.c:874 [inline]
>   __se_sys_ioctl fs/ioctl.c:860 [inline]
>   __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Reported-by: syzkaller <syzkaller@googlegroups.com>
> Signed-off-by: George Kennedy <george.kennedy@oracle.com>

The resid value, inherited from CAM's cam_resid, was a signed quantity
where a negative number implied a data-in overflow ***. That may happen
if the alloc_len in the SCSI command implies a larger data-in transfer
than the transport has been set up for. That subtlety seems to be lost
on scsi_get_resid() which returns an unsigned int (i.e. it only reports
underflows).

Can't see how the code in place can blow up other than a data length
north of 2 billion bytes. But I guess that is what syzkaller specializes
in.

Can't see any downsides to the proposed patch.

Acked-by: Douglas Gilbert <sgilbert@interlog.com>

---

*** That happens more often than one might expect, mainly with READ
commands. Some of my copy utilities don't do a READ CAPACITY if it
is not needed (e.g. because count=BLOCKS is given). A copy utility may
then not notice that the device has 4096 byte blocks (rather than the
default 512 byte blocks). When that happens the copy operation runs
slowly because the HBA driver (LLD) is filling the log with errors
probably because there is no sensible way to report data-in overflow
to the mid-level. IOWs the CAM designers knew what they were doing.

Here is an example of a LLD error which could be clearer:
   mpt3sas_cm0: log_info(0x31120434): originator(PL), code(0x12), sub_code(0x0434)

> ---
>   drivers/scsi/scsi_debug.c | 20 ++++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 40b473e..e4c48fb 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -1189,7 +1189,7 @@ static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
>   		 __func__, off_dst, scsi_bufflen(scp), act_len,
>   		 scsi_get_resid(scp));
>   	n = scsi_bufflen(scp) - (off_dst + act_len);
> -	scsi_set_resid(scp, min_t(int, scsi_get_resid(scp), n));
> +	scsi_set_resid(scp, min_t(unsigned int, scsi_get_resid(scp), n));
>   	return 0;
>   }
>   
> @@ -1714,7 +1714,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   	}
>   	put_unaligned_be16(0x2100, arr + n);	/* SPL-4 no version claimed */
>   	ret = fill_from_dev_buffer(scp, arr,
> -			    min_t(int, alloc_len, SDEBUG_LONG_INQ_SZ));
> +			    min_t(unsigned int, alloc_len, SDEBUG_LONG_INQ_SZ));
>   	kfree(arr);
>   	return ret;
>   }
> @@ -1774,7 +1774,7 @@ static int resp_requests(struct scsi_cmnd *scp,
>   			arr[7] = 0xa;
>   		}
>   	}
> -	return fill_from_dev_buffer(scp, arr, min_t(int, len, alloc_len));
> +	return fill_from_dev_buffer(scp, arr, min_t(unsigned int, len, alloc_len));
>   }
>   
>   static int resp_start_stop(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
> @@ -1885,7 +1885,7 @@ static int resp_readcap16(struct scsi_cmnd *scp,
>   	}
>   
>   	return fill_from_dev_buffer(scp, arr,
> -			    min_t(int, alloc_len, SDEBUG_READCAP16_ARR_SZ));
> +			    min_t(unsigned int, alloc_len, SDEBUG_READCAP16_ARR_SZ));
>   }
>   
>   #define SDEBUG_MAX_TGTPGS_ARR_SZ 1412
> @@ -1959,9 +1959,9 @@ static int resp_report_tgtpgs(struct scsi_cmnd *scp,
>   	 * - The constructed command length
>   	 * - The maximum array size
>   	 */
> -	rlen = min_t(int, alen, n);
> +	rlen = min_t(unsigned int, alen, n);
>   	ret = fill_from_dev_buffer(scp, arr,
> -			   min_t(int, rlen, SDEBUG_MAX_TGTPGS_ARR_SZ));
> +			   min_t(unsigned int, rlen, SDEBUG_MAX_TGTPGS_ARR_SZ));
>   	kfree(arr);
>   	return ret;
>   }
> @@ -2467,7 +2467,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
>   		arr[0] = offset - 1;
>   	else
>   		put_unaligned_be16((offset - 2), arr + 0);
> -	return fill_from_dev_buffer(scp, arr, min_t(int, alloc_len, offset));
> +	return fill_from_dev_buffer(scp, arr, min_t(unsigned int, alloc_len, offset));
>   }
>   
>   #define SDEBUG_MAX_MSELECT_SZ 512
> @@ -2652,9 +2652,9 @@ static int resp_log_sense(struct scsi_cmnd *scp,
>   		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 3, -1);
>   		return check_condition_result;
>   	}
> -	len = min_t(int, get_unaligned_be16(arr + 2) + 4, alloc_len);
> +	len = min_t(unsigned int, get_unaligned_be16(arr + 2) + 4, alloc_len);
>   	return fill_from_dev_buffer(scp, arr,
> -		    min_t(int, len, SDEBUG_MAX_INQ_ARR_SZ));
> +		    min_t(unsigned int, len, SDEBUG_MAX_INQ_ARR_SZ));
>   }
>   
>   static inline bool sdebug_dev_is_zoned(struct sdebug_dev_info *devip)
> @@ -4425,7 +4425,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
>   	put_unaligned_be64(sdebug_capacity - 1, arr + 8);
>   
>   	rep_len = (unsigned long)desc - (unsigned long)arr;
> -	ret = fill_from_dev_buffer(scp, arr, min_t(int, alloc_len, rep_len));
> +	ret = fill_from_dev_buffer(scp, arr, min_t(unsigned int, alloc_len, rep_len));
>   
>   fini:
>   	read_unlock(macc_lckp);
> 

