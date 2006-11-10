From: Andrew Morton <akpm@osdl.org>
Subject: Re: 2.6.19-rc5-mm1
Date: Thu, 9 Nov 2006 16:11:23 -0800
Message-ID: <20061109161123.f9cea1e7.akpm@osdl.org>
References: <20061109192658.GA2560@inferi.kami.home>
	<Pine.LNX.4.44L0.0611091655080.2262-100000@iolanthe.rowland.org>
	<20061109145100.01d6ec46.akpm@osdl.org>
	<f56c1ba00611091539n1d1cbe99obdb1c5f608646c96@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <f56c1ba00611091539n1d1cbe99obdb1c5f608646c96@mail.gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: =?ISO-8859-1?Q? C=E9dric?= Augonnet <cedric.augonnet@gmail.com>, Anton Vorontsov <cbou@mail.ru>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>, Mattia Dongili <malattia@linux.it>, Alan Stern <stern@rowland.harvard.edu>, Benoit Boissinot <bboissin@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 10 Nov 2006 00:39:46 +0100
"C__dric Augonnet" <cedric.augonnet@gmail.com> wrote:

> 2006/11/9, Andrew Morton <akpm@osdl.org>:
> 
> >
> > hm.  Maybe it's the disk_sysfs_symlinks() changes.
> >
> > Could someone who can reproduce this please try this revert, on
> > 2.6.19-rc2-mm2 through 2.6.19-rc5-mm1?
> >
> >
> >
> >  fs/partitions/check.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> >
> > diff -puN fs/partitions/check.c~revert-fix-ide-cs-hang-after-device-removal fs/partitions/check.c
> > --- a/fs/partitions/check.c~revert-fix-ide-cs-hang-after-device-removal
> > +++ a/fs/partitions/check.c
> > @@ -416,7 +416,7 @@ static char *make_block_name(struct gend
> >
> >  static int disk_sysfs_symlinks(struct gendisk *disk)
> >  {
> > -       struct device *target = disk->driverfs_dev;
> > +       struct device *target = get_device(disk->driverfs_dev);
> >         int err;
> >         char *disk_name = NULL;
> >
> > @@ -452,8 +452,9 @@ err_out_dev_link:
> >                 sysfs_remove_link(&disk->kobj, "device");
> >  err_out_disk_name:
> >                 kfree(disk_name);
> > -       }
> >  err_out:
> > +               put_device(target);
> > +       }
> >         return err;
> >  }
> >
> > _
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> Hi,
> 
> This patch seems to be working : whereas i had the same oops as Mattia
> each time I unplugged my USB external DD drive, now it does not happen
> anymore.
> Thank you very much for this one !
> 

OK, thanks.  I dropped the patch.  So ide-cs will now start deadlocking
again.


-------------------------------------------------------------------------
Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
