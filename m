From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Oops in scsi_send_eh_cmnd 2.6.21-rc5-git6,7,10,13
Date: Fri, 06 Apr 2007 16:35:46 -0500
Message-ID: <1175895346.3677.57.camel@mulgrave.il.steeleye.com>
References: <200704061512.l36FCFjl031431@cichlid.com>
	 <1175873277.3677.11.camel@mulgrave.il.steeleye.com>
	 <20070406.113229.122031524.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:54003 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933036AbXDFVhZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Apr 2007 17:37:25 -0400
In-Reply-To: <20070406.113229.122031524.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: aab@cichlid.com, cebbert@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, aradford@gmail.com

On Fri, 2007-04-06 at 11:32 -0700, David Miller wrote:
> From: James Bottomley <James.Bottomley@SteelEye.com>
> Date: Fri, 06 Apr 2007 10:27:57 -0500
> 
> > On Fri, 2007-04-06 at 08:12 -0700, Andrew Burgess wrote:
> > > Yes. The 3w-xxxx.c driver changed between 2.6.18 and 2.6.20 but
> > > nothing jumps out to my untrained eyes. Here's the diff:
> > > Also, I should mention that the working kernel is a fedora
> > > rpm (2.6.18-1.2798.fc6) so I don't know what patches are in it.
> > > The vmlinuz is dated Oct 6 2006.
> > 
> > It's actually a long standing bug in the 3w-xxxx driver.  Apparently it
> > assumes request sense is always the use_sg == 0 case.  This is what it
> > does on a request sense:
> 
> Thanks for figuring this out James.  I was very worried there
> was some bug in my scsi_send_eh_cmnd() fix :)

You're welcome ... the code in the fix looked fine, which is why I was
initially suspicious ... however, the bug in __free_page() on reversion
pretty much confirmed a driver issue.

James


