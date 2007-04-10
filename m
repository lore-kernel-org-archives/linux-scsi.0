From: Steve Fox <drfickle@linux.vnet.ibm.com>
Subject: Re: 2.6.21-rc6-mm1 aacraid not finding device
Date: Tue, 10 Apr 2007 17:21:01 -0500
Message-ID: <1176243661.5949.59.camel@drfickle.rchland.ibm.com>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:60836 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030401AbXDJWVF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Apr 2007 18:21:05 -0400
In-Reply-To: <20070408143559.f5014629.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mark_salyzyn@adaptec.com, markh@linux-foundation.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Sun, 2007-04-08 at 14:35 -0700, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/

Since 2.6.21-rc5-mm1, one of the test.kernel.org machines (elm3b239) has
not been able to boot because it cannot find the SCSI device. You can
view http://test.kernel.org/abat/82623/debug/console.log for the latest
boot log (rc6-mm1).

I tracked this down to the git-scsi-misc patch in the -mm tree and then
bisected the scsi-misc git tree until I reached the commit below from
Mark Salyzyn:

fe76df4235986cfacc2d3b71cef7c42bc1a6dd6c

[SCSI] aacraid: Fix blocking issue with container probing function (cast update)

This is a pretty big patch, so hopefully Mark can take a look at it.
lspci shows

01:02.0 RAID bus controller: Adaptec AAC-RAID (rev 02)
0f:02.0 SCSI storage controller: Adaptec AIC-9410W SAS (Razor ASIC
non-RAID) (rev 08)
1d:02.0 SCSI storage controller: Adaptec AIC-9410W SAS (Razor ASIC
non-RAID) (rev 08)
2b:02.0 SCSI storage controller: Adaptec AIC-9410W SAS (Razor ASIC
non-RAID) (rev 08)

on 2.6.21-rc6. Let me know if I can provide more details.

-- 

Steve Fox
IBM Linux Technology Center

