From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/2] scsi: Handle Unit Attention when issuing SCSI
 command
Date: Tue, 25 Oct 2016 16:50:13 -0700
Message-ID: <1477439413.3079.101.camel@linux.vnet.ibm.com>
References: <1477279216-11256-1-git-send-email-krisman@linux.vnet.ibm.com>
         <27d08f8f-bbf5-1298-1985-f0c3ee45d2d1@sandisk.com>
         <1477434237.3079.84.camel@linux.vnet.ibm.com>
         <1477437481.2385.7.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42582 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752680AbcJYXuU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Oct 2016 19:50:20 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9PNmW6I021602
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2016 19:50:19 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0b-001b2d01.pphosted.com with ESMTP id 26abrut24w-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2016 19:50:19 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Tue, 25 Oct 2016 17:50:18 -0600
In-Reply-To: <1477437481.2385.7.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "krisman@linux.vnet.ibm.com" <krisman@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "gabriel@krisman.be" <gabriel@krisman.be>

On Tue, 2016-10-25 at 23:18 +0000, Bart Van Assche wrote:
> On Tue, 2016-10-25 at 15:23 -0700, James Bottomley wrote:
> > Because scsi_execute uses REQ_BLOCK_PC which is completed before 
> > you get to that code.
> 
> Hello James,
> 
> Do you perhaps mean that scsi_io_completion() returns early for
> REQ_TYPE_BLOCK_PC requests? Can you clarify this further?

I'm not sure how much simpler I can make it.  How about: the first if
block gives a non zero value in error causing scsi_end_request to
signal an immediate return?

> Anyway, currently the following functions interpret the SCSI sense
> buffer:
> * scsi_io_completion() in scsi_lib.c.
> * scsi_mode_sense() in scsi_lib.c.
> * scsi_test_unit_ready_flags() in scsi_lib.c.
> * scsi_probe_lun() in scsi_scan.c.
> * scsi_report_lun_scan() in scsi_scan.c.
> * ioctl_internal_command() in scsi_ioctl.c.
> * sg_rq_end_io() in sg.c.
> * scsi_check_sense() in scsi_error.c.
> * spi_execute() in scsi_transport_spi.c.
> 
> Are you sure we should add sense code interpretation code in a tenth
> function in the SCSI core?

In the absence of a better proposal, yes.  I originally looked into
better BLOCK_PC error handling in scsi_io_completion, but that has some
knock on problems, so it seems best to leave it alone.

James

