From: James.Smart@Emulex.Com
Subject: RE: [PATCH] for Deadlock in transport_fc
Date: Thu, 9 Jun 2005 10:05:48 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AC67@xbl3.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:47500 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S262403AbVFIOGA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jun 2005 10:06:00 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bstroesser@fujitsu-siemens.com
Cc: linux-scsi@vger.kernel.org, hch@infradead.org



> Thank you for the explanations. We tested a bit more and 
> found out, that
> one has to wait lpfc_nodev_tmo seconds between disconnecting 
> one target
> from the fabric and connecting the other.
> As this might be done quite fast in our tests, we now set 
> lpfc_nodev_tmo
> to 1, and it seems to work fine. Is there any risk with such a short
> timer?

The risk of setting this too low is that normal links may occur where
the port disappears for longer than 1 second. If so, the lpfc driver
will notify the transport of a loss of the port, which will tear down
the target and all luns. In your test case, it's what you wanted.
In otherwise normal scenarios, it may not be.  If it did occur, and
the port came back, discovery should see it, re-add the port with the
transport, kick off the scsi scan, and enumerate the target and luns
again.  Beware though- if you are not using udev, name shift may occur.

> For my understanding: what is "echo 1 > 
> sys/class/scsi_host/host1/issue_lip"?
> When we used it after not having waited for nodev_tmo, it 
> didn't cause a
> rescan (i.e., the target still had the old wwpn).

This either injects a LIP if the topology is loop, or bounces the link if
the topology is pt-2-pt. Discovery has to then kick in and complete before
changes would be seen.

> 
> BTW: at least once when we disconnected one target and 
> connected the other
> without waiting for nodev_tmo, we saw the situation, that the 
> new target was
> accessible, while sysfs still showed us the old wwpn.

We ought to track this further offline. There's more detail I'd like to
get from you to ensure there isn't an error here.

-- james s
