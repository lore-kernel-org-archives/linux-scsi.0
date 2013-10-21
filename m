From: vaughan <vaughan.cao@oracle.com>
Subject: Re: PROBLEM: special sense code asc,ascq=04h,0Ch abort scsi scan
 in the middle
Date: Mon, 21 Oct 2013 14:07:06 +0800
Message-ID: <5264C48A.80900@oracle.com>
References: <525AD704.6040705@oracle.com> <525BD1EA.6000701@suse.de> <525BE8C1.5090606@linux.vnet.ibm.com> <525BEF2B.2030907@suse.de> <525BF256.6060707@suse.de> <525C0CAE.3030803@linux.vnet.ibm.com> <525E37CA.2000605@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49775 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3JUGFH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Oct 2013 02:05:07 -0400
In-Reply-To: <525E37CA.2000605@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 10/16/2013 02:52 PM, Hannes Reinecke wrote:
> But seeing that this approach raises quite some issues I've attached a
> different patch. Vaughan, could you test with that, too? Should be
> functionally equivalent to the previous one. Cheers, Hannes 
Hi Hannes,

We only tested the later patch which returns _TARGET_PRESENT after
parsing sense, it works as expected.

About the cause of this issue, admin said he is configuring a
active-active cluster mode storage. Each node has it own LUN pool and a
set of rule to control which node can access the pool.
LUN7 is owned and can only be able to manipulated by the other node, but
can be seen by this node for a misconfig. So it presents itself in
REPORT_LUN but return NOT_READY when accessed through this node.
Do you still regard this as a misbehave in response to INQUIRY?

Thanks,
Vaughan
