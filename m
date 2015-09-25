From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 08/32] cxlflash: Fix to avoid CXL services during EEH
Date: Fri, 25 Sep 2015 12:09:51 -0500
Message-ID: <ACF85932-A3A7-42C1-9655-D3C571C84F9D@linux.vnet.ibm.com>
References: <1443123193-16498-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443123485-16808-1-git-send-email-mrochs@linux.vnet.ibm.com> <5604A20C.4090000@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:49087 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519AbbIYRKv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2015 13:10:51 -0400
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 25 Sep 2015 13:10:50 -0400
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id F3E346E8040
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 13:02:31 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8PHAegu61276340
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 17:10:48 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8PHAEfb006447
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 13:10:16 -0400
In-Reply-To: <5604A20C.4090000@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Sep 24, 2015, at 8:23 PM, Brian King <brking@linux.vnet.ibm.com> wrote:
> On 09/24/2015 02:38 PM, Matthew R. Ochs wrote:
>> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
>> index 3e3ccf1..6e85c77 100644
>> --- a/drivers/scsi/cxlflash/main.c
>> +++ b/drivers/scsi/cxlflash/main.c
>> @@ -2383,16 +2397,14 @@ static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
>> 	switch (state) {
>> 	case pci_channel_io_frozen:
>> 		cfg->state = STATE_LIMBO;
>> -
>> -		/* Turn off legacy I/O */
>> 		scsi_block_requests(cfg->host);
>> +		drain_ioctls(cfg);
> 
> I don't see this addressing the deadlock with an outstanding read_cap16 during EEH I identified
> in the previous review. Am I missing something here?

I'll submit this in a separate patch in v4.

>> /**
>> + * check_state() - checks and responds to the current adapter state
>> + * @cfg:	Internal structure associated with the host.
>> + * @ioctl:	Indicates if on an ioctl thread.
>> + *
>> + * This routine can block and should only be used on process context.
>> + * When blocking on an ioctl thread, the ioctl read semaphore should be
>> + * let up to allow for draining actively running ioctls. Also note that
>> + * when waking up from waiting in reset, the state is unknown and must
>> + * be checked again before proceeding.
>> + *
>> + * Return: 0 on success, -errno on failure
>> + */
>> +static int check_state(struct cxlflash_cfg *cfg, bool ioctl)
> 
> Looks like you missed this cleanup. The second parameter is not needed, since all
> the callers set it to true.

Yep, this was my mistake. I'll correct in a v4 as the change will
ripple to the next patch in the series.

