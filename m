From: Douglas Gilbert <dougg@torque.net>
Subject: Re: lk 2.5.49 module frustration
Date: Sat, 23 Nov 2002 23:42:40 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DDF77C0.3000803@torque.net>
References: <3DDEF2A2.8050701@torque.net> <20021123032616.GD19547@redhat.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi@vger.kernel.org

Doug Ledford wrote:
> On Sat, Nov 23, 2002 at 02:14:42PM +1100, Douglas Gilbert wrote:
> 
>>Hopefully others are having more success with the new
>>module loader than I am. My system is basically RH8.0
>>with the new module-init-tools (version 0.7) loaded
>>and the recent 2.5.49 kernel.
>>
>>During system load there is noise (failure?) on calls
>>to modprobe since the new command doesn't support the same
>>switches as the old. [harmless?]
> 
> 
> It doesn't yet.  It's intended to.
> 
> 
>>My lsmod looks like this:
>># lsmod
>>Module                  Size  Used by
>>scsi_debug             29423  0 [unsafe]
>>ohci1394               21561  0
>>ieee1394               41773  1 ohci1394 [unsafe]
>>parport_pc             18883  0 [unsafe]
>>parport                30228  1 parport_pc [unsafe]
>>ehci_hcd               32801  0
>>usbcore                90237  3 ehci_hcd
>>
>>Those "unsafe" dependencies wedge in a module, making
>>it hard to remove them. In the case of scsi_debug about
>>30 seconds after it is loaded I get this on my console:
>># Module scsi_debug cannot be unloaded due to unsafe
>># usage in fs/proc/inode.c:204
>>That is procfs calling __MOD_INC_USE_COUNT. Is that our
>>problem (i.e. shouldn't RR fix that before he lets this
>>stuff loose on us)?
> 
> 
> I posted a patch for this almost a week back.  It didn't get picked up, so 
> I put this particular fix into my tree that I uploaded and announced 
> today.
> 
> 
>>Are all the MODULE_* macros now dead? I can no longer
>>get any load time options/parameters through to the
>>scsi_debug. Nothing useful comes out of modinfo.
> 
> 
> Yes, it's very much a work in process, not a completed change over.  Rusty 
> has publically stated that he thinks he bit off more than he can chew and 
> I know he's taken a lot of flak over this change.  However, there *are* 
> positive parts to Rusty's work and it does in fact solve the races he says 
> it solves (at least once you convert things like fs/proc/inode.c to know 
> about the fact that getting a module *can* fail) and as soon as you get 
> the remaining parts of the kernel to properly grab module references when 
> calling into a module.  Myself and Cristoph already did that basic job for 
> the SCSI layer.

BTW I meant (but didn't spell out) MODULE_PARM, MODULE_LICENSE
et cetera.

> 
> 
>>Where is the ..... documentation?
>>$ ls -l modules.txt
>>-rw-r--r--    1 1046     101          9441 Feb 17  2001 modules.txt
> 
> 
> Yes, that's another thing that isn't complete.

Doug,
Thanks for the reply. Seems as though developers who relied
on the flexibility of modules may need to find alternate
techniques for the next little while.

Doug Gilbert


