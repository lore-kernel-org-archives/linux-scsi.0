From: Benoit Boissinot <benoit.boissinot@ens-lyon.org>
Subject: Re: 2.6.19-rc5-mm1
Date: Fri, 10 Nov 2006 20:29:37 +0100
Message-ID: <20061110192937.GB9659@ens-lyon.fr>
References: <20061109192658.GA2560@inferi.kami.home>
	<Pine.LNX.4.44L0.0611091655080.2262-100000@iolanthe.rowland.org>
	<20061109145100.01d6ec46.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20061109145100.01d6ec46.akpm@osdl.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Andrew Morton <akpm@osdl.org>
Cc: Mattia Dongili <malattia@linux.it>, Alan Stern <stern@rowland.harvard.edu>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 09, 2006 at 02:51:00PM -0800, Andrew Morton wrote:
> On Thu, 9 Nov 2006 16:58:31 -0500 (EST)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Thu, 9 Nov 2006, Mattia Dongili wrote:
> > > On Thu, Nov 09, 2006 at 11:04:53AM -0800, Andrew Morton wrote:
> > > [...]
> > > > > [27526.232000] EIP: [<e8074e26>]
> > > > > scsi_device_dev_release_usercontext+0x36/0x100 [scsi_mod] SS:ESP
> > > > > 0068:dfdb1e3c
> > > > > 
> > > > > full dmesg attached, I can test patches and provide any useful
> > > > > information if needed (just not now because the dock is at work).
> > > > 
> > > > You're the second or third person to report this (to no effect, btw). 
> > > 
> > > oh, great. I was going to report the same (had with usb key unplug).
> > > Linux version 2.6.19-rc5-mm1-1 (mattia@tadamune) (gcc version 4.1.2 20060901 (prerelease) (Debian 4.1.1-13)) #4 SMP Wed Nov 8 22:46:11 CET 2006
> > 
> > I don't know exactly where the problem lies, but I have narrowed it down.
> > 
> > In drivers/scsi/sd.c:sd_probe(), the call to add_disk() increases the 
> > device's refcount by 1.  However in sd_remove(), the call to del_gendisk() 
> > decreases the device's refcount by 2.  Consequently the structure is 
> > deallocated too early, causing the oops.
> > 
> > Somebody who knows more than I do about add_disk() and del_gendisk() will 
> > have to figure what's going wrong.
> > 
> 
> hm.  Maybe it's the disk_sysfs_symlinks() changes.
> 
> Could someone who can reproduce this please try this revert, on
> 2.6.19-rc2-mm2 through 2.6.19-rc5-mm1?
> 

I confirm it fixes it for me too.

regards,

Benoit

-- 
:wq

-------------------------------------------------------------------------
Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
