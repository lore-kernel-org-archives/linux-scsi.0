From: Bernd Schubert <bs@q-leap.de>
Subject: Re: what is return code 70000
Date: Wed, 16 Jan 2008 20:05:56 +0100
Message-ID: <200801162005.57272.bs@q-leap.de>
References: <200801161913.24753.bs@q-leap.de> <1200508063.3136.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:36718 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbYAPTF6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jan 2008 14:05:58 -0500
In-Reply-To: <1200508063.3136.17.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

On Wednesday 16 January 2008 19:27:43 James Bottomley wrote:
> On Wed, 2008-01-16 at 19:13 +0100, Bernd Schubert wrote:
> > Hi,
> >
> > I already grepped, but I don't find the definition of
> >
> > return code = 0x00070000
> >
> >
> > Just got with FC and 2.4.18 of scientitfic linux:
> >
> > sd 1:0:0:0: SCSI error: return code = 0x00070000
> > end_request: I/O error, dev sdb, sector 294388752
> > device-mapper: multipath: Failing path 8:16.
> > sd 1:0:1:0: SCSI error: return code = 0x00070000
> > end_request: I/O error, dev sdc, sector 1713114128
> > device-mapper: multipath: Failing path 8:32.
> > sd 2:0:1:0: SCSI error: return code = 0x00070000
> > end_request: I/O error, dev sde, sector 2094272016
> > device-mapper: multipath: Failing path 8:64.
> >
> >
> > Since I have some error handling patches in queue for 2.6.22, I would
> > like to know if I would have catched this error, but 0x00070000 is pretty
> > meaningless for me :(
>
> SCSI returns are 32 bit numbers with definitions in include/scsi/scsi.h
> going (from lowest to highest)
>
>      1. status byte: the status return code from the command if
>         successfully executed
>      2. message byte: now misnamed, message is SPI specific, what it
>         means is task status interlaced with possible SPI message
>         responses.
>      3. host byte: these are the DID_ codes, specific error codes
>         returned by drivers.
>      4. driver byte: Additional qualification of the error in host byte

Ah, thanks! Now I understand. 

>
> In your case, it's showing DID_ERROR.

Hmm, which means I wouldn't have cached it :( Well, this is fibre channel, so 
far I only had trouble with native scsi systems.


Thanks again,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH
