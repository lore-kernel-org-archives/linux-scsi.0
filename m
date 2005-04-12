From: Douglas Gilbert <dougg@torque.net>
Subject: Re: evaluation of scsi_cmnd->resid
Date: Wed, 13 Apr 2005 07:38:47 +1000
Message-ID: <425C3FE7.4040308@torque.net>
References: <20050412180443.GA7395@lion28.boeblingen.de.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:42447 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S263005AbVDLVmt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2005 17:42:49 -0400
In-Reply-To: <20050412180443.GA7395@lion28.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <aherrman@de.ibm.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

Andreas Herrmann wrote:
> Hi,
> 
> Am I right in the assumption that scsi_cmnd->resid is just of use for
> requests initiated by sg?
> 
> How does the SCSI-stack handle normal (non-sg) requests for SCSI disks
> for which a scsi_cmnd->resid is set?  AFAIK, resid is ignored by
> sd. So, such requests are returned to the block layer although the
> amount of data transferred is less the amount of data that should have
> been transferred.  For FCP-drivers this means that some error situations
> cannot be handled by just using scsi_cmnd->resid.
> 
> What am I missing here?

Andreas,
sd, sr, st, ch and osst (and the mid level when it issues
SCSI commands) need to be modified to use resid.

resid is initialized to zero (by the mid level). So older
LLDs that do not set resid will not change the current
situation for the ULDs mentioned above :-)

Doug Gilbert

