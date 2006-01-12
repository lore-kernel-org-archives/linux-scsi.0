From: "Zhikun Wang" <raidwang@gmail.com>
Subject: Re: Re: Calling scsi_done from queuecommand()
Date: Thu, 12 Jan 2006 17:47:36 +0800
Message-ID: <200601121747284849911@gmail.com>
References: <200601121157417180341@gmail.com> <1137052740.2936.7.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.200]:56360 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S964793AbWALJpt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 04:45:49 -0500
Received: by zproxy.gmail.com with SMTP id i11so343322nzh
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2006 01:45:48 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

>On Thu, 2006-01-12 at 11:57 +0800, Zhikun Wang wrote:
> Hi list, 
> 	Can we call scsi_done() to complete the I/O from the queuecommand() ? 

>>yes that should be fine *IF THE COMMAND COMPLETED*. (for example that
>>can be done for battery backed ram cards)

> (e.g. to make queuecommand synchronous). 
> 	I try this method in my LsiLogic 22320 SCSI card driver 

>>but... that sounds unlikely to be right. That is real scsi, which means
>>you have to wait a REALLY long time (easily 5 miliseconds) before the
>>command completes, and you cannot sleep in queuecommand (it's called
>>from interrupt context). So this sounds really fishy

I intend to use a global variable to make queuecommand synchronously. In the <queuecommand function> i set the global variable to 0.
	......
	global = 0;
	......
	while(!global)
    	barrier();
    SCpnt->scsi_done(SCpnt);
	......
When the command completes, in the <interrupt routine> i set the global variable to 1.
	......
	global = 1;
    ......
this method works for read command, but write command will stop at scsi_done routine and then timeout!
i am very puzzled about this!

> in Redhat9,

>>you do realize you're using a truely antique linux kernel/distribution
>>there, right? I suggest you go to a far more recent (and an actual
>>maintained) distribution

i know Redhat9 is out of time, but i must use this kernel/distribution
in my project!



