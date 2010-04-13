From: Julian Bangert <jbangert@acm.org>
Subject: AIC7xxx only supports 12 byte commands with aic7892 ( was: SG_IO )
Date: Tue, 13 Apr 2010 20:48:08 +0200
Message-ID: <1271184488.13356.5.camel@fermat>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xa5.serverdomain.org ([89.107.186.22]:46017 "EHLO
	xa5.serverdomain.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab0DMSsH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2010 14:48:07 -0400
Received: from [192.168.178.28] (xa5 [89.107.186.22])
	(Authenticated sender: xa5508p1)
	by xa5.serverdomain.org (xa5.serverdomain.org) with ESMTP id 84D5C1A2000D
	for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2010 20:48:06 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello: I  use the following driver on Linux 2.6.31
Adaptec AIC7xxx driver version: 7.0
Adaptec 29160N Ultra160 SCSI adapter
aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
Allocated SCBs: 4, SG List Length: 128

Serial EEPROM:
0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 
0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 
0xb8f4 0x585c 0x2807 0x0010 0xffff 0xffff 0xffff 0xffff 
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0250 0x6f4d 

and have a program like this:
    memset(&io_hdr, 0, sizeof(struct sg_io_hdr));
        struct read_attr_cmd cmd;
        cmd.opcode = 0x8C;
        cmd.s_action = 0;
        cmd.pad1 = cmd.pad2 = cmd.pad3 = cmd.pad4 = 0;
        cmd.volid = cmd.partition = 0;
        cmd.attrib_id = htons(attribs[idx].id);
        cmd.size = htonl(buffer_size);
        cmd.control = 0;
        
        assert(sizeof(struct read_attr_cmd) == 16);
    
        io_hdr.interface_id='S';
        io_hdr.cmd_len = 16;//sizeof cmd;
        io_hdr.mx_sb_len= sizeof(sense_b);
        io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
        io_hdr.dxferp = buffer;
        io_hdr.dxfer_len = buffer_size;
        io_hdr.cmdp = (unsigned char *) &cmd;
        io_hdr.sbp = sense_b;
        io_hdr.timeout = 10000;
        
        if(ioctl(g_fd,SG_IO,&io_hdr) == -1)
(c.f. my earlier message)

On execution, it gets host_status=5 and the following messages are logged:Apr 13 20:41:35 fermat kernel: [10526.952015] st 6:0:12:0: [sg5] Send: 0xffff88020d8c8f00 
Apr 13 20:41:35 fermat kernel: [10526.952021] st 6:0:12:0: [sg5] CDB: Read attributes: 8c 00 00 00 00 00 00 00 00 01 00 00 00 28 00 00
Apr 13 20:41:35 fermat kernel: [10526.952037] buffer = 0xffff88020d8c8600, bufflen = 40, queuecommand 0xffffffffa0052bc0
Apr 13 20:41:35 fermat kernel: [10526.952040] queuecommand : command too long. cdb_size=16 host->max_cmd_len=12
Apr 13 20:41:35 fermat kernel: [10526.952044] leaving scsi_dispatch_cmnd()
Apr 13 20:41:35 fermat kernel: [10526.952049] st 6:0:12:0: [sg5] Done: 0xffff88020d8c8f00 SUCCESS
Apr 13 20:41:35 fermat kernel: [10526.952055] st 6:0:12:0: [sg5] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK


Could you please provide assistance, or information if it is safe ( or if there already is a patch) to force the driver to do 16-byte commands?

Best regards, Julian Bangert

