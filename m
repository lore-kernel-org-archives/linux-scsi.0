From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [RFC PATCH 3/3] block: improve detail in I/O error messages
Date: Wed, 08 Dec 2010 14:28:32 +0300
Message-ID: <4CFF6BE0.4090109@ru.mvista.com>
References: <1291763802-8251-1-git-send-email-snitzer@redhat.com> <1291763802-8251-4-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1291763802-8251-4-git-send-email-snitzer@redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, k-ueda@ct.jp.nec.com, michaelc@cs.wisc.edu, tytso@mit.edu, sshtylyov@mvista.com, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, swhiteho@redhat.com, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, j-nomura@ce.jp.nec.com, vst@vlnb.net, rwheeler@redhat.com, hch@lst.de, chris.mason@oracle.com, tj@kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello.

On 08-12-2010 2:16, Mike Snitzer wrote:

> Classify severity of I/O errors for target and transport errors.

> Signed-off-by: Mike Snitzer<snitzer@redhat.com>
[...]

> diff --git a/block/blk-core.c b/block/blk-core.c
> index 4ce953f..ab8c776 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2028,9 +2028,15 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
>
>   	if (error&&  req->cmd_type == REQ_TYPE_FS&&
>   	!(req->cmd_flags&  REQ_QUIET)) {
> -		printk(KERN_ERR "end_request: I/O error, dev %s, sector %llu\n",
> -				req->rq_disk ? req->rq_disk->disk_name : "?",
> -				(unsigned long long)blk_rq_pos(req));
> +		char *error_type = "I/O";
> +
> +		if (error == -ENOLINK)
> +			error_type = "recoverable transport";
> +		else if (error == -EREMOTEIO)
> +			error_type = "critical target";

    *switch* would be more natural here.

WBR, Sergei
