From: Douglas Gilbert <dougg@torque.net>
Subject: sg driver and Fedora Core 2
Date: Sat, 29 May 2004 00:05:25 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B74725.90403@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:58629 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263121AbUE1OGA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2004 10:06:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: alan@redhat.com

This is slightly off topic (discussing a particular
distribution).

The recently released Fedora Core 2 distribution contains
a patch that allocates sg device names (e.g. /dev/sg0)
only to those SCSI devices _not_ "claimed" by other upper
level drivers (i.e. sd, sr, st and osst). There is no
kernel (or module) load time parameter to alter this
behaviour. There is no way to bind a sg device name to
a SCSI device after it has been attached by the SCSI mid
level (but perhaps there should be ...).

It seems that the intention of this change is to force cdrecord
users to use the /dev/scd or /dev/hd device names (rather than
the /dev/sg devices names that were used in the lk 2.0, 2.2
and 2.4 series). While I agree that encouraging the use
of the more natural /dev/scd or /dev/hd devices make sense for
cdrecord, there are some lesser used applications
that are broken by the "forcing" nature of this change (e.g.
mtx).

Recently I have had a query about how a specialist application
(that worked in the lk 2.4 series) sends 16 MB data through a
single SCSI command in Fedora Core 2. The simple answer to that
one is the block layer imposes a 128 KB limit on single
transfers and that's it. [Counter-intuitively that limit also
applies to st and osst when they use the SG_IO ioctl.] Around a
year ago I tried to move Jens Axboe on this issue and failed.
Evidentally there are good reasons why the block layer imposes
that limit. There are other issues with this change.

There seems to be mixed signals coming from the Fedora camp
on this change. A "policy" change was one response and this
url ( http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=123876 )
has Alan Cox stating that this change is a bug.

I am not aware of any such change (or pending change) in the
"mainline" linux kernel (i.e. the lk 2.6 source tree controlled
by Linus Torvalds).

Doug Gilbert



