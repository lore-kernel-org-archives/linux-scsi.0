From: Brad Campbell <brad@wasp.net.au>
Subject: Re: libata & scsi error handling
Date: Wed, 18 Aug 2004 11:04:43 +0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <4122FF8B.5070509@wasp.net.au>
References: <4122771A.4070203@wasp.net.au> <4122BA04.3070705@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4122BA04.3070705@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:

> 
> It is highly likely that your patch is doing the right thing.  Doug 
> Ledford, 2.4.x SCSI maintainer, pointed out to me recently that my 2.4.x 
> error handling code MUST update a couple variables, otherwise error 
> handling would hang as you see.  The reason is that scsi_unjam_host(), 
> on both 2.4.x and 2.6.x, is the only ->eh_strategy_handler until libata 
> came along.
> 
> So, it is likely that there are a few details the scsi_unjam_host() 
> performs, that needs to do too.

Possibly stupid question time. (What I know about the SCSI stack could be written on the back of a 
matchbox)

I'm a little concerned about this bit here. (This is the end of the first command and then the 
timeout related to it).


Aug 18 01:54:48 srv kernel: ata_dev_select: ENTER, ata13: device 0, wait 1
Aug 18 01:54:48 srv kernel: ata_tf_load_pio: hob: feat 0x0 nsect 0x0, lba 0x0 0x0 0x0
Aug 18 01:54:48 srv kernel: ata_tf_load_pio: feat 0x0 nsect 0x80 lba 0x0 0x0 0x0
Aug 18 01:54:48 srv kernel: ata_tf_load_pio: device 0xE0
Aug 18 01:54:48 srv kernel: ata_exec_command_pio: ata13: cmd 0x25
Aug 18 01:54:48 srv kernel: ata_scsi_translate: EXIT
Aug 18 01:54:48 srv kernel: scsi_dispatch_cmd out
Aug 18 00:43:41 srv kernel: scsi_times_out
Aug 18 00:43:41 srv kernel: scsi_eh_scmd_add

Here the scmd that failed gets added to a list.

         list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);

Because scsi_eh_finish_cmd never runs it will never get removed from the list. Am I missing something?

Aug 18 00:43:41 srv kernel: scsi_eh_scmd_after return 0
Aug 18 00:43:41 srv kernel: host_busy 1, host_failed 1
Aug 18 00:43:41 srv kernel: scsi_times_out out
Aug 18 00:43:41 srv kernel: wake eh_strategy_handler
Aug 18 00:43:41 srv kernel: hit eh_strategy_handler
Aug 18 00:43:41 srv kernel: eh_strategy_handler 1
Aug 18 00:43:41 srv kernel: ata_scsi_error: ENTER
Aug 18 00:43:41 srv kernel: ata_eng_timeout: ENTER
Aug 18 00:43:41 srv kernel: ata_qc_timeout: ENTER
Aug 18 00:43:41 srv kernel: ata13: command 0x25 timeout, stat 0xd0 host_stat 0x1
Aug 18 00:43:41 srv kernel: ata_sg_clean: unmapping 128 sg elements
Aug 18 00:43:41 srv kernel: scsi_device_unbusy
Aug 18 00:43:41 srv kernel: host_busy 0, host_failed 1
Aug 18 00:43:41 srv kernel: scsi12: ERROR on channel 0, id 0, lun 0, CDB: Read (10) 00 00 00 00 00 
00 00 80 00
Aug 18 00:43:41 srv kernel: Current sda: sense key Medium Error
Aug 18 00:43:41 srv kernel: Additional sense: Unrecovered read error - auto reallocate failed
Aug 18 00:43:41 srv kernel: end_request: I/O error, dev sda, sector 0
Aug 18 00:43:41 srv kernel: Buffer I/O error on device sda, logical block 0
Aug 18 00:43:41 srv kernel: ata_qc_timeout: EXIT
Aug 18 00:43:41 srv kernel: ata_eng_timeout: EXIT
Aug 18 00:43:41 srv kernel: ata_scsi_error: EXIT
Aug 18 00:43:41 srv kernel: eh_strategy_handler 2
Aug 18 00:43:41 srv kernel: eh_strategy_handler 3
Aug 18 00:43:41 srv kernel: scsi_dispatch_cmd
Aug 18 00:43:41 srv kernel: Add Timer
Aug 18 00:43:41 srv kernel: After Add Timer
Aug 18 01:55:14 srv kernel: ata_scsi_dump_cdb: CDB (13:0,0,0) 28 00 00 00 00 01 00 00 7f
Aug 18 01:55:14 srv kernel: ata_scsi_translate: ENTER
Aug 18 01:55:14 srv kernel: ata_scsi_rw_xlat: ten-byte command
Aug 18 01:55:14 srv kernel: ata_sg_setup: ENTER, ata13
Aug 18 01:55:14 srv kernel: ata_sg_setup: 127 sg elements mapped

Regards,
Brad
