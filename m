From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/4] [SCSI]stex: fix id mapping issue
Date: Fri, 30 Mar 2007 19:35:53 -0400
Message-ID: <460D9ED9.1050801@garzik.org>
References: <NONAMEBZNuIkdg0MZMt000005d3@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:37111 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932886AbXC3Xf4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Mar 2007 19:35:56 -0400
In-Reply-To: <NONAMEBZNuIkdg0MZMt000005d3@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "james.Bottomley" <james.Bottomley@SteelEye.com>, promise_linux <promise_linux@promise.com>

Ed Lin wrote:
> The internal id/lun mapping of st_vsc and st_vsc1 controllers is different
> from st_shasta. The original driver code can only  map first 16 'entities'
> for st_vsc and st_vsc1 while there are actually 128 available.
> 
> Also the  ST_MAX_LUN_PER_TARGET should be 8, although this can do
> no harm because inquiries beyond boundary are discarded by firmware.
> 
> The correct internal mapping should be:
> id:0~15, lun:0~7 (st_shasta)
> id:0, lun:0~127 (st_yosemite)
> id:0~127, lun:0 (st_vsc and st_vsc1)
> To scsi mid layer they are all channel:0~7, id:0~15, lun:0, with a maximun
> 'entity' number of 128. The RAID console only interfaces to scsi mid layer
> and is always mapped at channel:0, id:16, lun:0.
> 
> Signed-off-by: Ed Lin <ed.lin@promise.com>

ACK patches 1-4.  I presume James will apply them to scsi-fixes...

	Jeff



