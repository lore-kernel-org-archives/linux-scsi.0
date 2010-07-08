From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/7 v2] BNX2I: Patch set to fix various disconnect conditions
Date: Wed, 07 Jul 2010 19:49:41 -0500
Message-ID: <4C3520A5.2080301@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1278023696-17817-1-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49300 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab0GHAqg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jul 2010 20:46:36 -0400
In-Reply-To: <1278023696-17817-1-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 07/01/2010 05:34 PM, Eddie Wai wrote:
> Hello,
>
> This patch set contains various code fixes and optimization which mostly
> deals with disconnect and clean up issues.
>
> The following is a list of changes for v2:
> 1)  Extended the disconnect timeout from 10s to 20s as the 10g firmware
> has a FIN retransmission timeout of 16s.  This fixes one of the
> iscsi_endpoint leak issues when the target is slow or non-responsive to
> our TCP FIN sent.
>
> 2)  Removed the unnecessary read lock in the bnx2i_stop.
>
> 3)  Optimized various code paths based on Mike Christie's comments.
>
> Your comments are greatly appreciated.  Please review, thanks.
>
> Eddie
>
> Eddie Wai (7):
>    BNX2I: Separated the hardware's cleanup procedure from ep_disconnect
>    BNX2I: Created an active linklist which holds bnx2i endpoints
>    BNX2I: Optimized the bnx2i_stop connection clean up procedure
>    BNX2I: Fine tuned conn destroy and context destroy timeout values
>    BNX2I: Fixed the TCP graceful termination initiation
>    BNX2I: Added host param ISCSI_HOST_PARAM_IPADDRESS
>    BNX2I: Updated version from 2.1.1 to 2.1.2
>
>   drivers/scsi/bnx2i/bnx2i.h       |   14 +++
>   drivers/scsi/bnx2i/bnx2i_hwi.c   |    4 +
>   drivers/scsi/bnx2i/bnx2i_init.c  |   39 ++++++-
>   drivers/scsi/bnx2i/bnx2i_iscsi.c |  229 +++++++++++++++++++++++++++++---------
>   4 files changed, 226 insertions(+), 60 deletions(-)
>
>

Thanks for the update. Updated patches look ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
