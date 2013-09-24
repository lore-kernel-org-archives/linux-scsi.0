From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [dm-devel] SCSI's heuristics for enabling WRITE SAME still need
 work [was: dm mpath: disable WRITE SAME if it fails]
Date: Tue, 24 Sep 2013 15:37:27 -0400
Message-ID: <5241E9F7.1080303@interlog.com>
References: <20130919161043.GA27081@redhat.com> <20130920212142.GA17898@redhat.com> <yq1eh8jf8wq.fsf@sermon.lab.mkp.net> <1379960325.4010.32.camel@localhost.localdomain> <52412581.2010909@suse.de> <5241E422.1010700@tributary.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:56594 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab3IXThy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Sep 2013 15:37:54 -0400
In-Reply-To: <5241E422.1010700@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>, Hannes Reinecke <hare@suse.de>
Cc: "emilne@redhat.com" <emilne@redhat.com>, device-mapper development <dm-devel@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>

On 13-09-24 03:12 PM, Jeremy Linton wrote:
> On 9/24/2013 12:39 AM, Hannes Reinecke wrote:
>
>> My drives support 'report opcodes', and report that write same is
>> supported: ... 93                 16    Write same(16) ...
>>
>> but no support for page 'b0'. And yes, these are real SAS drives.
>
> 	So the question is, how many devices get the protect bit in the std inquiry
> incorrect?

To that specific question: all of them get it right because
if they don't the disk (LU) does not support PI (or at least
that is the conclusion the application client should reach).
What the sales blurb for the device may say is another thing.

More generally why are we using WRITE SAME:
   a) associated with LB provisioning?
   b) associated with PI (DIF)?
   c) as an optimized multi-block write of the same contents?

I'm not aware there is any special relationship between WS
and PI. That leaves a) and c) . I'm guessing it is more
important for a) .

> 	If that is mostly correct, how about std inquiry (SPC>2), protect bit, and then
> VPD page 0x86 (or alternatively then do the READ CAPACITY, P_TYPE instead of
> page 0x86)?
>
> 	After all, the set of valid read/write opcodes is limited by the protection
> mode format, yes?

Yes: READ(32), WRITE(32), WRITE SAME(32), VERIFY(32)
and WRITE AND VERIFY(32) are only valid for protection
type 2 (sbc3r35h 4.22.2.2). I'm sure T10 have a good
reason for that but they are keeping that reason to
themselves.

Doug Gilbert


