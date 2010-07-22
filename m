From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH resend 3/4] scsi/sd: Add a no_read_capacity_16 scsi_device
 flag
Date: Thu, 22 Jul 2010 19:16:08 +0400
Message-ID: <4C4860B8.70205@ru.mvista.com>
References: <1279811521-11372-1-git-send-email-hdegoede@redhat.com> <1279811521-11372-3-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37091 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab0GVPRH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2010 11:17:07 -0400
In-Reply-To: <1279811521-11372-3-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: James.Bottomley@suse.de, Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

Hello.

Hans de Goede wrote:

> I know I know, I seem to have a nack for digging up buggy usb devices
> which don't work with Linux, and I'm crazy enough to try to make them
> work. So this time a friend of mine asked me to get an mp4 player (an
> mp3 player which can play videos on a small screen) to work with Linux.

> It is based on the well known rockbox chipset for which we already have
> an unusual devs entries to work around some of its bugs. But this model
> comes with an additional twist.

> This model chokes on read_capacity_16 calls. Now normally we don't make
> those calls, but this model comes with an sdcard slot and when there
> is no card in there (and shipped from the factory there is none), it
> reports a size of 0. However this time the programmers actually
> got the read_capacity_10 response right! So they substract one from
> the size as stored internally in the mp3 player before reporting it back,
> resulting in an answer of ... 0xffffffff sectors, causing sd.c to
> try a read_capacity_16, on which the device crashes.

> This patch adds a flag to scsi_device to indicate that a a device cannot
> handle read_capacity_16, and when this flag is set if a device reports
> an lba of 0xffffffff as answer to a read_capacity_10, assumes it tries
> to report a size of 0.

> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
[...]
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 8802e48..1ad339b 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
[...]
> @@ -1578,6 +1581,15 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  	sector_size = get_unaligned_be32(&buffer[4]);
>  	lba = get_unaligned_be32(&buffer[0]);
>  
> +	if (sdp->no_read_capacity_16 && (lba == 0xffffffff)) {

    Parens around == are not necessary.

> +		/* Some buggy (usb cardreader) devices return an lba of
> +		   0xffffffff when the want to report a size of 0 (with
> +		   which they really mean no media is present) */

    According to CodingStyle, the preferred format of the multi-line comments 
is this:

/*
  * bla
  * bla
  */

WBR, Sergei
