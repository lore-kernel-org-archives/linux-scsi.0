From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] make fc transport removal of target configurable
Date: Tue, 13 Jun 2006 14:35:39 -0500
Message-ID: <448F138B.2020109@sgi.com>
References: <448DF5DA.3070800@sgi.com> <20060613070714.GA16358@infradead.org> <448E9C34.6070707@emulex.com> <448EDCEB.50702@sgi.com> <7A809A3B-B514-4ADE-A717-595250103E56@egenera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:59879 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1751185AbWFMTf4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jun 2006 15:35:56 -0400
In-Reply-To: <7A809A3B-B514-4ADE-A717-595250103E56@egenera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve Byan <smb@egenera.com>
Cc: James.Smart@Emulex.Com, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>



Steve Byan wrote:
> On Jun 13, 2006, at 11:42 AM, Michael Reed wrote:
> 
>> Treating fibre channel like removable storage is wrong.  Fibre  
>> targets aren't
>> generally supposed to go away.  If they do, there's a significant  
>> chance
>> that they'll be repaired and returned to service.  It makes sense  
>> to keep
>> the infrastructure in place just like scsi, sas, iscsi, ata.
> 
> In both Fibre Channel SANs and iSCSI SANs, administrators in large  
> datacenters will re-zone devices with some regularity as they  
> redeploy applications among existing systems.

Yes, they will.  And don't they generally do this gracefully, i.e,
shut down access to file systems or devices before rezoning?  And when
the target is rezoned to the host again don't they expect to be able
to resume using it.  This patch allows that to happen with no
user intervention.

> 
>> The kind of disruption the current code can cause to systems with  
>> multi-terabytes
>> or petabytes of storage will be considered unacceptable in a  
>> production environment.
> 
> Agreed; but Fibre Channel and SAN devices _will_ come and go  
> dynamically.

My concern is when targets go in an uncontrolled manner.

> 
>> So, I also wish to encourage a reconsideration of the position that  
>> dead targets
>> should be removed.  Removing removable storage targets like  
>> firewire and usb
>> makes sense.  I just don't believe that the same applies to fibre  
>> channel
>> or other generally non-removable targets.
> 
> Think of removing a Fibre Channel or iSCSI device as "removing access  
> authorization". You're correct that these devices are not often  
> physically removed from the SAN, but access authorization may change  
> frequently.

When the target "self-removes" and "self-attaches" I want the existing
user of the target to be able to resume use.  By not removing the
infrastructure in these situations less disruption to a production
system occurs.  The existing "user" has to be tolerant of errors during
this period of absence if it wishs to resume use.

This patch allows that to happen if the admin so desires.

Mike


> 
> Regards,
> -Steve
