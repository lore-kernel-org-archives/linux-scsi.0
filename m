From: "Kevin P. Fleming" <kpfleming@backtobasicsmgmt.com>
Subject: Re: Weird SCSI error, can anyone interpret?
Date: Fri, 05 Mar 2004 07:47:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <404892F7.8010001@backtobasicsmgmt.com>
References: <4046AB54.9010909@backtobasicsmgmt.com> <20040305060748.GC9315@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wsip-68-14-253-125.ph.ph.cox.net ([68.14.253.125]:10375 "EHLO
	office.labsysgrp.com") by vger.kernel.org with ESMTP
	id S262612AbUCEOrW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Mar 2004 09:47:22 -0500
In-Reply-To: <20040305060748.GC9315@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org

Andrew Vasquez wrote:

> Before the deluge of I/O error messages, does the messages file
> contain any useful bits of information, i.e. the driver posting
> messages about link failures, devices going away, etc.

Nope, there were no other SCSI related messages before these (all the 
way back to the last kernel boot, about 18 hours before).

> Did the driver not recognize the RAID box on the loop?

No, the loop appeared to come up but there were no devices present. 
Thanks for asking, I hadn't checked the log file to that level of detail 
yet. That's a pretty important sign that the problem was the RAID 
controller, given that the ISP2100 and the CMD-7220 are the only devices 
on the loop (direct cable between them).

> Now that's interesting...

Yes, that's why I think this may be a RAID controller problem (we've 
already had one of the original two boards die a year or so ago).

> Well given the information that was presented, I'd say it seems rather
> suspicious that the RAID- box needed a power-cycle to be restored into
> functioning state.  What type of I/O patterns were being run to the
> RAID box?  How many concurrent commands were being queued?

At this time of day there would have been almost zero activity. The 
"flood" of error messages I referred was over the next 56 hours or so, 
from when the problem occurred until users starting trying to hit the 
server on Monday morning.

> Could you enable some additional debug in the driver and rerun your
> test?   Set DEBUG_QLA2100 to 1 in qla_settings.h and define
> QL_DEBUG_LEVEL_2 in qla_dbg.h.  Recompile the driver, then run your
> test.  If a failure occurs, send me the resultant /var/log/messages
> file and the output of the following command:
> 
> 	# cat /proc/scsi/qla2xxx/* 

I can try that this afternoon, can't promise when (if) the problem will 
occur again, and I will have to have the customer ready to issue the cat 
command but they are capable of that.

Thanks for your help.
