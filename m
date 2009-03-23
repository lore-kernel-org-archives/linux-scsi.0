From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/5] bfa: Brocade BFA FC SCSI driver (bfad)
Date: Mon, 23 Mar 2009 12:17:23 -0500
Message-ID: <49C7C423.5010202@cs.wisc.edu>
References: <200903142003.n2EK39r4031547@blc-10-6.brocade.com> <49C27E95.4050401@cs.wisc.edu> <4C94DE2070B172459E4F1EE14BD2364E02B4B4A2@HQ-EXCH-5.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58737 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757326AbZCWRRf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Mar 2009 13:17:35 -0400
In-Reply-To: <4C94DE2070B172459E4F1EE14BD2364E02B4B4A2@HQ-EXCH-5.corp.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@Brocade.COM>
Cc: James.Bottomley@HansenPartnership.com, Krishna Gudipati <kgudipat@Brocade.COM>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>

Jing Huang wrote:
>>> +
>>> +	im_port->shost->hostdata[0] = (unsigned long)im_port;
>>
>>
>> I think I asked about this before. Why do you just not allocate the
> bfad
>> or im_port in the hostdata? What is the struct hierarchy? Do you have
>> one bfad for the entire HBA/pci_device then have a im_port for each
> port
>> on the hba?
>>
> 
> Thanks for review the code again. Yes, we have one bfad for each HBA
> port/pci device, and one im_port (im stands for initiator mode) for each
> scsi_host/vport. We can certainly allocate im_port in scsi_host_alloc()
> as you suggest, but currently we allocate all possible fc4 port
> (initiator/tgt/ipfc) in one function, and it is just more convenient to
> do it in one place.

I think the refcounting is off though. For example in the shutdown case, 
if someone is accessing a scsi host sysfs attr, bfad_im_scsi_host_free 
would release the drivers refcounts on the scsi_host and free the 
im_port, but the sysfs code could still be accessing the im port. The 
shost would still be there because the sysfs code took a refcount on 
kobject/kref, but the im port is now gone. When you allocate the port 
struct in the hostdata with scsi_host_alloc this type of issue is 
handled for you.
