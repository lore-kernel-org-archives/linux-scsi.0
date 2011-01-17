From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] configfs: change depends -> select SYSFS
Date: Mon, 17 Jan 2011 10:11:29 -0800
Message-ID: <20110117101129.402fee67.randy.dunlap@oracle.com>
References: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
	<20110116141105.59e5b3a2@stein>
	<1295214807.22813.57.camel@haakon2.linux-iscsi.org>
	<20110117000659.57352da7@stein>
	<1295223733.2998.8.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1295223733.2998.8.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Joel Becker <jlbec@evilplan.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 16 Jan 2011 18:22:12 -0600 James Bottomley wrote:

> On Mon, 2011-01-17 at 00:06 +0100, Stefan Richter wrote:
> > On Jan 16 Nicholas A. Bellinger wrote:
> > > On Sun, 2011-01-16 at 14:11 +0100, Stefan Richter wrote:
> > > > On Jan 15 Nicholas A. Bellinger wrote:
> > > > > This patch changes configfs to select SYSFS to fix the following:
> > > > > 
> > > > > warning: (TARGET_CORE && GFS2_FS) selects CONFIGFS_FS which has unmet direct dependencies (SYSFS)
> > > > 
> > > > Why don't you fix target-core's Kconfig instead?
> > > 
> > > The thought here was that since modern configfs is mounted
> > > at /sys/kernel/config/, selecting SYSFS by default when building
> > > CONFIGFS_FS made the most sense for existing configfs consumers.
> > 
> > I for one think that layered "select" directives will open too many cans
> > of worms.
> 
> select, since we have it, should be clean ... as in if you select
> something, you don't have to expose yourself to a huge pile of missing
> depends that only show up in obscure configurations.
> 
> 
> > Best don't use select at all.
> 
> The object of select is not to trip up the user.  If we used a purely
> depend based configuration, the user would have to know to select, say,
> the right SCSI transport classes before they get presented with drivers.
> It's completely correct, since transport classes are internal
> implementations, to have the user select drivers and Kconfig work out
> via the select directive what transport classes are needed.
> 
> > If you use it, select only options that don't depend on anything else.
> > 
> > If you feel that people really want you to provide a select for them which
> > selects something that in turn depends on other things, then I suggest you
> > rather let your own option depend on these lower dependencies:
> > 
> > config HIGHLEVEL_FEATURE
> > 	tristate "some driver"
> > 	depends on SYSFS  # because CONFIGFS depends on it
> > 	select CONFIGFS
> 
> This is what I don't understand.
> 
> Actually I think the whole premise of the patch (to get back to the
> original topic) is wrong.
> 
> TARGET_CORE depends on SCSI; SCSI has to have sysfs to survive ... we
> just don't work without it yet we neither select nor depend on it.
> SYSFS is only deselectable for embedded anyway, so I think the
> configuration which generated this whole argument was likely a bogus one
> and consequently, none of the patches are needed (or if they are,
> they're the tip of the iceberg).

This sounds like a problem.
SCSI subsystem will certainly build without having SYSFS enabled, but I think
that you are saying that it won't function without SYSFS.  Then it depends on
SYSFS and should say so somewhere (IMO of course).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
