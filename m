From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] Re: [BUG] dm-mpath and scsi persistent reservation
Date: Wed, 22 Oct 2008 21:53:08 -0500
Message-ID: <48FFE714.7010308@cs.wisc.edu>
References: <20081021231910.0fdbeb75@plop>	<1224629283.14830.838.camel@chandra-ubuntu>	<20081022215402.214a4ef8@plop> <1224707416.6851.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52638 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbYJWCy7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2008 22:54:59 -0400
In-Reply-To: <1224707416.6851.33.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: agk@redhat.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, Christophe Varoqui <christophe.varoqui@free.fr>

James Bottomley wrote:
>> I don't see how we could use a device handler to translate an scsi error
>> code from a write io submitted to the multipath device map. Do you ?
> 
> Well, there is a problem.  Reservation Conflict should be treated as a
> device error and passed straight up ... it shouldn't really have any
> effect on dm mp because a path switch is unlikely to fix any issues.  So
> dm mp shouldn't be intercepting this type of error at all.
> 

I think what Christophe was asking for is something like this:

[RFC PATCH 1/4] convert block layer drivers to blkerr
http://marc.info/?l=linux-scsi&m=112487427230642&w=2
[RFC PATCH 2/4] convert dm to blkerr error values
http://marc.info/?l=linux-scsi&m=112487427306501&w=2
[RFC PATCH 3/4] convert dm-multipath to blkerr error
http://marc.info/?l=linux-scsi&m=112487431524436&w=2
[RFC PATCH 4/4] convert scsi to blkerr error values
http://marc.info/?l=linux-scsi&m=112487431524350&w=2

something that allows lower layers to give the upper layers some extra 
info. In the patches the scsi layer would return a fatal device error, 
and device mapper multipath would see that and just fail the IO instead 
of retrying on a new path.

I do not like my implementation in those patches, but I did not have 
time in the past to rework them. I can now though if you guys have any 
comments. I am really struggling on the definition of the block layer 
errors codes and what info they should convey. For example I was not 
sure if they should they give a hint about if the error is fatal or 
retryable like in the patches above or should they describe what happened?
