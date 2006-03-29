From: Ingo Flaschberger <if@xip.at>
Subject: Re: Compaq Fiber Channel Array RM4000 / 2.6.16 kernel patch
Date: Wed, 29 Mar 2006 20:35:23 +0200 (CEST)
Message-ID: <Pine.GSO.4.64.0603292025500.4009@filebunker.xip.at>
References: <20060228004043.GH27759@parisc-linux.org>
 <Pine.GSO.4.64.0603221911370.14214@filebunker.xip.at>  <yq1lkv2iap8.fsf@wilson.lab.mkp.net>
  <Pine.GSO.4.64.0603222054520.14214@filebunker.xip.at>
 <20060322200229.GT8980@parisc-linux.org>  <Pine.GSO.4.64.0603222105560.14214@filebunker.xip.at>
  <Pine.GSO.4.64.0603282134370.8439@filebunker.xip.at>  <yq18xqtain6.fsf@wilson.lab.mkp.net>
  <Pine.GSO.4.64.0603291305590.4009@filebunker.xip.at>
 <Pine.GSO.4.64.0603291428590.4009@filebunker.xip.at>  <20060329150729.GA14690@infradead.org>
  <Pine.GSO.4.64.0603291845550.4009@filebunker.xip.at>
 <1143653396.3248.34.camel@mulgrave.il.steeleye.com>
 <Pine.GSO.4.64.0603291949370.4009@filebunker.xip.at>
 <1143656547.3248.36.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.xip.at ([193.239.188.99]:61604 "EHLO chile.gbit.at")
	by vger.kernel.org with ESMTP id S1750982AbWC2SfY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 13:35:24 -0500
In-Reply-To: <1143656547.3248.36.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello James,

> On Wed, 2006-03-29 at 19:53 +0200, Ingo Flaschberger wrote:
>>> Really no to this we're trying to get away from changing actual reported
>>> device information.  I assume the device reports SCSI-3
>>
>> The device reports "zero" and thats why I need to force SCSI2!
>> Its better to force SCSI2 in one position than to deal with "SCSI_UNKNOWN"
>> in severall position?
>
> Why?  We're actually trying to make SCSI_UNKNOWN work for some sbp2 and
> USB storage as well.  What specific problems does it cause?

Ok...

Then I need to force something in this:

scsi_report_lun_scan:
         if ((bflags & BLIST_NOREPORTLUN) ||
              starget->scsi_level < SCSI_2 ||
             (starget->scsi_level < SCSI_3 &&
              (!(bflags & BLIST_REPORTLUN2) || shost->max_lun <= 8)) )
                 return 1;

Version 1:
 	if ((bflags & BLIST_NOREPORTLUN) ||
             (starget->scsi_level < SCSI_3 &&
              (!(bflags & BLIST_REPORTLUN2) || shost->max_lun <= 8)) )
                 return 1;

Version 2:
 	if ((bflags & BLIST_NOREPORTLUN) ||
              (starget->scsi_level < SCSI_2  && !(bflags &
 		BLIST_REPORTLUN3))||
             (starget->scsi_level < SCSI_3 &&
              (!(bflags & BLIST_REPORTLUN2) || shost->max_lun <= 8)) )
                 return 1;

Which one?

Kind regards,
 	Ingo
