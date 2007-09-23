From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 4/5] qla2xxx: add target mode support
Date: Sun, 23 Sep 2007 23:15:16 +0900
Message-ID: <20070923231416K.tomof@acm.org>
References: <200708311703.l7VH3NkK016220@mbox.iij4u.or.jp>
	<20070905150534.GJ17977@plap.qlogic.org>
	<46F3D66A.9010000@qlogic.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:42038 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbXIWOPk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Sep 2007 10:15:40 -0400
In-Reply-To: <46F3D66A.9010000@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: seokmann.ju@qlogic.com
Cc: tomof@acm.org, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, michaelc@cs.wisc.edu, hare@suse.de, fujita.tomonori@lab.ntt.co.jp

On Fri, 21 Sep 2007 07:34:18 -0700
Seokmann Ju <seokmann.ju@qlogic.com> wrote:

> Andrew Vasquez wrote:
> > On Sat, 01 Sep 2007, FUJITA Tomonori wrote:
> > 
> >> This adds target mode support to qla2xxx.
> >>
> >> With set ql2enable_target_mode module parameter to 1, the driver runs
> >> in target mode. By default, ql2enable_target_mode is set to 0, and the
> >> driver should work in initiator mode as before.
> >>
> >> The driver could support dual-mode in the future but it doesn't at the
> >> moment (we need to add dual-mode support tgt first).
> >>
> >> It is based on scst qla2xxx target mode driver. Mike converted the
> >> driver to use tgt long ago. I changed it to use the latest (mainline)
> >> version of qla2xxx driver and tgt, and also converted it to use fc
> >> transport class.
> > 
> > Thanks for doing this.  Some initial comments before a full review is
> > complete, As was seen from the initiator updates needed for 24xx
> > support, there are comparable changes needed in the area of
> > target-mode support for 4gb and 8gb parts.  Also, which ISPs and
> > firmwares were exercised with this code?
> The patch is still under reviewing and will get done, soon.

Great, thinks!


> One quick question on the patch, 
> The tgt core will invoke transfer_response() once it completes the command processing. 
> Could you point out where the actual data transfer is happening if the command required it?
> I guest it should happen in scsi_tgt_kspace_exec(), but not sure where it is happening?

The user-space daemon sends an mapped address then
scsi_tgt_kspace_exec calls blk_rq_map_user against
it. scsi_tgt_cmd_destroy calls blk_rq_unmap_user thats set pages
dirty.
