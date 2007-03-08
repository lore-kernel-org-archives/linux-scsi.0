From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [stable] [patch 29/29] bug in gdth.c crashing machine
Date: Wed, 07 Mar 2007 19:50:14 -0500
Message-ID: <1173315014.3771.51.camel@mulgrave.il.steeleye.com>
References: <200703061046.l26AksTi020093@shell0.pdx.osdl.net>
	 <1173288505.3771.33.camel@mulgrave.il.steeleye.com>
	 <20070307174021.GA25066@kroah.com>
	 <20070307111616.16e5e641.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:39094 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752100AbXCHAvq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Mar 2007 19:51:46 -0500
In-Reply-To: <20070307111616.16e5e641.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, rdunlap@xenotime.net, Achim_Leubner@adaptec.com, joerg@dorchain.net, stable@kernel.org, linux-scsi@vger.kernel.org

On Wed, 2007-03-07 at 11:16 -0800, Andrew Morton wrote:
> Achim did reply:  http://lkml.org/lkml/2007/2/23/138

Ah ... OK; sorry, I'm parochial ... if it didn't appear on linux-scsi,
you can usually assume I haven't seen it.

> So we don't know what the patch does, but it should be merged into
> -stable
> (and mainline, heaven forfend)

Well ... I would, except what this patch does is to initialise the
command sg_ranz field (for both 64 bit and 32 bit commands).  If you
look in the code just below the patch application at the 

if (scp->use_sg) {
...
} else if (scp->request_bufflen) {
...
}

You'll find a line setting these parameters in each of the cases of the
if statement.  So the bug appears to be that there's a missing else
clause to this if, which would initialise the zero transfer commands.
Is that a correct analysis?

James


