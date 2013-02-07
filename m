From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v8 0/10] More device removal fixes
Date: Thu, 07 Feb 2013 11:40:29 +0100
Message-ID: <5113849D.9060209@acm.org>
References: <5110FE98.8030209@acm.org> <alpine.DEB.2.02.1302061727030.11804@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:43476 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab3BGKkd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2013 05:40:33 -0500
In-Reply-To: <alpine.DEB.2.02.1302061727030.11804@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <Joe.Lawrence@stratus.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>

On 02/06/13 23:31, Joe Lawrence wrote:
> On Tue, 5 Feb 2013, Bart Van Assche wrote:
>> Fix a few race conditions that can be triggered by removing a device:
>> - Fix a race between starved list processing and device removal.
>> - Avoid that a SCSI LLD callback can get invoked after
>>    scsi_remove_host() finished.
>> - Speed up device removal by stopping error handling as soon as
>>    the SHOST_DEL or SHOST_DEL_RECOVERY state has been reached.
>> - Save and restore the host_scribble field during error handling
>>
>> These patches have been tested on top of kernel v3.8-rc6 and are also
>> available here: http://github.com/bvanassche/linux/tree/device-removal-fixes.
>
> Hi Bart,
>
> I gave your patchset a spin on our ftServer, which supports hotplug of PCI
> devices.  Before attempting a surprise HW removal of an LSI Fusion SAS-2
> SCSI controller, I issued an orderly removal through our hotplug driver.
> The device removal appeared to hang (this does not occur with vanilla
> 3.8.0-rc6).

Hello Joe,

Thanks for running this test. I have had a quick look at the mpt2sas 
_scsih_remove() implementation but I have not yet had the time to 
analyze that function entirely. My proposal is to defer further analysis 
of the interaction between the two patches that make scsi_remove_host() 
wait and the mpt2sas driver until a later time. It would be appreciated 
if you could run the following test:
* Revert the two patches that make scsi_remove_host() wait (these
   two patches should revert cleanly).
* Repeat your device removal test.
If that test runs fine, I will retest and repost this patch series 
without the two patches that make scsi_remove_host() wait.

Thanks,

Bart.

