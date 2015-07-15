From: Timothy Pearson <tpearson@raptorengineeringinc.com>
Subject: Re: [PATCH v3] [SCSI] mpt2sas, mpt3sas: Abort initialization if no
 memory I/O resources detected
Date: Wed, 15 Jul 2015 08:52:13 -0500
Message-ID: <55A6658D.6030802@raptorengineeringinc.com>
References: <1436935796-28995-1-git-send-email-Sreekanth.Reddy@avagotech.com> <CAE9FiQWzbwzQ7mrtyumhMFYg0-8N18+KZhjfvMfs5j5eV0C5wA@mail.gmail.com> <20150715062456.GB19028@dhcp-135-24-192-118.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pearsoncomputing.net ([192.119.205.242]:1555 "EHLO
	mail.pearsoncomputing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbbGONwR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2015 09:52:17 -0400
In-Reply-To: <20150715062456.GB19028@dhcp-135-24-192-118.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: Yinghai Lu <yinghai@kernel.org>, James Bottomley <jejb@kernel.org>, martin.petersen@oracle.com, Linux-Scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya.Prakash@avagotech.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Bjorn Helgaas <bhelgaas@google.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>

On 07/15/2015 01:24 AM, Sreekanth Reddy wrote:
> On Tue, Jul 14, 2015 at 10:36:58PM -0700, Yinghai Lu wrote:
>> On Tue, Jul 14, 2015 at 9:49 PM, Sreekanth Reddy
>> <sreekanth.reddy@avagotech.com> wrote:
>>> Driver crashes if the BIOS do not set up at least one
>>> memory I/O resource. This failure can happen if the device is too
>>> slow to respond during POST and is missed by the BIOS, but Linux
>>> then detects the device later in the boot process.
>>
>> But pci subsystem should assign resources to those unassigned BAR.
>>
>> Do you mean even kernel can not assign resource to them? or it takes so long for
>> mpt FW to get ready?
> 
> This is not an issue from mpt FW.
> 
> I have just kept the same description provide by Timothy in his
> initial patch.
> 
> But I observe that their may be chance of getting "unable to handle
> kernel NULL pointer dereference" kernel panic if no Memory Resource
> available in the PCI subsystem. So agreed to the Timothy proposal of
> aborting the driver initialization if it doesn't detect any Memory
> resource instead of whole system get into panic state.
> 
>>
>> Thanks
>>
>> Yinghai

On some systems Linux is unable / unwilling to assign a BAR if the BIOS
does not assign one at startup.  I didn't look into the Linux allocator
side of things in much detail, but it is quite possible that Linux is
unaware the device only has partial resources assigned.

-- 
Timothy Pearson
Raptor Engineering
+1 (415) 727-8645
http://www.raptorengineeringinc.com
