From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] Re: [PATCH 5/7] scsi-hw-handler: convert dm-mpath
 to	scsi hw handlers
Date: Sat, 09 Jun 2007 14:39:41 -0500
Message-ID: <466B01FD.6020400@cs.wisc.edu>
References: <11814160842916-git-send-email-michaelc@cs.wisc.edu>	<11814160853812-git-send-email-michaelc@cs.wisc.edu>	<1181416085774-git-send-email-michaelc@cs.wisc.edu>	<11814160863051-git-send-email-michaelc@cs.wisc.edu>	<11814160871580-git-send-email-michaelc@cs.wisc.edu>	<11814160881707-git-send-email-michaelc@cs.wisc.edu> <466AFD02.30403@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55001 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759070AbXFITj5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Jun 2007 15:39:57 -0400
In-Reply-To: <466AFD02.30403@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair Graeme Kergon <agk@redhat.com>, linux-scsi@vger.kernel.org

Mike Christie wrote:
> michaelc@cs.wisc.edu wrote:
>> From: Mike Christie <michaelc@cs.wisc.edu>
>>
>> This patch converts dm-mpath to scsi hw handlers. It does
>> not add any new functionality and old behaviors and userspace
>> tools should be supported except we use the safe clariion
>> default instead of using the userspace setting.
>>
>> This is just the dm-mpath parts which are necessary to use
>> REQ_TYPE_LINUX_BLOCK and REQ_LB_OP_TRANSITION. In later mails
>> I will send patches which remove old code and add more
>> functionality.
>> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> 
> Alasdair, I took out all the new functionality. This patch is just the
> basic conversion. I can try to break it down even more if and do a patch
> for every hw handler callout that gets removed (all the callouts end up
> getting removed), but that may not buy much since the bulk of the patch
> is the REQ_TYPE_LINUX_BLOCK code.
> 

Just in case, I broke the patch in this mail down here
http://www.cs.wisc.edu/~michaelc/block/dm/mpath/

It basically breaks it up into removing the creation/destruction
callbacks. Then adds the new pg init code. And finally removes the old
pg_init code. Each patch is not compilable by itself so it is not
git-revertable, but maybe it will be easier for you to read.
