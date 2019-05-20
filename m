From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: ses: Fix out-of-bounds memory access in
 ses_enclosure_data_process()
Date: Mon, 20 May 2019 17:53:08 -0400
Message-ID: <c14d427c-1d17-fc8f-672d-d612851abcc1@interlog.com>
References: <20190501180535.26718-1-longman@redhat.com>
 <1fd39969-4413-2f11-86b2-729787680efa@redhat.com>
 <1558363938.3742.1.camel@linux.ibm.com>
 <3385cf54-7b6c-3f28-e037-f0d4037368eb@redhat.com>
 <1558367212.3742.10.camel@linux.ibm.com> <yq1zhnh8625.fsf@oracle.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1zhnh8625.fsf@oracle.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.ibm.com>
Cc: Waiman Long <longman@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2019-05-20 12:05 p.m., Martin K. Petersen wrote:
> 
> James,
> 
>> Please.  What I'm interested in is whether this is simply a bug in the
>> array firmware, in which case the fix is sufficient, or whether
>> there's some problem with the parser, like mismatched expectations
>> over added trailing nulls or something.
> 
> Our support folks have been looking at this for a while. We have seen
> problems with devices from several vendors. To the extent that I gave up
> the idea of blacklisting all of them.
> 
> I am collecting "bad" SES pages from these devices. I have added support
> for RECEIVE DIAGNOSTICS to scsi_debug and added a bunch of deliberately
> broken SES pages so we could debug this

Patches ??

> It appears to be very common for devices to return inconsistent or
> invalid data. So pretty much all of the ses.c parsing needs to have
> sanity checking heuristics added to prevent KASAN hiccups.

And it is not just SES device implementations that were broken. The
relationship between Additional Element Status diagnostic page (dpage)
and the Enclosure Status dpage was under-specified in SES-2 and that
led to the EIIOE field being introduced during the SES-3 revisions.
And the meaning of EIIOE was tweaked several times *** before SES-3 was
standardized. Anyone interested in the adventures of EIIOE can see
the code of sg_ses.c in sg3_utils. The sg_ses utility is many times
more complex than anything else in the sg3_utils package.

And that complexity led me to suspect that the Linux SES driver was
broken. It should be 3 or 4 times larger than it is! It simply doesn't
do enough checking.

So yes Martin, you are on the right track.

Doug Gilbert


BTW the NVME Management Interface folks have decided to use SES-3 for
NVME enclosure management rather than invent their own can of worms :-)

*** For example EIIOE started life as a 1 bit field, but two cases
     wasn't enough, so it became a 2 bit field and now uses all
     four possibilities.
