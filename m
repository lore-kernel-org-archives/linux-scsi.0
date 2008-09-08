From: David Miller <davem@davemloft.net>
Subject: Re: kernel 2.6.26.3 qla2xxx oopsing on Fire 280R
Date: Mon, 08 Sep 2008 14:23:51 -0700 (PDT)
Message-ID: <20080908.142351.00296600.davem@davemloft.net>
References: <20080904093929.GA29006@orion.carnet.hr>
	<20080908211331.GC22598@plap4-2.qlogic.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20080908211331.GC22598@plap4-2.qlogic.org>
Sender: sparclinux-owner@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: joy@entuzijast.net, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date: Mon, 8 Sep 2008 14:13:31 -0700

> That's odd, as fc_flush_work() is quite minimal:
> 
> 	static void
> 	fc_flush_work(struct Scsi_Host *shost)
> 	{
> 		if (!fc_host_work_q(shost)) {
> 			printk(KERN_ERR
> 				"ERROR: FC host '%s' attempted to flush work, "
> 				"when no workqueue created.\n", shost->hostt->name);
> 			dump_stack();
> 			return;
> 		}
> 
> 		flush_workqueue(fc_host_work_q(shost));
> 	}
> 
> there's not much chance here for a NULL-dereference.

There are several.

In this particular case, looking at the instruction dump, it appears
to be shost->shost_data is NULL in this case, via the expansion of
fc_host_work_q which is defined as:

#define fc_host_work_q(x) \
	(((struct fc_host_attrs *)(x)->shost_data)->work_q)

