From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Mon, 08 Aug 2005 14:07:18 -0400
Message-ID: <42F79F56.3040409@adaptec.com>
References: <Pine.LNX.4.44L0.0508071041110.28316-100000@netrider.rowland.org> <1123429001.5020.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:23257 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932167AbVHHSHW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2005 14:07:22 -0400
In-Reply-To: <1123429001.5020.14.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 08/07/05 11:36, James Bottomley wrote:
> On Sun, 2005-08-07 at 10:59 -0400, Alan Stern wrote:
> 
>>What sort of synchronization is there between scsi_remove_host and the 
>>error-handler thread?  Offhand I can see two possible problems, depending 
>>on how the LLD is written:
> 
> 
> There isn't any by design.
> 
> I think you're not thinking about how this works correctly.  What remove
> host does is loop over the active devices removing them from visibility
> and trying to do a final put on the generic devices before removing the
> host from visibility and doing a final put on it.
> 
> However, any outstanding user will have a reference and will keep all
> the bits of the hierarchy in place until that reference is relinquished.

Which automatically implies that any such entity (holding a ref)
trying to do any kind of action to what it is holding, should get
an error result, else it would be misled to believe that things are ok,
when in fact the whole thing is coming down...

	Luben
