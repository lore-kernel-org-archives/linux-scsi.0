From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] sg block layer tcqing fix
Date: Tue, 06 Jan 2004 15:06:51 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FFA426B.2030406@torque.net>
References: <3FF08EAF.9080708@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:64781 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S266040AbUAFFLt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jan 2004 00:11:49 -0500
In-Reply-To: <3FF08EAF.9080708@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org

Brian King wrote:
> In bringing up a new LLD driver I am working on, I came across an oops 
> related to sg and using the TCQ function provided by the block layer. 
> The backtrace is shown below. I did some poking around and it looks like 
> when doing SG_IO ioctls to devices running blk tagged command queuing, 
> blk_queue_start_tag gets called, but blk_queue_end_tag never does. 
> Attached is a patch against 2.6.0 which adds the call in sg_cmd_done and 
> gets rid of the oops for me. Please apply.

Brian,
Thanks for this patch. As far as I can tell this patch is needed
for all SCSI char ULDs (in other words: sg, st and osst) when
used with a LLD that uses block layer queueing infrastructure.
At the moment that is only the 53c700 driver (maintained by James B.)
and that one you are working on (I suspect).

Given that no other ULDs call blk_queue_*_tag() routines it seems
a bit strange that sg, st and osst need to call blk_queue_end_tag()
prior to calling scsi_release_request(). Perhaps the cleanup can be
built into scsi_release_request() or a new variant (e.g.
scsi_release_special_request() ) could be introduced.

Doug Gilbert


