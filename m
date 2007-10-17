From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Bug 3680] sym53c8xx_2 SMP deadlock on driver load
Date: Wed, 17 Oct 2007 10:27:47 -0600
Message-ID: <20071017162747.GA32174@parisc-linux.org>
References: <20071017013045.A19ED108036@picon.linux-foundation.org> <471621D2.5080806@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:46870 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760026AbXJQQ1t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 12:27:49 -0400
Content-Disposition: inline
In-Reply-To: <471621D2.5080806@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: w@1wt.eu, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, protasnb@gmail.com, bugme-daemon@bugzilla.kernel.org

On Wed, Oct 17, 2007 at 10:53:06AM -0400, Tony Battersby wrote:
> After looking at it carefully, this is true of pci_map_mem, but not
> pci_unmap_mem.  pci_unmap_mem can be called from both ->detect and
> ->release.  io_request_lock is held in ->detect but not in ->release.
> So, your patch locks up the system on module unload.

My mistake.  I should have checked the iorl was held over ->release too.

This is a pretty ugly patch, but I think the three alternatives are
worse:

 - Drop the iorl at the beginning of ->detect and reacquire it at exit.
   We don't know what else the iorl might be protecting.  Probably
   nothing, but I don't want to audit it.
 - Convert sym2 back to old error handling so the midlayer doesn't
   acquire the iorl for us in ->detect.
 - Acquire the iorl in ->release.  We might deadlock on something.

So, sure, apply this patch.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
