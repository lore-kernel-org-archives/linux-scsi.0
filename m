From: Oliver Neukum <oliver@neukum.org>
Subject: Re: RES: RES: AS2105-based enclosure size issues with >2TB HDDs
Date: Mon, 25 Aug 2014 23:16:30 +0200
Message-ID: <1409001390.376.6.camel@linux-fkkt.site>
References: <Pine.LNX.4.44L0.1408251613270.1385-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:35567 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370AbaHYVaD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Aug 2014 17:30:03 -0400
In-Reply-To: <Pine.LNX.4.44L0.1408251613270.1385-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alfredo Dal Ava Junior <alfredo.junior@eldorado.org.br>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2014-08-25 at 16:21 -0400, Alan Stern wrote:
> On Mon, 25 Aug 2014, Alfredo Dal Ava Junior wrote:
> 
> > Well, it is causing problems anyway... from user perspective, it's a
> > Linux compatibility issue, as it works "fine" on Windows. I'm not an
> > expert, but I'm wondering that if usb-storage could set capacity as
> > "UNDETERMINED"/ Zero (or keep using the readcapacity_10 as it as
> with
> > some flag signalizing it as inaccurate), EFI partition check would
> be
> > able to ignore size and look for secondary GPT where it really is.
> 
> Part of the problem is that usb-storage has no way to know that
> anything strange is going on.  It's normal for READ CAPACITY(16) to
> fail (this depend on the SCSI level), and it's normal for the READ
> CAPACITY(10) to report a value less than 2 TB.

Just set US_FL_NEEDS_CAP16. If READ CAPACITY(16) fails in that case,
it is clear that something is wrong. It must be set or READ CAPACITY(10)
alone would be taken as giving a valid answer.

At that time we are sure that the drive will be unusable unless we
determine the correct capacity, so we don't make matters worse if we
crash it.

Is there an easy way for Alfredo to determine what happens if we
read beyond the end?

	Regards
		Oliver


