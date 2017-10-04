From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [BUG] scsi/fcoe: Sleep-in-atomic bugs in fcoe driver
Date: Wed, 4 Oct 2017 12:06:37 +0200
Message-ID: <20171004100637.pucskthcimhhen4k@linux-x5ow.site>
References: <a19f782f-b3f2-c954-f982-35574b36d605@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a19f782f-b3f2-c954-f982-35574b36d605@163.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@163.com>
Cc: jth@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 03, 2017 at 11:02:33AM +0800, Jia-Ju Bai wrote:
> According to fcoe_ctlr.c, the driver may sleep under a RCU lock,
> and the function call paths are:
> fcoe_ctlr_disc_stop_locked (acquire the RCU lock)
>   fc_rport_logoff
>     mutex_lock --> may sleep
> 
> fcoe_ctlr_vn_disc
>   fc_rport_login
>     mutex_lock --> may sleep
> 
> fcoe_ctlr_vn_age
>   fc_rport_logoff
>     mutex_lock --> may sleep
> 
> These bugs are found by my static analysis tool and my code review.
> 
> Thanks,
> Jia-Ju Bai
> 

Thanks for the report, coincidentally I have a bug report for this as well (in
a real setup not just static analysis) and gave the reporter a patch to test.
Once it's verified I'll post it here.

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
