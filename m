From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: Possible explanation for mptsas ATA pass-through hangs
Date: Tue, 27 Apr 2010 18:28:18 +0530
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB249028AB0AD12@inbmail02.lsi.com>
References: <20100410093539.GB21178@kspace.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:50077 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753923Ab0D0M60 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2010 08:58:26 -0400
In-Reply-To: <20100410093539.GB21178@kspace.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ryan Kuester <rkuester@metis.kspace.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Ryan,

Sorry for delay in response.  I am able to see the behavior you have mentioned using your sample program.
I am also learning your proposed patch too. I will update my thoughts on your findings ASAP.

Thanks,
Kashyap

> -----Original Message-----
> From: Ryan Kuester [mailto:rkuester@metis.kspace.net]
> Sent: Saturday, April 10, 2010 3:06 PM
> To: Desai, Kashyap; linux-scsi@vger.kernel.org
> Subject: Possible explanation for mptsas ATA pass-through hangs
> 
> I may have an explanation for the LSI 1068 HBA hangs provoked by ATA
> pass-through commands, in particular by smartctl.
> 
> First, my version of the symptoms.  On an LSI SAS1068E HBA with SATA
> disks and with smartd running, I'm seeing occasional task, bus, and
> host
> resets, some of which lead to hard faults of the HBA requiring a
> reboot.
> Abusively looping the smartctl command,
> 
>     # while true; do smartctl -a /dev/sdb > /dev/null; done
> 
> dramatically increases the frequency of these failures to nearly one
> per
> minute.  A high IO load through the HBA while looping smartctl seems to
> improve the chance of a full scsi host reset or a non-recoverable hang.
> 
> I reduced what smartctl was doing down to a simple test case which
> causes
> the hang with a single IO when pointed at the sd interface.  See the
> code at the bottom of this e-mail.  It uses an SG_IO ioctl to issue a
> single pass-through ATA identify device command.  If the buffer
> userspace
> gives for the read data has certain alignments straddling a page
> boundary,
> the task is issued to the HBA but the HBA fails to respond.  If run
> against
> the sg interface, neither the test code nor smartctl causes a hang.
> 
> sd and sg handle the SG_IO ioctl slightly differently.  Unless you
> specifically set a flag to do direct IO, sg passes a buffer of its own,
> which is page-aligned, to the block layer and later copies the result
> into the userspace buffer regardless of its alignment.  sd, on the
> other
> hand, always does direct IO unless the userspace buffer fails an
> alignment test at block/blk-map.c line 57, in which case a page-aligned
> buffer is created for the transfer.
> 
> The alignment test currently checks for word-alignment, the default
> setup by scsi_lib.c; therefore, userspace buffers of almost any
> alignment are given directly to the HBA as DMA targets.  The hardware
> doesn't seem to like at least a couple of the alignments which cross a
> page boundary (see the test code below).  Curiously, many
> page-boundary-crossing alignments do work just fine.
> 
> So, either the hardware has an bug handling certain alignments or the
> hardware has a stricter alignment requirement than the driver is
> advertising.  If stricter alignment is required, then in no case should
> misaligned buffers from userspace be allowed through without being
> bounced or at least causing an error to be returned.
> 
> It seems the mptsas driver or its friends could use
> blk_queue_dma_alignment() to advertise a stricter alignment
> requirement.
> If so, sd does the right thing and bounces misaligned buffers (see
> block/blk-map.c line 57).  I gave the following patch to Linus's tree
> from last night a quick try and it seemed to work.  I'm sure this is
> the
> wrong place for this call, but it gets the idea across.
> 
> diff --git a/drivers/message/fusion/mptscsih.c
> b/drivers/message/fusion/mptscsih.c
> index 6796597..1e034ad 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -2450,6 +2450,8 @@ mptscsih_slave_configure(struct scsi_device
> *sdev)
>  		ioc->name,sdev->tagged_supported, sdev->simple_tags,
>  		sdev->ordered_tags));
> 
> +	blk_queue_dma_alignment (sdev->request_queue, 512 - 1);
> +
>  	return 0;
>  }
> 
> I look forward to hearing from you guys who know this hardware and code
> better.  Is the hardware at fault, or should the driver be shielding
> the
> hardware better?
> 
> Does this `fix' the problem for anyone besides me?
> 
> Regards,
> -- Ryan
> 
> 
> Here is a minimal bit of test code which causes the error.  BEWARE:
> this
> will hose the HBA at which you point it, of course.  If that's
> controlling your root disk...
> 
> /*
>  * sg_bomb -- send SG_IO ioctl which causes HBA to hang
>  *
>  *   usage: sg_bomb <device>
>  *    e.g.: sg_bomb /dev/sdb
>  *    e.g.: sg_bomb /dev/sg1
>  *
>  *   Modify offset_into_page to adjust the degree of buffer
> misalignment.
>  */
> 
> #include <unistd.h>
> #include <scsi/sg.h>
> #include <sys/ioctl.h>
> #include <fcntl.h>
> #include <stdlib.h>
> 
> int main(int argc, char* argv[])
> {
>     char* filename = argv[1];
>     unsigned int offset_into_page = 0xe40;
>     // works: unsigned int offset_into_page = 0x0;
>     // hangs: unsigned int offset_into_page = 0xf00;
>     // works: unsigned int offset_into_page = 0xf04;
> 
>     unsigned char ata_identify_cmd[] = {0x85, 0x08, 0x0e, 0, 0, 0,
> 0x01,
>         0, 0, 0, 0, 0, 0, 0, 0xec, 0};
>     unsigned char sense[32];
>     unsigned char* data = valloc(0x2000) + offset_into_page;
>     struct sg_io_hdr hdr = {
>         .interface_id = 'S',
>         .dxfer_direction = SG_DXFER_FROM_DEV,
>         .cmdp = ata_identify_cmd,
>         .cmd_len = 16,
>         .dxferp = data,
>         .dxfer_len = 512,
>         .sbp = sense,
>         .mx_sb_len = sizeof(sense),
>         .timeout = 5000,
>     };
> 
>     int fd;
>     if ((fd = open(filename, O_RDWR|O_NONBLOCK)) < 0)
>         perror();
> 
>     return ioctl(fd, SG_IO, &hdr);
> }
