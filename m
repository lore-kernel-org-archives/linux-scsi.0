From: James.Smart@Emulex.Com
Subject: RE: [PATCH] minimal SAS transport class
Date: Thu, 18 Aug 2005 07:57:30 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A33@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46540 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932212AbVHRL55 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Aug 2005 07:57:57 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de, jejb@steeleye.com
Cc: ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

Christoph,

I like it, and have no real complaints.  

As familiar as this looks, there were a couple of conventions in the FC
transport that I thought should have carried over here. Namely, I saw
not all attributes being the same, thus I created 3 categories of
attributes:
  Private:
    These are attributes fully owned by the transport. The LLDD does
    not directly access them, or participate in the sysfs calls.
    LLDD interaction is strictly indirect via transport functions.
  Fixed:
    These attributes, once set, are not expected to change. The LLDD
    does set these values directly, but should only do so at
    initialization. The sysfs functions will be handled solely by
    the transport w/ no interaction with the LLDD.
  Dynamic (Normal):
    Values can change. Sysfs functions utilize LLDD to get/set values.

I expect that the SAS transport has much the same categories, and it
would be beneficial to indicate which category the different attributes
fall into. This can be as simple as comments, grouping, or name prefixes.

Also, I see your enums set explicit values. Just a caution. When I did
the FC transport, there were cases where I specifically did not use
specification-specific values, as the transport was a subset or extension
of the spec. This made anyone interacting with the transport realize that
this area was not just a reincarnation of the spec (plus, spec writers
sometimes do stupid things).

-- james s

