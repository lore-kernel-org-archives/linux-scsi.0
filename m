From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] tmscsim: improve tagging
Date: 19 Oct 2004 09:01:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098194521.2068.6.camel@mulgrave>
References: <Pine.LNX.4.60.0410190011090.6761@poirot.grange>
	<20041019131051.GN16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:8648 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269416AbUJSOC0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Oct 2004 10:02:26 -0400
In-Reply-To: <20041019131051.GN16153@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-10-19 at 08:10, Matthew Wilcox wrote:
> Isn't cmd_per_lun set to only use one tag with this patch?

No, it's the depth associated with untagged devices.  Arguably it should
always be 2 so that there's always one command executing and one fully
prepped and waiting to roll, but the driver must know to reject the
second command with SCSI_MLQUEUE_DEVICE_BUSY to get it to requeue fully
prepared.

James


