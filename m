Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEACCC56202
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 09:28:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74D5D20756
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 09:28:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fdSJ/Hte"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgKKJ2O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Nov 2020 04:28:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39930 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726176AbgKKJ2N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Nov 2020 04:28:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605086891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eNo6Md/9dfVzilzM+6Lo5mUatEHgedivNh/U2R1OIMU=;
        b=fdSJ/Hteg252ORhambN/1QarURJ9x+yHrOY9KmTqnLAUF7uGfykM9GYvJR1XXL986iMbzF
        ZwLrHs89fldQ93gjXVUSpjt0T7ZT+W69gEygY68k1fEKTke6hUN+8dNbeyH3I/pR6msD4o
        Wn0Ah+ONDl+U/kkef38OWeNrnMiDTkY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-dZ-DS3yLOmKB2wip47gmdg-1; Wed, 11 Nov 2020 04:28:06 -0500
X-MC-Unique: dZ-DS3yLOmKB2wip47gmdg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7A1B188C129;
        Wed, 11 Nov 2020 09:28:02 +0000 (UTC)
Received: from T590 (ovpn-12-145.pek2.redhat.com [10.72.12.145])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 677EB5C1C4;
        Wed, 11 Nov 2020 09:27:47 +0000 (UTC)
Date:   Wed, 11 Nov 2020 17:27:43 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     John Garry <john.garry@huawei.com>, Qian Cai <cai@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        don.brace@microsemi.com, Bart Van Assche <bvanassche@acm.org>,
        dgilbert@interlog.com, paolo.valente@linaro.org,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        linux-block@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        esc.storagedev@microsemi.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        chenxiang66@hisilicon.com, luojiaxing@huawei.com,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH v8 17/18] scsi: megaraid_sas: Added support for shared
 host tagset for cpuhotplug
Message-ID: <20201111092743.GC545929@T590>
References: <d4f86cccccc3bffccc4eda39500ce1e1fee2109a.camel@redhat.com>
 <7624d3fe1613f19af5c3a77f4ae8fe55@mail.gmail.com>
 <d1040c06-74ea-7016-d259-195fa52196a9@huawei.com>
 <CAL2rwxoAAGQDud1djb3_LNvBw95YoYUGhe22FwE=hYhy7XOLSw@mail.gmail.com>
 <aaf849d38ca3cdd45151ffae9b6a99fe6f6ea280.camel@redhat.com>
 <0c75b881-3096-12cf-07cc-1119ca6a453e@huawei.com>
 <06a1a6bde51a66461d7b3135349641856315401d.camel@redhat.com>
 <db92d37c-28fd-4f81-7b59-8f19e9178543@huawei.com>
 <8043d516-c041-c94b-a7d9-61bdbfef0d7e@huawei.com>
 <CAL2rwxpQt-w2Re8ttu0=6Yzb7ibX3_FB6j-kd_cbtrWxzc7chw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL2rwxpQt-w2Re8ttu0=6Yzb7ibX3_FB6j-kd_cbtrWxzc7chw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 11, 2020 at 12:57:59PM +0530, Sumit Saxena wrote:
