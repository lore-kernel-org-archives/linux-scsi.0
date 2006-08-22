From: Martin Peschke <mp3@de.ibm.com>
Subject: Re: [Patch] cleanup: GFP_ATOMIC to GFP_KERNEL in scsi_scan.c
Date: Tue, 22 Aug 2006 17:44:58 +0200
Message-ID: <44EB267A.7010104@de.ibm.com>
References: <1156187273.2924.12.camel@dyn-9-152-230-71.boeblingen.de.ibm.com> <44EAD1B7.1010505@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:486 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP
	id S1751020AbWHVPpB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Aug 2006 11:45:01 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.13.7/8.13.7) with ESMTP id k7MFj055166434
	for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2006 15:45:00 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k7MFn1u6156136
	for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2006 17:49:01 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7MFixCA017272
	for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2006 17:45:00 +0200
In-Reply-To: <44EAD1B7.1010505@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org

Stefan Richter wrote:
> Martin Peschke wrote:
>> It seems to be safe to replace all 4 occurrences of GFP_ATOMIC in
>> scsi_scan.c by GFP_KERNEL. I found that calling code always held a mutex
>> (indicating process context) while not acquiring a spin_lock or such
>> inside the mutex sections and when using GFP_ATOMIC (see details below).
> 
> Please use diff's -p option for postings like this.

okay

> Did you check Documentation/scsi/scsi_mid_low_api.txt with respect to
> the detailed description of all exported functions which you modify? All
> of them should contain a remark like "Might block: yes" or something
> else in the way of "do not call in atomic context". Although I suppose
> that all or most of them do so already.
> 
> If scsi_mid_low_api.txt does not fully reflect what your patch imposes,
> please modify scsi_mid_low_api.txt in the same patch.

Thanks for the hint.

My changes conform to this description, as far as scsi_mid_low_api.txt
covers the interfaces touched by my patch.

Looks like a documentation update is needed regardless of my patch:

scsi_get_host_dev(), scsi_scan_target(), __scsi_add_device() are not
documented, though being exported. These are the ones affected by my
patch. I didn't check for other misses.

scsi_mid_low_api.txt says scsi_add_host() never blocks. This function
calls sysfs routines which might block (on mutex), and it uses
GFP_KERNEL - the latter not being my fault :)

scsi_host_get() "currently may block but may be changed to not block" -
current code won't block.

(My observations come from 2.6.18-rc4-mm2.)

> You need to make sure that it does not break _any_ caller. (SCSI is more
> than the bundle of interconnect drivers for SPI hardware.) Also take
> precautions for future callers or future changes to current callers.

Sure. I found that all these interface functions acquire a mutex. That is,
any caller which doesn't guarantee process context would be broken anyway,
even without me changing GFP_ATOMICs.

Martin

