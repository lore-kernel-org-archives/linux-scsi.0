From: James Smart <James.Smart@emulex.com>
Subject: Re: [PATCH 0/4] scsi: 64-bit LUN support
Date: Fri, 5 Apr 2013 11:24:53 -0400
Message-ID: <e585e906-5ada-4fe6-a21d-b735c42a51c1@CMEXHTCAS1.ad.emulex.com>
References: <1361261883-41467-1-git-send-email-hare@suse.de> <alpine.WNT.2.00.1303261354360.5004@N5102REMCQXM4BS.qlogic.org> <5152A19C.7010500@suse.de> <5155C235.40807@redhat.com> <515718A3.1080302@suse.de> <51587619.1060208@redhat.com> <515D533C.1070809@suse.de>
Reply-To: <James.Smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:34975 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3DEPY6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Apr 2013 11:24:58 -0400
In-Reply-To: <515D533C.1070809@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Tomas Henzl <thenzl@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Robert Elliott <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>, Bud Brown <bubrown@redhat.com>, "Smart, James" <James.Smart@Emulex.Com>


On 4/4/2013 6:17 AM, Hannes Reinecke wrote:
> On 03/31/2013 07:44 PM, Tomas Henzl wrote:
>> What we can do is to decode the LUN and compare it to max_lun provided by the driver,
>> I think that sg_luns is able to do that, so what is needed is just to follow the SAM.
>>
>> I have seen reports of problem on three different drivers connected to various
>> external storage, all of them having the same basic reason - the driver sets a max_lun
>> and then LUN comes encoded with a newer addressing method and something like this is shown
>> 'kernel: scsi: host 2 channel 0 id 2 lun16643 has a LUN larger than allowed by the host adapter'
>>
>> Decoding the real LUN value would fix this problem, by decoding is only meant the use in
>> scsi_report_lun_scan. The LUN would be stored exactly the same way as it is now.
>> I know we can patch the certain drivers too, but when max_lun were  what the name says
>> - max LU number, it would fix my problem very easy.
>>
> Errm.
>
> No. Decoding LUNs is _evil_. It has only a relevance on the target,
> and even then it might choose to ignore it.
> So we cannot try to out-guess the target here.
>
> The error you're reporting is that lpfc is setting max_luns to
> '255', which of course is less than 16643. Increasing max_luns on
> lpfc to '0xFFFF' will fix your problem; nothing to do with 64-bit
> LUNs ...
>

The reason lpfc set max_luns to 255 is due to the midlayer using 
max_luns as a (SCSI-2 device) max sequential scan loop top value, not 
necessarily as a max lun # as what's now in the report luns scan loop. 
When we were attached to jbods (loop, etc) - we saw 2 problems: our scan 
time dramatically increased (several minutes based on a 16k max_lun 
value); and as the jbod only decoded 8 bits - it happened to respond 
successfully to any lun value where the lower 8-bits were 0, meaning 
lots of midlayer "ghost" devices were created when in reality there was 
only 1 lun present.    Changing the max_luns value is fine as long as 
you know what's attached.

-- james s

