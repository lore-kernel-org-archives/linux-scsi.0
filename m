From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [RFC] Transport classes, SAS, discovery
Date: Fri, 11 Mar 2005 11:33:56 -0500
Message-ID: <4231C874.7060800@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:5021 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261174AbVCKQeC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 11:34:02 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j2BGY2r03873
	for <linux-scsi@vger.kernel.org>; Fri, 11 Mar 2005 08:34:02 -0800
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j2BGY2D02666
	for <linux-scsi@vger.kernel.org>; Fri, 11 Mar 2005 08:34:02 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi guys,

Q: I've been wondering how exactly does the transport class work?
Can anyone give an intro on attribute container, attribute group,
transport class template, etc.  I've been looking at those but not
100% sure I understand it all.  It looks similar to the old
scsi detect "discovery" but not 100% sure.

Q: Also I'd like to ask if domain discovery would be performed
by the mid layer?  I assume yes, so that "there is no code duplication".

Q: In this case would it be safe to assume that we need a
sas_phy, sas_port and sas_ha? A la:

sas_ha 1<---* sas_port 1<---128 sas_phy  *
   ^                               |
   | 1                         128 |
   +-------------------------------+

With the appropriate linked lists and properties as defined
in the SAS 1.1 spec ch 4? (undoubtedly more properties would
be added as drivers come along)

Now, I can see that there exist scsi_target and scsi_host
which appear to be the underlying objects for the transport
classes of sorts, host and target.

Q: Since a SAS mid layer discovery core would manipulate ports
and phys, do we need to represent those with scsi core
objects, or would struct device plus the SAS specific
object class suffice?

Q: Also, how exactly would a LLDD register the objects with
the class?  Would the answer to this be the trivial answer,
or is there some kind of "it will detect it itself".

On top of this we would have scsi targets in this picture
which would depend on phys/ports/ha.  (And LUs depend on
targets.)

So basically, would scsi core need to have an internal SAS
domain topology representation (how about expanders...).
That is, it would help multipathing a great deal.

Thanks,
	Luben

* Where,
	objA N<---M objB,  means
objA depends on objB* and objA can associate M number of objB
and objB can associate N objA, where an association is 
a relationship defined appropriate for the object tuple, which
need not necessarily be homogeneous.

