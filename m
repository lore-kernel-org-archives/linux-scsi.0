From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: error processing + rw 6 byte fix
Date: Fri, 26 Aug 2005 23:31:17 -0400
Message-ID: <430FDE85.4060301@pobox.com>
References: <430994BC.4060102@torque.net> <430A230B.8040204@pobox.com> <430B1337.7080906@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:48556 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1030290AbVH0DbT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 23:31:19 -0400
In-Reply-To: <430B1337.7080906@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Douglas Gilbert wrote:
> Jeff Garzik wrote:
>>>@@ -1093,28 +1189,54 @@
>>>                   unsigned int buflen)
>>> {
>>>     u8 *scsicmd = args->cmd->cmnd, *p, *last;
>>>-    unsigned int page_control, six_byte, output_len;
>>>+    const u8 sat_blk_desc[] = {0, 0, 0, 0, 0, 0, 0x2, 0x0};
>>>+    /* 512 byte blocks, number of blocks = 0, (sat-r05) */
>>
>>
>>NOTE: don't hardcode 512, since that will change very soon in SATA.
> 
> 
> So put ATA_SECT_SIZE in there for the time being?

Yes.


>>1K ATA devices are just around the corner.
>>
>>
>>>@@ -1570,11 +1737,6 @@
>>>             ata_scsi_rbuf_fill(&args, ata_scsiop_mode_sense);
>>>             break;
>>> 
>>>-        case MODE_SELECT:    /* unconditionally return */
>>>-        case MODE_SELECT_10:    /* bad-field-in-cdb */
>>>-            ata_bad_cdb(cmd, done);
>>>-            break;
>>>-
>>>         case READ_CAPACITY:
>>>             ata_scsi_rbuf_fill(&args, ata_scsiop_read_cap);
>>>             break;
>>
>>
>>At this point in the patch series, you should not be removing this code
>>AFAICS.
> 
> 
> It is a trick and an error correction. In this version
> of libata MODE SELECT commands don't have "invalid field
> in cdb" as the ata_bad_cmd() sets, but "invalid command
> operation code" which is what the default case sets.

Since they are required commands, I tend to prefer "invalid field in 
CDB" as a temporary return code.

Of course we could just solve this by getting your MODE SELECT code in 
there ;)

	Jeff


