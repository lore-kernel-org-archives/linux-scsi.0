From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCHSET #upstream] libata: separate out SFF and BMDMA
Date: Tue, 21 Oct 2008 15:36:10 +0400
Message-ID: <48FDBEAA.3050806@ru.mvista.com>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello.

Tejun Heo wrote:
> This is the first take of separate-out-SFF-and-BMDMA patchset.
>   

   If BMDMA means the well known Intel BMIDE spec (also known as 
SFF-8038i) this separation starts to sound funny. :-)

> Historically, ATA meant SFF (or TASKFILE interface) plus BMDMA and
>   

   ATA means the taskfile interface plus the command set -- and nothing 
else.
   SFF couldn't mean taskfile interface because SFF ATAPI specs refers 
to ATA in this part -- it could only mean either ATAPI command set or 
BMDMA (BMIDE) interface which is spec'ed by SFF-8038i.

> that holds true for many modern SATA controllers.  This was reflected
> in libata implementation and libata core layer and SFF/BMDMA support
> used to be all tangled in one piece.
>   

   The "all tangled" expression describes this mess quite well. :-)

> Another issue which surpassed with the addition of all the legacy,
> platform and somewhat peculiar PATA drivers is that now there are
> enough drivers which use SFF interface but use its own DMA interface
> or don't support DMA at all.  This, in similar fashion, led those
> drivers to fake certain level of BMDMA functionality to please the
> libata SFF/BMDMA layer.  This led to the following interesting
> solutions in low level drivers.
>
> 1. For BMDMA drivers which don't use traditional BMDMA register,
>    ata_bmdma_mode_filter() incorrectly inhibits DMA modes.  Those
>    drivers either have to inherit from ata_sff_port_ops or clear
>    ->mode_filter explicitly.
>
> 2. non-BMDMA drivers call into BMDMA PRD table allocation.  It doesn't
>    actually allocate PRD table if bmdma_addr is not initialized but is
>    still confusing.
>
> 3. For BMDMA drivers which don't use traditional BMDMA register, some
>    methods might not be invoked as expected (e.g. bmdma_stop from
>    ata_sff_post_internal_cmd()).
>   
  
   What do you mean by BMDMA here? I'm now at a loss...

> 4. SFF drivers w/ custom DMA interface implement noop BMDMA ops
>    worrying libata core might call into one of them.
>   

   Are those drivers not the same as "BMDMA drivers which don't use 
traditional BMDMA register"?

MBR, Sergei


