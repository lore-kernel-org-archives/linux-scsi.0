From: Douglas Gilbert <dougg@torque.net>
Subject: Re: "MEDIUM FORMAT CORRUPTED" error
Date: Fri, 08 Jun 2007 10:01:26 +0200
Message-ID: <46690CD6.4020709@torque.net>
References: <11021579.post@talk.nabble.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46178 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968259AbXFHICE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jun 2007 04:02:04 -0400
In-Reply-To: <11021579.post@talk.nabble.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sandip shete <sandipshete@gmail.com>
Cc: linux-scsi@vger.kernel.org

sandip shete wrote:
> Hi,
>   I recieved the following ASC/ASCQ values as Additional Sense data :
> 31/00.
>   I looked it up and found that it stands for "MEDIUM FORMAT CORRUPTED".
> Does it mean that the target disk has bad sectors?

That error may be reported after a disk is reset during a
FORMAT operation. Another related case is a media access
after a MODE SELECT is used to change the sector size (e.g.
from 512 to 528 bytes) and prior to a FORMAT command which
actually reformats the disk to 528 byte sectors.

So if a disk is reporting that ASC/ASCQ sequence for ever
media access, then you need to format it. In that case
sg_format in sg3_utils may be useful.

Doug Gilbert

