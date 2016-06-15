From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v5] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Wed, 15 Jun 2016 16:50:05 -0700
Message-ID: <1466034605.19647.28.camel@perches.com>
References: <20160614145728.GB18075@infradead.org>
	 <1466034106-31810-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay0140.hostedemail.com ([216.40.44.140]:49106 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753256AbcFOXuK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2016 19:50:10 -0400
In-Reply-To: <1466034106-31810-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, nab@linux-iscsi.org, hch@infradead.org
Cc: mikecyr@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com

On Wed, 2016-06-15 at 18:41 -0500, Bryant G. Ly wrote:
> The driver provides a virtual SCSI device on IBM Power Servers.
[]
> =A0MAINTAINERS=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0|=A0=A0=A011 +
> =A0drivers/scsi/Kconfig=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0|=A0=A0=A027 +-
> =A0drivers/scsi/Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0|=A0=A0=A0=A02 +-
> =A0drivers/scsi/ibmvscsi/Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0|=A0=
=A0=A0=A04 +
> =A0drivers/scsi/ibmvscsi/ibmvfc.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0|=A0=
=A0=A0=A02 +-
> =A0drivers/scsi/ibmvscsi/ibmvscsi.h=A0=A0=A0=A0=A0=A0=A0=A0=A0|=A0=A0=
=A0=A02 +-
> =A0drivers/scsi/ibmvscsi/viosrp.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0|=A0=
=A0225 --
> =A0drivers/scsi/ibmvscsi_tgt/Makefile=A0=A0=A0=A0=A0=A0=A0|=A0=A0=A0=A0=
4 +
> =A0drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 4029 ++++++++++++++++++=
++++++++++++
> =A0drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h |=A0=A0342 +++
> =A0drivers/scsi/ibmvscsi_tgt/libsrp.c=A0=A0=A0=A0=A0=A0=A0|=A0=A0427 =
++++
> =A0drivers/scsi/ibmvscsi_tgt/libsrp.h=A0=A0=A0=A0=A0=A0=A0|=A0=A0123 =
+
> =A0drivers/scsi/libsrp.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0|=A0=A0447 ----
> =A0include/scsi/libsrp.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0|=A0=A0=A078 -
> =A0include/scsi/viosrp.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0|=A0=A0220 ++
> =A015 files changed, 5180 insertions(+), 763 deletions(-)
> =A0delete mode 100644 drivers/scsi/ibmvscsi/viosrp.h
> =A0create mode 100644 drivers/scsi/ibmvscsi_tgt/Makefile
> =A0create mode 100644 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> =A0create mode 100644 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h
> =A0create mode 100644 drivers/scsi/ibmvscsi_tgt/libsrp.c
> =A0create mode 100644 drivers/scsi/ibmvscsi_tgt/libsrp.h
> =A0delete mode 100644 drivers/scsi/libsrp.c
> =A0delete mode 100644 include/scsi/libsrp.h
> =A0create mode 100644 include/scsi/viosrp.h
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -5451,6 +5451,17 @@ S:	Supported
> =A0F:	drivers/scsi/ibmvscsi/ibmvscsi*
> =A0F:	drivers/scsi/ibmvscsi/viosrp.h
> =A0
> +IBM Power Virtual SCSI Device Target Driver
> +M:	Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> +M:	Michael Cyr <mikecyr@linux.vnet.ibm.com>
> +L:	linux-scsi@vger.kernel.org
> +L:	target-devel@vger.kernel.org
> +S:	Supported
> +F:	drivers/scsi/ibmvscsi/ibmvscsis.c
> +F:	drivers/scsi/ibmvscsi/ibmvscsis.h
> +F:	drivers/scsi/ibmvscsi/libsrp.c
> +F:	drivers/scsi/ibmvscsi/libsrp.h

trivia:

Please make the MAINTAINER pattern entries match the file locations.

This could be done in a separate patch if this doesn't need to be
resubmitted for any other reason.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
