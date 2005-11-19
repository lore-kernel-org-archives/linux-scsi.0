From: Douglas Gilbert <dougg@torque.net>
Subject: Re: aic7xxx support for >2TB volumes?
Date: Sat, 19 Nov 2005 11:32:26 +1000
Message-ID: <437E80AA.2030400@torque.net>
References: <200511161208.02374.kilian.cavalotti@lip6.fr> <437D97E9.8020709@torque.net> <200511181355.17911.kilian.cavalotti@lip6.fr> <437DECDB.3070509@us.ibm.com> <437E5E1E.2080902@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:28084 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1030266AbVKSBbM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2005 20:31:12 -0500
In-Reply-To: <437E5E1E.2080902@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: brking@us.ibm.com, Kilian CAVALOTTI <kilian.cavalotti@lip6.fr>, linux-scsi@vger.kernel.org

Here are the test results for that patch. They indicate
that the READ_CAPACITY(16) is getting to the disk (which
doesn't support it since its capacity is 18 GB).

# sg_readcap -16 -vv /dev/sdb
    read capacity (16) cdb: 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
READ CAPACITY 16 command error: SCSI status: Check Condition
 Fixed format, current;  Sense key: Illegal Request
 Additional sense: Invalid command operation code
  Field replaceable unit code: 2
  Sense Key Specific: Error in Command byte 0 bit 7
 Raw sense data (in hex):
        70 00 05 00 00 00 00 0a  00 00 00 00 20 00 02 cf
        00 00
plus...: Driver_status=0x08 [DRIVER_SENSE, SUGGEST_OK]
READ CAPACITY (16) not supported

# lsscsi
[0:0:0:0]    disk    SEAGATE  ST318451LW       0003  /dev/sdb
[3:0:0:0]    disk    ATA      ST380013AS       3.18  /dev/sda

# lsscsi -H
[0]    aic7xxx
[1]    sym53c8xx
[2]    sym53c8xx
[3]    sata_sil


# lspci
....
00:0e.0 RAID bus controller: CMD Technology Inc Silicon Image SiI 3112 SATARaid Controller (rev 02)
00:0f.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 02)
00:10.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 Ultra3 SCSI Adapter (rev 01)
00:10.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 Ultra3 SCSI Adapter (rev 01)


BTW That adaptec controller is labelled "APD-29160N MAC".
My PC BIOS doesn't see it, so I can't boot of it, but
linux sees it ok. That makes it useful for testing ...

Doug Gilbert


Douglas Gilbert wrote:
> Brian King wrote:
> 
>>Kilian CAVALOTTI wrote:
>>
>>
>>
>>>What I can't really understand is how a device could fail on a READ CAPACITY 
>>>16 if plugged on an HBA, but work if plugged on another one... 
>>
>>
>>Looks to me like the aic7xxx driver does not change max_cmd_len from
>>the default of 12, so any 16 byte cdb gets failed back by scsi core.
> 
> 
> Indeed, the DID_ABORT on the READ CAPACITY(16) suggests
> that the command is not making it out to the scsi bus.
> Strange that in lk 2.6 the scsi subsystem still defaults
> to a maximum of 12 byte scsi commands, unless overridden
> by the LLD.
> 
> Perhaps Kilian could try the following patch (borrowed from
> scsi_debug). The patch is against lk 2.6.15-rc1 but should
> by widely applicable (unless the aic7... series really
> does have a 12 byte limit). I will report back if this
> patch has any adverse impact on "sg_readcap -16" which
> should report: "illegal request/invalid command operation
> code" on my hardware.
> 
> Doug Gilbert
> 
> 
> 
> 
> ------------------------------------------------------------------------
> 
> --- linux/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-11-15 13:15:26.000000000 +1000
> +++ linux/drivers/scsi/aic7xxx/aic7xxx_osm.c2615rc1big	2005-11-19 08:45:08.000000000 +1000
> @@ -637,6 +637,9 @@
>  	if (bootverbose)
>  		sdev_printk(KERN_INFO, sdev, "Slave Configure\n");
>  
> +        if (sdev->host->max_cmd_len < MAX_COMMAND_SIZE)
> +                sdev->host->max_cmd_len = MAX_COMMAND_SIZE;
> +
>  	ahc_linux_device_queue_depth(sdev);
>  
>  	/* Initial Domain Validation */
> --- linux/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-11-15 13:15:26.000000000 +1000
> +++ linux/drivers/scsi/aic7xxx/aic79xx_osm.c2615rc1big	2005-11-19 08:45:29.000000000 +1000
> @@ -559,6 +559,9 @@
>  	if (bootverbose)
>  		sdev_printk(KERN_INFO, sdev, "Slave Configure\n");
>  
> +        if (sdev->host->max_cmd_len < MAX_COMMAND_SIZE)
> +                sdev->host->max_cmd_len = MAX_COMMAND_SIZE;
> +
>  	ahd_linux_device_queue_depth(sdev);
>  
>  	/* Initial Domain Validation */

