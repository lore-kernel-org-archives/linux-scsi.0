From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target/file: fix inclusive vfs_fsync_range() end
Date: Tue, 07 Oct 2014 23:11:30 -0700
Message-ID: <1412748690.31947.38.camel@haakon3.risingtidesystems.com>
References: <1412638813-13285-1-git-send-email-zab@zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1412638813-13285-1-git-send-email-zab@zabbo.net>
Sender: target-devel-owner@vger.kernel.org
To: Zach Brown <zab@zabbo.net>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2014-10-06 at 16:40 -0700, Zach Brown wrote:
> Both of the file target's calls to vfs_fsync_range() got the end offset
> off by one.  The range is inclusive, not exclusive.  It would sync a bit
> more data than was required.
> 
> The sync path already tested the length of the range and fell back to
> LLONG_MAX so I copied that pattern in the rw path.
> 
> This is untested. I found the errors by inspection while following other
> code.
> 
> Signed-off-by: Zach Brown <zab@zabbo.net>
> ---
>  drivers/target/target_core_file.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
> index 7d6cdda..176588f 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -415,7 +415,7 @@ fd_execute_sync_cache(struct se_cmd *cmd)
>  	} else {
>  		start = cmd->t_task_lba * dev->dev_attrib.block_size;
>  		if (cmd->data_length)
> -			end = start + cmd->data_length;
> +			end = start + cmd->data_length - 1;
>  		else
>  			end = LLONG_MAX;
>  	}
> @@ -680,7 +680,12 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
>  			struct fd_dev *fd_dev = FD_DEV(dev);
>  			loff_t start = cmd->t_task_lba *
>  				dev->dev_attrib.block_size;
> -			loff_t end = start + cmd->data_length;
> +			loff_t end;
> +
> +			if (cmd->data_length)
> +				end = start + cmd->data_length - 1;
> +			else
> +				end = LLONG_MAX;
>  
>  			vfs_fsync_range(fd_dev->fd_file, start, end, 1);
>  		}

Nice catch Zach.  Applying to target-pending/for-next now.

Thank you,

--nab
