From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Commit a692b0e broke my mvsas card
Date: Tue, 17 Apr 2012 09:50:47 -0700
Message-ID: <CABE8wwuze+VwCy3fmA8hsGWpo=HQjPZjhEwgKrb7nvBC_rMwHg@mail.gmail.com>
References: <20120416224250.GA1983@bill-the-cat>
	<CABE8wwvbSsc02U_m+20-DQgsZ2gQCi_A6susCrmfyx_scQkccw@mail.gmail.com>
	<4F8CAC6F.6070907@ti.com>
	<1334620782.23541.2.camel@ultramagnus.opencreations.com>
	<4F8CCD0C.5060900@ti.com>
	<1334633159.13899.4.camel@dwillia2-mobl>
	<4F8D81B6.3080604@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga12.intel.com ([143.182.124.36]:31682 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752221Ab2DQQuu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Apr 2012 12:50:50 -0400
Received: by bkcjm19 with SMTP id jm19so4786661bkc.25
        for <linux-scsi@vger.kernel.org>; Tue, 17 Apr 2012 09:50:47 -0700 (PDT)
In-Reply-To: <4F8D81B6.3080604@ti.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Rini <trini@ti.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <JBottomley@parallels.com>, Xiangliang Yu <yuxiangl@marvell.com>

On Tue, Apr 17, 2012 at 7:44 AM, Tom Rini <trini@ti.com> wrote:
> On 04/16/2012 08:25 PM, Dan Williams wrote:
>>
>> On Mon, 2012-04-16 at 18:53 -0700, Tom Rini wrote:
>>>>
>>>> Thanks, yes it looks like a new regression. =A0Can you tell me if =
the
>>>> following fixes it?
>>>
>>>
>>> No joy, oopses. =A0http://alnk.org/43youngkirby for the dmesg and o=
ops.
>>>
>>
>> Agh, sorry, I rushed that one. =A0The phy array is initialized later=
, here
>> is another run at it:
>
>
> No crash, but 2 out of 4 SSDs still: http://pastebin.com/PCUGTBqG

Ok, this looks like a different issue around the changes to ata reset.
 The intent was to leave mvsas with its old behavior (of not waiting
for resets to complete) until it could be updated to the new reset
scheme.  Can you send a log from a good run on 3.3?

I want to see if the timings are different, because:

[   10.039490] sas: ata10: end_device-6:4: dev error handler
[..]
[   10.198842] ata10.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
err_mask=3D0x80)

[   25.684822] sas: ata11: end_device-6:5: dev error handler
[..]
[   25.844299] ata11.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
err_mask=3D0x80)

Is shorter than I would expect.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
