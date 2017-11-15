From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Seagate External SMR drive USB resets (was: Re: [PATCH] uas:
 Add US_FL_NO_ATA_1X quirk for one more Seagate device)
Date: Thu, 16 Nov 2017 07:40:08 +0900
Message-ID: <1510785608.6323.10.camel@HansenPartnership.com>
References: <Pine.LNX.4.44L0.1711151656350.1363-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33014 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753334AbdKOWkM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Nov 2017 17:40:12 -0500
In-Reply-To: <Pine.LNX.4.44L0.1711151656350.1363-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, =?ISO-8859-1?Q?J=E9r=F4me?= Carretero <cJ-ko@zougloub.eu>
Cc: Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Jens <jens-bugzilla.kernel.org@spamfreemail.de>, Andrey Astafyev <1@246060.ru>, Oliver Neukum <oneukum@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2017-11-15 at 17:02 -0500, Alan Stern wrote:
> On Wed, 15 Nov 2017, Jérôme Carretero wrote:
> > >   Because with several of these drives / lots of activity /
> occasional
> > >   issues, it looks like it will be hard to catch (yes I can use
> > > usbmon).
> > > 
> > > - It looks like there is no configurable timeout for USB MSC
> requests.
> > >   Perhaps the device is not responding in time and this is why
> it's
> > >   reset?
> 
> Timeouts are set by the SCSI layer.  I believe they are rather long
> (30 seconds, by default).  Presumably they are configurable, although
> I would have to do some digging to figure out how.

They're in /sys/class/scsi_device/<id>/device/timeout

jejb@bedivere:~> ls -l /sys/class/scsi_device/0\:0\:0\:0/device/timeout
-rw-r--r-- 1 root root 4096 Nov 15 14:37 /sys/class/scsi_device/0:0:0:0/device/timeout
jejb@bedivere:~> cat /sys/class/scsi_device/0\:0\:0\:0/device/timeout
30

You can actually have a udev rule adjust them on a per device id basis.

James
