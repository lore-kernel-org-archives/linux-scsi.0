From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 31/32] cxlflash: Fix to avoid corrupting adapter fops
Date: Fri, 25 Sep 2015 17:35:55 -0500
Message-ID: <705BCC10-2E28-4B26-AD9E-DABD594A1437@linux.vnet.ibm.com>
References: <1443123193-16498-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443123851-17893-1-git-send-email-mrochs@linux.vnet.ibm.com> <5605BB6F.1030905@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:46777 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340AbbIYWf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2015 18:35:59 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 25 Sep 2015 18:35:58 -0400
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 0E1976E8040
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 18:27:39 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8PMZtKS59834460
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 22:35:55 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8PMZsXD002422
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 18:35:55 -0400
In-Reply-To: <5605BB6F.1030905@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Sep 25, 2015, at 4:23 PM, Brian King <brking@linux.vnet.ibm.com> wrote:
> On 09/24/2015 02:44 PM, Matthew R. Ochs wrote:
>> @@ -1293,8 +1291,8 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
>> 
>> 	int fd = -1;
>> 
>> -	/* On first attach set fileops */
>> -	if (atomic_read(&cfg->num_user_contexts) == 0)
>> +	/* On very first attach set fileops for adapter */
>> +	if (cfg->cxl_fops.owner != THIS_MODULE)
>> 		cfg->cxl_fops = cxlflash_cxl_fops;
> 
> Hmm... Why not just set this up once at probe time instead?

I tried to explain this in the commit message. I left it out of probe
time in an attempt to keep it separate from the legacy support as
it's only needed for superpipe.

I'll fix up this commit and just move it to probe as that seems easiest.


-matt
