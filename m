From: Matt Gulick <gulickconsulting@direcway.com>
Subject: Re: bug 2400
Date: Thu, 01 Apr 2004 15:52:32 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080856352.5300.43.camel@localhost.localdomain>
References: <20040401131502.41136788.akpm@osdl.org>
Reply-To: gulickconsulting@direcway.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a34-mta01.direcpc.com ([66.82.4.90]:44528 "EHLO
	a34-mta01.direcway.com") by vger.kernel.org with ESMTP
	id S263273AbUDAVwr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2004 16:52:47 -0500
Received: from [40.0.0.57] (dpc6935101125.direcpc.com [69.35.101.125])
 by a34-mta01.direcway.com
 (iPlanet Messaging Server 5.2 HotFix 1.12 (built Feb 13 2003))
 with ESMTP id <0HVI004SZI3KG3@a34-mta01.direcway.com> for
 linux-scsi@vger.kernel.org; Thu, 01 Apr 2004 16:52:45 -0500 (EST)
In-reply-to: <20040401131502.41136788.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Thu, 2004-04-01 at 15:15, Andrew Morton wrote:
> Apparently there is some controversy over whether this:
> http://bugme.osdl.org/show_bug.cgi?id=2400 is a usb-storage problem or
> a
> SCSI problem.
> 
> Can someone please shed some light, propose a way to get it fixed?
> 
> Thanks.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Andrew,

This could be in the SCSI stack.  USB is just a transport mechanism or
physical layer.  The commands are actually handled by SCSI.  The
commands are packaged into SBP-2 (SCSI Bus Protocol) data grams for
delivery.

Where you will get into trouble is that SCSI is not considered to be a
'Dynamic' bus.  Devices do not normally come and go, while USB and 1394
devices are 'Hot Plugable'.

Think about what happens on MacOS X or Windose, the device must first be
stopped and ejected (virtual ejection) prior to unplugging.  This allows
the driver to tear down the device control structures and to release the
associated memory.

When the device was disconnected, these structures may have been torn
down and released without the SCSI drivers knowledge, hence the zero
pointer issue.

Remember, SCSI is not hot plugable.  The SCSI driver must receive a
START/STOP cdb with the bits set for STOP.  An EJECT call would not hurt
if supported by the device in question.

Just like I am constantly telling my kids, "Just 'cause you can, does
not mean you should"

Matt


----------------------------------------
Matt Gulick
Sr. Staff Engineer
Adaptec, Inc.
gulickconsulting@direcway.com
matt_gulick@adaptec.com
(715) 426-0884


