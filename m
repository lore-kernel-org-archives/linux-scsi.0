From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 0/4] scsi: 64-bit LUN support
Date: Mon, 08 Apr 2013 17:37:10 +0200
Message-ID: <5162E426.40202@redhat.com>
References: <1361261883-41467-1-git-send-email-hare@suse.de> <alpine.WNT.2.00.1303261354360.5004@N5102REMCQXM4BS.qlogic.org> <5152A19C.7010500@suse.de> <5155C235.40807@redhat.com> <515718A3.1080302@suse.de> <51587619.1060208@redhat.com> <515D533C.1070809@suse.de> <e585e906-5ada-4fe6-a21d-b735c42a51c1@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965075Ab3DHPiH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Apr 2013 11:38:07 -0400
In-Reply-To: <e585e906-5ada-4fe6-a21d-b735c42a51c1@CMEXHTCAS1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@emulex.com
Cc: Hannes Reinecke <hare@suse.de>, Chad Dupuis <chad.dupuis@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Robert Elliott <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>, Bud Brown <bubrown@redhat.com>

On 04/05/2013 05:24 PM, James Smart wrote:
>
> On 4/4/2013 6:17 AM, Hannes Reinecke wrote:
>> On 03/31/2013 07:44 PM, Tomas Henzl wrote:
>>> What we can do is to decode the LUN and compare it to max_lun provided by the driver,
>>> I think that sg_luns is able to do that, so what is needed is just to follow the SAM.
>>>
>>> I have seen reports of problem on three different drivers connected to various
>>> external storage, all of them having the same basic reason - the driver sets a max_lun
>>> and then LUN comes encoded with a newer addressing method and something like this is shown
>>> 'kernel: scsi: host 2 channel 0 id 2 lun16643 has a LUN larger than allowed by the host adapter'
>>>
>>> Decoding the real LUN value would fix this problem, by decoding is only meant the use in
>>> scsi_report_lun_scan. The LUN would be stored exactly the same way as it is now.
>>> I know we can patch the certain drivers too, but when max_lun were  what the name says
>>> - max LU number, it would fix my problem very easy.
>>>
>> Errm.
>>
>> No. Decoding LUNs is _evil_. It has only a relevance on the target,
>> and even then it might choose to ignore it.
>> So we cannot try to out-guess the target here.
OK, I can see the problems with decoding the LUN one of them is the need to
again encode the LUN to address format + number. I'm not sure if the hw
would work if another address mode were used.

When we understand the LUN as a complex structure then it makes no sense
to compare to max_lun as a number - http://lxr.linux.no/#linux+v3.8.6/drivers/scsi/scsi_scan.c#L1471

>> The error you're reporting is that lpfc is setting max_luns to
>> '255', which of course is less than 16643. Increasing max_luns on
>> lpfc to '0xFFFF' will fix your problem; nothing to do with 64-bit
>> LUNs ...
I think I haven't mentioned lpfc, but it doesn't matter.
Fixing this in individual drivers by increasing the max_lun is not easy,
because the firmware could have some reasons for the max lun (some tables, ..., 
fact is I have no idea how this is implemented in the hw).
If the fix for this were just to set max_lun to 0xFFFF in every driver
it means that we could remove the max_lun and the test completely. 

A kernel option like 'ignore_max_lun' would help, but I somehow dislike it,
what do you think?

> The reason lpfc set max_luns to 255 is due to the midlayer using 
> max_luns as a (SCSI-2 device) max sequential scan loop top value, not 
> necessarily as a max lun # as what's now in the report luns scan loop. 
> When we were attached to jbods (loop, etc) - we saw 2 problems: our scan 
> time dramatically increased (several minutes based on a 16k max_lun 
> value); and as the jbod only decoded 8 bits - it happened to respond 
> successfully to any lun value where the lower 8-bits were 0, meaning 
> lots of midlayer "ghost" devices were created when in reality there was 
> only 1 lun present.    Changing the max_luns value is fine as long as 
> you know what's attached.
>
> -- james s
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

