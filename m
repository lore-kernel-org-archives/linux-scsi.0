From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] IBM Power RAID driver (ipr) 2.0.6
Date: Mon, 10 May 2004 17:54:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <409FFA2A.2070402@us.ibm.com>
References: <4097D863.8040505@us.ibm.com> <1084221540.2659.353.camel@mulgrave> <20040510213901.GH16118@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:3547 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261631AbUEJVyy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 May 2004 17:54:54 -0400
In-Reply-To: <20040510213901.GH16118@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Matthew Wilcox wrote:
> On Mon, May 10, 2004 at 03:38:57PM -0500, James Bottomley wrote:
> 
>>On Tue, 2004-05-04 at 12:52, Brian King wrote:
>>
>>>Here is the latest version of the LLD for the IBM Power RAID family of
>>>adapters. This includes several IBM iSeries and pSeries SCSI adapters.
>>>Please apply.
>>
>>The problem is your use of list_head pointers in packed structures.  You
>>can't simply pass a pointer to a misaligned structure to a common kernel
>>function and expect it to work: the packed attribute is lost doing this
>>and what you end up with is a misaligned pointer reference.
> 
> 
> It also causes gcc to pessimise references to this structure; often
> doing byte-loads instead of larger quantities.  Why does this struct
> need to be packed? 

It is a shared structure with the adapter with a little bit of added
driver data at the end of it. I'll roll a patch to clean this up. The
better way to do this is probably to break out the data that needs to be
packed into its own structure.

-Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

