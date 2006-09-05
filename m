From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Question about scsi_qla_host_t.fcports list protection (qla2xxx)
Date: Tue, 05 Sep 2006 15:30:27 +0400
Message-ID: <44FD5FD3.5000407@vlnb.net>
References: <44E19F93.2020305@vlnb.net> <20060816175739.GS3674@andrew-vasquezs-computer.local> <44FD4C99.9060308@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out-relay-03.infobox.ru ([85.249.135.212]:51670 "EHLO
	out-relay-03.infobox.ru") by vger.kernel.org with ESMTP
	id S1751331AbWIELbH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Sep 2006 07:31:07 -0400
In-Reply-To: <44FD4C99.9060308@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com

Vladislav Bolkhovitin wrote:
> Andrew Vasquez wrote:
> 
>> On Tue, 15 Aug 2006, Vladislav Bolkhovitin wrote:
>>
>>
>>> Looking at the qla2xxx driver source code I noticed that 
>>> scsi_qla_host_t.fcports is used without any protection. For instance, 
>>> qla2x00_loop_reset() walks over this list. This function is called 
>>> from qla2xxx_eh_bus_reset(), which could be called at any time. What 
>>> does protect fcports from being changed, eg, by some async loop event 
>>> during the walking and eventually oops'ing? Do I miss something? 
>>> There are many such unprotected fcports list usages in the driver.
>>
>>
>>
>> Nothing is ever removed from the fcports list during driver execution.
>> fcports are also only added from a single context (post init-time)
>> within the DPC thread. 
> 
> 
> How about qla2x00_send_login_iocb_cb(), where an entry is added to 
> fcports list and which is called from IRQ context from 
> qla2x00_process_iodesc()?

Sorry for the noise, I just checked in 2.6.18-rc6 and from it all that 
code was removed. Anyway, the problem with unsafe fcports list iterating 
remains valid.

Vlad

>> We are safe here.
> 
> 
>> Regards,
>> Andrew Vasquez
>>
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

