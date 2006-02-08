From: Tejun <htejun@gmail.com>
Subject: Re: [patch 09/15] libata: Improved ata_exec_internal timeout handling
Date: Thu, 09 Feb 2006 02:21:41 +0900
Message-ID: <43EA28A5.5020803@gmail.com>
References: <200602061542.k16FgYf0002182@d01av01.pok.ibm.com> <43E9D328.7020109@gmail.com> <43EA256B.5050000@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pproxy.gmail.com ([64.233.166.182]:57589 "EHLO pproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1030350AbWBHRVr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2006 12:21:47 -0500
Received: by pproxy.gmail.com with SMTP id x31so431697pye
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2006 09:21:46 -0800 (PST)
In-Reply-To: <43EA256B.5050000@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Brian King wrote:
> Tejun Heo wrote:
> 
>>brking@us.ibm.com wrote:
>>
>>>Currently ata_exec_internal does very minimal cleanup if
>>>the executing command times out. This works for most usage
>>>scenarios, but can cause problems for hosts that set
>>>ATA_FLAG_PIO_DMA. For these users, the DMA buffer gets unmapped
>>>while the timed out out command is still active, which has
>>>the potential to cause PCI DMA errors if the command is
>>>still in progress. The following patch modifies ata_exec_internal
>>>to invoke eng_timeout on a timeout to allow for the timed out
>>>command to be cleaned up better before proceeding further.
>>>This patch is also in preparation for SAS attached SATA devices.
>>>
>>
>>Hello, again.
>>
>>ata_exec_internal() will be used during EH, so if you call error handler
>>from ata_exec_internal()....  In my pending EH patchset, there's a patch
>>to implement ->post_internal() callback which cleans up after an
>>internal command (successful or not).  Hopefully, it will be merged in
>>not too distant future.  Can ata_exec_internal() timeout handling wait
>>till then?
> 
> 
> Do you have a pointer to this patchset? I did a quick search for
> post_internal on the archive and didn't find anything.
> 

Hi,

No, not posted yet.  It's pretty simple though.  Hmmm... I'll post the
patch against the current upstream tomorrow.  It's pretty much
independent from other changes anyway.

-- 
tejun
