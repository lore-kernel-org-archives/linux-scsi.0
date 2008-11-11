From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Thin provisioning & arrays
Date: Tue, 11 Nov 2008 10:38:45 -0500
Message-ID: <4919A705.2070301@redhat.com>
References: <28572.1226369378@ocs10w> <49198FC3.7080301@redhat.com> <49199CFF.8080002@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54198 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbYKKPjQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2008 10:39:16 -0500
In-Reply-To: <49199CFF.8080002@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jim owens <jowens@hp.com>
Cc: Keith Owens <kaos@ocs.com.au>, Black_David@emc.com, david@fromorbit.com, dwmw2@infradead.org, martin.petersen@oracle.com, chris.mason@oracle.com, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, coughlan@redhat.com, matthew@wil.cx

jim owens wrote:
> Ric Wheeler wrote:
>> Thing is being pitched to answer a very specific customer use case - 
>> shared storage (mid to high end almost exclusively) with several 
>> different users and applications....
>
> And by "different users" these customers almost always mean
> different operating systems.  They are combining storage into
> a central location for easier management.

When you have one specific LUN exported from an array, it is owned by 
one OS. You can definitely have different LUN's used by different OS's, 
but that seems to be irrelevant to our challenges here, right?
 
>
> So "exact unmapped tracking by the filesystem" is impossible
> and not part of the requirement.  Doesn't mean we can't make our
> filesystems better, but forget about a perfect ability to known
> just how much space we really have once we do an unmap.

My understanding is that most of this kind of information (how much real 
space is provisioned/utilized/etc) is handled out of band by a user 
space app.

>
> We can't tell how much of our unmapped space the device has
> given away to someone else and we cannot prevent the device
> from failing a write to an unmapped block if all the space
> is gone.  It is just an IO error, and possible fs-is-offline
> if that block we failed was metadata!

This is where things really fall apart - odd IO errors on a device that 
seems to us to have lots of space. If it becomes common in the field, I 
suspect that users will flee thin luns :-)  I also understand that other 
os'es are mutually unable to react.

>
> It is up to the customer to manage their storage so it never
> reaches the unable-to-write state.
>
> jim

Agreed - the high water marks should be set to allow the sys admin 
(storage admin?) to reallocate space....

ric

