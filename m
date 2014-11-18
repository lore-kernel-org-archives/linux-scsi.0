From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] bnx2fc: do not add shared skbs to the fcoe_rx_list
Date: Tue, 18 Nov 2014 16:50:56 +0100
Message-ID: <1416325856.3764.1.camel@dhcp-27-107.brq.redhat.com>
References: <1406275372-3983-1-git-send-email-mlombard@redhat.com>
	  <53D21166.4090608@redhat.com>
	  <1408748523.3876.52.camel@lbirv-waie-lx2.broadcom.com>
	 <1415974030.3977.1.camel@dhcp-27-107.brq.redhat.com>
	 <alpine.OSX.2.00.1411141625350.2317@administrators-macbook-pro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbaKRPvG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2014 10:51:06 -0500
In-Reply-To: <alpine.OSX.2.00.1411141625350.2317@administrators-macbook-pro.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, hch@lst.de

Hi Chad,
Thanks.

CC James and Christoph

On Fri, 2014-11-14 at 16:26 -0500, Chad Dupuis wrote:
> Maurizio, we've been running this for a little while with no issues so 
> it's good to go from our perspective.
> 
> Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>
> 
> On Fri, 14 Nov 2014, Maurizio Lombardi wrote:
> 
> > Hi Chad,
> >
> > On Fri, 2014-08-22 at 16:02 -0700, Eddie Wai wrote:
> >> On Fri, 2014-07-25 at 10:12 +0200, Maurizio Lombardi wrote:
> >>>
> >>> On 07/25/2014 10:02 AM, Maurizio Lombardi wrote:
> >>>> In some cases, the fcoe_rx_list may contains multiple instances
> >>>> of the same skb (the so called "shared skbs").
> >>>>
> >>>> the bnx2fc_l2_rcv thread is a loop that extracts a skb from the list,
> >>>> modifies (and destroys) its content and the proceed to the next one.
> >>>> The problem is that if the skb is shared, the remaining instances will
> >>>> be corrupted.
> >>>>
> >>>> The solution is to use skb_share_check() before adding the skb to the
> >>>> fcoe_rx_list.
> >>>>
> >>>> [ 6286.808725] ------------[ cut here ]------------
> >>>> [ 6286.808729] WARNING: at include/scsi/fc_frame.h:173 bnx2fc_l2_rcv_thread+0x425/0x450 [bnx2fc]()
> >>>> [ 6286.808748] Modules linked in: bnx2x(-) mdio dm_service_time bnx2fc cnic uio fcoe libfcoe 8021q garp stp mrp libfc llc scsi_transport_fc scsi_tgt sg iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel e1000e ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper ptp cryptd hpilo serio_raw hpwdt lpc_ich pps_core ipmi_si pcspkr mfd_core ipmi_msghandler shpchp pcc_cpufreq mperf nfsd auth_rpcgss nfs_acl lockd sunrpc dm_multipath xfs libcrc32c ata_generic pata_acpi sd_mod crc_t10dif crct10dif_common mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit ata_piix drm_kms_helper ttm drm libata i2c_core hpsa dm_mirror dm_region_hash dm_log dm_mod [last unloaded: mdio]
> >>>> [ 6286.808750] CPU: 3 PID: 1304 Comm: bnx2fc_l2_threa Not tainted 3.10.0-121.el7.x86_64 #1
> >>>> [ 6286.808750] Hardware name: HP ProLiant DL120 G7, BIOS J01 07/01/2013
> >>>> [ 6286.808752]  0000000000000000 000000000b36e715 ffff8800deba1e00 ffffffff815ec0ba
> >>>> [ 6286.808753]  ffff8800deba1e38 ffffffff8105dee1 ffffffffa05618c0 ffff8801e4c81888
> >>>> [ 6286.808754]  ffffe8ffff663868 ffff8801f402b180 ffff8801f56bc000 ffff8800deba1e48
> >>>> [ 6286.808754] Call Trace:
> >>>> [ 6286.808759]  [<ffffffff815ec0ba>] dump_stack+0x19/0x1b
> >>>> [ 6286.808762]  [<ffffffff8105dee1>] warn_slowpath_common+0x61/0x80
> >>>> [ 6286.808763]  [<ffffffff8105e00a>] warn_slowpath_null+0x1a/0x20
> >>>> [ 6286.808765]  [<ffffffffa054f415>] bnx2fc_l2_rcv_thread+0x425/0x450 [bnx2fc]
> >>>> [ 6286.808767]  [<ffffffffa054eff0>] ? bnx2fc_disable+0x90/0x90 [bnx2fc]
> >>>> [ 6286.808769]  [<ffffffff81085aef>] kthread+0xcf/0xe0
> >>>> [ 6286.808770]  [<ffffffff81085a20>] ? kthread_create_on_node+0x140/0x140
> >>>> [ 6286.808772]  [<ffffffff815fc76c>] ret_from_fork+0x7c/0xb0
> >>>> [ 6286.808773]  [<ffffffff81085a20>] ? kthread_create_on_node+0x140/0x140
> >>>> [ 6286.808774] ---[ end trace c6cdb939184ccb4e ]---
> >>>>
> >>>> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> >>>> ---
> >>>>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 7 +++++++
> >>>>  1 file changed, 7 insertions(+)
> >>>>
> >>>> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> >>>> index 785d0d7..a190ab6 100644
> >>>> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> >>>> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> >>>> @@ -411,6 +411,7 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct net_device *dev,
> >>>>  	struct fc_frame_header *fh;
> >>>>  	struct fcoe_rcv_info *fr;
> >>>>  	struct fcoe_percpu_s *bg;
> >>>> +	struct sk_buff *tmp_skb;
> >>>>  	unsigned short oxid;
> >>>>
> >>>>  	interface = container_of(ptype, struct bnx2fc_interface,
> >>>> @@ -423,6 +424,12 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct net_device *dev,
> >>>>  		goto err;
> >>>>  	}
> >>>>
> >>>> +	tmp_skb = skb_share_check(skb, GFP_ATOMIC);
> >>>> +	if (!tmp_skb)
> >>>> +		goto err;
> >>>> +
> >>>> +	skb = tmp_skb;
> >>>> +
> >>>>  	if (unlikely(eth_hdr(skb)->h_proto != htons(ETH_P_FCOE))) {
> >>>>  		printk(KERN_ERR PFX "bnx2fc_rcv: Wrong FC type frame\n");
> >>>>  		goto err;
> >>>>
> >> Seems logical, but this patch requires some testing which ought to be
> >> verified by the Qlogic team.  Thanks.
> >
> > Any update about this?
> > Is the QLogic team still reviewing this patch?
> >
> > Thanks,
> > Maurizio Lombardi
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


