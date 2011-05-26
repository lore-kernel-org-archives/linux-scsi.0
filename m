From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v5 07/13] iscsi-target: Add iSCSI Login Negotiation +
	Parameter logic
Date: Thu, 26 May 2011 12:07:12 -0700
Message-ID: <1306436832.5807.127.camel@haakon2.linux-iscsi.org>
References: <1305862678-30150-1-git-send-email-nab@linux-iscsi.org>
	 <1305862678-30150-8-git-send-email-nab@linux-iscsi.org>
	 <1306428415.4048.22.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56535 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758358Ab1EZTPa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 May 2011 15:15:30 -0400
In-Reply-To: <1306428415.4048.22.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Martin Svec <martin.svec@zoner.cz>

On Thu, 2011-05-26 at 11:46 -0500, James Bottomley wrote:
> On Thu, 2011-05-19 at 20:37 -0700, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch adds the princple RFC-3720 compatiable iSCSI Login
> > phase negotiation for iscsi_target_mod.  This also includes the
> > target RX/TX thread queue logic which is called directly from iSCSI
> > login associated code.
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org> 
> 
> I thought the upshot of the thread with Tomo was that we wouldn't be
> doing all of this in-kernel.  Where's the userspace upcall for this?
> 

The technical reasons why I want to avoid this have not changed for the
1) authentication disabled and 2) 'required-to-implement' CHAP
authentication cases.  These where discussed at the bottom of the thread
from March with Tomo-san here:

http://marc.info/?l=linux-scsi&m=130108812405710&w=2

As mentioned, I am open to adding a userspace upcall for authentication
payloads post merge in order to support the 'optional-to-implement'
authentication cases.  However, pushing the above two cases out to
userspace really does add unnecessary complexity and limitiations that I
want to avoid for the default iSCSI login cases.

It also would break existing rtslib/rtsadmin-v2 userspace code, and
require a userspace daemon be aware of the necessary initiator NodeACL
information and keep the current configuration state in sync between
kernel + userspace.  The current code avoids this type of mess all
together for the default cases, and I still only see downsides and
endless maintainability headaches and delays for going back to this type
of design for a kernel-level iscsi-target.

--nab


