From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [scsi:misc 102/104] drivers/scsi/fnic/fnic_fcs.c:381:31:
 sparse: cast to restricted __be16
Date: Sun, 24 Feb 2013 08:18:39 +0000
Message-ID: <1361693917.2457.1.camel@dabdike.int.hansenpartnership.com>
References: <5127c1e9.pbebaAT25aJl2osg%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0.parallels.com ([199.115.104.20]:43526 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab3BXISl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2013 03:18:41 -0500
In-Reply-To: <5127c1e9.pbebaAT25aJl2osg%fengguang.wu@intel.com>
Content-Language: en-US
Content-ID: <88DA06F74C59904DAF68C42E50C0EC6B@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Hiral Patel <hiralpat@cisco.com>, Anantha Prakash T <atungara@cisco.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 2013-02-23 at 03:07 +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
> head:   c2983bd66114a8047bb74e4d347db8ffde381f71
> commit: 5f0d0de727c055e15c2602e4905c6b75509ce9d7 [102/104] [SCSI] fnic: FIP VLAN Discovery Feature Support
> 
> 
> sparse warnings: (new ones prefixed by >>)
> 
> >> drivers/scsi/fnic/fnic_fcs.c:381:31: sparse: cast to restricted __be16
> >> drivers/scsi/fnic/fnic_fcs.c:381:31: sparse: cast to restricted __be16
> >> drivers/scsi/fnic/fnic_fcs.c:381:31: sparse: cast to restricted __be16
> >> drivers/scsi/fnic/fnic_fcs.c:381:31: sparse: cast to restricted __be16
>    drivers/scsi/fnic/cq_enet_desc.h:142:39: sparse: restricted __le16 degrades to integer
>    include/scsi/fc/fc_fcoe.h:101:36: sparse: cast truncates bits from constant value (efc becomes fc)
>    include/scsi/fc/fc_fcoe.h:102:23: sparse: cast truncates bits from constant value (efc00 becomes 0)
> >> drivers/scsi/fnic/fnic_fcs.c:1198:6: sparse: context imbalance in 'fnic_handle_fip_timer' - different lock contexts for basic block
> 
> vim +381 drivers/scsi/fnic/fnic_fcs.c
> 
>    365			  "Received VLAN response...\n");
>    366	
>    367		fiph = (struct fip_header *) skb->data;
>    368	
>    369		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host,
>    370			  "Received VLAN response... OP 0x%x SUB_OP 0x%x\n",
>    371			  ntohs(fiph->fip_op), fiph->fip_subcode);
>    372	
>    373		rlen = ntohs(fiph->fip_dl_len) * 4;
>    374		fnic_fcoe_reset_vlans(fnic);
>    375		spin_lock_irqsave(&fnic->vlans_lock, flags);
>    376		desc = (struct fip_desc *)(fiph + 1);
>    377		while (rlen > 0) {
>    378			dlen = desc->fip_dlen * FIP_BPW;
>    379			switch (desc->fip_dtype) {
>    380			case FIP_DT_VLAN:
>  > 381				vid = ntohs(((struct fip_vlan_desc *)desc)->fd_vlan);
>    382				shost_printk(KERN_INFO, fnic->lport->host,
>    383					  "process_vlan_resp: FIP VLAN %d\n", vid);
>    384				vlan = (struct fcoe_vlan *) kmalloc(sizeof(*vlan),
>    385								GFP_ATOMIC);
>    386				if (!vlan) {
>    387					/* retry from timer */
>    388					spin_unlock_irqrestore(&fnic->vlans_lock,
>    389								flags);

OK, I'll drop the series from this patch on.  I take it the sparse and
other problems in the patches before this are all fixed?

James

