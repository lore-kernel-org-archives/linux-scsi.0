From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: what is return code 70000
Date: Wed, 16 Jan 2008 12:27:43 -0600
Message-ID: <1200508063.3136.17.camel@localhost.localdomain>
References: <200801161913.24753.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60542 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672AbYAPS1t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jan 2008 13:27:49 -0500
In-Reply-To: <200801161913.24753.bs@q-leap.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-scsi@vger.kernel.org


On Wed, 2008-01-16 at 19:13 +0100, Bernd Schubert wrote:
> Hi,
> 
> I already grepped, but I don't find the definition of 
> 
> return code = 0x00070000
> 
> 
> Just got with FC and 2.4.18 of scientitfic linux:
> 
> sd 1:0:0:0: SCSI error: return code = 0x00070000
> end_request: I/O error, dev sdb, sector 294388752
> device-mapper: multipath: Failing path 8:16.
> sd 1:0:1:0: SCSI error: return code = 0x00070000
> end_request: I/O error, dev sdc, sector 1713114128
> device-mapper: multipath: Failing path 8:32.
> sd 2:0:1:0: SCSI error: return code = 0x00070000
> end_request: I/O error, dev sde, sector 2094272016
> device-mapper: multipath: Failing path 8:64.
> 
> 
> Since I have some error handling patches in queue for 2.6.22, I would like to 
> know if I would have catched this error, but 0x00070000 is pretty meaningless 
> for me :(

SCSI returns are 32 bit numbers with definitions in include/scsi/scsi.h
going (from lowest to highest)

     1. status byte: the status return code from the command if
        successfully executed
     2. message byte: now misnamed, message is SPI specific, what it
        means is task status interlaced with possible SPI message
        responses.
     3. host byte: these are the DID_ codes, specific error codes
        returned by drivers.
     4. driver byte: Additional qualification of the error in host byte

In your case, it's showing DID_ERROR.

James


