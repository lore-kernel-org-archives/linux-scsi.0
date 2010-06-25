From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH RFC] support sata odd zero power
Date: Fri, 25 Jun 2010 10:01:18 -0400
Message-ID: <1277474478.5234.98.camel@mulgrave.site>
References: <AANLkTimajvNh3frP9LcytXUhFAGk1gB52wa0LlGe0ZS0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53318 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386Ab0FYOBY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jun 2010 10:01:24 -0400
In-Reply-To: <AANLkTimajvNh3frP9LcytXUhFAGk1gB52wa0LlGe0ZS0@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: su henry <henry.su.ati@gmail.com>
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, htejun <htejun@gmail.com>

On Fri, 2010-06-25 at 18:15 +0800, su henry wrote:
> From b221e73b802ccfe5338b575dc0ff3b687acdd6fa Mon Sep 17 00:00:00 2001
> From: henry su <henry.su.ati@gmail.com>
> Date: Fri, 25 Jun 2010 00:08:42 +0800
> Subject: [PATCH RFC] support sata odd zero power
> 
> In order to extend the battery life of Mobile PC system, the host should remove
> the power supply to the Optical Disc Drive (logical unit) when it detects the
> logical unit with no media and tray closed, and the host starts the power
> supply to the logical unit when it detects user action to the logical unit that
> the power supply is omitted.

> The patch evaluates the _PS3 method to remove the power supply to the ODD if
> the host detects MEDIUM NOT PRESENT - TRAY CLOSED is reported by REQUEST SENSE
> command for a Drawer, Tray or Pop-up type drive, or MEDIUM NOT PRESENT -
> TRAY CLOSED for a slot/caddy type drive; on the other hand, the patch evaluates
> the _PS0 method to restart the power supply to the ODD when the user
> presses the
> button on a tray type drive or inserts a CD to a slot/caddy type drive.
> 
> PLDS DS-8A5S, pansonic UJ892 and UJ897 are the ODD samples used to test
> the patch on AMD SB800 platforms.
> 
> Signed-off-by: Henry Su <henry.su.ati@gmail.com>

The first observation I'd have is a big meta one:  This all needs to
work on non ACPI systems ... given that it relies on unstubbed ACPI
functions, I don't think it does, does it?

What I'd suggest is confining it all to sr_acpi.c and hooking it in to
the test unit ready and init/exit ... that way the code only need be
present if ACPI is.

[...]
> @@ -786,6 +853,7 @@ static void get_capabilities(struct scsi_cd *cd)
>  	}
> 
>  	n = data.header_length + data.block_descriptor_length;
> +	sr_zpodd_device.mechtype = buffer[n + 6] >> 5;
>  	cd->cdi.speed = ((buffer[n + 8] << 8) + buffer[n + 9]) / 176;
>  	cd->readcd_known = 1;
>  	cd->readcd_cdda = buffer[n + 5] & 0x01;

This piece of data should probably be added to struct scsi_cd .. we
already use it in the routine anyway for printing out the tray type.

James


