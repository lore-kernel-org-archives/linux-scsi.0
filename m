From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: further testing w/ multipath ... and bugs
Date: Mon, 13 Jun 2005 20:56:50 +0200
Message-ID: <1118689011.1515.2.camel@zezette>
References: <20050613081154.GA28251@averon.dyndns.org>
	<20050613182042.GA24059@plap.qlogic.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050613182042.GA24059@plap.qlogic.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> > qla2300 0000:05:0d.0: LOOP DOWN detected.
> > Debug: sleeping function called from invalid context at include/linux/rwsem.h:43
> > in_atomic():1, irqs_disabled():1
> >  [<c0120a74>] __might_sleep+0xa4/0xc0
> >  [<c026a466>] device_for_each_child+0x26/0x80
> >  [<c02b3180>] target_block+0x0/0x30
> >  [<c02bbdae>] fc_remote_port_block+0x2e/0x60
> >  [<c02bdbf5>] qla2x00_mark_all_devices_lost+0x55/0x60
> >  [<c02c597e>] qla2x00_async_event+0x83e/0xd60
> >  [<c011dd2b>] find_busiest_group+0xbb/0x310
> >  [<c02cdce4>] sd_rw_intr+0x164/0x320
> >  [<c02c4e37>] qla2300_intr_handler+0x77/0x240
> >  [<c0144882>] handle_IRQ_event+0x32/0x70
> 
> Without wanting to making a number of large changes to the qla2xxx
> internals to deal with these pre-qualifications, could you try the
> following patch (lightly tested with latest linus git tree).  
> 
> We'll need to update the fc_remote_port docs in order to account for
> this semantic change in device_for_each_child().
> 
Indeed, it fixed this bug. Thanks for the prompt fix.

This leaves us with DM related bugs only :/

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
