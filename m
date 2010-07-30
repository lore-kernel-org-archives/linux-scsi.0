From: James Smart <james.smart@emulex.com>
Subject: Re: dev_loss_tmo behavior question
Date: Fri, 30 Jul 2010 13:28:34 -0400
Message-ID: <4C530BC2.40200@emulex.com>
References: <4C4F4B94.1070009@cs.wisc.edu> <4C5055AA.7080703@emulex.com> <20100728165707.GA9844@plapp.qlogic.org> <4C530A2D.5070507@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:40137 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759241Ab0G3R3H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jul 2010 13:29:07 -0400
In-Reply-To: <4C530A2D.5070507@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, "Love, Robert W" <robert.w.love@intel.com>, Jing Huang <huangj@Brocade.COM>



Mike Christie wrote:
> On 07/28/2010 11:57 AM, Andrew Vasquez wrote:
>> I'm curious though, each driver would still need to seed the rport's
>> dev_loss_tmo value (in the case of qla2xxx,
>> ha->port_down_retry_count), but, by doing so after rport-addition
>> (fc_remote_port_add()), the driver could still overwrite a previous
>> sysfs setting.  Internally, upon rport creation, the dev_loss_tmo
>> value is seeding with fc_dev_loss_tmo (a module parameter -- 60
>> seconds).  Should we extend the transport so the the 'default seeding
>> value' can be specified once at fc_host creation-time?
>>
> 
> I was going to add a fc_transport callout that gets called when the 
> rport is allocated so drivers can do other rport initialization if they 
> wanted. It is only called the first time when it is actually allocated 
> not every time fc_remote_port_add is called. Would that be more useful?

I would assume this is a fc_host attribute, used in fc_remote_port_add.

Per your last sentence, I assume :
if the rport comes back within the devloss window it definitely is kept to the 
last value set in the rport

if devloss expires, only if you have target id bindings (where you keep the 
rport struct as a container for the binding, thus it is part of the saved 
binding) would you keep the last value set, and it only applies if the binding 
matches.

if no target id bindings, then it would be set again to the fc_host value when 
fc_remote_port_add() is called.


-- james s

