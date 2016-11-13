From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] sd: Fix a deadlock between event checking and
 device removal
Date: Sat, 12 Nov 2016 21:47:08 -0800
Message-ID: <1479016028.17624.16.camel@linux.vnet.ibm.com>
References: <a8f0ee8f-7b40-2375-47a4-52f78af29d8d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45714 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751481AbcKMFrO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 13 Nov 2016 00:47:14 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAD5hYMM144217
        for <linux-scsi@vger.kernel.org>; Sun, 13 Nov 2016 00:47:13 -0500
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26ny91e6uq-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 13 Nov 2016 00:47:13 -0500
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Sun, 13 Nov 2016 00:47:12 -0500
In-Reply-To: <a8f0ee8f-7b40-2375-47a4-52f78af29d8d@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2016-11-11 at 16:38 -0800, Bart Van Assche wrote:
> Hello James and Martin,
> 
> This short patch series fixes a deadlock that I ran into for the 
> first time several months ago but for which I had not yet had the 
> time to post a fix. As usual, feedback is appreciated.

First question would be why do we need to push highly dm specific
knowledge into block, like REQ_FAIL_IF_NO_PATH.  Can't we just use
REQ_FAILFAST_X for this?

Also, I don't quite understand how you've configured multipath
underneath SCSI.  I thought dm-mp always went on top?

James





