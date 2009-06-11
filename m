From: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Subject: Re: PATCH: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID
 controller
Date: Thu, 11 Jun 2009 06:11:07 -0700 (PDT)
Message-ID: <alpine.LNX.1.10.0906110608570.3603@rslab159.pmc-sierra.bc.ca>
References: <alpine.LNX.1.10.0906101259500.24722@rslab159.pmc-sierra.bc.ca> <da824cf30906102014re508926lf4e64c0f0623291e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:43051 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751740AbZFKNwK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jun 2009 09:52:10 -0400
In-Reply-To: <da824cf30906102014re508926lf4e64c0f0623291e@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, gregkh@suse.de


Hi Grant,

Thanks for all your inputs. I will look into each one of them and get back 
to you soon.

with regards,
   Anil

On Wed, 10 Jun 2009, Grant Grundler wrote:

> On Wed, Jun 10, 2009 at 1:07 PM, Anil
> Ravindranath<anil_ravindranath@pmc-sierra.com> wrote:
> > Hi, This patch adds a driver to support PMC-Sierra 6Gb/s SAS RAID controller.
> 
> Anil,
> 
> Thanks for posting this patch!
> I'm very glad to see it. Please don't take the comments below too
> negatively, they are
> really targeted at the code.
> 
> And because my employer's preferred email handler is broken WRT handling patches
> ("reply" got word wrapped entirely...utter crap), I'll just cut/paste
> the bits I'm commenting
> on in this round...just some quick feedback before I bail for the day.
> 
> 
> +/*
> + * pmcraid_driver_build_date - get the driver build date.
> + * This routine makes use of GCC's __DATE__ macro and frames an integer with
> + * month, day and year values retrieved.
> + */
> +static inline int pmcraid_driver_build_date(void)
> +{
> +       char cdate[32];
> +       char mon[12];
> +       char day[12];
> +       char year[12];
> +       char *months[] = { "Jan", "Feb", "Mar", "Apr", "May", "Jun",
> +               "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
> +       };
> +       int i_month, i_day, i_year;
> +       int i = 0, j = 0;
> ...
> 
> 
> All the "driver build date" stuff can be deleted.
> 
> The build date is embedded whenever someone compiles the kernel and
> it's embeded in the kernel string. E.g.:
> # uname -a
> Linux hostA 2.6.26-2-amd64 #1 SMP Fri Mar 27 04:02:59 UTC 2009 x86_64 GNU/Linux
> 
> Folks can separately build the module. But the module version is what
> matters and not the build date.
> An older version with a newer build date is still an older version. At
> both HP and Google, I never
> cared about the build date of any driver module.
> 
> What I would be interested in are the compiler version/flags used to
> build a module.
> I don't know if that is captured in modinfo fields though. We should
> consider doing
> that by default if someone knows how to do it easily.  Kernel newbie project?
> 
> 
> +/*
> + * pmcraid_driver_version - structure defining PMC MaxRAID controller driver
> + * version information.
> + *
> + * .day     : driver build date, day of month (1 to 31)
> + * .month   : driver build date, month of the year (1 to 12)
> + * .year    : driver build date, year
> + * .version : version number in major_version << 16 | minor version < 8 | patch
> + * .name    : driver module name
> + */
> 
> pmcraid_get_driver_version() and related code can also be deleted.
> The correct way to handle this is via "modinfo".
> 
> Driver versioning is handled with MODULE_VERSION() and you've already
> used that correctly.
> 
> 
> +#if !defined(VERSION)
> +#define PMCRAID_DRIVER_VERSION         "1.0.0"
> +#else
> +#define PMCRAID_DRIVER_VERSION         VERSION
> +#endif
> 
> I'm not sure I like this. My fear is that might get defined someplace
> else already.
> However, I can see how it would be useful to track different .ko files when
> evaluating different compilers, compiler options or other -DPMC_FAST_MODE
> type flags.
> 
> In any case, "VERSION" is too generic. Please don't use that exact string.
> 
> 
> +#define PMCRAID_DEVFILE                "pmcsas"
> 
> is defined twice in drivers/scsi/pmcraid.h.
> Isn't udev or some other tool responsible for setting this up?
> I don't recall any other driver encoding what it's /dev files shoud
> be called.  But I'm not clueful about PMCRAID_DEVFILE use yet.
> 
> 
> And I noticed lots of IOCTLs...some of which could be deleted.
> I'll send more feedback at a later date. The above should be
> something to get started on though.
> 
> thanks!
> grant
> 
