From: Douglas Gilbert <dougg@torque.net>
Subject: Re: aic7xxx support for >2TB volumes?
Date: Sun, 20 Nov 2005 11:33:44 +1000
Message-ID: <437FD278.2080807@torque.net>
References: <200511161208.02374.kilian.cavalotti@lip6.fr> <437E5E1E.2080902@torque.net> <437E80AA.2030400@torque.net> <200511191557.15533.kilian.cavalotti@lip6.fr>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:56223 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751083AbVKTBcp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Nov 2005 20:32:45 -0500
In-Reply-To: <200511191557.15533.kilian.cavalotti@lip6.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kilian CAVALOTTI <kilian.cavalotti@lip6.fr>
Cc: brking@us.ibm.com, linux-scsi@vger.kernel.org

Kilian CAVALOTTI wrote:
> On Saturday 19 November 2005 02:32, Douglas Gilbert wrote:
> 
>>Here are the test results for that patch. They indicate
>>that the READ_CAPACITY(16) is getting to the disk (which
>>doesn't support it since its capacity is 18 GB).
> 
> 
> So it seems promising. :)
> 
> FYI, I had reports from users who said to be able to use a >2TB external 
> storage array (different vendor) with that same 39160 Adaptec HBA.
> 
> Here's part of their dmesg:
> scsi4 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
>          <Adaptec 3960D Ultra160 SCSI adapter>
>          aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
> (scsi4:A:0): 160.000MB/s transfers (80.000MHz DT, offset 62, 16bit)
>    Type:   Direct-Access                      ANSI SCSI revision: 03
> scsi4:A:0:0: Tagged Queuing enabled.  Depth 4
> SCSI device sdg: 2686132224 1024-byte hdwr sectors (2750599 MB)

The READ CAPACITY (10) command can report a maximum size
of ((2**32 - 1) * blk_size) bytes. As shown above, /dev/sdg
is reporting a block (sector) size of 1024 rather than
the more normal 512 bytes that most production SCSI disks
use. With a 1024 byte block size, just under 4 TB can be
represented before READ CAPACITY (16) is needed.

> SCSI device sdg: drive cache: write back
>   sdg: unknown partition table
> Attached scsi disk sdg at scsi4, channel 0, id 0, lun 0
> 
> The weird part is that the driver does not even seem to invoke READ 
> CAPACITY(16) command, but directly succeed in getting device size.
> 
> To sum up my experiences so far:
> --------------------|----------------|---------------|--------------------------
> Ext. device (>2TB)  | HBA            | Driver	     | Result			
> --------------------|----------------|---------------|--------------------------
> Infortrend EonStore | Adaptec 39160  | aic7xxx       | READ CAPACITY(16) fails
> A16U-G1410          |		     |               |
> --------------------|----------------|---------------|--------------------------
> Infortrend EonStore | LSI Logic U320 | mptbase       | READ CAPACITY(16)
> A16U-G1410          |		     |               | success	
> --------------------|----------------|---------------|--------------------------
> Proware             | Adaptec 39160  | aic7xxx       | Direct success
> --------------------|----------------|---------------|--------------------------
> 
> So it seems to come from both the external device and the aic7xxx driver,since 
> the EonStore works with another HBA, and the aic7xxx works with another 
> device...
> 
> It seems quite strange to me, but I hope gurus here will have a rational 
> explanation. :)

I rechecked my patch and its seems correct for lk 2.6.15-rc1 .
Does 'head <kernel_src_dir>/Makefile' confirm the kernel
source version?

It is easy to apply by hand to drivers/scsi/aic7xxx/aic7xxx_osm.c
and drivers/scsi/aic7xxx/aic79xx_osm.c . Before the patch my
ahc_linux_slave_configure function starts like this:

static int
ahc_linux_slave_configure(struct scsi_device *sdev)
{
        struct  ahc_softc *ahc;

        ahc = *((struct ahc_softc **)sdev->host->hostdata);

        if (bootverbose)
                sdev_printk(KERN_INFO, sdev, "Slave Configure\n");

        ahc_linux_device_queue_depth(sdev);
.......

after the patch it looks like this:

static int
ahc_linux_slave_configure(struct scsi_device *sdev)
{
        struct  ahc_softc *ahc;

        ahc = *((struct ahc_softc **)sdev->host->hostdata);

        if (bootverbose)
                sdev_printk(KERN_INFO, sdev, "Slave Configure\n");

        if (sdev->host->max_cmd_len < MAX_COMMAND_SIZE)
                sdev->host->max_cmd_len = MAX_COMMAND_SIZE;

        ahc_linux_device_queue_depth(sdev);
.....

Those two extra line can probably be added to any
version of those drivers found in the lk 2.6 series.
The "sdev" may need to change to the appropriate
name.

Doug Gilbert


