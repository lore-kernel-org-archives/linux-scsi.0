From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: INQUIRY always only untagged
Date: Fri, 1 Oct 2004 23:00:23 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0410012255410.3951@poirot.grange>
References: <Pine.LNX.4.60.0409040033310.5266@poirot.grange>
 <20040904140102.A15247@infradead.org> <Pine.LNX.4.60.0409050022570.3092@poirot.grange>
 <20040904233835.A18659@infradead.org> <Pine.LNX.4.60.0409051654460.3039@poirot.grange>
 <1094398979.10977.9.camel@mulgrave>  <20040905173134.A31521@infradead.org>
 <1094422949.10977.15.camel@mulgrave> <Pine.LNX.4.60.0409061042240.6252@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:46018 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S266802AbUJAWUa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2004 18:20:30 -0400
In-Reply-To: <Pine.LNX.4.60.0409061042240.6252@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 6 Sep 2004, Guennadi Liakhovetski wrote:

> On Mon, 5 Sep 2004, James Bottomley wrote:
>
>> I think perhaps the correct palliative fix is simply to list this device
>> (whatever it is, it's not listed in the bug report) as BLIST_NOTQ, then
>> the problem won't arise (and of course, tmscsim would have actually to
>> use the mid-layer black list rather than its own much shorter internal
>> list).
>
> I don't know what device the original reporter had, but the one I have here, 
> which exibits the same behaviour, is a Seagate disk (see attached patch). So, 
> if you still think, this device should not be allowed any tags (which is a 
> pity, I would then again have no device with tags supported for tests 
> here:-(), then, please, apply the attached patch. A patch to use the 
> blacklist will follow shortly.

Looks like this patch didn't get applied until now. Have you changed your 
opinion about the proper handling of this disk, James, or it just somehow 
got lost? Attaching again below. Next patch to tmscsim will switch the 
driver to use the device information from the mid-layer, so, this patch is 
required.

Thanks
Guennadi
---
Guennadi Liakhovetski


Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

diff -u a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
--- a/drivers/scsi/scsi_devinfo.c	Mon Sep  6 10:37:08 2004
+++ b/drivers/scsi/scsi_devinfo.c	Mon Sep  6 10:36:30 2004
@@ -181,6 +181,7 @@
  	{"REGAL", "CDC-4X", NULL, BLIST_MAX5LUN | BLIST_SINGLELUN},
  	{"SanDisk", "ImageMate CF-SD1", NULL, BLIST_FORCELUN},
  	{"SEAGATE", "ST3390N", "9546", BLIST_NOTQ},
+	{"SEAGATE", "ST34555N", "0930", BLIST_NOTQ},	/* Chokes on tagged INQUIRY */
  	{"SGI", "RAID3", "*", BLIST_SPARSELUN},
  	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
  	{"SGI", "TP9100", "*", BLIST_REPORTLUN2},
