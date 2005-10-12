From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: RE: [patch] fix unnecessary activation of blk tag queue for qla2x00
Date: Wed, 12 Oct 2005 13:55:04 -0700
Message-ID: <200510122055.j9CKtRg28828@unix-os.sc.intel.com>
References: <20051012200016.GA24096@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr24.intel.com ([143.183.121.16]:50051 "EHLO
	scsfmr004.sc.intel.com") by vger.kernel.org with ESMTP
	id S1751569AbVJLU7r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Oct 2005 16:59:47 -0400
In-Reply-To: <20051012200016.GA24096@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Patrick Mansfield' <patmans@us.ibm.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote on Wednesday, October 12, 2005 1:00 PM
> > > It turns out that qla2x00 driver unnecessarily activated
> > > generic blk tag queue without actually use any of the tag
> > > maintained by the block layer.  I suggest we turn that off
> > > until there is a real consumer of the tag queuing in the
> > > qla driver. Please apply.
> > > 
> > > Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>
> > 
> > ACK.
> 
> And then also remove scsi_populate_tag_msg() calls also in qla2xxx,
> as that becomes dead code?

Yeah, that would indeed be a very good thing to do.  It reminds me
a while back, I was investigating cache miss profile and we
consistently see cache misses on tag[2] variable defined in
qla2x00_start_scsi (used by scsi_populate_tag_msg).  Removing it
would be a very good thing for driver performance.

Should I generate the patch?

- Ken

