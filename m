From: Michael Joosten <michael.joosten@c-lab.de>
Subject: Re: [PATCH]: Re: qla1280.c broken on SGI visws,	PCI	coherency	problem
Date: Thu, 15 Dec 2005 17:21:24 +0100
Message-ID: <43A19804.1050100@c-lab.de>
References: <439A17BE.5000904@sgi.com> <439DE50B.90007@sgi.com> <1134424057.3713.18.camel@mulgrave> <439E0112.1030801@sgi.com> <439ECB2E.7070103@sgi.com> <1134485413.3356.2.camel@mulgrave> <439F0FD6.30701@sgi.com> <439FA708.9070508@c-lab.de> <1134581356.3278.1.camel@mulgrave> <43A0C432.5060109@c-lab.de> <20051215022021.GC192359@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailserver.c-lab.de ([131.234.80.230]:61156 "EHLO
	mailserver.c-lab.de") by vger.kernel.org with ESMTP
	id S1750780AbVLOQ2D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Dec 2005 11:28:03 -0500
In-Reply-To: <20051215022021.GC192359@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Michael Reed <mdr@sgi.com>, pazke@donpac.ru, linux-scsi@vger.kernel.org

Jeremy Higdon wrote:

>On Thu, Dec 15, 2005 at 02:17:38AM +0100, Michael Joosten wrote:
>  
>
>>>Btw, the VisWS Linux port apparently uses non-coherent DMA.  Perhaps it
>>>should be switched to coherent DMA, as there could be bugs in that area
>>>with qla1280.
>>>      
>>>
>>Aha, so we are back at coherence, but it's not MP, but DMA one...
>>(I'm not sure what is meant with DMA coherence - make sure that before a 
>>DMA transfer is started at least the related CPU cache lines (in the DMA 
>>address range) are written back?)
>>    
>>
>
>For a start.  You need to invalidate before read into memory and write
>back before write to disk.  You also need to make sure that the memory
>stays out of the CPU cache during the DMA (so you need to make sure that
>when you DMA into memory that nothing is loading or storing to a cacheline
>that you're DMA'ing into.  On a speculative execution CPU, this is really
>hard.
>  
>
Aha. Thanks for the info, now I can figure what's going on.

>>in qla1280_32/64bit_start_scsi().
>>    
>>
>
>We're going to work on an API change to mmiowb() instead.
>
>  
>
OK. From my point, this has been settled and I'll stay tuned to test a 
patch. It's not urgent.

Thanks for the lively discussion and some insights, Michael

