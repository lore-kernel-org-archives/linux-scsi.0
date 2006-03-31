From: Ingo Flaschberger <if@xip.at>
Subject: Re: Compaq Fiber Channel Array RM4000 / 2.6.16 kernel patch VER6
Date: Fri, 31 Mar 2006 23:13:48 +0200 (CEST)
Message-ID: <Pine.GSO.4.64.0603312311590.25350@filebunker.xip.at>
References: <1143656547.3248.36.camel@mulgrave.il.steeleye.com>
 <Pine.GSO.4.64.0603292025500.4009@filebunker.xip.at>
 <1143657838.3248.39.camel@mulgrave.il.steeleye.com>
 <Pine.GSO.4.64.0603292052430.4009@filebunker.xip.at>
 <1143659029.3248.42.camel@mulgrave.il.steeleye.com>
 <Pine.GSO.4.64.0603292125370.4009@filebunker.xip.at>
 <1143666681.3248.48.camel@mulgrave.il.steeleye.com>
 <Pine.GSO.4.64.0603301252100.595@filebunker.xip.at>  <20060330125816.GG13590@parisc-linux.org>
  <Pine.GSO.4.64.0603301523130.6412@filebunker.xip.at>
 <20060330162429.GI13590@parisc-linux.org>  <Pine.GSO.4.64.0603301825560.14161@filebunker.xip.at>
 <1143834313.3342.54.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.xip.at ([193.239.188.99]:36011 "EHLO chile.gbit.at")
	by vger.kernel.org with ESMTP id S932400AbWCaVNy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Mar 2006 16:13:54 -0500
In-Reply-To: <1143834313.3342.54.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello James,

> On Thu, 2006-03-30 at 18:35 +0200, Ingo Flaschberger wrote:
>> +       sdev->max_xfer_len = 0xffff;
>> +       if (*bflags & BLIST_MAX_512K)
>> +               sdev->max_xfer_len = 0x200;
>
> Where do you make the block layer see the effects of this?
>
> Currently it seems all you do is truncate a READ10 or WRITE10 to a
> maximum transfer size of 0x200.  That means that we simply lie to the
> block layer for transfers above 0x200 and say that it all completed when
> we only transferred 0x200 blocks ... this is bound to cause data
> corruption.

linux-2.6.16/drivers/scsi/sd.c
                 SCpnt->cmnd[14] = SCpnt->cmnd[15] = 0;
         } else if ((this_count > 0xff) || (block > 0x1fffff) ||
                    SCpnt->device->use_10_for_rw) {
-               if (this_count > 0xffff)
-                       this_count = 0xffff;
+               if (this_count > SCpnt->device->max_xfer_len)
+                       this_count = SCpnt->device->max_xfer_len;

                 SCpnt->cmnd[0] += READ_10 - READ_6;
                 SCpnt->cmnd[1] |= blk_fua_rq(rq) ? 0x8 : 0;

Here, but only for the RA4x00.


bye,
 	Ingo
