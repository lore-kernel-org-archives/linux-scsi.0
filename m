From: James Bottomley <jejbbe@hansenpartnership.com>
Subject: Re: 3.4.0-02580-g72c04af regression on sparc64 - partitions not
 recognized
Date: Thu, 24 May 2012 08:42:41 +0100
Message-ID: <1337845361.2955.6.camel@dabdike.int.hansenpartnership.com>
References: <alpine.SOC.1.00.1205221200050.9585@math.ut.ee>
	 <20120522.151217.278388169416093561.davem@davemloft.net>
	 <alpine.SOC.1.00.1205231945480.12326@math.ut.ee>
	 <20120523.140451.386112705611304887.davem@davemloft.net>
	 <1337813770.3013.37.camel@dabdike.int.hansenpartnership.com>
	 <1337826142.6877.7.camel@dwillia2-mobl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337826142.6877.7.camel@dwillia2-mobl>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: David Miller <davem@davemloft.net>, mroos@linux.ee, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, stern@rowland.harvard.edu, "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-05-23 at 19:22 -0700, Dan Williams wrote:
> On Wed, 2012-05-23 at 23:56 +0100, James Bottomley wrote:
> > On Wed, 2012-05-23 at 14:04 -0400, David Miller wrote:
> > > From: Meelis Roos <mroos@linux.ee>
> > > Date: Wed, 23 May 2012 19:46:46 +0300 (EEST)
> > > 
> > > CC:'ing interested parties.
> > > 
> > > >> > Just tested 3.4.0-02580-g72c04af on about 10 machines. While most of 
> > > >> > them work (including 3 different sparc64 machines with real scsi disks), 
> > > >> > Sun Netra X1 with pata_ali and IDE disk consistently fails to boot. sda 
> > > >> > is recognized but no partitions. 3.3.0 works fine, as did something 
> > > >> > around 3.4-rc7 (plain 3.4 not tested yet). No other IDE machines tested 
> > > >> > yet since I have none with remote console at the moment.
> > > >> 
> > > >> If 3.4.0-final is OK, start bisecting from v3.4.0 until 72c04af.  One
> > > >> possibility could be the sparc64 NOBOOTMEM conversion that went into
> > > >> the merge window.
> > > > 
> > > > Bisecting leads to this commit:
> > > > 
> > > > a7a20d103994fd760766e6c9d494daa569cbfe06 is the first bad commit
> > > > commit a7a20d103994fd760766e6c9d494daa569cbfe06
> > > > Author: Dan Williams <dan.j.williams@intel.com>
> > > > Date:   Thu Mar 22 17:05:11 2012 -0700
> > > > 
> > > >     [SCSI] sd: limit the scope of the async probe domain
> > 
> > My theory is that this is an init problem: The assumption in a lot of
> > our code is that async_synchronize_full() waits for everything ... even
> > the domain specific async schedules, which isn't true.
> > 
> > The code in init that makes this assumption is wait_for_device_probe().
> > There's also a fun async_synchronize_full() in init_post() that assumes
> > it can free the init memory after, which would fail badly if anything in
> > init used an async domain.
> > 
> > So either we fix the assumptions or we can't use domain specific async
> > schedules.
> > 
> 
> Hm, we already have cases of code not trusting the semantics of
> wait_for_device_probe(), especially as it relates to async scanning like
> in kernel/power/hibernate.c:
> 
>                 /*
>                  * Some device discovery might still be in progress; we need
>                  * to wait for this to finish.
>                  */
>                 wait_for_device_probe();
> 
>                 if (resume_wait) {
>                         while ((swsusp_resume_device = name_to_dev_t(resume_file)) == 0)
>                                 msleep(10);
>                         async_synchronize_full();
>                 }
> 
>                 /*
>                  * We can't depend on SCSI devices being available after loading
>                  * one of their modules until scsi_complete_async_scans() is
>                  * called and the resume device usually is a SCSI one.
>                  */
>                 scsi_complete_async_scans();

This is actually looks wrong: it works if SCSI is built in, but it's a
nop if SCSI is a module (the nop function is gated by the else clause of
#ifdef CONFIG_SCSI)

Rafael, you added this not via the SCSI tree, is that the intention?

> ...so it seems scsi_complete_async_scans() should take care to flush sd
> probe actions as well... here is a test patch:
> 
> --- snip ---
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 8906557..05a92d3 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -141,13 +141,13 @@ struct async_scan_data {
>   * started scanning after this function was called may or may not have
>   * finished.
>   */
> -int scsi_complete_async_scans(void)
> +static void __scsi_complete_async_scans(void)
>  {
>         struct async_scan_data *data;
>  
>         do {
>                 if (list_empty(&scanning_hosts))
> -                       return 0;
> +                       return;
>                 /* If we can't get memory immediately, that's OK.  Just
>                  * sleep a little.  Even if we never get memory, the async
>                  * scans will finish eventually.
> @@ -181,6 +181,13 @@ int scsi_complete_async_scans(void)
>         spin_unlock(&async_scan_lock);
>  
>         kfree(data);
> +}
> +
> +int scsi_complete_async_scans(void)
> +{
> +       __scsi_complete_async_scans();
> +       async_synchronize_full_domain(&scsi_sd_probe_domain);
> +
>         return 0;
>  }

But this still doesn't fix the boot problem, does it? ... unless we want
to add a scsi_complete_async_scans() into init/do_mounts.c, which looks
like piling one hack on top of another.

I really think the correct fix is to have wait_for_device_probe()
actually wait until all probes have completed and everything is
discovered, that way we get the semantics the name implies and boot
should just work.

James
