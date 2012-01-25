From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCHSET 0/1] osd_uld: Important fix also for 3.2 Stable
Date: Wed, 25 Jan 2012 21:40:31 +0200
Message-ID: <4F205AAF.7000305@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:46252 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab2AYTkt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2012 14:40:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Welch, Brent" <welch@panasas.com>, "Bhamare, Sachin" <sbhamare@panasas.com>, Stable Tree <stable@vger.kernel.org>


There was a mine hiding in the osd_uld driver. It was limited by the number of device minors
it registers at startup which was 64.

The rest of the code is not limited at all and can hold as many devices as permitted
by memory conditions.

The fix is very simple just bump the max number to the maximum minor permitted which
is 2^20.

This is a serious BUG because some of the systems that intend to use the 3.2 Kernel
to deploy pnfs. (Fedora 17 most probably) are bigger then 64 OSDs and will break.

I have tested this on 64bit platform and user-mode works just fine with this.
(Kernel is not an issue). Might there be issues hiding in 32bit ARCHs. From
reading the code I could not find any.

James would you like to take this through your tree for the next rc-fixes round
or give me an ACK-BY: and I'll push it through the osd tree?

The patch:
[PATCH 1/1] osd_uld: Bump MAX_OSD_DEVICES from 64 to 1,048,576

Thanks
Boaz

