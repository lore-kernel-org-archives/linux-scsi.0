From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: libata SCSI page 0x83 query
Date: Mon, 06 Mar 2006 15:12:46 -0500
Message-ID: <440C97BE.1030105@pobox.com>
References: <43AB446F.6000900@edesix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43AB446F.6000900@edesix.com>
Sender: linux-ide-owner@vger.kernel.org
To: Chris Paulson-Ellis <chris@edesix.com>
Cc: linux-ide@vger.kernel.org, Douglas Gilbert <dougg@torque.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Chris Paulson-Ellis wrote:
> Hi,
> 
> I have a problem with udev persistent device naming for SATA drives that 
> is caused by the libata implementation of the page 0x83 SCSI device 
> identifier query. See this thead from hotplug-devel:
> 
> http://marc.theaimsgroup.com/?t=113518947900002&r=1&w=2
> 
> I can work around the problem using /etc/scsi_id.config or udev rules 
> (see the thread), but here is a patch to fix the problem at source. What 
> do you think?
> 
> Regards,
> Chris.
> 
> --- drivers/scsi/libata-scsi.c.orig     2005-12-22 23:23:55.000000000 +0000
> +++ drivers/scsi/libata-scsi.c  2005-12-22 23:56:14.000000000 +0000
> @@ -1532,16 +1532,13 @@
>        return 0;
> }
> 
> -static const char *inq_83_str = "Linux ATA-SCSI simulator";
> -
> /**
>  *     ata_scsiop_inq_83 - Simulate INQUIRY EVPD page 83, device identity
>  *     @args: device IDENTIFY data / SCSI command of interest.
>  *     @rbuf: Response buffer, to which simulated SCSI cmd output is sent.
>  *     @buflen: Response buffer length.
>  *
> - *     Returns device identification.  Currently hardcoded to
> - *     return "Linux ATA-SCSI simulator".
> + *     Returns ATA device serial number (as for page 80).
>  *
>  *     LOCKING:
>  *     spin_lock_irqsave(host_set lock)
> @@ -1551,13 +1548,14 @@
>                              unsigned int buflen)
> {
>        rbuf[1] = 0x83;                 /* this page code */
> -       rbuf[3] = 4 + strlen(inq_83_str);       /* page len */
> +       rbuf[3] = 4 + ATA_SERNO_LEN;    /* page len */
> 
>        /* our one and only identification descriptor (vendor-specific) */
> -       if (buflen > (strlen(inq_83_str) + 4 + 4 - 1)) {
> +       if (buflen > (ATA_SERNO_LEN + 4 + 4 - 1)) {
>                rbuf[4 + 0] = 2;        /* code set: ASCII */
> -               rbuf[4 + 3] = strlen(inq_83_str);
> -               memcpy(rbuf + 4 + 4, inq_83_str, strlen(inq_83_str));
> +               rbuf[4 + 3] = ATA_SERNO_LEN;
> +               ata_dev_id_string(args->id, (unsigned char *) rbuf + 4 + 4,
> +                                 ATA_ID_SERNO_OFS, ATA_SERNO_LEN);

Douglas Gilbert has an improved patch along these lines...

	Jeff


