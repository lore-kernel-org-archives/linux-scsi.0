From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH/RFT] mode sense madness always use page 8
Date: 03 Nov 2003 14:40:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067895603.2303.42.camel@patrh9>
References: <20031030100501.A7250@beaverton.ibm.com>
	 <Pine.LNX.4.44L0.0310301351380.1440-100000@ida.rowland.org>
	 <20031030112621.A7844@beaverton.ibm.com>  <1067632701.5742.45.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:50351 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263453AbTKCVkT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Nov 2003 16:40:19 -0500
In-Reply-To: <1067632701.5742.45.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: stern@rowland.harvard.edu, ronald@kuetemeier.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com

> > per Pat L's comment, should we decrement the
> > len by four if going from MODE SENSE 10 to
> > MODE SENSE? Or request four more bytes than
> > required?

Hang on a minute.  I began to write this patch but I stumbled. I now
think I see:

We either need more complex rounding or no rounding at all?

Any votes for no rounding at all?

How about we add a parm to __scsi_mode_sense so that we specify one byte
length for our default of op x5A MODE_SENSE_10 and another length for
the choice of op x1A MODE_SENSE?

I argue as follows:

255 is xFF.

Op x5A MODE_SENSE_10 for xFF bytes makes no sense.

If we want max, then max is xFFFF for op x5A, not xFF as it was for op
x1A MODE_SENSE.  If we want as many page bytes as in op x1A MODE_SENSE,
then because the header grew four bytes, x103 gives us that, not xFF.

> Tell me again what we think __scsi_mode_sense does?

Again I am grepping in 2.6.0-test9 drivers/scsi/ and leaping to
conclusions without having injected drive errors and collecting traces.

Into sd_read_cache_type we have coded only the t10 fiction that we can
fetch a header and it encodes the available length of bytes as an
additional length:

const int dbd = 0; ...
const int modepage = 0x08; ...
res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, 4, &data);
res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, len, &data);

In sd_read_write_protect_flag we try that t10 fiction first for page
x3F, then page x00, then we instead we try xFF, which is max only if the
op happens to be x1A MODE_SENSE and not x5A MODE_SENSE_10:

res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 4, &data);
res = sd_do_mode_sense(SRpnt, 0, 0, buffer, 4, &data);
res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 255, &data);

The op x1A MODE_SENSE interpretations of these appear reasonable:

-i 4 -y "1A 00:08:00 04 00"
-i x$len -y "1A 00:08:00 $len 00"

-i 4 -y "1A 00:3F:00 04 00"
-i 4 -y "1A 00:00:00 04 00"
-i xFF -y "1A 00:3F:00 FF 00"

The translation to op x5A MODE_SENSE appears incomplete:

-i 4 -y "5A 00 08:00:00:00 00 00:04 00"
-i x$hi$lo -y "5A 00 08:00:00:00 00 $hi:$lo 00"

-i 4 -y "5A 00 3F:00:00:00 00 00:04 00"
-i 4 -y "5A 00 00:00:00:00 00 00:04 00"
-i xFF -y "5A 00 3F:00:00:00 00 00:FF 00"

In 2.6.0-test9, we round up 4 to 8, but we do not round up xFF to
xFFFF.  If per Alan S' comments we dislike rounding up the allocated len
parm of a buffer parm, we could ask for 8 and xFFFF rather than 4 and
xFF, and round down.

But do we ever want to ask for xFFFF?  Why???

Tell me again what we think sd_do_mode_sense does?

Pat LaVarre


