From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] scsi_debug: add LBPRZ support
Date: Wed, 07 Mar 2012 19:18:35 -0600
Message-ID: <4F5808EB.9000909@redhat.com>
References: <4F57C061.9020807@redhat.com> <4F58049C.5010505@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab2CHBSj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Mar 2012 20:18:39 -0500
In-Reply-To: <4F58049C.5010505@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, mkp@mkp.net, =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>

On 3/7/12 7:00 PM, Douglas Gilbert wrote:
> On 12-03-07 03:09 PM, Eric Sandeen wrote:
>> Add LBPRZ support to scsi_debug; i.e. return zero for
>> unmapped blocks.
>>
>> Rather than checking for unmapped blocks at
>> read time, this just zeroes them on the backing store
>> at unmap time so it behaves the same way.
>>
>> This also adds a module parameter to disable it, since
>> some SSDs have this behavior.
>>
>> unmap_zeroes, "unmapped blocks return 0 on read (def=1)"
>>
>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>> ---
>>
>> Note: This was sent long ago as "TPRZ" support, but lost, I guess.
>>
>> Note2: dgilbert preferred "zeros" to "zeroes" at the time,
>> but since we have "discard_zeroes_data" in sysfs it seems like
>> we should be consistent with the kernel precedent, rather than
>> the spec spelling.
> 
> Eric,
> I checked the latest drafts of SPC-4 and SBC-3 and they
> contain both "zeros" and "zeroes". Take your pick!

While we're talking about names, looking at other scsi_debug_* flags
should it be lbprz / scsi_debug_lbprz / DEF_LBPRZ instead of
unmap_zeroes / scsi_debug_unmap_zeroes / DEF_UNMAP_ZEROES?
 
> More seriously the LBPRZ flag now appears in the Logical
> Block Provisioning VPD page and the READ CAPACITY (16)
> response. Your patch sets the latter, could you add the
> LBPRZ flag setting in the inquiry_evpd_b2() function as
> well. Perhaps:
>   if (scsi_debug_unmap_zeroes)
>     arr[1] |= 1 << 2;

ok; I'm no scsi guy, just a pattern-following monkey but I'll
change that if you say it's right. :)

> And if your are editing that function in the comment introducing
> that function:
>    s/Thin/Logical block/
> to reflect the renaming done by t10.org .

ok.

> Ah, and inquiry_evpd_b2() should return 4 (not 8).

Is that at all related to this change or some other random bug?
Should that return be unconditional?  Should that be a separate
patch?  By someone who knows what it means? :)

> Otherwise it looks good.


Thanks,

-Eric


 
> Doug Gilbert
> 

