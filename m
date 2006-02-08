From: Brian King <brking@us.ibm.com>
Subject: Re: [patch 09/15] libata: Improved ata_exec_internal timeout handling
Date: Wed, 08 Feb 2006 11:07:55 -0600
Message-ID: <43EA256B.5050000@us.ibm.com>
References: <200602061542.k16FgYf0002182@d01av01.pok.ibm.com> <43E9D328.7020109@gmail.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43E9D328.7020109@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> brking@us.ibm.com wrote:
>> Currently ata_exec_internal does very minimal cleanup if
>> the executing command times out. This works for most usage
>> scenarios, but can cause problems for hosts that set
>> ATA_FLAG_PIO_DMA. For these users, the DMA buffer gets unmapped
>> while the timed out out command is still active, which has
>> the potential to cause PCI DMA errors if the command is
>> still in progress. The following patch modifies ata_exec_internal
>> to invoke eng_timeout on a timeout to allow for the timed out
>> command to be cleaned up better before proceeding further.
>> This patch is also in preparation for SAS attached SATA devices.
>>
> 
> Hello, again.
> 
> ata_exec_internal() will be used during EH, so if you call error handler
> from ata_exec_internal()....  In my pending EH patchset, there's a patch
> to implement ->post_internal() callback which cleans up after an
> internal command (successful or not).  Hopefully, it will be merged in
> not too distant future.  Can ata_exec_internal() timeout handling wait
> till then?

Do you have a pointer to this patchset? I did a quick search for
post_internal on the archive and didn't find anything.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
