From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH-v5 07/13] iscsi-target: Add iSCSI Login Negotiation +
	Parameter logic
Date: Fri, 27 May 2011 04:29:34 +0900
Message-ID: <20110527042934U.fujita.tomonori@lab.ntt.co.jp>
References: <1305862678-30150-8-git-send-email-nab@linux-iscsi.org>
	<1306428415.4048.22.camel@mulgrave.site>
	<1306436832.5807.127.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1306436832.5807.127.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, hare@suse.de, fujita.tomonori@lab.ntt.co.jp, agrover@redhat.com, michaelc@cs.wisc.edu, bharrosh@panasas.com, akpm@linux-foundation.org, martin.svec@zoner.cz
List-Id: linux-scsi@vger.kernel.org

On Thu, 26 May 2011 12:07:12 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> On Thu, 2011-05-26 at 11:46 -0500, James Bottomley wrote:
> > On Thu, 2011-05-19 at 20:37 -0700, Nicholas A. Bellinger wrote:
> > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > > 
> > > This patch adds the princple RFC-3720 compatiable iSCSI Login
> > > phase negotiation for iscsi_target_mod.  This also includes the
> > > target RX/TX thread queue logic which is called directly from iSCSI
> > > login associated code.
> > > 
> > > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org> 
> > 
> > I thought the upshot of the thread with Tomo was that we wouldn't be
> > doing all of this in-kernel.  Where's the userspace upcall for this?
> > 
> 
> The technical reasons why I want to avoid this have not changed for the
> 1) authentication disabled and 2) 'required-to-implement' CHAP
> authentication cases.  These where discussed at the bottom of the thread
> from March with Tomo-san here:
> 
> http://marc.info/?l=linux-scsi&m=130108812405710&w=2
> 
> As mentioned, I am open to adding a userspace upcall for authentication
> payloads post merge in order to support the 'optional-to-implement'
> authentication cases.  However, pushing the above two cases out to

We don't need such, passing payloads from kernel to user space. You do the pre
SCSI nexus operations in user space then kernel takes care of established
nexuses.

> userspace really does add unnecessary complexity and limitiations that I
> want to avoid for the default iSCSI login cases.
> 
> It also would break existing rtslib/rtsadmin-v2 userspace code, and

I don't think breaking the existing code matters.
