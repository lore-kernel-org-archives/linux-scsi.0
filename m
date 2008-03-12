From: Josef Bacik <jbacik@redhat.com>
Subject: Re: some hard numbers on ext3 & batching performance issue
Date: Wed, 12 Mar 2008 14:37:01 -0400
Message-ID: <20080312183701.GB21187@unused.rdu.redhat.com>
References: <47C6A46D.8020700@emc.com> <200803051520.09931.jbacik@redhat.com> <47D1A0C0.8010908@emc.com> <200803071540.13958.jbacik@redhat.com> <47D1A986.8010307@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbYCLSjE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Mar 2008 14:39:04 -0400
Content-Disposition: inline
In-Reply-To: <47D1A986.8010307@emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <ric@emc.com>
Cc: Josef Bacik <jbacik@redhat.com>, David Chinner <dgc@sgi.com>, Theodore Ts'o <tytso@mit.edu>, adilger@sun.com, jack@ucw.cz, "Feld, Andy" <Feld_Andy@emc.com>, linux-fsdevel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Mar 07, 2008 at 03:45:58PM -0500, Ric Wheeler wrote:
> Josef Bacik wrote:
>> On Friday 07 March 2008 3:08:32 pm Ric Wheeler wrote:
>>> Josef Bacik wrote:
>>>> On Wednesday 05 March 2008 2:19:48 pm Ric Wheeler wrote:
>>>>> After the IO/FS workshop last week, I posted some details on the slow
>>>>> down we see with ext3 when we have a low latency back end instead of a
>>>>> normal local disk (SCSI/S-ATA/etc).
>>> ...
>>> ...
>>>
>>> Note that this spreads the files across 64 subdirectories, each thread
>>> writes 50 files and then moves on to the next in a round robin.
>>>
>>
>> I'm starting to wonder about the disks I have, because my files/second is 
>> spanking yours, and its just a local samsung 3gb/s sata drive.  With those 
>> commands I'm consistently getting over 700 files/sec.  I'm seeing about a 
>> 1-5% increase in speed locally with my patch.  I guess I'll start looking 
>> around for some other hardware and check on there in case this box is more 
>> badass than I think it is.  Thanks much,
>>
>> Josef
>>
>
> Sounds like you might be running with write cache on & barriers off ;-)
>
> Make sure you have write cache & barriers enabled on the drive. With a good 
> S-ATA drive, you should be seeing about 35-50 files/sec with a single 
> threaded writer.
>
> The local disk that I tested on is a relatively slow s-ata disk that is 
> more laptop quality/performance than server.
>
> One thought I had about the results is that we might be flipping the IO 
> sequence with the local disk case. It is the only device of the three that 
> I tested which is seek/head movement sensitive for small files.
>

Ahh yes turning off write cache off and barriers on I get your numbers, however
I'm not seeing the slowdown that you are, with and without my patch I'm seeing
the same performance.  Its just a plane jane intel sata controller with a
samsung sata disk set at 1.5gbps.  Same thing with an nvidia sata controller.
I'll think about this some more and see if there is something better that could
be done that may help you.  Thanks much,

Josef
