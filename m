From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] lpfc: lpfc no longer discovers lun 255
Date: Thu, 10 Dec 2009 07:01:40 -0600
Message-ID: <4B20F134.60400@linux.vnet.ibm.com>
References: <4B1932FA.7080407@sgi.com> <4B1949E3.8040400@emulex.com> <4B194D1D.3060309@sgi.com> <1259949518.8360.90.camel@mulgrave.site> <4B195869.7040504@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:38088 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZLJNB4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2009 08:01:56 -0500
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e36.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id nBACxaRT030863
	for <linux-scsi@vger.kernel.org>; Thu, 10 Dec 2009 05:59:36 -0700
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nBAD1o5o084742
	for <linux-scsi@vger.kernel.org>; Thu, 10 Dec 2009 06:01:52 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nBAD1j1h006867
	for <linux-scsi@vger.kernel.org>; Thu, 10 Dec 2009 06:01:47 -0700
In-Reply-To: <4B195869.7040504@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James Bottomley <James.Bottomley@suse.de>, James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>, Ed Lin <ed.lin@promise.com>

Michael Reed wrote:
> 
> James Bottomley wrote:
>> On Fri, 2009-12-04 at 11:55 -0600, Michael Reed wrote:
>>> Yeah.  I'm working on a patch for qla1280.c also.  Probably others
>>> have been hit.  It would have been nice if the patch author had
>>> fixed all the drivers instead of introducing this change and waiting
>>> for people to discover their last lun is now missing.
>> Actually, lets just revert this:
>>
>> commit 71c309995bff5b5e84253931888b6e8163ee1df0
>> Author: Ed Lin <ed.lin@promise.com>
>> Date:   Fri Oct 9 15:23:27 2009 -0700
>>
>>     [SCSI] fix inconsistent usage of max_lun
>>
>> Which is causing all the problems.  Perhaps we need to update the
>> documentation instead?
>>
>> James
> 
> As much as I would whine about it, I think moving to a consistent
> usage of max_lun is a good thing.  There are only about 140 references
> to max_lun in the cscope output so it wouldn't be that difficult
> for people to go through and fix up their drivers.  And, I suspect
> a good portion will not require any change as they already either
> work correctly with sequential lun scan by design or have misinterpreted
> the meaning of max_lun, and thus will continue to work correctly
> with report lun scan with Mr. Lin's patch applied.

The ibmvfc driver was using 0xffffffff to indicate it essentially had no limit
on the number of LUNs. It appears this can no longer be done with the commit
above since max_lun is an unsigned int.

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


