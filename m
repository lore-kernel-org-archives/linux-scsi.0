From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Using common code for csiostor.
Date: Wed, 17 Dec 2014 08:10:15 -0800
Message-ID: <1418832615.3052.36.camel@HansenPartnership.com>
References: <24C222ADD7729F4FB5113B41FF0028A1BC8C12@nice.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57405 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750900AbaLQQKS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Dec 2014 11:10:18 -0500
In-Reply-To: <24C222ADD7729F4FB5113B41FF0028A1BC8C12@nice.asicdesigners.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Praveen Madhavan <praveenm@chelsio.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2014-12-17 at 15:51 +0000, Praveen Madhavan wrote:
> Hi Christoph,
> csiostor is chelsio full offload FCoE physical function driver. I
> would like to reuse common hardware interface functions defined in
> t4_hw.c of chelsio networking driver(cxgb4). Below is makefile change
> that creates softlink to t4_hw.c and builds the same. Is this change
> is acceptable? Please suggest if there is any better way of doing
> this.

The usual way to do this is to make the common hardware function a base
module and make all drivers that use it depend on it.  Like iwldvm ->
iwlwifi -> mac80211 etc.

We really wouldn't want to do the link and build because that will
create two identical binary copies of the interface (one in SCSI and one
in net) which is a waste of text space.

James


