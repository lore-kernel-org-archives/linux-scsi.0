From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] /proc/scsi/map
Date: Thu, 20 Jun 2002 10:52:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020620105233.A5506@eng2.beaverton.ibm.com>
References: <200206200711.RAA10165@thucydides.inspired.net.au> <Pine.LNX.4.44.0206200800260.8012-100000@home.transmeta.com> <20020620165553.GA16897@win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020620165553.GA16897@win.tue.nl>; from aebr@win.tue.nl on Thu, Jun 20, 2002 at 06:55:53PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: Linus Torvalds <torvalds@transmeta.com>, Martin Schwenke <martin@meltin.net>, Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mochel <mochel@osdl.org>

On Thu, Jun 20, 2002 at 06:55:53PM +0200, Andries Brouwer wrote:
> Kurt's patch does not solve all problems, but what it provides
> is a small translation table between different names for the same thing.
> That information is not easily obtainable without his patch.
> I do not see that driverfs provides such information.
> 
> Andries

With Mike Sullivan'a patch for SCSI driverfs support: 

http://marc.theaimsgroup.com/?l=linux-scsi&m=102434655912858&w=2

You can see the relationship (not that it is simpile or easy to read),
for example, on my system for the LUN at scsi3 channel 0 , id 3, lun 0
I can see that the sd (disc) is at major/minor 4200 (66, 0), and sg
(gen) is at 1521 (21, 33):

[root@elm3a50 3:0:3:0]# pwd
/devices/root/pci1/01:07.0/scsi3/3:0:3:0
[root@elm3a50 3:0:3:0]# find .
.
./3:0:3:0:p2
./3:0:3:0:p2/kdev
./3:0:3:0:p2/type
./3:0:3:0:p2/power
./3:0:3:0:p2/name
./3:0:3:0:p1
./3:0:3:0:p1/kdev
./3:0:3:0:p1/type
./3:0:3:0:p1/power
./3:0:3:0:p1/name
./3:0:3:0:disc
./3:0:3:0:disc/kdev
./3:0:3:0:disc/type
./3:0:3:0:disc/power
./3:0:3:0:disc/name
./3:0:3:0:gen
./3:0:3:0:gen/kdev
./3:0:3:0:gen/type
./3:0:3:0:gen/power
./3:0:3:0:gen/name
./type
./power
./name
[root@elm3a50 3:0:3:0]# cat 3\:0\:3\:0\:gen/kdev
1521
[root@elm3a50 3:0:3:0]# cat 3\:0\:3\:0\:disc/kdev
4200
[root@elm3a50 3:0:3:0]# ls -l /dev/sdag
brw-rw----    1 root     disk      66,   0 Aug 30  2001 /dev/sdag


-- Patrick Mansfield
