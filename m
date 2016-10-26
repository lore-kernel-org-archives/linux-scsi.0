From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v3 1/2] scsi: Handle Unit Attention when issuing SCSI
 command
Date: Wed, 26 Oct 2016 08:42:40 -0700
Message-ID: <e3531f72-596e-359c-93bd-3855291d7ba0@sandisk.com>
References: <1477279216-11256-1-git-send-email-krisman@linux.vnet.ibm.com>
 <27d08f8f-bbf5-1298-1985-f0c3ee45d2d1@sandisk.com>
 <1477434237.3079.84.camel@linux.vnet.ibm.com>
 <1477437481.2385.7.camel@sandisk.com>
 <1477439413.3079.101.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0071.outbound.protection.outlook.com ([104.47.41.71]:26384
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755219AbcJZPmw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Oct 2016 11:42:52 -0400
In-Reply-To: <1477439413.3079.101.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "krisman@linux.vnet.ibm.com" <krisman@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "gabriel@krisman.be" <gabriel@krisman.be>

On 10/25/2016 04:50 PM, James Bottomley wrote:
> On Tue, 2016-10-25 at 23:18 +0000, Bart Van Assche wrote:
>> Anyway, currently the following functions interpret the SCSI sense
>> buffer:
>> * scsi_io_completion() in scsi_lib.c.
>> * scsi_mode_sense() in scsi_lib.c.
>> * scsi_test_unit_ready_flags() in scsi_lib.c.
>> * scsi_probe_lun() in scsi_scan.c.
>> * scsi_report_lun_scan() in scsi_scan.c.
>> * ioctl_internal_command() in scsi_ioctl.c.
>> * sg_rq_end_io() in sg.c.
>> * scsi_check_sense() in scsi_error.c.
>> * spi_execute() in scsi_transport_spi.c.
>>
>> Are you sure we should add sense code interpretation code in a tenth
>> function in the SCSI core?
>
> In the absence of a better proposal, yes.  I originally looked into
> better BLOCK_PC error handling in scsi_io_completion, but that has some
> knock on problems, so it seems best to leave it alone.

Can you elaborate on this? Since the sense buffer is available in 
scsi_io_completion() and since that function already calls 
scsi_command_normalize_sense() this function seems like a good candidate 
to me to add retry logic for REQ_TYPE_BLOCK_PC requests.

Thanks,

Bart.
