From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC][PATCH 2/6] fnic: add fnic_scsi.c and fnic_io.h.
Date: Mon, 25 Aug 2008 15:17:24 -0400
Message-ID: <48B30544.2020106@emulex.com>
References: <20080823024949.13569.94133.stgit@feynman.nuovasystems.com> <20080823025222.13569.37765.stgit@feynman.nuovasystems.com> <48B2FCD0.5050504@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:37850 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbYHYTRu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Aug 2008 15:17:50 -0400
In-Reply-To: <48B2FCD0.5050504@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "jeykholt@cisco.com" <jeykholt@cisco.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jre@nuovasystems.com" <jre@nuovasystems.com>, "ajoglekar@nuovasystems.com" <ajoglekar@nuovasystems.com>



Mike Christie wrote:
> jeykholt@cisco.com wrote:
>> + * fnic_queuecommand
>> + * Routine to send a scsi cdb
>> + * Called with host_lock held and interrupts disabled.
>> + */
>> +int fnic_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
>> +{
>> +     struct fc_lport *lp;
>> +     struct fc_rport *rport;
>> +     struct fnic_io_req *io_req;
>> +     struct fnic *fnic;
>> +     struct vnic_wq_copy *wq;
>> +     int ret;
>> +     u32 sg_count;
>> +     unsigned long flags;
>> +
>> +     rport = starget_to_rport(scsi_target(sc->device));
>> +     ret = fc_remote_port_chkready(rport);
>> +     if (ret) {
>> +             sc->result = ret;
>> +             done(sc);
>> +             return 0;
>> +     }
>> +
>> +     lp = shost_priv(sc->device->host);
>> +     if (lp->state != LPORT_ST_READY || !(lp->link_status & FC_LINK_UP)) {
>> +             sc->result = DID_NO_CONNECT << 16;
> 
> You should use SCSI_MLQUEUE_HOST_BUSY here, becuase we set the link
> status/state and then will block rports, if a io has passed the rport
> check then sees the updated state we will fail it when it should be
> requeued until the fc class decides what to do.

Are you sure ?  I would assume that if you passed the chkready() test, 
but still don't have connectivity to the device, you should be failing 
it with a DID_NO_CONNECT.  The chkready(), paired with the 
fc_remote_port_delete()/blocked luns, should cover the temporary losses 
of connectivity.

-- james s
