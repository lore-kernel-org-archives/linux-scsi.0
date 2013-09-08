From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 17/18] lpfc 8.3.42: Fixed issue of task management commands
 having a fixed timeout
Date: Sun, 8 Sep 2013 09:59:59 -0400
Message-ID: <522C82DF.2000305@emulex.com>
References: <1378484566.14051.36.camel@myfc17> <522A2125.9040406@tributary.com>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:42790 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab3IHOAC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Sep 2013 10:00:02 -0400
In-Reply-To: <522A2125.9040406@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Jeremy,

Different issues....

The patch addresses only 1 topic - making an attribute to change the 
timeout for the TMF.  This was a request by the distros to post a hack 
that was used on older releases to work around all the serialization and 
delay problems in the midlayer error recovery path - which allowed 
shortening delays from 10-12 minutes to 1-2 minutes. These are the same 
issues we discussed at the last storage forum and which Hannes has been 
working to correct upstream.  The desire is to continue with a like 
tuning option in the driver for those customers that have used it in the 
past.

The other issue - we seem to have missed your prior post. I'll look into 
it shortly.

The two patches work on the same code, but are independent topics.

-- james


On 9/6/2013 2:38 PM, Jeremy Linton wrote:
> On 9/6/2013 11:22 AM, James Smart wrote:
>> Fixed issue of task management commands having a fixed timeout
> 	I'm surprised about this change, since it appears a number of issues in the
> send_taskmgmt() still exist that keep it from handling task management
> failures correctly. It also continues to have a number of smaller issues like
> for example dead code of the form
>
> if (status != IOCB_STATUS)
> else if (status == IOCB_BUSY)
> else
>
>
> 	See patch:
>
> "lpfc should check return status for task mgmt IOCB"
>
> http://marc.info/?l=linux-scsi&m=136242124409687
>
>
>
>

