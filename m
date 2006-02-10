From: Tejun Heo <htejun@gmail.com>
Subject: Re: Regarding ordered-tag support.
Date: Fri, 10 Feb 2006 09:45:16 +0900
Message-ID: <43EBE21C.2020803@gmail.com>
References: <43E99248.7090505@gmail.com>	 <1139413766.3003.19.camel@mulgrave.il.steeleye.com>	 <43EA17E6.4000800@gmail.com> <43EA1B75.40008@emulex.com>	 <43EA2313.9030506@gmail.com>	 <1139418451.3003.37.camel@mulgrave.il.steeleye.com>	 <43EA27E4.9080105@gmail.com>	 <1139419637.3003.43.camel@mulgrave.il.steeleye.com>	 <43EA329F.2000906@pobox.com>  <43EAC110.5030700@gmail.com> <1139505635.3275.43.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pproxy.gmail.com ([64.233.166.176]:12989 "EHLO pproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1750894AbWBJApV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2006 19:45:21 -0500
Received: by pproxy.gmail.com with SMTP id 57so130388pya
        for <linux-scsi@vger.kernel.org>; Thu, 09 Feb 2006 16:45:20 -0800 (PST)
In-Reply-To: <1139505635.3275.43.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James.Smart@Emulex.Com, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello, James.

James Bottomley wrote:
> 
> The fact that tasks can proceed in parallel, only the command components
> individual linked tasks must be serialised. so it supports the TCQ
> paradigm.
> 
> Really, also, linked tasks is exactly what a JFS wants because most of
> the updates that would be linked are something like update log entry;
> modify metadata (or data); remove log entry.
> 

I see your point, so it's not really a barrier anymore, but a sequence
of ordered writes with an intervening flush independent of other
unrelated writes.  Some random thoughts...

* All writes in the ordered sequence will have to be done sequentially,
but unrelated writes are not affected.  This can be overall gain.

* Can be implemented in block layer proper without using SCSI linked
task (probably with separate ->ordered_requests queue).  What would be
the advantage of SCSI linked task?

* As it's finer grained than wholesale barrier, FS layer will need to
pay more attention.

Thanks for the explanation.  :-)

-- 
tejun
