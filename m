From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Stale devices in sysfs
Date: Fri, 27 Mar 2009 09:37:18 -0400
Message-ID: <49CCD68E.6080201@emulex.com>
References: <635936.80425.qm@web32508.mail.mud.yahoo.com> <1238103888.3342.67.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:38791 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbZC0NhY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2009 09:37:24 -0400
In-Reply-To: <1238103888.3342.67.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ahmed A <ahmedcali@yahoo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



James Bottomley wrote:
>> Thank you for your reply.  It is an Emulex 2 port FC hba (LPE11002),
>> using the inbox driver version 8.2.0.33.3p.  Yes, there have been some
>> disconnect, initiatied by me by disabling / enablling the port on the
>> target.  Even in these situations, wouldn't the driver remove the
>> old/stale mappings?  I am guessing from you response, there is no way
>> for me to clean-up the old ones.
> 
> The delete caused by rport removal is supposed to remove them.

This is true of upstream. But the hint is "inbox driver".  The distros added a 
tweak to the transport to allow an enable/disable teardown on removal, with 
default to teardown-disabled.  This was to work around issues with sdev 
reallocation, which Hannes has been working on for a while due to all its 
nuances, where the distro isn't quite in sync with what's upstream.

>  There
> should be a message in the logs, something like :
> 
> blocked FC remote port time out: removing target and saving binding
> 
> You can delete any of the devices by just doing
> 
> echo 1 > /sys/class/scsi_device/<h:c:t:l>/device/delete

This will always work.  Additionally, you can change the distro transport 
option by loading the fc transport with the module option "remove_on_dev_loss=1".

-- james s

> 
> 
>> As to figure out which ones are real, just use the sd mapping with the
>> latest target number, right?
> 
> Yes, the transport class allocates them from a per host incrementing
> variable.
> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
