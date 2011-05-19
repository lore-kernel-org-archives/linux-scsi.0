From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: TCM/LIO ib_srpt testing
Date: Wed, 18 May 2011 21:25:06 -0700
Message-ID: <1305779106.2856.540.camel@haakon2.linux-iscsi.org>
References: <BANLkTim5inFCXMwnFz=4CHrAmhXMYyMscw@mail.gmail.com>
	 <1305668263.2856.235.camel@haakon2.linux-iscsi.org>
	 <BANLkTikyHRsskL+4kbiOUwexJg1Medb+hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:47021 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab1ESEdR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2011 00:33:17 -0400
In-Reply-To: <BANLkTikyHRsskL+4kbiOUwexJg1Medb+hw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Vasilis Liaskovitis <vliaskov@gmail.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Wed, 2011-05-18 at 12:19 +0200, Bart Van Assche wrote:
> On Tue, May 17, 2011 at 11:37 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > On Tue, 2011-05-17 at 12:37 +0200, Vasilis Liaskovitis wrote:
> > > In the past, using branch tcm_ib_srpt-38, I have successfully
> > > initialized the srp target and initiator with the "manual steps" in:
> > > http://linux-iscsi.org/wiki/SCSI_RDMA_Protocol#Manual_steps
> > >
> > > However with master, the manual steps fail at:
> > > root@server1:~# mkdir -p /sys/kernel/config/target/srpt/mlx4_0/mlx4_0/lun/lun_0
> > > mkdir: cannot create directory
> > > `/sys/kernel/config/target/srpt/mlx4_0': Invalid argument
> > > Has the recommended ib_srpt initialization procedure changed recently?
> >
> > Yes.  In order for ib_srpt to properly work with rtslib+rtsadmin, the
> > control plane has been changed from Bart's original patch to reference
> > HW IB Port GUID instead of the symbolic /sys/class/infiniband/ name
> 
> Most users expect the original behavior. If you agree I can prepare a
> new patch where the target name format can be selected via a kernel
> module parameter and in which Christoph Hellwig's recent comments are
> addressed too.
> 

Since we don't have any real userspace to break with 
/sys/kernel/config/target/srpt/ at this point, we need to avoid multiple
configfs layouts in mainline without a really solid backwards compatible
reason for needing to do so.

I don't have a strong issue with this myself, and would even be happy to
support it in lio upstream and backports if it's really useful, but I
think for mainline we have to decide on a single configfs layout for
modern v2 userspace.

Thank you for your comments,

--nab


