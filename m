From: Tom Rini <trini@ti.com>
Subject: Re: Commit a692b0e broke my mvsas card
Date: Tue, 17 Apr 2012 10:21:21 -0700
Message-ID: <4F8DA691.5070907@ti.com>
References: <20120416224250.GA1983@bill-the-cat>	<CABE8wwvbSsc02U_m+20-DQgsZ2gQCi_A6susCrmfyx_scQkccw@mail.gmail.com>	<4F8CAC6F.6070907@ti.com>	<1334620782.23541.2.camel@ultramagnus.opencreations.com>	<4F8CCD0C.5060900@ti.com>	<1334633159.13899.4.camel@dwillia2-mobl>	<4F8D81B6.3080604@ti.com> <CABE8wwuze+VwCy3fmA8hsGWpo=HQjPZjhEwgKrb7nvBC_rMwHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:60282 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab2DQRWM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Apr 2012 13:22:12 -0400
In-Reply-To: <CABE8wwuze+VwCy3fmA8hsGWpo=HQjPZjhEwgKrb7nvBC_rMwHg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <JBottomley@parallels.com>, Xiangliang Yu <yuxiangl@marvell.com>

On 04/17/2012 09:50 AM, Dan Williams wrote:
> On Tue, Apr 17, 2012 at 7:44 AM, Tom Rini<trini@ti.com>  wrote:
>> On 04/16/2012 08:25 PM, Dan Williams wrote:
>>>
>>> On Mon, 2012-04-16 at 18:53 -0700, Tom Rini wrote:
>>>>>
>>>>> Thanks, yes it looks like a new regression.  Can you tell me if the
>>>>> following fixes it?
>>>>
>>>>
>>>> No joy, oopses.  http://alnk.org/43youngkirby for the dmesg and oops.
>>>>
>>>
>>> Agh, sorry, I rushed that one.  The phy array is initialized later, here
>>> is another run at it:
>>
>>
>> No crash, but 2 out of 4 SSDs still: http://pastebin.com/PCUGTBqG
>
> Ok, this looks like a different issue around the changes to ata reset.
>   The intent was to leave mvsas with its old behavior (of not waiting
> for resets to complete) until it could be updated to the new reset
> scheme.  Can you send a log from a good run on 3.3?
>
> I want to see if the timings are different, because:
>
> [   10.039490] sas: ata10: end_device-6:4: dev error handler
> [..]
> [   10.198842] ata10.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
> err_mask=0x80)
>
> [   25.684822] sas: ata11: end_device-6:5: dev error handler
> [..]
> [   25.844299] ata11.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
> err_mask=0x80)
>
> Is shorter than I would expect.

The 3.3.0 dmesg is up at http://pastebin.com/cVTmpH1M

-- 
Tom
