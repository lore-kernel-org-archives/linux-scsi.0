From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1][RESEND] Staging: hv: storvsc: Move the storage
 driver out of the staging area
Date: Wed, 11 Jan 2012 05:36:49 -0500
Message-ID: <20120111103649.GB22652@infradead.org>
References: <1325622441-15600-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1325622441-15600-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> +#define STORVSC_MIN_BUF_NR				64

What about a comment explaining what this is for?

> +#define STORVSC_RING_BUFFER_SIZE			(20*PAGE_SIZE)
> +static int storvsc_ringbuffer_size = STORVSC_RING_BUFFER_SIZE;

I don't think you need the #define here.

> +/* to alert the user that structure sizes may be mismatched even though the */
> +/* protocol versions match. */
> +
> +
> +#define REVISION_STRING(REVISION_) #REVISION_
> +#define FILL_VMSTOR_REVISION(RESULT_LVALUE_)				\
> +	do {								\
> +		char *revision_string					\
> +			= REVISION_STRING($Rev : 6 $) + 6;		\
> +		RESULT_LVALUE_ = 0;					\
> +		while (*revision_string >= '0'				\
> +			&& *revision_string <= '9') {			\
> +			RESULT_LVALUE_ *= 10;				\
> +			RESULT_LVALUE_ += *revision_string - '0';	\
> +			revision_string++;				\
> +		}							\
> +	} while (0)
> +

How can these macros work?  I don't think git ever expans $Rev, and in
either case I really don't get how this is supposed to work.

> +/* Major/minor macros.  Minor version is in LSB, meaning that earlier flat */
> +/* version numbers will be interpreted as "0.x" (i.e., 1 becomes 0.1). */

Please use comment formats like this:

/*
 * Blah ....
 * .....
 */

(this also applies to a few other places).

> +#define VMSTOR_PROTOCOL_MAJOR(VERSION_)		(((VERSION_) >> 8) & 0xff)
> +#define VMSTOR_PROTOCOL_MINOR(VERSION_)		(((VERSION_))      & 0xff)
> +#define VMSTOR_PROTOCOL_VERSION(MAJOR_, MINOR_)	((((MAJOR_) & 0xff) << 8) | \
> +						 (((MINOR_) & 0xff)))

All these should be inline functions.

> +#define VMSTOR_INVALID_PROTOCOL_VERSION		(-1)

Not used.

> + * Platform neutral description of a scsi request -
> + * this remains the same across the write regardless of 32/64 bit
> + * note: it's patterned off the SCSI_PASS_THROUGH structure
> + */
> +#define CDB16GENERIC_LENGTH			0x10
> +
> +#ifndef SENSE_BUFFER_SIZE
> +#define SENSE_BUFFER_SIZE			0x12
> +#endif
> +
> +#define MAX_DATA_BUF_LEN_WITH_PADDING		0x14

Please don't conditionally re-use the SCSI-layer SENSE_BUFFER_SIZE for
your on the wire packets, but define your own.  Please also give all
theses constants a VMSCSI_ or similar prefix.

> +struct vmscsi_request {
> +	unsigned short length;
> +	unsigned char srb_status;
> +	unsigned char scsi_status;
> +
> +	unsigned char port_number;
> +	unsigned char path_id;
> +	unsigned char target_id;
> +	unsigned char lun;
> +
> +	unsigned char cdb_length;
> +	unsigned char sense_info_length;
> +	unsigned char data_in;
> +	unsigned char reserved;
> +
> +	unsigned int data_transfer_length;
> +
> +	union {
> +		unsigned char cdb[CDB16GENERIC_LENGTH];
> +		unsigned char sense_data[SENSE_BUFFER_SIZE];
> +		unsigned char reserved_array[MAX_DATA_BUF_LEN_WITH_PADDING];
> +	};
> +} __attribute((packed));

Please use fixed size u8/16/32/etc types for all the on-wire defintions.

I'd also really recommend splitting the actual protocol defintion in
a header separate from the driver implementation to make it clear what
is part of the protocol and what's internal to the driver.

> +/*  This is the set of flags that the vsc can set in any packets it sends */
> +#define VSC_LEGAL_FLAGS		(REQUEST_COMPLETION_FLAG)

unused.

> +#define STORVSC_MAX_CMD_LEN				16

This seems to duplicate the CDB16GENERIC_LENGTH define used above,
please make sure you only have one #define for this constant.

> +
> +/* Matches Windows-end */
> +enum storvsc_request_type {
> +	WRITE_TYPE,
> +	READ_TYPE,
> +	UNKNOWN_TYPE,
> +};

For enums specifying the protocol please always use explicit values.


> +struct hv_storvsc_request {
> +	struct hv_device *device;
> +
> +	/* Synchronize the request/response if needed */
> +	struct completion wait_event;
> +
> +	unsigned char *sense_buffer;
> +	void *context;

This always is a struct storvsc_cmd_request, and should be typed as
such.

> +	void (*on_io_completion)(struct hv_storvsc_request *request);

This always points to storvsc_command_completion, so please remove the
indirect call and use it directly.

> +	struct hv_multipage_buffer data_buffer;
> +
> +	struct vstor_packet vstor_packet;
> +};


Btw, what is the reason that storvsc_cmd_request and hv_storvsc_request
are separate structures and not merged into one?  This wastes a tiny
amount of memory for the init/reset requests, but keeps the code
a lot simpler.


> +static inline struct storvsc_device *get_out_stor_device(
> +					struct hv_device *device)

> +static inline struct storvsc_device *get_in_stor_device(
> +					struct hv_device *device)

