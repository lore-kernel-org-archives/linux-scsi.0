From: zhou sf <sxzzsf@gmail.com>
Subject: SG_DXFER_TO_FROM_DEV does not copy user buffer to driver buffer in
	linux 2.6.28 and later?
Date: Mon, 29 Jun 2009 08:50:14 +0800
Message-ID: <42a6d9690906281750i65c5c3ccy6bfac5e1055bae77@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:42602 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbZF2AuL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2009 20:50:11 -0400
Received: by gxk26 with SMTP id 26so3309288gxk.13
        for <linux-scsi@vger.kernel.org>; Sun, 28 Jun 2009 17:50:14 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Test with the following program, and dump the data buf at queuecommand
of the driver, found the data is something like:
"00 00 00 00 ff 53 4d 42 2e 00 00 00 00 80 01 c0 00 00 00 00 00 00 00
00 00 00 00 00 02 20 4a ..."
While before 2.6.28, it is "ec ec ec ec ..." as expected.


#include <string.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <scsi/sg.h>

int main(int argc, char* argv[])
{
       int fd;
       sg_io_hdr_t io_hdr;
       int ret;

       unsigned char sensebuf[32], cdb[16], outbuf[256];

       if ((argc!=2) || (fd = open(argv[1], O_RDWR)) < 0) {
               return -1;
       }

       memset(&io_hdr, 0, sizeof(sg_io_hdr_t));
       memset(cdb, 0, sizeof(cdb));
       memset(outbuf, 0xec, sizeof(outbuf));
       memset(sensebuf, 0xec, sizeof(sensebuf));

       io_hdr.interface_id = 'S';

       io_hdr.cmdp = cdb;
       io_hdr.cmd_len = sizeof(cdb);

       io_hdr.sbp = sensebuf;
       io_hdr.mx_sb_len = sizeof(sensebuf);

       io_hdr.dxferp = outbuf;
       io_hdr.dxfer_len = sizeof(outbuf);
       io_hdr.dxfer_direction = SG_DXFER_TO_FROM_DEV;

       io_hdr.timeout = 20000;

       ret = ioctl(fd, SG_IO, &io_hdr);
       return 0;
}
