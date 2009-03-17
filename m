From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC][PATCH 5/6] fnic: add descriptor right, buffers, device
 interface
Date: Tue, 17 Mar 2009 11:41:10 -0500
Message-ID: <49BFD2A6.9030200@cs.wisc.edu>
References: <20090228022152.12158.11200.stgit@feynman.nuovasystems.com> <20090228023230.12158.72176.stgit@feynman.nuovasystems.com> <49B97403.4020302@cs.wisc.edu> <9E88C8678BF34240A8C61D4078A3D251A4A39F@xmb-sjc-23e.amer.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45137 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317AbZCQQlq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Mar 2009 12:41:46 -0400
In-Reply-To: <9E88C8678BF34240A8C61D4078A3D251A4A39F@xmb-sjc-23e.amer.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Abhijeet Arvind Joglekar (abjoglek)" <abjoglek@cisco.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, "Joe Eykholt (jeykholt)" <jeykholt@cisco.com>

Abhijeet Arvind Joglekar (abjoglek) wrote:
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org 
>> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Mike Christie
>> Sent: Thursday, March 12, 2009 1:44 PM
>> To: Abhijeet Arvind Joglekar (abjoglek)
>> Cc: james.bottomley@hansenpartnership.com; 
>> linux-scsi@vger.kernel.org; Joe Eykholt (jeykholt)
>> Subject: Re: [RFC][PATCH 5/6] fnic: add descriptor right, 
>> buffers, device interface
>>
>> Abhijeet Joglekar wrote:
>>> diff --git a/drivers/scsi/fnic/vnic_cq.h 
>> b/drivers/scsi/fnic/vnic_cq.h 
>>> new file mode 100644 index 0000000..4ede680
>>> --- /dev/null
>>> +++ b/drivers/scsi/fnic/vnic_cq.h
>>
>>> +
>>> +/*
>>> + * These defines avoid symbol clash between fnic and enic 
>> (Cisco 10G Eth
>>> + * Driver) when both are built with CONFIG options =y
>>> + */
>>> +#define vnic_cq_service fnic_cq_service
>>> +#define vnic_cq_free fnic_cq_free
>>> +#define vnic_cq_alloc fnic_cq_alloc
>>> +#define vnic_cq_init fnic_cq_init
>>> +#define vnic_cq_clean fnic_cq_clean
>>> +
>> Are these functions implementations the same as the net ones? I only 
>> looked at the first one and it looked the same.
> 
> Yes, they are the same, it is the low-level queue/buffer code that we
> wanted to share across enic and fnic. We did consider making a new
> module out of it, but its not a lot of code, and there was the problem

Normally I would just make it a new module, but I looked it over again 
and it is less than 100 lines so I am not sure if there is some point we 
say it is ok to duplicate code. Personally I would not like having to 
update multiple modules through two different maintainers (netdev and 
scsi). OTOH, updating the one module then making sure that two 
maintainers have the right code so their tress can compile can be tricky.


> of where the common files will reside, and how we share it across the
> net and scsi subsystems.
> 

I think it can live anywhere. The Kconfig and userspace module deps will 
make sure it gets built and loaded correctly.

> So, the plan was to re-define them for fnic (since enic is already
> integrated) and then go with what the kernel community thinks the best
> way is.
> 
