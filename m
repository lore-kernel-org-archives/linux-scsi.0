From: Julian Bangert <jbangert@acm.org>
Subject: SG_IO
Date: Fri, 02 Apr 2010 19:16:20 +0200
Message-ID: <1270228580.12985.45.camel@fermat>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xa5.serverdomain.org ([89.107.186.22]:43769 "EHLO
	xa5.serverdomain.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab0DBRj0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Apr 2010 13:39:26 -0400
Received: from [192.168.178.28] (xa5 [89.107.186.22])
	(Authenticated sender: xa5508p1)
	by xa5.serverdomain.org (xa5.serverdomain.org) with ESMTP id 9E79A1A2001D
	for <linux-scsi@vger.kernel.org>; Fri,  2 Apr 2010 19:16:18 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello, 
I want to write a tape utility using the SG_IO interface (because I
don't have the expensive IBM one ;) ) but I have got a problem with the
SCSI interface. 
My program looks as follows:

    ioctl(g_fd,SG_IO,&io_hdr);
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

The IOCTL succeeds, but io_hdr.host_status contains SG_ERR_DID_ABORT.
All other fields are not touched. I am using an Adaptec 29160N(AIC7892)
with the adaptec aix7xxx driver  on Linux  2.6.31 (ubuntu). As far as I
know this driver supports 16 Byte commands.

Thank you very much for your assistance,

-- Julian Bangert

