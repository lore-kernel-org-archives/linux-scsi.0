From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 19:10:45 +0200
Message-ID: <47139F15.7050702@s5r6.in-berlin.de>
References: <200710112011.22000.rob@landley.net> <200710141836.55211.rob@landley.net> <4712FE33.3000400@s5r6.in-berlin.de> <200710150426.04924.rob@landley.net> <20071015160800.GA324@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1765782AbXJORL5@vger.kernel.org>
In-Reply-To: <20071015160800.GA324@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Rob Landley <rob@landley.net>, David Newall <david@davidnewall.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Mon, Oct 15, 2007 at 04:26:04AM -0500, Rob Landley wrote:
>> Combining USB and IDE into the same /dev/sd? namespace makes enumerating the 
>> IDE devices much harder than in the traditional "/dev/hdb doesn't move 
>> without a screwdriver" model.  The merger creates a new problem for IDE, one 
>> which didn't exist before: the addition or removal of other unrelated types 
>> of devices may change this device's location next boot.  It may be possible 
>> to add additional complication to the system to compensate, but what was the 
>> advantage of merging the namespaces in the first place?
> 
> It's not something anyone particularly set out to do, it's just how
> it worked out.  It was justified by saying "ok, this goes from a 99%
> solution to a 96% solution, but there's 100% solution called uuids".
> I don't particularly agree with this line of argumentation, but it did
> hold sway.

Low-level networking drivers suggest a default interface name (per
interface or as a template like eth%d into which the networking core
inserts a lowest spare number).  Userspace can rename interfaces, but
nevertheless it's nice to have different default kernel names for
ethernet, wlan etc..

Could low-level SCSI drivers provide similar name templates which give a
hint on the transport involved?  It's a bit more difficult as with
networking interfaces though because
  - SCSI devices can have sd, sr, st, osst, ch, sg interfaces,
  - SCSI device files share a namespace with all other device files.

E.g.
/dev/sd-ide-b	- second IDE HDD,
/dev/sd-iscsi-e	- fifth iSCSI direct access device,
/dev/sr-sata-0	- first SATA CD-ROM,
/dev/sr-usb-0	- a USB CD-ROM,
/dev/st-fw-0	- a FireWire tape drive,
/dev/sda	- a device whose transport driver didn't propose a name

Of course the really interesting names will still be provided by
udev-generated symlinks.
-- 
Stefan Richter
-=====-=-=== =-=- -====
http://arcgraph.de/sr/
