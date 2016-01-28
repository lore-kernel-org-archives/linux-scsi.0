From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 11/12] xen-scsiback: Convert to percpu_ida tag
 allocation
Date: Wed, 27 Jan 2016 21:13:29 -0800
Message-ID: <1453958009.6746.197.camel@haakon3.risingtidesystems.com>
References: <1453709466-6308-1-git-send-email-nab@daterainc.com>
	 <1453709466-6308-12-git-send-email-nab@daterainc.com>
	 <56A7401E.7070005@suse.com>
	 <1453876090.6746.123.camel@haakon3.risingtidesystems.com>
	 <56A8A2A3.30407@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35351 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbcA1FNb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 00:13:31 -0500
In-Reply-To: <56A8A2A3.30407@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Juergen Gross <jgross@suse.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, David Vrabel <david.vrabel@citrix.com>

On Wed, 2016-01-27 at 11:57 +0100, Juergen Gross wrote:
> On 27/01/16 07:28, Nicholas A. Bellinger wrote:
> > On Tue, 2016-01-26 at 10:45 +0100, Juergen Gross wrote:
> >> On 25/01/16 09:11, Nicholas A. Bellinger wrote:
> >>> From: Nicholas Bellinger <nab@linux-iscsi.org>
> >>>
> >>> Cc: Juergen Gross <jgross@suse.com>
> >>> Cc: Hannes Reinecke <hare@suse.de>
> >>> Cc: David Vrabel <david.vrabel@citrix.com>
> >>> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> >>> ---
> >>>  drivers/xen/xen-scsiback.c | 163 ++++++++++++++++++++++++---------------------
> >>>  1 file changed, 87 insertions(+), 76 deletions(-)
> >>>
> >>> diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
> >>> index 594f8a7..640fb22 100644
> >>> --- a/drivers/xen/xen-scsiback.c
> >>> +++ b/drivers/xen/xen-scsiback.c
> >>> @@ -190,7 +190,6 @@ module_param_named(max_buffer_pages, scsiback_max_buffer_pages, int, 0644);
> >>>  MODULE_PARM_DESC(max_buffer_pages,
> >>>  "Maximum number of free pages to keep in backend buffer");
> >>>  
> >>> -static struct kmem_cache *scsiback_cachep;
> >>>  static DEFINE_SPINLOCK(free_pages_lock);
> >>>  static int free_pages_num;
> >>>  static LIST_HEAD(scsiback_free_pages);
> >>> @@ -322,7 +321,8 @@ static void scsiback_free_translation_entry(struct kref *kref)
> >>>  }
> >>>  
> >>>  static void scsiback_do_resp_with_sense(char *sense_buffer, int32_t result,
> >>> -			uint32_t resid, struct vscsibk_pend *pending_req)
> >>> +			uint32_t resid, struct vscsibk_pend *pending_req,
> >>> +			uint16_t rqid)
> >>>  {
> >>>  	struct vscsiif_response *ring_res;
> >>>  	struct vscsibk_info *info = pending_req->info;
> >>
> >> pending_req might be NULL now, so this will panic the system.
> >>
> > 
> > Thanks for the review.
> > 
> > Added the following to propagate up original *info into
> > scsiback_do_resp_with_sense() to address the early pending_req
> > failure case.
> > 
> > https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?h=queue-next&id=5873f22a9b7c7aa16ff9a85074a07b739f1d06a5
> 
> Hmm, wouldn't it make more sense to split scsiback_do_resp_with_sense()
> into two functions now? Something like:
> 

<SNIP>

> And then call scsiback_send_response() directly in case pending_req
> is NULL.
> 

That makes alot more sense.

Just updated the series in queue-next, and folded your change into the
original patch.

Thanks Juergen.

