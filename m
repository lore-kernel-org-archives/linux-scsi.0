From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] SCSI postmerge patches for 2.6.38 merge window
Date: Fri, 14 Jan 2011 17:38:43 -0800
Message-ID: <1295055523.28685.93.camel@haakon2.linux-iscsi.org>
References: <1295030453.18445.63.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43085 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab1AOBir (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jan 2011 20:38:47 -0500
In-Reply-To: <1295030453.18445.63.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Fri, 2011-01-14 at 12:40 -0600, James Bottomley wrote:
> This is a set of three patches I've been carrying that had a
> dependencies on pieces of the block tree (which went in yesterday).
> It's been rebased to go cleanly on top of current git head (and elimnate
> some of the merge cruft of creating a postmerge tree).  All of the
> patches have been in Linux-next for several weeks.
> 
> The two sd/sr patches are just completion of the media events
> infrastructure which was in the block tree.  The main chunk is the
> addition of the LIO in-kernel target infrastructure which is one of the
> two competing target infrastructures which have been out of tree for
> several years now.  Thanks to quite a lot of effort (particularly from
> Christoph Hellwig) cleaning it up, I think it's ready for mainline
> inclusion.  This piece is just the target infrastructure; we'll begin
> adding the in-kernel drivers and the migration hooks for STGT (our
> original user land target driver) over the next merge window.
> 
> The patch is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-post-merge-2.6.git
> 
> The short changelog is:
> 
> Nicholas Bellinger (1):
>       target: Add LIO target core v4.0.0-rc6

Many, many thanks to the individual kernel development community members
who have given their time and efforts for LIO v4.0 code, and for
reaching this milestone of an initial target infrastructure merge
into .38.  Without their help this would not have been possible, and
certainly not as interesting or as much fun as it has been thus far..

Many thanks to everyone who has reported bug(s) on their LIO systems,
spent the time to review individual target patches, and provide the
critical feedback throughout development of the major v3 and v4 features
features in the last 2.75 years since moving to kernel.org git.  This
list is by no means complete for all of the devels, users, vendors and
customers who have been involved up to this point, so please forgive me
if your name is not mentioned directly.  All of your hard work and
contributions are appreciated.

Christoph Hellwig
James Bottomley
Fujita Tomonori
Mike Christie
Hannes Reinecke
Boaz Harrosh
Martin K. Peterson
Joel Becker
Konrad Rzeszutek Wilk
Leonid Grossman
Joe Eykholt
Robert Love
Jeff Garzik
H. Peter Anvin
Grant Grundler
Andi Kleen
Jon Hawley
Doug Gilbert
Kiran Patil
Zi You
Stephen Rothwell
Randy Dunlap
Geert Uytterhoeven

And a extra special thanks to Ming Zhang from the IET community for
originally recommending a ConfigFS based control plane for target mode
operation way back in August 2008.   

And finally, thanks to Marc Fleischmann, Jerome Martin, Thomas Uhl and
the entire team @ RisingTideSystems for providing commerical products
and support with the LIO target code.

Thank you!

--nab

