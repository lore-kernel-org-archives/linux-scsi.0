From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] saved and restore result for timed out commands
Date: Wed, 1 Jun 2005 14:45:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506011440090.5912-100000@iolanthe.rowland.org>
References: <20050516174215.GA23974@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51636 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261196AbVFASpO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jun 2005 14:45:14 -0400
In-Reply-To: <20050516174215.GA23974@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Doug Gilbert <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 16 May 2005, Patrick Mansfield wrote:

> Save and restore the scmd->result, so that timed out commands do not
> return the result of the TEST UNIT READY or the start/stop commands. =
Code
> is already in place to save and restore the result for the request se=
nse
> case.
>=20
> The previous version of this patch erroneously removed the "if" check=
,
> instead add a comment as to why the "if" is needed.

Has there been any more progress on this issue?

I spoke with J=F6rg Schilling (author of the cdrecord package, a widely=
-used
sg client) and he said that failed operations should be retried
automatically if the command had not gotten as far as being sent on the
bus -- e.g., if the host adapter driver's queue was full.  But if the
command did get sent to the device then any subsequent failure should b=
e
reflected back to the client with no retrys.

Alan Stern

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
