From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: Remove scsi_wait_scan module
Date: Mon, 28 May 2012 16:07:46 +0400
Message-ID: <1338206866.6330.22.camel@dabdike>
References: <1338110026.2957.5.camel@dabdike.int.hansenpartnership.com>
	 <20120528100015.GB10036@vostochny.stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120528100015.GB10036-VJknIhvjf2Ov8OlOgJ4AIV6hYfS7NtTn@public.gmane.org>
Sender: initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: maximilian attems <max-U9r9yeDMy7A@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Mahoney <jeffm-l3A5Bk7waGM@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, initramfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-05-28 at 10:00 +0000, maximilian attems wrote:
> On Sun, May 27, 2012 at 10:13:46AM +0100, James Bottomley wrote:
> > scsi_wait_scan was introduced with asynchronous host scanning as a hack
> > for distributions that weren't using proper udev based wait for root to
> > appear in their initramfs scripts.  In 2.6.30 Commit 
>  
> > c751085943362143f84346d274e0011419c84202
> > Author: Rafael J. Wysocki <rjw-KKrjLPT3xs0@public.gmane.org>
> > Date:   Sun Apr 12 20:06:56 2009 +0200
> > 
> >     PM/Hibernate: Wait for SCSI devices scan to complete during resume
> > 
> > Actually broke scsi_wait_scan because it renders
> > scsi_complete_async_scans() a nop for modular SCSI if you include
> > scsi_scans.h (which this module does).
> > 
> > The lack of bug reports is sufficient proof that this module is no
> > longer used.
> 
> We do use it in initramfs-tools.
> 
> There is quite a number of bug reports moaning about having to boot with
> `scsi_mod.scan=sync'. I didn't pass them on, because I didn't knew that
> the module itself got broken, for example:
> http://bugs.debian.org/616689

OK, so what these bugs show is the breakage ... basically scsi_wait_scan
isn't really waiting for the scans to complete.  I can fix it in stable
so you can close your bug reports, but if I do, can you also transition
away from using it so I can remove it in 3.5?

James
