From: Douglas Gilbert <dougg@torque.net>
Subject: SAS illegal toplogies [was Re: [PATCH 1/4 v2] libsas: Don't BUG when
 connecting two expanders via wide port]
Date: Tue, 30 Jan 2007 17:26:19 -0500
Message-ID: <45BFC60B.10809@torque.net>
References: <20070130074810.7612.31980.stgit@elm3a70.beaverton.ibm.com> <20070130074816.7612.6444.stgit@elm3a70.beaverton.ibm.com> <45BFA57F.5020408@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50856 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbXA3W0a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jan 2007 17:26:30 -0500
In-Reply-To: <45BFA57F.5020408@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, alexisb@us.ibm.com

Darrick J. Wong wrote:
> libsas: Don't BUG when connecting two expanders via wide port
> 
> When a device is connected to an expander, the discovery process goes through
> sas_ex_discover_dev to figure out what's attached to the phy.  If it is the
> case that the phy being discovered happens to be the second phy of a wide link
> to an expander, that discover_dev function will incorrectly call
> sas_ex_discover_expander, which creates another sas_port and tries to attach the
> other sas_phys to the new port, thus triggering a BUG.  The correct thing to do is
> to check the other ex_phys of the expander to see if there's a sas_port for this
> sas_phy, and attach the sas_phy to the existing sas_port.
> 
> This is easily triggered if one enables the phys of a wide port between
> expanders one by one.
> 
> This second version of the patch fixes a small regression in the case where
> all the phys show up at once and we accidentally try to attach to a port
> that hasn't been created yet.

Darrick,
Okay.

Now I'm wondering what the discovery algorithm in libsas
does if it finds truly illegal connections between expanders.
The spec defines what is illegal but says it is vendor specific
what will be done.

One approach is to use the SMP PHY CONTROL function to disable
the phy (or the phys at both ends of the illegal link). The
next trick is how to tell the user who just connected a cable
between expanders that "you can't do that!". Tools like my
smp_discover could alert a user to a disabled phy but
without turning it back on (and causing the libsas discovery
algorithm another headache) my SMP utilities don't know what
it is connected to.

Another question is which link to disable. Imagine three
expanders interconnected with 3 links which is illegal.
Breaking any one link makes it legal, but which one
to break? Last seen, or perhaps the link which has
the largest SAS address sum ...

Doug Gilbert
