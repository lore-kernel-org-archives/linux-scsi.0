From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
	slot is freed)
Date: Fri, 14 Aug 2009 17:33:49 -0400
Message-ID: <87f94c370908141433h111f819j550467bf31c60776__49310.2421788082$1250285710$gmane$org@mail.gmail.com>
References: <200908122007.43522.ngupta@vflare.org>
	 <20090813151312.GA13559@linux.intel.com>
	 <20090813162621.GB1915@phenom2.trippelsdorf.de>
	 <alpine.DEB.1.10.0908130931400.28013@asgard.lang.hm>
	 <87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com>
	 <alpine.DEB.1.10.0908131342460.28013@asgard.lang.hm>
	 <87f94c370908131428u75dfe496x1b7d90b94833bf80@mail.gmail.com>
	 <46b8a8850908131520s747e045cnd8db9493e072939d@mail.gmail.com>
	 <87f94c370908131719l7d84c5d0x2157cfeeb2451bce@mail.gmail.com>
	 <46b8a8850908131758s781b07f6v2729483c0e50ae7a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:38311 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbZHNVdt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Aug 2009 17:33:49 -0400
In-Reply-To: <46b8a8850908131758s781b07f6v2729483c0e50ae7a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Sharpe <realrichardsharpe@gmail.com>, david@lang.hm, Markus Trippelsdorf <markus@trippelsdorf.de>, Matthew Wilcox <willy@linux.intel.com>, Hugh Dickins <hugh.dickins@tiscali.c>

This inadvertently went just to me, replying to all:

