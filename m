From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH] mpt fusion: add support for Brocade branded LSI FC HBA
Date: Fri, 13 Jul 2007 11:10:46 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7085119B@NAMAIL4.ad.lsil.com>
References: <20070713092918.GB5564@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:46491 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbXGMRKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jul 2007 13:10:53 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070713092918.GB5564@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, linux-scsi@vger.kernel.org
Cc: "Hickerson, Roger" <Roger.Hickerson@lsi.com>, ggrignou@brocade.com

On Friday, July 13, 2007 3:29 AM,  Prakash, Sathya wrote:

You need to include in this  patch, the fix that occurred between the
4.00.09 and 4.00.10 drivers.  That fix is in mptDisplayIocCapabilties,
where it was removing the first three characters from the prod_name.
Without this change, "040" would be displayed instead of "BRE040". 

Here are some additional request:


> +mpt_get_product_name(u16 vendor, u16 device, u8 revision, 
> char *prod_name)
> +{
> +	char *product_str = NULL;
> +
> +	if (vendor == 0x1657) {
> +		switch (device)

You should use the define PCI_VENDOR_ID_BROCADE instead of the hardcoded
0x1657 value.



> +	if (vendor != PCI_VENDOR_ID_LSI_LOGIC)
> +		goto out;

This sanity check on  PCI_VENDOR_ID_LSI_LOGIC needs to be removed.  I
will be required in the pending ATTO UL4D patch.



