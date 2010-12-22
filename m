From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH scsi-misc-2.6] sd: implement sd_check_events()
Date: Wed, 22 Dec 2010 09:49:53 +0100
Message-ID: <4D11BBB1.2020807@kernel.dk>
References: <20101217122831.39300d94.sfr@canb.auug.org.au>	 <1292597607.2820.17.camel@mulgrave.site>  <4D0CF27F.1080601@kernel.org>	 <1292862013.3034.7.camel@mulgrave.site>	 <1292954953.3034.15.camel@mulgrave.site>  <4D10FDAD.2060801@kernel.dk> <1292963097.3034.21.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1292963097.3034.21.camel@mulgrave.site>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Kay Sievers <kay.sievers@vrfy.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2010-12-21 21:24, James Bottomley wrote:
> On Tue, 2010-12-21 at 20:19 +0100, Jens Axboe wrote:
>> On 2010-12-21 19:09, James Bottomley wrote:
>>> On Mon, 2010-12-20 at 10:20 -0600, James Bottomley wrote:
>>>> Added cc: linux-scsi
>>>>
>>>> On Sat, 2010-12-18 at 18:42 +0100, Tejun Heo wrote:
>>>>> Replace sd_media_change() with sd_check_events().
>>>>>
>>>>> * Move media removed logic into set_media_not_present() and
>>>>>   media_not_present() and set sdev->changed iff an existing media is
>>>>>   removed or the device indicates UNIT_ATTENTION.
>>>>>
>>>>> * Make sd_check_events() sets sdev->changed if previously missing
>>>>>   media becomes present.
>>>>>
>>>>> * Event is reported only if sdev->changed is set.
>>>>>
>>>>> This makes media presence event reported if scsi_disk->media_present
>>>>> actually changed or the device indicated UNIT_ATTENTION.  For backward
>>>>> compatibility, SDEV_EVT_MEDIA_CHANGE is generated each time
>>>>> sd_check_events() detects media change event.
>>>>>
>>>>> Signed-off-by: Tejun Heo <tj@kernel.org>
>>>>> Cc: Kay Sievers <kay.sievers@vrfy.org>
>>>>> ---
>>>>> Here it is.  The conflicts were due to Alan's recent patch, which was
>>>>> in the similar direction anyway.
>>>>
>>>> This looks fine to me.  Jens can you strip the SCSI patches out of your
>>>> tree and I'll run them through a postmerge tree to get the fix up?
>>>
>>> Ping on this, please: I can't build a postmerge tree until block is
>>> sorted out.  I need these four removing:
>>
>> I would need to revert those four then, I can't rebase any of those
>> branches.
> 
> That's a bit unfortunate.  OK, just revert the sd one then.  Hopefully
> we're close enough to the merge window that we won't pick up conflicts
> in the others.

Done, sd patch reverted and pushed out.

-- 
Jens Axboe
