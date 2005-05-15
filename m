From: Matthias Andree <matthias.andree@gmx.de>
Subject: 53C8XX /sys/devices/pci*/*/config revisited
Date: Sun, 15 May 2005 13:02:37 +0200
Message-ID: <m3br7c4ur6.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.E-Technik.Uni-Dortmund.DE ([129.217.163.1]:56720 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S261602AbVEOLCm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 May 2005 07:02:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Matthew,

remember the discussion we had in Late November last year about root
reading the upper 128 bytes of SYM53C8XX's /sys/devices/pci/*/*/config
file? See <http://marc.theaimsgroup.com/?l=linux-scsi&m=110113027015843&w=2>

The bug also affects a different user-space package, Freedesktop's
"hal", that now ships with the new SUSE Linux 9.3.

I filed two bug reports/additions against the user space, SUSE Ticket ID
[20050515990000057] and FreeDesktop's bugzilla as #1852.
<https://bugs.freedesktop.org/show_bug.cgi?id=1852>

BTW, the hald bug #1852 has been open since 2004-11-14, and so is
actually older than the discussion we had here, but SUSE wasn't using
HAL at that time so I was unaware - I've posted the contents of my
addition to that bug on the HAL list but if they haven't fixed the bug
in half a year, I don't see why they'd fix the bug just now.

In the message above, you offered

| > 2. is it a kernel bug if reading offset #216 (byte-wise) in the config
| >    file in sysfs confuses the hardware?
| 
| No, but it does seem to me that we could do better.  Unfortunately,
| the obvious thing to do (set the file size to less than 256 bytes) isn't
| really possible in sysfs.  But we could use the 'undocumented feature'
| in drivers/pci/pci-sysfs.c:pci_read_config() of setting the pci_dev's
| cfg_size to 128 bytes.  This would prevent even root from reading more
| than 128 bytes.  That'd be OK -- there's no *PCI* data in this range,
| even on the latest 1010/1030 controllers.  The operating registers are
| exposed in the 0x80-0xFF range only up to the 875; the 876 and later
| return only 0 in that range.

And I ask you to hack the driver as suggested to the bug keeps from
coming back as soon as a new user-space tool by $RANDOM_VENDOR feels
like it must read the whole range again.

Note also that the bug is visible on the 895, too. And it hurts, as it,
in connection with the GNOME desktop, offlines my CD-ROM drive, which
some automation component doesn't detect and hang, with GNOME not
starting up properly.

I fear that trying to fix user-space is going to become a neverending
story, with new packages causing trouble every other quarter.

I also filed a kernel bug against SUSE Linux, Ticket [20050515990000068]

Thanks in advance,

-- 
Matthias Andree
