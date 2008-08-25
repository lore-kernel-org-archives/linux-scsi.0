From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC][PATCH 2/6] fnic: add fnic_scsi.c and fnic_io.h.
Date: Mon, 25 Aug 2008 14:31:17 -0500
Message-ID: <48B30885.1010808@cs.wisc.edu>
References: <20080823024949.13569.94133.stgit@feynman.nuovasystems.com> <20080823025222.13569.37765.stgit@feynman.nuovasystems.com> <48B2F880.7080108@cs.wisc.edu> <48B304BD.9060404@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42717 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756248AbYHYTb3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 15:31:29 -0400
In-Reply-To: <48B304BD.9060404@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "jeykholt@cisco.com" <jeykholt@cisco.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jre@nuovasystems.com" <jre@nuovasystems.com>, "ajoglekar@nuovasystems.com" <ajoglekar@nuovasystems.com>

James Smart wrote:
> 
> 
> Mike Christie wrote:
>> jeykholt@cisco.com wrote:
>>> fnic: add fnic_scsi.c and fnic_io.h.
>>>
>>> fnic_scsi.c contains the FCP SCSI handling as well as firmware reset
>>> and FLOGI registration handling.
>>>
>>
>> I just looked at this one function, because I was fixing the same code
>> in fcoe.ko/libfc:fc_fcp.c
>>
>>
>>> +int fnic_reset(struct Scsi_Host *shost)
>>> +{
>>> +     struct fc_lport *lp;
>>> +     struct fnic *fnic;
>>> +     unsigned long flags;
>>> +     int ret = SUCCESS;
>>> +     enum fnic_state old_state;
>>> +     DECLARE_COMPLETION_ONSTACK(reset_wait);
>>> +
>>> +     lp = shost_priv(shost);
>>> +     fnic = lp->drv_priv;
>>> +
>>> +     printk(KERN_DEBUG DFX "fnic_reset called\n", fnic->fnic_no);
>>> +
>>> +     /* Issue firmware reset */
>>> +     spin_lock_irqsave(&fnic->fnic_lock, flags);
>>> +     fnic->reset_wait = &reset_wait;
>>> +     old_state = fnic->state;
>>> +     fnic->state = FNIC_IN_FC_TRANS_ETH_MODE;
>>> +     vnic_dev_del_addr(fnic->vdev, fnic->data_src_addr);
>>> +     spin_unlock_irqrestore(&fnic->fnic_lock, flags);
>>> +
>>> +     if (fnic_fw_reset_handler(fnic)) {
>>> +             spin_lock_irqsave(&fnic->fnic_lock, flags);
>>> +             ret = FAILED;
>>> +             if (fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)
>>> +                     fnic->state = old_state;
>>> +             fnic->reset_wait = NULL;
>>> +             spin_unlock_irqrestore(&fnic->fnic_lock, flags);
>>> +             goto fnic_reset_end;
>>> +     }
>>> +
>>> +     /* fw reset is issued, now wait for it to complete */
>>> +     wait_for_completion_timeout(&reset_wait,
>>> +                                 
>>> msecs_to_jiffies(FNIC_HOST_RESET_TIMEOUT));
>>> +
>>> +     /* Check for status */
>>> +     spin_lock_irqsave(&fnic->fnic_lock, flags);
>>> +     fnic->reset_wait = NULL;
>>> +     ret = (fnic->state == FNIC_IN_ETH_MODE) ? SUCCESS : FAILED;
>>> +     spin_unlock_irqrestore(&fnic->fnic_lock, flags);
>>> +
>>> +     /* Now reset local port, this will clean up libFC exchanges,
>>> +      * reset remote port sessions, and if link is up, begin flogi
>>> +      */
>>> +     fc_lport_lock(lp);
>>> +     if (lp->tt.lport_reset(lp))
>>> +             ret = FAILED;
>>
>>
>> The problem here is that this only starts the login. When fnic_reset
>> returns for the scsi eh path, scsi-ml is going to send a TUR to make
>> sure that we are ready to go. If we are not the devices will be
>> offlined. So unless it is a really quick relogin we are going to offline
>> the devices by accident.
> 
> Well - what should be happening is - prior to the reset or as part of 
> it, the fc transport fc_remote_port_delete() call should be made on all 
> those remote ports that connectivity is about to be terminated on.  This 
> will place all the associated targets/luns on those rports into a 
> blocked state, and start the devloss timer on them.  This will suspend 
> the eh path as well.  Thus, things suspend until either the driver/fcoe 

What do you mean by that? For lpfc it will or for this driver? This 
driver does not have that block call like lpfc_block_error_handler, so 
if the rport event occurs after the scsi eh is running we do not suspend 
the eh.

So below I am saying we should make the lpfc_block_error_handler 
functionality and the equivalent in the qla2xxx and mpfc common so 
libfc/fcoe and fnic can use it.



> stack re-login's and re-calls the transport with the same remote port 
> (thus the transport will unblock the targets/luns), or devloss_tmo 
> expires, at which time it is correct to report loss of connectivity.
> 
> Of course, all this assumes the fc_host stays in existence.
> 
>>
>> For fc_fcp.c I added a hokey loop and wait like some other drivers. We
>> could instead have libfc notify any waiters of a state change here. We
>> could also do a rport blocked timedout helper, convert the fc drivers
>> and use it here so we only wait for the login to complete or for the
>> port block to fail.
> 
> -- james s

