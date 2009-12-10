From: "Ed Lin - PTU" <ed.lin@promise.com>
Subject: RE: [PATCH 1/1] lpfc: lpfc no longer discovers lun 255
Date: Thu, 10 Dec 2009 12:03:59 -0800
Message-ID: <85ABFDC4641C4847BA6088F2982EFD8F03200AB8@nonamew.ptu.promise.com>
References: <1260459787.2457.74.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:37491 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751757AbZLJUTE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2009 15:19:04 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1260459787.2457.74.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Brian King <brking@linux.vnet.ibm.com>
Cc: Michael Reed <mdr@sgi.com>, James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>



>-----Original Message-----
>From: James Bottomley [mailto:James.Bottomley@suse.de] 
>Sent: 2009年12月10日 7:43
>To: Brian King
>Cc: Michael Reed; James Smart; linux-scsi; Ed Lin - PTU
>Subject: Re: [PATCH 1/1] lpfc: lpfc no longer discovers lun 255
>
>
>On Thu, 2009-12-10 at 07:01 -0600, Brian King wrote:
>> Michael Reed wrote:
>> > 
>> > James Bottomley wrote:
>> >> On Fri, 2009-12-04 at 11:55 -0600, Michael Reed wrote:
>> >>> Yeah.  I'm working on a patch for qla1280.c also.  
>Probably others
>> >>> have been hit.  It would have been nice if the patch author had
>> >>> fixed all the drivers instead of introducing this change 
>and waiting
>> >>> for people to discover their last lun is now missing.
>> >> Actually, lets just revert this:
>> >>
>> >> commit 71c309995bff5b5e84253931888b6e8163ee1df0
>> >> Author: Ed Lin <ed.lin@promise.com>
>> >> Date:   Fri Oct 9 15:23:27 2009 -0700
>> >>
>> >>     [SCSI] fix inconsistent usage of max_lun
>> >>
>> >> Which is causing all the problems.  Perhaps we need to update the
>> >> documentation instead?
>> >>
>> >> James
>> > 
>> > As much as I would whine about it, I think moving to a consistent
>> > usage of max_lun is a good thing.  There are only about 
>140 references
>> > to max_lun in the cscope output so it wouldn't be that difficult
>> > for people to go through and fix up their drivers.  And, I suspect
>> > a good portion will not require any change as they already either
>> > work correctly with sequential lun scan by design or have 
>misinterpreted
>> > the meaning of max_lun, and thus will continue to work correctly
>> > with report lun scan with Mr. Lin's patch applied.
>> 
>> The ibmvfc driver was using 0xffffffff to indicate it 
>essentially had no limit
>> on the number of LUNs. It appears this can no longer be done 
>with the commit
>> above since max_lun is an unsigned int.
>
>Right, I've pulled the commit.  It was largely cosmetic ... moving what
>we actually do to match the documentation.  However, since it appears
>everyone reads the code not the docs, the better course might be moving
>the documentation to match what we actually do.
>

Well, for the stex driver it is not just cosmetic. Unfortunately the member
"lun" in a request message of stex driver is only u8, which means, if user
manually scans lun 256, it will become lun 0. The original patch was intended
to address the issue.

But I didn't notice the repost lun case could have problem when preparing
the original patch. It seems there is no easy fix for it. There is no indication
which case is using sequential scan and which one is using report lun. The
confusion in the manual scan case will continue (but it may do no harm if
no one reported problem). So, I may need to prepare a patch to the stex
driver, either changing max_lun to 255 (so that user can not manually scan
lun 256), or comparing lun in the scsi command with max_lun to make sure
it is in a valid range.

Thanks,

Ed Lin
