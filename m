From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] ibmvscsis: Move to struct ibmvscsis_vdev usage in
	fabric configfs handlers
Date: Tue, 2 Nov 2010 23:21:06 +0900
Message-ID: <20101102231539F.fujita.tomonori@lab.ntt.co.jp>
References: <1288647462.7708.31.camel@haakon2.linux-iscsi.org>
	<20101102070638M.fujita.tomonori@lab.ntt.co.jp>
	<4CD0166C.5060403@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:53137 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab0KBOVk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Nov 2010 10:21:40 -0400
In-Reply-To: <4CD0166C.5060403@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: fujita.tomonori@lab.ntt.co.jp, nab@linux-iscsi.org, linux-scsi@vger.kernel.org, lxie@us.ibm.com, rcjenn@us.ibm.com, michaelc@cs.wisc.edu, James.Bottomley@suse.de, joel.becker@oracle.com

On Tue, 02 Nov 2010 08:47:24 -0500
Brian King <brking@linux.vnet.ibm.com> wrote:

> On 11/01/2010 05:15 PM, FUJITA Tomonori wrote:
> > On Mon, 01 Nov 2010 14:37:42 -0700
> > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > 
> >> On Tue, 2010-11-02 at 06:05 +0900, FUJITA Tomonori wrote:
> >>> On Sat, 30 Oct 2010 16:13:54 -0700
> >>> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> >>>
> >>>> From: Nicholas Bellinger <nab@linux-iscsi.org>
> >>>>
> >>>> This patch takes tomo-san original commit 94fdb0196151 and changes a handful
> >>>> of important items wrt to the fabric configfs logic.
> >>>>
> >>>> Firstly, this patch introduces struct ibmvscsis_vdev and converts the
> >>>> VIO ibmvscsis_probe() and ibmvscsi_remove() callers to allocate/free
> >>>> struct ibmvscsis_vdev instead of the original usage of struct ibmvscsis_tpg
> >>>> which is intended to be allocated/freed respectively in ibmvscsis_make_tpg()
> >>>> and ibmvscsis_drop_tpg() fabric configfs handlers.
> >>>
> >>> What happens if an initiator sends a crq command before an user
> >>> creates a tpg? Or what happens if an initiator sends a crq command
> >>> after removing a tpg?
> >>>
> >>
> >> Hmmm, good point.  So this would require ibmvscsis_queuecommand() to
> >> check internal some ibmvscsi_tpg state to determine availability, and
> >> reject incoming I/O otherwise.  The other operation would be to just
> >> move crq queue creation/release for individual ibmvscsi_vdev into
> >> ibmvscsis_make_tpg() and ibmvscsis_drop_tpg().
> > 
> > You don't need to create/release rcq. I think that enable/disable vio
> > interrupts is enough.
> 
> Maybe I'm not following the conversation here, but if you just disable vio
> interrupts, then any commands sent by a client LPAR would be seen to hang
> from the client's perspective. If ibmvscsis doesn't have the CRQ registered,
> then firmware will fail client commands with a response indicating the server
> is not ready.

Yeah, I told him it makes a client stall. We should register CRQ and
enable vio interrupts in vio_driver->probe.

ibmvscsis driver needs to set up nexuses in vio_driver->probe. The
problem is that it's not fit for TCM model. My initial version does
that in a hacky way though.
