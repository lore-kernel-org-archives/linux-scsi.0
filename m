From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [BUG] x86_64 pci_map_sg modifies sg list - fails multiple map/unmaps
Date: Mon, 05 Jan 2004 13:04:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2997092704.1073333041@aslan.btc.adaptec.com>
References: <2938942704.1073325455@aslan.btc.adaptec.com> <m3brpi41q0.fsf@averell.firstfloor.org>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([216.52.22.10]:31883 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S265338AbUAET6W
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jan 2004 14:58:22 -0500
In-Reply-To: <m3brpi41q0.fsf@averell.firstfloor.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: linux-kernel@vger.kernel.org, davem@redhat.com, linux-scsi@vger.kernel.org

> "Justin T. Gibbs" <gibbs@scsiguy.com> writes:
> 
>> Berkley Shands recently tripped over this problem.  The 2.6.X pci_map_sg
>> code for x86_64 modifies the passed in S/G list to compact it for mapping
>> by the GART.  This modification is not reversed when pci_unmap_sg is
>> called.  In the case of a retried SCSI command, this causes any attempt
> 
> Qlogic has the same bug.

Which bug is this?  Not updating use_sg, or mapping the command the
second time when it is retried?  If the latter, I don't think this is an
HBA bug.  The HBA driver doesn't know that the command has been mapped in
the past, so it will blindly map/unmap it again.

...

>> DMA-API.txt doesn't seem to cover this issue.
> 
> It does actually, but not very clearly. I've suggested changes of wording
> recently to make this more clear, but it hasn't gotten in.

Can you point to the section of the document you believe applies?

> You should never remap an already mapped sg list.

But the sg list is no longer mapped.  The HBA driver did call pci_unmap_sg
on it.  Did you mean to say, "Never map an sg list again that has been
mapped in the past"?

> Either reuse the already mapped list or keep a copy of the original list
> around. First is better because the later may have problems with the page
> reference counts.

The mid-layer doesn't map the list.  The HBA drivers do.  So you're saying
that either the mid-layer or the HBA drivers need to copy the list so it
can be restored just in case the command will be retried?

--
Justin

