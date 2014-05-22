From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 1/6] virtio-scsi.h: Add virtio_scsi_cmd_req_pi +
 VIRTIO_SCSI_F_T10_PI bits
Date: Thu, 22 May 2014 13:38:17 -0700
Message-ID: <1400791097.26558.1.camel@haakon3.risingtidesystems.com>
References: <1400725582-5521-1-git-send-email-nab@daterainc.com>
	 <1400725582-5521-2-git-send-email-nab@daterainc.com>
	 <20140522065716.GB29474@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36467 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaEVUi3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2014 16:38:29 -0400
In-Reply-To: <20140522065716.GB29474@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Rusty Russell <rusty@rustcorp.com.au>

On Thu, 2014-05-22 at 09:57 +0300, Michael S. Tsirkin wrote:
> On Thu, May 22, 2014 at 02:26:17AM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch adds a virtio_scsi_cmd_req_pi header as recommened by
> > Paolo that contains do_pi_niov + di_pi_niov elements used for
> > signaling when protection information buffers are expected to
> > preceed the data buffers.
> 
> Cc rusty.
> Rusty could you please Ack merging this through Nicholas' tree
> together with the vhost changes?
> 
> 
> > Also add new VIRTIO_SCSI_F_T10_PI feature bit to be used to signal
> > host support.
> > 
> > v4 changes:
> 
> v2? Proably best to drop versioning info from commit log,
> move it out to notes (after ---)

Dropped

> 
> >    - Use pi_bytesout + pi_bytesin instead of niovs (mst + paolo)
> 
> Right, so maybe update the commit log above to match?
> It gave me pause.

Fixed

> 
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Martin K. Petersen <martin.petersen@oracle.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >  include/linux/virtio_scsi.h |   15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/virtio_scsi.h b/include/linux/virtio_scsi.h
> > index 4195b97..7344906 100644
> > --- a/include/linux/virtio_scsi.h
> > +++ b/include/linux/virtio_scsi.h
> > @@ -35,11 +35,23 @@ struct virtio_scsi_cmd_req {
> >  	u8 lun[8];		/* Logical Unit Number */
> >  	u64 tag;		/* Command identifier */
> >  	u8 task_attr;		/* Task attribute */
> > -	u8 prio;
> > +	u8 prio;		/* SAM command priority field */
> >  	u8 crn;
> >  	u8 cdb[VIRTIO_SCSI_CDB_SIZE];
> >  } __packed;
> >  
> > +/* SCSI command request, followed by protection information */
> > +struct virtio_scsi_cmd_req_pi {
> > +	u8 lun[8];		/* Logical Unit Number */
> > +	u64 tag;		/* Command identifier */
> > +	u8 task_attr;		/* Task attribute */
> > +	u8 prio;		/* SAM command priority field */
> > +	u8 crn;
> > +	u32 pi_bytesout;	/* DataOUT PI Number of bytes */
> > +	u32 pi_bytesin;		/* DataIN PI Number of bytes */
> > +	u8 cdb[VIRTIO_SCSI_CDB_SIZE];
> > +} __packed;
> > +
> >  /* Response, followed by sense data and data-in */
> >  struct virtio_scsi_cmd_resp {
> >  	u32 sense_len;		/* Sense data length */
> > @@ -97,6 +109,7 @@ struct virtio_scsi_config {
> >  #define VIRTIO_SCSI_F_INOUT                    0
> >  #define VIRTIO_SCSI_F_HOTPLUG                  1
> >  #define VIRTIO_SCSI_F_CHANGE                   2
> > +#define VIRTIO_SCSI_F_T10_PI		       3
> 
> Could you pad this with spaces and not tabs so it aligns nicely
> with stuff above it?

Fixed

