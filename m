From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC] Implementation of SCSI dynamic power management
Date: Wed, 9 Jan 2008 17:11:32 +0100
Message-ID: <200801091711.33394.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0801071244180.2748-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:51245 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYAIQK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 11:10:59 -0500
In-Reply-To: <Pine.LNX.4.44L0.0801071244180.2748-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>

Am Montag, 7. Januar 2008 20:42:23 schrieb Alan Stern:
> When all the devices under a host are suspended, the LLD is informed=20
> (via a new "autosuspend" method in the host template) so that it can=20
> put the host adapter in a low-power state. =A0Likewise, a new=20
> "autoresume" method is called when the host adapter needs to return t=
o=20
> full power. =A0An implementation of these methods for the usb-storage=
=20
> driver will be posted in a followup patch.

This has an interesting implication. As the storage driver can share
a device with in principle any other usb driver, we must audit all usb
drivers if we wish to adopt this patch.
All a device's interfaces must be resumed when the storage interface
is resumed. To resume a storage device no memory must be allocated
because that could deadlock.

	Regards
		Oliver

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
