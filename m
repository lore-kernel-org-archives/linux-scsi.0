From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: Newbie: multiple initiator contention resolution?
Date: Fri, 2 Apr 2004 16:05:47 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF9A569789.59ADE54F-ON88256E6A.00833381-88256E6B.0000658B@us.ibm.com>
References: <406DC64C.4030405@ecs.soton.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:49605 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S261416AbUDCAGI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Apr 2004 19:06:08 -0500
In-Reply-To: <406DC64C.4030405@ecs.soton.ac.uk>
List-Id: linux-scsi@vger.kernel.org
To: Daniel Patton <djp101@ecs.soton.ac.uk>
Cc: linux-scsi@vger.kernel.org, sdake@mvista.com

>Steven Dake wrote:
>
> You have to use some form of external locking mechanism, most often. 
>> Most filesystems do not support such a thing.  Check out opengfs (use
>> google) for an example of one that does.
>> 
>
Daniel Patton:

>Many thanks, I will look into this.  I don't understand why SCSI 
>RESERVE/RELEASE can't be used as the locking mechanism though.  Call me 
>stupid, but I'm only a student.

You _can_ use SCSI RESERVE/RELEASE for the locking.  The locking doesn't 
have to be external to the SCSI channel -- it has to be external to the 
device driver.  The reason is that every filesystem driver I know caches 
information from the disk -- above the device driver.

So the filesystem drivers on the various accessing systems would have to 
use a locking mechanism (possibly with a lock based on SCSI 
RESERVE/RELEASE) to communicate amongst themselves and coordinate their 
caches.

There's also the matter of multi-write updates that have to be atomic. 
That's a problem naturally solved with SCSI RESERVE/RELEASE, but it still 
has to be handled external to the device driver.

