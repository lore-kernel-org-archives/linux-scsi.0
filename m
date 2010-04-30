From: Jing Huang <huangj@Brocade.COM>
Subject: RE: bfa driver on xen
Date: Fri, 30 Apr 2010 14:13:28 -0700
Message-ID: <04391A4E90BB2149B010D22452FA1687B9AD2A5B@HQ-EXCH-6.corp.brocade.com>
References: <20100430093350.GA27777@joejin-pc.cn.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:40715 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756216Ab0D3VNf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Apr 2010 17:13:35 -0400
In-Reply-To: <20100430093350.GA27777@joejin-pc.cn.oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Jin <joe.jin@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "soeren.binner@oracle.com" <soeren.binner@oracle.com>, "haobo.zhou@oracle.com" <haobo.zhou@oracle.com>

Hi Joe,

Thanks for reporting the issue. We have noticed this during the netapp/oracal ovm test to include bfa driver as part of ovm distro. As a workaround, we suggested to set num_sgpg=512 and num_ios=512. 

We are working on a fix and it will be available in our 2.3 driver.

Regards,

Jing

>-----Original Message-----
>From: Joe Jin [mailto:joe.jin@oracle.com]
>Sent: Friday, April 30, 2010 2:34 AM
>To: Jing Huang; linux-scsi@vger.kernel.org
>Cc: soeren.binner@oracle.com; haobo.zhou@oracle.com; joe.jin@oracle.com
>Subject: bfa driver on xen
>
>Hi Jing Huang,
>
>I'm Joe Jin from Oracle Linux team, recently we tried brocade device
>on HP DL385 with OracleVM and  found the device could not worked for
>driver could not applied enough memory with below error message:
>
>bfad[0]: memory allocation failed with num_sgpgs: 2048
>bfad[0]: trying to allocate memory with num_sgpgs: 1024
>bfad[0]: memory allocation failed with num_sgpgs: 1024
>bfad[0]: trying to allocate memory with num_sgpgs: 512
>bfad0 bfad_hal_mem_alloc failure
>Not enough memory to attach all Brocade HBA ports, System may need more
>
>I have did some investigated, here are some information:
>OracleVM xen it 64bit and Dom0 is 32bit, the root cause is when 32bit Dom0
>running on 64bit hypervisor(xen), it on compat mode and xen just allowed
>to allocate 1M(order = 8) contiguous memory, if not of compat mode,
>Dom0 would successed applied 2M(order=9) contiguous memory.
>
>To let it the device works, we have to decrease driver config params
>like num_sgpgs, reqq_size, rspq_size and so on, I'm not sure if
>there are some releations among them, also did not known what values
>is good enough for performance, woule you like give me some advices
>for those? we have to reduce bfa driver DMA memory no more than 1M.
>
>Thanks,
>Joe
>

