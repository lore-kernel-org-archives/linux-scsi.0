From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch] plug async scan race at 1st node scan
Date: Sat, 1 Mar 2008 07:26:45 -0700
Message-ID: <20080301142644.GC24386@parisc-linux.org>
References: <1187615436.3897.5.camel@localhost.localdomain> <20070820134918.GC30019@parisc-linux.org> <47C9419D.1040402@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:46310 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbYCAO1H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Mar 2008 09:27:07 -0500
Content-Disposition: inline
In-Reply-To: <47C9419D.1040402@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Smart <James.Smart@Emulex.Com>, linux-scsi@vger.kernel.org, tore@linpro.no

On Sat, Mar 01, 2008 at 05:44:29AM -0600, Mike Christie wrote:
> >Possibly we should be less forgiving, and require drivers to have a
> >scan_start, otherwise they can't avoid this race.
> 
> I am hitting this problem with qla4xxx (added async scanning to 
> 2.6.25-rc). Was the final decision that we have to add a scan_start? I 
> did not see scan_start be made mandatory and I did not see James's patch 
> go in.

You can't really make it mandatory ... it's only mandatory *if* you have
a scan_finished.

The documentation should be updated though.  Possibly the function
prototype should be changed from returning void to returning int, to
allow drivers to say "Oh no, I can't start after all".

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
