From: Arne Wiebalck <arne.wiebalck@cern.ch>
Subject: SG_IO problem on tape devices
Date: Tue, 3 Jun 2008 09:59:41 +0200
Message-ID: <1212479982.5079.58.camel@pcitfio23.cern.ch>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cernmx11.cern.ch ([137.138.142.198]:7866 "EHLO cernmx11.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbYFCIFM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jun 2008 04:05:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: arne.wiebalck@cern.ch

Hi all,

I got a problem using the SG_IO ioctl with our tape drives. 
In order to examine errors on our drives in more detail, I 
would like to make the sense bytes available to the 
application using the REQUEST_SENSE command.

However, there's a discrepancy between the kernel output in
/var/log/messages and what I see using SG_IO within my 
application: while the kernel sees

kernel: st0: Error with sense data: scsi1 : destination target 0, lun 0
kernel:         command = Space 01 00 0d d5 00
kernel: Info fld=0x1, Current st0: sense key Medium Error
kernel: Additional sense: Read retries exhausted
kernel: Raw sense data:0xf0 0x00 0x03 0x00 0x00 0x00 0x01 0x12 0x00 0x00
0x00 0x00 0x11 0x01 0x00 0x00 0x00 0x00 0x37 0xf7 0x10 0x01 0x00 0x00
0xf7 0x37

(which is realistic) the ioctl reports something like

70 00 00 00 00 00 00 12  00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00  10 02

(since the first bit is not set, the sense bytes are not even valid,
as far as I understand).

So, could it be that the sense bytes are already cleared when I request
them? They cleared/set by the next SCSI cmd, I assume? But shouldn't
they be valid even then?

I also tried the sg3-utils to query the drive's sense bytes, and they
report (almost) the same sense bytes as SG_IO inside my application
does. Sending an INQUIRY cmd using sg3_utils works fine, btw.

Maybe that's all a plain usage error, so please find the code I use
below.

Anything obvious I am doing wrong here? All comments appreciated. 

Cheers,
 Arne

P.s.: As I am not subscribed to the list, please CC your answer to me.

---------------------------------


#define REQUEST_SENSE_CMD 0x3
#define REQUEST_SENSE_ALLOC_LEN 0xfc  /* maximum alloc length */
#define REQUEST_SENSE_SENSEB_LEN 32
#define REQUEST_SENSE_CMDLEN 6

                unsigned char sense_b[REQUEST_SENSE_SENSEB_LEN];
                unsigned char dxfer_b[REQUEST_SENSE_ALLOC_LEN];
                unsigned char rsCmdBlk[] = {REQUEST_SENSE_CMD, 0, 0, 0,
REQUEST_SENSE_ALLOC_LEN, 0};
                struct sg_io_hdr io_hdr;

                memset(sense_b, 0, sizeof(sense_b));
                memset(dxfer_b, 0, sizeof(dxfer_b));
                memset(&io_hdr, 0, sizeof(struct sg_io_hdr));

                io_hdr.interface_id = 'S';

                io_hdr.cmdp = rsCmdBlk;
                io_hdr.cmd_len = REQUEST_SENSE_CMDLEN;
                io_hdr.timeout = 30000;

                io_hdr.sbp = sense_b;
                io_hdr.mx_sb_len = sizeof(sense_b);

                io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
                io_hdr.dxferp = (unsigned char*)dxfer_b;
                io_hdr.dxfer_len = REQUEST_SENSE_ALLOC_LEN;

                if (ioctl(tapefd, SG_IO, &io_hdr) < 0) {
                       /* handle error */
                } else {
                       /* examine sense bytes */                        
                }       
      
---------------------------- 



