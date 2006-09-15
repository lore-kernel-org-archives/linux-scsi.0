From: "Jones, David G" <david.g.jones@lmco.com>
Subject: RE: SCSI timeouts with sym-2 driver
Date: Fri, 15 Sep 2006 13:46:00 -0400
Message-ID: <824B13109773064F92372DAB2F3B3C9D0EFB1F2A@emss35m05.us.lmco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgw3a.lmco.com ([192.35.35.7]:62412 "EHLO mailgw3a.lmco.com")
	by vger.kernel.org with ESMTP id S1751194AbWIORqM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Sep 2006 13:46:12 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matt,

Thanks for the response. Each device is on a separate interrupt. But it
does seem like an interrupt related problem, doesn't it ? 

-----Original Message-----
From: Matthew Wilcox [mailto:matthew@wil.cx] 
Sent: Friday, September 15, 2006 1:41 PM
To: Jones, David G
Cc: linux-scsi@vger.kernel.org
Subject: Re: SCSI timeouts with sym-2 driver

On Fri, Sep 15, 2006 at 01:36:37PM -0400, Jones, David G wrote:
> Everything works fine until I try to use the hard drive and PC card at

> the same time. Then I get SCSI timeouts for the PC card reader and 
> eventually I/O errors for the PCCard devices. Continously copying a 
> file from the PCCard reader to the hard drive results in these 
> messages in the kernel log :

Sounds like you've got both these devices on the same interrupt; is that
true?  If so, I'd urge you to examine both of the interrupt handlers; it
feels like one of the drivers is not playing well with the other when an
interrupt occurs on both at the same time.  Or maybe it's a problem in
the arch code where it doesn't call both handlers?

In any case, trying a recent 2.6 kernel may give better results.
