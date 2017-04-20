From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH-v1 02/22] Fix nvme unregister port timeout.
Date: Thu, 20 Apr 2017 09:15:54 +0200
Message-ID: <20170420071554.GC6217@linux-x5ow.site>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
 <20170420044641.10657-3-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47176 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S942852AbdDTHP6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Apr 2017 03:15:58 -0400
Content-Disposition: inline
In-Reply-To: <20170420044641.10657-3-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On Wed, Apr 19, 2017 at 09:46:21PM -0700, jsmart2021@gmail.com wrote:
> From: James Smart <jsmart2021@gmail.com>
> 
> During some link event testing it was observed that the
> wait_for_completion_timeout in the lpfc_nvme_unregister_port
> was timing out all the time.
> 
> The initiator is claiming the nvme_fc_unregister_remoteport upcall is
> not completing the unregister in the time allotted.
> [ 2186.151317] lpfc 0000:07:00.0: 0:(0):6169 Unreg nvme wait failed 0
> 
>  The wait_for_completion_timeout returns 0 when the wait has
> been outstanding for the jiffies passed by the caller.  In this error
> message, the nvme initiator passed value 5 - meaning 5 jiffies -
> and this is just wrong.
> 
> Calculate 5 seconds in Jiffies and pass that value
> from the current jiffies.
> 
> Also the log message for the unregister timeout was reduced
> because timeout failure is the same as timeout.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
