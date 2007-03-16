From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 2/2] fusion - honour return value of pci_enable_device()
 in mpt_resume()
Date: Fri, 16 Mar 2007 08:06:47 -0700
Message-ID: <20070316080647.3c6d3579.rdunlap@xenotime.net>
References: <20070316070521.GB1081@verge.net.au>
	<20070316070550.GC1081@verge.net.au>
	<1174055246.3519.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:47462 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965388AbXCPQIR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Mar 2007 12:08:17 -0400
Received: from midway.site ([71.245.96.31]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 16 Mar 2007 09:08:15 -0700
In-Reply-To: <1174055246.3519.5.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Horms <horms@verge.net.au>, mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org, Eric Moore <Eric.Moore@lsi.com>

On Fri, 16 Mar 2007 09:27:26 -0500 James Bottomley wrote:

> On Fri, 2007-03-16 at 16:05 +0900, Horms wrote:
> > +       err = pci_enable_device(pdev);
> > +       if (err < 0)
> > +               return err;
> 
> Traditionally, this should be 
> 
> if (err)
> 	return err;
> 
> The reason is that <0 is a signed comparison which can be slightly more
> expensive on some architectures and it's unnecessary if zero is the only
> successful return.

Tradition vs. Linus, eh?  Linus wrote (2007-Mar-06, on lkml,
Message-ID: <Pine.LNX.4.64.0703060817060.5963@woody.linux-foundation.org>):

 - "negative error values" should preferably always be tested as such

	if (tick_init_highres() < 0) {
		printk("Aieee! Couldn't init!\n");
		return 0;
	}


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
