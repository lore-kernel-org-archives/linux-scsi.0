From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 3/3] MidLayer updates - extending scsi_target support
Date: Fri, 04 Feb 2005 17:00:56 -0600
Message-ID: <1107558056.5557.86.camel@mulgrave>
References: <0B1E13B586976742A7599D71A6AC733C12EAB3@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:44503 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264164AbVBDXBL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2005 18:01:11 -0500
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12EAB3@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2005-01-29 at 09:03 -0500, James.Smart@Emulex.Com wrote:
>   This patch extends scsi_target support:
>   - Allows for driver-specific data to be allocated along with the
>     target structure and accessible via the starget->hostdata pointer.
>   - Adds scsi target alloc/configure/destory callbacks to the
>     scsi host template.
>   - Rearranges the calling sequences for scsi targets so that the
>     target and slave alloc/configure/destory callbacks are in
>     order (target before slave on alloc/configure).


the idea behind this is fine, I just don't like the interface.

Really a target device is nothing more than a container to SCSI.  We
already do the transport add/remove calls for targets, I don't see we
need other calls duplicating this.  So, I think the implementation would
look a whole lot better if the fc transport class just exported an
interface to get the extra storage for the driver and tacked it on to
its allocation.  Then you can use the existing mid-layer transport
target triggers to do everything you want.

James


