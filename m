From: Joe Jin <joe.jin@oracle.com>
Subject: bfa driver on xen
Date: Fri, 30 Apr 2010 17:33:50 +0800
Message-ID: <20100430093350.GA27777@joejin-pc.cn.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet14.oracle.com ([148.87.113.126]:24487 "EHLO
	rcsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759524Ab0D3TR1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2010 15:17:27 -0400
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121])
	by rcsinet14.oracle.com (Sentrion-MP-4.0.0/Sentrion-MP-4.0.0) with ESMTP id o3U9aSBD027655
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 30 Apr 2010 09:36:29 GMT
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: huangj@brocade.com, linux-scsi@vger.kernel.org
Cc: soeren.binner@oracle.com, haobo.zhou@oracle.com, joe.jin@oracle.com

Hi Jing Huang,

I'm Joe Jin from Oracle Linux team, recently we tried brocade device
on HP DL385 with OracleVM and  found the device could not worked for 
driver could not applied enough memory with below error message:

bfad[0]: memory allocation failed with num_sgpgs: 2048 
bfad[0]: trying to allocate memory with num_sgpgs: 1024 
bfad[0]: memory allocation failed with num_sgpgs: 1024 
bfad[0]: trying to allocate memory with num_sgpgs: 512 
bfad0 bfad_hal_mem_alloc failure 
Not enough memory to attach all Brocade HBA ports, System may need more 

I have did some investigated, here are some information:
OracleVM xen it 64bit and Dom0 is 32bit, the root cause is when 32bit Dom0
running on 64bit hypervisor(xen), it on compat mode and xen just allowed
to allocate 1M(order = 8) contiguous memory, if not of compat mode,
Dom0 would successed applied 2M(order=9) contiguous memory.

To let it the device works, we have to decrease driver config params
like num_sgpgs, reqq_size, rspq_size and so on, I'm not sure if 
there are some releations among them, also did not known what values
is good enough for performance, woule you like give me some advices
for those? we have to reduce bfa driver DMA memory no more than 1M.

Thanks,
Joe


