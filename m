From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] Re: [PATCH] Always pass result and sense on request
 completion
Date: Thu, 10 Dec 2009 11:03:33 -0600
Message-ID: <4B2129E5.9020205@cs.wisc.edu>
References: <20091119122454.71A7D3A174@ochil.suse.de>	<4B20C417.4020201@suse.de> <1260463457.2457.80.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46941 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761190AbZLJRDu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Dec 2009 12:03:50 -0500
In-Reply-To: <1260463457.2457.80.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Thu, 2009-12-10 at 10:49 +0100, Hannes Reinecke wrote:
>> Hi James,
>>
>> would you mind commenting on this patch?
>> We really need this if we ever want to be able to do proper error code
>> handling from multipath.
> 
> OK, not keen on the way you're setting req->errors.
> 
> Our big problem with FS requests is deferred or corrected errors
> (basically we never want the FS to think we had a problem with them).  I
> think it's currently OK because block tends to believe the returned
> error code rather than req->errors ... I'd just hate it if that changed
> and suddenly lots of stuff broke.
> 
> I think you're just looking for the sense data, so could you look at
> that and not set req->errors?
> 

For the specific bug Hannes is fixing we only need the sense code, so 
that would work. If you also pass info like the host_byte bits then we 
can do something like fail a path right away for a DID_TRANSPORT* or 
DID_NO_CONNECT failure, but then for other errors do something else. 
RAID could also not fail the drive on transport errors, and do something 
different too.
