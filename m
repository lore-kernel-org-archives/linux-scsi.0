From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC][PATCH 2/6] fnic: add fnic_scsi.c and fnic_io.h.
Date: Mon, 25 Aug 2008 15:15:09 -0400
Message-ID: <48B304BD.9060404@emulex.com>
References: <20080823024949.13569.94133.stgit@feynman.nuovasystems.com> <20080823025222.13569.37765.stgit@feynman.nuovasystems.com> <48B2F880.7080108@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:37354 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbYHYTPd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Aug 2008 15:15:33 -0400
In-Reply-To: <48B2F880.7080108@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "jeykholt@cisco.com" <jeykholt@cisco.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jre@nuovasystems.com" <jre@nuovasystems.com>, "ajoglekar@nuovasystems.com" <ajoglekar@nuovasystems.com>



Mike Christie wrote:
> jeykholt@cisco.com wrote:
>> fnic: add fnic_scsi.c and fnic_io.h.
>>
>> fnic_scsi.c contains the FCP SCSI handling as well as firmware reset
>> and FLOGI registration handling.
>>
> 
> I just looked at this one function, because I was fixing the same code
> in fcoe.ko/libfc:fc_fcp.c
> 
> 
>> +int fnic_reset(struct Scsi_Host *shost)
>> +{
>> +     struct fc_lport *lp;
>> +     struct fnic *fnic;
>> +     unsigned long flags;
>> +     int ret = SUCCESS;
>> +     enum fnic_state old_state;
>> +     DECLARE_COMPLETION_ONSTACK(reset_wait);
>> +
>> +     lp = shost_priv(shost);
>> +     fnic = lp->drv_priv;
>> +
>> +     printk(KERN_DEBUG DFX "fnic_reset called\n", fnic->fnic_no);
>> +
>> +     /* Issue firmware reset */
>> +     spin_lock_irqsave(&fnic->fnic_lock, flags);
>> +     fnic->reset_wait = &reset_wait;
>> +     old_state = fnic->state;
>> +     fnic->state = FNIC_IN_FC_TRANS_ETH_MODE;
>> +     vnic_dev_del_addr(fnic->vdev, fnic->data_src_addr);
>> +     spin_unlock_irqrestore(&fnic->fnic_lock, flags);
>> +
>> +     if (fnic_fw_reset_handler(fnic)) {
>> +             spin_lock_irqsave(&fnic->fnic_lock, flags);
>> +             ret = FAILED;
>> +             if (fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)
>> +                     fnic->state = old_state;
>> +             fnic->reset_wait = NULL;
>> +             spin_unlock_irqrestore(&fnic->fnic_lock, flags);
>> +             goto fnic_reset_end;
>> +     }
>> +
>> +     /* fw reset is issued, now wait for it to complete */
>> +     wait_for_completion_timeout(&reset_wait,
>> +                                 msecs_to_jiffies(FNIC_HOST_RESET_TIMEOUT));
>> +
>> +     /* Check for status */
>> +     spin_lock_irqsave(&fnic->fnic_lock, flags);
>> +     fnic->reset_wait = NULL;
>> +     ret = (fnic->state == FNIC_IN_ETH_MODE) ? SUCCESS : FAILED;
>> +     spin_unlock_irqrestore(&fnic->fnic_lock, flags);
>> +
>> +     /* Now reset local port, this will clean up libFC exchanges,
>> +      * reset remote port sessions, and if link is up, begin flogi
>> +      */
>> +     fc_lport_lock(lp);
>> +     if (lp->tt.lport_reset(lp))
>> +             ret = FAILED;
> 
> 
> The problem here is that this only starts the login. When fnic_reset
> returns for the scsi eh path, scsi-ml is going to send a TUR to make
> sure that we are ready to go. If we are not the devices will be
> offlined. So unless it is a really quick relogin we are going to offline
> the devices by accident.

Well - what should be happening is - prior to the reset or as part of 
it, the fc transport fc_remote_port_delete() call should be made on all 
those remote ports that connectivity is about to be terminated on.  This 
will place all the associated targets/luns on those rports into a 
blocked state, and start the devloss timer on them.  This will suspend 
the eh path as well.  Thus, things suspend until either the driver/fcoe 
stack re-login's and re-calls the transport with the same remote port 
(thus the transport will unblock the targets/luns), or devloss_tmo 
expires, at which time it is correct to report loss of connectivity.

Of course, all this assumes the fc_host stays in existence.

> 
> For fc_fcp.c I added a hokey loop and wait like some other drivers. We
> could instead have libfc notify any waiters of a state change here. We
> could also do a rport blocked timedout helper, convert the fc drivers
> and use it here so we only wait for the login to complete or for the
> port block to fail.

-- james s