I'm pretty sure you defended this odd reference counting scheme last
time the discussion came up, but please write up a long comment in
the code explaning it so that the question doesn't come up again
all the time.


> +	/*
> +	 * The current SCSI handling on the host side does
> +	 * not correctly handle:
> +	 * INQUIRY command with page code parameter set to 0x80
> +	 * MODE_SENSE command with cmd[2] == 0x1c
> +	 *
> +	 * Setup srb and scsi status so this won't be fatal.
> +	 * We do this so we can distinguish truly fatal failues
> +	 * (srb status == 0x4) and off-line the device in that case.
> +	 */
> +
> +	if ((stor_pkt->vm_srb.cdb[0] == INQUIRY) ||
> +		(stor_pkt->vm_srb.cdb[0] == MODE_SENSE)) {

This should be:

	if (stor_pkt->vm_srb.cdb[0] == INQUIRY ||
	    stor_pkt->vm_srb.cdb[0] == MODE_SENSE) {

or even better use a switch statement to clarify what's going on.


> +static int storvsc_remove(struct hv_device *dev)
> +{
> +	struct storvsc_device *stor_device = hv_get_drvdata(dev);
> +	struct Scsi_Host *host = stor_device->host;
> +
> +	scsi_remove_host(host);
> +
> +	scsi_host_put(host);
> +
> +	storvsc_dev_remove(dev);
> +
> +	return 0;
> +}

Why isn't this near storvcs_probe at the end of the file given that
they logically belong together?  Also please only do the scsi_host_put
once you are fully done with it, that is after storvsc_dev_remove.

> +/*
> + * storvsc_host_reset_handler - Reset the scsi HBA
> + */
> +static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
> +{
> +	struct hv_host_device *host_dev = shost_priv(scmnd->device->host);
> +	struct hv_device *dev = host_dev->dev;
> +
> +	return storvsc_host_reset(dev);
> +}

Why is storvsc_host_reset split from this function?  Also the comment
really doesn't tell us anything, I'd rather leave it away.


> +/*
> + * storvsc_command_completion - Command completion processing
> + */
> +static void storvsc_command_completion(struct hv_storvsc_request *request)

I really don't see how this comment adds any value over the pure
function name.


> +	if (vm_srb->srb_status == 0x4)

> +	if (vm_srb->srb_status == 0x20) {

Please add defines for the vm_srb->srb_status values.

> +static bool storvsc_check_scsi_cmd(struct scsi_cmnd *scmnd)

Please call this storvsc_ignore_command or similar to make the use more
obvious.

> +	/* If retrying, no need to prep the cmd */
> +	if (scmnd->host_scribble) {
> +
> +		cmd_request =
> +			(struct storvsc_cmd_request *)scmnd->host_scribble;
> +
> +		goto retry_request;
> +	}

I don't think this can ever happen given that you make sure to always
clear ->host_scribble when returning SCSI_MLQUEUE_*_BUSY.

> +	request_size = sizeof(struct storvsc_cmd_request);
> +
> +	cmd_request = mempool_alloc(memp->request_mempool,
> +				       GFP_ATOMIC);
> +	if (!cmd_request)
> +		return SCSI_MLQUEUE_DEVICE_BUSY;

The point of the mempool allocator is that it will never return NULL.

> +
> +	memset(cmd_request, 0, sizeof(struct storvsc_cmd_request));
> +
> +	/* Setup the cmd request */
> +	cmd_request->bounce_sgl_count = 0;
> +	cmd_request->bounce_sgl = NULL;
> +	cmd_request->cmd = scmnd;

Either use memset for the whole structure, or set the fields that need
it to 0 explicitly, but not both.  I doubt it's more efficient to only
initialise the fields that need it.

> +			if (!cmd_request->bounce_sgl) {
> +				scmnd->host_scribble = NULL;
> +				mempool_free(cmd_request,
> +						memp->request_mempool);
> +
> +				return SCSI_MLQUEUE_HOST_BUSY;
> +			}



> +		if (cmd_request->bounce_sgl_count)
> +			destroy_bounce_buffer(cmd_request->bounce_sgl,
> +					cmd_request->bounce_sgl_count);
> +
> +		mempool_free(cmd_request, memp->request_mempool);
> +
> +		scmnd->host_scribble = NULL;
> +
> +		ret = SCSI_MLQUEUE_DEVICE_BUSY;

Please use goto labels and a single error exit for unwindining on
failure.

> +/* Scsi driver */

Not a useful comment, just remove it.

> +/*
> + * storvsc_probe - Add a new device for this driver
> + */

Not a very useful comment, just remove it.

> +	if (dev_is_ide)
> +		storvsc_get_ide_info(device, &target, &path);

path is never used, so drop that argument from storvsc_get_ide_info
please.  Target is only used in the next dev_is_ide block, so please
move this call to it.

> +	/* max # of devices per target */
> +	host->max_lun = STORVSC_MAX_LUNS_PER_TARGET;
> +	/* max # of targets per channel */
> +	host->max_id = STORVSC_MAX_TARGETS;
> +	/* max # of channels */
> +	host->max_channel = STORVSC_MAX_CHANNELS - 1;
> +	/* max cmd length */
> +	host->max_cmd_len = STORVSC_MAX_CMD_LEN;

Any reason these aren't set directly in the host template?

> +	if (!dev_is_ide) {
> +		scsi_scan_host(host);
> +		return 0;
> +	}
> +	ret = scsi_add_device(host, 0, target, 0);
> +	if (ret) {
> +		scsi_remove_host(host);
> +		goto err_out2;
> +	}
> +	return 0;

I'd write this as an if/else block to be be more clear.


> +/* The one and only one */

this isn't an overly useful comment.
