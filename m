From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: SMP pass through interface via bsg
Date: Tue, 03 Apr 2007 01:27:47 +0900
Message-ID: <20070403012747O.fujita.tomonori@lab.ntt.co.jp>
References: <1175486263.27675.11.camel@mulgrave.il.steeleye.com>
	<20070402214325Y.fujita.tomonori@lab.ntt.co.jp>
	<1175529721.3680.18.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:56325 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526AbXDBQ2Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 12:28:16 -0400
In-Reply-To: <1175529721.3680.18.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: fujita.tomonori@lab.ntt.co.jp, hch@infradead.org, dougg@torque.net, James.Smart@Emulex.Com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SMP pass through interface via bsg
Date: Mon, 02 Apr 2007 11:02:01 -0500

> On Mon, 2007-04-02 at 21:43 +0900, FUJITA Tomonori wrote:
> > From: James Bottomley <James.Bottomley@SteelEye.com>
> > > If you post the code, others who also have the hardware can try it
> > > too ...
> > 
> > I've attached a patch against Jens' bsg tree and uploaed a patch
> > against the sgv4-tools tree:
> > 
> > http://zaal.org/bsg/smp-test.diff
> > 
> > The sgv4-tools tree is at:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/tomo/sgv4-tools.git;a=summary
> > 
> > 
> > If everything works:
> > 
> > gazania:/sys/class/bsg# ls
> > end_device-0:0  end_device-0:1  expander-0:0  sas_host0  sda  sdb
> > 
> > gazania:/home/fujita/sgv4-tools# ./smp_test /sys/class/bsg/expander-0\:0
> > 
> > 
> > smp_test works like Doug's smp_rep_manufacturer.
> > 
> > Note that `smp_test /sys/class/bsg/expander-0\:0/` doesn't work.
> 
> Well, I get a lot further than Doug with aic94xx, but it still doesn't
> quite work.  This is the console output:

Thanks.

>  =======================
> sas: smp_execute_task: task to dev 500605b000001450 response: 0x0 status 0x82
> sas: smp_execute_task: task to dev 500605b000001450 response: 0x0 status 0x82
> sas: smp_execute_task: task to dev 500605b000001450 response: 0x0 status 0x82
> 
> The first huge dump is just complaining about a kzalloc GFP_KERNEL
> with irqs off in sas_smp_request.

Probably, this is due to a silly bug in sas_smp_fn (please replace
spin_unlock with spin_unclok_irq).


> I'll debug why the execute_task is failing when I get more time today.

Thanks.
