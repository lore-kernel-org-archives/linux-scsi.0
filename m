From: "Igor A. Nesterov" <igor.nesterov@usa.net>
Subject: Re: rounding dxfer_len to 512 bytes boundary in sg.c
Date: Thu, 15 Nov 2007 16:56:54 -0500
Message-ID: <1195163814.2607.234.camel@potomac.tworiverlabs.com>
References: <1195141083.2607.203.camel@potomac.tworiverlabs.com>
	 <473CB9DF.5030401@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmsout02.mbox.net ([165.212.64.32]:42345 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbXKOV5C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 16:57:02 -0500
In-Reply-To: <473CB9DF.5030401@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2007-11-15 at 16:27 -0500, Douglas Gilbert wrote:

> That code was there when I inherited the sg driver in 1998
> (the original sg drivers dates from around 1993). The reason
> is/was that the DMA element of some HBA needed it. I tried
> to take it out once (probably in the last millenium) and it
> broke somewhere so back in it went :-)

I would say that if an HBA accepts only rounded values, it should either
round them up itself, or reject non-rounded requests with one or another
status value. Well, in 1993 people might think differently.

> 
> Now the SG_IO ioctl implementation in the block layer
> doesn't have that code so perhaps we might assume from
> that the HBA is no longer in use or its DMA logic
> has been fixed. So perhaps it's time to pull out that
> line again and see if anyone screams.

But the code in sg_link_reserve() which fixes the last scatterlist
element length (and which was most probably added at later times),
nullifies the effect of that rounding anyway. It only has an effect on
requests bigger than def_reserved_size, and there it breaks IO. So I
scream. 