> 
> Tejun Heo (2):
>       sd,sr: kill compat SDEV_MEDIA_CHANGE event
>       sd: implement sd_check_events()
> 
> and the diffstat:
> 
>  Documentation/target/tcm_mod_builder.py      | 1094 +++++
>  Documentation/target/tcm_mod_builder.txt     |  145 +
>  drivers/Kconfig                              |    2 +
>  drivers/Makefile                             |    1 +
>  drivers/scsi/sd.c                            |  103 +-
>  drivers/scsi/sd.h                            |    1 -
>  drivers/scsi/sr.c                            |    4 -
>  drivers/target/Kconfig                       |   32 +
>  drivers/target/Makefile                      |   24 +
>  drivers/target/target_core_alua.c            | 1991 +++++++++
>  drivers/target/target_core_alua.h            |  126 +
>  drivers/target/target_core_cdb.c             | 1131 +++++
>  drivers/target/target_core_configfs.c        | 3225 ++++++++++++++
>  drivers/target/target_core_device.c          | 1694 +++++++
>  drivers/target/target_core_fabric_configfs.c |  996 +++++
>  drivers/target/target_core_fabric_lib.c      |  451 ++
>  drivers/target/target_core_file.c            |  688 +++
>  drivers/target/target_core_file.h            |   50 +
>  drivers/target/target_core_hba.c             |  185 +
>  drivers/target/target_core_hba.h             |    7 +
>  drivers/target/target_core_iblock.c          |  808 ++++
>  drivers/target/target_core_iblock.h          |   40 +
>  drivers/target/target_core_mib.c             | 1078 +++++
>  drivers/target/target_core_mib.h             |   28 +
>  drivers/target/target_core_pr.c              | 4252 ++++++++++++++++++
>  drivers/target/target_core_pr.h              |   67 +
>  drivers/target/target_core_pscsi.c           | 1470 ++++++
>  drivers/target/target_core_pscsi.h           |   65 +
>  drivers/target/target_core_rd.c              | 1091 +++++
>  drivers/target/target_core_rd.h              |   73 +
>  drivers/target/target_core_scdb.c            |  105 +
>  drivers/target/target_core_scdb.h            |   10 +
>  drivers/target/target_core_tmr.c             |  404 ++
>  drivers/target/target_core_tpg.c             |  826 ++++
>  drivers/target/target_core_transport.c       | 6134 ++++++++++++++++++++++++++
>  drivers/target/target_core_ua.c              |  332 ++
>  drivers/target/target_core_ua.h              |   36 +
>  include/target/configfs_macros.h             |  147 +
>  include/target/target_core_base.h            |  937 ++++
>  include/target/target_core_configfs.h        |   52 +
>  include/target/target_core_device.h          |   61 +
>  include/target/target_core_fabric_configfs.h |  106 +
>  include/target/target_core_fabric_lib.h      |   28 +
>  include/target/target_core_fabric_ops.h      |  100 +
>  include/target/target_core_tmr.h             |   43 +
>  include/target/target_core_tpg.h             |   35 +
>  include/target/target_core_transport.h       |  351 ++
>  47 files changed, 30571 insertions(+), 58 deletions(-)
>  create mode 100755 Documentation/target/tcm_mod_builder.py
>  create mode 100644 Documentation/target/tcm_mod_builder.txt
>  create mode 100644 drivers/target/Kconfig
>  create mode 100644 drivers/target/Makefile
>  create mode 100644 drivers/target/target_core_alua.c
>  create mode 100644 drivers/target/target_core_alua.h
>  create mode 100644 drivers/target/target_core_cdb.c
>  create mode 100644 drivers/target/target_core_configfs.c
>  create mode 100644 drivers/target/target_core_device.c
>  create mode 100644 drivers/target/target_core_fabric_configfs.c
>  create mode 100644 drivers/target/target_core_fabric_lib.c
>  create mode 100644 drivers/target/target_core_file.c
>  create mode 100644 drivers/target/target_core_file.h
>  create mode 100644 drivers/target/target_core_hba.c
>  create mode 100644 drivers/target/target_core_hba.h
>  create mode 100644 drivers/target/target_core_iblock.c
>  create mode 100644 drivers/target/target_core_iblock.h
>  create mode 100644 drivers/target/target_core_mib.c
>  create mode 100644 drivers/target/target_core_mib.h
>  create mode 100644 drivers/target/target_core_pr.c
>  create mode 100644 drivers/target/target_core_pr.h
>  create mode 100644 drivers/target/target_core_pscsi.c
>  create mode 100644 drivers/target/target_core_pscsi.h
>  create mode 100644 drivers/target/target_core_rd.c
>  create mode 100644 drivers/target/target_core_rd.h
>  create mode 100644 drivers/target/target_core_scdb.c
>  create mode 100644 drivers/target/target_core_scdb.h
>  create mode 100644 drivers/target/target_core_tmr.c
>  create mode 100644 drivers/target/target_core_tpg.c
>  create mode 100644 drivers/target/target_core_transport.c
>  create mode 100644 drivers/target/target_core_ua.c
>  create mode 100644 drivers/target/target_core_ua.h
>  create mode 100644 include/target/configfs_macros.h
>  create mode 100644 include/target/target_core_base.h
>  create mode 100644 include/target/target_core_configfs.h
>  create mode 100644 include/target/target_core_device.h
>  create mode 100644 include/target/target_core_fabric_configfs.h
>  create mode 100644 include/target/target_core_fabric_lib.h
>  create mode 100644 include/target/target_core_fabric_ops.h
>  create mode 100644 include/target/target_core_tmr.h
>  create mode 100644 include/target/target_core_tpg.h
>  create mode 100644 include/target/target_core_transport.h
> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

