From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Incorrect response to SK/ASC/ASCQ = x 02/04/01 (becoming ready)
Date: 26 Aug 2004 11:38:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093534695.1684.28.camel@mulgrave>
References: <Pine.LNX.4.44L0.0408221154220.15992-100000@netrider.rowland.org>
	<1093217548.1727.367.camel@mulgrave>
	<1093218968.3553.17.camel@swtf.comptex.com.au>
	<1093275122.1776.52.camel@mulgrave>  <20040826025453.GA125799@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:40331 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269062AbUHZPi1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 11:38:27 -0400
In-Reply-To: <20040826025453.GA125799@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Burn Alting <burn@goldweb.com.au>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2004-08-25 at 22:54, Jeremy Higdon wrote:
> I believe that 02/04/01 should be treated like a Busy status.  The
> semantics are slightly different, but the action taken by the
> initiator is the same: wait a bit and then retry.

Well, that's dangerous.  BUSY is assumed always to be a transient
condition, so it doesn't count against the retries, so if this thing
never comes back, we'd loop forever there.

The other thing about BUSY handling is that, for a device with no
outstanding commands like this, we retry based on I/O pressure, so even
if I increment the retry count time waited would depend on how much I/O
pressure the system had.

> I have seen this key/asc/asq before and had to handle it that way.
> I believe the device in question was a disk drive that had been
> powered on recently.  Disks set to have a variable spinup delay
> (based on ID, so that not all disks in a 16-drive box power up at
> the same time and overstress a power supply) can return this code
> up to a couple of minutes after power on.

But that's a start of day thing, which would be handled by sd's TUR
code.

James


