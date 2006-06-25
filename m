From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Sun, 25 Jun 2006 16:46:31 -0600
Message-ID: <20060625224631.GD1608@parisc-linux.org>
References: <20060511143352.GI12272@parisc-linux.org>
	<20060518172258.GL1604@parisc-linux.org>
	<20060529031915.GB23405@parisc-linux.org>
	<447AB2F5.2000700@s5r6.in-berlin.de>
	<20060529130515.GE23405@parisc-linux.org>
	<20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru>
	<20060601132315.GD32143@parisc-linux.org>
	<1151270127.3617.26.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <1151270127.3617.26.camel@mulgrave.il.steeleye.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-hotplug-devel@lists.sourceforge.net, Stefan Richter <stefanr@s5r6.in-berlin.de>, "Alexander E. Patrakov" <patrakov@ums.usu.ru>, linux-scsi@vger.kernel.org, Patrick Mansfield <patmans@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jun 25, 2006 at 04:15:26PM -0500, James Bottomley wrote:
> Actually, the first problem is that SCSI doesn't compile as a module at
> all:  late_initcalls are defined to be module_init calls for modules.
> Your adding this to scsi_scan.c now gives us two module_init calls,
> which won't build.  I fixed this by putting an #ifdef MODULE around the
> late_initcall.

I think that's a good idea (well, I would, I suggested it to you ;-)

> > There's a potential solution to this.  If we add a hook to sys_module_init
> > such that it'll call a specified function before returning, we can make
> > it wait until all scans are done.  This way, userspace never sees the
> > asynchronous scanning behaviour.  But if you have devices of different
> > types, you won't get the overlapping scans.
> 
> How about this solution which works for me with debian on a huge 6 bus
> scsi machine:  it introduces a new module scsi_wait_scan.ko whose sole
> job is to wait for the scans to complete in its init function.  The
> initrd/initramfs sequence now becomes:
> 
> insert all other modules
> modprobe scsi_wait_scan

I think that's a great idea.  I wonder about making it always fail
initialisation, since then it can be loaded multiple times without being
unloaded.  I think Arjan was suggesting some proc or sysfs file that
would cause scsi_complete_async_scans() to be called, but I couldn't
figure out where a good place to put such a file would be. 

> @@ -22,6 +22,10 @@
>  
>  obj-$(CONFIG_SCSI)		+= scsi_mod.o
>  
> +ifeq ("$(CONFIG_SCSI)", "m")
> +	obj-m			+= scsi_wait_scan.o
> +endif

We seem to have a bit of an allergy to conditionals in Makefiles these
days; how about:

tmp-$(CONFIG_SCSI)	:= scsi_wait_scan.o
obj-m 			+= $(tmp-m)

>  
> -static int scsi_complete_async_scans(void)
> +int scsi_complete_async_scans(void)
>  {
>  	struct async_scan_data *data;
>  
> @@ -157,8 +157,10 @@
>  	kfree(data);
>  	return 0;
>  }

Do you think it's worth putting in something like:

/* Only exported for the benefit of scsi_wait_scan */

And maybe ...

#ifdef MODULE
/* Only exported for the benefit of scsi_wait_scan */
EXPORT_SYMBOL_GPL(scsi_complete_async_scans);
#else
late_initcall(scsi_complete_async_scans);
#endif

I really don't want to see driver authors calling it -- if they are,
something's gone pretty horribly wrong.

Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
