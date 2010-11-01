From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] ibmvscsis: Move to struct ibmvscsis_vdev usage in
	fabric configfs handlers
Date: Mon, 01 Nov 2010 15:25:46 -0700
Message-ID: <1288650346.7708.76.camel@haakon2.linux-iscsi.org>
References: <1288480434-29670-1-git-send-email-nab@linux-iscsi.org>
	 <20101102060030Z.fujita.tomonori@lab.ntt.co.jp>
	 <1288647462.7708.31.camel@haakon2.linux-iscsi.org>
	 <20101102070638M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38925 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0KAWaw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2010 18:30:52 -0400
In-Reply-To: <20101102070638M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, lxie@us.ibm.com, rcjenn@us.ibm.com, michaelc@cs.wisc.edu, James.Bottomley@suse.de, joel.becker@oracle.com

On Tue, 2010-11-02 at 07:15 +0900, FUJITA Tomonori wrote:
> On Mon, 01 Nov 2010 14:37:42 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > On Tue, 2010-11-02 at 06:05 +0900, FUJITA Tomonori wrote:
> > > On Sat, 30 Oct 2010 16:13:54 -0700
> > > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > > 
> > > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > > > 
> > > > This patch takes tomo-san original commit 94fdb0196151 and changes a handful
> > > > of important items wrt to the fabric configfs logic.
> > > > 
> > > > Firstly, this patch introduces struct ibmvscsis_vdev and converts the
> > > > VIO ibmvscsis_probe() and ibmvscsi_remove() callers to allocate/free
> > > > struct ibmvscsis_vdev instead of the original usage of struct ibmvscsis_tpg
> > > > which is intended to be allocated/freed respectively in ibmvscsis_make_tpg()
> > > > and ibmvscsis_drop_tpg() fabric configfs handlers.
> > > 
> > > What happens if an initiator sends a crq command before an user
> > > creates a tpg? Or what happens if an initiator sends a crq command
> > > after removing a tpg?
> > > 
> > 
> > Hmmm, good point.  So this would require ibmvscsis_queuecommand() to
> > check internal some ibmvscsi_tpg state to determine availability, and
> > reject incoming I/O otherwise.  The other operation would be to just
> > move crq queue creation/release for individual ibmvscsi_vdev into
> > ibmvscsis_make_tpg() and ibmvscsis_drop_tpg().
> 
> You don't need to create/release rcq. I think that enable/disable vio
> interrupts is enough.

<nod>, will do.

> 
> > I am suspecting the latter would bit slightly cleaner..
> 
> Probabably, however, I think that not returning any response to an
> initiator makes the initiator stall for some time.
> 
> 

Understood

> > > > Secondly, this patch changes the metadata that is used to determine the
> > > > fabric WWN and TPGT (collectively the TCM VIO SRP endpoint) layout for
> > > > /sys/kernel/config/target/ibmvscsis/$WWN/tpgt_$TPGT/.  This patch will
> > > > now use struct vio_dev->unit_address for $WWN, and dev_name(vio_dev->dev)
> > > > for $TPGT.
> > > 
> > > I don't care much about this but vio_dev->unit_address ==
> > > dev_name(vio_dev->dev), I think. See vio_register_device_node() in
> > > arch/powerpc/kernel/vio.c. So it's odd a bit.
> > > 
> > 
> > Hmmmm..
> > 
> > > ibmvscsis model doesn't strictly follow the SRP SCSI model; no port,
> > > wwpn, etc. 
> > > 
> > 
> > Correct, which means we need to find a value to build a WWPN that is
> > both unique to the individual POWER machine, and is persisent across
> > reports..
> 
> I think that vio_dev->unit_address can be used to identify a nexus
> uniquely. It's not WWPN though. It's a connection between an initiator
> lpar and a target lpar.

Ok, then I think we will want to generate an emulated SRP WWN in
userspace based on partially based on system_id (via existing sysfs code
I assume..?) and drop the ->unit_address check in ibmvscsis_make_tpg()
and continue use the dev_name(vio_dev->dev) for the TPGT part of the WWN
+TPGT.   This also means we need a TCM/ibmvscsis internal method to
ensure that each ibmvscsis_vdev is only mapped 1:1 for ibmvscsis_tport
+ibmvscsi_tpg target_core_fabric_configfs.c callers..

>From there VIO SRP WWPNs present in /sys/kernel/config/target/ibmvscsis/
explictly configured by enduser can be saved into 
/etc/target/ibmvscsis_start.sh and made persisent across reboots.

Btw, I still need to add the SRP transportID encoding/decoding for
target_core_fabric_lib.c and TCM_Loop code, so while I am doing this I
will have a look at writing up some python code to generate these for
our VIO SRP WWPNs.

Best,

--nab


