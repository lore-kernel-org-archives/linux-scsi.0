From: Changlimin <changlimin@h3c.com>
Subject: RE: A qla2xxx commit cause Linux no response, has not fixed in
 lastest version 4.15-rc6
Date: Tue, 16 Jan 2018 06:49:06 +0000
Message-ID: <BC29A004BA570342A4CC0044A3845572010DCF8560@H3CMLB12-EX.srv.huawei-3com.com>
References: <BC29A004BA570342A4CC0044A3845572010DCF3E30@H3CMLB12-EX.srv.huawei-3com.com>
 <1515821296.24576.94.camel@haakon3.daterainc.com>
 <74BFA730-FDBB-4912-B4E3-734A84C6A63A@cavium.com>
 <BC29A004BA570342A4CC0044A3845572010DCF828D@H3CMLB12-EX.srv.huawei-3com.com>
 <8E5E47EC-8184-4D07-96D5-9D41E3D4520D@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.h3c.com ([60.191.123.56]:42609 "EHLO h3cmg01-ex.h3c.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750740AbeAPGtg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Jan 2018 01:49:36 -0500
In-Reply-To: <8E5E47EC-8184-4D07-96D5-9D41E3D4520D@cavium.com>
Content-Language: zh-CN
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Tran, Quinn" <Quinn.Tran@cavium.com>, Jifuliang <fuliang_ji@h3c.com>, Zhangguanghui <zhang.guanghui@h3c.com>, Zhangzijian <zhang.zijian@h3c.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Hi Himanshu,
   This is my progress.
   First, I compiled 4.15-rc6, I found linux hang when booting, the stack showed something wrong in qla2xxx driver.
   Second, I want to find which commit introduced the issue. So I tried many times via git bisect to linux kernel.
   Finally, I found the commit 726b85487067d7f5b23495bc33c484b8517c4074 introduced the issue. The attached log is related to this commit.
   Also ubuntu kernel has this issue: 
   https://launchpad.net/ubuntu/+archive/primary/+files/linux-image-4.13.0-25-generic_4.13.0-25.29_amd64.deb
   https://launchpad.net/ubuntu/+archive/primary/+files/linux-image-extra-4.13.0-25-generic_4.13.0-25.29_amd64.deb

Regards
Chang Limin

-----Original Message-----
From: Madhani, Himanshu [mailto:Himanshu.Madhani@cavium.com] 
Sent: Tuesday, January 16, 2018 12:59 PM
To: changlimin (Cloud)
Cc: Nicholas A. Bellinger; Tran, Quinn; jifuliang (Cloud); zhangguanghui (Cloud); zhangzijian (Cloud); target-devel; linux-scsi
Subject: Re: A qla2xxx commit cause Linux no response, has not fixed in lastest version 4.15-rc6

Hi Chang, 

> On Jan 15, 2018, at 4:27 PM, Changlimin <changlimin@h3c.com> wrote:
> 
> Hi Himanshu,
>  The issue is: When insmod the qla2xxx.ko from 4.15-rc6, linux hang.

>From the log file attached. I see that you are trying to load driver from 4.9.x in 4.15.0-rc6. 

[  279.898704] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.07.00.38-k-debug.

4.15.0-rc6 had driver version 10.00.00.02-k. Would you check if you have all the driver changes pulled in with kernel 4.15.0-rc6.

>  I have git bisect the commits. 
>  The issue was introduced in commit: 726b85487067d7f5b23495bc33c484b8517c4074 qla2xxx: Add framework for async fabric discovery.
>  The previous commit is good: 5d964837c6a743193c63c8912f98834c7457ba5c qla2xxx: Track I-T nexus as single fc_port struct .
> 
> Regards
> Chang Limin
> 
> -----Original Message-----
> From: Madhani, Himanshu [mailto:Himanshu.Madhani@cavium.com]
> Sent: Tuesday, January 16, 2018 12:58 AM
> To: Nicholas A. Bellinger
> Cc: changlimin (Cloud); Tran, Quinn; jifuliang (Cloud); zhangguanghui 
> (Cloud); zhangzijian (Cloud); target-devel; linux-scsi
> Subject: Re: A qla2xxx commit cause Linux no response, has not fixed 
> in lastest version 4.15-rc6
> 
> Hi Nic, Chang,
> 
>> On Jan 12, 2018, at 9:28 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
>> 
>> Hi Chang & Co,
>> 
>> (Adding list + Himanshu CC')
>> 
>> On Sun, 2018-01-07 at 10:21 +0000, Changlimin wrote:
>>> Hi,
>>> It seems the qla2xxx commit cause Linux no response, has not fixed in lastest version 4.15-rc6.
>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.
>>> g
>>> it/commit/?id=726b85487067d7f5b23495bc33c484b8517c4074
>>> 
>> 
>> Thanks for reporting + including debug log.  :)
>> 
>>> lspci:
>>> 0a:00.0 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel 
>>> to PCI Express HBA (rev 02)
>>> 0a:00.1 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel 
>>> to PCI Express HBA (rev 02)
>>> 
>>> syslog:
>>> qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.07.00.38-k.
>>> qla2xxx [0000:0a:00.0]-001a: : MSI-X vector count: 32.
>>> qla2xxx [0000:0a:00.0]-001d: : Found an ISP2532 irq 16 iobase 0xffffb0d5cc501000.
>>> qla2xxx [0000:0a:00.0]-00c6:1: MSI-X: Failed to enable support with 32 vectors, using 26 vectors.
>>> scsi host1: qla2xxx
>>> qla2xxx [0000:0a:00.0]-00fb:1: QLogic HPAJ764A - HP 8Gb Dual Channel PCI-e 2.0 FC HBA.
>>> qla2xxx [0000:0a:00.0]-00fc:1: ISP2532: PCIe (5.0GT/s x8) @ 0000:0a:00.0 hdma+ host#=1 fw=8.03.00 (90d5).
>>> qla2xxx [0000:0a:00.1]-001a: : MSI-X vector count: 32.
>>> qla2xxx [0000:0a:00.1]-001d: : Found an ISP2532 irq 17 iobase 0xffffb0d5cc5d9000.
>>> qla2xxx [0000:0a:00.1]-00c6:2: MSI-X: Failed to enable support with 32 vectors, using 26 vectors.
>>> scsi host2: qla2xxx
>>> qla2xxx [0000:0a:00.1]-00fb:2: QLogic HPAJ764A - HP 8Gb Dual Channel PCI-e 2.0 FC HBA.
>>> qla2xxx [0000:0a:00.1]-00fc:2: ISP2532: PCIe (5.0GT/s x8) @ 0000:0a:00.1 hdma+ host#=2 fw=8.03.00 (90d5).
>>> qla2xxx [0000:0a:00.0]-500a:1: LOOP UP detected (8 Gbps).
>>> qla2xxx [0000:0a:00.1]-500a:2: LOOP UP detected (8 Gbps).
>>> 
>>> The attached file is the module log.
>>> 
>>> Do you have any advice?
>> 
>> Quinn & Himanshu folks, any comments..?
>> 
> 
> What is the issue here? I am not clear form the snippet above.
> 
> One thing I noticed that, if you are using 4.15-rc6 driver version 
> should be 10.00.00.02-k but the snippet shows 8.07.00.38-k which tells 
> me you might
> 
> Thanks,
> - Himanshu
> <qla2xxx-full.log.gz>

Thanks,
- Himanshu
