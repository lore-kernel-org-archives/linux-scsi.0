From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Check for deleted device in scsi_device_online()
Date: Thu, 08 Jan 2009 10:27:36 -0600
Message-ID: <1231432056.3237.25.camel@localhost.localdomain>
References: <20081216153352.27D4318C75E@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48721 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754184AbZAHQ1l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2009 11:27:41 -0500
In-Reply-To: <20081216153352.27D4318C75E@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On Tue, 2008-12-16 at 16:33 +0100, Hannes Reinecke wrote:
> scsi_device_online() is not just a negation of SDEV_OFFLINE,
> also devices in state SDEV_CANCEL and SDEV_DEL are
> actually offline.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  include/scsi/scsi_device.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index e96daf6..63b58d2 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -401,7 +401,9 @@ static inline unsigned int sdev_id(struct scsi_device *sdev)
>   */
>  static inline int scsi_device_online(struct scsi_device *sdev)
>  {
> -	return sdev->sdev_state != SDEV_OFFLINE;
> +	return (sdev->sdev_state != SDEV_OFFLINE &&
> +		sdev->sdev_state != SDEV_CANCEL &&
> +		sdev->sdev_state != SDEV_DEL);

SDEV_DEL is OK.  We can't do this for SDEV_CANCEL because that will
block post removal commands (notably cache flush).

James


