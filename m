From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SUN Universal Xport no attach blacklist
Date: Tue, 13 Jan 2009 10:47:11 -0600
Message-ID: <1231865231.4519.15.camel@localhost.localdomain>
References: <1231771552.7596.11.camel@octane>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57192 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753660AbZAMQrP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2009 11:47:15 -0500
In-Reply-To: <1231771552.7596.11.camel@octane>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ILLES, Marton" <illes.marton@balabit.hu>
Cc: linux-scsi@vger.kernel.org

On Mon, 2009-01-12 at 15:45 +0100, ILLES, Marton wrote:
> Hi,
> 
> I was using a Sun ST2510 device (iSCSI) and a special "block device"
> appeared which is used by SUN Common Array Manager in-band management.
> 
> However it also appeared as a block device and caused some IO error:
> 
> [  716.868000] scsi 15:0:0:31: Direct-Access     SUN      Universal Xport  0735 PQ: 0 ANSI: 5
> [  716.868000] qla4xxx 0000:04:01.1: scsi(15:0:0:31): Enabled tagged queuing, queue depth 32.
> [  716.868000] sd 15:0:0:31: [sdf] 40960 512-byte hardware sectors (21 MB)
> [  716.868000] sd 15:0:0:31: [sdf] Write Protect is off
> [  716.868000] sd 15:0:0:31: [sdf] Mode Sense: 77 00 10 08
> [  716.868000] sd 15:0:0:31: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
> [  716.868000] sd 15:0:0:31: [sdf] 40960 512-byte hardware sectors (21 MB)
> [  716.868000] sd 15:0:0:31: [sdf] Write Protect is off
> [  716.868000] sd 15:0:0:31: [sdf] Mode Sense: 77 00 10 08
> [  716.872000] sd 15:0:0:31: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
> [  716.872000]  sdf: unknown partition table
> [  716.932000] sd 15:0:0:31: [sdf] Attached SCSI disk
> [  716.932000] sd 15:0:0:31: Attached scsi generic sg6 type 0
> [  717.412000] end_request: I/O error, dev sdf, sector 40
> [  717.412000] Buffer I/O error on device sdf, logical block 5
> [  717.412000] Buffer I/O error on device sdf, logical block 6
> [  717.412000] Buffer I/O error on device sdf, logical block 7
> [  717.412000] Buffer I/O error on device sdf, logical block 8
> [  717.412000] Buffer I/O error on device sdf, logical block 9
> [  717.412000] Buffer I/O error on device sdf, logical block 10
> [  717.412000] Buffer I/O error on device sdf, logical block 11
> [  717.412000] Buffer I/O error on device sdf, logical block 12
> [  717.412000] Buffer I/O error on device sdf, logical block 13
> [  717.412000] Buffer I/O error on device sdf, logical block 14
> 
> After some googling it appeared that similar issue has been solved for
> SGI/IBM devices in 4869040512082b761de2d7c35975d01044f8bfea, so here is
> the patch for SUN, please apply.
> 
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> index 18dd5cc..fb95b86 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -219,6 +219,7 @@ static struct {
>         {"SGI", "TP9100", "*", BLIST_REPORTLUN2},
>         {"SGI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
>         {"IBM", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
> +       {"SUN", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},

OK, I have applied this with difficulty: your email tool has converted
all the tabs in the patch to spaces.

James


