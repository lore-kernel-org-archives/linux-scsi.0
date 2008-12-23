From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 12207] block reads/writes > 122880 bytes to USB tape
	drive gives EBUSY
Date: Tue, 23 Dec 2008 08:55:24 -0600
Message-ID: <1230044124.3461.1.camel@localhost.localdomain>
References: <20081223135938.30266108042@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33451 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183AbYLWOz2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Dec 2008 09:55:28 -0500
In-Reply-To: <20081223135938.30266108042@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

> ------- Comment #6 from stern@rowland.harvard.edu  2008-12-23 05:59 -------
> You can change the max_sectors setting through sysfs.  However the last time I
> looked, the block layer limited max_sectors to 512 KB or something on that
> order, so you can't get too much improvement.
> 
> Why is a limit of 120 KB unreasonably small?  All it means is that you have to
> use more system calls to transfer the same amount of data.  Is anything wrong
> with that?

Tapes need large block sizes.

We can accommodate both:  Just check for TYPE_TAPE in the
slave_configure() and bump the limit back up.  Any USB tape that doesn't
do large block transfers will be truly broken.

James


