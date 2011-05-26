From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v5 07/13] iscsi-target: Add iSCSI Login Negotiation +
	Parameter logic
Date: Thu, 26 May 2011 12:49:59 -0700
Message-ID: <1306439399.19113.22.camel@haakon2.linux-iscsi.org>
References: <1305862678-30150-8-git-send-email-nab@linux-iscsi.org>
	 <1306428415.4048.22.camel@mulgrave.site>
	 <1306436832.5807.127.camel@haakon2.linux-iscsi.org>
	 <20110527042934U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51962 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436Ab1EZT7G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 May 2011 15:59:06 -0400
In-Reply-To: <20110527042934U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, hare@suse.de, agrover@redhat.com, michaelc@cs.wisc.edu, bharrosh@panasas.com, akpm@linux-foundation.org, martin.svec@zoner.cz

On Fri, 2011-05-27 at 04:29 +0900, FUJITA Tomonori wrote:
> On Thu, 26 May 2011 12:07:12 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > On Thu, 2011-05-26 at 11:46 -0500, James Bottomley wrote:
> > > On Thu, 2011-05-19 at 20:37 -0700, Nicholas A. Bellinger wrote:
> > > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > > > 
> > > > This patch adds the princple RFC-3720 compatiable iSCSI Login
> > > > phase negotiation for iscsi_target_mod.  This also includes the
> > > > target RX/TX thread queue logic which is called directly from iSCSI
> > > > login associated code.
> > > > 
> > > > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org> 
> > > 
> > > I thought the upshot of the thread with Tomo was that we wouldn't be
> > > doing all of this in-kernel.  Where's the userspace upcall for this?
> > > 
> > 
> > The technical reasons why I want to avoid this have not changed for the
> > 1) authentication disabled and 2) 'required-to-implement' CHAP
> > authentication cases.  These where discussed at the bottom of the thread
> > from March with Tomo-san here:
> > 
> > http://marc.info/?l=linux-scsi&m=130108812405710&w=2
> > 
> > As mentioned, I am open to adding a userspace upcall for authentication
> > payloads post merge in order to support the 'optional-to-implement'
> > authentication cases.  However, pushing the above two cases out to
> 
> We don't need such, passing payloads from kernel to user space. You do the pre
> SCSI nexus operations in user space then kernel takes care of established
> nexuses.
> 

I understand what you have in mind, but I still think this the wrong
approach for the default cases.  For an in-kernel iscsi-target capable
of changing any aspect of the control plane on the fly, this type of
split is problematic to support and maintain and does not actually buy
us anything for the default cases.

> > userspace really does add unnecessary complexity and limitiations that I
> > want to avoid for the default iSCSI login cases.
> > 
> > It also would break existing rtslib/rtsadmin-v2 userspace code, and
> 
> I don't think breaking the existing code matters.

Sure it does.  It means the difference between if the
'required-to-implement' cases can be exposed via configfs to a native
python object library and shell, or if we need to have an external
daemon + configuration that has to be kept in sync between the two,
parse external configuration files, et al.

With the current design, the NodeACLs + authentication are available
directly as part of the rtslib python object library, and python code
including rtslib can reference all aspects of the initiator
configuration directly.  Breaking this up to an external daemon and
configuration is a step backwards for the default cases from the
perspective of rtslib, and making it work with an external
configuration / daemon for the NodeACLs + default authentication case is
an hack compared to how iscsi-target functionality is exposed to
application level progammers via rtslib today.

--nab



