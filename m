From: Mark Lord <lkml@rtr.ca>
Subject: Re: [PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2
Date: Tue, 14 Sep 2004 13:27:54 -0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <41472A1A.6020105@rtr.ca>
References: <41471163.10709@rtr.ca> <414723B0.1090600@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <414723B0.1090600@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

Thanks Jeff,

I'll look into most of your points and give responses and changes
where required.  But first, a few overall notes on the approach.

This is a hardware RAID device, but it requires driver knowledge
of the RAID features.  It does not map to libata at all, unfortunately,
because all of the queuing features are completely non-SATA standard,
and the RAID stuff is (as normal) peculiar to the chip.

Here's a question for you:  like all of the other RAID drivers,
this one needs an interface to a userland RAID management GUI.

The usual method for this is to create a fake character device driver,
and use that as the interface to userland.  This is commonly done,
but is it the best way to handle such?  A /proc/ or /sys/ interface
could achieve similar goals, but without the need of a fake device.

We can go either way with this one, so lets hear some opinions on it.

For the rest, this driver has been around (vendor driver) since before
libata became usable, and certainly before libata existed in 2.4.xx.
The driver will eventuall need to compile and run in 2.4.20,
for customers using old Redhat kernels.   It's not there yet,
but if it were to lean more heavily on 2.6.xx stuff,
then that will be more difficult to achieve.

Cheers
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
