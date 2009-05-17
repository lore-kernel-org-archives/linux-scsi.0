From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: /dev/megadev0 missing with 2.6.26 kernel megaraid_mm
Date: Sun, 17 May 2009 14:19:41 -0500
Message-ID: <1242587981.11755.11.camel@mulgrave.int.hansenpartnership.com>
References: <20090517172833.GA9759@lamity.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56984 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958AbZEQTTk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 May 2009 15:19:40 -0400
In-Reply-To: <20090517172833.GA9759@lamity.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Pearson <chris-linux-scsi@twock.com>
Cc: linux-scsi@vger.kernel.org

On Sun, 2009-05-17 at 18:28 +0100, Chris Pearson wrote:
> I have a Dell PowerEdge 2850 that was running Debian with a 2.4 kernel.
> I have just upgraded it to 2.6.26 and as part of that upgrade also begun
> using udev.  I am unsure whether this is a udev problem or a kernel
> problem.
> 
> With 2.4 I used to have a block device "megadev" in /proc/devices which
> the Dell/LSI scripts use to communicate with the PERC.  However, since
> the upgrade I have no block device and udev is not creating
> /dev/megadev0.
> 
> The array is functioning fine.  Would anyone be able to offer any
> suggestions about how to get /dev/megadev0 back so I can use the
> monitoring tools again?  Some potentially useful output below.

>From 2.6.25 onwards, megaraid_mm (the new megaraid driver) doesn't
define its own block device like 2.4 did, but instead uses the misc
devices.  So, if you cat /proc/misc and megadev0 doesn't show up, it's a
kernel problem.  If it does, it's a debian udev problem.

James


