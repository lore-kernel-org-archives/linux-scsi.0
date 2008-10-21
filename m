From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET #upstream] libata: separate out SFF and BMDMA
Date: Tue, 21 Oct 2008 20:43:11 +0900
Message-ID: <48FDC04F.2080701@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org> <48FDBEAA.3050806@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:60462 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbYJULpZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 07:45:25 -0400
In-Reply-To: <48FDBEAA.3050806@ru.mvista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Hello, Sergei.

Sergei Shtylyov wrote:
> Tejun Heo wrote:
>> This is the first take of separate-out-SFF-and-BMDMA patchset.
> 
>   If BMDMA means the well known Intel BMIDE spec (also known as
> SFF-8038i) this separation starts to sound funny. :-)

Heh.. we had this discussion before.  SFF is TF ATA in libata.

>> Historically, ATA meant SFF (or TASKFILE interface) plus BMDMA and
>>   
> ATA means the taskfile interface plus the command set -- and nothing
> else.  SFF couldn't mean taskfile interface because SFF ATAPI specs
> refers to ATA in this part -- it could only mean either ATAPI
> command set or BMDMA (BMIDE) interface which is spec'ed by
> SFF-8038i.

Yeah, I know now.  We can either do s/sff/tf/ or just accept that SFF
is TF in libata for whatever reason.  Maybe it's not Small Form Factor
but something like Strange Form of tF.  :-)

>> that holds true for many modern SATA controllers.  This was reflected
>> in libata implementation and libata core layer and SFF/BMDMA support
>> used to be all tangled in one piece.
> 
>   The "all tangled" expression describes this mess quite well. :-)

So, the above is actually about the tangledness between ATA SFF and
BMDMA.

>> Another issue which surpassed with the addition of all the legacy,
>> platform and somewhat peculiar PATA drivers is that now there are
>> enough drivers which use SFF interface but use its own DMA interface
>> or don't support DMA at all.  This, in similar fashion, led those
>> drivers to fake certain level of BMDMA functionality to please the
>> libata SFF/BMDMA layer.  This led to the following interesting
>> solutions in low level drivers.
>>
>> 1. For BMDMA drivers which don't use traditional BMDMA register,
>>    ata_bmdma_mode_filter() incorrectly inhibits DMA modes.  Those
>>    drivers either have to inherit from ata_sff_port_ops or clear
>>    ->mode_filter explicitly.
>>
>> 2. non-BMDMA drivers call into BMDMA PRD table allocation.  It doesn't
>>    actually allocate PRD table if bmdma_addr is not initialized but is
>>    still confusing.
>>
>> 3. For BMDMA drivers which don't use traditional BMDMA register, some
>>    methods might not be invoked as expected (e.g. bmdma_stop from
>>    ata_sff_post_internal_cmd()).
>>   
>  
>   What do you mean by BMDMA here? I'm now at a loss...

Rephrased: Drivers which inherit from bmdma_port_ops as they share
many similar characteristics with the standard BMDMA interface but
uses different register format.

>> 4. SFF drivers w/ custom DMA interface implement noop BMDMA ops
>>    worrying libata core might call into one of them.
> 
>   Are those drivers not the same as "BMDMA drivers which don't use
> traditional BMDMA register"?

Rephrased: Drivers which uses ATA TF interface but uses completely
custom DMA interface instead of BMDMA or something similar to it.

Thanks.

-- 
tejun
