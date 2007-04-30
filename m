From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SAVE_DATA / RESTORE_POINTERS message confusion
Date: Mon, 30 Apr 2007 14:00:48 -0500
Message-ID: <1177959648.3674.57.camel@mulgrave.il.steeleye.com>
References: <20070429.143759.71876461.davem@davemloft.net>
	 <Pine.LNX.4.60.0704301947570.15250@poirot.grange>
	 <1177957447.3674.51.camel@mulgrave.il.steeleye.com>
	 <20070430.114637.41634896.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:35635 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946639AbXD3TAx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Apr 2007 15:00:53 -0400
In-Reply-To: <20070430.114637.41634896.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: g.liakhovetski@gmx.de, linux-scsi@vger.kernel.org

On Mon, 2007-04-30 at 11:46 -0700, David Miller wrote:
> The new ESP driver in esp_scsi.c is a good example of doing at least
> SAVE and RESTORE pointer management properly.  I plan to add the
> necessary MODIFY bits soon.
> 
> I think it's important to get this right because a target can use
> this to recover from internal errors during an I/O, in order to
> transfer some block of the data again.
> 
> I am pretty sure that the firmware in the aic7xxx, sym53c8xx, et
> al. have extensive code to handle this completely.  That's why there
> aren't any good driver examples, not because it isn't being handled,
> but because all the logic and important details are done in the scsi
> adapter firmware.

You're right. I can only speak sym53c8xx firmware code.  What that does
is to save and restore the pointer address correctly ... it does have a
nice snippet anticipating the save data pointer before a disconnect, but
I think it's not mandatory.

The Modify Data Pointers is actually handled outside of the firmware in
sym_hipd.c:sym_modify_dp().  This is what you need to implement to allow
a device to rewind after an error.

James


