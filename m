From: Chris Webb <chris@arachsys.com>
Subject: Re: scsi_wait_scan not working (2.6.30.5)
Date: Wed, 26 Aug 2009 17:23:01 +0100
Message-ID: <20090826162301.GA2877@arachsys.com>
References: <200908252124.22562.a.miskiewicz@gmail.com> <1251228529.7539.8.camel@mulgrave.site> <20090826143431.GA4368@arachsys.com> <1251301226.4205.10.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alpha.arachsys.com ([91.203.57.7]:42809 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbZHZQXE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Aug 2009 12:23:04 -0400
Content-Disposition: inline
In-Reply-To: <1251301226.4205.10.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>, linux-scsi@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>

James Bottomley <James.Bottomley@suse.de> writes:

> The way it's supposed to work is that you listen for the uevent that
> signals the sd binding is complete, so you actually get notice
> asynchronously.  The event carries device information with it.  udev
> uses the node information to send VPD inquiries, which is how it does
> the by-id and by-uuid mappings.

Quite hard to sit down and actually write a shell script to do this, though!

It feels like the operation of logging into an iscsi target, waiting for the
device node and then returning it is something you'd reasonably expect to be
able to do, but it's become quite tricky in this async world. Netlink isn't
at all accessible to scripts, and udevadm doesn't provide a good front-end
to do it either.

When something like a USB device being plugged in, the operation is
fundamentally asynchronous, but with an iscsi login, the device is appearing
because you've run a login command, so it's not completely mad to hope to be
get back the ultimate result of that command, even if you have to wait for
it.

Cheers,

Chris.
