From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Usb storage mounting was broken somewhere between 2.6.0-test5-bk10 and 2.6.0-test6-bk1
Date: Tue, 21 Oct 2003 17:55:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031021175556.A8670@beaverton.ibm.com>
References: <1066775616.3458.8.camel@m70.net81-64-235.noos.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:19608 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S263259AbTJVBBN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2003 21:01:13 -0400
Content-Disposition: inline
In-Reply-To: <1066775616.3458.8.camel@m70.net81-64-235.noos.fr>; from Nicolas.Mailhot@laPoste.net on Wed, Oct 22, 2003 at 12:33:36AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Nicolas Mailhot <Nicolas.Mailhot@laPoste.net>
Cc: linux-scsi@vger.kernel.org, dbrownell@users.sourceforge.net

On Wed, Oct 22, 2003 at 12:33:36AM +0200, Nicolas Mailhot wrote:

> 2. the usb storage maintainer says nothing changed at the usb level, so
> it's probably the scsi layer that broke somehow

In the bug, Matthew says:

	looks like someone may have broken usb_reset_configuration or some
	other code path outside of usb-storage.

> I've just retested with 2.6.0-test8-bk1 and the bug is still there.
> 
> More patch tests, logs, etc available on demand (though the bugzilla
> entry is already pretty complete)

Since the device functioned in an earlier 2.6 release, I doubt the MODE
SENSE page is causing a problem. 

It is a multi slot card reader, and SCSI sees these as multiple LUNs
(multiple sd's), though you say you can only use one at a time. So we see
INQUIRY's to LUN 0 and LUN 1, and LUN 1 shows up and is then mounted via
/dev/smartmedia, correct?

David - as replied to you by Nicolas in the bug, the dmesg you commented
on is the one that was working (the "2.6.0-test5-bk5 scenario"). SCSI is
not confused in that case (though I am somewhat confused by the various
dmesg and log files).

Where are the SCSI INQUIRY messages? The ones with Vendor and Model. And
sd attach messages?

If the SCSI INQUIRY messages are not output, SCSI is not seeing the device
at all and it is more likely a usb issue.

AFAICT the bad dmesg ends without a reset, where the good one shows an
INQUIRY being sent and returned back OK, followed by logs of the mount
command.

i.e. bad demsg/log has:

Oct  2 23:55:35 rousalka kernel: usb-storage: USB Mass Storage device detected
Oct  2 23:55:35 rousalka kernel: usb-storage: act_altsetting is 0, id_index is 16
Oct  2 23:55:35 rousalka kernel: usb-storage: -- associate_dev
Oct  2 23:55:35 rousalka kernel: usb-storage: Vendor: SCM Microsystems
Oct  2 23:55:35 rousalka kernel: usb-storage: Product: eUSB SmartMedia /
CompactFlash Adapter

And then nothing at all???

-- Patrick Mansfield
