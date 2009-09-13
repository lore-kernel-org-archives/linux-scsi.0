From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] hwmon: Driver for SCSI/ATA temperature sensors
Date: Sun, 13 Sep 2009 09:00:53 -0500
Message-ID: <1252850453.23599.13.camel@mulgrave.site>
References: <20090913040104.ab1d0b69.const@mimas.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069AbZIMOBO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Sep 2009 10:01:14 -0400
In-Reply-To: <20090913040104.ab1d0b69.const@mimas.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Constantin Baranov <const@mimas.ru>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, 2009-09-13 at 04:01 +0500, Constantin Baranov wrote:
> The scsitemp module attaches a device to each SCSI device
> and registers it in hwmon. Currently the only method of
> reading temperature is ATA SMART. Adding support of the
> pure SCSI methods is provided.

The code, as you wrote it looks fine.

The basic problem are the effects.  Right at the moment it tries to send
an ATA_16 encapsulated SMART command to every SCSI device in the system.
We simply can't allow this.  A huge number of SCSI presenting USB
devices are known to lock up when they see either ATA_X encapsulation or
SMART commands.  It's not really even safe to send ATA_X to SCSI
devices.  The modern ones should all error out fine, but the older ones
are likely to be less tolerant.

Finally, this:

> +               if (attr[2] == 194) {
> +                       *temp = attr[7] * 1000;
> +                       err = 0;
> +                       break;

Smart attribute 194 is highly vendor specific ... for instance my new
SATA drive doesn't implement it (it does implement 190 instead).

So really, given the complexity of just obtaining the data and the
problem of matching which data to obtain to which device you have, why
not just use smartctl from userspace for monitoring?  you could even
just plug into smartd, it seems to have most of the necessary heuristics
built in already.

James


