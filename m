From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bugme-new] [Bug 10915] New: echo min_power >
	/sys/class/scsi_host/host0/active_mode causes problem
Date: Mon, 16 Jun 2008 13:51:03 +0900
Message-ID: <20080616135537K.fujita.tomonori@lab.ntt.co.jp>
References: <bug-10915-10286@http.bugzilla.kernel.org/>
	<20080615180146.8abb9450.akpm@linux-foundation.org>
	<1213581610.3517.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:38254 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbYFPEvZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jun 2008 00:51:25 -0400
In-Reply-To: <1213581610.3517.44.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, cijoml@volny.cz

On Sun, 15 Jun 2008 21:00:10 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Sun, 2008-06-15 at 18:01 -0700, Andrew Morton wrote:
> > On Sun, 15 Jun 2008 01:52:26 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> > 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=10915
> > > 
> > >            Summary: echo min_power > /sys/class/scsi_host/host0/active_mode
> > >                     causes problem
> > >            Product: File System
> > >            Version: 2.5
> > >      KernelVersion: 2.6.25.6
> > >           Platform: All
> > >         OS/Version: Linux
> > >               Tree: Mainline
> > >             Status: NEW
> > >           Severity: normal
> > >           Priority: P1
> > >          Component: SysFS
> > >         AssignedTo: greg@kroah.com
> > >         ReportedBy: cijoml@volny.cz
> > > 
> > > 
> > > Latest working kernel version: unknown
> > > Earliest failing kernel version: unknown
> > > Distribution: Debian testing
> > > Hardware Environment: HP Compaq 6910p
> > > Software Environment: Debian testing, sysfs
> > > Problem Description:
> > > 
> > > In accident I proceed
> > > echo min_power > /sys/class/scsi_host/host0/active_mode
> > > 
> > > which causes HIGH cpu load, echo wasn't killable so reboot was only solution :(
> > > 
> > > Steps to reproduce:
> > > proceed command
> > 
> > For reasons which escape me, there is no description text in bugzilla
> > for this report, yet the reporter entered some.
> > 
> > Anyway.  Could someone please refile this under scsi?  Or fix the bug ;)
> 
> Um ... actually, maybe not.  The active_mode file is read only (it has a
> NULL store method).  It's designed to show what mode the host is
> activated in "initiator", "target" (or both or unknown).  If echoing
> something to a read only sysfs file with no actual store method is
> causing this behaviour, the root cause has to be somewhere in sysfs.

This bug doesn't happen with the latest git so I guess that the root
cause was fixed, which can't handle the NULL store method properly.

But I think that it would be better to set active_mode and
support_mode files to read-only (though in the future, active_mode
would be changeable for a dual-mode driver).


> However, since the file has nothing to do with power saving ... unless
> some driver I can't find is trying to duplicate it, so there's no reason
> to try to echo "min_power" to it, so some of the details on this report
> might bear further investigation ...

I guess that he intended to echo "min_power" to
link_power_management_policy file.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] set active_mode and support_mode sysfs files to read-only

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_sysfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 93d2b67..01191bb 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -227,7 +227,7 @@ show_shost_supported_mode(struct device *dev, struct device_attribute *attr,
 	return show_shost_mode(supported_mode, buf);
 }
 
-static DEVICE_ATTR(supported_mode, S_IRUGO | S_IWUSR, show_shost_supported_mode, NULL);
+static DEVICE_ATTR(supported_mode, S_IRUGO, show_shost_supported_mode, NULL);
 
 static ssize_t
 show_shost_active_mode(struct device *dev,
@@ -241,7 +241,7 @@ show_shost_active_mode(struct device *dev,
 		return show_shost_mode(shost->active_mode, buf);
 }
 
-static DEVICE_ATTR(active_mode, S_IRUGO | S_IWUSR, show_shost_active_mode, NULL);
+static DEVICE_ATTR(active_mode, S_IRUGO, show_shost_active_mode, NULL);
 
 shost_rd_attr(unique_id, "%u\n");
 shost_rd_attr(host_busy, "%hu\n");
-- 
1.5.5.GIT

