From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] scsi_transport_fc: FC pass through support -
 revised II
Date: Fri, 31 Oct 2008 10:57:36 +0900
Message-ID: <20081031105633W.fujita.tomonori@lab.ntt.co.jp>
References: <20081030131825M.fujita.tomonori@lab.ntt.co.jp>
	<BDE35A87-59AD-4116-9DB8-F1DFAD40177A@qlogic.com>
	<8F8E62D4-233D-4347-ACAE-2018C6ADDA00@qlogic.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:36604 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbYJaB6D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2008 21:58:03 -0400
In-Reply-To: <8F8E62D4-233D-4347-ACAE-2018C6ADDA00@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: seokmann.ju@qlogic.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Smart@Emulex.Com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, bharrosh@panasas.com, michaelc@cs.wisc.edu, robert.w.love@intel.com

On Thu, 30 Oct 2008 18:38:04 -0700
Seokmann Ju <seokmann.ju@qlogic.com> wrote:

> 
> On Oct 30, 2008, at 6:37 AM, Seokmann Ju wrote:
> 
> >
> > On Oct 29, 2008, at 9:18 PM, FUJITA Tomonori wrote:
> [snip]
> >
> >
> >>> +	    GFP_KERNEL);
> >>> +	sg_init_table(service->payload_dma, req->nr_phys_segments);
> >>> +	service->payload_sg_cnt =
> >>> +	    blk_rq_map_sg(q, req, service->payload_dma);
> >>> +	service->payload = (void *) bio_data(req->bio);
> >>
> >> You don't need service->payload. We use scatterlist for data  
> >> transfer.
> > Yes. Removed.
> I need a step back here.
> I understand that modules get involved in handling pass through are  
> treat
> FC service requests as opaque data.
> However, there are some case where LLDs need to retrieve the contents of
> the service request and pull out some information - for example, opcode
> of the ELS for the case of qla2xxx.
> I guess there might be some other LLDs that need to pull out some
> information from the service request for similar reasons.
> For that purpose, I think it would be good to keep 'payload' and  
> 'response'
> field instead.
> Any comment?

Simply, you can't access to the data via bio_data(). You must access
to the scatter gather in a proper way.

For example, try to do the following way to allocate a request buffer
in user space:

struct sg_io_v4 sg_io;
char *p = valloc(8192);
struct fc_els_frame *els = (struct fc_els_frame *)(p + 4086);

sg_io.dout_xferp = (__u64) &els;


fc_els_frame crosses two page frames. bio_data() can't handle it.


If a driver wants the payload in a linear buffer, sg_copy_to_buffer()
is helpful.


