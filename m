From: Adrian Bunk <bunk@fs.tum.de>
Subject: Re: SCSI sg: Questions regarding jiffies usage
Date: Tue, 13 Jul 2004 00:46:30 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040712224629.GY4701@fs.tum.de>
References: <20040711004153.GZ28324@fs.tum.de> <40F2E7EA.6010907@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:25293 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S264054AbUGLWqi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2004 18:46:38 -0400
Content-Disposition: inline
In-Reply-To: <40F2E7EA.6010907@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Mon, Jul 12, 2004 at 03:35:06PM -0400, Douglas Gilbert wrote:
> Adrian Bunk wrote:
> >Hi,
> >
> >I have some questions regarding jiffies usage in the SCSI sg driver in 
> >2.6.7-mm7:
> >
> >
> >Is there a good reason for the local sg_ms_to_jif/sg_jif_to_ms functions  
> >instead of using the time.h msecs_to_jiffies/jiffies_to_msecs macros?
> 
> Adrian,

Hi Doug,

> I don't think the msec_to_jiffies() macro was there when I
> wanted it. So the sg driver should be changed to use the
> macros in time.h .

I'll send a patch.

> >In function sg_new_write:
> >   timeout = sg_ms_to_jif(srp->header.timeout);
> >How is it possible that srp->header.timeout isn't already
> >in jiffies?
> 
> The sg_new_write() function is invoked when the sg_io_hdr
> interface structure is used (compared with the older
> sg_header structure). The unit of the timeout in the
> sg_io_hdr structure is milliseconds [which is probably
> overkill]. The mid level wants timeouts in jiffies.

As far as I can see, timeout is set in two places:

sg_add_sfp:
  sfp->timeout = SG_DEFAULT_TIMEOUT;

sg_ioctl:
  sfp->timeout = MULDIV (val, HZ, USER_HZ);

Isn't timeout set to jiffies in both places?

> >Why do both sg_add_request and sg_common_write set
> >  duration = jiffies
> 
> It doesn't look like both are required.
> 
> Doug Gilbert

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

