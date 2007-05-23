From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH] Un-remove aacraid devices
Date: Wed, 23 May 2007 21:08:05 +0400
Message-ID: <465474F5.9080504@msgid.tls.msk.ru>
References: <465438AD.8000406@suse.de> <AE4F746F2AECFC4DA4AADD66A1DFEF019E1B5C@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hobbit.corpit.ru ([81.13.94.6]:23588 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757101AbXEWROu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 13:14:50 -0400
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1B5C@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Hannes Reinecke <hare@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Salyzyn, Mark wrote:
> NAK
> 
> This will break all our management applications, and will not allow us to manipulate the array configurations from within Linux. This will also break online expansion of capacity.
> 
> This flag has been set from the beginning to allow partition tables, capacity and device locking to be changed without requiring an intervening reboot or needing the device to be taken offline. Fixed disk result in these pieces of information being cached.

I think I've seen this very discussion before.

It looks like kernel needs to distinguish things like removable
media (truely removable - CDRoms etc) and some "dynamic" things
like in this case (like with any raid array really), with iSCSI
devices and so on.

Currently, 'removable' is handy at detecting devices which should
be handed to 'cdrom' or 'floppy' group (i think it was the cause
of previous incarnation of this discussion).

Right now, both ways are causing problems here or there.  "Removable"
is bad because it confuses "regular" linux tools, while !removable
breaks configurability of arrays.

/mjt
