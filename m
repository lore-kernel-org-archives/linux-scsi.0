From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Sun, 22 Jun 2008 16:27:25 +0300
Message-ID: <485E533D.1070804@panasas.com>
References: <20080619160342.GJ4392@parisc-linux.org> <485E42B1.1060807@panasas.com> <20080622131926.GX4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:12261 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751824AbYFVN1p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jun 2008 09:27:45 -0400
In-Reply-To: <20080622131926.GX4392@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Sun, Jun 22, 2008 at 03:16:49PM +0300, Boaz Harrosh wrote:
>> Matthew Wilcox wrote:
>>> Use the noop elevator by default for drives that do not spin
>>>
>> <snip> 
>>> I've brazenly stolen sd_vpd_inquiry from mkp's patch here:
>>>
>>> http://marc.info/?l=linux-scsi&m=121264354724277&w=2
>>>
>>> No need to have two copies of that ... but this will conflict with his code.
>>>
>> <snip>
>>> I think there's an opportunity to improve sd_vpd_inquiry() to remove
>>> some of the duplicate code between sd_set_elevator() and sd_block_limits,
>>> but it's not terribly important.
>>>
>>> +static int sd_vpd_inquiry(struct scsi_disk *sdkp, unsigned char *buffer, u8 page, u8 len)
>>> +{
>>> +	int result;
>>> +	unsigned char cmd[16];
>>> +	struct scsi_sense_hdr sshdr;
>>> +
>>> +	memset(cmd, 0, 16);
>>> +	cmd[0] = INQUIRY;
>>> +	cmd[1] = 1;		/* EVPD */
>>> +	cmd[2] = page;		/* VPD page */
>>> +	cmd[3] = len;
>>> +	
>>> +	result = scsi_execute_req(sdkp->device, cmd, DMA_FROM_DEVICE, buffer,
>>> +				  len, &sshdr, SD_TIMEOUT, SD_MAX_RETRIES);
>>> +
>>> +	if (media_not_present(sdkp, &sshdr))
>>> +		return -EIO;
>>> +
>>> +	if (result) {
>>> +		sd_printk(KERN_ERR, sdkp, "EVPD Inquiry failed\n");
>>> +		return -EIO;
>>> +	}
>>> +
>>> +	if (buffer[1] != page) {
>>> +		sd_printk(KERN_ERR, sdkp, "Page code not %2x (%2x)\n", page,
>>> +			  buffer[1]);
>>> +		return -EIO;
>>> +	}
>>> +
>>> +	return buffer[3];
>>> +}
>> I was just copy/pasting the same code into my ULD. Perhaps the low level of above
>> could be made into a scsi_vpd_inquiry(...). From a quick search it looks like there
>> are 3 more places that issue _vpd_inquiry in the tree today.
> 
> Yes, there's nothing sd-specific about it.  Let me just make that minor
> improvement and I'll send out a proposal for scsi_vpd_inquiry().
> 
>> Some of the more interesting device information are in vpd's. we should have a generic
>> user-mode way to inquire them. sysfs structure, ioctl, I'm not sure, something good for
>> udev. There are tones of such little knobs that could be tuned according to vpd
>> information.
> 
> We have sg_inq and sg_vpd from Doug's sg3-utils.
> 
>> Thanks for doing this, I will investigate if current iscsi-targets will immediately benefit
>> from this too. From my testing I found that it is usually better to let the target side
>> elevator do the work, and set the Initiator elevator to noop. Do you know what the standard
>> say about the default value should be, in the case the page is not present. I would assume 
>> it means "No spinning media" too, right?
> 
> It means "Not reported".  Which I translate from standard-ese as
> "Could be anything".
> 

OK Thanks. I'll make sure all iscsi targets I care about return this page.
Am anticipating this patchset to be submitted, thanks again.

Boaz

