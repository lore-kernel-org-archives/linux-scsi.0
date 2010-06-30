From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: Re: [PATCH 3/7] BNX2I: Optimized the bnx2i_stop connection
 clean up procedure
Date: Tue, 29 Jun 2010 23:56:12 -0700
Message-ID: <1277880974.6535.333.camel@ltirv-waie-lx1>
References: <Eddie Wai <eddie.wai@broadcom.com>
 <1277516372-469-4-git-send-email-eddie.wai@broadcom.com>
 <4C2ADFFE.2090507@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3319 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab0F3GzI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2010 02:55:08 -0400
In-Reply-To: <4C2ADFFE.2090507@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eddie Wai <waie@broadcom.com>, James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Benjamin Li <benli@broadcom.com>

Our test group has generated a case where a MTU change or an ifdown was
performed while having active sessions outstanding.  While the
disconnection effort works normally, but for the case where iscsid is
forced to stop, our driver was previously designed to dead wait for 240s
before resuming operation.  Once the wait is over, any leftover chip
resources allocated + previously active iscsi_endpoints would be
forfeited.  For this kind of destructive testing, we decided that it is
best to clean up our chip so that other operations such as L2 or FCoE
would not get affected.  

The 'slow' case mentioned is just a hypothetical case which we have not
encountered first hand.  But the code has been worked so that if iscsid
were to come back up and continue to call ep_disconnect again, only the
endpoints would get cleanup and will no longer attempt to clean up the
hardware.  We're not trying to work around a bug here...

For the case presented, bnx2i_stop was actually called from cnic's
ulp_stop due to the different test case described.  The hard 240s
timeout was there to wait for iscsid to cleanup all the active
connections.  If it were to be exceeded somehow, the same lost resource
+ endpoint condition would happen.

Eddie

On Tue, 2010-06-29 at 23:11 -0700, Mike Christie wrote:
> On 06/25/2010 08:39 PM, Eddie Wai wrote:
> > For cases where the iSCSI disconnection procedure times out due to
> > the iSCSI daemon being slow or unresponsive, the bnx2i_stop routine
> 
> Could you describe when iscsid is slow a little more? The unresponsive 
> case sounds like if iscsid is not running, right? For the slow case, it 
> sounds like you are trying to work around a bug in there.
> 
> I am also not sure how it helps exactly. iscsid still has to cleanup the 
> iscsi resources like the scsi commands running on the connection (conn 
> stop is called after ep disconnect), so I am not sure how this helps. 
> Does doing it this way skip some steps?
> 


