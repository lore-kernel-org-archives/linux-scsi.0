From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] improvement of fastfail operation
Date: 30 Mar 2004 20:29:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080696593.2075.120.camel@mulgrave>
References: <1080403035.2078.10.camel@mulgrave>
	<200403291217.AA03115@fukuchi.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:62955 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261168AbUCaBaD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Mar 2004 20:30:03 -0500
In-Reply-To: <200403291217.AA03115@fukuchi.jp.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org
To: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-03-29 at 07:17, Masao Fukuchi wrote:
> By the way, how about item 1.
> I think this is bug and we need to validate fastfail for command timeout.
> If you agree with this, please put it into official patch.
> (See attached patch)

Well, the patch doesn't apply, but I put an equivalent in the tree.

> Next, I tested the fastfail recovery using Kernel 2.6.4.
> But the command didn't complete forever.
> Then I installed following Mike Christie's patch and it worked fine.
>  http://marc.theaimsgroup.com/?l=linux-scsi&m=107904932710899&w=2
> Please put it into official patch.

This patch is obviously wrong on its face.  It completes the request
without regard to any leftovers.

There's clearly a problem somewhere in the completion path for commands
that run out of retries, but whatever it is, this patch only covers it
up it doesn't solve the root problem.

James


