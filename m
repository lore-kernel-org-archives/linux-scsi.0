From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/7] scsi: Fix transfer length 0 for 6-byte r/w commands
Date: Sat, 16 May 2015 09:46:10 -0700
Message-ID: <1431794770.2181.7.camel@HansenPartnership.com>
References: <1431760673-7180-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53775 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992AbbEPQqO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 May 2015 12:46:14 -0400
In-Reply-To: <1431760673-7180-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Don Brace <don.brace@pmcs.com>, iss_storagedev@hp.com, storagedev@pmcs.com, Adam Radford <linuxraid@lsi.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, megaraidlinux.pdl@avagotech.com

On Sat, 2015-05-16 at 16:17 +0900, Akinobu Mita wrote:
> For 6-byte r/w commands, transfer length 0 means 256 blocks of data,
> not 0 block.
> 
> But some drivers consider transfer length 0 as 0 block.
> Fortunately, the scsi disk driver sets up 10-byte r/w commands for
> 256 blocks of data instead of 6-byte r/w commands.  So this could be
> an issue when SCSI commands are issued by SG_IO ioctl.

6-byte commands are obsolete, so there's not a lot of point in doing
this; however, in the early days of SCSI, there was considerable
confusion about what 0 transfer length meant (I think it wasn't until
SCSI-2 that it was clarified).  Even today, USB drive manufacturers have
considerable difficulty with it, that's why the sd driver avoids it, as
would any sensible program doing sg_io.

James


