From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
Date: Wed, 11 Jul 2007 09:51:05 -0700
Message-ID: <20070711095105.ed166521.kristen.c.accardi@intel.com>
References: <20070705194909.337398431@intel.com>
	<20070705130518.135e4e3c.kristen.c.accardi@intel.com>
	<20070709193603.GA5722@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7920 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbXGKQyS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jul 2007 12:54:18 -0400
In-Reply-To: <20070709193603.GA5722@ucw.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: jeff@garzik.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@steeleye.com, edwintorok@gmail.com, axboe@kernel.dk, linux-scsi@vger.kernel.org

On Mon, 9 Jul 2007 19:36:04 +0000
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > This patch will modify the scsi subsystem to allow
> > users to set a power management policy for the link.
> > 
> > The scsi subsystem will create a new sysfs file for each
> > host in /sys/class/scsi_host called "link_power_management_policy".
> > This file can have 3 possible values:
> > 
> > Value		Meaning
> > -------------------------------------------------------------------
> > min_power	User wishes the link to conserve power as much as
> > 		possible, even at the cost of some performance
> > 
> > max_performance User wants priority to be on performance, not power
> > 		savings
> > 
> > medium_power	User wants power savings, with less performance cost
> > 		than min_power (but less power savings as well).
> 
> Has that anything to do with HIPM vs. DIPM? 
> 
> 							Pavel
Hi Pavel,
I'm not sure I'm understanding your question, but if you mean the different
levels of power savings you would get, no.  With ALPM you have the option of
instructing the link to either go into slumber or partial mode when it 
determines the link is quiet.  Slumber uses less power, but has more latency
to come out of.  So, for a SATA device, setting the link_power_managment
file to "medium_power" will set up the link to only go into Partial mode,
which has less power savings (about half by my informal measurement), but 
less latency, and therefore less of a performance hit.

Hopefully this answers your question.
Kristen
