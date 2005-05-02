From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: [PATCH] fix disk geometry calculation for large disks
Date: Mon, 2 May 2005 13:18:10 -0400
Message-ID: <006901c54f3a$eaaf1f50$e0019d89@cybernetics.com>
References: <1115052512.11434.2738.camel@bianchi.boston.redhat.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:28169 "EHLO
	cyborg.cybernetics.com") by vger.kernel.org with ESMTP
	id S261355AbVEBRSM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 May 2005 13:18:12 -0400
In-Reply-To: <1115052512.11434.2738.camel@bianchi.boston.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Tom Coughlan' <coughlan@redhat.com>, linux-scsi@vger.kernel.org

> Testing with multi-terabyte disks shows that HDIO_GETGEO sometimes
> returns heads=0. This causes parted to die with a Floating Point
> Exception, among other possible effects.
>
> The problem occurs because several routines in scsicam_bios_param cast
> sector_t capacity to unsigned long.
>
> The attached patch avoids this, by checking first to see if
> the capacity
> exceeds the maximum allowed values for cylinder/sector/head
> (65535*63*255). If so, just return those values right away.

I brought up this issue a few months ago
(http://marc.theaimsgroup.com/?t=110383771000001&r=1&w=2), but no one
replied.  There are actually many other drivers with custom bios_param()
routines that should be reviewed as well.

Anthony J. Battersby
Cybernetics

