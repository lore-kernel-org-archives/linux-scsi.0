From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] 2.6 aacraid: remove aac_handle_aif
Date: Wed, 8 Dec 2004 14:06:13 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B7F508C@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:31450 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261317AbULHTGY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Dec 2004 14:06:24 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Coughlan <coughlan@redhat.com>, linux-scsi@vger.kernel.org
Cc: alan@redhat.com, markh@osdl.org

As Tom noted, this patch is a result of a committee. I guess it would be
superfluous for these committee members to state `I like it' on the list
to 'vote' for its acceptance?

:-)

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Tom Coughlan [mailto:coughlan@redhat.com] 
Sent: Wednesday, December 08, 2004 11:12 AM
To: linux-scsi@vger.kernel.org
Cc: alan@redhat.com; markh@osdl.org; Salyzyn, Mark
Subject: [PATCH] 2.6 aacraid: remove aac_handle_aif

When aac_command_thread detects an adapter event (AifCmdDriverNotify or
AifCmdEventNotify) it calls aac_handle_aif. This routine sets a flag,
calls fib_adapter_complete, and returns. The bad news is that after the
return, aac_command_thread continues to process the command and calls
fib_adapter_complete again.   

Under some circumstances this causes the driver to take the device
offline. In my case, it happens with a Dell CERC SATA with a RAID 5 in
the "building" state:

aacraid: Host adapter reset request. SCSI hang ?
aacraid: Host adapter appears dead
scsi: Device offlined - not ready after error recovery: host 0 channel 0
id 0 lun 0
SCSI error : <0 0 0 0> return code = 0x6000000
end_request: I/O error, dev sda, sector 976537592

Mark Salyzyn says the intent is for aac_handle_aif to perform some
plug-n-play actions based on the adapter event, and return, leaving the
command completion to the caller. 

The attached patch solves the problem by removing aac_handle_aif
entirely, since it is wrong, and there is currently no code in the
driver to actually do anything with these events.

Thanks to Alan, Mark S., and Mark H. for looking this over.

Tom
