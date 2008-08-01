From: James.Smart@Emulex.Com
Subject: RE: [PATCH 1/2] scsi:netlink support in scsi and fc transports for hbaspecific messages
Date: Thu, 31 Jul 2008 20:35:16 -0400
Message-ID: <D1D4C3FF75F9354393DB8314DF43DEF2E7F57F@xbl3.ma.emulex.com>
References: <C4B7595B.160C%david.somayajulu@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:57403 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbYHAAfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 20:35:19 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: david.somayajulu@qlogic.com, linux-scsi@vger.kernel.org

 

David Somayajulu wrote:
> > I'm a little bothered that there's nothing that qualifies the driver
> > to the shost before invoking the LLDD handler (e.g. driver has a
> > signature, message header contains signature, and the two 
> must match).
> The idea was to let the Low Level Driver validate the message 
> contents -
> signature, etc.

But that's the point - if we have a common action and a common point,
lets
do it once. Why have all LLDs perform the same kind of thing but in
completely different manners ? And worse, what happens if one doesn't
validate ?  The check doesn't have to be extensive, and the LLD
can certainly do more checks.

> I would appreciate if you can explain your comment a bit more, if my
> reasoning below does not suffice. I have already provided a function
> "fc_host_post_vendor_event_to_pid() [in 
> scsi_transport_fc.c]", which enables
> an LLD to post a message to a specific pid. This may be used 
> by the LLD to
> send response messages to the pid, for command messages sent 
> by the pid. 

it's not about sending...

What happens if the pid unexpectedly dies ? The event notices are an
easy way to find out that it died - thus releasing the "cached pid", or
terminating partial transactions, and not abusing the netlink socket
with data destined to a dead pid.

-- james s

