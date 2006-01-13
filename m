From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/10] iscsi: data digest page cache usage fix
Date: Fri, 13 Jan 2006 12:19:39 -0600
Message-ID: <43C7EF3B.1090401@cs.wisc.edu>
References: <1137128913.9508.37.camel@max> <20060113181427.GM20718@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:31154 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1422794AbWAMSTy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 13:19:54 -0500
In-Reply-To: <20060113181427.GM20718@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Jan 12, 2006 at 11:08:33PM -0600, Mike Christie wrote:
> 
>>>From FUJITA Tomonori <tomof@acm.org>:
>>
>>Users can write to a page while we are sending it and making
>>digest calculations. This ends up causing us to retry the command
>>when a digest error is later reported. By using sock_no_sendpage
>>when data digests are calculated we can avoid a lot of (not all but it
>>helps) the retries becuase sock_no_sendpage is not zero copy.
> 
> 
> This sounds like it'd kill performance badly when using data digests.
> But using lock_page from an LLDD sounds pretty bad aswell, so I don't
> know anything better.
> 

Yeah, we kinda accpeted that if you use data digests in linux 
performance will drop. It will either drop due to the copy we added here 
or due to the mutiple digest errors/retry path we will hit. Either way, 
the user should know that safety they get from data digests comes at a 
price.
