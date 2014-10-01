From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: [PATCH v1 1/1] [SCSI] enclosure: Handle non-unique element
 descriptors
Date: Wed, 1 Oct 2014 17:41:00 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735864E9AA@EXCHANGE.collogia.de>
References: <be2f680f-81da-4f33-9454-4555de3c179d@EXCHANGE.collogia.de>,<1412177498.5299.33.camel@jarvis>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-adceae0f-9fd3-45eb-a804-95bd59f2bdb7"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:40315 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752309AbaJARlO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 13:41:14 -0400
In-Reply-To: <1412177498.5299.33.camel@jarvis>
Content-Language: de-DE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-adceae0f-9fd3-45eb-a804-95bd59f2bdb7
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: linux-scsi-owner@vger.kernel.org [linux-scsi-owner@vger.kernel.org]&=
quot; im Auftrag von &quot;James Bottomley [James.Bottomley@HansenPartnersh=
ip.com]=0A=
> Gesendet: Mittwoch, 1. Oktober 2014 17:31=0A=
> An: Markus Stockhausen=0A=
> Cc: linux-scsi@vger.kernel.org=0A=
> Betreff: Re: [PATCH v1 1/1] [SCSI] enclosure: Handle non-unique element d=
escriptors=0A=
>=0A=
> On Wed, 2014-10-01 at 15:10 +0000, Markus Stockhausen wrote:=0A=
> > [SCSI] enclosure: Handle non-unique element descriptors=0A=
> ...=0A=
> > +=0A=
> > +     if (name && name[0]) {=0A=
> > +             /* Some hardware (e.g. enclosure in RX300 S6) has compone=
nts=0A=
> > +              * with non unique names. Registering duplicates in sysfs=
=0A=
> > +              * will lead to warnings during bootup. So make the names=
=0A=
> > +              * unique by appending consecutive numbers -1, -2, ... */=
=0A=
> > +             i =3D 1;=0A=
> > +             snprintf(newname, COMPONENT_NAME_SIZE,=0A=
> > +                      "%s", name);=0A=
> > +             while (i < 255 &&=0A=
> > +                    enclosure_component_find_by_name (edev, newname))=
=0A=
> > +                     snprintf(newname, COMPONENT_NAME_SIZE,=0A=
> > +                              "%s-%i", name, i++);=0A=
> =0A=
> We need error handling here (what happens when i becomes 255).  Since=0A=
> it's iterating through a unique name space, I think you can just let the=
=0A=
> loop be unbounded because if it's not, the system will run out of memory=
=0A=
> before we get into an apparently endless loop.=0A=
> =0A=
> After fixing this, you can add my acked-by.=0A=
> =0A=
> James=0A=
=0A=
Hi James.=0A=
=0A=
Just to make sure I get it right. My intention was to ensure that we will=
=0A=
not loop endlessly. Thinking about the corner cases I was unsure if we =0A=
might encounter component names with up to 63 chars. If yes appending =0A=
the numbers will not not change the generated names throughout the=0A=
loop. So ensure that we will stop somewhere by giving it an upper bound. =
=0A=
In the error case we will have the same behaviour as now. Creating an =0A=
already existing filename.=0A=
=0A=
You are more experienced with that. So if i drop the "i<255" it will be =0A=
fine and can be implemented?=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-adceae0f-9fd3-45eb-a804-95bd59f2bdb7
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-adceae0f-9fd3-45eb-a804-95bd59f2bdb7--
