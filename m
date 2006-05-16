From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 11:29:58 -0500
Message-ID: <1147796999.3505.42.camel@mulgrave.il.steeleye.com>
References: <4468B596.9090508@garzik.org>
	 <1147789098.3505.19.camel@mulgrave.il.steeleye.com>
	 <4469F2B2.703@garzik.org>
	 <1147794708.3505.30.camel@mulgrave.il.steeleye.com>
	 <4469F906.7040602@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:23247 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751863AbWEPQb6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 12:31:58 -0400
In-Reply-To: <4469F906.7040602@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

On Wed, 2006-05-17 at 01:08 +0900, Tejun Heo wrote:
> It's handled the same way shost->host_failed is handled.
> scsi_device_unbusy() wakes it up when the condition is met.

That's the piece I hadn't spotted, yet ... thanks.  That will do it.

could you move ata_schedule_scsi_eh to scsi_error (with the appropriate
API rename).  That way the SCSI state model changes aren't in libata
(and no-one else who wants to use this has to open code the
ata_schedule_scsi_eh API).

James


