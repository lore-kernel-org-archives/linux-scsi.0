From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi_scan.c: bug fix: starget use after free issue
Date: Tue, 27 Jun 2006 10:58:45 -0500
Message-ID: <1151423925.3340.32.camel@mulgrave.il.steeleye.com>
References: <1150390560.29774.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:52165 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161125AbWF0P6t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jun 2006 11:58:49 -0400
In-Reply-To: <1150390560.29774.32.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Thu, 2006-06-15 at 12:55 -0400, James Smart wrote:
> When reaping the starget, after all sdev's have been removed, the starget
> was queued for deletion via usercontext, but was left on the shost's
> __targets list. Another scanning thread can match the starget and use it, 
> causing reference after free problems.
> 
> This patch unlinks the starget at the same time it is scheduled for deletion.
> 
This cannot be done this way.  The problem it will introduce is that
we'll think the target has gone and possibly reallocate its name before
device_del is called on it (which means if the new device gets added, it
will return -EEXIST and everything will go wrong).

Where is the actual reference coming from ... perhaps the using place
should simply be checking the state.

James


