From: Paul Wagland <paul@wagland.net>
Subject: Re: megaraid unified driver version 2.20.0.0-alpha1
Date: Wed, 25 Feb 2004 15:28:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077719297.2560.157.camel@paulw-desktop.allshare.nl>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC3E2@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out5.xs4all.nl ([194.109.24.6]:18437 "EHLO
	smtp-out5.xs4all.nl") by vger.kernel.org with ESMTP id S261333AbUBYO2Z
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2004 09:28:25 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC3E2@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: 'Arjan van de Ven' <arjanv@redhat.com>, 'Christoph Hellwig' <hch@infradead.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'matt_domsch@dell.com'" <matt_domsch@dell.com>, Matthew Wilcox <willy@debian.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Hi,

One of my goals with the forward porting of the 2.10.1 changes to the
driver in lk2.6 was also to add a wider level of sysfs support. Is there
any plan to add this to the unified driver?

I am sure that other, more experienced, people will bring up other
points, but here are a few comments of mine;

1. I had a quick look through the code to check on "extended" sysfs
support, i.e. whether or not board specific abilities/information could
be accessed through the sysfs interface. At the moment, they are only
accessible through the /proc interface. Would it be possible to do
something like what I did in
http://marc.theaimsgroup.com/?l=linux-scsi&m=107724328420636&w=2 I.e.
split the information gathering into a separate module, and then use
that for both the /proc system, and the /sys system.

2. The Scsi_Host_Template should have a ".module = THIS_MODULE,"
initialiser, otherwise the device can be removed whilst it is still
accurate. Please see
http://marc.theaimsgroup.com/?l=linux-scsi&m=107692559912129&w=2

3. Longer term perhaps, but, if sysfs support is included, is it
possible/reasonable to include write support for some/all of the
attributes? For example, to be able to set the rebuild-rate without
using the LSI supplied binary.

Cheers,
Paul

