From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: Re: smp-induced oops/NULL pointer dereference in mpt3sas, from kernel
 >= 4.11
Date: Mon, 4 Sep 2017 18:08:36 -0300
Message-ID: <3f9dce9c-5b54-785c-a165-4760b984fe8b@linux.vnet.ibm.com>
References: <3ba6084a-3404-18a4-3129-2539821b15df@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60403 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751329AbdIDVIm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Sep 2017 17:08:42 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v84L53xn067391
        for <linux-scsi@vger.kernel.org>; Mon, 4 Sep 2017 17:08:42 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2cs8rsygr4-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 04 Sep 2017 17:08:42 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Mon, 4 Sep 2017 15:08:41 -0600
In-Reply-To: <3ba6084a-3404-18a4-3129-2539821b15df@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: chaitra.basappa@broadcom.com
Cc: Bart.VanAssche@wdc.com, gpiccoli@linux.vnet.ibm.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 09/04/2017 05:44 PM, Guilherme G. Piccoli wrote:
> [Hopefully this messages gets threaded properly...]

And of course, I forgot to CC linux-scsi heheh
Sorry!

> 
> Chaitra, the following 4 patches fix this issue (the last one is really
> the fix, the others are part of the patchset):
> 
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=4.14/scsi-queue&id=c1225f01a
> ("scsi: bsg-lib: pass the release callback through bsg_setup_queue")
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=4.14/scsi-queue&id=9a664f492
> ("scsi: hpsa: remove the smp_handler stub")
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=4.14/scsi-queue&id=eaa79a6cd
> ("scsi: smartpqi: remove the smp_handler stub")
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=4.14/scsi-queue&id=651a01364
> ("scsi: scsi_transport_sas: switch to bsg-lib for SMP passthrough")
> 
> Issue happens because mpt3asas is using a non-allocated sense buffer on
> scsi_request; it started after the scsi_req refactoring, that made the
> sense buffer a pointer (scsi_transport_sas was an user that didn't
> allocate it, neither used - before the patches above - the bsg alloc
> API, hence the bug).
> 
> Cheers,
> 
> 
> Guilherme
> 
