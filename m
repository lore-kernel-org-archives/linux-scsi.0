From: Austin Gonyou <austin@digitalroadkill.net>
Subject: Re: max_scsi_luns and 2.4.19-pre10.
Date: 26 Jun 2002 09:18:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1025101125.19558.4.camel@UberGeek>
References: <1025052385.19462.5.camel@UberGeek>
	  <20020626123337.GC1217@gum01m.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020626123337.GC1217@gum01m.etpnet.phys.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Wed, 2002-06-26 at 07:33, Kurt Garloff wrote:
> Hi Austin,
> 
> enough guesses have been there not answering your questions ...

Sure I hear that. But I posted an earlier question about QLA2200 and a
PV 660F and not seeing > 8 luns with 2.4.19-pre10. 


> On Tue, Jun 25, 2002 at 07:46:25PM -0500, Austin Gonyou wrote:
> > This originally was asking for help regarding QLA2200's, but I've since
> > discovered it's a kernel param problem that I'm not sure how to solve.
> > 
> > Using a default RH kernel (from SGI XFS installer) and passing
> > max_scsi_luns=128 in grub, and for scsi_mod, it seems to work. 
> 
> In 2.4.19pre1 a patch was merged into mainline which introduced a flag
> BLIST_LARGELUN and set it for EMC Symmetrix devices. Some distributors
> (incl. RH and SuSE) did ship kernels with this patch included.
> http://van-dijk.net/linuxkernel/200206/0347.html
> (An older patch for 2.4.16 exists as well.)


I'll take a look at that, and see if I can merge it into -aa4. 

> The flag does allow a device to use more than 8 LUNs despite it reporting
> as SCSI Version 2 devices (which can not support more than 8 LUNs normally
> ...) 
> The flag also needs to be set for some more devices, look for DGC, DELL, CMD
> and CNSi/CNSI devices that already have the BLIST_SPARSELUN flag.

This would be a DELL device, so I'll see about changing it from
SPARESLUN to LARGELUN?

> But as you did not post the output of /proc/scsi/scsi nor the syslog
> meesages from your SCSI subsystem nobody knows what devices you're using or
> what actually happens. Just speculations ...

There's nothing to post from /proc/scsi/scsi or the syslog other than
there's no more than 8 devices on my FC chain. I guess the real point
here is that if you're using FC, you're probably going to use more than
8 luns, even if not immediately. Especially for large Databases. 

> PS: The better list for such questions is linux-scsi@vger.kernel.org

That makes sense I'll post to that list immediately and see what I can
get. Sorry for the confusion. 


> Regards,
> -- 
> Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
> GPG key: See mail header, key servers         Linux kernel development
> SuSE Linux AG, Nuernberg, DE                            SCSI, Security
-- 
Austin Gonyou <austin@digitalroadkill.net>
