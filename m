From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [Bugme-new] [Bug 11792] New: Oops when reading
 /proc/megaraid/hba0/diskdrives-ch*
Date: Wed, 22 Oct 2008 09:57:24 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C32D2C5EFE@cosmail02.lsi.com>
References: <48FF3690.2020806@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:44193 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbYJVP7D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Oct 2008 11:59:03 -0400
In-Reply-To: <48FF3690.2020806@panasas.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "pterjan@gmail.com" <pterjan@gmail.com>, "matthew@wil.cx" <matthew@wil.cx>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Patro, Sumant" <Sumant.Patro@lsi.com>, "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>

Thanks Boaz, the name for SAS is megaraid_sas and MPT is fusion.

Regards,

Bo Yang

-----Original Message-----
From: Boaz Harrosh [mailto:bharrosh@panasas.com]
Sent: Wednesday, October 22, 2008 10:20 AM
To: Yang, Bo
Cc: FUJITA Tomonori; pterjan@gmail.com; matthew@wil.cx; akpm@linux-foundation.org; linux-scsi@vger.kernel.org; Patro, Sumant; bugme-daemon@bugzilla.kernel.org; Austria, Winston
Subject: Re: [Bugme-new] [Bug 11792] New: Oops when reading /proc/megaraid/hba0/diskdrives-ch*

Yang, Bo wrote:
> Thanks TOMM.  If this is the case, it may affect some of other drivers like our
> MPT and SAS driver.  Is there a way kernel can fix it?
>
> Thanks,
>
> Bo Yang
>

Hi Bo Yang

What are the source files for the MPT and SAS drivers from LSI?
I have made a system wide search for such problems as below and could not
find any more. But I might have missed them. If you tell me the file names
I will inspect more closly.

Thanks
Boaz

> -----Original Message-----
> From: FUJITA Tomonori [mailto:fujita.tomonori@lab.ntt.co.jp]
> Sent: Wednesday, October 22, 2008 9:39 AM
> To: Yang, Bo
> Cc: fujita.tomonori@lab.ntt.co.jp; bharrosh@panasas.com; pterjan@gmail.com; matthew@wil.cx; akpm@linux-foundation.org; linux-scsi@vger.kernel.org; Patro, Sumant; bugme-daemon@bugzilla.kernel.org; Austria, Winston
> Subject: RE: [Bugme-new] [Bug 11792] New: Oops when reading /proc/megaraid/hba0/diskdrives-ch*
>
> On Wed, 22 Oct 2008 07:03:03 -0600
> "Yang, Bo" <Bo.Yang@lsi.com> wrote:
>
>> I saw the latest working kernel: 2.6.24 and first failing kernel
>> version: 2.6.27-rc8.  I understand there are lots of changes between
>> those two kernels.  Can you take a look the changes from kernels to
>> find out the root cause?
>
> Sorry, I didn't explain the possible root cause.
>
> struct scsi_cmnd in 2.6.25:
>
> unsigned char cmnd[MAX_COMMAND_SIZE];
>
>
> struct scsi_cmnd in 2.6.26:
>
> unsigned char *cmnd;
>
>
> In short, struct scsi_cmnd doesn't have static array for cdb. You need
> to allocate memory for it (the scsi midlayer does for common usage).
>
> So
>
> static int
> mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
> {
> ...
>         scb = &adapter->int_scb;
>         memset(scb, 0, sizeof(scb_t));
>
>         scmd = &adapter->int_scmd;
>         memset(scmd, 0, sizeof(Scsi_Cmnd));
>
>         sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
>         scmd->device = sdev;
>
>         scmd->device->host = adapter->host;
>         scmd->host_scribble = (void *)scb;
>         scmd->cmnd[0] = MEGA_INTERNAL_CMD;
>
> I suspect that the driver crashes here. My patch adds array to
> adapter_t and use it here.
>
> After 2.6.25, sense_buffer also is converted from static array to
> pointer. In general, using scsi_allocate_command/scsi_free_command is
> the recommended way to use struct scsi_cmnd.
>
> So my latest patch removes struct scsi_cmnd in adapter_t and uses the
> API in mega_internal_command().
>
>
>> Also if you believe this is the driver issue and need LSI to help,
>> can you report this issue to LSI?
>
> Yeah, I think that we need to update this driver because of the
> changes to SCSI mid-layer.
>
> It would be appreciated if you can test my latest path:
>
> http://marc.info/?l=linux-scsi&m=122467887502481&w=2
>
>
> Can you think of this thread as a bug report to LSI?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

