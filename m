From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v4] cxlflash: Base support for IBM CXL Flash Adapter
Date: Mon, 8 Jun 2015 14:11:32 -0500
Message-ID: <574AF30D-275B-4129-A960-BB177AF105B2@linux.vnet.ibm.com>
References: <1433540782-15276-1-git-send-email-mrochs@linux.vnet.ibm.com> <1433757934.12237.6.camel@neuling.org>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:51708 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbbFHTLh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2015 15:11:37 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Mon, 8 Jun 2015 15:11:36 -0400
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 96D726E8045
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jun 2015 15:03:21 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t58JBYVp62390428
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2015 19:11:34 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t58JBXEJ003423
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2015 15:11:34 -0400
In-Reply-To: <1433757934.12237.6.camel@neuling.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Neuling <mikey@neuling.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, hch@infradead.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>

On Jun 8, 2015, at 5:05 AM, Michael Neuling wrote:
> 
> Reviewed-by: Michael Neuling <mikey@neuling.org>

Thanks again for helping us to review the code.

> 
> The core cxl changes needed for this are in mpe's powerpc next branch queued up
> for 4.2.  They are in linux next-20150605.  To compile this you'll need to pull
> in mpe's powerpc tree from:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux.git next

I went ahead and did a test build against this tree, everything worked.

>> +config CXLFLASH
>> +	tristate "Support for IBM CAPI Flash"
>> +	depends on CXL
> 
> This should be depends on SCSI too?

Yep, and PCI. Will fix in v5.

> 
>> +struct afu {
> < snip>
>> +	u64 interface_version;
> 
> This doesn't seem to be used anywhere except for in init_afu where it's
> only used local to that function.

True, the intention here is to save it off in case it is needed in a debug scenario. We may
even make it retrievable via a sysfs attribute at some point. 

>> +
>> +static inline u64 lun_to_lunid(u64 lun)
>> +{
>> +	u64 lun_id;
>> +
>> +	int_to_scsilun(lun, (struct scsi_lun *)&lun_id);
>> +	return swab64(lun_id);
>> +}
> 
> This is only used in main.c.  Why is it not just in there?

We use it in other places within the driver that have not been submitted. Rather than
migrating it around we decided to keep it defined in the common header.

> 
>> +/**
>> + * cxlflash_probe() - PCI entry point to add host
>> + * @pdev:	PCI device associated with the host.
>> + * @dev_id:	PCI device id associated with device.
>> + *
>> + * Return: 0 on success / non-zero on failure
>> + */
>> +static int cxlflash_probe(struct pci_dev *pdev,
>> +			  const struct pci_device_id *dev_id)
>> +{
> <snip>
>> +	phys_dev = cxl_get_phys_dev(pdev);
>> +	if (!dev_is_pci(phys_dev)) {
>> +		pr_err("%s: not a pci dev\n", __func__);
>> +		rc = ENODEV;
> 
> -ENODEV;

Good catch! Will fix in v5.

