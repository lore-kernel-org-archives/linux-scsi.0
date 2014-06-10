From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 0/6] vhost/scsi: Add T10 PI SGL passthrough support
Date: Tue, 10 Jun 2014 00:05:12 -0700
Message-ID: <1402383912.5774.13.camel@haakon3.risingtidesystems.com>
References: <1400725582-5521-1-git-send-email-nab@daterainc.com>
	 <20140609133026.GA6239@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49089 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933097AbaFJHFV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2014 03:05:21 -0400
In-Reply-To: <20140609133026.GA6239@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Stephen Rothwell <sfr@canb.auug.org.au>

On Mon, 2014-06-09 at 16:30 +0300, Michael S. Tsirkin wrote:
> On Thu, May 22, 2014 at 02:26:16AM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Hi MST, MKP, Paolo & Co,
> > 
> > Here is the v2 patch series for adding T1O protection information (PI)
> > SGL passthrough support between virtio-scsi LLD + vhost-scsi fabric
> > endpoints.
> > 
> > Following MST's recommendation, it includes the changes for using
> > bytes intead of number of iovecs in virtio_scsi_cmd_req_pi along with
> > the associated changes to virtio-scsi + vhost/scsi code.
> > 
> > For vhost/scsi, this includes walking the leading iovec's length(s)
> > to determine where protection payload ends, and real data payload 
> > starts.  For virtio-scsi LLD code, this includes locating struct
> > blk_integrity for using blk_rq_sectors + ->tuple_size to calculate
> > the total bytes for outgoing cmd_pi->pi_bytes[out,in] values.
> > 
> > The full list of changes from last series include:
> > 
> >   - Use pi_bytesout + pi_bytesin instead of niovs in virtio-scsi PI
> >     header (mst + paolo)
> >   - Add prot_pto=1 in tcm_vhost_submission_work() when no PI buffer
> >     exists (nab)
> >   - Get rid of req + cdb pointer casts in vhost_scsi_handle_vq (mst)
> >   - Ensure that virtio_scsi_cmd_req_pi processing happens regardless
> >     of data_num in vhost_scsi_handle_vq (nab)
> >   - Pass TARGET_PROT_ALL into transport_init_session_tags() (nab)
> >   - Convert vhost_scsi_handle_vq to use memcpy_fromiovecend() (mst)
> >   - Convert vhost_scsi_handle_vq to use pi_bytesout + pi_bytesin (nab)
> >   - Convert virtio_scsi_init_hdr_pi() to use pi_bytesout + pi_bytesin
> >     (mst + paolo + nab)
> >   - Use blk_integrity->tuple_size to calculate pi bytes (nab)
> > 
> > Please review for v3.16-rc1 code.
> > 
> > Thanks!
> > 
> > --nab
> 
> OK since this conflicts with my vhost locking
> patches, I have rebased this and parked at vhost-review
> branch in my tree.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-review
> 
> Nicholas could you please take a look at the patches and confirm this is
> OK ASAP?
> 
> If yes I will pack it all up and send to Linus.

>From my experience, Linus prefers to fix this type of conflict on his
own at merge time, instead of having subsystem maintainers rebase their
for-next branches to include other's commits.

Stephen (CC'ed) has included a fix in today's linux-next for the merge
conflict here:

https://lkml.org/lkml/2014/6/10/3

Please confirm, as it will be a pointer to Linus within the
target-pending/for-next PULL request.

--nab

