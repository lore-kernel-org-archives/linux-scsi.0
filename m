From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [PATCH] scsi_transport_iscsi.c contexts
Date: Fri, 29 Apr 2005 14:20:06 -0700
Message-ID: <4272A506.7020405@us.ibm.com>
References: <1114646147.20844.37.camel@haakon> <42705449.1030706@us.ibm.com> <1114803919.16658.8.camel@haakon>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:32657 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S263001AbVD2VUQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2005 17:20:16 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j3TLKFua486788
	for <linux-scsi@vger.kernel.org>; Fri, 29 Apr 2005 17:20:15 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j3TLKFnT179100
	for <linux-scsi@vger.kernel.org>; Fri, 29 Apr 2005 15:20:15 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j3TLKEQv014233
	for <linux-scsi@vger.kernel.org>; Fri, 29 Apr 2005 15:20:14 -0600
In-Reply-To: <1114803919.16658.8.camel@haakon>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, iscsi-initiator-core-devel <iscsi-initiator-core-devel@iscsi-initiator-core.org>

Nicholas A. Bellinger wrote:
> On Wed, 2005-04-27 at 20:11 -0700, Mike Christie wrote:
> 
>>Nicholas A. Bellinger wrote:
>>
>>>This patch against 2.6.12-rc3 is the first step for scsi_transport_iscsi
>>>getting iSCSI Keys defined in RFC 3720 Section 12 and other values not
>>>defined in this section as keys, but need to be exported out via sysfs
>>>into the correct connection/session contexts.
>>>
>>>Currently, scsi_transport_iscsi.[c,h] assume that all values are on a
>>>per session basis.  These changes have been tested with the upcoming
>>>iSCSI transport class enabled release of iscsi-initiator-core
>>>(1.6.2.0-rc2), and should hopefully be 'breakage-free' with sfnet.
>>>
>>>Comments?
>>>
>>>
>>>
>>>------------------------------------------------------------------------
>>>
>>>diff -urN linux-2.6.12-rc3/drivers/scsi/scsi_transport_iscsi.c linux-2.6.12-rc3-iscsi/drivers/scsi/scsi_transport_iscsi.c
>>>--- linux-2.6.12-rc3/drivers/scsi/scsi_transport_iscsi.c	2005-04-27 15:02:03.000000000 -0700
>>>+++ linux-2.6.12-rc3-iscsi/drivers/scsi/scsi_transport_iscsi.c	2005-04-27 17:36:20.000000000 -0700
>>>@@ -3,6 +3,8 @@
>>>  *
>>>  * Copyright (C) IBM Corporation, 2004
>>>  * Copyright (C) Mike Christie, 2004
>>>+ * Copyright (C) PyX Technologies, 2005
>>>+ * Copyright (C) Nicholas A. Bellinger <nab@kernel.org>
>>>  *
>>>  * This program is free software; you can redistribute it and/or modify
>>>  * it under the terms of the GNU General Public License as published by
>>>@@ -25,7 +27,8 @@
>>> #include <scsi/scsi_transport.h>
>>> #include <scsi/scsi_transport_iscsi.h>
>>> 
>>>-#define ISCSI_SESSION_ATTRS 20
>>>+#define ISCSI_CONNECTION_ATTRS 9
>>>+#define ISCSI_SESSION_ATTRS 15
>>> #define ISCSI_HOST_ATTRS 2
>>> 
>>> struct iscsi_internal {
>>>@@ -34,6 +37,7 @@
>>> 	/*
>>> 	 * We do not have any private or other attrs.
>>> 	 */
>>>+	struct class_device_attribute *connection_attrs[ISCSI_CONNECTION_ATTRS + 1];
>>
>>How are these attrs getting set up? By the LLD? Patch does not work for me;
>>nothing shows up btw.
>>
> 
> 
> Whoops, I forgot to mention that the includes of the local
> scsi_transport_scsi.h in linux-iscsi-4.0.1.11 need to be changed from
> "scsi_transport_iscsi.h" to <scsi/scsi_transport_iscsi.h>.  I assume
> this was failing because of the changes to struct
> iscsi_function_template in the patch.
> 
> 
>>The reason all the settings are stuck on the session was becuase we couldn't
>>come to an agreement on the layout. We wanted to do something like this:
>>
>>/sys/class/iscsi_session/iscsi_connection
>>
>>or even
>>
>>/sys/class/iscsi_session
>>/sys/class/iscsi_connection
>>
> 
> 
> I am still thinking on this one.  First and foremost I think that we
> need to get move towards a single class for iSCSI Initiators instead of
> what is currently registered (/sys/class/iscsi_transport
> and /sys/class/iscsi_host).  Let me keep working on this some more and I
> will draft up a prosposal in the near future.  Any futher input is
> welcomed. :-)
> 

get everyone to agree (or force them) on how to set the initiarname and alias
and the iscsi_host can be chopped. the iscsi_host is only there becuase sfnet
used a /etc file and I think you can set the initiatorname on some HW cards
from a BIOS/OF prompt (or you will not have control over it) so if they ever
end up on the same box and wanted to konw what each one ended up as you could.


