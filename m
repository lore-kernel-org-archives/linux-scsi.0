From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] : Spinning up disk is observed on standby paths
	until timeout, resulting in longer path restoration time.
Date: Fri, 20 Feb 2009 15:36:22 +0000
Message-ID: <1235144182.3349.5.camel@localhost.localdomain>
References: <DB8E544DD4B3D346A36F2698103530AE292A9BDC54@GVW1105EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47292 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141AbZBTPg1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2009 10:36:27 -0500
In-Reply-To: <DB8E544DD4B3D346A36F2698103530AE292A9BDC54@GVW1105EXC.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rengarajan, Narayanan (STSD)" <narayanan.rengarajan@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2009-02-20 at 11:14 +0000, Rengarajan, Narayanan (STSD) wrote:
> Hi,
> 
>   Spinning up disk is observed on standby paths until timeout, resulting in longer path restoration time in 2.6.27 kernel.
> 
>  Steps to reproduce:
>  1. present a standby lun to the host
>  2. do a discovery from the host (scan the scsi bus)
>  3. Spinning of disks is  observed in  /var/log/messages
> 
> Whenever a device goes offline and comes back, the new sd device takes longer
> time to get created. This is because of the spinning up of disk in
> sd_spinup_disk fuction as the standby paths would return device not ready with
> 0x04/0x0b asc/ascq.
> 
> Recommended patch :
> 
>   diff -pNaur /usr/src/linux/drivers/scsi/sd.c sd.c
> --- /usr/src/linux/drivers/scsi/sd.c    2009-02-09 22:24:56.000000000 +0530
> +++ sd.c        2009-02-19 16:39:16.000000000 +0530
> @@ -1181,8 +1181,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
>                  */
>                 if (sense_valid &&
>                     sshdr.sense_key == NOT_READY &&
> -                   sshdr.asc == 4 && sshdr.ascq == 3) {
> -                       break;          /* manual intervention required */
> +                   sshdr.asc == 4 && (sshdr.ascq == 3 || sshdr.ascq == 0x0b ||
> sshdr.ascq == 0x0c) ) {
> +                       break;  /* manual intervention required || Standby ||

This really doesn't look right ASC/ASCQ 0x04/0x0b is LUN not accessible;
target *port* in standby state. That's supposed to be because it was put
into a standby state according to SPC3(r23) 5.8.2.4.4

I don't see how a port (target) is expected to come out of standby with
a LUN command.  The standard implies you need to do it with a set target
port groups command.  What array is actually giving this?

James


