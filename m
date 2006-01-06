From: patman@aracnet.com
Subject: Re: /dev/disk/by-id incomplete and unhelpful for SATA drives
Date: Thu, 5 Jan 2006 17:36:40 -0800
Message-ID: <20060106013640.GA27841@aracnet.com>
References: <doc5jl$acv$1@sea.gmane.org> <20051221185518.GA9100@vrfy.org> <43A9CFE0.2070103@edesix.com> <20051222043527.GA13175@vrfy.org> <43AA8D0B.10504@edesix.com> <20051222183525.GA17871@devserv.devel.redhat.com> <43AB40E2.1050009@edesix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jade.aracnet.com ([216.99.193.136]:1453 "EHLO
	jade.spiritone.com") by vger.kernel.org with ESMTP id S1750893AbWAFBhA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jan 2006 20:37:00 -0500
Content-Disposition: inline
In-Reply-To: <43AB40E2.1050009@edesix.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Paulson-Ellis <chris@edesix.com>
Cc: Bill Nottingham <notting@redhat.com>, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Fri, Dec 23, 2005 at 12:12:18AM +0000, Chris Paulson-Ellis wrote:

> >Why not just fix the kernel when it's filling in the page 83
> >data to pull the serial from page 80 instead of putting *that* there?
> >
> >Bill
> 
> Indeed. Here's the patch. Now I have 3 ways to fix this. Any more anyone?

This is the best approach, I think you could even remove page 0x83 support
and still be SCSI compliant. You should add a sign-off and re-send the
patch to linux-scsi (cc-ed here) and jeff garzik.

What was scsi_id output before and after the patch?

> --- drivers/scsi/libata-scsi.c.orig     2005-12-22 23:23:55.000000000 +0000
> +++ drivers/scsi/libata-scsi.c  2005-12-22 23:56:14.000000000 +0000
> @@ -1532,16 +1532,13 @@
>         return 0;
>  }
> 
> -static const char *inq_83_str = "Linux ATA-SCSI simulator";
> -
>  /**
>   *     ata_scsiop_inq_83 - Simulate INQUIRY EVPD page 83, device identity
>   *     @args: device IDENTIFY data / SCSI command of interest.
>   *     @rbuf: Response buffer, to which simulated SCSI cmd output is sent.
>   *     @buflen: Response buffer length.
>   *
> - *     Returns device identification.  Currently hardcoded to
> - *     return "Linux ATA-SCSI simulator".
> + *     Returns ATA device serial number (as for page 80).
>   *
>   *     LOCKING:
>   *     spin_lock_irqsave(host_set lock)
> @@ -1551,13 +1548,14 @@
>                               unsigned int buflen)
>  {
>         rbuf[1] = 0x83;                 /* this page code */
> -       rbuf[3] = 4 + strlen(inq_83_str);       /* page len */
> +       rbuf[3] = 4 + ATA_SERNO_LEN;    /* page len */
> 
>         /* our one and only identification descriptor (vendor-specific) */
> -       if (buflen > (strlen(inq_83_str) + 4 + 4 - 1)) {
> +       if (buflen > (ATA_SERNO_LEN + 4 + 4 - 1)) {
>                 rbuf[4 + 0] = 2;        /* code set: ASCII */
> -               rbuf[4 + 3] = strlen(inq_83_str);
> -               memcpy(rbuf + 4 + 4, inq_83_str, strlen(inq_83_str));
> +               rbuf[4 + 3] = ATA_SERNO_LEN;
> +               ata_dev_id_string(args->id, (unsigned char *) rbuf + 4 + 4,
> +                                 ATA_ID_SERNO_OFS, ATA_SERNO_LEN);

-- Patrick Mansfield