> On Tue, Nov 10, 2020 at 11:12 PM John Garry <john.garry@huawei.com> wrote:
> >
> > On 09/11/2020 14:05, John Garry wrote:
> > > On 09/11/2020 13:39, Qian Cai wrote:
> > >>> I suppose I could try do this myself also, but an authentic version
> > >>> would be nicer.
> > >> The closest one I have here is:
> > >> https://cailca.coding.net/public/linux/mm/git/files/master/arm64.config
> > >>
> > >> but it only selects the Thunder X2 platform and needs to manually select
> > >> CONFIG_MEGARAID_SAS=m to start with, but none of arm64 systems here have
> > >> megaraid_sas.
> > >
> > > Thanks, I'm confident I can fix it up to get it going on my Huawei arm64
> > > D06CS.
> > >
> > > So that board has a megaraid sas card. In addition, it also has hisi_sas
> > > HW, which is another storage controller which we enabled this same
> > > feature which is causing the problem.
> > >
> > > I'll report back when I can.
> >
> > So I had to hack that arm64 config a bit to get it booting:
> > https://github.com/hisilicon/kernel-dev/commits/private-topic-sas-5.10-megaraid-hang
> >
> > Boot is ok on my board without the megaraid sas card, but includes
> > hisi_sas HW (which enables the equivalent option which is exposing the
> > problem).
> >
> > But the board with the megaraid sas boots very slowly, specifically
> > around the megaraid sas probe:
> >
> > : ttyS0 at MMIO 0x3f00002f8 (irq = 17, base_baud = 115200) is a 16550A
> > [   50.023726][    T1] printk: console [ttyS0] enabled
> > [   50.412597][    T1] megasas: 07.714.04.00-rc1
> > [   50.436614][    T5] megaraid_sas 0000:08:00.0: FW now in Ready state
> > [   50.450079][    T5] megaraid_sas 0000:08:00.0: 63 bit DMA mask and 63
> > bit consistent mask
> > [   50.467811][    T5] megaraid_sas 0000:08:00.0: firmware supports msix
> >         : (128)
> > [   50.845995][    T5] megaraid_sas 0000:08:00.0: requested/available
> > msix 128/128
> > [   50.861476][    T5] megaraid_sas 0000:08:00.0: current msix/online
> > cpus      : (128/128)
> > [   50.877616][    T5] megaraid_sas 0000:08:00.0: RDPQ mode     : (enabled)
> > [   50.891018][    T5] megaraid_sas 0000:08:00.0: Current firmware
> > supports maximum commands: 4077       LDIO threshold: 0
> > [   51.262942][    T5] megaraid_sas 0000:08:00.0: Performance mode
> > :Latency (latency index = 1)
> > [   51.280749][    T5] megaraid_sas 0000:08:00.0: FW supports sync cache
> >         : Yes
> > [   51.295451][    T5] megaraid_sas 0000:08:00.0:
> > megasas_disable_intr_fusion is called outbound_intr_mask:0x40000009
> > [   51.387474][    T5] megaraid_sas 0000:08:00.0: FW provided
> > supportMaxExtLDs: 1       max_lds: 64
> > [   51.404931][    T5] megaraid_sas 0000:08:00.0: controller type
> > : MR(2048MB)
> > [   51.419616][    T5] megaraid_sas 0000:08:00.0: Online Controller
> > Reset(OCR)  : Enabled
> > [   51.436132][    T5] megaraid_sas 0000:08:00.0: Secure JBOD support
> > : Yes
> > [   51.450265][    T5] megaraid_sas 0000:08:00.0: NVMe passthru support
> > : Yes
> > [   51.464757][    T5] megaraid_sas 0000:08:00.0: FW provided TM
> > TaskAbort/Reset timeout        : 6 secs/60 secs
> > [   51.484379][    T5] megaraid_sas 0000:08:00.0: JBOD sequence map
> > support     : Yes
> > [   51.499607][    T5] megaraid_sas 0000:08:00.0: PCI Lane Margining
> > support    : No
> > [   51.547610][    T5] megaraid_sas 0000:08:00.0: NVME page size
> > : (4096)
> > [   51.608635][    T5] megaraid_sas 0000:08:00.0:
> > megasas_enable_intr_fusion is called outbound_intr_mask:0x40000000
> > [   51.630285][    T5] megaraid_sas 0000:08:00.0: INIT adapter done
> > [   51.649854][    T5] megaraid_sas 0000:08:00.0: pci id
> > : (0x1000)/(0x0016)/(0x19e5)/(0xd215)
> > [   51.667873][    T5] megaraid_sas 0000:08:00.0: unevenspan support    : no
> > [   51.681646][    T5] megaraid_sas 0000:08:00.0: firmware crash dump   : no
> > [   51.695596][    T5] megaraid_sas 0000:08:00.0: JBOD sequence map
> > : enabled
> > [   51.711521][    T5] megaraid_sas 0000:08:00.0: Max firmware commands:
> > 4076 shared with nr_hw_queues = 127
> > [   51.733056][    T5] scsi host0: Avago SAS based MegaRAID driver
> > [   65.304363][    T5] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG
> > MZ7KH1T9 404Q PQ: 0 ANSI: 6
> > [   65.392401][    T5] scsi 0:0:1:0: Direct-Access     ATA      SAMSUNG
> > MZ7KH1T9 404Q PQ: 0 ANSI: 6
> > [   79.508307][    T5] scsi 0:0:65:0: Enclosure         HUAWEI
> > Expander 12Gx16  131  PQ: 0 ANSI: 6
> > [  183.965109][   C14] random: fast init done
> >
> > Notice the 14 and 104 second delays.
> >
> > But does boot fully to get to the console. I'll wait for further issues,
> > which you guys seem to experience after a while.
> >
> > Thanks,
> > John
> "megaraid_sas" driver calls “scsi_scan_host()” to discover SCSI
> devices. In this failure case, scsi_scan_host() is taking a long time
> to complete, hence causing delay in system boot.
> With "host_tagset" enabled, scsi_scan_host() takes around 20 mins.
> With "host_tagset" disabled, scsi_scan_host() takes upto 5-8 mins.
> 
> The scan time depends upon the number of scsi channels and devices per
> scsi channel is exposed by LLD.
> megaraid_sas driver exposes 4 channels and 128 drives per channel.
> 
> Each target scan takes 2 seconds (in case of failure with host_tagset
> enabled).  That's why driver load completes after ~20 minutes. See
> below:
> 
> [  299.725271] kobject: 'target18:0:96': free name
> [  301.681267] kobject: 'target18:0:97' (00000000987c7f11):
> kobject_cleanup, parent 0000000000000000
> [  301.681269] kobject: 'target18:0:97' (00000000987c7f11): calling
> ktype release
> [  301.681273] kobject: 'target18:0:97': free name
> [  303.575268] kobject: 'target18:0:98' (00000000a8c34149):
> kobject_cleanup, parent 0000000000000000
> 
> In Qian's kernel .config, async scsi scan is disabled so in failure
> case SCSI scan type is synchronous.
> Below is the stack trace when scsi_scan_host() hangs:
> 
> [<0>] __wait_rcu_gp+0x134/0x170
> [<0>] synchronize_rcu.part.80+0x53/0x60
> [<0>] blk_free_flush_queue+0x12/0x30

Can this issue disappear by applying the following change?

diff --git a/block/blk-flush.c b/block/blk-flush.c
index e32958f0b687..b1fe6176d77f 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -469,9 +469,6 @@ struct blk_flush_queue *blk_alloc_flush_queue(int node, int cmd_size,
 	INIT_LIST_HEAD(&fq->flush_queue[1]);
 	INIT_LIST_HEAD(&fq->flush_data_in_flight);
 
-	lockdep_register_key(&fq->key);
-	lockdep_set_class(&fq->mq_flush_lock, &fq->key);
-
 	return fq;
 
  fail_rq:
@@ -486,7 +483,6 @@ void blk_free_flush_queue(struct blk_flush_queue *fq)
 	if (!fq)
 		return;
 
-	lockdep_unregister_key(&fq->key);
 	kfree(fq->flush_rq);
 	kfree(fq);
 }


Thanks, 
Ming

