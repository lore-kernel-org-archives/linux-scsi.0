From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi_host sysfs updates scsi-misc-2.5 [0/2]
Date: 12 May 2003 12:50:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1052761851.2093.55.camel@mulgrave>
References: <20030509063321.GA3259@beaverton.ibm.com>
	<1052711864.1768.7.camel@mulgrave>
	<20030512063833.GA4133@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:13062 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262400AbTELRiM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2003 13:38:12 -0400
In-Reply-To: <20030512063833.GA4133@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-05-12 at 01:38, Mike Anderson wrote:
> Can you run this on your system and see if it addresses your issue? If
> not I can hack scsi_debug to make back to back scsi_register /
> scsi_unregister calls.

Surprisingly, it still fails.  I've debugged the refcounting and I see
it fall to zero in scsi_host_put but the dev release method doesn't
trigger for no reason I can see.

It's probably a kobject initialisation problem somewhere.

Also, eventually, don't we need to do class_device_remove_files() on the
created class files, so that will have to be done in release and we've
got symmetry problems again?

James


