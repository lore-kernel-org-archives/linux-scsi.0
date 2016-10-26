From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/2] scsi: Handle Unit Attention when issuing SCSI
 command
Date: Wed, 26 Oct 2016 12:38:25 -0500
Message-ID: <bec8981d-b061-928a-24f9-683dc7eaa936@linux.vnet.ibm.com>
References: <1477279216-11256-1-git-send-email-krisman@linux.vnet.ibm.com>
 <27d08f8f-bbf5-1298-1985-f0c3ee45d2d1@sandisk.com>
 <1477434237.3079.84.camel@linux.vnet.ibm.com>
 <1477437481.2385.7.camel@sandisk.com>
 <1477439413.3079.101.camel@linux.vnet.ibm.com>
 <e3531f72-596e-359c-93bd-3855291d7ba0@sandisk.com>
 <1477497160.2724.11.camel@linux.vnet.ibm.com>
 <1477498520.2550.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53497 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752642AbcJZRi3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Oct 2016 13:38:29 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9QHXT4q035394
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2016 13:38:28 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26aw33ykae-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2016 13:38:28 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Wed, 26 Oct 2016 13:38:28 -0400
In-Reply-To: <1477498520.2550.1.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "krisman@linux.vnet.ibm.com" <krisman@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gabriel@krisman.be" <gabriel@krisman.be>

On 10/26/2016 11:15 AM, Bart Van Assche wrote:
> On Wed, 2016-10-26 at 08:52 -0700, James Bottomley wrote:
>> On Wed, 2016-10-26 at 08:42 -0700, Bart Van Assche wrote:
>>> Can you elaborate on this? Since the sense buffer is available in 
>>> scsi_io_completion() and since that function already calls 
>>> scsi_command_normalize_sense() this function seems like a good 
>>> candidate to me to add retry logic for REQ_TYPE_BLOCK_PC requests.
>>
>> UAs are used to signal AENs to userspace control processes that use
>> BLOCK_PC, like CD changers, burners and scanners.  If we eat UAs
>> inside scsi_io_completion(), we could potentially break any userspace
>> control system that relies on AENs.
> 
> Ignoring the SCSI error handler, the call sequence for reporting UAs to
> user space is as follows: scsi_softirq_done() ->
> scsi_decide_disposition() -> scsi_check_sense() -> scsi_report_sense().
> This means that scsi_report_sense() is called before
> scsi_io_completion() is called. I think this means that what
> scsi_io_completion() decides cannot affect UA reporting to user space?

I think what would break if we just started eating UAs in scsi_io_completion
for BLOCK_PC is applications that are building BLOCK_PC requests and then
checking the sense data in the completed command for a UA. I think this is what
James was referring to. If we wanted to collapse some of this retry logic,
it seems like we might need a way to differentiate between different types of BLOCK_PC
requests. A new cmd_flag on struct request, or more generally, a way for scsi
or any user of struct request to pass driver specific data along with the request.
This is something I've wanted for ipr, which I've sort of worked around currently.

-Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

