From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/2] target: fix max discard sectors calculation
Date: Mon, 16 May 2016 11:57:42 -0700
Message-ID: <573A1826.3050007@sandisk.com>
References: <1463424410-17196-1-git-send-email-mchristi@redhat.com>
 <1463424410-17196-3-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1463424410-17196-3-git-send-email-mchristi@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: mchristi@redhat.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, socketpair@gmail.com
Cc: stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/16/2016 11:46 AM, mchristi@redhat.com wrote:
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index a4046ca..3f9f304 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -826,8 +826,8 @@ bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
> -	attrib->max_unmap_lba_count = (q->limits.max_discard_sectors << 9) /
> -								block_size;
> +	attrib->max_unmap_lba_count =
> +			((u64)q->limits.max_discard_sectors << 9) / block_size;

Hello Mike,

That's a good catch. But seeing this patch makes me wonder whether this 
patch introduces a 64-bit division? If so, I'm afraid this patch will 
make 32-bit users unhappy. Have you considered to use do_div() or >> 
(ilog2(block_size) - 9) instead? For the latter alternative no 64-bit 
cast is needed.

Thanks,

Bart.
