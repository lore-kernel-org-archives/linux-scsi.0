From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: compile new kernel in order to install DEll OMSA software on Dell
	Poweredge 2850 with PERC 4e Raid Controller
Date: Wed, 27 Apr 2005 13:21:41 -0500
Message-ID: <20050427182141.GA23203@lists.us.dell.com>
References: <200504271835.30826.oliver@windfinder.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-poweredge-bounces@dell.com>
Content-Disposition: inline
In-Reply-To: <200504271835.30826.oliver@windfinder.com>
List-Unsubscribe: <http://lists.us.dell.com/mailman/listinfo/linux-poweredge>,
	<mailto:linux-poweredge-request@dell.com?subject=unsubscribe>
List-Archive: <http://lists.us.dell.com/pipermail/linux-poweredge>
List-Post: <mailto:linux-poweredge@dell.com>
List-Help: <mailto:linux-poweredge-request@dell.com?subject=help>
List-Subscribe: <http://lists.us.dell.com/mailman/listinfo/linux-poweredge>,
	<mailto:linux-poweredge-request@dell.com?subject=subscribe>
Sender: linux-poweredge-bounces@dell.com
Errors-To: linux-poweredge-bounces@dell.com
To: oliver@windfinder.com
Cc: linux-poweredge@dell.com, linux-scsi@vger.kernel.org, aschultz@warp10.net, "Ju, Seokmann" <sju@lsil.com>, Alexander Klein <ak@jenomics.de>, Thomas Glas <thomas.glas@hanse.net>, Jay Wineinger <jay@ffsi.com>, Jonas Kaufmann <me@j0nes.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 27, 2005 at 06:35:30PM +0200, oliver@windfinder.com wrote:
> Hello,
> I followed the instructions from Jay Wineinger at 
> http://shadsplace.org/PE2650/ with the only difference that I used a 
> different config file (see below) because I have different hardware. 
> 
> After havinf compiled the new kernel and rebooting into the new kernel I get:
> 
> This is the the what happened after booting into the new kernel:
> [..]
> kmod: failed to exec /sbin/modprobe -s -k block-major-8, errno = 2

errno=2 is "No such file or directory".  Meaning modprobe isn't in
your initial ramdisk.  You're using an initial ramdisk, right, as your
SCSI subsystem (scsi_mod) and your SCSI device drivers are all modular.


> VFS: Cannot open root device "sda2" or 08:02
> Please append append correct "root=" boot option
> Kernel panic: VFS: Unable to mount root fs on 08:02

which is expected, as you don't have any SCSI drivers loaded.


Either use an initrd, or change all the CONFIG_SCSI* entries you care
about to =y.

Thanks,
Matt

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

_______________________________________________
Linux-PowerEdge mailing list
Linux-PowerEdge@dell.com
http://lists.us.dell.com/mailman/listinfo/linux-poweredge
Please read the FAQ at http://lists.us.dell.com/faq
