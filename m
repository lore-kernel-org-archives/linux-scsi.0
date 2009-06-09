From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] qla2xxx: Resolved a performance issue in interrupt
	handler
Date: Tue, 9 Jun 2009 15:47:59 -0600
Message-ID: <20090609214759.GR3274@parisc-linux.org>
References: <alpine.OSX.1.00.0906091107470.3891@ac-mac.local> <1244575944.12321.58.camel@mulgrave.site> <19C9538E-B7B2-4924-859F-37E56660D95E@qlogic.com> <1244580029.12321.138.camel@mulgrave.site> <alpine.OSX.1.00.0906091436120.4405@ac-mac.local> <20090609214342.GQ3274@parisc-linux.org> <6FEBF8A9-AA4F-496A-B549-AE5D4275A8A4@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56556 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbZFIVr5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2009 17:47:57 -0400
Content-Disposition: inline
In-Reply-To: <6FEBF8A9-AA4F-496A-B549-AE5D4275A8A4@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "douglas.w.styner@intel.com" <douglas.w.styner@intel.com>

On Tue, Jun 09, 2009 at 02:46:12PM -0700, Anirban Chakraborty wrote:
>
> On Jun 9, 2009, at 2:43 PM, Matthew Wilcox wrote:
>> While I don't think Doug has MSI-X adapters, a complete patch would  
>> change
>> all request_irq() calls to use IRQF_DISABLED, right?
>
> The above patch takes care of replacing all the IRQF_SHARED flags in irq 
> registrations with IRQF_DISABLED.

Yes ... but even for the MSI-X case, you want the handler to be run with
interrupts disabled, don't you?  If not, why not?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
