From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] aic94xx: Use request_firmware() to provide SAS address
 if the adapter lacks one
Date: Tue, 09 Oct 2007 11:29:20 -0400
Message-ID: <470B9E50.2090205@emulex.com>
References: <20071008212553.GI16752@tree.beaverton.ibm.com> <20071008224832.GB11993@plap3.qlogic.org> <20071008235009.GB16003@tree.beaverton.ibm.com> <20071009001240.GA13922@plap3.qlogic.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:55781 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbXJIPaV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Oct 2007 11:30:21 -0400
In-Reply-To: <20071009001240.GA13922@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, James Bottomley <james.bottomley@steeleye.com>

Why do you prefer request_firmware() vs something over sysfs ?

Does environments like the kdump kernel also have access to data needed
by request_firmware() ?

-- james s


Andrew Vasquez wrote:
> On Mon, 08 Oct 2007, Darrick J. Wong wrote:
> 
>> On Mon, Oct 08, 2007 at 03:48:32PM -0700, Andrew Vasquez wrote:
>>
>>> So how about factoring that out to a transport-level interface.  How
>>> about something along the lines of the following patch, whereby the
>>> software driver upon detecting no valid WWPN, makes an upcall to each
>>> interface's 'request_wwn()'.  The data passed in from shost_gendev
>>> should be enough for some helper script to cull relevent device bits
>>> and perhaps offer some level of persistence...  Off base?
>> Hrm... jejb made a remark that it might be better to pass the
>> scsi_host's device into request_firmware() as your example does, so I'll
>> pitch in a patch to do likewise with libsas--the scsi_host knows the
>> actual device it's coming from, and userland can sort that all out later
>> anyway via DEVPATH.
>>
>> I suppose one could also have multiple scsi_hosts per PCI device, which
>> means that my first patch would stumble horribly in more than a few
>> cases.
> 
> This is done already in the FC case -- NPIV.  Though with that
> interface, the administrator is already responsible for assigning
> proper WWNN/WWPN during creation.
> 
>>> Darrick, forgive the FC example, I don't do SAS...
>> That's ok, I don't do FC. :)  Looks mostly good to me...
> 
> --
> av
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
