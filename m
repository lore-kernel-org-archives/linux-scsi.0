From: Ben Collins <ben.collins@ubuntu.com>
Subject: Re: [PATCH] scsi/initio: section mismatches with HOTPLUG=n
Date: Sun, 26 Nov 2006 11:02:48 -0500
Message-ID: <1164556968.5257.188.camel@gullible>
References: <20061119185343.e4dde647.randy.dunlap@oracle.com>
	 <1164408696.2813.19.camel@mulgrave.il.steeleye.com>
	 <1164409859.5257.7.camel@gullible>
	 <1164467971.2804.3.camel@mulgrave.il.steeleye.com>
	 <1164475196.5257.105.camel@gullible>
	 <1164476271.2804.11.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adelie.ubuntu.com ([82.211.81.139]:2493 "EHLO adelie.ubuntu.com")
	by vger.kernel.org with ESMTP id S934366AbWKZQC5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Nov 2006 11:02:57 -0500
In-Reply-To: <1164476271.2804.11.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>

On Sat, 2006-11-25 at 11:37 -0600, James Bottomley wrote:
> On Sat, 2006-11-25 at 12:19 -0500, Ben Collins wrote:
> > The MODULE_DEV_TABLE was added so userspace has an easier time loading
> > a
> > driver for the device, without special rules. It wasn't meant to make
> > the driver hot-pluggable. I think the idea that a module alias is just
> > for hotplug is a little short-sighted.
> 
> The module device table isn't the problem.  The problem is the fact that
> you marked the table __devinitdata.  __devinitdata is a sectional
> marking that causes the table to be placed in a discardable init data
> section for CONFIG_HOTPLUG=n.  However, the routines accessing it still
> occur in the standard text segment hence the mismatch.  If you want to
> mark data __devinitdata, you have to ensure that all the routines
> accessing it are marked __devinit.

I know what the section is :) I wasn't aware that it was causing a
problem with HOTPLUG=n. I'll get a patch to fix it up.
