From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 0/6] Avoid that scsi-mq and dm-mq queue processing
 stalls sporadically
Date: Thu, 13 Apr 2017 14:23:58 +0200
Message-ID: <20170413122358.GH22576@bblock-ThinkPad-W530>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com>
 <20170412105538.GB22576@bblock-ThinkPad-W530>
 <1492020683.2764.9.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53428 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752908AbdDMMYH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Apr 2017 08:24:07 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3DCNf6K120110
        for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2017 08:24:06 -0400
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29t5cmuh9q-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2017 08:24:06 -0400
Received: from localhost
        by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Thu, 13 Apr 2017 13:24:03 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v3DCO0ug17695074
        for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2017 12:24:00 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61F6642041
        for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2017 13:23:05 +0100 (BST)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 410BA42042
        for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2017 13:23:05 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.69])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2017 13:23:05 +0100 (BST)
Content-Disposition: inline
In-Reply-To: <1492020683.2764.9.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>

On Wed, Apr 12, 2017 at 06:11:25PM +0000, Bart Van Assche wrote:
> On Wed, 2017-04-12 at 12:55 +0200, Benjamin Block wrote:
> > On Fri, Apr 07, 2017 at 11:16:48AM -0700, Bart Van Assche wrote:
> > > The six patches in this patch series fix the queue lockup I reported
> > > recently on the linux-block mailing list. Please consider these patches
> > > for inclusion in the upstream kernel.
> >
> > just out of curiosity. Is this maybe related to similar stuff happening
> > when CPUs are hot plugged - at least in that the stack gets stuck? Like
> > in this thread here:
> > https://www.mail-archive.com/linux-block@vger.kernel.org/msg06057.html
> >
> > Would be interesting, because we recently saw similar stuff happening.
>
> Hello Benjamin,
>
> My proposal is to repeat that test with Jens' for-next branch. If the issue
> still occurs with that tree then please check the contents of
> /sys/kernel/debug/block/*/mq/*/{dispatch,*/rq_list}. That will allow to
> determine whether or not any block layer requests are still pending. If
> running the command below resolves the deadlock then it means that a
> trigger to run a block layer queue is still missing somewhere:
>
> for a in /sys/kernel/debug/block/*/mq/state; do echo run >$a; done
>
> See also git://git.kernel.dk/linux-block.git.
>

Thx for the hint! I'll forward that and see if the affected folks are
willing to reproduce.


                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block
--
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
