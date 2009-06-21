From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [SCSI RESEND] scsi_transport_iscsi.c return -EOVERFLOW for Too
 many iscsi targets
Date: Sun, 21 Jun 2009 11:35:22 -0500
Message-ID: <4A3E614A.2020300@cs.wisc.edu>
References: <1243401279.3118.2.camel@localhost.localdomain> <1245484761.3102.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37624 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbZFUQgz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Jun 2009 12:36:55 -0400
In-Reply-To: <1245484761.3102.11.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>

On 06/20/2009 02:59 AM, Jaswinder Singh Rajput wrote:
> setting err as -EOVERFLOW for Too many iscsi targets.
>
> Also fixes compiler warning for gcc 4.3.3 and gcc 4.4 :
>
>    CC      drivers/scsi/scsi_transport_iscsi.o
> drivers/scsi/scsi_transport_iscsi.c: In function =E2=80=98iscsi_add_s=
ession=E2=80=99:
> drivers/scsi/scsi_transport_iscsi.c:678: warning: =E2=80=98err=E2=80=99=
 may be used uninitialized in this function
>
> Signed-off-by: Jaswinder Singh Rajput<jaswinderrajput@gmail.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_=
transport_iscsi.c
> index 0947954..fdcda7f 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -693,6 +693,7 @@ int iscsi_add_session(struct iscsi_cls_session *s=
ession, unsigned int target_id)
>   						 "Too many iscsi targets. Max "
>   						 "number of targets is %d.\n",
>   						 ISCSI_MAX_TARGET - 1);
> +			err =3D -EOVERFLOW;
>   			goto release_host;
>   		}
>   	}


Acked-by: Mike Christie <michaelc@cs.wisc.edu>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
