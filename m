From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] ibmvscsis: Move to struct ibmvscsis_vdev usage in
	fabric configfs handlers
Date: Tue, 02 Nov 2010 17:36:39 +0900
Message-ID: <20101102173639L.fujita.tomonori@lab.ntt.co.jp>
References: <1288647462.7708.31.camel@haakon2.linux-iscsi.org>
	<20101102070638M.fujita.tomonori@lab.ntt.co.jp>
	<1288650346.7708.76.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:64920 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab0KBIjZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2010 04:39:25 -0400
In-Reply-To: <1288650346.7708.76.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, lxie@us.ibm.com, rcjenn@us.ibm.com, michaelc@cs.wisc.edu, James.Bottomley@suse.de, joel.becker@oracle.com

On Mon, 01 Nov 2010 15:25:46 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> > I think that vio_dev->unit_address can be used to identify a nexus
> > uniquely. It's not WWPN though. It's a connection between an initiator
> > lpar and a target lpar.
> 
> Ok, then I think we will want to generate an emulated SRP WWN in
> userspace based on partially based on system_id (via existing sysfs code
> I assume..?) and drop the ->unit_address check in ibmvscsis_make_tpg()
> and continue use the dev_name(vio_dev->dev) for the TPGT part of the WWN
> +TPGT. 

Why we want to generate fake WWNs?


>  This also means we need a TCM/ibmvscsis internal method to
> ensure that each ibmvscsis_vdev is only mapped 1:1 for ibmvscsis_tport
> +ibmvscsi_tpg target_core_fabric_configfs.c callers..

That's why my initiatal driver uses tpg for vdev. They are always
1:1. Having ibmvscsis_vdev (a separate data structure for vdev) makes
no point.


> >From there VIO SRP WWPNs present in /sys/kernel/config/target/ibmvscsis/
> explictly configured by enduser can be saved into 
> /etc/target/ibmvscsis_start.sh and made persisent across reboots.
> 
> Btw, I still need to add the SRP transportID encoding/decoding for
> target_core_fabric_lib.c and TCM_Loop code, so while I am doing this I
> will have a look at writing up some python code to generate these for
> our VIO SRP WWPNs.
