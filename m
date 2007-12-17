From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: INITIO scsi driver fails to work properly
Date: Mon, 17 Dec 2007 19:00:26 +0200
Message-ID: <4766AB2A.7000206@panasas.com>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com> <20071217031841.f483e5ac.akpm@linux-foundation.org> <20071217130523.7e9c88bb@the-village.bc.nu> <47668A75.7040707@panasas.com> <20071217143641.760d4162@the-village.bc.nu> <1197903781.3204.4.camel@localhost.localdomain> <47669F1B.4090400@panasas.com> <20071217162040.GB5056@dspnet.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:20805 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752839AbXLQRBe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Dec 2007 12:01:34 -0500
In-Reply-To: <20071217162040.GB5056@dspnet.fr.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olivier Galibert <galibert@pobox.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Filippos Papadopoulos <psybases@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Dec 17 2007 at 18:20 +0200, Olivier Galibert <galibert@pobox.com> wrote:
> On Mon, Dec 17, 2007 at 06:08:59PM +0200, Boaz Harrosh wrote:
>> Below fixes a deadly typo. Might as well be included in 2.6.24
> 
> You're sure ?  scsi_for_each_sg includes a (sg)++ already...
> 
> 
>>  		scsi_for_each_sg(cmnd, sglist, cblk->sglen, i) {
>>  			sg->data = cpu_to_le32((u32)sg_dma_address(sglist));
>>  			total_len += sg->len = cpu_to_le32((u32)sg_dma_len(sglist));
>> +			++sg;
>>  		}
> 
>   OG.
> --
Don't mix up between the here sg that points to a driver specific struct sg_entry
and the here sglist which points to struct scatterlist, and is named sg inside
the scsi_for_each_sg() macro. Please inspect the full code, the patch does not
show the complete information. I admit it's confusing.

Boaz

