From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fix dma mapping leak in fusion
Date: Sat, 28 Aug 2004 21:02:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040828190256.GA17846@lst.de>
References: <0E3FA95632D6D047BA649F95DAB60E5704DE6BD5@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:44449 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267522AbUH1TDF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Aug 2004 15:03:05 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5704DE6BD5@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>, linux-scsi@vger.kernel.org

On Mon, Aug 23, 2004 at 11:56:50AM -0400, Moore, Eric Dean wrote:
> Christoph - What is the criteria for the mid-layer
> to offline a device? 

When eh_abort didn't succeed for all outstanding commands and the various
reset methods failed aswell.

> The dmesg dump in previous email indicates that mid-layer 
> issued several aborts to the LLD, then mpt driver is returning 
> SUCCESS. However at some point the midlayer offlines the device,
> however commands are still in the LLD, and completed sometime later after
> the mptscsih_taskmgmt_timeout is called, thus hitting the
> oops(because request_buffer=NULL), as we have removed the 
> scsi_device_online check per your request.

I'm looking over fusion code with your latest patch applied now.  What
worries me is mptscsih_flush_running_cmds where's you're erroring out
commands possibly from withing EH methods (?, I have a hard time
following the code from mptscsih to mptbase and back), but not under
EH control.

Btw, when looking over this it seems to me you could kill
mptscsih_search_running_cmds - the scsi core makes sure you'll never
have outstanding commands when it calls ->slave_destory.
