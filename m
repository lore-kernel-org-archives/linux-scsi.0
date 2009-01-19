From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] qla2xxx: double free bug in qla2x00_probe_one
Date: Mon, 19 Jan 2009 09:59:46 +0900
Message-ID: <6.0.0.20.2.20090119094611.06ce0720@172.19.0.2>
References: <6.0.0.20.2.20090116115911.06b02170@172.19.0.2>
 <A80C85DE-E35D-46A3-AA9F-2D790CAED442@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:38300 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZASBCg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Jan 2009 20:02:36 -0500
In-Reply-To: <A80C85DE-E35D-46A3-AA9F-2D790CAED442@qlogic.com>
References: <6.0.0.20.2.20090116115911.06b02170@172.19.0.2>
 <A80C85DE-E35D-46A3-AA9F-2D790CAED442@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


At 01:56 09/01/17, Anirban Chakraborty wrote:

>On Jan 15, 2009, at 7:13 PM, Hisashi Hifumi wrote:
>
>>Hi.
>>
>>I got double free bug at qla2x00_probe_one's error path and
>>kernel was panicked.
>>qla2x00_probe_one's probe_failed path is as follows:
>>
>>qla2x00_free_que(ha, req, rsp);
>>qla2x00_free_device(base_vha);
>>
>>qla2x00_free_device calls qla2x00_free_que through qla2x00_free_queues.
>>qla2x00_free_device frees the same pointer of req and rsp that is already 
>>freed by qla2x00_free_que.
>>
>>Following patch fixes this problem.
>>Thanks.
>This has been fixed as a part of the ISP restart bug fix. <http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=29bdccbee69c199910b2b39377e66ee5c33f241c>http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=29bdccbee69c199910b2b39377e66ee5c33f241c
>Thanks,
>Anirban

Your patch is as follows:

 probe_failed:
-       qla2x00_free_que(ha, req, rsp);
        qla2x00_free_device(base_vha);


I think just removing qla2x00_free_que here is wrong, because when qla2x00_request_irqs or
qla2x00_alloc_queues fails, no one frees rsp and req.


