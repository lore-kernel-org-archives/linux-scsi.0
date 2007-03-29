From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [patch 2/3] libata: expose AN support to user space via sysfs
Date: Wed, 28 Mar 2007 22:19:53 -0400
Message-ID: <460B2249.4010200@pobox.com>
References: <20070328230108.597741522@intel.com> <20070328164450.b89d5156.kristen.c.accardi@intel.com> <460B0539.9040103@pobox.com> <460B1F6B.5050108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:49674 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964826AbXC2CT4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Mar 2007 22:19:56 -0400
In-Reply-To: <460B1F6B.5050108@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

Tejun Heo wrote:
> Jeff Garzik wrote:
>> Kristen Carlson Accardi wrote:
>>> Allow user space to determine if an ATAPI device supports
>>> async notification (AN) of media changes.  This is done by
>>> adding a new sysfs file "async_notification" to genhd.
>>> If the file reads 1, then the device supports async notification.  If 
>>> the file reads 0, it does not. A flag is set in the generic disk to 
>>> indicate whether
>>> or not AN is supported.  This flag is set by the SCSI
>>> subsystem when it registers with add_disk.  The SCSI
>>> system gets information from libata on whether the
>>> device supports AN during dev_configure.
>>> Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
>>>
>>
>> 3) I would make the contents of 'media_change_events' be a list of 
>> flags, rather than a boolean.  Thus, when AN is present, 
>> media_change_events would return "AN\n".  It would return "\n" (no 
>> flags) when AN is absent.  This permits future expansion of this 
>> capabilities reporting variable.
> 
> I'm not sure about this.  AN is kind of specific term for ATA while 
> media change event is generic.  So, I think the original approach is 
> okay.  No matter how the actual thing is implemented, it's the same 
> media change event and as long as event delivery interface is the same, 
> upper layer shouldn't care about how it's done.

AN is a generic concept that I feel will propagate elsewhere.

Though perhaps it should be in a 'capability_flags' file rather than a 
'media_change_event' file.

	Jeff



