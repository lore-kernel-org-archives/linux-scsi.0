From: "Andy Kennedy" <akennedy@wpid-am.com>
Subject: CDROMSUBCHNL. . .
Date: Sun, 26 Sep 2004 22:53:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <007101c4a445$7f150840$0201010a@ankkennedy>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dadsl-206-41.webshoppe.net ([65.161.206.41]:28946 "EHLO
	mail.wpid-am.com") by vger.kernel.org with ESMTP id S265697AbUI0Dwp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Sep 2004 23:52:45 -0400
Received: from ankkennedy (ank.wpid-am.com [10.1.1.2])
	by mail.wpid-am.com (8.12.3/8.12.3) with SMTP id i8R3qetc010603
	for <linux-scsi@vger.kernel.org>; Sun, 26 Sep 2004 22:52:40 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I use the sr_ioctl calls in a program that I wrote to record tracks off CDs.
The most important one that I use is CDROMSUBCHNL.  I found that in 2.2.16
"case CDROMSUBCHNL" was removed without documentation.  I have grepped all
around in that kernel and also in the one before it and found nothing about
why it was to be removed.  Anyone have any idea why it got taken out and can
we put it back in?

The missing code is as follows:
    case CDROMSUBCHNL:
    {
        struct cdrom_subchnl* subchnl = (struct cdrom_subchnl*)arg;
        char * buffer;

        sr_cmd[0] = SCMD_READ_SUBCHANNEL;
        sr_cmd[1] = ((scsi_CDs[target].device->lun) << 5) | 0x02;    /* MSF
form
at */
        sr_cmd[2] = 0x40;    /* I do want the subchannel info */
        sr_cmd[3] = 0x01;    /* Give me current position info */
        sr_cmd[4] = sr_cmd[5] = 0;
        sr_cmd[6] = 0;
        sr_cmd[7] = 0;
        sr_cmd[8] = 16;
        sr_cmd[9] = 0;

        if ((buffer = (unsigned char *) scsi_malloc(512)) == NULL)
                return -ENOMEM;

        result = sr_do_ioctl(target, sr_cmd, buffer, 16, 0);

        subchnl->cdsc_audiostatus = buffer[1];
        subchnl->cdsc_format = CDROM_MSF;
        subchnl->cdsc_ctrl = buffer[5] & 0xf;
        subchnl->cdsc_trk = buffer[6];
        subchnl->cdsc_ind = buffer[7];

        subchnl->cdsc_reladdr.msf.minute = buffer[13];
        subchnl->cdsc_reladdr.msf.second = buffer[14];
        subchnl->cdsc_reladdr.msf.frame = buffer[15];
        subchnl->cdsc_absaddr.msf.minute = buffer[9];
        subchnl->cdsc_absaddr.msf.second = buffer[10];
        subchnl->cdsc_absaddr.msf.frame = buffer[11];

        scsi_free(buffer, 512);
        break;
    }

Thanks,
Andy

