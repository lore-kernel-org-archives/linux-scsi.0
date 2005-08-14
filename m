From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] add transport class symlink to device object
Date: Sun, 14 Aug 2005 09:17:50 -0500
Message-ID: <1124029070.18802.6.camel@mulgrave>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AD36@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:36289 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932532AbVHNOSG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Aug 2005 10:18:06 -0400
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AD36@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2005-08-14 at 08:42 -0400, James.Smart@Emulex.Com wrote:
> I'll trust that James B's fix resolves things. Thought my testing was
> straight-forward and ok. Guess not. Humbled again as a mere mortal in
> the world of sysfs and transport/container logic... :)

Well ... I confidently predict that you only tested in an all fibre
environment.  The bug only shows up with scanning (which we no longer do
for fibre).

> - Visually, I get more meaning out of seeing the class's name, than
>   what is usually a redundant object name (many device and class
>   objects have the same name).

This is also an argument for a directory rather than a prefix.

> - If a device could ever be associated with more than 1 class, it's
>   supported (and no issues of name collision).

This is a killer reason for not using the other class.  We allow this,
and already have several examples.  The host device, for instance is a
member of both the spi_host class and the scsi_host class.  Indeed, you
can see the problem with Greg's original patch:

titanic:~# ls -l /sys/class/scsi_host/host0/device/
total 0
lrwxrwxrwx  1 root root 0 Aug 14 09:05 host0 -> ../../../../class/spi_host/host0
lrwxrwxrwx  1 root root 0 Aug 14 09:05 host0 -> ../../../../class/spi_host/host0
drwxr-xr-x  2 root root 0 Aug 14 09:02 power

In fact, not naming the link after the class is particularly daft since
the object is to tell you what classes a device belongs to.

By contrast, this is what you get under James' patch:

titanic:~# ls -l /sys/class/scsi_host/host0/device/
total 0
lrwxrwxrwx  1 root root 0 Aug 14 09:16 class:scsi_host -> ../../../../class/scsi_host/host0
lrwxrwxrwx  1 root root 0 Aug 14 09:16 class:spi_host -> ../../../../class/spi_host/host0
drwxr-xr-x  2 root root 0 Aug 14 09:13 power

> - The prefix of "class:" highlights what it is; makes it harder to lose
>   in a long list of attributes; gives a simple handle for regex
>   parsing (ex: "ls class*"); and helps avoid name collision with other
>   attributes.

> - The class object's name is always derivable from what the symlink
>   points to.

Again, I think this one is a requirement.

James


