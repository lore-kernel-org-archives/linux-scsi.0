From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: suspending I/Os to a device
Date: 23 Apr 2004 19:28:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082762917.1615.17.camel@mulgrave>
References: <8D43EFD7CCBDB24980134BE078C227E704E37A82@xcm.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:30920 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261704AbUDWX3d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Apr 2004 19:29:33 -0400
In-Reply-To: <8D43EFD7CCBDB24980134BE078C227E704E37A82@xcm.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Infante, Jon" <Jon.Infante@Emulex.Com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

On Fri, 2004-04-23 at 18:12, Infante, Jon wrote:
> Here is the senerio I am trying to handle within our Fibre Channel driver.
> In Fibre Channel, it is possible for the Target, or HBA, to be disconnected
> from one port on a switch and plugged into another port on the same (or even
> a different) switch. This transitition can happen with live traffic and the
> scsi subsystem / driver is supposed to recover gracefully, without failing
> all I/Os back up to applications that are running. In order to accomplish
> this, there is a configurable timer, that tells the driver how long to wait
> (at the Fibre Channel level), when a device disappears, to give it a chance
> to come back. Some OEMs / environments set this to a couple seconds, some a
> to couple of minutes.

Actually, there is no interface because no-one has had any prior
requirements for this.

This is effectively a FC specific thing, and I believe you know because
you get a lip event telling you the target has gone, so it sounds like
the ideal thing to handle in the FC transport class (since it would
apply to all FC HBAs) The target reconnect timeout would then be a
transport class property and we'd start failing I/Os when it expired.  I
would guess there needs to be an additional state in the device state
model like SUSPEND (QUIESCE doesn't quite fit because it allows the
pending queue to drain and the error handler to operate), but we can
accomodate that.

By default, I would think the reconnect timeout should be zero because
most FC operates in a multi-path environment and you want path failure
notifications as fast as possible, so users requiring this feature would
need to set the timeout.

James


