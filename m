From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 2.6.2-rc2 - MPT Fusion driver 3.00.02 update
Date: 28 Jan 2004 15:08:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075316397.1739.15.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E5703D19D33@exa-atlanta.se.lsil.com>
	<1075136727.2290.48.camel@mulgrave>  <401625CA.1070404@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:19605 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265923AbUA1UIf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2004 15:08:35 -0500
In-Reply-To: <401625CA.1070404@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: "Moore, Eric Dean" <Emoore@lsil.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, hch@infradead.org

On Tue, 2004-01-27 at 02:48, Douglas Gilbert wrote:
> So the sg (or SG_IO/SCSI_IOCTL_SEND_COMMAND ioctl) user controls
> the data direction and they are free to get it wrong:-)

Since we do have a mid layer library for this, perhaps we should set it
in sg if the user leaves it apparently unset.

> ** The Object Storage Device (OSD) commands use bidirectional
> data transfers so perhaps we should think about catering for
> that.

Actually, a much more fundamental problem for OSD is going to be >16
byte CDBs.  The mid and block layers today are coded with an internal 16
byte array for the CDB.  That's not very scaleable to the hundreds of
bytes that OSD needs.

As far as bidirectional goes, we should be able to support that today
providing there's just a *single* data buffer, which the OSD spec
implies is the easiest way to support this (although I suspect most SCSI
processor coding won't be expecting to see both a data in and a data out
from a single command).

As I see it, OSD seems to require a different interface from the current
bio layer, so there would be some type of object layer glue between the
fs and the mid-layer, with the block layer relegated simply to queueing
specials for the mid-layer, but since no-one's actually come forward
with an implementation, that's just a guess.

James


