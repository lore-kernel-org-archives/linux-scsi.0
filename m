From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: convert to request_firmware interface
Date: Mon, 28 Aug 2006 15:59:54 -0500
Message-ID: <1156798794.3465.27.camel@mulgrave.il.steeleye.com>
References: <1156733286.3460.26.camel@mulgrave.il.steeleye.com>
	 <1156736843.3460.31.camel@mulgrave.il.steeleye.com>
	 <44F2E6F2.2090706@torque.net>
	 <1156773918.3465.7.camel@mulgrave.il.steeleye.com>
	 <44F35586.1040505@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:33179 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932116AbWH1VAA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Aug 2006 17:00:00 -0400
In-Reply-To: <44F35586.1040505@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2006-08-28 at 16:43 -0400, Douglas Gilbert wrote:
> What I'm angling at is a firmware file name like:
>    aic94xx-seq_10c6.req

I don't think that's a good idea ... the current razor firmware is
backwards compatible, so if I hard code a version into the file there'd
be no upgrade ability.

> and the driver attempts to read:
>    aic94xx-seq*.req

It can't do that from the kernel ... this is all conditioned on how the
user level firmware loader actually works

> If there a multiple matches then it takes the one
> with the most recent date (reporting this in syslog).

The way you do this is to have a generic name (aic94xx-seq.fw) and then
symbolically link it to the versioned file.

The firmware itself is versioned, so if the driver comes to require a
particular version (or later), it can be programmed to complain.

James


