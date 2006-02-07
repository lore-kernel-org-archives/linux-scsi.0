From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [SCSI] fix wrong context bugs in SCSI
Date: Tue, 07 Feb 2006 17:26:46 -0600
Message-ID: <1139354806.6065.14.camel@mulgrave.il.steeleye.com>
References: <1139342419.6065.8.camel@mulgrave.il.steeleye.com>
	 <1139342922.6065.12.camel@mulgrave.il.steeleye.com>
	 <43E91998.2070204@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:49592 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030262AbWBGX0u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 18:26:50 -0500
In-Reply-To: <43E91998.2070204@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Tue, 2006-02-07 at 16:05 -0600, Brian King wrote:
> I just tried this out on my ppc64 box. I recently noticed that
> the target reaping via workqueue change that went in not too long ago
> resulted in *really* slow user initiated wildcard scans for ipr
> adapters - in the neighborhood of 6 minutes... Your patch brings
> that back down to 8 seconds.

Yes, that's because the original fix used a workqueue for everything
(whether it needed it or not).  The new API checks the context first
before invoking a workqueue.  By and large, for SCSI, we actually have
user context most of the time, so the old fix was rather heavy handed.

James


