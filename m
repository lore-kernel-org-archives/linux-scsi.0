From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC] Remove of ISA pools, and Lazy sense allocation.
Date: Mon, 12 May 2008 16:03:01 +0300
Message-ID: <48284005.8010407@panasas.com>
References: <48218B24.4000507@panasas.com> <20080508004308U.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:10410 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755654AbYELNDs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 May 2008 09:03:48 -0400
In-Reply-To: <20080508004308U.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: andi@firstfloor.org, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com

FUJITA Tomonori wrote:
> On Wed, 07 May 2008 13:57:40 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> Let me please explain a bit on my sense_buffer patchset and where I was going 
>> with these:
>>
>> Currently every ULD/Initiator that pushes request to block devices puts a sense
>> buffer of SCSI_SENSE_BUFFERSIZE size onto request->sense pointer. scsi-midlayer
>> shadows that buffer, for what it thought as a DMAable buffer for drivers, and at
>> completion of request copies the shadow buffer back into ULD's buffer.
>>
>> I have observed three uses of sense_buffer handling in scsi drivers:
> 
> I just had a quick look at only some of patches, but where do you
> allocate rq->sense for fs requests?
> 
> 
> Here are some comments:
> 
> scsi_eh: Define API for driver private sense allocation
> 
> +struct scsi_sense_elem {
> +       union {
> +               struct scsi_sense_elem *next;
> +               u8 sense_data[SCSI_SENSE_BUFFERSIZE] ____cacheline_aligned;
> +       };
> +} ____cacheline_aligned;
> 
> 
> I think that this is wrong since all the architecutures don't have
> such dma restriction. ARCH_KMALLOC_MINALIGN?
> 
> There is the same code in The libata patch at least. I guess there are
> more.

Tomo you are absolutely right there is no sense allocated for fs commands.

Which makes all this useless. I will go dig a big hole under a rock and
stay there for a year in shame. Please forgive me all for the noise.

Boaz

