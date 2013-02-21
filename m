From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: Issue with mini-SaS to eSATA to USB 3.0 setup
Date: Thu, 21 Feb 2013 14:26:26 -0800
Message-ID: <20130221222626.GA32050@xanatos>
References: <CAAfSSYhT+r07yQfok_BvKj_bTnCUv7nMX8Wafd-xjB1ejEZusQ@mail.gmail.com>
 <CAAfSSYj4ycBUVW3rVy1jrbJEY2hW_Ui88MyWdA5yGose80Vggw@mail.gmail.com>
 <20130221192646.GE27219@xanatos>
 <CAAfSSYhUzSv+R8qkhBpvM0z39mKFH07FZ3Vuk_y3XVM81aAnSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24435 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757858Ab3BUW01 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Feb 2013 17:26:27 -0500
Content-Disposition: inline
In-Reply-To: <CAAfSSYhUzSv+R8qkhBpvM0z39mKFH07FZ3Vuk_y3XVM81aAnSw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fabio David <fabiodavid@gmail.com>
Cc: linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Thu, Feb 21, 2013 at 05:27:00PM -0300, Fabio David wrote:
> On Thu, Feb 21, 2013 at 4:26 PM, Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:
> On Tue, Jan 29, 2013 at 12:56:02PM -0200, Fabio David wrote:
> > > Do you have any suggestions?
> >
> > A couple possible root causes come to mind:
> >
> > 1. Perhaps the USB 3.0 hub is interfering with communication to your
> > eSATA to USB 3.0 adapters.
> >
> > 2. Maybe USB device suspend is to blame.  Do you have USB device suspend
> > enabled for the eSATA to USB adapters?
> 
> I am not sure, I thought it was disabled by default. How can I check?

It is disabled by default.  I just wanted to make sure an installed udev
script wasn't enabling auto-suspend.

You can check whether auto-suspend is enabled by running powertop and
looking for the lines that correspond to the USB 3.0 to eSATA adapters.
If they say 'Bad', device suspend is disabled.  If they say 'Good',
device suspend is enabled.

Or you can find the power/control entries for the devices in
/sys/bus/usb/devices/ and make sure they say 'on' rather than 'auto'.

E.g.

sarah@xanatos:~$ lsusb
Bus 001 Device 002: ID 050d:0413 Belkin Components 
Bus 003 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 004 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 003: ID 045e:0750 Microsoft Corp. Wired Keyboard 600
Bus 001 Device 004: ID 046d:c018 Logitech, Inc. Optical Wheel Mouse
Bus 003 Device 004: ID 04f2:b2ea Chicony Electronics Co., Ltd 
sarah@xanatos:~$ lsusb -t
/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/3p, 480M
    |__ Port 1: Dev 2, If 0, Class=hub, Driver=hub/8p, 480M
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/3p, 480M
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/4p, 5000M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/4p, 480M
    |__ Port 1: Dev 2, If 0, Class=hub, Driver=hub/4p, 480M
        |__ Port 3: Dev 3, If 0, Class=HID, Driver=usbhid, 1.5M
        |__ Port 3: Dev 3, If 1, Class=HID, Driver=usbhid, 1.5M
        |__ Port 4: Dev 4, If 0, Class=HID, Driver=usbhid, 1.5M
sarah@xanatos:~$ cd /sys/bus/usb/devices/
sarah@xanatos:/sys/bus/usb/devices$ ls
1-0:1.0  1-1  1-1:1.0  1-1.3  1-1.3:1.0  1-1.3:1.1  1-1.4  1-1.4:1.0  2-0:1.0  3-0:1.0  3-1  3-1:1.0  3-1.6  3-1.6:1.0  3-1.6:1.1  4-0:1.0  4-1  4-1:1.0  usb1  usb2  usb3  usb4
sarah@xanatos:/sys/bus/usb/devices$ cat 1-1.4/idVendor 
046d
sarah@xanatos:/sys/bus/usb/devices$ cat 1-1.4/power/control 
on
sarah@xanatos:/sys/bus/usb/devices$ 

That means my USB mouse is 'on', so device auto-suspend is disabled.

Sarah Sharp
