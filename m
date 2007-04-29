From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SAVE_DATA / RESTORE_POINTERS message confusion
Date: Sun, 29 Apr 2007 16:18:19 -0500
Message-ID: <1177881499.3688.82.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.60.0704292249200.4454@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:54872 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161339AbXD2VTB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Apr 2007 17:19:01 -0400
In-Reply-To: <Pine.LNX.4.60.0704292249200.4454@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Sun, 2007-04-29 at 22:56 +0200, Guennadi Liakhovetski wrote:
> Hi all,
> 
> looking at tmscsim (again) I cannot persuade myself that the handling of 
> the RESTORE_POINTERS command is correct... Therefore a couple of 
> questions:
> 
> 1. do any devices at all use this message-pair?

Every *device* does ... they're a mandatory part of the SPI standard for
devices doing disconnect/reselect

> 2. are they ever sent apart from when accompanying the DISCONNECT / 
> RESELECT?

I've never seen an occasion, no.

> 3. if "yes" to 2 - can the RESTORE be used to "rewind" the pointer to a 
> value smaller than the current?

Theoretically, yes.  In practice, no device I've ever heard of has done
this.

> 4. Some LLDs just pretty much ignore the message. Thereby, AFAIU, they 
> just assume that this is just a part of the RESELECT procedure and that 
> they already have the proper context. Is it sufficient?

Yes ... the only function use seems to be to save/restore across
disconnect/reselect, so almost every SPI driver builds this in as part
of the disconnect/reselect action.

> >From which I'm trying to derive whether the handling in tmscsim is 
> correct, and, if not, how to correct it...

Hope this helps.

James


