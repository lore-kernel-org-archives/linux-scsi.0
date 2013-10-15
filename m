From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Is there any plan to support 64bit lun in mainline?
Date: Tue, 15 Oct 2013 15:58:33 +0100
Message-ID: <3aeace08-b1f4-45b0-a026-960cc93cef55@email.android.com>
References: <FD44589ECFC0AF44ABFD421806CAB1F081EC2FEA@SZXEMA502-MBX.china.huawei.com> <525BC836.2030306@suse.de> <1381775449.3752.9.camel@dabdike.lan> <525CDA2A.2060308@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59070 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932639Ab3JOO7E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Oct 2013 10:59:04 -0400
In-Reply-To: <525CDA2A.2060308@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

Ok may be brief: on top of cliff with fleeting mobile signal.

Hannes Reinecke <hare@suse.de> wrote:
>On 10/14/2013 08:30 PM, James Bottomley wrote:
>> On Mon, 2013-10-14 at 12:32 +0200, Hannes Reinecke wrote:
>[ .. ]
>>>
>>> However, there are two other patchsets pending (EH Deadline and
>>> asynchronous command aborts), both of which have been tested
>>> thoroughly _and_ have acked-by from various other parties.
>>> None of these patchset had received any feedback from James
>>> Bottomley, let alone any indication if or when they'll be merged.
>>>
>>> So I stopped sending further patchsets, sensing some communication
>>> breakdown on the line.
>> 
>> There's no communications breakdown, I've just been very busy.  EH
>> deadline looks OK, but let me look again to make sure.  Async aborts
>I'm
>> not necessarily keen on because I know a lot of devices where
>aborting
>> just confuses the firmware more, so I think skipping aborts and
>moving
>> to LUN reset might be a better form of acceleration.
>> 
>
>Hmm. I've made exactly the opposite experience with FC devices.
>A faulty SFP or wiring might cause the occasional frame drop, which
>will be happily corrected with an ABTS.
>And HBAs like lpfc or qla2xxx even have a fast command abort built
>into the firmware, where the firmware will not even wait for a
>command abort to hit the wire but rather just disable the exchange
>internally and return.
>_Not_ sending an abort but rather escalating directly to LUN reset
>will only make matters worse here.
>Plus a LUN reset won't be able to fix anything here.

Its mostly for*device* firmware problems. The while problem with our reset escalations is that they don't fit with a transport model. Its a bit accidental that abort works for the fc transport because its designed as a device message.

>But sure, if there are some devices which are confused by aborts,
>sure we should be doing something about it.
>Just out of curiosity, which devices are we talking about?

Lots of older drives. Even some arrays (but also only older ones). For them when they start to timeout they've already begun losing track of commands so aborts make this worse.

>I would very much prefer to have inlined command aborts at least for
>FC, as it has proven to be really beneficial there.

Ok, so how about this. I looked over
The running abort series. It looks fine apart from some coding bits. For the deadline, we can't waste all the deadline with the tiny hammer and then fail to use the bigone. Should have internet on Wednesday will expand then.

James

>Cheers,
>
>Hannes

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
