From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] qla2xxx: double free bug in qla2x00_probe_one
Date: Mon, 19 Jan 2009 10:50:46 +0900
Message-ID: <6.0.0.20.2.20090119103110.06f34868@172.19.0.2>
References: <6.0.0.20.2.20090116115911.06b02170@172.19.0.2>
 <A80C85DE-E35D-46A3-AA9F-2D790CAED442@qlogic.com>
 <6.0.0.20.2.20090119094611.06ce0720@172.19.0.2>
 <1232328133.3247.66.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:39933 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbZASBxc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Jan 2009 20:53:32 -0500
In-Reply-To: <1232328133.3247.66.camel@localhost.localdomain>
References: <6.0.0.20.2.20090116115911.06b02170@172.19.0.2>
 <A80C85DE-E35D-46A3-AA9F-2D790CAED442@qlogic.com>
 <6.0.0.20.2.20090119094611.06ce0720@172.19.0.2>
 <1232328133.3247.66.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Anirban Chakraborty <anirban.chakraborty@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


At 10:22 09/01/19, James Bottomley wrote:
>On Mon, 2009-01-19 at 09:59 +0900, Hisashi Hifumi wrote:
>> At 01:56 09/01/17, Anirban Chakraborty wrote:
>> 
>> >On Jan 15, 2009, at 7:13 PM, Hisashi Hifumi wrote:
>> >
>> >>Hi.
>> >>
>> >>I got double free bug at qla2x00_probe_one's error path and
>> >>kernel was panicked.
>> >>qla2x00_probe_one's probe_failed path is as follows:
>> >>
>> >>qla2x00_free_que(ha, req, rsp);
>> >>qla2x00_free_device(base_vha);
>> >>
>> >>qla2x00_free_device calls qla2x00_free_que through qla2x00_free_queues.
>> >>qla2x00_free_device frees the same pointer of req and rsp that is already 
>> >>freed by qla2x00_free_que.
>> >>
>> >>Following patch fixes this problem.
>> >>Thanks.
>> >This has been fixed as a part of the ISP restart bug fix. 
><http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=29bdccbee69c199910b2b39377e66ee5c33f241c>http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=29bdccbee69c199910b2b39377e66ee5c33f241c
>> >Thanks,
>> >Anirban
>> 
>> Your patch is as follows:
>> 
>>  probe_failed:
>> -       qla2x00_free_que(ha, req, rsp);
>>         qla2x00_free_device(base_vha);
>> 
>> 
>> I think just removing qla2x00_free_que here is wrong, because when 
>qla2x00_request_irqs or
>> qla2x00_alloc_queues fails, no one frees rsp and req.
>
>Aren't these freed by
>
>qla2x00_free_device()
>qla2x00_free_queues()
>qla2x00_free_que()
>
>along that path?
>
>James

Only qla2x00_free_que frees rsp and req above path, but just qla2x00_free_device
without qla2x00_free_que is ok after ha->rsp_q_map[0] and ha->req_q_map[0] definition
, such as failure of qla2x00_initialize_adapter , kthread_create or scsi_add_host.

