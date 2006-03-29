From: Ingo Flaschberger <if@xip.at>
Subject: Re: Compaq Fiber Channel Array RM4000 / 2.6.16 kernel patch
Date: Wed, 29 Mar 2006 19:53:14 +0200 (CEST)
Message-ID: <Pine.GSO.4.64.0603291949370.4009@filebunker.xip.at>
References: <20060228004043.GH27759@parisc-linux.org>
 <Pine.GSO.4.64.0603221911370.14214@filebunker.xip.at>  <yq1lkv2iap8.fsf@wilson.lab.mkp.net>
  <Pine.GSO.4.64.0603222054520.14214@filebunker.xip.at>
 <20060322200229.GT8980@parisc-linux.org>  <Pine.GSO.4.64.0603222105560.14214@filebunker.xip.at>
  <Pine.GSO.4.64.0603282134370.8439@filebunker.xip.at>  <yq18xqtain6.fsf@wilson.lab.mkp.net>
  <Pine.GSO.4.64.0603291305590.4009@filebunker.xip.at>
 <Pine.GSO.4.64.0603291428590.4009@filebunker.xip.at>  <20060329150729.GA14690@infradead.org>
  <Pine.GSO.4.64.0603291845550.4009@filebunker.xip.at>
 <1143653396.3248.34.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.xip.at ([193.239.188.99]:49316 "EHLO chile.gbit.at")
	by vger.kernel.org with ESMTP id S1750913AbWC2RxQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 12:53:16 -0500
In-Reply-To: <1143653396.3248.34.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello James,


> On Wed, 2006-03-29 at 18:47 +0200, Ingo Flaschberger wrote:
>> -       sdev->scsi_level = inq_result[2] & 0x07;
>> +
>> +       if (BLIST_FORCE_SCSI2 & *bflags) {      /* force SCSI2 for
>> RA4x00 */
>> +               sdev->scsi_level = 2;
>> +       } else {
>> +               sdev->scsi_level = inq_result[2] & 0x07;
>> +       }
>
>
> Really no to this we're trying to get away from changing actual reported
> device information.  I assume the device reports SCSI-3

The device reports "zero" and thats why I need to force SCSI2!
Its better to force SCSI2 in one position than to deal with "SCSI_UNKNOWN" 
in severall position?

> and then
> something goes wrong with the REPORT LUNS scan?  In which case
> BLIST_NOREPORTLUNS should work.

no, does not work.

Sorry, thats the only idea I have to ship around the problem.

bye,
 	Ingo
