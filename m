From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] scsi_debug: add TPRZ support
Date: Mon, 23 Aug 2010 20:17:10 -0500
Message-ID: <4C731D96.5000308@redhat.com>
References: <4C72CAF7.8020601@redhat.com> <4C731B08.1060100@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab0HXBRT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2010 21:17:19 -0400
In-Reply-To: <4C731B08.1060100@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: mkp@mkp.net, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Eric,
> Now for a really serious issue: in sbc3r24
> TPRZ == "thin provisioning read zeros".
> SBC-3 uses the shorter variant of the plural of
> zero. [ACS-2 uses both zeros and zeroes :-)]
> 
> The reason I point that out (apart from trying to
> distract James B. from another dispute) is that
> you are introducing a new module option called
> "unmap_zeroes". I prefer the shorter form.

Ok, I think i was following Martin's lead there,
based on what's presented in sysfs:

queue/discard_zeroes_data

Believe it or not I thought about this ;)

> When I tried to combine your patch on top of Martin's
> I needed to do a hand merge (since I'm "gitless") onto
> lk 2.6.35 . Both of you picked almost the same lines
> to change. Attached is the result of my patch merge
> against lk 2.6.35 . It may not be tab clean.
> 
> With that combined patch I checked a real SSD that
> does TPRZ against the scsi_debug virtual SSD and it
> looked okay with my utilities.

Thanks, will look over your combined patch & let you know
if I see anything.

-Eric

> 
> SCSI WRITE SAME does have one interesting quirk that
> Martin may like to consider. If the "number of
> logical blocks" field is zero, then that implies write
> to the end of the LU!! Madness when you think about it.
> libata's SCSI WRITE SAME translation takes the zero
> number of LBs literally and does nothing I guess
> (when the UNMAP bit is given).
> 
> Doug Gilbert
> 
> 
> 
> On 10-08-23 03:24 PM, Eric Sandeen wrote:
>> Add TPRZ support to scsi_debug; i.e. return zero for
>> unmapped blocks.
>>
>> Rather than checking for unmapped blocks at
>> read time, this just zeroes them on the backing store
>> at unmap time so it behaves the same way.
>>
>> This also adds a module parameter to disable it, since
>> some SSDs have this behavior.
>>
>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> 
> Acked-by: Douglas Gilbert <dgilbert@interlog.com>
> 

