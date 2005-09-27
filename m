From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Tue, 27 Sep 2005 17:55:53 -0400
Message-ID: <4339BFE9.1060604@pobox.com>
References: <43384E28.8030207@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:41692 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S965177AbVI0Vz7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Sep 2005 17:55:59 -0400
In-Reply-To: <43384E28.8030207@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> I request inclusion of the SAS Transport Layer
> and the AIC-94xx SAS LLDD into the Linux kernel.

Overall, I see the following major issues.  My recommendation is that 
this driver live in -mm, or outside the kernel tree, for a while to let 
things shake out.


Background
----------
* There is no question that Adaptec's aic94xx and SAS code is correct 
WRT the SCSI specifications.  The maintainer eats, sleeps, and breathes 
SAS specs.  :)

* aic94xx hardware supports both SAS and SATA connections.  Since SAS 
and SATA are intentionally similar electrically, other vendors are 
coming out with SATA+SAS hardware too.

* Acronym:  "HCIL"  Stands for Host/Channel/ID/LUN.  Pre-SAS legacy 
addressing method.


Issues
------
* Avoids existing SAS code, rather than working with it.

* Avoids existing SATA code, rather than working with it.

* Avoids (rather than fix) several SCSI core false dependencies on HCIL. 
  Results in code duplication and/or avoidance of needed code.

* So far, it's an Adaptec-only solution.  Since it pointedly avoids the 
existing SAS transport code, this results in two SAS solutions in Linux: 
one for Adaptec, one for {everyone else}.

* Maintainer reminds me of my ATA mentor, Andre Hedrick:  knows his 
shit, but has difficulties working with the community.  May need a 
filter if we want long term maintenance to continue.


Resolution
----------
AFAICS, there are two paths:

Easy path: make Adaptec's solution a block driver, which allows it to 
sidestep all the "doesn't play well with others" issues.  Still an 
Adaptec-only solution, but at least its in a separate playpen.

Hard path: Update the SCSI core and libata to work with SATA+SAS 
hardware such as Adaptec's.

The hard path takes time, and won't be solved simply by shoving it in.

	Jeff


