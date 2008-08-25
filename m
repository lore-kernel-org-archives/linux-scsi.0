From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC][PATCH 2/6] fnic: add fnic_scsi.c and fnic_io.h.
Date: Mon, 25 Aug 2008 14:38:21 -0500
Message-ID: <48B30A2D.6070501@cs.wisc.edu>
References: <20080823024949.13569.94133.stgit@feynman.nuovasystems.com> <20080823025222.13569.37765.stgit@feynman.nuovasystems.com> <48B2FCD0.5050504@cs.wisc.edu> <48B30544.2020106@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41662 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001AbYHYTia (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 15:38:30 -0400
In-Reply-To: <48B30544.2020106@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "jeykholt@cisco.com" <jeykholt@cisco.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jre@nuovasystems.com" <jre@nuovasystems.com>, "ajoglekar@nuovasystems.com" <ajoglekar@nuovasystems.com>

James Smart wrote:
> 
> 
> Mike Christie wrote:
>> jeykholt@cisco.com wrote:
>>> + * fnic_queuecommand
>>> + * Routine to send a scsi cdb
>>> + * Called with host_lock held and interrupts disabled.
>>> + */
>>> +int fnic_queuecommand(struct scsi_cmnd *sc, void (*done)(struct 
>>> scsi_cmnd *))
>>> +{
>>> +     struct fc_lport *lp;
>>> +     struct fc_rport *rport;
>>> +     struct fnic_io_req *io_req;
>>> +     struct fnic *fnic;
>>> +     struct vnic_wq_copy *wq;
>>> +     int ret;
>>> +     u32 sg_count;
>>> +     unsigned long flags;
>>> +
>>> +     rport = starget_to_rport(scsi_target(sc->device));
>>> +     ret = fc_remote_port_chkready(rport);
>>> +     if (ret) {
>>> +             sc->result = ret;
>>> +             done(sc);
>>> +             return 0;
>>> +     }
>>> +
>>> +     lp = shost_priv(sc->device->host);
>>> +     if (lp->state != LPORT_ST_READY || !(lp->link_status & 
>>> FC_LINK_UP)) {
>>> +             sc->result = DID_NO_CONNECT << 16;
>>
>> You should use SCSI_MLQUEUE_HOST_BUSY here, becuase we set the link
>> status/state and then will block rports, if a io has passed the rport
>> check then sees the updated state we will fail it when it should be
>> requeued until the fc class decides what to do.
> 
> Are you sure ?  I would assume that if you passed the chkready() test, 

Yes. See fc_linkdown. It sets the status and state then blocks rports. 
Or actually it should be deleting/blocking rports but from that thread 
on fcoe-devel that you were on you know that that code is not completely 
right and is getting fixed.

> but still don't have connectivity to the device, you should be failing 
> it with a DID_NO_CONNECT.  The chkready(), paired with the 
> fc_remote_port_delete()/blocked luns, should cover the temporary losses 
> of connectivity.
> 

The check above I am commenting on is like lpfc's

         if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
                 cmnd->result = ScsiResult(DID_BUS_BUSY, 0);
                 goto out_fail_command;
         }

or qla2xxxx's

         if (atomic_read(&fcport->state) != FCS_ONLINE) {
                 if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
                     atomic_read(&ha->loop_state) == LOOP_DEAD) {
                         cmd->result = DID_NO_CONNECT << 16;
                         goto qc_fail_command;
                 }
                 goto qc_host_busy;
         }

where we are in the middle of transistioning. The driver/lib has set 
some internal state, and is in the middle of calling the rport delete 
function.
