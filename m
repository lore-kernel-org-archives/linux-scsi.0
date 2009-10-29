From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/5] osduld: Use device->release instead of internal
 kref
Date: Thu, 29 Oct 2009 18:06:48 +0000
Message-ID: <1256839608.7191.35.camel@mulgrave.site>
References: <4AE5D374.80400@panasas.com>
	 <1256576294-10430-1-git-send-email-bharrosh@panasas.com>
	 <1256836303.7191.21.camel@mulgrave.site>  <4AE9CFC6.2080404@panasas.com>
	 <1256838073.7191.24.camel@mulgrave.site>  <4AE9D7D9.5010006@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54947 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754384AbZJ2SGs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Oct 2009 14:06:48 -0400
In-Reply-To: <4AE9D7D9.5010006@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

On Thu, 2009-10-29 at 19:58 +0200, Boaz Harrosh wrote:
> On 10/29/2009 07:41 PM, James Bottomley wrote:
> > 
> > Chaining methods like this because of inner knowledge of the
> > implementation isn't resilient, it's very fragile.
> > 
> 
> If I would just kfree, because I know the inner code, that would be
> fragile.
> 
> But overriding a destructor, do what you need, and call previous
> distroctor. Does not take any inner knowledge. Just the published fact
> that it is a distructor, which will destroy the object.

You can't even justify this on OO grounds: In OO code, you get this
override by extending the object not hijacking the method and
arbitrarily linking two separate objects.

Embedding the device is the C equivalent of the OO object extension.

Method hijacks are almost always wrong.

James


