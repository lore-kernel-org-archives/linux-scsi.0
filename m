From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: section mismatches (scsi e.g.)
Date: Fri, 14 Apr 2006 11:27:22 -0700
Message-ID: <20060414112722.f035fc0c.rdunlap@xenotime.net>
References: <20060414092911.71f25ac1.rdunlap@xenotime.net>
	<20060414165210.GA4053@mars.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:44185 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1751332AbWDNSY4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Apr 2006 14:24:56 -0400
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 14 Apr 2006 11:24:54 -0700
In-Reply-To: <20060414165210.GA4053@mars.ravnborg.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-scsi@vger.kernel.org

On Fri, 14 Apr 2006 18:52:10 +0200 Sam Ravnborg wrote:

> On Fri, Apr 14, 2006 at 09:29:11AM -0700, Randy.Dunlap wrote:
> > Hi Sam,
> > 
> > I was looking at these warnings (on 2.6.17-rc1-git8):
> > 
> > WARNING: drivers/scsi/3w-9xxx.o - Section mismatch: reference to .init.data: from .data between 'twa_driver' (at offset 0x18) and 'twa_error_table'
> > WARNING: drivers/scsi/3w-xxxx.o - Section mismatch: reference to .init.data: from .data between 'tw_driver' (at offset 0x18) and 'tw_sense_table'
> > WARNING: drivers/scsi/gdth.o - Section mismatch: reference to .init.text:gdth_detect from .data between 'driver_template' (at offset 0x270) and 'async_cache_tab'
> > 
> > I either don't see a problem or I'm having trouble reading/decoding
> > the warning messages.  Could you look at these 3 sometime?
> 
> > WARNING: drivers/scsi/3w-9xxx.o
> twa_driver contains a reference to twa_pci_tbl which is marked
> devinitdata.
> 
> Darren Jenkins already pointed this pattern out but somehow I lost
> the patch (not applied).
> It is here:

[snip]

> > WARNING: drivers/scsi/gdth.o 
> >From modpost.c:
> * Pattern 2:
> *   Many drivers utilise a *_driver container with references to
> *   add, remove, probe functions etc.
> *   These functions may often be marked __init and we do not want to
> *   warn here.
> *   the pattern is identified by:
> *   tosec   = .init.text | .exit.text
> *   fromsec = .data
> *   atsym = *_driver, *_ops, *_probe, *probe_one
> **/
> 
> Shall we include *_template in this list?

I would say yes.

> The most common name seems to be the ambigous driver_template.
> Some scsi drievers has been a bit more specific and used
> <driver>_template.
> In total 76 drivers.
> 
> 16 drivers uses: *_sht for their scsi_host_template variables.
> And one uses NCR_Q720_tpnt.
> 
> I will push the 'lost' patch later today.

+ I don't see the inconsistencies that James mentioned.

Thanks.

---
~Randy
