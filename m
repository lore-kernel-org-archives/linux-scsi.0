From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down
 disk
Date: Fri, 28 Sep 2007 17:11:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709281705180.7142-100000@iolanthe.rowland.org>
References: <200709281022.17322.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44528 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750863AbXI1VLx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2007 17:11:53 -0400
In-Reply-To: <200709281022.17322.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Fri, 28 Sep 2007, Oliver Neukum wrote:

> Am Donnerstag 27 September 2007 schrieb Alan Stern:
> > Have you thought about how autoresume would fit into this picture? =
=A0I
> > don't think you can rely on usb-storage telling the SCSI core to re=
sume
> > devices when it gets handed a command, because the commands to spin=
-up
> > the drives would have to be transmitted first. =A0(The sample patch=
 you

I had another look at your patch.  It calls scsi_device_quiesce(),=20
which causes all normal requests to be deferred.  Hence under normal=20
operation the device would never autoresume -- user requests would be=20
deferred and never sent to usb-storage.

It will be necessary to modify scsi_prep_fn(), so that if the device is
in the SDEV_QUIESCE state because of autosuspend when a request
arrives, a workqueue routine initiates an autoresume.

Alan Stern

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
