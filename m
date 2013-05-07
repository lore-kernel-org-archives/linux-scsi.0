From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 32-byte CDB support in Libsas?
Date: Tue, 07 May 2013 13:06:47 -0700
Message-ID: <1367957207.4108.7.camel@dabdike>
References: <405BE55790F03349A85344435F25B01C0784369E@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
	<1367867773.1868.39.camel@dabdike>
	 <CAD+HZHUynKmSgebmoLfPNgfbj8OVGaTUuFhJoJhNJxfvsNUFvg@mail.gmail.com>
	 <405BE55790F03349A85344435F25B01C07843842@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47567 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923Ab3EGUGu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 May 2013 16:06:50 -0400
In-Reply-To: <405BE55790F03349A85344435F25B01C07843842@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kamaljit Singh <Kamaljit.Singh@pmcs.com>
Cc: Jack Wang <xjtuwjp@gmail.com>, Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>, linux-scsi@vger.kernel.org, Harry Yang <Harry.Yang@pmcs.com>, Vishwanath Maram <Vishwanath.Maram@pmcs.com>, Sakthivel Saravanan Kamal Raju <sakthivel.sk@hcl.com>, Rich Bono <Rich.Bono@pmcs.com>, Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>

On Tue, 2013-05-07 at 12:46 -0700, Kamaljit Singh wrote:
> James,  Jack,
>=20
> Thanks for your responses.
>=20
> > I don't understand the question ... it should just work; is it
> broken?
> sas_create_task() only copies 16 bytes to the sas_ssp_task struct=E2=80=
=99s
> cdb field, which itself is a 16 byte wide array.  So it looks like
> sas_queuecommand() doesn=E2=80=99t support a 32-byte cdb.

Hm, it does it as a bare 16 instead of SCSI_MAX_CDB which is probably
how it got missed in the long command conversion.

> > It's easy to add that, define cdb 32 to ssp_task and modify
> sas_queuecommand, and lldd to pass it to fw
> Yes, that=E2=80=99s exactly what I=E2=80=99ve designed it as, i.e. in=
 my lldd=E2=80=99s
> queuecommand function.  At the moment I only need this function for
> 32-byte cdb support.  But if there are plans to add that to libsas
> then I=E2=80=99d prefer to use sas_queuecommand rather than having to=
 do
> manual merges from future libsas fixes/updates.

I wouldn't do it that way.  Since everything has to form a command IU
anyway by copying, I'd just make sas_ssp->cdb a pointer to the actual
command instead of an array of the command; if it points to the
scsi_cmnd, then it has access to cmd_len as well.  That way no copying
and no problem when anyone wants longer commands.  There should probabl=
y
also be a macro to populate the command IU since the format of CDB > 16
is different.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
