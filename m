From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Calling sd_shutdown when in state SDEV_DEL
Date: Wed, 24 Mar 2004 09:04:52 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040324170452.GB1679@beaverton.ibm.com>
References: <200403241603.23269.heiko.carstens@de.ibm.com> <1080142505.2706.25.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:10426 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S263775AbUCXRF1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Mar 2004 12:05:27 -0500
Content-Disposition: inline
In-Reply-To: <1080142505.2706.25.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> How about the attached instead.  That forces every deleted device to go
> through CANCEL (uncompiled, but you can test it...)
> 

Why setting CANCEL on the device? Future plans for the CANCEL state?
You are setting the state to cancel, but not going through
scsi_device_cancel as you want IO to still flow.

While this will solve the problem for removing a single device, this
same error will show up when you remove a host unless you remove all
devices first through the sysfs interface. Is this ok?

-andmike
--
Michael Anderson
andmike@us.ibm.com

