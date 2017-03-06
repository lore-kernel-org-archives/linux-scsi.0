From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [bdi_unregister] 165a5e22fa INFO: task swapper:1 blocked for
 more than 120 seconds.
Date: Mon, 06 Mar 2017 06:35:21 -0800
Message-ID: <1488810921.16832.6.camel@linux.vnet.ibm.com>
References: <20170305022111.yqtwyd6ognmco4gx@wfg-t540p.sh.intel.com>
         <20170306102733.GC14932@quack2.suse.cz>
         <20170306120123.GD14932@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37908 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932456AbdCFOfg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2017 09:35:36 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v26ETDxU144581
        for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2017 09:35:30 -0500
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2918g6bkwb-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2017 09:35:29 -0500
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Mon, 6 Mar 2017 09:35:28 -0500
In-Reply-To: <20170306120123.GD14932@quack2.suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, LKP <lkp@01.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Mon, 2017-03-06 at 13:01 +0100, Jan Kara wrote:
> On Mon 06-03-17 11:27:33, Jan Kara wrote:
> > Hi,
> > 
> > On Sun 05-03-17 10:21:11, Wu Fengguang wrote:
> > > FYI next-20170303 is good while mainline is bad with this error.
> > > The attached reproduce-* may help reproduce the issue.
> > 
> > Thanks for report! So from the stacktrace we are in the path 
> > testing removal of a device immediately after it has been probed 
> > and for some reason bdi_unregister() hangs - likely waiting for 
> > cgroup-writeback references to drop. Given how early this happens 
> > my guess is we fail to initialize something but for now I don't see 
> > how my patch could make a difference. I'm trying to reproduce this 
> > to be able to debug more...
> 
> OK, so after some debugging I think this is yet another problem in 
> SCSI initialization / destruction code which my patch only makes 
> visible (added relevant maintainers).
> 
> I can reproduce the problem reliably with enabling:
> 
> CONFIG_DEBUG_TEST_DRIVER_REMOVE=y
> CONFIG_SCSI_DEBUG=m
> CONFIG_BLK_CGROUP=y
> CONFIG_MEMCG=y
> (and thus CONFIG_CGROUP_WRITEBACK=y)
> 
> then 'modprobe scsi_debug' is all it takes to reproduce hang. 
> Relevant kernel messages with some of my debugging added (attached is 
> a patch that adds those debug messages):

This looks to be precisely the same problem Dan Williams was debugging
for us.

> [   58.721765] scsi host0: scsi_debug: version 1.86 [20160430]
> [   58.721765]   dev_size_mb=8, opts=0x0, submit_queues=1,
> statistics=0
> [   58.728946] CGWB init ffff88007fbb2000
> [   58.730095] Created sdev ffff880078e1a000
> [   58.731611] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug
> 0186 PQ : 0 ANSI: 7
> [   58.782246] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39
> MB/8.00 MiB)
> [   58.789687] sd 0:0:0:0: [sda] Write Protect is off
> [   58.791140] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
> [   58.800879] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, supports DPO and FUA
> [   58.893738] sd 0:0:0:0: [sda] Attached SCSI disk
> [   58.896808] Unreg1
> [   58.897960] Unreg2
> [   58.898637] Unreg3
> [   58.899100] CGWB ffff88007fbb2000 usage_cnt: 0
> [   58.900004] Unreg4
> [   58.904976] sd 0:0:0:0: [sda] Synchronizing SCSI cache

OK, can you put a WARN_ON trace in sd_shutdown and tell us where this
is coming from.  For the device to be reused after this we have to be
calling sd_shutdown() without going into SDEV_DEL.

Thanks,

James
