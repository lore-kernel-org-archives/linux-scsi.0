From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Creating a subdirectory under fc_host statistics using fc_function_template
Date: Thu, 18 Dec 2008 12:22:38 -0500
Message-ID: <494A86DE.7020908@emulex.com>
References: <ddedcbc75baf.493faa75@usc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:39831 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbYLRRVR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Dec 2008 12:21:17 -0500
In-Reply-To: <ddedcbc75baf.493faa75@usc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: Krishna Gudipati <gudipati@usc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Smart, James" <James.Smart@Emulex.Com>

James,

What Krishna describes, is a need to add driver-specific attributes (and 
optionally a directory of attributes) to a class-level object. I 
attempted patches of a similar form when I was originally doing the 
fc_rports, which were rejected.

I believe the position is that we do not allow driver-specific things on 
the class objects, and drivers are limited in scope to only adding 
individual attributes to the scsi_host via the attribute list in the 
scsi_host_template.

I'd like to re-propose the patches to add driver-specific data to the FC 
class objects. Do you believe there's a change in heart to accepting 
this functionality before I start the work to create them ?

For example, I know that Emulex would have liked to add driver-specific 
state data to the rports.  And Krishna's proposal is another request.

-- james


Krishna Gudipati wrote:
> Hello Everyone,
> 
> I have a small question on how to create a sub-directory to store my driver specific data under fc_host statistics.
> 
> Currently i am using the fc_function_template's  .get_fc_host_stats to export all my fc_host statistics.
> 
> But now i need a way to create a directory under the /sys/class/fc_host/statistics
> 
> lets say /sys/class/fc_host/statistics/hba/ns_stats to store all the specific information regarding name_server or
> this type of information for different stats we want to collect. Basically we are thinking of having a hierarchy
> under the fc_host/statistics folder so that we can display our driver specific information in a much cleaner fashion.
> 
> I researched looking at the current "struct fc_function_template" under scsi_transport_fc.c but did not find a way where i can specify
> that i need to create a folder under this statistics folder. I am not aware as of now if this feature of creating a hierarchy of directories for fc_host stats is in development.
> 
> But we think that having our driver specific information under a subdirectory would make things look nicer.
> 
> Can any of you linux guru's help me understand if this feature is currently in development?
> or
> is there any good way to tweak in and create a new subdirectory under the fc_host stats using the current fc_function_template?
> 
> If this feature is not currently present or in dev can we add some code to the scsi_transport_fc.c to support this feature?
> 
> Because we have a lot of driver specific information and we don't want to dump everything under the stats which can make things look a little messy. So we are planning to have a hierarchy so that we can sort out these properly.
> 
> Any help in this regard is really appreciated.
> 
> thanks in advance,
> 
> 
> with regards,
> 
> KRISHNA CHAITANYA GUDIPATI
> MS CS(COMPUTER NETWORKS)
> UNIVERSITY OF SOUTHERN CALIFORNIA
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
