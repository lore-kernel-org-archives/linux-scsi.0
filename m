From: "David Somayajulu" <david.somayajulu@qlogic.com>
Subject: RE: [PATCH 1/2] scsi:netlink support in scsi and fc transports forhba	specific messages
Date: Sat, 2 Aug 2008 23:16:48 -0700
Message-ID: <0BB3E5E7462EEA4295BC02D49691DC07015B4249@AVEXCH1.qlogic.org>
References: <D1D4C3FF75F9354393DB8314DF43DEF2E7F5C9@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:57341 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbYHCGQu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Aug 2008 02:16:50 -0400
Content-class: urn:content-classes:message
In-Reply-To: <D1D4C3FF75F9354393DB8314DF43DEF2E7F5C9@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, David Wagner <david.wagner@qlogic.com>



"James.Smart@Emulex.Com" <James.Smart@Emulex.Com> wrote:
> 
> David,
> 
> The more I look at the patch, the more it's not done correctly.
> 
> For example:
> - The rcv function jumps to the msg_type, and thereby jumps over the
>   transport designator. This should be a msg_type under the generic
>   SCSI Transport (aka SCSI_NL_TRANSPORT). We shouldn't steal msg_types
>   from the transports. There was a layering in the design, granted it
>   wasn't used much yet, that was subverted by this.
Isn't this what my patch does - as msg type on SCSI_NL_TRANSPORT.
> - The message needs to be it's own message type - not munged into the
>   FC event message.
I agree on the send side, if you want everything to be under scsi
transport. For receive side my patch is fine. 
> - The send function, should not be a function under the fc transport,
>   but rather a generic function exported by the scsi netlink module.
I agree it would better if the entire solution is under the scsi
transport.
> - Your recently added scsi_host_put() was very wrong. You never
>   had a corresponding get().
Oops. The version I was looking at for cross reference had a get() in
scsi_host_lookup() and no corresponding put(). Looks like
scsi_host_lookup() has changed at some point. (I think Mike Christie was
under the same impression when he suggested this).
> 
> I'm testing a patch which corrects the above, and adds the following:
> - adds generic support for any transport to receive messages, and
>   send to pid
> - the shost vendor message is a now a message type of the generic
>   scsi transport
> - adds checks for vendor_id to the reception of vendor message
> - adds event propogation to the scsi hosts too
> - updates shost for the netlink rcv function, event function, vendorid
> - Keeps the basic semantics you already had for entry into the shost.
> 
> I'll post it when testing is complete.

Thanks
David S.
