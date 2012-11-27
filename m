From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH 0/2] Change type-2 dif to use rq embedded 32 byte cdb
Date: Tue, 27 Nov 2012 11:12:17 -0500
Message-ID: <50B4E661.6020002@redhat.com>
References: <1353528468-5664-1-git-send-email-revers@redhat.com> <yq14nkbsyr8.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399Ab2K0QMz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Nov 2012 11:12:55 -0500
In-Reply-To: <yq14nkbsyr8.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, chad.dupuis@qlogic.com, giridhar.malavali@qlogic.com, scameron@beardog.cce.hp.com, mike.miller@hp.com, fushun@marvell.com

On 11/26/2012 06:58 PM, Martin K. Petersen wrote:
>>>>>> "Rob" == Rob Evers<revers@redhat.com>  writes:
> Rob>  These patches replace the original t10 type 2 dif mempool
> Rob>  implementation by increasing the block and scsi cdb maximum sizes
> Rob>  from 16 to 32 bytes.  The cdb embedded in the request structure can
> Rob>  then be used for type 2 dif commands, or other 32 byte cdbs as
> Rob>  required.
>
> Rob>  Motivation for this is that type-2 dif commands should be treated
> Rob>  as any other read/writes generally, without any performance
> Rob>  penalty.
>
> We did the mempool because we did not want to penalize everybody else by
> always allocating 32-byte CDBs. Type 2 is a really rare corner case.

I didn't see a penalty in the non dif case, in the sanity checking I did.
If someone has results that indicate otherwise, please indicate.

> So while I agree we should handle the UA scenario correctly, I'm not
> sure I agree with the fix. Why are you messing with Type 2 devices in
> the first place? These should really only be used inside disk arrays.
>

The previous fix for the mempool race condition was found when
one of our partners reported a problem in a system that had
type 2 dif storage attached to the host.

Use of BLK_MAX_CDB and MAX_COMMAND_SIZE could
use some feedback.


