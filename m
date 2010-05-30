From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/2] [tgt]: Add proper CDB passthrough for SG_IO backstores
Date: Sun, 30 May 2010 12:36:18 +0300
Message-ID: <4C023192.9080503@panasas.com>
References: <1274159582-6074-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:55351 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752791Ab0E3JgW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 May 2010 05:36:22 -0400
In-Reply-To: <1274159582-6074-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: stgt-devel <stgt@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>

On 05/18/2010 08:13 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch updates usr/bs_sg.c:bs_sg_cmd_submit() to process incoming scsi-generic IO
> of type SG_DXFER_TO_DEV and SG_DXFER_FROM_DEV using a single new struct scsi_cmnd->sg_iovec
> set using existing scsi_cmd.h scsi_get_[out,in]_[buffer,length]() macros.
> 
> It also makes set_cmd_failed() properly return SAM_STAT_CHECK_CONDITION, which is expected
> by the bs_sg_cmd_submit() caller in usr/scsi.c:scsi_cmd_perform()
> 
> Finally, this patch adds struct backingstore_template->bs_passthrough=1 that is used by
> bs_sg.c here and the next patch to hand off struct scsi_cmd for CDB passthrough.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  usr/bs_sg.c     |   31 ++++++++++++++++++++++++-------

Why not add a new bs_bsg.c backing store that goes through BSG and not SG
and do it properly for all type of targets and commands?

Just a thought.

>  usr/scsi_cmnd.h |    4 ++++
>  usr/tgtd.h      |    1 +
>  3 files changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/usr/bs_sg.c b/usr/bs_sg.c
> index 8baa480..9696392 100644
> --- a/usr/bs_sg.c
> +++ b/usr/bs_sg.c
> @@ -82,7 +82,7 @@ static int graceful_write(int fd, void *p_write, int to_write)
>  	return 0;
>  }
>  
> -static void set_cmd_failed(struct scsi_cmd *cmd)
> +static int set_cmd_failed(struct scsi_cmd *cmd)
>  {
>  	int result = SAM_STAT_CHECK_CONDITION;
>  	uint16_t asc = ASC_READ_ERROR;
> @@ -90,11 +90,14 @@ static void set_cmd_failed(struct scsi_cmd *cmd)
>  
>  	scsi_set_result(cmd, result);
>  	sense_data_build(cmd, key, asc);
> +
> +	return result;
>  }
>  
>  static int bs_sg_cmd_submit(struct scsi_cmd *cmd)
>  {
>  	struct scsi_lu *dev = cmd->dev;
> +	struct sg_iovec *iov = &cmd->sg_iovec;
>  	int fd = dev->fd;
>  	struct sg_io_hdr io_hdr;
>  	int err = 0;
> @@ -104,14 +107,27 @@ static int bs_sg_cmd_submit(struct scsi_cmd *cmd)
>  	io_hdr.cmd_len = cmd->scb_len;
>  	io_hdr.cmdp = cmd->scb;
>  
> +	if (scsi_get_data_dir(cmd) == DATA_BIDIRECTIONAL) {

Using bsg just really cleans this all function up.
IN_CMD => IN_HDR
OUT_CMD => OUT_HDR

no ifs and buts. The tgt's cmd looks like struct sg_io_v4 as if they
are twins ;-)

> +		eprintf("Unable to process DATA_BIDIRECTIONAL to"
> +			" SG_IO backstore\n");
> +		return set_cmd_failed(cmd);
> +	}
> +
>  	if (scsi_get_data_dir(cmd) == DATA_WRITE) {
>  		io_hdr.dxfer_direction = SG_DXFER_TO_DEV;
> -		io_hdr.dxfer_len = scsi_get_out_length(cmd);
> -		io_hdr.dxferp = (void *)scsi_get_out_buffer(cmd);

dxferp is already void* why do you need the cast?

> -	} else {
> +		io_hdr.dxfer_len = iov->iov_len = scsi_get_out_length(cmd);
> +		iov->iov_base = (void *)scsi_get_out_buffer(cmd);
> +		io_hdr.dxferp = &cmd->sg_iovec;
> +		io_hdr.iovec_count = 1;
> +	} else if (scsi_get_data_dir(cmd) == DATA_READ) {
>  		io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
> -		io_hdr.dxfer_len = scsi_get_in_length(cmd);
> -		io_hdr.dxferp = (void *)scsi_get_in_buffer(cmd);
> +		io_hdr.dxfer_len = iov->iov_len = scsi_get_in_length(cmd);
> +		iov->iov_base = (void *)scsi_get_in_buffer(cmd);
> +		io_hdr.dxferp = &cmd->sg_iovec;
> +		io_hdr.iovec_count = 1;
> +	} else {
> +		io_hdr.dxfer_direction = SG_DXFER_NONE;
> +		io_hdr.dxfer_len = 0;
>  	}
>  	io_hdr.mx_sb_len = sizeof(cmd->sense_buffer);
>  	io_hdr.sbp = cmd->sense_buffer;

