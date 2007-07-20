From: Vasily Averin <vvs@sw.ru>
Subject: unexpected scsi timeout
Date: Fri, 20 Jul 2007 19:02:42 +0700
Message-ID: <46A0A462.2090407@sw.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000101010400000901070708"
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devel@openvz.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000101010400000901070708
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Tejun, Jeff

I've noticed that some scsi commands for DVD-drive attached to pata_via
successfully finishes without any delays but reports about TIMEOUT condition. It
happens because of ATA_ERR bit is set in status register. As result for each
command  Error Handler thread awakened, requests sense buffer and go to sleep again.

Could you please confirm that it is expected behavior? It's a bit strange for
me, IMHO other scsi drivers requests sense buffer without EH thread.

Thank you,
	Vasily Averin

--------------000101010400000901070708
Content-Type: text/x-log;
 name="sr.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sr.log"

Jul 20 13:20:15 ts28 cdrom: entering cdrom_open
Jul 20 13:20:15 ts28 scsi_block_when_processing_errors: rtn: 1
Jul 20 13:20:15 ts28 cdrom: Use count for "/dev/sr0" now 1
Jul 20 13:20:15 ts28 scsi_add_timer: scmd: ffff8100defba840, time: 30000, (ffffffff80382c14)
Jul 20 13:20:15 ts28 sr 2:0:0:0: Send: 0xffff8100defba840 
Jul 20 13:20:15 ts28 sr 2:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
Jul 20 13:20:15 ts28 buffer = 0x0000000000000000, bufflen = 0, done = 0xffffffff803856e5, queuecommand 0xffffffff8039758e
Jul 20 13:20:15 ts28 ata_scsi_dump_cdb: CDB (3:0,0,0) 00 00 00 00 00 00 00 00 00
Jul 20 13:20:15 ts28 ata_scsi_translate: ENTER
Jul 20 13:20:15 ts28 ata3: ata_dev_select: ENTER, device 0, wait 1
Jul 20 13:20:15 ts28 ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x20
Jul 20 13:20:15 ts28 ata_tf_load: device 0xA0
Jul 20 13:20:15 ts28 ata_exec_command: ata3: cmd 0xA0
Jul 20 13:20:15 ts28 ata_scsi_translate: EXIT
Jul 20 13:20:15 ts28 leaving scsi_dispatch_cmnd()
Jul 20 13:20:15 ts28 ata_hsm_move: ata3: protocol 6 task_state 1 (dev_stat 0x58)
Jul 20 13:20:15 ts28 atapi_send_cdb: send cdb
Jul 20 13:20:15 ts28 ata_host_intr: ata3: protocol 6 task_state 3
Jul 20 13:20:15 ts28 ata_hsm_move: ata3: protocol 6 task_state 3 (dev_stat 0x51)
Jul 20 13:20:15 ts28 ata_hsm_move: ata3: protocol 6 task_state 4 (dev_stat 0x51)
Jul 20 13:20:15 ts28 scsi_delete_timer: scmd: ffff8100defba840, rtn: 1
Jul 20 13:20:15 ts28 sr 2:0:0:0: Done: 0xffff8100defba840 TIMEOUT
Jul 20 13:20:15 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 20 13:20:15 ts28 sr 2:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
Jul 20 13:20:15 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 20 13:20:15 ts28 ata_scsi_timed_out: ENTER
Jul 20 13:20:15 ts28 ata_scsi_timed_out: EXIT, ret=0
Jul 20 13:20:15 ts28 Waking error handler thread
Jul 20 13:20:15 ts28 Error handler scsi_eh_2 waking up
Jul 20 13:20:15 ts28 ata_scsi_error: ENTER
Jul 20 13:20:15 ts28 ata_port_flush_task: ENTER
Jul 20 13:20:15 ts28 ata_port_flush_task: flush #1
Jul 20 13:20:15 ts28 ata3: ata_port_flush_task: flush #2
Jul 20 13:20:15 ts28 ata3: ata_port_flush_task: EXIT
Jul 20 13:20:15 ts28 ata_eh_autopsy: ENTER
Jul 20 13:20:15 ts28 atapi_eh_request_sense: ATAPI request sense
Jul 20 13:20:15 ts28 ata3: ata_dev_select: ENTER, device 0, wait 1
Jul 20 13:20:15 ts28 ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x20
Jul 20 13:20:15 ts28 ata_tf_load: device 0xA0
Jul 20 13:20:15 ts28 ata_exec_command: ata3: cmd 0xA0
Jul 20 13:20:15 ts28 ata_hsm_move: ata3: protocol 5 task_state 1 (dev_stat 0x58)
Jul 20 13:20:15 ts28 atapi_send_cdb: send cdb
Jul 20 13:20:15 ts28 ata_host_intr: ata3: protocol 5 task_state 2
Jul 20 13:20:15 ts28 ata_hsm_move: ata3: protocol 5 task_state 2 (dev_stat 0x58)
Jul 20 13:20:15 ts28 atapi_pio_bytes: ata3: xfering 18 bytes
Jul 20 13:20:15 ts28 __atapi_pio_bytes: data read
Jul 20 13:20:15 ts28 ata_host_intr: ata3: protocol 5 task_state 2
Jul 20 13:20:15 ts28 ata_hsm_move: ata3: protocol 5 task_state 2 (dev_stat 0x50)
Jul 20 13:20:15 ts28 ata_hsm_move: ata3: protocol 5 task_state 3 (dev_stat 0x50)
Jul 20 13:20:15 ts28 ata_hsm_move: ata3: dev 0 command complete, drv_stat 0x50
Jul 20 13:20:15 ts28 ata_port_flush_task: ENTER
Jul 20 13:20:15 ts28 ata_port_flush_task: flush #1
Jul 20 13:20:15 ts28 ata3: ata_port_flush_task: flush #2
Jul 20 13:20:15 ts28 ata3: ata_port_flush_task: EXIT
Jul 20 13:20:15 ts28 ata_eh_autopsy: EXIT
Jul 20 13:20:15 ts28 ata_eh_recover: ENTER
Jul 20 13:20:15 ts28 ata_eh_revalidate_and_attach: ENTER
Jul 20 13:20:15 ts28 ata_eh_recover: EXIT, rc=0
Jul 20 13:20:15 ts28 atapi_qc_complete: ENTER, err_mask 0x0
Jul 20 13:20:15 ts28 scsi_eh_2: flush finish cmd: ffff8100defba840
Jul 20 13:20:15 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 8000002)
Jul 20 13:20:15 ts28 0 sectors total, 0 bytes done.
Jul 20 13:20:15 ts28 use_sg is 0
Jul 20 13:20:15 ts28 ata_scsi_error: EXIT
Jul 20 13:20:15 ts28 scsi_restart_operations: waking up host to restart
Jul 20 13:20:15 ts28 Error handler scsi_eh_2 sleeping
Jul 20 13:20:15 ts28 scsi_block_when_processing_errors: rtn: 1
Jul 20 13:20:15 ts28 scsi_add_timer: scmd: ffff8100defba6c0, time: 30000, (ffffffff80382c14)
Jul 20 13:20:15 ts28 sr 2:0:0:0: Send: 0xffff8100defba6c0 
Jul 20 13:20:15 ts28 sr 2:0:0:0: CDB: Read TOC/PMA/ATIP: 43 00 00 00 00 00 00 00 0c 40
Jul 20 13:20:15 ts28 buffer = 0xffff810037e9a2c0, bufflen = 12, done = 0xffffffff803856e5, queuecommand 0xffffffff8039758e
Jul 20 13:20:15 ts28 ata_scsi_dump_cdb: CDB (3:0,0,0) 43 00 00 00 00 00 00 00 0c
Jul 20 13:20:15 ts28 ata_scsi_translate: ENTER
Jul 20 13:20:15 ts28 ata3: ata_dev_select: ENTER, device 0, wait 1
Jul 20 13:20:15 ts28 ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x20
Jul 20 13:20:15 ts28 ata_tf_load: device 0xA0
Jul 20 13:20:15 ts28 ata_exec_command: ata3: cmd 0xA0
Jul 20 13:20:15 ts28 ata_scsi_translate: EXIT
Jul 20 13:20:15 ts28 leaving scsi_dispatch_cmnd()
Jul 20 13:20:15 ts28 ata_hsm_move: ata3: protocol 5 task_state 1 (dev_stat 0x58)
Jul 20 13:20:15 ts28 atapi_send_cdb: send cdb
Jul 20 13:20:15 ts28 ata_host_intr: ata3: protocol 5 task_state 2
Jul 20 13:20:15 ts28 ata_hsm_move: ata3: protocol 5 task_state 2 (dev_stat 0x51)
Jul 20 13:20:15 ts28 ata_hsm_move: ata3: protocol 5 task_state 3 (dev_stat 0x51)
Jul 20 13:20:15 ts28 ata_hsm_move: ata3: protocol 5 task_state 4 (dev_stat 0x51)
Jul 20 13:20:16 ts28 scsi_delete_timer: scmd: ffff8100defba6c0, rtn: 1
Jul 20 13:20:16 ts28 sr 2:0:0:0: Done: 0xffff8100defba6c0 TIMEOUT
Jul 20 13:20:16 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 20 13:20:16 ts28 sr 2:0:0:0: CDB: Read TOC/PMA/ATIP: 43 00 00 00 00 00 00 00 0c 40
Jul 20 13:20:16 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 20 13:20:16 ts28 ata_scsi_timed_out: ENTER
Jul 20 13:20:16 ts28 ata_scsi_timed_out: EXIT, ret=0
Jul 20 13:20:16 ts28 Waking error handler thread
Jul 20 13:20:16 ts28 Error handler scsi_eh_2 waking up
Jul 20 13:20:16 ts28 ata_scsi_error: ENTER
Jul 20 13:20:16 ts28 ata_port_flush_task: ENTER
Jul 20 13:20:16 ts28 ata_port_flush_task: flush #1
Jul 20 13:20:16 ts28 ata3: ata_port_flush_task: flush #2
Jul 20 13:20:16 ts28 ata3: ata_port_flush_task: EXIT
Jul 20 13:20:16 ts28 ata_eh_autopsy: ENTER
Jul 20 13:20:16 ts28 atapi_eh_request_sense: ATAPI request sense
Jul 20 13:20:16 ts28 ata3: ata_dev_select: ENTER, device 0, wait 1
Jul 20 13:20:16 ts28 ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x20
Jul 20 13:20:16 ts28 ata_tf_load: device 0xA0
Jul 20 13:20:16 ts28 ata_exec_command: ata3: cmd 0xA0
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 1 (dev_stat 0x58)
Jul 20 13:20:16 ts28 atapi_send_cdb: send cdb
Jul 20 13:20:16 ts28 ata_host_intr: ata3: protocol 5 task_state 2
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 2 (dev_stat 0x58)
Jul 20 13:20:16 ts28 atapi_pio_bytes: ata3: xfering 18 bytes
Jul 20 13:20:16 ts28 __atapi_pio_bytes: data read
Jul 20 13:20:16 ts28 ata_host_intr: ata3: protocol 5 task_state 2
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 2 (dev_stat 0x50)
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 3 (dev_stat 0x50)
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: dev 0 command complete, drv_stat 0x50
Jul 20 13:20:16 ts28 ata_port_flush_task: ENTER
Jul 20 13:20:16 ts28 ata_port_flush_task: flush #1
Jul 20 13:20:16 ts28 ata3: ata_port_flush_task: flush #2
Jul 20 13:20:16 ts28 ata3: ata_port_flush_task: EXIT
Jul 20 13:20:16 ts28 ata_eh_autopsy: EXIT
Jul 20 13:20:16 ts28 ata_eh_recover: ENTER
Jul 20 13:20:16 ts28 ata_eh_revalidate_and_attach: ENTER
Jul 20 13:20:16 ts28 ata_eh_recover: EXIT, rc=0
Jul 20 13:20:16 ts28 atapi_qc_complete: ENTER, err_mask 0x0
Jul 20 13:20:16 ts28 scsi_eh_2: flush finish cmd: ffff8100defba6c0
Jul 20 13:20:16 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 8000002)
Jul 20 13:20:16 ts28 0 sectors total, 12 bytes done.
Jul 20 13:20:16 ts28 use_sg is 1
Jul 20 13:20:16 ts28 ata_scsi_error: EXIT
Jul 20 13:20:16 ts28 scsi_restart_operations: waking up host to restart
Jul 20 13:20:16 ts28 Error handler scsi_eh_2 sleeping
Jul 20 13:20:16 ts28 scsi_block_when_processing_errors: rtn: 1
Jul 20 13:20:16 ts28 scsi_add_timer: scmd: ffff8100defba9c0, time: 30000, (ffffffff80382c14)
Jul 20 13:20:16 ts28 sr 2:0:0:0: Send: 0xffff8100defba9c0 
Jul 20 13:20:16 ts28 sr 2:0:0:0: CDB: Read TOC/PMA/ATIP: 43 00 00 00 00 00 00 00 0c 00
Jul 20 13:20:16 ts28 buffer = 0xffff810037e9aac0, bufflen = 12, done = 0xffffffff803856e5, queuecommand 0xffffffff8039758e
Jul 20 13:20:16 ts28 ata_scsi_dump_cdb: CDB (3:0,0,0) 43 00 00 00 00 00 00 00 0c
Jul 20 13:20:16 ts28 ata_scsi_translate: ENTER
Jul 20 13:20:16 ts28 ata3: ata_dev_select: ENTER, device 0, wait 1
Jul 20 13:20:16 ts28 ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x20
Jul 20 13:20:16 ts28 ata_tf_load: device 0xA0
Jul 20 13:20:16 ts28 ata_exec_command: ata3: cmd 0xA0
Jul 20 13:20:16 ts28 ata_scsi_translate: EXIT
Jul 20 13:20:16 ts28 leaving scsi_dispatch_cmnd()
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 1 (dev_stat 0x58)
Jul 20 13:20:16 ts28 atapi_send_cdb: send cdb
Jul 20 13:20:16 ts28 ata_host_intr: ata3: protocol 5 task_state 2
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 2 (dev_stat 0x51)
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 3 (dev_stat 0x51)
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 4 (dev_stat 0x51)
Jul 20 13:20:16 ts28 scsi_delete_timer: scmd: ffff8100defba9c0, rtn: 1
Jul 20 13:20:16 ts28 sr 2:0:0:0: Done: 0xffff8100defba9c0 TIMEOUT
Jul 20 13:20:16 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 20 13:20:16 ts28 sr 2:0:0:0: CDB: Read TOC/PMA/ATIP: 43 00 00 00 00 00 00 00 0c 00
Jul 20 13:20:16 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 20 13:20:16 ts28 
Jul 20 13:20:16 ts28 ata_scsi_timed_out: ENTER
Jul 20 13:20:16 ts28 ata_scsi_timed_out: EXIT, ret=0
Jul 20 13:20:16 ts28 Waking error handler thread
Jul 20 13:20:16 ts28 Error handler scsi_eh_2 waking up
Jul 20 13:20:16 ts28 ata_scsi_error: ENTER
Jul 20 13:20:16 ts28 ata_port_flush_task: ENTER
Jul 20 13:20:16 ts28 ata_port_flush_task: flush #1
Jul 20 13:20:16 ts28 ata3: ata_port_flush_task: flush #2
Jul 20 13:20:16 ts28 ata3: ata_port_flush_task: EXIT
Jul 20 13:20:16 ts28 ata_eh_autopsy: ENTER
Jul 20 13:20:16 ts28 atapi_eh_request_sense: ATAPI request sense
Jul 20 13:20:16 ts28 
Jul 20 13:20:16 ts28 ata3: ata_dev_select: ENTER, device 0, wait 1
Jul 20 13:20:16 ts28 ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x20
Jul 20 13:20:16 ts28 ata_tf_load: device 0xA0
Jul 20 13:20:16 ts28 ata_exec_command: ata3: cmd 0xA0
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 1 (dev_stat 0x58)
Jul 20 13:20:16 ts28 atapi_send_cdb: send cdb
Jul 20 13:20:16 ts28 ata_host_intr: ata3: protocol 5 task_state 2
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 2 (dev_stat 0x58)
Jul 20 13:20:16 ts28 atapi_pio_bytes: ata3: xfering 18 bytes
Jul 20 13:20:16 ts28 __atapi_pio_bytes: data read
Jul 20 13:20:16 ts28 ata_host_intr: ata3: protocol 5 task_state 2
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 2 (dev_stat 0x50)
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 3 (dev_stat 0x50)
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: dev 0 command complete, drv_stat 0x50
Jul 20 13:20:16 ts28 ata_port_flush_task: ENTER
Jul 20 13:20:16 ts28 ata_port_flush_task: flush #1
Jul 20 13:20:16 ts28 ata3: ata_port_flush_task: flush #2
Jul 20 13:20:16 ts28 ata3: ata_port_flush_task: EXIT
Jul 20 13:20:16 ts28 ata_eh_autopsy: EXIT
Jul 20 13:20:16 ts28 
Jul 20 13:20:16 ts28 ata_eh_recover: ENTER
Jul 20 13:20:16 ts28 ata_eh_revalidate_and_attach: ENTER
Jul 20 13:20:16 ts28 ata_eh_recover: EXIT, rc=0
Jul 20 13:20:16 ts28 
Jul 20 13:20:16 ts28 atapi_qc_complete: ENTER, err_mask 0x0
Jul 20 13:20:16 ts28 
Jul 20 13:20:16 ts28 scsi_eh_2: flush finish cmd: ffff8100defba9c0
Jul 20 13:20:16 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 8000002)
Jul 20 13:20:16 ts28 0 sectors total, 12 bytes done.
Jul 20 13:20:16 ts28 use_sg is 1
Jul 20 13:20:16 ts28 ata_scsi_error: EXIT
Jul 20 13:20:16 ts28 scsi_restart_operations: waking up host to restart
Jul 20 13:20:16 ts28 scsi_add_timer: scmd: ffff8100defba540, time: 30000, (ffffffff80382c14)
Jul 20 13:20:16 ts28 sr 2:0:0:0: Send: 0xffff8100defba540 
Jul 20 13:20:16 ts28 sr 2:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
Jul 20 13:20:16 ts28 buffer = 0xffff810037e9adc0, bufflen = 8, done = 0xffffffff803856e5, queuecommand 0xffffffff8039758e
Jul 20 13:20:16 ts28 ata_scsi_dump_cdb: CDB (3:0,0,0) 25 00 00 00 00 00 00 00 00
Jul 20 13:20:16 ts28 ata_scsi_translate: ENTER
Jul 20 13:20:16 ts28 ata3: ata_dev_select: ENTER, device 0, wait 1
Jul 20 13:20:16 ts28 ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x20
Jul 20 13:20:16 ts28 ata_tf_load: device 0xA0
Jul 20 13:20:16 ts28 ata_exec_command: ata3: cmd 0xA0
Jul 20 13:20:16 ts28 ata_scsi_translate: EXIT
Jul 20 13:20:16 ts28 leaving scsi_dispatch_cmnd()
Jul 20 13:20:16 ts28 Error handler scsi_eh_2 sleeping
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 1 (dev_stat 0x58)
Jul 20 13:20:16 ts28 atapi_send_cdb: send cdb
Jul 20 13:20:16 ts28 ata_host_intr: ata3: protocol 5 task_state 2
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 2 (dev_stat 0x51)
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 3 (dev_stat 0x51)
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 4 (dev_stat 0x51)
Jul 20 13:20:16 ts28 scsi_delete_timer: scmd: ffff8100defba540, rtn: 1
Jul 20 13:20:16 ts28 sr 2:0:0:0: Done: 0xffff8100defba540 TIMEOUT
Jul 20 13:20:16 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 20 13:20:16 ts28 sr 2:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
Jul 20 13:20:16 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 20 13:20:16 ts28 ata_scsi_timed_out: ENTER
Jul 20 13:20:16 ts28 ata_scsi_timed_out: EXIT, ret=0
Jul 20 13:20:16 ts28 Waking error handler thread
Jul 20 13:20:16 ts28 Error handler scsi_eh_2 waking up
Jul 20 13:20:16 ts28 ata_scsi_error: ENTER
Jul 20 13:20:16 ts28 ata_port_flush_task: ENTER
Jul 20 13:20:16 ts28 ata_port_flush_task: flush #1
Jul 20 13:20:16 ts28 ata3: ata_port_flush_task: flush #2
Jul 20 13:20:16 ts28 ata3: ata_port_flush_task: EXIT
Jul 20 13:20:16 ts28 ata_eh_autopsy: ENTER
Jul 20 13:20:16 ts28 atapi_eh_request_sense: ATAPI request sense
Jul 20 13:20:16 ts28 ata3: ata_dev_select: ENTER, device 0, wait 1
Jul 20 13:20:16 ts28 ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x20
Jul 20 13:20:16 ts28 ata_tf_load: device 0xA0
Jul 20 13:20:16 ts28 ata_exec_command: ata3: cmd 0xA0
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 1 (dev_stat 0x58)
Jul 20 13:20:16 ts28 atapi_send_cdb: send cdb
Jul 20 13:20:16 ts28 ata_host_intr: ata3: protocol 5 task_state 2
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 2 (dev_stat 0x58)
Jul 20 13:20:16 ts28 atapi_pio_bytes: ata3: xfering 18 bytes
Jul 20 13:20:16 ts28 __atapi_pio_bytes: data read
Jul 20 13:20:16 ts28 ata_host_intr: ata3: protocol 5 task_state 2
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 2 (dev_stat 0x50)
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 3 (dev_stat 0x50)
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: dev 0 command complete, drv_stat 0x50
Jul 20 13:20:16 ts28 ata_port_flush_task: ENTER
Jul 20 13:20:16 ts28 ata_port_flush_task: flush #1
Jul 20 13:20:16 ts28 ata3: ata_port_flush_task: flush #2
Jul 20 13:20:16 ts28 ata3: ata_port_flush_task: EXIT
Jul 20 13:20:16 ts28 ata_eh_autopsy: EXIT
Jul 20 13:20:16 ts28 ata_eh_recover: ENTER
Jul 20 13:20:16 ts28 ata_eh_revalidate_and_attach: ENTER
Jul 20 13:20:16 ts28 ata_eh_recover: EXIT, rc=0
Jul 20 13:20:16 ts28 atapi_qc_complete: ENTER, err_mask 0x0
Jul 20 13:20:16 ts28 scsi_eh_2: flush finish cmd: ffff8100defba540
Jul 20 13:20:16 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 8000002)
Jul 20 13:20:16 ts28 0 sectors total, 8 bytes done.
Jul 20 13:20:16 ts28 use_sg is 1
Jul 20 13:20:16 ts28 ata_scsi_error: EXIT
Jul 20 13:20:16 ts28 scsi_restart_operations: waking up host to restart
Jul 20 13:20:16 ts28 scsi_add_timer: scmd: ffff8100de1093c0, time: 30000, (ffffffff80382c14)
Jul 20 13:20:16 ts28 
Jul 20 13:20:16 ts28 sr 2:0:0:0: Send: 0xffff8100de1093c0 
Jul 20 13:20:16 ts28 sr 2:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
Jul 20 13:20:16 ts28 buffer = 0xffff810037e9a1c0, bufflen = 8, done = 0xffffffff803856e5, queuecommand 0xffffffff8039758e
Jul 20 13:20:16 ts28 ata_scsi_dump_cdb: CDB (3:0,0,0) 25 00 00 00 00 00 00 00 00
Jul 20 13:20:16 ts28 ata_scsi_translate: ENTER
Jul 20 13:20:16 ts28 ata3: ata_dev_select: ENTER, device 0, wait 1
Jul 20 13:20:16 ts28 ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x20
Jul 20 13:20:16 ts28 ata_tf_load: device 0xA0
Jul 20 13:20:16 ts28 ata_exec_command: ata3: cmd 0xA0
Jul 20 13:20:16 ts28 ata_scsi_translate: EXIT
Jul 20 13:20:16 ts28 leaving scsi_dispatch_cmnd()
Jul 20 13:20:16 ts28 Error handler scsi_eh_2 sleeping
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 1 (dev_stat 0x58)
Jul 20 13:20:16 ts28 atapi_send_cdb: send cdb
Jul 20 13:20:16 ts28 ata_host_intr: ata3: protocol 5 task_state 2
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 2 (dev_stat 0x51)
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 3 (dev_stat 0x51)
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 4 (dev_stat 0x51)
Jul 20 13:20:16 ts28 scsi_delete_timer: scmd: ffff8100de1093c0, rtn: 1
Jul 20 13:20:16 ts28 sr 2:0:0:0: Done: 0xffff8100de1093c0 TIMEOUT
Jul 20 13:20:16 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 20 13:20:16 ts28 sr 2:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
Jul 20 13:20:16 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 20 13:20:16 ts28 ata_scsi_timed_out: ENTER
Jul 20 13:20:16 ts28 ata_scsi_timed_out: EXIT, ret=0
Jul 20 13:20:16 ts28 Waking error handler thread
Jul 20 13:20:16 ts28 Error handler scsi_eh_2 waking up
Jul 20 13:20:16 ts28 ata_scsi_error: ENTER
Jul 20 13:20:16 ts28 ata_port_flush_task: ENTER
Jul 20 13:20:16 ts28 ata_port_flush_task: flush #1
Jul 20 13:20:16 ts28 ata3: ata_port_flush_task: flush #2
Jul 20 13:20:16 ts28 ata3: ata_port_flush_task: EXIT
Jul 20 13:20:16 ts28 ata_eh_autopsy: ENTER
Jul 20 13:20:16 ts28 atapi_eh_request_sense: ATAPI request sense
Jul 20 13:20:16 ts28 ata3: ata_dev_select: ENTER, device 0, wait 1
Jul 20 13:20:16 ts28 ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x20
Jul 20 13:20:16 ts28 ata_tf_load: device 0xA0
Jul 20 13:20:16 ts28 ata_exec_command: ata3: cmd 0xA0
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 1 (dev_stat 0x58)
Jul 20 13:20:16 ts28 atapi_send_cdb: send cdb
Jul 20 13:20:16 ts28 ata_host_intr: ata3: protocol 5 task_state 2
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 2 (dev_stat 0x58)
Jul 20 13:20:16 ts28 atapi_pio_bytes: ata3: xfering 18 bytes
Jul 20 13:20:16 ts28 __atapi_pio_bytes: data read
Jul 20 13:20:16 ts28 ata_host_intr: ata3: protocol 5 task_state 2
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 2 (dev_stat 0x50)
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 3 (dev_stat 0x50)
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: dev 0 command complete, drv_stat 0x50
Jul 20 13:20:16 ts28 ata_port_flush_task: ENTER
Jul 20 13:20:16 ts28 
Jul 20 13:20:16 ts28 ata_port_flush_task: flush #1
Jul 20 13:20:16 ts28 ata3: ata_port_flush_task: flush #2
Jul 20 13:20:16 ts28 ata3: ata_port_flush_task: EXIT
Jul 20 13:20:16 ts28 ata_eh_autopsy: EXIT
Jul 20 13:20:16 ts28 ata_eh_recover: ENTER
Jul 20 13:20:16 ts28 ata_eh_revalidate_and_attach: ENTER
Jul 20 13:20:16 ts28 ata_eh_recover: EXIT, rc=0
Jul 20 13:20:16 ts28 atapi_qc_complete: ENTER, err_mask 0x0
Jul 20 13:20:16 ts28 scsi_eh_2: flush finish cmd: ffff8100de1093c0
Jul 20 13:20:16 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 8000002)
Jul 20 13:20:16 ts28 0 sectors total, 8 bytes done.
Jul 20 13:20:16 ts28 use_sg is 1
Jul 20 13:20:16 ts28 ata_scsi_error: EXIT
Jul 20 13:20:16 ts28 scsi_restart_operations: waking up host to restart
Jul 20 13:20:16 ts28 scsi_add_timer: scmd: ffff8100defba540, time: 30000, (ffffffff80382c14)
Jul 20 13:20:16 ts28 sr 2:0:0:0: Send: 0xffff8100defba540 
Jul 20 13:20:16 ts28 sr 2:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
Jul 20 13:20:16 ts28 buffer = 0xffff810037e9adc0, bufflen = 8, done = 0xffffffff803856e5, queuecommand 0xffffffff8039758e
Jul 20 13:20:16 ts28 ata_scsi_dump_cdb: CDB (3:0,0,0) 25 00 00 00 00 00 00 00 00
Jul 20 13:20:16 ts28 ata_scsi_translate: ENTER
Jul 20 13:20:16 ts28 ata3: ata_dev_select: ENTER, device 0, wait 1
Jul 20 13:20:16 ts28 ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x20
Jul 20 13:20:16 ts28 ata_tf_load: device 0xA0
Jul 20 13:20:16 ts28 ata_exec_command: ata3: cmd 0xA0
Jul 20 13:20:16 ts28 ata_scsi_translate: EXIT
Jul 20 13:20:16 ts28 leaving scsi_dispatch_cmnd()
Jul 20 13:20:16 ts28 Error handler scsi_eh_2 sleeping
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 1 (dev_stat 0x58)
Jul 20 13:20:16 ts28 atapi_send_cdb: send cdb
Jul 20 13:20:16 ts28 ata_host_intr: ata3: protocol 5 task_state 2
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 2 (dev_stat 0x51)
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 3 (dev_stat 0x51)
Jul 20 13:20:16 ts28 ata_hsm_move: ata3: protocol 5 task_state 4 (dev_stat 0x51)
Jul 20 13:20:17 ts28 scsi_delete_timer: scmd: ffff8100defba540, rtn: 1
Jul 20 13:20:17 ts28 sr 2:0:0:0: Done: 0xffff8100defba540 TIMEOUT
Jul 20 13:20:17 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 20 13:20:17 ts28 sr 2:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
Jul 20 13:20:17 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 20 13:20:17 ts28 ata_scsi_timed_out: ENTER
Jul 20 13:20:17 ts28 ata_scsi_timed_out: EXIT, ret=0
Jul 20 13:20:17 ts28 Waking error handler thread
Jul 20 13:20:17 ts28 Error handler scsi_eh_2 waking up
Jul 20 13:20:17 ts28 ata_scsi_error: ENTER
Jul 20 13:20:17 ts28 ata_port_flush_task: ENTER
Jul 20 13:20:17 ts28 ata_port_flush_task: flush #1
Jul 20 13:20:17 ts28 ata3: ata_port_flush_task: flush #2
Jul 20 13:20:17 ts28 ata3: ata_port_flush_task: EXIT
Jul 20 13:20:17 ts28 ata_eh_autopsy: ENTER
Jul 20 13:20:17 ts28 atapi_eh_request_sense: ATAPI request sense
Jul 20 13:20:17 ts28 ata3: ata_dev_select: ENTER, device 0, wait 1
Jul 20 13:20:17 ts28 ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x20
Jul 20 13:20:17 ts28 ata_tf_load: device 0xA0
Jul 20 13:20:17 ts28 ata_exec_command: ata3: cmd 0xA0
Jul 20 13:20:17 ts28 ata_hsm_move: ata3: protocol 5 task_state 1 (dev_stat 0x58)
Jul 20 13:20:17 ts28 atapi_send_cdb: send cdb
Jul 20 13:20:17 ts28 ata_host_intr: ata3: protocol 5 task_state 2
Jul 20 13:20:17 ts28 ata_hsm_move: ata3: protocol 5 task_state 2 (dev_stat 0x58)
Jul 20 13:20:17 ts28 atapi_pio_bytes: ata3: xfering 18 bytes
Jul 20 13:20:17 ts28 __atapi_pio_bytes: data read
Jul 20 13:20:17 ts28 ata_host_intr: ata3: protocol 5 task_state 2
Jul 20 13:20:17 ts28 ata_hsm_move: ata3: protocol 5 task_state 2 (dev_stat 0x50)
Jul 20 13:20:17 ts28 ata_hsm_move: ata3: protocol 5 task_state 3 (dev_stat 0x50)
Jul 20 13:20:17 ts28 ata_hsm_move: ata3: dev 0 command complete, drv_stat 0x50
Jul 20 13:20:17 ts28 ata_port_flush_task: ENTER
Jul 20 13:20:17 ts28 ata_port_flush_task: flush #1
Jul 20 13:20:17 ts28 ata3: ata_port_flush_task: flush #2
Jul 20 13:20:17 ts28 ata3: ata_port_flush_task: EXIT
Jul 20 13:20:17 ts28 ata_eh_autopsy: EXIT
Jul 20 13:20:17 ts28 ata_eh_recover: ENTER
Jul 20 13:20:17 ts28 ata_eh_revalidate_and_attach: ENTER
Jul 20 13:20:17 ts28 ata_eh_recover: EXIT, rc=0
Jul 20 13:20:17 ts28 
Jul 20 13:20:17 ts28 atapi_qc_complete: ENTER, err_mask 0x0
Jul 20 13:20:17 ts28 scsi_eh_2: flush finish cmd: ffff8100defba540
Jul 20 13:20:17 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 8000002)
Jul 20 13:20:17 ts28 0 sectors total, 8 bytes done.
Jul 20 13:20:17 ts28 use_sg is 1
Jul 20 13:20:17 ts28 ata_scsi_error: EXIT
Jul 20 13:20:17 ts28 cdrom: entering CDROM_DRIVE_STATUS
Jul 20 13:20:17 ts28 scsi_restart_operations: waking up host to restart
Jul 20 13:20:17 ts28 Error handler scsi_eh_2 sleeping
Jul 20 13:20:17 ts28 scsi_block_when_processing_errors: rtn: 1
Jul 20 13:20:17 ts28 scsi_add_timer: scmd: ffff8100defba9c0, time: 30000, (ffffffff80382c14)
Jul 20 13:20:17 ts28 sr 2:0:0:0: Send: 0xffff8100defba9c0 
Jul 20 13:20:17 ts28 sr 2:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
Jul 20 13:20:17 ts28 buffer = 0x0000000000000000, bufflen = 0, done = 0xffffffff803856e5, queuecommand 0xffffffff8039758e
Jul 20 13:20:17 ts28 ata_scsi_dump_cdb: CDB (3:0,0,0) 00 00 00 00 00 00 00 00 00
Jul 20 13:20:17 ts28 ata_scsi_translate: ENTER
Jul 20 13:20:17 ts28 ata3: ata_dev_select: ENTER, device 0, wait 1
Jul 20 13:20:17 ts28 ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x20
Jul 20 13:20:17 ts28 ata_tf_load: device 0xA0
Jul 20 13:20:17 ts28 ata_exec_command: ata3: cmd 0xA0
Jul 20 13:20:17 ts28 ata_scsi_translate: EXIT
Jul 20 13:20:17 ts28 leaving scsi_dispatch_cmnd()
Jul 20 13:20:17 ts28 ata_hsm_move: ata3: protocol 6 task_state 1 (dev_stat 0x58)
Jul 20 13:20:17 ts28 atapi_send_cdb: send cdb
Jul 20 13:20:17 ts28 ata_host_intr: ata3: protocol 6 task_state 3
Jul 20 13:20:17 ts28 ata_hsm_move: ata3: protocol 6 task_state 3 (dev_stat 0x51)
Jul 20 13:20:17 ts28 ata_hsm_move: ata3: protocol 6 task_state 4 (dev_stat 0x51)
Jul 20 13:20:17 ts28 scsi_delete_timer: scmd: ffff8100defba9c0, rtn: 1
Jul 20 13:20:17 ts28 sr 2:0:0:0: Done: 0xffff8100defba9c0 TIMEOUT
Jul 20 13:20:17 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 20 13:20:17 ts28 sr 2:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
Jul 20 13:20:17 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 20 13:20:17 ts28 ata_scsi_timed_out: ENTER
Jul 20 13:20:17 ts28 ata_scsi_timed_out: EXIT, ret=0
Jul 20 13:20:17 ts28 Waking error handler thread
Jul 20 13:20:17 ts28 Error handler scsi_eh_2 waking up
Jul 20 13:20:17 ts28 ata_scsi_error: ENTER
Jul 20 13:20:17 ts28 ata_port_flush_task: ENTER
Jul 20 13:20:17 ts28 ata_port_flush_task: flush #1
Jul 20 13:20:17 ts28 ata3: ata_port_flush_task: flush #2
Jul 20 13:20:17 ts28 ata3: ata_port_flush_task: EXIT
Jul 20 13:20:17 ts28 ata_eh_autopsy: ENTER
Jul 20 13:20:17 ts28 atapi_eh_request_sense: ATAPI request sense
Jul 20 13:20:17 ts28 ata3: ata_dev_select: ENTER, device 0, wait 1
Jul 20 13:20:17 ts28 ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x20
Jul 20 13:20:17 ts28 ata_tf_load: device 0xA0
Jul 20 13:20:17 ts28 ata_exec_command: ata3: cmd 0xA0
Jul 20 13:20:17 ts28 ata_hsm_move: ata3: protocol 5 task_state 1 (dev_stat 0x58)
Jul 20 13:20:17 ts28 atapi_send_cdb: send cdb
Jul 20 13:20:17 ts28 ata_host_intr: ata3: protocol 5 task_state 2
Jul 20 13:20:17 ts28 ata_hsm_move: ata3: protocol 5 task_state 2 (dev_stat 0x58)
Jul 20 13:20:17 ts28 atapi_pio_bytes: ata3: xfering 18 bytes
Jul 20 13:20:17 ts28 __atapi_pio_bytes: data read
Jul 20 13:20:17 ts28 ata_host_intr: ata3: protocol 5 task_state 2
Jul 20 13:20:17 ts28 ata_hsm_move: ata3: protocol 5 task_state 2 (dev_stat 0x50)
Jul 20 13:20:17 ts28 ata_hsm_move: ata3: protocol 5 task_state 3 (dev_stat 0x50)
Jul 20 13:20:17 ts28 ata_hsm_move: ata3: dev 0 command complete, drv_stat 0x50
Jul 20 13:20:17 ts28 ata_port_flush_task: ENTER
Jul 20 13:20:17 ts28 ata_port_flush_task: flush #1
Jul 20 13:20:17 ts28 ata3: ata_port_flush_task: flush #2
Jul 20 13:20:17 ts28 ata3: ata_port_flush_task: EXIT
Jul 20 13:20:17 ts28 ata_eh_autopsy: EXIT
Jul 20 13:20:17 ts28 ata_eh_recover: ENTER
Jul 20 13:20:17 ts28 ata_eh_revalidate_and_attach: ENTER
Jul 20 13:20:17 ts28 ata_eh_recover: EXIT, rc=0
Jul 20 13:20:17 ts28 atapi_qc_complete: ENTER, err_mask 0x0
Jul 20 13:20:17 ts28 scsi_eh_2: flush finish cmd: ffff8100defba9c0
Jul 20 13:20:17 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 8000002)
Jul 20 13:20:17 ts28 0 sectors total, 0 bytes done.
Jul 20 13:20:17 ts28 use_sg is 0
Jul 20 13:20:17 ts28 ata_scsi_error: EXIT
Jul 20 13:20:17 ts28 cdrom: entering cdrom_release
Jul 20 13:20:17 ts28 cdrom: Use count for "/dev/sr0" now zero
Jul 20 13:20:17 ts28 cdrom: sr0: No DVD+RW
Jul 20 13:20:17 ts28 cdrom: Unlocking door!
Jul 20 13:20:17 ts28 
Jul 20 13:20:17 ts28 Trying ioctl with scsi command 30
Jul 20 13:20:17 ts28 scsi_restart_operations: waking up host to restart
Jul 20 13:20:17 ts28 scsi_add_timer: scmd: ffff8100defba840, time: 10000, (ffffffff80382c14)
Jul 20 13:20:17 ts28 sr 2:0:0:0: Send: 0xffff8100defba840 
Jul 20 13:20:17 ts28 sr 2:0:0:0: CDB: Prevent/Allow Medium Removal: 1e 00 00 00 00 00
Jul 20 13:20:17 ts28 buffer = 0x0000000000000000, bufflen = 0, done = 0xffffffff803856e5, queuecommand 0xffffffff8039758e
Jul 20 13:20:17 ts28 ata_scsi_dump_cdb: CDB (3:0,0,0) 1e 00 00 00 00 00 00 00 00
Jul 20 13:20:17 ts28 ata_scsi_translate: ENTER
Jul 20 13:20:17 ts28 ata3: ata_dev_select: ENTER, device 0, wait 1
Jul 20 13:20:17 ts28 ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x20
Jul 20 13:20:17 ts28 ata_tf_load: device 0xA0
Jul 20 13:20:17 ts28 ata_exec_command: ata3: cmd 0xA0
Jul 20 13:20:17 ts28 ata_scsi_translate: EXIT
Jul 20 13:20:17 ts28 leaving scsi_dispatch_cmnd()
Jul 20 13:20:17 ts28 Error handler scsi_eh_2 sleeping
Jul 20 13:20:17 ts28 ata_hsm_move: ata3: protocol 6 task_state 1 (dev_stat 0x58)
Jul 20 13:20:17 ts28 atapi_send_cdb: send cdb
Jul 20 13:20:17 ts28 
Jul 20 13:20:17 ts28 ata_host_intr: ata3: protocol 6 task_state 3
Jul 20 13:20:17 ts28 ata_hsm_move: ata3: protocol 6 task_state 3 (dev_stat 0x50)
Jul 20 13:20:17 ts28 ata_hsm_move: ata3: dev 0 command complete, drv_stat 0x50
Jul 20 13:20:17 ts28 atapi_qc_complete: ENTER, err_mask 0x0
Jul 20 13:20:17 ts28 scsi_delete_timer: scmd: ffff8100defba840, rtn: 1
Jul 20 13:20:17 ts28 sr 2:0:0:0: Done: 0xffff8100defba840 SUCCESS
Jul 20 13:20:17 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 20 13:20:17 ts28 sr 2:0:0:0: CDB: Prevent/Allow Medium Removal: 1e 00 00 00 00 00
Jul 20 13:20:17 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 20 13:20:17 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 0)
Jul 20 13:20:17 ts28 0 sectors total, 0 bytes done.
Jul 20 13:20:17 ts28 use_sg is 0
Jul 20 13:20:17 ts28 Ioctl returned  0x0
Jul 20 13:20:17 ts28 IOCTL Releasing command

--------------000101010400000901070708--
