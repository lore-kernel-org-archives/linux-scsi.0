From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
Date: Wed, 22 Jan 2014 11:45:28 -0500
Message-ID: <52DFF5A8.1090002@redhat.com>
References: <20131220093022.GV11295@suse.de> <52DF353D.6050300@redhat.com>	 <20140122093435.GS4963@suse.de>	 <1390403770.1198.4.camel@ret.masoncoding.com> <1390406584.2372.7.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1390406584.2372.7.camel@dabdike.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Chris Mason <clm@fb.com>
Cc: "mgorman@suse.de" <mgorman@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On 01/22/2014 11:03 AM, James Bottomley wrote:
> On Wed, 2014-01-22 at 15:14 +0000, Chris Mason wrote:
>> On Wed, 2014-01-22 at 09:34 +0000, Mel Gorman wrote:
>>> On Tue, Jan 21, 2014 at 10:04:29PM -0500, Ric Wheeler wrote:
>>>> One topic that has been lurking forever at the edges is the current
>>>> 4k limitation for file system block sizes. Some devices in
>>>> production today and others coming soon have larger sectors and it
>>>> would be interesting to see if it is time to poke at this topic
>>>> again.
>>>>
>>> Large block support was proposed years ago by Christoph Lameter
>>> (http://lwn.net/Articles/232757/). I think I was just getting started
>>> in the community at the time so I do not recall any of the details. I do
>>> believe it motivated an alternative by Nick Piggin called fsblock though
>>> (http://lwn.net/Articles/321390/). At the very least it would be nice to
>>> know why neither were never merged for those of us that were not around
>>> at the time and who may not have the chance to dive through mailing list
>>> archives between now and March.
>>>
>>> FWIW, I would expect that a show-stopper for any proposal is requiring
>>> high-order allocations to succeed for the system to behave correctly.
>>>
>> My memory is that Nick's work just didn't have the momentum to get
>> pushed in.  It all seemed very reasonable though, I think our hatred of
>> buffered heads just wasn't yet bigger than the fear of moving away.
>>
>> But, the bigger question is how big are the blocks going to be?  At some
>> point (64K?) we might as well just make a log structured dm target and
>> have a single setup for both shingled and large sector drives.
> There is no real point.  Even with 4k drives today using 4k sectors in
> the filesystem, we still get 512 byte writes because of journalling and
> the buffer cache.

I think that you are wrong here James. Even with 512 byte drives, the IO's we 
send down tend to be 4k or larger. Do you have traces that show this and details?

>
> The question is what would we need to do to support these devices and
> the answer is "try to send IO in x byte multiples x byte aligned" this
> really becomes an ioscheduler problem, not a supporting large page
> problem.
>
> James
>

Not that simple.

The requirement of some of these devices are that you *never* send down a 
partial write or an unaligned write.

Also keep in mind that larger block sizes allow us to track larger files with 
smaller amounts of metadata which is a second win.

Ric