You might want to look into the new SG_FLAG_Q_AT_TAIL but this is available
only in new Kernels so it'll be a little hack

> @@ -125,7 +141,7 @@ static int bs_sg_cmd_submit(struct scsi_cmd *cmd)
>  		set_cmd_async(cmd);
>  	else {
>  		eprintf("failed to start cmd 0x%p\n", cmd);
> -		set_cmd_failed(cmd);
> +		return set_cmd_failed(cmd);
>  	}
>  	return 0;
>  }
> @@ -238,6 +254,7 @@ static int bs_sg_cmd_done(struct scsi_cmd *cmd)
>  static struct backingstore_template sg_bst = {
>  	.bs_name		= "sg",
>  	.bs_datasize		= 0,
> +	.bs_passthrough		= 1,
>  	.bs_open		= bs_sg_open,
>  	.bs_close		= bs_sg_close,
>  	.bs_cmd_submit		= bs_sg_cmd_submit,

And again the Second patch should just fold into this one. And the final disposition will
just set the .bs_cmd_submit to the proper one.

[BTW if you want to keep struct backingstore_template sg_bst const (Which it is not, but
 should be) then just have two of them and switch between them]

Boaz
> diff --git a/usr/scsi_cmnd.h b/usr/scsi_cmnd.h
> index 011f3e6..776ffb3 100644
> --- a/usr/scsi_cmnd.h
> +++ b/usr/scsi_cmnd.h
> @@ -17,6 +17,8 @@ struct scsi_data_buffer {
>  	uint64_t buffer;
>  };
>  
> +#include <scsi/sg.h>
> +
>  struct scsi_cmd {
>  	struct target *c_target;
>  	/* linked it_nexus->cmd_hash_list */
> @@ -31,6 +33,8 @@ struct scsi_cmd {
>  	enum data_direction data_dir;
>  	struct scsi_data_buffer in_sdb;
>  	struct scsi_data_buffer out_sdb;
> +	/* used for bs_sg.c:bs_sg_cmd_submit() */
> +	struct sg_iovec sg_iovec;
>  
>  	uint64_t cmd_itn_id;
>  	uint64_t offset;
> diff --git a/usr/tgtd.h b/usr/tgtd.h
> index 3323a9b..4f26a29 100644
> --- a/usr/tgtd.h
> +++ b/usr/tgtd.h
> @@ -117,6 +117,7 @@ struct device_type_template {
>  struct backingstore_template {
>  	const char *bs_name;
>  	int bs_datasize;
> +	int bs_passthrough;
>  	int (*bs_open)(struct scsi_lu *dev, char *path, int *fd, uint64_t *size);
>  	void (*bs_close)(struct scsi_lu *dev);
>  	int (*bs_init)(struct scsi_lu *dev);

