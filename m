From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/7] BNX2I: Optimized the bnx2i_stop connection clean
 up procedure
Date: Wed, 30 Jun 2010 01:11:10 -0500
Message-ID: <4C2ADFFE.2090507@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1277516372-469-4-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54684 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab0F3GIV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2010 02:08:21 -0400
In-Reply-To: <1277516372-469-4-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 06/25/2010 08:39 PM, Eddie Wai wrote:
> For cases where the iSCSI disconnection procedure times out due to
> the iSCSI daemon being slow or unresponsive, the bnx2i_stop routine

Could you describe when iscsid is slow a little more? The unresponsive 
case sounds like if iscsid is not running, right? For the slow case, it 
sounds like you are trying to work around a bug in there.

I am also not sure how it helps exactly. iscsid still has to cleanup the 
iscsi resources like the scsi commands running on the connection (conn 
stop is called after ep disconnect), so I am not sure how this helps. 
Does doing it this way skip some steps?
