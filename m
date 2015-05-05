From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Question about driver category for submission
Date: Tue, 05 May 2015 10:23:58 -0700
Message-ID: <1430846638.2173.29.camel@HansenPartnership.com>
References: <1430845254.106831601@apps.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39349 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761860AbbEERX7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2015 13:23:59 -0400
In-Reply-To: <1430845254.106831601@apps.rackspace.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux@highpoint-tech.com
Cc: linux-scsi@vger.kernel.org

On Tue, 2015-05-05 at 13:00 -0400, linux@highpoint-tech.com wrote:
> Hello,
> We would like to submit our driver for Linux kernel embedded. Our
> product is using Marvell 9480/9495 SAS/SATA controller with Marvell
> Port Multiplier(PM) controller to provide PM feature for SATA HDDs.
> From driver source package, we found the Marvell has provided =E2=80=9C=
mvsas=E2=80=9D
> source package that covers this chip. But here are questions
>=20
> 1.  The =E2=80=9Cmvsas=E2=80=9D is based on SCSI modules so it links =
to scsi library
> where it doesn=E2=80=99t support PM feature

It links to libsas, which has SATA support provided via libata but has
the PM code stubbed out.  The reason for that is that it was always
thought the benefit of cheap SAS chips was to drive SAS expanders loade=
d
with SATA devices, since PMs are very functionally lacking compared to
SAS expanders, so no-one was motivated to do the work.

> 2.  We use the same controller chip, so we can=E2=80=99t have the cod=
e in
> other category.=20
> 3. To use PM feature, we need to link to SATA library
>
> Our current code is proprietary which uses scsi module and add PM and
> staggered drive spin up features. Hence, this question is to ask Linu=
x
> community to tell us how should we proceed this if we want to open ou=
r
> code and get driver embedded? Do we need to add our code based on
> mvsas source? How do we include SATA library in scsi module? or other
> alternatives?

Well, you're already including it via libsas; just do the extra libsas
work to plug in port multipliers and the existing mvsas driver should
work for you.

Staggered spin-ups are more problematic: it needs to be done in the sd
module but there's never been a clear idea of how to do the grouping
(that's why most enterprise devices do staggered spin ups on their own)=
=2E

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
