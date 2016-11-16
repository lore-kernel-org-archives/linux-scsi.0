From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] blk-mq: Avoid memory reclaim when remapping queues
Date: Wed, 16 Nov 2016 14:23:18 -0200
Message-ID: <8737irmm15.fsf@linux.vnet.ibm.com>
References: <1479151478-19725-1-git-send-email-krisman@linux.vnet.ibm.com>
        <1479151478-19725-2-git-send-email-krisman@linux.vnet.ibm.com>
        <39a42839-b877-21b7-aa85-314cf499e234@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41729 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753033AbcKPQX0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Nov 2016 11:23:26 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAGGIhVh006819
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2016 11:23:25 -0500
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26rnseg8br-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2016 11:23:25 -0500
Received: from localhost
        by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
        Wed, 16 Nov 2016 14:23:23 -0200
In-Reply-To: <39a42839-b877-21b7-aa85-314cf499e234@sandisk.com> (Bart Van
        Assche's message of "Tue, 15 Nov 2016 14:51:30 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: axboe@fb.com, linux-block@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>, Douglas Miller <dougmill@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

Bart Van Assche <bart.vanassche@sandisk.com> writes:

> I don't think that GFP_NOWAIT is acceptable in this context. Have you
> tried GFP_NOIO instead of GFP_NOWAIT?

At first I used GFP_NOIO, but after reviewing gfp.h I convinced myself
GFP_NOWAIT was what I wanted because I was concerned about FS accesses
that aren't restricted in GFP_NOIO.  For some reason, I assumed this was
an issue.  I'm ok with the change and can submit a v2 shortly, after
more tests.  in fact, this will make the change more compliant with the
rest of block layer critical allocations that use GFP_NOIO.

Thanks,

-- 
Gabriel Krisman Bertazi

