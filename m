From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Thin provisioning & arrays
Date: Tue, 11 Nov 2008 11:25:01 -0500
Message-ID: <4919B1DD.3030207@redhat.com>
References: <28572.1226369378@ocs10w> <49198FC3.7080301@redhat.com> <49199CFF.8080002@hp.com> <4919A705.2070301@redhat.com> <4919ABC6.8030606@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46823 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbYKKQZ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2008 11:25:27 -0500
In-Reply-To: <4919ABC6.8030606@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jim owens <jowens@hp.com>
Cc: Keith Owens <kaos@ocs.com.au>, Black_David@emc.com, david@fromorbit.com, dwmw2@infradead.org, martin.petersen@oracle.com, chris.mason@oracle.com, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, coughlan@redhat.com, matthew@wil.cx

jim owens wrote:
> Ric Wheeler wrote:
>> jim owens wrote:
>>>
>>> And by "different users" these customers almost always mean
>>> different operating systems.  They are combining storage into
>>> a central location for easier management.
>>
>> When you have one specific LUN exported from an array, it is owned by 
>> one OS. You can definitely have different LUN's used by different 
>> OS's, but that seems to be irrelevant to our challenges here, right?
>
> But the total thin storage pool is shared by multiple luns
> and thus maybe multiple not-able-to-cooperate hosts.

agreed...
>
> I was only pointing this out because earlier threads seemed
> to be "linux filesystems to be exact across multiple hosts"
> (which is really a cluster design) and even if we did that
> for linux it would not solve the customer need.
>
> I just wanted to make it clear why trying to do a complicated
> change to linux for exactness is pointless because the customer
> requirement is for more than linux attached to the thin pool.
>
> So the relevance is our design boundary.
>
> jim

I think that the concern is that the exact implementation is actually 
already coded and relatively easy for us to do (i.e., send down unmap 
commands at natural file system level units after a truncate/delete).

The irony is that the hard part is to try to approach that level of 
exactness with the other techniques (coalescing unmaps, defrag, etc) :-)

ric

