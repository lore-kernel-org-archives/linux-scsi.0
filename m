From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH] SCSI/libsrp: fix bug in ADDITIONAL CDB LENGTH
	interpretation
Date: Wed, 9 Dec 2009 20:17:16 +0100
Message-ID: <e2e108260912091117n59240ae5kea36022313f9ef93@mail.gmail.com>
References: <200912091952.19978.bart.vanassche@gmail.com>
	 <20091209190413.GB7246@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65059 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817AbZLITRK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2009 14:17:10 -0500
Received: by bwz27 with SMTP id 27so5553897bwz.21
        for <linux-scsi@vger.kernel.org>; Wed, 09 Dec 2009 11:17:16 -0800 (PST)
In-Reply-To: <20091209190413.GB7246@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>

On Wed, Dec 9, 2009 at 8:04 PM, Matthew Wilcox <matthew@wil.cx> wrote:
>
> On Wed, Dec 09, 2009 at 07:52:19PM +0100, Bart Van Assche wrote:
> > Fix a bug in the interpretation of the ADDITIONAL CDB LENGTH (add_c=
db_len)
> > field of SRP_CMD requests. According to the SRP specification, the =
layout
> > of this single-byte field is as follows:
> > * Bits 0 and 1 are reserved.
> > * Bits 2 to 7 represent the ADDITIONAL CDB LENGTH field, symbolical=
ly
> > =A0 represented as n.
> > * Still according to the SRP specification, the ADDITIONAL CDB sect=
ion
> > =A0 takes 4*n bytes.
>
> Your interpretation of the SRP spec does seem to be correct, and I ca=
n
> totally see how the original author of this code got it wrong.
>
> > - =A0 =A0 offset =3D cmd->add_cdb_len * 4;
> > + =A0 =A0 offset =3D (cmd->add_cdb_len >> 2) * 4;
>
> Would this not be better written as:
>
> =A0 =A0 =A0 =A0offset =3D cmd->add_cdb_len & ~3;

I chose the former because of better readability for someone familiar
with the specs. But I do not have a strong opinion about this -- more
opinions are welcome.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
