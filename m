From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/3] [tgt]: Add BSG v4 backstore support to usr/bs_sg.c
Date: Mon, 07 Jun 2010 11:40:17 +0300
Message-ID: <4C0CB071.8040805@panasas.com>
References: <1275882640-5418-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1275882640-5418-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: stgt-devel <stgt@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On 06/07/2010 06:50 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds initial support for the block layer implementation of the sg v4 interface
> (BSG) -> STGT with a new struct backingstore_template bsg_bst sharing code with the
> original sg_bst.  It adds for new function bs_bsg_cmd_submit() for incoming write I/O
> and bs_bsg_cmd_complete() for polling read I/O using include/linux/bsg.h:struct sg_io_v4.
> 
> This patch also splits up bs_sg_open() to support both BSG and SG looking for the
> path "/dev/bsg" in bs_sg_open(), and getting max_queue using SG_GET_COMMAND_Q and
> calling SG_SET_RESERVED_SIZE (following the original bs_sg code in init_sg_device)
> 
> Also chk_bsg_device() currently using a hardcoded 254 major as def for BSG does not
> appear in include/linux/major.h just yet..
> 
> So far this has been tested with STGT/iSCSI <-> BSG <-> TCM_Loop SPC-4 iSCSI Target
> Port emulation and is able to mkfs, fsck and mount a filesystem from a TCM/IBLOCK
> Linux LVM kernel level backstore
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  usr/bs_sg.c     |  178 +++++++++++++++++++++++++++++++++++++++++++++++++++---
>  usr/scsi_cmnd.h |    7 ++
>  2 files changed, 175 insertions(+), 10 deletions(-)
> 
> diff --git a/usr/bs_sg.c b/usr/bs_sg.c
> index 23676ef..d071714 100644
> --- a/usr/bs_sg.c
> +++ b/usr/bs_sg.c
> @@ -3,6 +3,9 @@
>   *
>   * Copyright (C) 2008 Alexander Nezhinsky <nezhinsky@gmail.com>
>   *
> + * Added linux/block/bsg.c support using struct sg_io_v4.
> + * Copyright (C) 2010 Nicholas A. Bellinger <nab@linux-iscsi.org>
> + *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License as
>   * published by the Free Software Foundation, version 2 of the
> @@ -33,6 +36,7 @@
>  #include <sys/stat.h>
>  #include <sys/epoll.h>
>  #include <scsi/sg.h>
> +#include <linux/bsg.h>
>  
>  #include "list.h"
>  #include "util.h"
> @@ -45,6 +49,14 @@
>  #define BS_SG_TIMEOUT	2000
>  #define BS_SG_SHIFT	9
>  
> +//#define BSG_DEBUG_IO
> +
> +#ifdef BSG_DEBUG_IO
> +#define BSG_IO(x...) eprintf(x)
> +#else
> +#define BSG_IO(x...)
> +#endif
> +
>  static int graceful_read(int fd, void *p_read, int to_read)
>  {
>  	int err;
> @@ -111,7 +123,7 @@ static int bs_sg_rw(int host_no, struct scsi_cmd *cmd)
>  	return SAM_STAT_CHECK_CONDITION;
>  }
>  
> -static void set_cmd_failed(struct scsi_cmd *cmd)
> +static int set_cmd_failed(struct scsi_cmd *cmd)
>  {
>  	int result = SAM_STAT_CHECK_CONDITION;
>  	uint16_t asc = ASC_READ_ERROR;
> @@ -119,6 +131,54 @@ static void set_cmd_failed(struct scsi_cmd *cmd)
>  
>  	scsi_set_result(cmd, result);
>  	sense_data_build(cmd, key, asc);
> +
> +	return result;
> +}
> +
> +static int bs_bsg_cmd_submit(struct scsi_cmd *cmd)
> +{
> +	struct scsi_lu *dev = cmd->dev;
> +	int fd = dev->fd;
> +	struct sg_io_v4 *io_hdr = &cmd->cmd_bsg_hdr;
> +	int err = 0;
> +	/*
> +	 * Following linux/include/linux/bsg.h
> +	 */
> +	/* [i] 'Q' to differentiate from v3 */
> +	io_hdr->guard = 'Q';
> +	io_hdr->protocol = BSG_PROTOCOL_SCSI;
> +	io_hdr->subprotocol = BSG_SUB_PROTOCOL_SCSI_CMD;
> +	io_hdr->request_len = cmd->scb_len;
> +	io_hdr->request = (unsigned long )cmd->scb;
> +
> +	if (scsi_get_data_dir(cmd) == DATA_WRITE) {

Why the if? both sides are fully bidi just remove the ifs
and: OUT <= OUT, IN <= IN

Boaz

> +		io_hdr->dout_xfer_len = scsi_get_out_length(cmd);
> +		io_hdr->dout_xferp = (unsigned long)scsi_get_out_buffer(cmd);
> +	} else {
> +		io_hdr->din_xfer_len = scsi_get_in_length(cmd);
> +		io_hdr->din_xferp = (unsigned long)scsi_get_in_buffer(cmd);
> +	}
> +	io_hdr->max_response_len = sizeof(cmd->sense_buffer);
> +	/* SCSI: (auto)sense data */
> +	io_hdr->response = (unsigned long)cmd->sense_buffer;
> +	/* Using the same 2000 millisecond timeout.. */
> +	io_hdr->timeout = BS_SG_TIMEOUT;
> +	/* [i->o] unused internally */
> +	io_hdr->usr_ptr = (unsigned long)cmd;
> +	BSG_IO("[%d] Set io_hdr->usr_ptr from cmd: %p\n", getpid(), cmd);
> +	/* Bsg does Q_AT_HEAD by default */
> +	io_hdr->flags |= BSG_FLAG_Q_AT_TAIL;
> +
> +	BSG_IO("[%d] Calling graceful_write for CDB: 0x%02x\n", getpid(), cmd->scb[0]);
> +	err = graceful_write(fd, &cmd->cmd_bsg_hdr, sizeof(struct sg_io_v4));
> +	if (!err)
> +		set_cmd_async(cmd);
> +	else {
> +		eprintf("failed to start cmd 0x%p\n", cmd);
> +		return set_cmd_failed(cmd);
> +	}
> +
> +	return 0;
>  }
>  
>  static int bs_sg_cmd_submit(struct scsi_cmd *cmd)
> @@ -136,11 +196,13 @@ static int bs_sg_cmd_submit(struct scsi_cmd *cmd)
>  	if (scsi_get_data_dir(cmd) == DATA_WRITE) {
>  		io_hdr.dxfer_direction = SG_DXFER_TO_DEV;
>  		io_hdr.dxfer_len = scsi_get_out_length(cmd);
> -		io_hdr.dxferp = (void *)scsi_get_out_buffer(cmd);
> +		cmd->cmd_sg_iovec.iov_base = scsi_get_out_buffer(cmd);
> +		io_hdr.iovec_count = 1;
>  	} else {
>  		io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
>  		io_hdr.dxfer_len = scsi_get_in_length(cmd);
> -		io_hdr.dxferp = (void *)scsi_get_in_buffer(cmd);
> +		cmd->cmd_sg_iovec.iov_base = scsi_get_in_buffer(cmd);
> +		io_hdr.iovec_count = 1;
>  	}
>  	io_hdr.mx_sb_len = sizeof(cmd->sense_buffer);
>  	io_hdr.sbp = cmd->sense_buffer;
> @@ -154,11 +216,47 @@ static int bs_sg_cmd_submit(struct scsi_cmd *cmd)
>  		set_cmd_async(cmd);
>  	else {
>  		eprintf("failed to start cmd 0x%p\n", cmd);
> -		set_cmd_failed(cmd);
> +		return set_cmd_failed(cmd);
>  	}
>  	return 0;
>  }
>  
> +static void bs_bsg_cmd_complete(int fd, int events, void *data)
> +{
> +	struct sg_io_v4 io_hdr;
> +	struct scsi_cmd *cmd;
> +	int err;
> +
> +	BSG_IO("[%d] bs_bsg_cmd_complete() called!\n", getpid());
> +	memset(&io_hdr, 0, sizeof(io_hdr));
> +	/* [i] 'Q' to differentiate from v3 */
> +	io_hdr.guard = 'Q';
> +
> +	err = graceful_read(fd, &io_hdr, sizeof(io_hdr));
> +	if (err)
> +		return;
> +
> +	cmd = (struct scsi_cmd *)(unsigned long)io_hdr.usr_ptr;
> +	BSG_IO("BSG Using cmd: %p for io_hdr.usr_ptr\n", cmd);
> +	/*
> +	 * Check SCSI: command completion status
> +	 * */
> +	if (!io_hdr.device_status) {
> +		scsi_set_out_resid(cmd, io_hdr.dout_resid);
> +		scsi_set_in_resid(cmd, io_hdr.din_resid);
> +	} else {
> +		/*
> +		 * NAB: Used by linux/block/bsg.c:bsg_ioctl(), is this
> +		 * right..?
> +		 */
> +		cmd->sense_len = SCSI_SENSE_BUFFERSIZE;
> +		scsi_set_out_resid_by_actual(cmd, 0);
> +		scsi_set_in_resid_by_actual(cmd, 0);
> +	}
> +	BSG_IO("[%d] BSG() Calling cmd->scsi_cmd_done()\n", getpid());
> +	cmd->scsi_cmd_done(cmd, io_hdr.device_status);
> +}
> +
>  static void bs_sg_cmd_complete(int fd, int events, void *data)
>  {
>  	struct sg_io_hdr io_hdr;
> @@ -186,6 +284,22 @@ static void bs_sg_cmd_complete(int fd, int events, void *data)
>  	cmd->scsi_cmd_done(cmd, io_hdr.status);
>  }
>  
> +static int chk_bsg_device(char *path)
> +{
> +	struct stat st;
> +
> +	if (stat(path, &st) < 0) {
> +		eprintf("stat() failed errno: %d\n", errno);
> +		return -1;
> +	}
> +
> +	/* This is not yet defined in include/linux/major.h.. */
> +	if (S_ISCHR(st.st_mode) && major(st.st_rdev) == 254)
> +		return 0;
> +
> +	return -1;
> +}
> +
>  static int chk_sg_device(char *path)
>  {
>  	struct stat st;
> @@ -197,8 +311,29 @@ static int chk_sg_device(char *path)
>  
>  	if (S_ISCHR(st.st_mode) && major(st.st_rdev) == SCSI_GENERIC_MAJOR)
>  		return 0;
> -	else
> +
> +	return -1;
> +}
> +
> +static int init_bsg_device(int fd)
> +{
> +	int t, err;
> +
> +	err = ioctl(fd, SG_GET_COMMAND_Q, &t);
> +	if (err < 0) {
> +		eprintf("SG_GET_COMMAND_Q for bsd failed: %d\n", err);
> +		return -1;
> +	}
> +	eprintf("bsg: Using max_queue: %d\n", t);
> +
> +	t = BS_SG_RESVD_SZ;
> +	err = ioctl(fd, SG_SET_RESERVED_SIZE, &t);
> +	if (err < 0) {
> +		eprintf("SG_SET_RESERVED_SIZE errno: %d\n", errno);
>  		return -1;
> +	}
> +
> +	return 0;
>  }
>  
>  static int init_sg_device(int fd)
> @@ -242,9 +377,14 @@ static int bs_sg_init(struct scsi_lu *lu)
>  
>  static int bs_sg_open(struct scsi_lu *lu, char *path, int *fd, uint64_t *size)
>  {
> -	int sg_fd, err;
> -
> -	err = chk_sg_device(path);
> +	void (*cmd_complete)(int, int, void *) = NULL;
> +	int sg_fd, err, bsg = 0;
> +
> +	if ((strstr(path, "/dev/bsg/") != NULL)) {
> +		bsg = 1;
> +		err = chk_bsg_device(path);
> +	} else
> +		err = chk_sg_device(path);
>  	if (err) {
>  		eprintf("Not recognized %s as an SG device\n", path);
>  		return -EINVAL;
> @@ -256,13 +396,19 @@ static int bs_sg_open(struct scsi_lu *lu, char *path, int *fd, uint64_t *size)
>  		return sg_fd;
>  	}
>  
> -	err = init_sg_device(sg_fd);
> +	if (bsg) {
> +		cmd_complete = &bs_bsg_cmd_complete;
> +		err = init_bsg_device(sg_fd);
> +	} else {
> +		cmd_complete = bs_sg_cmd_complete;
> +		err = init_sg_device(sg_fd);
> +	}
>  	if (err) {
>  		eprintf("Failed to initialize sg device %s\n", path);
>  		return err;
>  	}
>  
> -	err = tgt_event_add(sg_fd, EPOLLIN, bs_sg_cmd_complete, NULL);
> +	err = tgt_event_add(sg_fd, EPOLLIN, cmd_complete, NULL);
>  	if (err) {
>  		eprintf("Failed to add sg device event %s\n", path);
>  		return err;
> @@ -302,6 +448,17 @@ static struct backingstore_template sg_bst = {
>  	.bs_cmd_done		= bs_sg_cmd_done,
>  };
>  
> +static struct backingstore_template bsg_bst = {
> +	.bs_name		= "bsg",
> +	.bs_datasize		= 0,
> +	.bs_passthrough		= 1,
> +	.bs_init		= bs_sg_init,
> +	.bs_open		= bs_sg_open,
> +	.bs_close		= bs_sg_close,
> +	.bs_cmd_submit		= bs_bsg_cmd_submit,
> +	.bs_cmd_done		= bs_sg_cmd_done,
> +};
> +
>  static struct device_type_template sg_template = {
>  	.type			= 0,
>  	.lu_init		= bs_sg_lu_init,
> @@ -315,5 +472,6 @@ static struct device_type_template sg_template = {
>  __attribute__((constructor)) static void bs_sg_constructor(void)
>  {
>  	register_backingstore_template(&sg_bst);
> +	register_backingstore_template(&bsg_bst);
>  	device_type_register(&sg_template);
>  }
> diff --git a/usr/scsi_cmnd.h b/usr/scsi_cmnd.h
> index 011f3e6..67a46c3 100644
> --- a/usr/scsi_cmnd.h
> +++ b/usr/scsi_cmnd.h
> @@ -17,6 +17,9 @@ struct scsi_data_buffer {
>  	uint64_t buffer;
>  };
>  
> +#include <scsi/sg.h>
> +#include <linux/bsg.h>
> +
>  struct scsi_cmd {
>  	struct target *c_target;
>  	/* linked it_nexus->cmd_hash_list */
> @@ -31,6 +34,10 @@ struct scsi_cmd {
>  	enum data_direction data_dir;
>  	struct scsi_data_buffer in_sdb;
>  	struct scsi_data_buffer out_sdb;
> +	/* Used for bs_sg.c:bs_bs_cmd_submit() */
> +	struct sg_iovec cmd_sg_iovec;
> +	/* used for bs_sg.c:bs_bsg_cmd_submit() */
> +	struct sg_io_v4 cmd_bsg_hdr;
>  
>  	uint64_t cmd_itn_id;
>  	uint64_t offset;
