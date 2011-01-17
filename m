From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] configfs: change depends -> select SYSFS
Date: Mon, 17 Jan 2011 14:10:16 -0800
Message-ID: <1295302216.22813.212.camel@haakon2.linux-iscsi.org>
References: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
	 <20110116141105.59e5b3a2@stein>
	 <1295214807.22813.57.camel@haakon2.linux-iscsi.org>
	 <20110117000659.57352da7@stein> <1295223733.2998.8.camel@mulgrave.site>
	 <1295244354.22813.98.camel@haakon2.linux-iscsi.org>
	 <20110117102420.5a1c1bf0.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51273 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1AQWKU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jan 2011 17:10:20 -0500
In-Reply-To: <20110117102420.5a1c1bf0.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Joel Becker <jlbec@evilplan.org>

On Mon, 2011-01-17 at 10:24 -0800, Randy Dunlap wrote:
> On Sun, 16 Jan 2011 22:05:54 -0800 Nicholas A. Bellinger wrote:
> 
> > On Sun, 2011-01-16 at 18:22 -0600, James Bottomley wrote:

<SNIP>

> > > This is what I don't understand.
> > > 
> > > Actually I think the whole premise of the patch (to get back to the
> > > original topic) is wrong.
> > > 
> > > TARGET_CORE depends on SCSI; SCSI has to have sysfs to survive ... we
> > > just don't work without it yet we neither select nor depend on it.
> > > SYSFS is only deselectable for embedded anyway, so I think the
> > > configuration which generated this whole argument was likely a bogus one
> > > and consequently, none of the patches are needed (or if they are,
> > > they're the tip of the iceberg).
> > > 
> > 
> > This sounds fine for TARGET_CORE, but would still leave GFS2_FS with an
> > unmet direct dependency according to the original warning above.
> > Unfortuately I do not recall which exactly linux-next build
> > configuration was causing this warning to occur from the original post:
> > 
> > http://marc.info/?l=linux-next&m=129355383112997&w=2
> > 
> > Any more thoughts here Randy..?
> 
> 
> I've looked at GFS2 a bit now and I think that the warning is bogus:
> 
> kconfig complains with:
> warning: (TARGET_CORE && GFS2_FS) selects CONFIGFS_FS which has unmet direct dependencies (SYSFS)
> 
> but the "select" is conditional:
> config GFS2_FS
> 	tristate "GFS2 file system support"
> 	depends on (64BIT || LBDAF)
> 	select DLM if GFS2_FS_LOCKING_DLM
> 	select CONFIGFS_FS if GFS2_FS_LOCKING_DLM
> 	select SYSFS if GFS2_FS_LOCKING_DLM
> 
> and the same condition selects both SYSFS and CONFIGFS_FS.  Furthermore, the
> conditional is not true, so neither of them is being selected/enabled.
> Looks like a minor kconfig buglet to me.
> 

Ok, so Linus has pulled the CONFIGFS_FS -> select SYSFS series and it
looks like this 'select SYSFS ...' bit for GFS2_FS can safely be dropped
now..

Care to carry this one via your kbuild tree..?

Thanks!

--nab


