From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V3] scsi_lib: remove the description string in scsi_io_completion()
Date: Thu, 10 Jul 2014 09:48:40 +0200
Message-ID: <53BE4558.7090008@suse.de>
References: <1404978113-3693-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbaGJHsn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2014 03:48:43 -0400
In-Reply-To: <1404978113-3693-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, Elliott@hp.com

On 07/10/2014 09:41 AM, Maurizio Lombardi wrote:
> During IO with fabric faults, one generally sees several "Unhandled e=
rror
> code" messages in the syslog as shown below:
>
> sd 4:0:6:2: [sdbw] Unhandled error code
> sd 4:0:6:2: [sdbw] Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRI=
VER_OK
> sd 4:0:6:2: [sdbw] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
> end_request: I/O error, dev sdbw, sector 0
>
> This comes from scsi_io_completion (in scsi_lib.c) while handling err=
or
> codes other than DID_RESET or not deferred sense keys i.e. this is
> actually handled by the SCSI mid layer. But what gets displayed here =
is
> "Unhandled error code" which is quite misleading as it indicates
> something that is not addressed by the mid layer.
>
> The description string is based on the sense key and sometimes on the
> additional sense code;
> since the ACTION_FAIL case always prints the sense key and the
> additional sense code, this patch removes the description string
> completely because it does not add useful information.
>
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Very good. I've been wanting to do this for a long time, too.

Reviewed-by: Hannes Reinecke <hare@suse.de>

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
