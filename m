From: Douglas Gilbert <dougg@torque.net>
Subject: Re: tools support for non-512 byte sector sizes
Date: Tue, 29 Jul 2008 15:14:24 -0400
Message-ID: <488F6C10.2060209@torque.net>
References: <660360F4F2570145BD872F298951B17A3AC7E3B3@cosmail03.lsi.com> <yq1y73kpl68.fsf@sermon.lab.mkp.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elrond2.infotech.no ([82.134.31.41]:38521 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbYG2TOg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jul 2008 15:14:36 -0400
In-Reply-To: <yq1y73kpl68.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, "rwheeler@redhat.com" <rwheeler@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Jim Meyering <jim@meyering.net>

Martin K. Petersen wrote:
>>>>>> "Eric" == Moore, Eric <Eric.Moore@lsi.com> writes:
> 
> Eric> I was wondering about formatting drives with DIF support??
> Eric> Martin told me he is using sg_format, however it doesn't support
> Eric> type 3 protection format, which has 6 byte application tag.
> 
> I have only been testing Type 3 with scsi_debug (which conveniently
> avoids the formatting step).
> 
> I doubt we will see any disk drives that support Type 3.  The way the
> standard is written, a drive can either do Type 1+2 or Type 1+3.  Type
> 2+3 is not a possible combination.
> 
> In any case.  If you happen to own a Type 3-capable device you format
> it exactly like if it had been a Type 2.  I.e. set PINFO=1 and
> RTO_REQ=1 in FORMAT UNIT.  sg_format can already do this.

According to sbc3r15.pdf (section 5.2 table 20 page 56)
sg_format is setting the correct bits for type 3 protection.
See the "format cdb" and the "format parameter list" in the
verbose output below).

The appropriate command line invocation is pretty convoluted:


# sg_format --format --pinfo --rto_req --pfu=1 -vvv /dev/sdb
open /dev/sdb with flags=0x802
     inquiry cdb: 12 00 00 00 24 00
       duration=0 ms
     Linux     scsi_debug        0004   peripheral_type: disk [0x0]
       PROTECT=0
     mode sense (10) cdb: 5a 00 01 00 00 00 00 00 fc 00
       duration=1 ms
     mode sense (10): requested 252 bytes but got 28 bytes
     mode sense (10): response
         00 1a 00 10 00 00 00 08  00 00 40 00 00 00 02 00
         01 0a c0 0b f0 00 00 00  05 00 ff ff
Mode Sense (block descriptor) data, prior to changes:
   Number of blocks=16384 [0x4000]
   Block size=512 [0x200]

A FORMAT will commence in 10 seconds
     ALL data on /dev/sdb will be DESTROYED
         Press control-C to abort
A FORMAT will commence in 5 seconds
     ALL data on /dev/sdb will be DESTROYED
         Press control-C to abort
     format cdb: 04 d8 00 00 00 00
     format parameter list:
         01 02 00 00
       duration=1 ms
format unit:  Fixed format, current;  Sense key: Illegal Request
  Additional sense: Invalid command operation code
  Raw sense data (in hex):
         70 00 05 00 00 00 00 0a  00 00 00 00 20 00 00 00
         00 00
Format command not supported
FORMAT failed


Doug Gilbert