On Thu, Aug 13, 2009 at 8:58 PM, Richard
Sharpe<realrichardsharpe@gmail.com> wrote:
> On Thu, Aug 13, 2009 at 5:19 PM, Greg Freemyer<greg.freemyer@gmail.co=
m> wrote:
>> On Thu, Aug 13, 2009 at 6:20 PM, Richard
>> Sharpe<realrichardsharpe@gmail.com> wrote:
>>> On Thu, Aug 13, 2009 at 2:28 PM, Greg Freemyer<greg.freemyer@gmail.=
com> wrote:
>>>> On Thu, Aug 13, 2009 at 4:44 PM, <david@lang.hm> wrote:
>>>>> On Thu, 13 Aug 2009, Greg Freemyer wrote:
>>>>>
>>>>>> On Thu, Aug 13, 2009 at 12:33 PM, <david@lang.hm> wrote:
>>>>>>>
>>>>>>> On Thu, 13 Aug 2009, Markus Trippelsdorf wrote:
>>>>>>>
>>>>>>>> On Thu, Aug 13, 2009 at 08:13:12AM -0700, Matthew Wilcox wrote=
:
>>>>>>>>>
>>>>>>>>> I am planning a complete overhaul of the discard work. =A0Use=
rs can send
>>>>>>>>> down discard requests as frequently as they like. =A0The bloc=
k layer will
>>>>>>>>> cache them, and invalidate them if writes come through. =A0Pe=
riodically,
>>>>>>>>> the block layer will send down a TRIM or an UNMAP (depending =
on the
>>>>>>>>> underlying device) and get rid of the blocks that have remain=
ed
>>>>>>>>> unwanted
>>>>>>>>> in the interim.
>>>>>>>>
>>>>>>>> That is a very good idea. I've tested your original TRIM imple=
mentation
>>>>>>>> on
>>>>>>>> my Vertex yesterday and it was awful ;-). The SSD needs hundre=
ds of
>>>>>>>> milliseconds to digest a single TRIM command. And since your
>>>>>>>> implementation
>>>>>>>> sends a TRIM for each extent of each deleted file, the whole s=
ystem is
>>>>>>>> unusable after a short while.
>>>>>>>> An optimal solution would be to consolidate the discard reques=
ts, bundle
>>>>>>>> them and send them to the drive as infrequent as possible.
>>>>>>>
>>>>>>> or queue them up and send them when the drive is idle (you woul=
d need to
>>>>>>> keep track to make sure the space isn't re-used)
>>>>>>>
>>>>>>> as an example, if you would consider spinning down a drive you =
don't hurt
>>>>>>> performance by sending accumulated trim commands.
>>>>>>>
>>>>>>> David Lang
>>>>>>
>>>>>> An alternate approach is the block layer maintain its own bitmap=
 of
>>>>>> used unused sectors / blocks. Unmap commands from the filesystem=
 just
>>>>>> cause the bitmap to be updated. =A0No other effect.
>>>>>
>>>>> how does the block layer know what blocks are unused by the files=
ystem?
>>>>>
>>>>> or would it be a case of the filesystem generating discard/trim r=
equests to
>>>>> the block layer so that it can maintain it's bitmap, and then the=
 block
>>>>> layer generating the requests to the drive below it?
>>>>>
>>>>> David Lang
>>>>
>>>> Yes, my thought.was that block layer would consume the discard/tri=
m
>>>> requests from the filesystem in realtime to maintain the bitmap, t=
hen
>>>> at some later point in time when the system has extra resources it
>>>> would generate the calls down to the lower layers and eventually t=
he
>>>> drive.
>>>
>>> Why should the block layer be forced to maintain something that is
>>> probably of use for only a limited number of cases? For example, th=
e
>>> devices I work on already maintain their own mapping of HOST-visibl=
e
>>> LBAs to underlying storage, and I suspect that most such devices do=
=2E
>>> So, you are duplicating something that we already do, and there is =
no
>>> way that I am aware of to synchronise the two.
>>>
>>> All we really need, I believe is for the UNMAP requests to come dow=
n
>>> to us with writes barriered until we respond, and it is a relativel=
y
>>> cheap operation, although writes that are already in the cache and
>>> uncommitted to disk present some issues if an UNMAP request comes d=
own
>>> for recently written blocks.
>>>
>>
>> Richard,
>>
>> Quoting the original email I saw in this thread:
>>
>>>
>>>The unfortunate thing about the TRIM command is that it's not NCQ, s=
o
>>>all NCQ commands have to finish, then we can send the TRIM command a=
nd
>>>wait for it to finish, then we can send NCQ commands again.
>>>
>>>So TRIM isn't free, and there's a better way for the drive to find
>>>out that the contents of a block no longer matter -- write some new
>>>data to it. =A0So if we just swapped a page in, and we're going to s=
wap
>>>something else back out again soon, just write it to the same locati=
on
>>>instead of to a fresh location. =A0You've saved a command, and you'v=
e
>>>saved the drive some work, plus you've allowed other users to contin=
ue
>>>accessing the drive in the meantime.
>>>
>>>I am planning a complete overhaul of the discard work. =A0Users can =
send
>>>down discard requests as frequently as they like. =A0The block layer=
 will
>>>cache them, and invalidate them if writes come through. =A0Periodica=
lly,
>>>the block layer will send down a TRIM or an UNMAP (depending on the
>>>underlying device) and get rid of the blocks that have remained unwa=
nted
>>>in the interim.
>>>
>>>Thoughts on that are welcome.
>>>>
>>
>> My thought was that a bitmap was a better solution than a cache of
>> discard commands.
>>
>> One of the biggest reasons is that a bitmap can coalesce the unused
>> areas into much larger discard ranges than a queue that will only ha=
ve
>> a limited number of discards to coalesce.
>
> OK, I misunderstood. For the work I did with an SSD company the UNMAP
> requests were coming down as 1024 LBA DISCARDs/UNMAPs. If someone
> deleted a multi-GB file that results in thousands of DISCARDS coming
> down, which is a problem.

I think the ext4 implementation is sending down discards way smaller
than 1024 sectors.  Ted Tso posted something a few months ago that he
did a test and was seeing a massive number of them being sent from
ext4 to block.  The rest of the stack was not in place, so he did not
know the real performance impact.

> However, I wonder if we cannot make do with merging in the block
> layer, especially with XFS or Ext4.

That's the cache and coalesce approach, right?  Just a personal thing,
but we run
things like defrag in the background during off hours.

It seems to me that unmap is not all that different, why do we need to
do it even close in time proximity to the deletes?  With a bitmap, we
have total timing control of when the unmaps are forwarded down to the
device.  I like that timing control much better than a cache and
coalesce approach.

>> And both Enterprise scsi and mdraid are desirous of larger discard r=
anges.
>
> I also would like large discard ranges ... metadata updates in the
> platform I am thinking of are transactional, and I would like to
> reduce the number of transactions pushed through the metadata journal=
=2E
>
> --
> Regards,
> Richard Sharpe

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
