From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 0/2] struct scsi_lun preparation
Date: Wed, 13 Sep 2006 00:27:39 -0400
Message-ID: <450788BB.3040909@torque.net>
References: <664A4EBB07F29743873A87CF62C26D70307646@NAMAIL4.ad.lsil.com> <4505D81F.5020300@garzik.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:25220 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751544AbWIME2c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Sep 2006 00:28:32 -0400
In-Reply-To: <4505D81F.5020300@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: "Moore, Eric" <Eric.Moore@lsil.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Moore, Eric wrote:
>> On Monday, September 11, 2006 1:56 PM, Jeff Garzik wrote:
>>>> A pretty print for the current u32 would be very useful though for
>>>> transports dealing with non single level luns (or address 
>>> methods other
>>>> than zero).
>>> A better subject line would have been "HCIL isolation" I suppose.  I
>>> would like to see increased usage of the accessors already present in
>>> include/scsi/scsi_device.h, which would ease the transition from
>>> hardcoded HCIL struct members to a more flexible addressing method.
>>>
>>> Though, FWIW, for LUNs I would certainly like to see u64 rather than
>>> u32.....
>>>
>>
>> shouldn't luns be defined as:
>> u8 lun[8] instead of u64?  
> 
> Please, not that argument again :)
> 
> It's purely semantics, the same storage is used, and only very rarely
> are the contents actually examined in either case.

James Bottomley asked Alberto Cammozzo yesterday
to see the output of 'sg_luns -v' so it ain't
that rare.

http://www.t10.org/ftp/t10/drafts/sam4/sam4r07.pdf
section 4.6.2 discusses a 64 bit lun's
"representation format". Assuming a 'u8 lun[8]'
representation fetched directly from a REPORT
LUNS response, then the first two bytes (i.e.
lun[0] and lun[1]) are most often of interest.
SCSI-2 (3 bit luns) map to lun[1] (with lun[0]=0),
eight bit luns also map to lun[1], 16 bit luns
map to lun[0] (msb) and lun[1] (lsb).

For more background, Rob Elliott wrote a document
on the subject (06-003r1 at www.t10.org).

Doug Gilbert

