From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: aic7xxx_biosparam
Date: Sun, 17 Nov 2002 21:20:10 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211180320.gAI3KBV16803@localhost.localdomain>
References: <dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id TAA04879
	for <linux-scsi@vger.kernel.org>; Sun, 17 Nov 2002 19:20:14 -0800
Received: from localhost.localdomain (sshppp-200.mtv1.steeleye.com [172.16.1.200])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id TAA04790
	for <linux-scsi@vger.kernel.org>; Sun, 17 Nov 2002 19:20:12 -0800
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id gAI3KBV16803
	for <linux-scsi@vger.kernel.org>; Sun, 17 Nov 2002 21:20:11 -0600
In-Reply-To: Message from Doug Ledford <dledford@redhat.com>
   of "Sun, 17 Nov 2002 21:46:45 EST." <20021118024645.GB4608@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

dledford@redhat.com said:
> Hmmm..should that be changed though? 

I hope not.  If we implement BIG_GETGEO then I've made all the wrong decisions 
for biosparam: since it can pass back ints, the implementations should all be 
using sector_div and we should do the truncation in the GETGEO ioctl since we 
can use the same biosparam call for both ioctls.

> I beg to differ.  At least on the Adaptec stuff, it gets pissy if the
> partition tables don't look sane (at least older BIOSes do, and those
> cards are still in use, so that means I try and make them work).
> Besides,  when I make changes in this code, the effects are instantly
> visible in  fdisk (well, after a module reload), so it get's used
> somewhere.

The argument is that no user space tools rely on the cyls value, only the 
sectors and heads.  They all use the GETGEO ioctl, but also get the blocksize 
of the device and divide this out by the sectors*heads to get the true cyls 
value.

I know this is the wrong short term decision: you should never implement an 
interface wrongly because it causes exactly this type of confusion.  I'm just 
betting on the C/H/S mess being sorted out soon....I hope.

James


