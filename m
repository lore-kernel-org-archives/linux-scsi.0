From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Calling sd_shutdown when in state SDEV_DEL
Date: 24 Mar 2004 15:09:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080158975.1783.26.camel@mulgrave>
References: <200403241603.23269.heiko.carstens@de.ibm.com>
	<1080142505.2706.25.camel@mulgrave>
	<20040324170452.GB1679@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:20117 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261154AbUCXUJq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Mar 2004 15:09:46 -0500
In-Reply-To: <20040324170452.GB1679@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-03-24 at 12:04, Mike Anderson wrote:
> Why setting CANCEL on the device? Future plans for the CANCEL state?
> You are setting the state to cancel, but not going through
> scsi_device_cancel as you want IO to still flow.

Mainly because it was there.  Using CANCEL instead of DEL is appealing
since it will still allow special I/O.  Would there be an issue with
refusing new device references in the CANCEL state?

> While this will solve the problem for removing a single device, this
> same error will show up when you remove a host unless you remove all
> devices first through the sysfs interface. Is this ok?

Sigh, that's a symptom of the host not having a state model ... I need
to think about adding that.

James


