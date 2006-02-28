From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fix scsi process problems and clean up the target reap
	issues
Date: Tue, 28 Feb 2006 13:52:02 -0600
Message-ID: <1141156322.3258.49.camel@mulgrave.il.steeleye.com>
References: <1140726438.2809.18.camel@localhost.localdomain>
	 <20060228172436.GA1456@us.ibm.com>
	 <1141148345.3258.24.camel@mulgrave.il.steeleye.com>
	 <20060228191733.GA4913@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:40150 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932534AbWB1TwF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 14:52:05 -0500
In-Reply-To: <20060228191733.GA4913@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2006-02-28 at 11:17 -0800, Mike Anderson wrote:
> I believe being on the list longer would solve the aic problem, but I have
> not tried to a patch to do this. I am trying to get access to the system now.

Actually, the problem is caused by a misordering of target_alloc,
target_destroy.

The aic target_alloc routine has a BUG_ON() to detect that the target
entry is null (it's nulled in target_destroy).  So, this could be fixed
by moving the target_destroy callback, as well.  I'll take a look at it
and see what springs to mind.  I'm leery of putting the list deletion in
the release, because that could delay new target creation arbitrarily
long ...

James


