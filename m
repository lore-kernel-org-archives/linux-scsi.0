From: Dave Olien <dmo@osdl.org>
Subject: Re: [dm-devel] [ANNOUNCE] multipath-tools-0.3.0
Date: Thu, 7 Oct 2004 13:01:43 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041007200143.GA9667@osdl.org>
References: <1096071849.4466.31.camel@zezette> <1097054573.4163b96d1262c@imp5-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1097054573.4163b96d1262c@imp5-q.free.fr>
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Christophe,

I downloaded your new multipath tools, and they seem to have solved a problem
I was having with the previous version.

The only difficulty I had was with the new klibc version (klibc-0.181).
For i386 architecture, it compiles by default with -mregparm=3, to
pass arguments in registers.

But with my version of compiler (gcc 3.2.2), the rest of the multipath
libraries and utilities were compiled to pass arguments on the stack.
So the resulting binaries segfault the first time they call a klibc library.

I modified the klibc/klibc/arch/i386/MCONFIG file to compile with
stack argument passing, and everything works great.

Is there a compiler version now that by default passes arguments
in registers?

Thanks!
Dave Olien

On Wed, Oct 06, 2004 at 11:22:53AM +0200, christophe.varoqui@free.fr wrote:
> Hello,
> 
> here goes multipath-tools-0.3.0
> 
> Faster release cycle.
> Big things for some people out there.
> Upgrade will need you to manualy remove your /etc/udev/rules.d/multipath.rules
> and kill your devmap_name rule in udev.rules (we use a separate rules.d file
> now)
> 
> In short :
> 
> 
> * easy multipath-aware initrds on Debian SID
> 	* fully fonctionnal with direct-attached SCSI disks (single-path)
> 
> Full ChangeLog for the release :
> 
>         * first cut at making scripts to create multipath-aware initrds
> 	  those scripts are tested on Debian SID, and must be copied into
> 	  /etc/mkinitrd/scripts. it works here.
> 	* [multipath] verify presence of the /sys/block/... node before
> 	  reading sysfs attributes. Avoids libsysfs and scsi_id stderr
> 	  garbage
> 	* [multipath] move down the stderr close (Ake Sandgren at umu.se)
> 	* [multipath] don't care about 0-sized mp (Ake Sandgren at umu.se)
> 	* [multipath] bump mp size field to ulong (Ake Sandgren at umu.se)
> 	* [multipath] replace quiet/verbose flags by a verbosity one.
> 	  introduce a new verbosity level : 1 == print only devmap names
> 	  thus we can feed kpartx with that output
> 	* [multipath] update man page to reflect the hotplug.d -> dev.d
> 	  transition and replace the obsolete group_by_tur policy by the
> 	  forgotten group_by_prio
> 	* [multipath] provide a /etc/udev/rules.d/multipath.rules for
> 	  multipath devices naming. Cleaner than the previously suggested
> 	  rule addition in the main udev.rules
> 	* [multipath] move out of hotplug.d to dev.d : kill synchronisation
> 	  problems between device node creation and multipath execution.
> 	  Incidentally the unfriendly $DEVPATH param become a friendly
> 	  $DEVNAME (simply /dev/sdb)
> 	* [multipath] rework the iopolicies name-to-id & id-to-name
> 	  translations. kills the last compilation warning here too
> 	* [kpartx] kill last compilation warnings
> 	* bump klibc to 0.181
> 	* add the debian/ packaging dir (make deb)
> 	* prototype __clone & __clone2 (kills compilation warning)
> 
> As usual, doc and download at :
> http://christophe.varoqui.free.fr/
> 
> regards,
> --
> christophe varoqui <christophe.varoqui@free.fr>
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
