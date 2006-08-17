From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Question about scsi_qla_host_t.fcports list protection (qla2xxx)
Date: Thu, 17 Aug 2006 13:58:19 +0400
Message-ID: <44E43DBB.3030705@vlnb.net>
References: <44E19F93.2020305@vlnb.net> <20060816175739.GS3674@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out-relay-04.infobox.ru ([85.249.135.213]:30645 "EHLO
	out-relay-04.mailcluster.net") by vger.kernel.org with ESMTP
	id S932468AbWHQJ6m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Aug 2006 05:58:42 -0400
In-Reply-To: <20060816175739.GS3674@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-driver@qlogic.com, linux-scsi@vger.kernel.org

Andrew Vasquez wrote:
> On Tue, 15 Aug 2006, Vladislav Bolkhovitin wrote:
> 
> 
>>Looking at the qla2xxx driver source code I noticed that 
>>scsi_qla_host_t.fcports is used without any protection. For instance, 
>>qla2x00_loop_reset() walks over this list. This function is called from 
>>qla2xxx_eh_bus_reset(), which could be called at any time. What does 
>>protect fcports from being changed, eg, by some async loop event during 
>>the walking and eventually oops'ing? Do I miss something? There are many 
>>such unprotected fcports list usages in the driver.
> 
> 
> Nothing is ever removed from the fcports list during driver execution.
> fcports are also only added from a single context (post init-time)
> within the DPC thread.  We are safe here.

Sorry, I don't think so. For lockless iterating over a list concurrently 
with the addition to it you need to use *_rcu() list functions and do 
some RCU locking or, at least, disable preemption. Otherwise it is not safe.

Also, I don't think that keeping dead FC ports entries forever is a good 
idea. What does prevent you from deleting them, for instance, after 
fc_remote_port_delete() call?

Vlad
