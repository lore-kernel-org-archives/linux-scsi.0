From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security in usb-storage driver
Date: Mon, 7 Nov 2005 17:53:03 +0000
Message-ID: <20051107175303.GA20151@infradead.org>
References: <1131130707.3532.45.camel@mulgrave> <20051104203004.GF12384@one-eyed-alien.net> <1131137395.3532.57.camel@mulgrave> <20051105235522.GA21733@one-eyed-alien.net> <1131238146.9430.7.camel@mulgrave> <20051106215856.GA28452@one-eyed-alien.net> <436E8394.2010600@gmx.de> <20051106235213.GA479@us.ibm.com> <20051107170525.GB26509@one-eyed-alien.net> <20051107172421.GA15710@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:11408 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932308AbVKGRxO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Nov 2005 12:53:14 -0500
Content-Disposition: inline
In-Reply-To: <20051107172421.GA15710@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: thomas schorpp <t.schorpp@gmx.de>, James Bottomley <James.Bottomley@SteelEye.com>, Timothy Thelin <Timothy.Thelin@wdc.com>, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>

On Mon, Nov 07, 2005 at 09:24:21AM -0800, Patrick Mansfield wrote:
> The scmd/cdb is not available until we call scsi_get_command() in the
> request function. So you would have to add a field into scsi_request, set
> it in sg (in both sg.c block/scsi_ioctl.c, test via sd and sg when you are
> done), and add the field in scsi_cmnd, and set scmd one in
> scsi_init_cmd_from_req().

Once Mike finally reposts his patchkit scsi_request should be gone
and block SG_IO or sg should send down a struct request.  Which already
has a cmnd pointer embedded.

