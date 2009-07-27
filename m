From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some
 USB Disks
Date: Mon, 27 Jul 2009 18:47:52 +0300
Message-ID: <4A6DCC28.7000309@panasas.com>
References: <4A4472DF.1050900@turknet.net.tr>	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr>	<yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr>	<yq1fxcmnpqa.fsf@sermon.lab.mkp.net> <4A69D093.8020108@turknet.net.tr>	<yq1hbwykj80.fsf@sermon.lab.mkp.net>	<20090727020611.GC3711@parisc-linux.org>	<yq18wiakfq4.fsf@sermon.lab.mkp.net> <4A6D64DC.3020001@panasas.com>	<yq1ocr66vy6.fsf@sermon.lab.mkp.net> <4A6DBEEB.5020302@panasas.com> <yq1fxci6tmc.fsf@sermon.lab.mkp.net> <4A6DCA7F.4080006@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:27818
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751896AbZG0Prz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jul 2009 11:47:55 -0400
In-Reply-To: <4A6DCA7F.4080006@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Tarkan Erimer <tarkan.erimer@turknet.net.tr>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 07/27/2009 06:40 PM, Boaz Harrosh wrote:
> On 07/27/2009 06:19 PM, Martin K. Petersen wrote:
>>>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:
>> Boaz> Haa, OK. I thought INQUIRY EVPD=1 page=0 was so old it sure must
>> Boaz> be supported but you are saying it's only SBC2/SPC3. So I guess
>> Boaz> there is nothing else we can do.
>>
>> Yes, EVPD must be supported.  USB-ATA bridge firmware writers are
>> dyslexic.  Film at 11.
>>
>> What I'm saying is that *our* reason for sending out extended inquiry
>> appeared in SBC2 (block limits VPD).  So there is no point in asking
>> devices older than that.
>>
>> The fact that this fixes the problem for Tarkan's crappy disk is a
>> (quasi-intentional) side effect.  My patch simply tries to be
>> conservative about asking for those pages.
>>
>>
>> Boaz> What I hate about all this is that in USB the scsi_level is hard
>> Boaz> coded at the driver, without actually been able to probe the
>> Boaz> device about it.
>>
>> Huh, what?
>>
> 
> Look in drivers/usb/storage::slave_configure
> 
> 		/* Some devices report a SCSI revision level above 2 but are
> 		 * unable to handle the REPORT LUNS command (for which
> 		 * support is mandatory at level 3).  Since we already have
> 		 * a Get-Max-LUN request, we won't lose much by setting the
> 		 * revision level down to 2.  The only devices that would be
> 		 * affected are those with sparse LUNs. */
> 		if (sdev->scsi_level > SCSI_2)
> 			sdev->sdev_target->scsi_level =
> 					sdev->scsi_level = SCSI_2;
> 
Maybe it should be:

		if (sdev->scsi_level > SCSI_2 && sdev->scsi_level < SCSI_SPC_2)
			sdev->sdev_target->scsi_level =
					sdev->scsi_level = SCSI_2;

To account for the devices the comment is talking about. Which seems to be
written at the time SCSI_3 was the highest level.

> So the scsi_level is hard coded to very low.
> Or am I reading this code wrong and it is only triggered for some but not
> all devices?
> 
> Boaz
> --

Sigh
Boaz
