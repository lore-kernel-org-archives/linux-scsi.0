From: James.Smart@Emulex.Com
Subject: RE: [PATCH] minimal SAS transport class
Date: Thu, 18 Aug 2005 10:02:21 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A35@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:11223 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932214AbVHRODB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Aug 2005 10:03:01 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, hch@lst.de, jejb@steeleye.com
Cc: ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

Ok, so I'm going to have to revert my statement. After perusing the
sas transport, I went to the previous patch, which added pre-init
data to scsi_scan_target calls.  I didn't understand why this was
needed.

In tracking how you were using the patch, it highlighted that you 
were skipping a step.  The api is such that it does not expect remote
SAS ports to be instantiated.  They should have be (just like FC).
Your api is written only to instantiate local initiator SAS ports.
It needs to instantiate remote SAS ports as well. If it does so, the
remote port is the parent, and the pre-init data doesn't need to be
passed around. The remote SAS ports need to also implement consistent
target id bindings, just like FC.

Also, it appears that your api is allowing multiple SAS initiator
ports to SCSI host. This doesn't make sense, unless you are going to
map SAS ports to the scsi "channel" designator in the address.
In FC, there is a 1:1 correlation of the scsi_host to the local FC
port, so there's no need for a local port transport object as it's
simply the transport for the host.  Also, I prefer a distinction
between the local port and remote port as the functionality of each
will be different (e.g. for local port, you'll have statistics, 
more attributes, and more functions that can be performed. The remote
ports are rarely more than a reporting element, so they are less
featured).

-- James



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Smart, James
> Sent: Thursday, August 18, 2005 7:58 AM
> To: hch@lst.de; jejb@steeleye.com
> Cc: ltuikov@yahoo.com; Eric.Moore@lsil.com; andrew.patterson@hp.com;
> linux-scsi@vger.kernel.org
> Subject: RE: [PATCH] minimal SAS transport class
> 
> 
> Christoph,
> 
> I like it, and have no real complaints.  
> 
> As familiar as this looks, there were a couple of conventions 
> in the FC
> transport that I thought should have carried over here. Namely, I saw
> not all attributes being the same, thus I created 3 categories of
> attributes:
>   Private:
>     These are attributes fully owned by the transport. The LLDD does
>     not directly access them, or participate in the sysfs calls.
>     LLDD interaction is strictly indirect via transport functions.
>   Fixed:
>     These attributes, once set, are not expected to change. The LLDD
>     does set these values directly, but should only do so at
>     initialization. The sysfs functions will be handled solely by
>     the transport w/ no interaction with the LLDD.
>   Dynamic (Normal):
>     Values can change. Sysfs functions utilize LLDD to get/set values.
> 
> I expect that the SAS transport has much the same categories, and it
> would be beneficial to indicate which category the different 
> attributes
> fall into. This can be as simple as comments, grouping, or 
> name prefixes.
> 
> Also, I see your enums set explicit values. Just a caution. When I did
> the FC transport, there were cases where I specifically did not use
> specification-specific values, as the transport was a subset 
> or extension
> of the spec. This made anyone interacting with the transport 
> realize that
> this area was not just a reincarnation of the spec (plus, spec writers
> sometimes do stupid things).
> 
> -- james s
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
