From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] ibmvscsis: Move to struct ibmvscsis_vdev usage in
 fabric configfs handlers
Date: Tue, 2 Nov 2010 06:05:52 +0900
Message-ID: <20101102060030Z.fujita.tomonori@lab.ntt.co.jp>
References: <1288480434-29670-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:41442 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab0KAVGS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Nov 2010 17:06:18 -0400
In-Reply-To: <1288480434-29670-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, brking@linux.vnet.ibm.com, lxie@us.ibm.com, rcjenn@us.ibm.com, michaelc@cs.wisc.edu, James.Bottomley@suse.de

On Sat, 30 Oct 2010 16:13:54 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch takes tomo-san original commit 94fdb0196151 and changes a handful
> of important items wrt to the fabric configfs logic.
> 
> Firstly, this patch introduces struct ibmvscsis_vdev and converts the
> VIO ibmvscsis_probe() and ibmvscsi_remove() callers to allocate/free
> struct ibmvscsis_vdev instead of the original usage of struct ibmvscsis_tpg
> which is intended to be allocated/freed respectively in ibmvscsis_make_tpg()
> and ibmvscsis_drop_tpg() fabric configfs handlers.

What happens if an initiator sends a crq command before an user
creates a tpg? Or what happens if an initiator sends a crq command
after removing a tpg?


> Secondly, this patch changes the metadata that is used to determine the
> fabric WWN and TPGT (collectively the TCM VIO SRP endpoint) layout for
> /sys/kernel/config/target/ibmvscsis/$WWN/tpgt_$TPGT/.  This patch will
> now use struct vio_dev->unit_address for $WWN, and dev_name(vio_dev->dev)
> for $TPGT.

I don't care much about this but vio_dev->unit_address ==
dev_name(vio_dev->dev), I think. See vio_register_device_node() in
arch/powerpc/kernel/vio.c. So it's odd a bit.

ibmvscsis model doesn't strictly follow the SRP SCSI model; no port,
wwpn, etc. 


>  The values passed in via configff for $WWN and $TPGT must match
> in ibmvscsis_make_tport() and ibmvscsis_make_tpg() against what has been
> automatically setup for each struct ibmvscsis_vdev in the VIO ibmvscsis_probe()
> callback.

As I said before, it's much better to create them automatically
instead of creating them via sysfs. The driver knows all nexuses to
handle.
