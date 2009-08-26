From: Mike Christie <michaelc@cs.wisc.edu>
Subject: transport classes vs binary interfaces
Date: Wed, 26 Aug 2009 17:15:02 -0500
Message-ID: <4A95B3E6.9030508@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34086 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006AbZHZWPI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2009 18:15:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, open-iscsi <open-iscsi@googlegroups.com>, Ravi Anand <ravi.anand@qlogic.com>, Jayamohan Kalickal <jayamohank@serverengines.com>

Hi,

For the transport classes we have been providing a common interface to 
get transport specific values. For example, for all iscsi drivers we can 
get the target name in sysfs or for FC we can get the node name in a 
common place in sysfs. Or we can get transport events via the classes 
netlink APIs.


For iscsi, We are now trying to support qla4xxx and be2iscsi (iscsi 
offload cards that are a little different from what we support today 
with bnx2i and cxgb3i) management. With qla4xxx you can do:

1. Just send a binary blob with configuration values between the card 
and userspace using a binary sysfs file or netlink.

or

2. Extend the existing netlink and sysfs code so that the driver can get 
the rest of the values it needs in a format that makes sense for both 
drivers. With this we would add some netlink messages that are 
sent/received through the iscsi class netlink code. The new messages 
would have a bunch of iscsi or net or iscsi hba config values. Then the 
drivers would take those values or requests and do some mbox command to 
the card to get/set the config params.


My question is there a preference or rule that says we should do #2? Or 
is doing #1 ok?

In my opinion, #1 is very easy and would be the easiest route. However, 
anytime there is a format change I am relying on the vendor letting me 
know so I can update the iscsi tools. To some vendors the iscsi tools 
are secondary to their own tools, so I am not sure how much love I am 
going to get. If it is allowed though, I will not stop vendors from 
doing it. #2 is nice, because it makes it easier for any tools to manage 
any cards.
