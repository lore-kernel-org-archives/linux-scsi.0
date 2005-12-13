From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: linux kernel panic when ejecting ieee1394 ipod
Date: Tue, 13 Dec 2005 21:44:09 +0100
Message-ID: <439F3299.9020804@s5r6.in-berlin.de>
References: <200512091938.jB9JbnnQ025362@einhorn.in-berlin.de> <1134168322.3491.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:25038 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1030192AbVLMUsN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Dec 2005 15:48:13 -0500
In-Reply-To: <1134168322.3491.5.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jody McIntyre <scjody@modernduck.com>, linux-scsi@vger.kernel.org, patmans@us.ibm.com, adq_dvb@lidskialf.net, linux1394-devel@lists.sourceforge.net, axboe@suse.de

James Bottomley wrote:
> On Fri, 2005-12-09 at 20:35 +0100, Stefan Richter wrote:
>>When preparing a request in scsi_lib or in a SCSI high-level driver,
>>always set a transfer direction of DMA_NONE if data length is zero,
>>even for alleged write requests. (Extended patch derived from Jens
>>Axboe's version.)
[...]
> The problem is that I already picked up Jens' patch in rc fixes, so this
> no-longer applies.  However, given that the fix needed to be in four
> separate places, which looks rather bad, I propose the following
> consolidation instead.

Jens' patch alone does not fix the kernel panic AFAICS. "eject /dev/sdX" 
goes through sd_init_command. James, could you put your patch into 
scsi-rc-fixes too? And what about -stable?

[BTW, some revisions of iPods require to either "eject" them or to 
unload sbp2 or to disassociate them from sbp2 via an arcane echo to 
ieee1394's sysfs interface before they can be unplugged. Else their 
firmware needs to be reset. This is why "eject" is the recommended 
procedure to disconnect an iPod.]

Thanks,
-- 
Stefan Richter
-=====-=-=-= ==-- -==-=
http://arcgraph.de/sr/
