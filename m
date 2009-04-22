From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] fc transport: pre-emptively terminate i/o upon dev_loss_tmo
Date: Wed, 22 Apr 2009 12:19:10 -0400
Message-ID: <49EF437E.6040506@emulex.com>
References: <20090409130439.042ff514@rwuerthntp>	<49EE3E0D.7000403@cs.wisc.edu>	<49EE403B.8060005@cs.wisc.edu>	<49EE44C2.3060800@cs.wisc.edu> <20090422141323.330c7f78@rwuerthntp>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52349 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZDVQTY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 12:19:24 -0400
In-Reply-To: <20090422141323.330c7f78@rwuerthntp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ralph Wuerthner <ralphw@linux.vnet.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

All the flushes and workq stuff is very tricky. We (Mike Reed and I) had 
a devil of a time with it on large SMP systems. So adding these quickly 
is not advised.

I believe what we need to do is add a synchronization between the delete 
and the add sequences, which right now, expect the workq and flushing to 
provide it, but left other code paths, where it had to release the locks 
post the state change, at risk. Let me put something together.

-- james s

Ralph Wuerthner wrote:
> Your patch does not work: you are canceling the fast_fail work and
> dev_loss work without initializing rport first. 
>
> We have to make sure that fc_remote_port_add(),
> fc_remote_port_delete(), and fc_timeout_deleted_rport() do not
> interfere with each other. Unfortunately I don't know yet how. I have to
> think more about this.
>
>   
