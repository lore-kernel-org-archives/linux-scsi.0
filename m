From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH v2] sg: add SG_FLAG_Q_AT_TAIL flag
Date: Thu, 5 Jun 2014 12:16:59 -0500
Message-ID: <5390A60B.6030009@tributary.com>
References: <538F3416.5090306@interlog.com> <53908C46.8080308@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.55]:27656 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbaFERWZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2014 13:22:25 -0400
In-Reply-To: <53908C46.8080308@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <openosd@gmail.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, James Bottomley <JBottomley@parallels.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 6/5/2014 10:27 AM, Boaz Harrosh wrote:

> 1. aio "scatter_gather" type io. (ie multiple pointers multiple length
> buffers that are written / read from same linear range on device) [The
> async aspect of aio can be implemented via bsg with the write+read system
> calls] 2. mmap of direct device range to user vm memory

	I suspect that belies a bit of a gap in the understanding of the kinds of
applications that use pass-through (vs just using sd, or using it for a guest OS).

	These use cases don't tend to be useful for things like SCSI changers, tape
devices, or SES devices. What is useful is the ability to reset devices, or
maybe some of the other "edge" features provided by SG that never managed to
make it into bsg. Nor are they useful for the monitoring type applications
that use pass-through to pull some vendor specific statistic or device state.

	Furthermore, i've see a fair number of cases where people slap together shell
scripts using the /dev/sg* handles instead of the /dev/bsg/* ones probably
because its simply more convenient.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTkKYLAAoJEL5i86xrzcy78ZEIAK9s8hcgtX3bloYbW+09OHWu
M12ySzk6hEOvJcGZwoBobkG5q9cHPk1ehaCtzaTE5MlBaSOSfg+AAHVUusr3PUZR
REmwS+eBZu6wRghXPE6c0oLuBulQ1FeJXkDsfuRhkaoBfZxfc/BiTEb67CCbHPm4
gT34VCiVRB0G0Sp5rnu9S9f1LvRmF2DoMCK+CmCBNh0q/dD3EskQJOh5c9sAKHKJ
0TO1LyuRj5jUILgOma/gHX3LHa7JN9EE+DKK5mm8s75vMKwv8FpWMc6B9LeOfcIn
XDDMM5tdrtbXMvZ6M5jp+bhbnoydxhRHgXBpiTMe3ze4VZXXLdmSBX/am9oVhKA=
=TdvH
-----END PGP SIGNATURE-----
