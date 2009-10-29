From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 4/5] osduld: Use device->release instead of internal kref
Date: Thu, 29 Oct 2009 19:58:49 +0200
Message-ID: <4AE9D7D9.5010006@panasas.com>
References: <4AE5D374.80400@panasas.com>	 <1256576294-10430-1-git-send-email-bharrosh@panasas.com>	 <1256836303.7191.21.camel@mulgrave.site>  <4AE9CFC6.2080404@panasas.com> <1256838073.7191.24.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:62943 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752390AbZJ2R6r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2009 13:58:47 -0400
In-Reply-To: <1256838073.7191.24.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

On 10/29/2009 07:41 PM, James Bottomley wrote:
> 
> Chaining methods like this because of inner knowledge of the
> implementation isn't resilient, it's very fragile.
> 

If I would just kfree, because I know the inner code, that would be
fragile.

But overriding a destructor, do what you need, and call previous
distroctor. Does not take any inner knowledge. Just the published fact
that it is a distructor, which will destroy the object.

> Isn't the correct answer to embed your device in struct osd_uld_device?
> They both look to have identical lifetimes and the release rules can
> then handle the dual destruction?
> 

See the patch. there I have direct manipulation with inner members.
The chaining is more resilient, i think.

> James
> 
> 

Boaz
