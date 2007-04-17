From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 4/4] libata: implement libata.spindown_compat
Date: Tue, 17 Apr 2007 10:45:41 -0400
Message-ID: <4624DD95.3070608@garzik.org>
References: <20070320150718.GF6152@htj.dyndns.org> <20070320151359.GG6152@htj.dyndns.org> <20070320152533.GH6152@htj.dyndns.org> <20070320155548.GI6152@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070320155548.GI6152@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, djwong@us.ibm.com, hmh@hmh.eng.br
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> Now that libata uses sd->manage_start_stop, libata spins down disk on
> shutdown.  In an attempt to compensate libata's previous shortcoming,
> shutdown(8) syncs and spins down disks attached via libata.  Some
> disks spin back up just to spin down again on STANDBYNOW1 if the
> command is issued when the disk is spun down, so this double spinning
> down causes problem.
> 
> This patch implements module parameter libata.spindown_compat which,
> when set to one (default value), prevents libata from spinning down
> disks on shutdown thus avoiding double spinning down.  Note that
> libata spins down disks for suspend to mem and disk, so with
> libata.spindown_compat set to one, disks should be properly spun down
> in all cases without modifying shutdown(8).
> 
> shutdown(8) should be fixed eventually tho.  Some drive do spin up on
> SYNCHRONZE_CACHE even when their cache is clean.  Those disks
> currently spin up briefly when sd tries to shutdown the device and
> then the machine powers off immediately, which can't be good for the
> head.  We can't skip SYNCHRONIZE_CACHE during shudown as it can be
> dangerous data integrity-wise.
> 
> So, this spindown_compat parameter is already scheduled for removal by
> the end of the next year and here's what shutdown(8) should do.
> 
>   1. Check whether /sys/modules/libata/parameters/spindown_compat
>      exists.  If it does, write 0 to it.
> 
>   For each libata harddisk {
> 
>     2. Check whether /sys/class/scsi_disk/h:c:i:l/manage_start_stop
>        exists.  If so, write 1 to it and continue; otherwise, fall
>        through to #3.
> 
>     3. Synchronize cache and spin down as before.
> 
>   }
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> Henrique, does it look good enough?  How do we coordinate this with
> distributions?  I can take care of suse and I guess Alan/Jeff can do
> so for redhat.  So, that leaves us with Debian, Ubuntu, Gentoo...

ACK patches 3-4 for upstream.  I'm dropping them, and requesting resend 
when patches 1-2 are applied (which I also ACK).  Or, alternately, I 
could apply all four patches with the other subsystem owner's assent, or 
the other subsystem owner could apply all four patches now that I have 
ACK'd them.  Pick any of the three options. :)

	Jeff





