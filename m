From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [BK PATCH] SCSI update for 2.6.3
Date: Tue, 24 Feb 2004 23:48:32 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0402242028370.3713@kai.makisara.local>
References: <Pine.LNX.4.58.0402240919490.1129@spektro.metla.fi>
 <20040224170412.GA31268@kroah.com> <1077642529.1804.170.camel@mulgrave>
 <20040224171629.GA31369@kroah.com> <20040224101512.A19617@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-0.kolumbus.fi ([193.229.0.41]:31956 "EHLO
	fep01-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S262487AbUBXVsf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 16:48:35 -0500
In-Reply-To: <20040224101512.A19617@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, 24 Feb 2004, Patrick Mansfield wrote:

...
> Current 2.6 kernel default names are of the form: st[0-9]m[0-3][n]
> 
Actually more like  st[0-9]*m[0-9]*[n]

> Current /dev naming is of the form: [n]st[0-9][alm]
> 
Depends on who's /dev you are looking at.

> Should the st kernel names be changed to map to current /dev names?
> 
I don't think we should go back to the old names. The intention with the 
"new" names was to make them easier to parse and handle than the old ones. 
The number of modes is not always four. Anyone can compile st with more or 
less modes. Using a number for the mode is naturally extensible. The 
characters at the end of the old names had interpretations that may not be 
correct in all cases (a=alternate, l=low density, m=medium density).

n has been put at the end of the name because now the tape names are 
grouped together in a listing. I know this is a weak justification ;-)

> For udev, even with that we need differing pre and postfix values wrapped
> around a peristent name.
> 
If I read udev correctly, it can now parse one number at the end of the 
name. Something like st%md%n and nst%md%n could be used with eight rules 
(where %m is the mode number and %n is the device number). Not very 
convenient. Parsing the st names should really be able to extract at 
least two fields. With an external program, anything can be done. Maybe 
udev can some day do this internally.

-- 
Kai
