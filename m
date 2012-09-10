From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH v6 1/7] scsi: sr: support runtime pm for ODD
Date: Mon, 10 Sep 2012 12:45:51 +0200
Message-ID: <4663685.bsC7gzLV6E@linux-lqwf.site>
References: <Pine.LNX.4.44L0.1209061437050.1182-100000@iolanthe.rowland.org> <504DAFE6.50507@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <504DAFE6.50507@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday 10 September 2012 17:16:22 Aaron Lu wrote:

> +static int sr_resume(struct device *dev)
> +{
> +	struct scsi_cd *cd;
> +	struct scsi_sense_hdr sshdr;
> +
> +	cd = dev_get_drvdata(dev);
> +
> +	if (!cd->device->powered_off)
> +		return 0;
> +
> +	/* get the disk ready */
> +	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
> +
> +	/* if user wakes up the ODD, eject the tray */
> +	if (cd->device->need_eject) {
> +		cd->device->need_eject = 0;
> +		if (!(cd->cdi.mask & CDC_CLOSE_TRAY))
> +			sr_tray_move(&cd->cdi, 1);

1. Even if the door is locked?
2. sr_tray_move allocates memory with GFP_KERNEL. This smells of a deadlock.

	Regards
		Oliver

