Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2713FC433ED
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 03:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9E4261362
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 03:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbhECDDh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 May 2021 23:03:37 -0400
Received: from gateway23.websitewelcome.com ([192.185.48.104]:19969 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230368AbhECDDg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 May 2021 23:03:36 -0400
X-Greylist: delayed 1393 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 May 2021 23:03:36 EDT
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id D2D1F9C7E
        for <linux-scsi@vger.kernel.org>; Sun,  2 May 2021 21:39:29 -0500 (CDT)
Received: from just2098.justhost.com ([173.254.31.45])
        by cmsmtp with SMTP
        id dOUblQismL7DmdOUblPA5y; Sun, 02 May 2021 21:39:29 -0500
X-Authority-Reason: nr=8
Received: from 116-240-66-4.sta.dodo.net.au ([116.240.66.4]:33810 helo=[192.168.1.104])
        by just2098.justhost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <erwin@erwinvanlonden.net>)
        id 1ldOUa-001zRc-HT; Sun, 02 May 2021 20:39:29 -0600
Message-ID: <9ff34a69d89e49b4faeadb74eb73732ff6892529.camel@erwinvanlonden.net>
Subject: Re: [dm-devel] RFC: one more time: SCSI device identification
From:   Erwin van Londen <erwin@erwinvanlonden.net>
To:     "Ewan D. Milne" <emilne@redhat.com>,
        Martin Wilck <martin.wilck@suse.com>,
        "Ulrich.Windl@rz.uni-regensburg.de" 
        <Ulrich.Windl@rz.uni-regensburg.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.com>,
        "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "hch@lst.de" <hch@lst.de>
In-Reply-To: <ba1ed6166b285d4ccb90f5f17b971983092d382e.camel@redhat.com>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
         <yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
         <06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
         <yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
         <685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
         <yq1im4dre94.fsf@ca-mkp.ca.oracle.com>
         <e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>
         <6086A0B2020000A100040BBE@gwsmtp.uni-regensburg.de>
         <59dc346de26997a6b8e3ae3d86d84ada60b3d26b.camel@suse.com>
         <65f66a5e03081dd3b470fa9aeff9a77dbc41743c.camel@redhat.com>
         <488ef3e7fa0cca4f0a0cb2e9307ddaa08385d3f7.camel@suse.com>
         <c8ede601244e1710dbf320c33c0f7853e249bbee.camel@redhat.com>
         <455a6e5086831323af86a150d21d5a0a7c2299eb.camel@erwinvanlonden.net>
         <ba1ed6166b285d4ccb90f5f17b971983092d382e.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 03 May 2021 12:34:16 +1000
MIME-Version: 1.0
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - just2098.justhost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - erwinvanlonden.net
X-BWhitelist: no
X-Source-IP: 116.240.66.4
X-Source-L: No
X-Exim-ID: 1ldOUa-001zRc-HT
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 116-240-66-4.sta.dodo.net.au ([192.168.1.104]) [116.240.66.4]:33810
X-Source-Auth: erwin@erwinvanlonden.net
X-Email-Count: 5
X-Source-Cap: aGl0YWNoaTE7aGl0YWNoaTE7anVzdDIwOTguanVzdGhvc3QuY29t
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On Fri, 2021-04-30 at 19:44 -0400, Ewan D. Milne wrote:
> On Wed, 2021-04-28 at 10:09 +1000, Erwin van Londen wrote:
> > > > 
> 
> Perhaps an array might abort I/Os it has received in the Device
> Server when
> something changes. I have no idea if most or any arrays actually do
> that.
> 
> But, what about I/O that has already been queued from the host to the
> host bus adapter? I don't see how we can abort those I/Os properly.
> Most high-performance HBAs have a queue of commands and a queue
> of responses, there could be lots of commands queued before we
> manage to notice an interesting status. And AFAIK there is no
> conditional
> mechanism that could hold them off (and, they could be in-flight on
> the
> wire anyway).
> 
> I get what you are saying about what SAM describes, I just don't see
> how
> we can guarantee we don't send any further commands after the status
> with the UA is sent back, before we can understand what happened.
> 
> -Ewan

I agree there is only so much we can do especially when IO's have been
dispatched to hardware queues. I think if anything happens to those,
too bad, these ones will incur an abort or status check as well. These
would just need to be identified and subsequent IO's then sent to a
different path but that is a different topic. 

My primary concern is that if anything happens on a lun that changes
its attributes or access characteristics a UA should be sent in order
to inform a host. It cannot be that an array shuffles a lun id onto a
different physical volume without the host knowing. This will for sure
cause data corruption. 

> 
> > > > 
> > > 
> > > 
> > --
> > dm-devel mailing list

