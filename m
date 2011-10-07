From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_io_completion: soften unhandled error and sense
 messages
Date: Fri, 07 Oct 2011 09:29:48 +0200
Message-ID: <4E8EAA6C.90102@suse.de>
References: <1317938931-6532-1-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab1JGH3t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Oct 2011 03:29:49 -0400
In-Reply-To: <1317938931-6532-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org

On 10/07/2011 12:08 AM, Rob Evers wrote:
> We are receiving reports that users are seeing error messages during
> fabric faults, but the systems are not malfunctioning.  I previously
> submitted a patch which simply removed the offending messages but
> James Bottomley rejected this as we were losing error information.
>
> This patch softens the messages such that they don't appear to
> be error indications from the user perspective.
>
> new messages suggested by Mike Christie
>
> Signed-off-by: Rob Evers<revers@redhat.com>
> ---
>   drivers/scsi/scsi_lib.c |    5 +++--
>   1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index fc3f168..ef2a8a1 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -920,12 +920,13 @@ void scsi_io_completion(struct scsi_cmnd *cmd, =
unsigned int good_bytes)
>   			action =3D ACTION_FAIL;
>   			break;
>   		default:
> -			description =3D "Unhandled sense code";
> +			description =3D
> +				"Extended sense description not available";
>   			action =3D ACTION_FAIL;
>   			break;
>   		}
>   	} else {
> -		description =3D "Unhandled error code";
> +		description =3D "Extended error description not available";
>   		action =3D ACTION_FAIL;
>   	}
>
Actually, I would prefer having this message routed via the=20
scsi_logging mechanism. Then it wouldn't bother the unsuspecting=20
user and we still would retain the information if scsi_logging is=20
enabled.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
