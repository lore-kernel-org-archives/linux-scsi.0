From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: linux-next: Tree for December 28 (drivers/target/)
Date: Tue, 28 Dec 2010 12:13:56 -0800
Message-ID: <1293567236.4649.221.camel@haakon2.linux-iscsi.org>
References: <20101228173049.217c192d.sfr@canb.auug.org.au>
	 <20101228082947.70b09534.randy.dunlap@oracle.com>
	 <1293554355.2371.1.camel@fuzzy>
	 <20101228085016.dedc8b18.randy.dunlap@oracle.com>
	 <1293565125.4649.217.camel@haakon2.linux-iscsi.org>
	 <4D1A42BF.4070401@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D1A42BF.4070401@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2010-12-28 at 12:04 -0800, Randy Dunlap wrote:
> On 12/28/10 11:38, Nicholas A. Bellinger wrote:
> > On Tue, 2010-12-28 at 08:50 -0800, Randy Dunlap wrote:
> >> On Tue, 28 Dec 2010 10:39:14 -0600 James Bottomley wrote:
> >>
> >>> On Tue, 2010-12-28 at 08:29 -0800, Randy Dunlap wrote:
> >>>> On Tue, 28 Dec 2010 17:30:49 +1100 Stephen Rothwell wrote:
> >>>>
> >>>>> Hi all,
> >>>>>
> >>>>> [The mirroring on kernel.org is running slowly]
> >>>>>
> >>>>> Changes since 20101227:
> >>>>
> >>>>
> >>>> warning: (TARGET_CORE && GFS2_FS) selects CONFIGFS_FS which has unmet direct dependencies (SYSFS)
> >>>>
> >>>> from:
> >>>>
> >>>> menuconfig TARGET_CORE
> >>>> 	tristate "Generic Target Core Mod (TCM) and ConfigFS Infrastructure"
> >>>> 	select CONFIGFS_FS
> >>>>
> >>>> but CONFIGFS_FS depends on SYSFS, so TARGET_CORE should either depend on SYSFS
> >>>> or (eek) it should select SYSFS.
> >>>
> >>> The latter, I think (and actually, configfs should select sysfs).  All
> >>> these unmet dependencies are a minefield.
> >>
> >> It's just another language to deal with.  Not a big deal, except for the
> >> twists that EXPERIMENTAL injects into it.
> > 
> > I agree with James on this one..  Attached is a patch to select SYSFS
> > and fix up some extra whitespace breakage. (jlbec CC'ed)
> 
> and I am not surprised.  James is a more liberal 'select'or than I am.

;)

> 
> > Thanks,
> > 
> > --nab
> > 
> > diff --git a/fs/configfs/Kconfig b/fs/configfs/Kconfig
> > index 13587cc..6874d75 100644
> > --- a/fs/configfs/Kconfig
> > +++ b/fs/configfs/Kconfig
> > @@ -1,11 +1,11 @@
> >  config CONFIGFS_FS
> >  	tristate "Userspace-driven configuration filesystem"
> > -	depends on SYSFS
> > +	select SYSFS
> >  	help
> > -	  configfs is a ram-based filesystem that provides the converse
> > -	  of sysfs's functionality. Where sysfs is a filesystem-based
> > -	  view of kernel objects, configfs is a filesystem-based manager
> > -	  of kernel objects, or config_items.
> > +	configfs is a ram-based filesystem that provides the converse
> 
> 	              RAM-based
> 

Fixed, and added as a single patch into the LIO tree tracking linux-next
here:

http://git.kernel.org/?p=linux/kernel/git/nab/linux-next.git;a=commitdiff;h=87b548329a29fbe54453f9ef47819ee39a32716d

Thanks!

--nab
