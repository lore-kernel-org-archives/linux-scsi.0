From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v6] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Thu, 16 Jun 2016 15:20:52 -0700
Message-ID: <1466115652.19647.94.camel@perches.com>
References: <1464274721-36453-1-git-send-email-bryantly@linux.vnet.ibm.com>
	 <1466112055-89343-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1466112055-89343-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, nab@linux-iscsi.org, hch@infradead.org
Cc: mikecyr@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2016-06-16 at 16:20 -0500, Bryant G. Ly wrote:
> This driver is a pick up of the old IBM VIO scsi Target Driver
> that was started by Nick and Fujita 2-4 years ago.
> http://comments.gmane.org/gmane.linux.scsi/90119

(style trivia only, nothing important enough to force a respin
=A0but nice to fix one day)

Please use git format-patch -M so file renames are more obvious.

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> +IBM Power Virtual SCSI Device Target Driver
> +M:	Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> +M:	Michael Cyr <mikecyr@linux.vnet.ibm.com>
> +L:	linux-scsi@vger.kernel.org
> +L:	target-devel@vger.kernel.org
> +S:	Supportedybe=20
> +F:	drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c

Maybe

=46:	drivers/scsi/ibmscsi_tgt/

> +F:	drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h
> +F:	drivers/scsi/ibmvscsi_tgt/libsrp.c
> +F:	drivers/scsi/ibmvscsi_tgt/libsrp.h

and these become unnecessary

> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/=
ibmvscsi_tgt/ibmvscsi_tgt.c
[]
> +/**
> + * ibmvscsis_establish_new_q() - Establish new CRQ queue
> + */

If you use kernel-doc comment style,
please describe the function arguments too.

> +static long ibmvscsis_establish_new_q(struct scsi_info *vscsi,=A0=A0=
uint new_state)
> +{
> +	long rc =3D ADAPT_SUCCESS;
> +	uint format;
> +
> +	vscsi->flags &=3D PRESERVE_FLAG_FIELDS;
> +	vscsi->rsp_q_timer.timer_pops =3D 0;
> +	vscsi->debit =3D 0;
> +	vscsi->credit =3D 0;
> +	rc =3D vio_enable_interrupts(vscsi->dma_dev);
> +	if (rc) {
> +		pr_warn("reset_queue: failed to enable interrupts, rc %ld\n",
> +			rc);
> +	} else {
> +		rc =3D ibmvscsis_check_init_msg(vscsi, &format);
> +		if (rc) {
> +			dev_err(&vscsi->dev, "reset_queue: check_init_msg failed, rc %ld\=
n",
> +				rc);
> +		} else if (format =3D=3D UNUSED_FORMAT &&
> +			=A0=A0=A0new_state =3D=3D WAIT_CONNECTION) {
> +			rc =3D ibmvscsis_send_init_message(vscsi, INIT_MSG);
> +			switch (rc) {
> +			case H_SUCCESS:
> +			case H_DROPPED:
> +			case H_CLOSED:
> +				rc =3D ADAPT_SUCCESS;
> +				break;
> +
> +			case H_PARAMETER:
> +			case H_HARDWARE:
> +				break;
> +
> +			default:
> +				vscsi->state =3D UNDEFINED;
> +				rc =3D H_HARDWARE;
> +				break;
> +			}
> +		}
> +	}
> +
> +	return rc;
> +}

This sort of code can have indent reduced by doing

	rc =3D vio_enable_interrupts(...)
	if (rc) {
		pr_warn(...);
		return rc;
	}

	rc =3D ibmvscsis_check_init_msg(...)
	if (rc) {
		dev_err(...);
		return rc;
	}

	if (format =3D=3D UNUSED_FORMAT &&=A0new_state =3D=3D WAIT_CONNECTION)=
 {
		rc =3D ibmvscsis_send_init_message(vscsi, INIT_MSG);=09
		switch (rc) {
			etc...
		}
	}

Why use pr_warn and dev_err in the same function?
Shouldn't dev_<level> be used whenever a struct device is available?

Also it's nice to use %s, __func__ instead of directly
embedding a function like name into the format string.

A lot of the pr_debug uses seem to be function tracing
and could be eliminated altogether.

> +		/* can transition from this state to UNCONFIGURING */
> +	case UNDEFINED:

Comment style for switch / case labels could not be indented
but start at the same indent level as the case statement.
