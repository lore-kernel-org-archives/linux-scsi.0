From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: scsi scan bug when peripheral qualifier of 3 is returned
Date: Wed, 04 Jan 2006 12:28:03 -0600
Message-ID: <43BC13B3.9030604@cs.wisc.edu>
References: <43BB750A.5050000@cs.wisc.edu> <20060104174019.GA3995@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45189 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S965263AbWADS2N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2006 13:28:13 -0500
In-Reply-To: <20060104174019.GA3995@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Patrick Mansfield wrote:
> On Wed, Jan 04, 2006 at 01:11:06AM -0600, Mike Christie wrote:
> 
> 
>>But for SCSI_SCAN_TARGET_PRESENT bflags is not set. Is the correct fix 
>>to move where bflagsp gets set in scsi_probe_and_add_lun so that it gets 
>>set for the SCSI_SCAN_TARGET_PRESENT case, or should __scsi_scan_target 
>>be passing scsi_sequential_lun_scan and possibly scsi_report_lun_scan 
>>some default bflags values?
> 
> 
> It looks OK to me as-is, since bflags is also passed to and set in
> scsi_probe_lun(), right?
> 

A blagfs variable gets set but it is not the same one passed into 
scsi_probe_and_add_lun.

static int scsi_probe_and_add_lun(struct scsi_target *starget,
                                   uint lun, int *bflagsp,


{
         struct scsi_device *sdev;
         unsigned char *result;
         int bflags,


scsi_probe_and_add_lun gets a *bflagsp passed to it as a function arg, 
but then also decalres a bflags variable itself. It then passes 
scsi_probe_lun() the bflags it declared and does this

         res = scsi_add_lun(sdev, result, &bflags);
         if (res == SCSI_SCAN_LUN_PRESENT) {
                 if (bflags & BLIST_KEY) {
                         sdev->lockable = 0;
                         scsi_unlock_floptical(sdev, result);
                 }
                 if (bflagsp)
                         *bflagsp = bflags;
         }

so *bflagsp pointer only gets set if SCSI_SCAN_LUN_PRESENT was returned 
by scsi_add_lun. For SCSI_SCAN_TARGET_PRESENT we do not even get to 
scsi_add_lun, so for this case *bflagsp never gets set and 
__scsi_scan_target gets zero. Previously, __scsi_scan_target would just 
pass scsi_sequential_lun_scan the sparse blist flag, but now it passes zero.
