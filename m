From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/4] scsi_data_buffer
Date: Tue, 13 Nov 2007 11:17:43 +0200
Message-ID: <47396BB7.3080708@panasas.com>
References: <47333E2A.7020307@panasas.com>	<47334072.7030908@panasas.com>	<20071112220652.dd9562c5.akpm@linux-foundation.org> <20071113154309K.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa3.bezeqint.net ([192.115.104.17]:59216 "EHLO sa3.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbXKMJR4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Nov 2007 04:17:56 -0500
In-Reply-To: <20071113154309K.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>, Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@SteelEye.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, pw@osc.edu, bhalevy@panasas.com, jes@sgi.com, "David S. Miller" <davem@davemloft.net>, "Maciej W. Rozycki" <macro@linux-mips.org>, Christoph Hellwig <hch@infradead.org>

On Tue, Nov 13 2007 at 8:40 +0200, FUJITA Tomonori <tomof@acm.org> wrote:
> On Mon, 12 Nov 2007 22:06:52 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> On Thu, 08 Nov 2007 18:59:30 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:
>>
>>>   In preparation for bidi we abstract all IO members of scsi_cmnd,
>>>   that will need to duplicate, into a substructure.
>>>
>>>   - Group all IO members of scsi_cmnd into a scsi_data_buffer
>>>     structure.
>> drivers/scsi/qla1280.c: In function 'qla1280_done':
>> drivers/scsi/qla1280.c:1313: error: 'struct scsi_cmnd' has no member named 'use_sg'
>> drivers/scsi/qla1280.c:1314: error: 'struct scsi_cmnd' has no member named 'request_buffer'
>> drivers/scsi/qla1280.c:1315: error: 'struct scsi_cmnd' has no member named 'use_sg'
>> drivers/scsi/qla1280.c:1316: error: 'struct scsi_cmnd' has no member named 'request_bufflen'
>> drivers/scsi/qla1280.c:1318: error: 'struct scsi_cmnd' has no member named 'request_bufflen'
>> drivers/scsi/qla1280.c: In function 'qla1280_return_status':
>> drivers/scsi/qla1280.c:1409: error: 'struct scsi_cmnd' has no member named 'request_bufflen'
>> drivers/scsi/qla1280.c:1416: error: 'struct scsi_cmnd' has no member named 'resid'
>> drivers/scsi/qla1280.c: In function 'qla1280_64bit_start_scsi':
>> drivers/scsi/qla1280.c:2791: error: 'struct scsi_cmnd' has no member named 'use_sg'
>> drivers/scsi/qla1280.c:2792: error: 'struct scsi_cmnd' has no member named 'request_buffer'
>> drivers/scsi/qla1280.c:2793: error: 'struct scsi_cmnd' has no member named 'use_sg'
>> drivers/scsi/qla1280.c:2801: error: 'struct scsi_cmnd' has no member named 'request_bufflen'
>> drivers/scsi/qla1280.c:2896: error: 'struct scsi_cmnd' has no member named 'use_sg'
>> drivers/scsi/qla1280.c:2991: error: 'struct scsi_cmnd' has no member named 'request_buffer'
>> drivers/scsi/qla1280.c:2992: error: 'struct scsi_cmnd' has no member named 'request_bufflen'
>> drivers/scsi/qla1280.c:3004: error: 'struct scsi_cmnd' has no member named 'request_bufflen'
>> make[2]: *** [drivers/scsi/qla1280.o] Error 1
>>
>> It mystfies me how a patch like this can have been floating about in N
>> submissions across M months and nobody has done an allmodconfig build or
>> even a grep to find out what broke.
>>
>> ho hum.  I shall mark qla1280 BROKEN and shall plod onwards.
> 
> A patch to fix this is in James' scsi-pending tree. Jes tested and
> fixed it (thanks !) so it will go to -mm via scsi-misc soon.
> 
> Boaz, it's better to send major scsi patches to -mm via scsi-misc to
> avoid problems like this.
> 
> 
> By the way, Andrew, can you add the following patchset to -mm?
> 
> http://lkml.org/lkml/2007/10/24/138
> 
> It fixes the IOMMUs' problem to merge scatter/gather segments without
> considering LLDs' restrictions.
> 
> 
> Thanks,

I was surprised that the patches reached -mm. My bad, I CCed Morton
because I thought that they should sit in mm early for collecting
complains, but I meant them to go through scsi-misc.
scsi-pending is patches that need approval from maintainers, but
that James thought they are ready. I was sure it is included in -mm, 
I should have checked.

The scsi_data_buffer patch must wait behind the patches in scsi-pending 
and behind the patch I sent for removal of the NCR53C9x/esp family of drivers.
http://www.spinics.net/lists/linux-scsi/msg20914.html

James please Submit this patch. At least to scsi-pending I have sent it to all 
the registered maintainers and mailing lists. I have got no response ether way. 
>From what Christoph said the only way we can get their comments, if any, is by 
removing the drivers. The only 2 active people (CCed) with interest in this HW, 
are working on the new driver set, and it should be easy to convert any esp HW 
to the new driver set.

Sorry for the mess
Boaz
