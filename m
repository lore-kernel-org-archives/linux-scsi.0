From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH]: Re: qla1280.c broken on SGI visws, PCI
	coherency	problem
Date: Tue, 13 Dec 2005 08:50:13 -0600
Message-ID: <1134485413.3356.2.camel@mulgrave>
References: <4399D6EB.4080603@c-lab.de> <439A17BE.5000904@sgi.com>
	 <439DE50B.90007@sgi.com> <1134424057.3713.18.camel@mulgrave>
	 <439E0112.1030801@sgi.com>  <439ECB2E.7070103@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:11407 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964980AbVLMOuk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Dec 2005 09:50:40 -0500
In-Reply-To: <439ECB2E.7070103@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: pazke@donpac.ru, Michael Joosten <michael.joosten@c-lab.de>, linux-scsi@vger.kernel.org

On Tue, 2005-12-13 at 07:22 -0600, Michael Reed wrote:
> I believe the biggest issue with VISWS is that it appears to need
> mmiowb() and we likely don't know how to implement it.  Hence, for
> that platform, it would make sense to replace the mmiowb() with a
> posting read.

Well, there's an easy way to tell ... the reason for the mmiowb in the
qla1280 driver is supposed to be an SMP race, according to the
description, so if it fails on UP as well there's something else going
on here ...

I'm still suspicious because the mmiowb() in this driver replaced a
posted write flush instruction, which altered the behaviour of the
driver.  The qla1280 is just rare enough that it might have taken this
long to notice ...

James


