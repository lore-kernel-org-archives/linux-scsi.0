From: Brian King <brking@us.ibm.com>
Subject: Re: Control Mode page (0xA) QERR bit setting
Date: Tue, 31 Aug 2004 08:55:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41348346.9030901@us.ibm.com>
References: <20040831024520.GA2118@sgi.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:15233 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S268538AbUHaNza
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2004 09:55:30 -0400
In-Reply-To: <20040831024520.GA2118@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: linux-scsi@vger.kernel.org

The ipr driver actually depends on QERR=1 and adapter firmware to do the 
right thing. TCQing doesn't get setup by the ipr driver until userspace 
enables it, and the userspace tool to enable it takes care of setting up 
QERR=1 before enabling it. When I get a check condition I send down a 
cancel all requests to the device, which is similar to an abort task 
set. The end result is that all commands that were silently aborted get 
returned to me with aborted status. Meanwhile, the device is in a state 
where it will always return a "not ready - synchronization required" 
response (pseudo ACA state), which I translate to DID_IMM_RETRY. I do 
the request sense and then clear this sync required state on the next 
command issued.

-Brian

Jeremy Higdon wrote:
> It looks as though the midlayer assumes that QERR is 0.  Is that correct?
> 
> If QERR is 0, then a check condition for one command will not affect other
> commands, whereas if QERR is 1, then when one command gets a check condition,
> all others for that ITL are silently aborted.
> 
> Since I wasn't able to find any code (other than in the ipr driver) that
> completed all outstanding commands to a Lun when a check condition is
> received, I figure that we depend on QERR=0.
> 
> thanks
> 
> jeremy
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

