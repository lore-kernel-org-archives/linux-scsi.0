From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: sym53c8xx ISTAT1 feature never set
Date: Mon, 21 Jan 2008 13:24:07 -0800
Message-ID: <20080121212407.GA14435@linux.vnet.ibm.com>
References: <20080119174144.GB25398@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44796 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778AbYAUVYM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jan 2008 16:24:12 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0LLOBrr002809
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jan 2008 16:24:11 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0LLOBoN157892
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jan 2008 16:24:11 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0LLOBkV026556
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jan 2008 16:24:11 -0500
Content-Disposition: inline
In-Reply-To: <20080119174144.GB25398@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox <matthew@wil.cx> wrote:
> The only problem is ... we never set the FE_ISTAT1 bit.  Mike tells me
> that when he sets it, it makes his error recovery work.
> 
> I think we need a patch somewhat along these lines:
> 
>   {PCI_DEVICE_ID_LSI_53C1010_66, 0xff, "1010-66", 6, 31, 7, 8,
>   FE_WIDE|FE_ULTRA3|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFBC|FE_LDSTR|FE_PFEN|
>   FE_RAM|FE_RAM8K|FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_66MHZ|FE_CRC|
> - FE_C10|FE_U3EN}
> + FE_C10|FE_U3EN|FE_ISTAT1}

As you already mentioned we tested setting FE_ISTAT1 for one card. We just
ran with your patch and it addressed that issue as expected (as this patch
only enables more cards that we do not have it not that interesting that it
passed, just wanted to add a "tested" to this thread). I can only hardware
verify the check above "PCI_DEVICE_ID_LSI_53C1010_66", so that does not
add much.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
