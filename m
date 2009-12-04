From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH 1/1] lpfc: lpfc no longer discovers lun 255
Date: Fri, 04 Dec 2009 12:43:53 -0600
Message-ID: <4B195869.7040504@sgi.com>
References: <4B1932FA.7080407@sgi.com> <4B1949E3.8040400@emulex.com>	 <4B194D1D.3060309@sgi.com> <1259949518.8360.90.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:48044 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753413AbZLDSns (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Dec 2009 13:43:48 -0500
In-Reply-To: <1259949518.8360.90.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>, Ed Lin <ed.lin@promise.com>



James Bottomley wrote:
> On Fri, 2009-12-04 at 11:55 -0600, Michael Reed wrote:
>> Yeah.  I'm working on a patch for qla1280.c also.  Probably others
>> have been hit.  It would have been nice if the patch author had
>> fixed all the drivers instead of introducing this change and waiting
>> for people to discover their last lun is now missing.
> 
> Actually, lets just revert this:
> 
> commit 71c309995bff5b5e84253931888b6e8163ee1df0
> Author: Ed Lin <ed.lin@promise.com>
> Date:   Fri Oct 9 15:23:27 2009 -0700
> 
>     [SCSI] fix inconsistent usage of max_lun
> 
> Which is causing all the problems.  Perhaps we need to update the
> documentation instead?
> 
> James

As much as I would whine about it, I think moving to a consistent
usage of max_lun is a good thing.  There are only about 140 references
to max_lun in the cscope output so it wouldn't be that difficult
for people to go through and fix up their drivers.  And, I suspect
a good portion will not require any change as they already either
work correctly with sequential lun scan by design or have misinterpreted
the meaning of max_lun, and thus will continue to work correctly
with report lun scan with Mr. Lin's patch applied.

I won't pretend to know the right answer.

Mike


> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
