From: "Kai OM" <epimetreus@fastmail.fm>
Subject: Re: [PATCH] fix for Domain Validation hang on some devices with
   sym_2driver
Date: Fri, 20 Aug 2004 10:55:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093013734.24711.202728757@webmail.messagingengine.com>
References: <1092970559.1728.2520.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from frontend1.messagingengine.com ([66.111.4.30]:27108 "EHLO
	frontend1.messagingengine.com") by vger.kernel.org with ESMTP
	id S268172AbUHTOzf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 10:55:35 -0400
Content-Disposition: inline
In-Reply-To: <1092970559.1728.2520.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, willy@debian.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


On 19 Aug 2004 22:55:57 -0400, "James Bottomley"
<James.Bottomley@SteelEye.com> said:
> There's a bad hang where the driver locks the system solid trying to do
> domain validation with certain devices.  The one I've managed to
> reproduce it with is a Quantum Atlas.
> 
> What happens is that setting the offset to zero is an async negotiation
> message.  However, the driver still seems to have DT set (which is
> illegal).  Most devices just reject this as stupid, but the Quantum
> seems to try to obey it and hangs the bus.
> 
> The simple fix is to reset all PPR options when the offset is set to
> zero.

As they said in the '90s, "you da' man."

It works perfectly, so far as I can tell.

So, um, what I want to know is... why did the issue appear to go away
for some people if they switched controllers?

I don't know a terrible lot about SCSI devices, so maybe someone here
could tell me if there's a reason that would happen, or is this to be
expected?
