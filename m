From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: Re: [PATCH] qla2xxx: double free bug in qla2x00_probe_one
Date: Fri, 16 Jan 2009 09:04:35 -0800
Message-ID: <FD89D7AB-1431-4F6E-9830-EC2F04EFB07C@qlogic.com>
References: <6.0.0.20.2.20090116115911.06b02170@172.19.0.2>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:1139 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934829AbZAPREh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jan 2009 12:04:37 -0500
In-Reply-To: <6.0.0.20.2.20090116115911.06b02170@172.19.0.2>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


On Jan 15, 2009, at 7:13 PM, Hisashi Hifumi wrote:

> Hi.
>
> I got double free bug at qla2x00_probe_one's error path and
> kernel was panicked.
> qla2x00_probe_one's probe_failed path is as follows:
>
> 	qla2x00_free_que(ha, req, rsp);
> 	qla2x00_free_device(base_vha);
>
> qla2x00_free_device calls qla2x00_free_que through  
> qla2x00_free_queues.
> qla2x00_free_device frees the same pointer of req and rsp that is  
> already
> freed by qla2x00_free_que.

This has been taken care of in the ISP restart bug fix patch. Please  
find it here:
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=29bdccbee69c199910b2b39377e66ee5c33f241c
Thanks,
Anirban

