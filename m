From: "'Patrick Mansfield'" <patmans@us.ibm.com>
Subject: Re: How to add/drop SCSI drives from within the driver?
Date: Wed, 26 Jan 2005 23:05:50 -0800
Message-ID: <20050127070550.GA18632@us.ibm.com>
References: <0E3FA95632D6D047BA649F95DAB60E5705B83A31@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:1535 "EHLO e33.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S262509AbVA0HG2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jan 2005 02:06:28 -0500
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5705B83A31@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: 'Greg KH' <greg@kroah.com>, 'James Bottomley' <James.Bottomley@steeleye.com>, 'Linux Kernel' <linux-kernel@vger.kernel.org>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, linux-hotplug-devel@lists.sourceforge.net

[moving to hotplug list ...]

On Wed, Jan 26, 2005 at 06:23:16PM -0500, Mukker, Atul wrote:

> Or more likely, by placing our agent in /etc/dev.d directory. Unfortunately,
> there seems be not a consensus here as well. On system has "default" and
> "net" directories and other has "block", "input", "net", "tty"?

Those are all kernel subsystem names, and as such all are supported
directory structures for udev, the part that is distro specific is that
they supply different scripts.

There won't be any "scsi" devices since they have no dev (the upper level
drivers have them); sg shows up as scsi_generic. sd is block.

You will still have to figure out via sysfs if you want to run your agent
even for subsystem block (i.e. figure out the host/driver type, I assume
you don't want to run it on hd or standard scsi disk drives).

I don't know why this is an issue for "new" devices, this should be a
problem for you when they first show up; existing and new devs should be
handled the same way.

-- Patrick Mansfield
