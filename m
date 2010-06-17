From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 5/12] scsi: megaraid_sas - Online Controller Reset
 (OCR): Add and initialize the OCR relaed variable
Date: Thu, 17 Jun 2010 11:19:30 -0500
Message-ID: <1276791570.7398.12.camel@mulgrave.site>
References: <4B6A08C587958942AA3002690DD4F8C3D0804554@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:40665 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933008Ab0FQQTi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 12:19:38 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3D0804554@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>

On Wed, 2010-06-09 at 21:54 -0600, Yang, Bo wrote:
> To support online controller reset, driver need to define some
> instance based variable and initialize them.

This doesn't compile:

  CC [M]  drivers/scsi/megaraid/megaraid_sas.o
drivers/scsi/megaraid/megaraid_sas.c: In function
=E2=80=98megasas_deplete_reply_queue=E2=80=99:
drivers/scsi/megaraid/megaraid_sas.c:2090: warning: unused variable
=E2=80=98fw_state=E2=80=99
drivers/scsi/megaraid/megaraid_sas.c: In function =E2=80=98megasas_init=
_mfi=E2=80=99:
drivers/scsi/megaraid/megaraid_sas.c:3023: error: =E2=80=98struct
megasas_ctrl_prop=E2=80=99 has no member named =E2=80=98OnOffProperties=
=E2=80=99
drivers/scsi/megaraid/megaraid_sas.c: In function =E2=80=98megasas_prob=
e_one=E2=80=99:
drivers/scsi/megaraid/megaraid_sas.c:3486: error:
=E2=80=98process_fw_state_change_wq=E2=80=99 undeclared (first use in t=
his function)
drivers/scsi/megaraid/megaraid_sas.c:3486: error: (Each undeclared
identifier is reported only once
drivers/scsi/megaraid/megaraid_sas.c:3486: error: for each function it
appears in.)

Because OnOffProperties structure is defined in patch 6/12 as is the
process_fw_state_change_wq function.

I've got 1-4 ... please resubmit 5-12 so they actually build in the
order submitted.

Thanks,

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
