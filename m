From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] [SCSI] Clear Devloss Callback Done flag in
 fc_remote_port_rolechg.
Date: Thu, 03 Nov 2011 11:15:36 +0400
Message-ID: <1320304536.11439.1.camel@dabdike>
References: <fc185e15-b38b-407a-a98b-bb65c53c5f78@exht2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42057 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753803Ab1KCHPl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2011 03:15:41 -0400
In-Reply-To: <fc185e15-b38b-407a-a98b-bb65c53c5f78@exht2.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex.Iannicelli@Emulex.Com
Cc: linux-scsi@vger.kernel.org, James.Smart@Emulex.Com

On Thu, 2011-10-27 at 07:53 -0700, Alex.Iannicelli@Emulex.Com wrote:
> This patch fixes a bug where devloss is not called on fc_host teardown. The 
> issues is seen if the LLDD uses rport_rolechg to add target role to rport.
> When an rport is discovered the LLDD uses fc_rport_add to add the rport and then 
> uses remote_port_rolechg to indicate that it is a target. If this rport goes away 
> and the LLDD calls fc_report_port_delete. The transport calls devloss after the 
> devloss timer fires and it sets the FC_RPORT_DEVLOSS_CALLBK_DONE flag. If the
> LLDD discovers this target again and uses remote_port_add to add it, but it was
> a target and there is no target role assigned yet then this function returns 
> without clearing the FC_RPORT_DEVLOSS_CALLBACK_DONE flag. When the LLDD calls
> again to change the role to a target the report_port_rolechg routine neglects to
> clear the flag as well. Once in this state, if the LLDD tears down the fc_host
> then devloss will not be called for this target because the DEVLOSS_CALLBK_DONE
> flag is still set.
>  
> This patch adds the FC_RPORT_DEVLOSS_CALLBK_DONE flag to the group of flags that
> it clears when flushing devloss timers.
>  
> Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
> Signed-off-by: James Smart <james.smart@emulex.com>

This patch has the usual outlook tab->space corruption.  Could you
resend it either with a working email client or as an attachment?

Thanks,

James


