From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Tue, 26 Jun 2007 00:27:30 +0200
Message-ID: <46804152.8050200@s5r6.in-berlin.de>
References: <200706191025.30986.swen@vnet.ibm.com>	 <20070622044035.GB5560@us.ibm.com>	 <1182521500.3923.49.camel@mulgrave.il.steeleye.com>	 <200706251239.09755.swen@vnet.ibm.com> <467FCB4C.6060907@suse.de>	 <46801010.3050604@s5r6.in-berlin.de> <1182808124.3461.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:52954 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbXFYW1l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jun 2007 18:27:41 -0400
In-Reply-To: <1182808124.3461.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Hannes Reinecke <hare@suse.de>, Swen Schillig <swen@vnet.ibm.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Mon, 2007-06-25 at 20:57 +0200, Stefan Richter wrote:
>> I would also like to have the Target Port identifier in there.  This, in
>> combination with the LUN alias Logical Unit identifier is useful for all
>> kinds of persistent device mapping.
> 
> Really, no.  Target port is a target, not a LUN property; worse, it's
> potentially transport defined.  The way target ports are currently shown
> is by the relevant transport class as per target things (see the FC
> transport for an example).  There's no real reason the mid-layer has to
> know about these.

Do all these transports use the same *name* for the attribute holding
the target port identifier's?  In other words, is userspace able to find
the target port identifier without knowing which transport is at work?
(It's a bit difficult for me to check for myself, not having any other
SCSI hardware than SBP-2 at hand.)

>> The LUN could be the same data format (and display format) for all
>> transports == 8 bytes.  SBP-3's native format is 2 bytes but we can
>> transform and print it in the 8 bytes format; shouldn't hurt.
>>
>> Actually, the SCSI midlayer integer 'l' can be used as internal
>> intermediary data format as long as only those LUN variants are in
>> real-world use which can be losslessly transformed to and from SCSI
>> midlayer's integer 'l'.
> 
> You're sort of confusing what we display as the LUN and what we
> represent it as internally (admittedly they're the same at the moment).

No, I'm not. :-)

(Actually we currently don't display the LUN at all.  There is something
in the device path name which more or rather less resembles the LUN
after some rough treatment.  But it's not a LUN; and as I said in
another post:  We need the LUN in sysfs, but we don't need it as
component of the device path.)

> The object would be to separate these and the debate is really about
> what to display.

Yes. :-)

[...]
>> The transport identifiers have transport-dependent data sizes, and the
>> display formats are not standardized.  So that's requiring a little bit
>> more care than the LUNs but it isn't overly complicated either.
>>
>> So,
>>   - SCSI mid layer should maintain sysfs attributes for each sdev which
>>     show Logical Unit identifier and Target Port identifier.
> 
> LUN possibly, TPID no; the transport class does that one.

Regarding the TPID:  The /how/ should be left to the transport layer
implementation; but the /where/ should be uniform in all transports.

Besides, the transports don't manage the lifetime of the sysfs device
which represent Logical Units.  Why not let the SCSI core also manage
the lifetime of sysfs attributes (or to-be-implemented sysfs devices)
which represent targets?  The concept of target is
transport-independent; merely some of their properties look different
from transport to transport.

>>   - Do we pass the LUN through to SCSI midlayer's sysfs code via the
>>     theoretically lossy scsilun_to_int/ int_to_scsilun transformation?
> 
> Absolutely ... otherwise you won't get the correct representation when
> that gets decided.
> 
>>   - Do we pass the target port identifier through as a data member in
>>     struct scsi_device, or as a hook "int (* print_target_port_id)(..);"
>>     in struct scsi_transport_template?
>>
>>   - Do we also want initiator port identifier, initiator port name,
>>     target port name, LU name?  If so, create a subdirectory for that
>>     whole bunch of additional attributes?  (Most of these are just
>>     optional.  In case of SBP-2/3, the initiator port identifier is
>>     totally uninteresting to userspace; the initiator port name is of
>>     mild interest but can be retrieved elsewhere from sysfs by some
>>     black magic.)
> 
> Again, no ... these are transport dependent quantities and belong in the
> transport class (if they're relevant to the transport).

"Yes, but" on the how and the where as above.
-- 
Stefan Richter
-=====-=-=== -==- ==-=-
http://arcgraph.de/sr/
