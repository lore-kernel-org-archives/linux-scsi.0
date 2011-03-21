From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 21 Mar 2011 15:34:33 -0700
Message-ID: <1300746873.21880.81.camel@haakon2.linux-iscsi.org>
References: <20110307134033K.fujita.tomonori@lab.ntt.co.jp>
	 <1299508803.12730.1.camel@mulgrave.site>
	 <4D83C78D.5040908@linux.vnet.ibm.com>
	 <20110321100909E.fujita.tomonori@lab.ntt.co.jp>
	 <4D87CF99.7040008@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:47764 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab1CUWlo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2011 18:41:44 -0400
In-Reply-To: <4D87CF99.7040008@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On Mon, 2011-03-21 at 17:22 -0500, Brian King wrote:
> Tomo,
> 
> Thanks for all the work you've done with this driver. It is much appreciated.
> 
> What sort of performance are you seeing with this? With filebacked devices, I
> was seeing around 1 MB/sec doing a basic disktest run. I haven't compared this
> to ibmvstgt, but I'm pretty sure we did a fair bit better there. Perhaps I've got
> some setup issue?
> 
> I tried a ramdisk device and saw this on the server:
> 
> 
> DMA_TO_DEVICE not supported for RAMDISK_DR with task_sg_chaining=1
> 
> 

So for the RAMDISK_DR (direct) SGL memory mapping case we do not support
WRITEs for HW fabric modules using task_sg_changing=1.

Please go ahead and use RAMDISK_MCP instead, and I will look at adding a
special case in target_core_fabric_configfs.c code to disallow
RAMDISK_DR symlink creation of configfs ports for target fabric modules
using task_sg_chaining=1.

Thanks!

--nab

