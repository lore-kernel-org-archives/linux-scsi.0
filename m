From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: SG_DXFER_TO_FROM_DEV does not copy user buffer to driver buffer
 in 	linux 2.6.28 and later?
Date: Mon, 29 Jun 2009 13:41:20 +0200
Message-ID: <4A48A860.5010803@interlog.com>
References: <42a6d9690906281750i65c5c3ccy6bfac5e1055bae77@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from firefly.infotech.no ([82.134.31.146]:53813 "EHLO
	elrond.bb.infotech.no" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752934AbZF2LlW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2009 07:41:22 -0400
In-Reply-To: <42a6d9690906281750i65c5c3ccy6bfac5e1055bae77@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: zhou sf <sxzzsf@gmail.com>
Cc: linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

The semantics of SG_DXFER_TO_FROM_DEV were:
   - copy user space buffer to kernel (LLD) buffer
   - do SCSI command which is assumed to be of the DATA_IN
     (data from device) variety. This would overwrite
     some or all of the kernel buffer
   - copy kernel (LLD) buffer back to the user space.

The idea was to detect short reads by filling the original
user space buffer with some marker bytes ("0xec" it would
seem in this report). The "resid" value is a better way
of detecting short reads but that was only added this century
and requires co-operation from the LLD.

There were major plumbing changes in the sg driver around
lk 2.6.28 and it looks like the above nuance was lost.
Perhaps the block layer does support the above "double
shuffle".


Doug Gilbert
cc-ed to Tomo for comments


zhou sf wrote:
> Test with the following program, and dump the data buf at queuecommand
> of the driver, found the data is something like:
> "00 00 00 00 ff 53 4d 42 2e 00 00 00 00 80 01 c0 00 00 00 00 00 00 00
> 00 00 00 00 00 02 20 4a ..."
> While before 2.6.28, it is "ec ec ec ec ..." as expected.
> 
> 
> #include <string.h>
> #include <fcntl.h>
> #include <sys/ioctl.h>
> #include <scsi/sg.h>
> 
> int main(int argc, char* argv[])
> {
>        int fd;
>        sg_io_hdr_t io_hdr;
>        int ret;
> 
>        unsigned char sensebuf[32], cdb[16], outbuf[256];
> 
>        if ((argc!=2) || (fd = open(argv[1], O_RDWR)) < 0) {
>                return -1;
>        }
> 
>        memset(&io_hdr, 0, sizeof(sg_io_hdr_t));
>        memset(cdb, 0, sizeof(cdb));
>        memset(outbuf, 0xec, sizeof(outbuf));
>        memset(sensebuf, 0xec, sizeof(sensebuf));
> 
>        io_hdr.interface_id = 'S';
> 
>        io_hdr.cmdp = cdb;
>        io_hdr.cmd_len = sizeof(cdb);
> 
>        io_hdr.sbp = sensebuf;
>        io_hdr.mx_sb_len = sizeof(sensebuf);
> 
>        io_hdr.dxferp = outbuf;
>        io_hdr.dxfer_len = sizeof(outbuf);
>        io_hdr.dxfer_direction = SG_DXFER_TO_FROM_DEV;
> 
>        io_hdr.timeout = 20000;
> 
>        ret = ioctl(fd, SG_IO, &io_hdr);
>        return 0;
> }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

