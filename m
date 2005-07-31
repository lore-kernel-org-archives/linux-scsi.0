From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 100% repeatable way to send firewire out to lunch permanently
 on 2.6.8.1
Date: Sun, 31 Jul 2005 19:31:18 +0200
Message-ID: <42ED0AE6.7020300@s5r6.in-berlin.de>
References: <Pine.LNX.4.44.0507310739320.13193-100000@sasami.anime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:24004 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S261633AbVGaRbt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Jul 2005 13:31:49 -0400
In-Reply-To: <Pine.LNX.4.44.0507310739320.13193-100000@sasami.anime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net
Cc: Dan Hollis <goemon@anime.net>, Olaf Hering <olh@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, bcollins@debian.org

Dan Hollis wrote:
> On Sun, 24 Oct 2004, Olaf Hering wrote:
>> On Sun, Oct 24, James Bottomley wrote:
>>>The trace doesn't show any error handler activity at all.  Are there no
>>>messages in the log about offlining the device?  If not, it sounds like
>>>there's a problem somewhere in the firewire system.
>>
>>How should sbp2_remove_device get rid of the device? It calls
>>scsi_remove_host, which calls scsi_remove_device, which sets the mode to
>>SDEV_CANCEL, then calls to device_del. sr_do_ioctl expects SDEV_OFFLINE.

This has been subtly changed in the latest sbp2 source from linux1394.org.
scsi_remove_device is now called before sbp2_logout_device and
sbp2_remove_device. The latter is still the caller of scsi_remove_host.
However, this little tweak only helps when sbp2 is unloaded or detached
from a device while the device is still physically present and working.
It does not improve the situation when a device was physically removed
while the drivers were still attached.

> Has there been any progress on this issue? I just got my _entire scsi 
> subsystem_ sent out to lunch because a firewire device lost power.

The situation has got even worse. Since RBC conversions were moved from
sbp2 to sd_mod in linux-2.6.13-rc2, the same or a similar problem is now
exhibited by sd_mod too with most of the FireWire harddisks. The culprit
in sd_mod is obviously sd_shutdown/ sd_sync_cache, which blocks at
scsi_wait_req if the device is physically gone, thus effectively freezing
ieee1394's nodemgr thread. I have not yet looked closer into what might
be the equivalent in sr_mod.

However, there is a positive side of this: 1. With harddisks triggering
the same or a similar problem now, the pressure got really high to
finally fix this extremely annoying bug. I am trying to understand the
nature of the problem right now, but I am new in linux-scsi land. 2. At
least unplugging should be less of a problem if you always remember to
detach or unload sbp2 first. (Or alternatively sr_mod/ sd_mod?) Of
course this does not help if power on the SBP-2 device failed or
somebody tripped over the wire. And detaching the driver manually is of
course quite awkward.
-- 
Stefan Richter
-=====-=-=-= -=== =====
http://arcgraph.de/sr/
