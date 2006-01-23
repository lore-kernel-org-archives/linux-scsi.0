From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 07/13] SCSI: export scsi_eh_finish_cmd() and	scsi_eh_flush_done_q()
Date: Mon, 23 Jan 2006 19:05:59 +0900
Message-ID: <43D4AA87.9080408@gmail.com>
References: <11379893764141-git-send-email-htejun@gmail.com> <1138001160.2977.14.camel@laptopd505.fenrus.org> <43D491DA.4020603@gmail.com> <20060123093653.GB9157@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060123093653.GB9157@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, albertcc@tw.ibm.com, linux-ide@vger.kernel.org, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Jan 23, 2006 at 05:20:42PM +0900, Tejun Heo wrote:
> 
>>Arjan van de Ven wrote:
>>
>>>On Mon, 2006-01-23 at 13:09 +0900, Tejun Heo wrote:
>>>
>>>
>>>>Export two SCSI EH command handling functions.  To be used by libata EH.
>>>
>>>since these are pretty much internal, can we make these _GPL exports?
>>>
>>
>>It's SCSI developers' decision.  I chose EXPORT_SYMBOL because all other
>>exported symbols in scsi_error.c were using it.  James?
> 
> 
> These are internal functions.  If we're going to export them at all then
> as _GPL (which is grossly misnamed and should be _INTERNAL)

And from the other thread created by my mistake.

 > What do you need it for?  Please send the whole patch series (and
 > generally anything in libata that interacts with the scsi midlayer) to
 > linux-scsi, please.

It's rather large patchset consisting of 13 libata-eh related patches. 
Only two of the patches are relevant to SCSI.  I'm not sure whether 
cross-posting the whole thing is appropriate.

The first one exports two scsi_eh functions (this thread) and the second 
one uses these two to implement ata_eh_retry/complete helpers.

http://marc.theaimsgroup.com/?l=linux-ide&m=113798939719926&w=2
http://marc.theaimsgroup.com/?l=linux-ide&m=113798939627887&w=2

These are used because libata implements shost->eh_strategy_handler for 
error handling.  libata's ->eh_strategy_handler should do everything 
scsi_unjam_host() does and one chunk is to retry or complete failed SCSI 
commands during or after EH completes.  libata used to do this by 
calling scsi_finish_command() directly, which is an internal interface 
too.  Directly calling scsi_finish_command() also used to have deadlock 
problem when libata shared SCSI's host lock.

As what has to be done is identical, above two patches make libata share 
that part of code with scsi_unjam_host().  And, as Jeff commented, once 
these are settled scsi_fini_command() can be unexported.

-- 
tejun
