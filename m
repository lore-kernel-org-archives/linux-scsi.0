From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver
Date: Wed, 23 Jan 2008 06:41:09 -0500
Message-ID: <479727D5.8060901@garzik.org>
References: <20080122151857.GA8680@ubuntu.domain>	 <6b2481670801220724o6c204216qc346020c296f2849@mail.gmail.com>	 <4796BB5A.9090003@garzik.org> <6b2481670801230254i46e65652vb9139e2c136e4ce4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:46951 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbYAWLlM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jan 2008 06:41:12 -0500
In-Reply-To: <6b2481670801230254i46e65652vb9139e2c136e4ce4@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: linux-scsi@vger.kernel.org, kewei@marvell.com, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com

Ke Wei wrote:
> Attachment is a patch file for 6440 driver. I will have to spend more
> time on setting my mail client. Yesterday I used mutt tool. But Look
> like the problem still exists.
> I fixed all issues which you mentioned , but

The changes look good, thanks!

In terms of engineering process, I should have been more clear:  when 
revising your submission, you should make the revisions and then 
regenerate your original patch.

To use a silly example, if you needed to fix a 1-character typo in a 
1,000-line patch, you would need to make your revision, re-generate the 
1,000-line patch, and email that new patch.

So, to move forward, please create one single patch with the latest 
mvsas, diff'd against the 'mvsas' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6

I will "ack" that patch (indicate my approval), and unless other 
objections surface, James will merge your patch into the 'mvsas' branch. 
  That will get the driver on the road to be included in 2.6.25.


>>> @@ -666,11 +970,53 @@ static int mvs_nvram_read(struct mvs_info *mvi, unsigned
>>> int addr,
>>>  err_out:
>>>        dev_printk(KERN_ERR, &mvi->pdev->dev, "%s", msg);
>>>        return rc;
>>> +#else
>>> +       memcpy(buf, "\x50\x05\x04\x30\x11\xab\x00\x00", 8);
>>> +       return 0;
>>> +#endif
>>
>> what happens if two adapters are used, with the same SAS address?  That
>> causes problems...
>>
>>
> Our bios can write SAS Address per port when system boot , so I think
> we don't need read or configure address.

It is standard Linux policy to reduce or eliminate BIOS dependencies as 
much as possible.

This is because there are several common scenarios where BIOS may not 
run, or otherwise not be available:

* suspend/resume
* controller hotplug
* non-x86 PCI platforms such as POWER

Thus, we need the driver to obtain these addresses -- hopefully reading 
them from a BIOS data table somewhere, if NVRAM is not available.

This is a highly common scenario -- obtaining unique identifying 
information in the absence of BIOS.



Similarly, we cannot rely on BIOS to perform any global reset or errata 
workaround duties for us.  That must be coded into the driver also.


> And I reserved hexdump funciton if you don't care. Only debugging.

It is not an important matter, but it would be nice to clean that up 
eventually.

Also, FWIW, we have a standard method of debug output:

	struct pci_dev *pdev;

	dev_dbg(&pdev->dev, KERN_INFO,
		"this is debug message number %d", 2);

which will only be compiled into the driver when DEBUG is defined.


>>> +static int mvs_abort_task(struct sas_task *task)
>>> +{
>>> +       /*FIXME*/
>>> +       MVS_PRINTK("mvs abort task\n");
>>> +       return TMF_RESP_FUNC_COMPLETE;
>>> +}
>> should make an attempt to do something sane here
>>
> if entering this abort function , I think I must fix the unknown
> issues instead of here.  But I also will implement next.

Ok, thanks.

	Jeff



