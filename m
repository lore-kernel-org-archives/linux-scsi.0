From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [BUG 2.6.17-git] kmem_cache_create: duplicate cache scsi_cmd_cache
Date: Fri, 12 May 2006 15:37:59 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0605121532360.3866@g5.osdl.org>
References: <15ddcffd0605112153q57f139a1k7068e204a3eeaf1f@mail.gmail.com>
 <20060512171632.GA29077@harddisk-recovery.com> <Pine.LNX.4.64.0605121024310.3866@g5.osdl.org>
 <1147456038.3769.39.camel@mulgrave.il.steeleye.com>
 <1147460325.3769.46.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0605121209020.3866@g5.osdl.org> <20060512203850.GC17120@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0605121346060.3866@g5.osdl.org> <20060512205804.GD17120@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0605121409250.3866@g5.osdl.org> <20060512215151.GG17120@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0605121508590.3866@g5.osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751101AbWELWig@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0605121508590.3866@g5.osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Erik Mouw <erik@harddisk-recovery.com>, Or Gerlitz <or.gerlitz@gmail.com>, linux-scsi@vger.kernel.org, axboe@suse.de, Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>, Todd Blumer <todd@sdgsystems.com>
List-Id: linux-scsi@vger.kernel.org



On Fri, 12 May 2006, Linus Torvalds wrote:
> 
> On Fri, 12 May 2006, Russell King wrote:
> > 
> > From: Todd Blumer <todd@sdgsystems.com>
> > On a PXA27x handheld (iPAQ hx4700), when we eject a mounted SD memory
> > card, we get a kernel panic (kernel trying to clean up non-existent
> > device). One hack patch to avoid the panic is:
> > 
> > --- fs/partitions/check.c       10 Apr 2006 22:57:27 -0000      1.15
> > +++ fs/partitions/check.c       4 May 2006 20:30:15 -0000
> > @@ -491,6 +491,7 @@
> >                         kfree(disk_name);
> >                 }
> >                 put_device(disk->driverfs_dev);
> > +               disk->driverfs_dev = 0; /* HACK - what's the right solution? */
> >         }
> >         kobject_uevent(&disk->kobj, KOBJ_REMOVE);
> >         kobject_del(&disk->kobj);
> 
> Btw, on the face it of, I really think that this patch is correct 
> regardless of any other issues.

.. and I suspect it also shows what the "other issues" are.

Shouldn't that KOBJ_REMOVE uevent happen _before_ we do all the freeing of 
the backing dev object? That KOBJ_REMOVE thing actually seems to want to 
report the pathname for the disk it removes. Preferably before the thing 
is gone and can't be reported on..

Ie shouldn't the diff be something like this?

		Linus
---
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 45ae7dd..7ef1f09 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -533,6 +533,7 @@ void del_gendisk(struct gendisk *disk)
 
 	devfs_remove_disk(disk);
 
+	kobject_uevent(&disk->kobj, KOBJ_REMOVE);
 	if (disk->holder_dir)
 		kobject_unregister(disk->holder_dir);
 	if (disk->slave_dir)
@@ -545,7 +546,7 @@ void del_gendisk(struct gendisk *disk)
 			kfree(disk_name);
 		}
 		put_device(disk->driverfs_dev);
+		disk->driverfs_dev = NULL;
 	}
-	kobject_uevent(&disk->kobj, KOBJ_REMOVE);
 	kobject_del(&disk->kobj);
 }
