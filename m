From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi/initio: section mismatches with HOTPLUG=n
Date: Sat, 25 Nov 2006 11:37:50 -0600
Message-ID: <1164476271.2804.11.camel@mulgrave.il.steeleye.com>
References: <20061119185343.e4dde647.randy.dunlap@oracle.com>
	 <1164408696.2813.19.camel@mulgrave.il.steeleye.com>
	 <1164409859.5257.7.camel@gullible>
	 <1164467971.2804.3.camel@mulgrave.il.steeleye.com>
	 <1164475196.5257.105.camel@gullible>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55489 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S966263AbWKYRiA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Nov 2006 12:38:00 -0500
In-Reply-To: <1164475196.5257.105.camel@gullible>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <ben.collins@ubuntu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>

On Sat, 2006-11-25 at 12:19 -0500, Ben Collins wrote:
> The MODULE_DEV_TABLE was added so userspace has an easier time loading
> a
> driver for the device, without special rules. It wasn't meant to make
> the driver hot-pluggable. I think the idea that a module alias is just
> for hotplug is a little short-sighted.

The module device table isn't the problem.  The problem is the fact that
you marked the table __devinitdata.  __devinitdata is a sectional
marking that causes the table to be placed in a discardable init data
section for CONFIG_HOTPLUG=n.  However, the routines accessing it still
occur in the standard text segment hence the mismatch.  If you want to
mark data __devinitdata, you have to ensure that all the routines
accessing it are marked __devinit.

James


