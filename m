From: James.Smart@Emulex.Com
Subject: RE: [PATCH 1/2] scsi:netlink support in scsi and fc transports forhba	specific messages
Date: Sat, 2 Aug 2008 14:09:48 -0400
Message-ID: <D1D4C3FF75F9354393DB8314DF43DEF2E7F5C9@xbl3.ma.emulex.com>
References: <1217454832.25166.22.camel@localhost.localdomain> <489218F4.8020203@cs.wisc.edu> <1217475321.26535.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51828 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbYHBSKC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Aug 2008 14:10:02 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: david.somayajulu@qlogic.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, david.wagner@qlogic.com

David,

The more I look at the patch, the more it's not done correctly.

For example:
- The rcv function jumps to the msg_type, and thereby jumps over the
  transport designator. This should be a msg_type under the generic
  SCSI Transport (aka SCSI_NL_TRANSPORT). We shouldn't steal msg_types
  from the transports. There was a layering in the design, granted it
  wasn't used much yet, that was subverted by this.
- The message needs to be it's own message type - not munged into the
  FC event message.
- The send function, should not be a function under the fc transport,
  but rather a generic function exported by the scsi netlink module.
- Your recently added scsi_host_put() was very wrong. You never
  had a corresponding get().
 
I'm testing a patch which corrects the above, and adds the following:
- adds generic support for any transport to receive messages, and
  send to pid
- the shost vendor message is a now a message type of the generic
  scsi transport
- adds checks for vendor_id to the reception of vendor message
- adds event propogation to the scsi hosts too
- updates shost for the netlink rcv function, event function, vendorid
- Keeps the basic semantics you already had for entry into the shost.

I'll post it when testing is complete.

-- james s


