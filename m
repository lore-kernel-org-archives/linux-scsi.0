From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] storvsc: add more logging for error and warning messages
Date: Thu, 03 Dec 2015 18:28:13 -0800
Message-ID: <1449196093.17296.36.camel@perches.com>
References: <1449200865-20694-1-git-send-email-longli@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449200865-20694-1-git-send-email-longli@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Long Li <longli@microsoft.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: devel@linuxdriverproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-12-03 at 19:47 -0800, Long Li wrote:
> Introduce a logging level for storvsc to log certain error/warning
> messages. Those messages are helpful in some environments, e.g.
> Microsoft Azure, for customer support and troubleshooting purposes.
[]
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
[]
> +static inline bool do_logging(int level)
> +{
> +	return (logging_level >=3D level) ? true : false;

The ternary is not necessary

	return logging_level >=3D level;

is enough

> +}
> +
> +
> =A0struct vmscsi_win8_extension {
> =A0	/*
> =A0	=A0* The following were added in Windows 8
> @@ -1183,7 +1198,7 @@ static void storvsc_command_completion(struct s=
torvsc_cmd_request *cmd_request)
> =A0
> =A0	scmnd->result =3D vm_srb->scsi_status;
> =A0
> -	if (scmnd->result) {
> +	if (scmnd->result && do_logging(STORVSC_LOGGING_ERROR)) {
> =A0		if (scsi_normalize_sense(scmnd->sense_buffer,
> =A0				SCSI_SENSE_BUFFERSIZE, &sense_hdr))
> =A0			scsi_print_sense_hdr(scmnd->device, "storvsc",

Is it appropriate to make this scsi_normalize_sense call
conditional on do_logging here?

> @@ -1239,12 +1254,25 @@ static void storvsc_on_io_completion(struct h=
v_device *device,
> =A0	stor_pkt->vm_srb.sense_info_length =3D
> =A0	vstor_packet->vm_srb.sense_info_length;
> =A0
> +	if (vstor_packet->vm_srb.scsi_status !=3D 0 ||
> +		vstor_packet->vm_srb.srb_status !=3D SRB_STATUS_SUCCESS)
> +		if (do_logging(STORVSC_LOGGING_WARN))
> +			dev_warn(&device->device,
> +				"cmd 0x%x scsi status 0x%x srb status 0x%x\n",
> +				stor_pkt->vm_srb.cdb[0],
> +				vstor_packet->vm_srb.scsi_status,
> +				vstor_packet->vm_srb.srb_status);

It might make some sense to use another macro indirection like

#define svc_log_warn(dev, level, fmt, ...)			\
do {								\
	if (do_logging(STORSVC_LOGGING_##level)			\
		dev_warn(&(dev)->device, fmt, ##__VA_ARGS__);	\
} while (0)

So a use could be:

	if (vstore_packet...)
		svc_log_warn(device, WARN, ...);

>=20
