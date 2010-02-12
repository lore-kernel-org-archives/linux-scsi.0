From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 06/11] qla4xxx: added srb referance counter
Date: Thu, 11 Feb 2010 18:48:12 -0600
Message-ID: <4B74A54C.5030100@cs.wisc.edu>
References: <20100130062856.GG10274@linux-qf4p> <4B671BFC.90107@cs.wisc.edu> <20100211110852.GB8237@linux-qf4p> <4B748B4D.5030809@cs.wisc.edu> <4B748C86.6030903@cs.wisc.edu> <0CB616B0-0903-41A0-9ADD-5DD64989FFD1@qlogic.com> <4B7498A5.4040307@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59748 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab0BLAsh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Feb 2010 19:48:37 -0500
In-Reply-To: <4B7498A5.4040307@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ravi.anand" <ravi.anand@qlogic.com>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

On 02/11/2010 05:54 PM, Mike Christie wrote:
> It seems like you would want to do
>

Maybe one more fix.


> qla4xxx_wait_for_hba_online()
> spin_lock_irqsave(&ha->hardware_lock, flags);
>
> srb = (struct srb *) cmd->SCp.ptr;
> if (!srb)
> /* raced while waiting for hba online */
> return SUCCESS;
>
> /* Get a reference to the sp and drop the lock.*/
> sp_get(srb);
> spin_unlock_irqrestore(&ha->hardware_lock, flags);
> qla4xxx_abort_task()

 From what I can tell, we used to call qla4xxx_srb_compl (and now do the 
final sp_put in the normal completion path) while holding the 
hardware_lock. If this is not the case then the loop in the eh abort 
patch is racey and my pseudo code above is too).

If I am right, then I think here we want to do

spin_lock_irqsave(&ha->hardware_lock, flags);
sp_put(ha, srb);

So it is consistent with the other code, and then I think we want to add 
a comment in sp_put() that we should be holing the hardware_lock when 
calling it.


> sp_put(ha, srb)
> spin_lock_irqsave(&ha->hardware_lock, flags);
>
> qla4xxx_eh_wait_on_command(ha, cmd);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

