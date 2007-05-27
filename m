From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] add help to WAIT_SCAN option
Date: Sat, 26 May 2007 19:15:43 -0500
Message-ID: <1180224943.3712.84.camel@mulgrave.il.steeleye.com>
References: <20070526191127.GB7080@colo.lackof.org>
	 <1180209014.3712.69.camel@mulgrave.il.steeleye.com>
	 <20070527000637.GB31023@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:48917 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751160AbXE0APp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 May 2007 20:15:45 -0400
In-Reply-To: <20070527000637.GB31023@colo.lackof.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-scsi@vger.kernel.org, Thibaut VARENE <T-Bone@parisc-linux.org>

On Sat, 2007-05-26 at 18:06 -0600, Grant Grundler wrote:
> On Sat, May 26, 2007 at 02:50:14PM -0500, James Bottomley wrote:
> > This solution is still as wrong as it was the last three times it was
> > submitted to linux-scsi:
> > 
> > http://marc.info/?t=117906989600001
> > http://marc.info/?t=117926627700012
> > http://marc.info/?t=117923062000004
> 
> ugh...sorry.  I should have looked first.
> 
> > A better, but still not quite right fix is here:
> > 
> > http://marc.info/?l=linux-scsi&m=117995785931981
> 
> Yes, I like this a lot better too.
> But I'm failing to understanding why "late_initcall" isn't ok. 
> I was expecting all drivers to have registered with scsi subsystem
> in their module_init() calls and have the scans get kicked off
> at that point. Further, I assumed "late_initcall" gets called
> after "init" list is processed. What am I missing?

Actually, it's a thinko on my part ... I thought late_initcall() and
module_init() are the same level, and hence this would be link order
dependent.  Actually that's only true in the modular case, so the patch
is fine ... I'll put it in.

James


