From: Kyle Fortin <kyle.fortin@oracle.com>
Subject: Re: [PATCH] libiscsi: use vzalloc for large allocations in iscsi_pool_init
Date: Mon, 3 Apr 2017 10:02:15 -0400
Message-ID: <5C682D60-2832-4CB0-8546-862D0A31251C@oracle.com>
References: <1491226221-24621-1-git-send-email-kyle.fortin@oracle.com> <20170403134139.GE4558@linux-x5ow.site>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41966 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751803AbdDCOCb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2017 10:02:31 -0400
In-Reply-To: <20170403134139.GE4558@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: lduncan@suse.com, cleech@redhat.com, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, Joe Gerard Slember <joe.slember@oracle.com>, Lance Hartmann ORACLE <lance.hartmann@oracle.com>

On Apr 3, 2017, at 9:41 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> 
> On Mon, Apr 03, 2017 at 06:30:21AM -0700, Kyle Fortin wrote:
>> iscsiadm session login can fail with the following error:
>> 
>> iscsiadm: Could not login to [iface: default, target: iqn.1986-03.com...
>> iscsiadm: initiator reported error (9 - internal error)
>> 
>> When /etc/iscsi/iscsid.conf sets node.session.cmds_max = 4096, it results
>> in 64K-sized kmallocs per session.  A system under fragmented slab
>> pressure may not have any 64K objects available and fail iscsiadm session
>> login. Even though memory objects of a smaller size are available, the
>> large order allocation ends up failing.
>> 
>> The kernel will print a warning and dump_stack, like below:
> 
> There is a series of patches in Andrew's mmotm tree, which introduces
> a kvmalloc() function, that does exactly what you're looking for.
> 
> Maybe you want to base your patch on top of it.
> 
> -- 
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
> GF: Felix Imendörffer, Jane Smithard, Graham Norton
> HRB 21284 (AG Nürnberg)
> Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

Thanks Johannes.  I’ll take a look.
--
Kyle Fortin - Oracle Linux Engineering
