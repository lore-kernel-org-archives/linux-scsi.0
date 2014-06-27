From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: External USB3 disk fails with "Invalid field in cdb"
Date: Fri, 27 Jun 2014 11:15:41 +0100
Message-ID: <20140627101540.GB10042@localhost.localdomain>
References: <20140626205519.314a71ae@wiggum>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbaF0KPw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 06:15:52 -0400
Content-Disposition: inline
In-Reply-To: <20140626205519.314a71ae@wiggum>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc: linux-scsi@vger.kernel.org

On Thu, Jun 26, 2014 at 08:55:19PM +0200, Michael B=FCsch wrote:
> Jun 26 20:47:14 wiggum kernel: [156019.870310] sd 22:0:0:0: [sdb] 976=
773168 512-byte logical blocks: (500 GB/465 GiB)
> Jun 26 20:47:14 wiggum kernel: [156019.870653] sd 22:0:0:0: [sdb] Wri=
te Protect is off
> Jun 26 20:47:14 wiggum kernel: [156019.870659] sd 22:0:0:0: [sdb] Mod=
e Sense: 47 00 10 08

The disk says it supports FUA:

> Jun 26 20:47:14 wiggum kernel: [156019.870956] sd 22:0:0:0: [sdb] Wri=
te cache: enabled, read cache: enabled, supports DPO and FUA
> Jun 26 20:47:14 wiggum kernel: [156019.924517]  sdb: sdb1
> Jun 26 20:47:14 wiggum kernel: [156019.928649] sd 22:0:0:0: [sdb] Att=
ached SCSI disk
> Jun 26 20:47:27 wiggum kernel: [156032.936896] JBD2: Clearing recover=
y information on journal
> Jun 26 20:47:27 wiggum kernel: [156032.938218] sd 22:0:0:0: [sdb] Inv=
alid command failure
> Jun 26 20:47:27 wiggum kernel: [156032.938222] sd 22:0:0:0: [sdb]
> Jun 26 20:47:27 wiggum kernel: [156032.938225] Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_SENSE
> Jun 26 20:47:27 wiggum kernel: [156032.938228] sd 22:0:0:0: [sdb]

The disk doesn't like the command we sent it:

> Jun 26 20:47:27 wiggum kernel: [156032.938230] Sense Key : Illegal Re=
quest [current]
> Jun 26 20:47:27 wiggum kernel: [156032.938234] sd 22:0:0:0: [sdb]
> Jun 26 20:47:27 wiggum kernel: [156032.938237] Add. Sense: Invalid fi=
eld in cdb

Looks like a WRITE(10) with the FUA bit set:

> Jun 26 20:47:27 wiggum kernel: [156032.938239] sd 22:0:0:0: [sdb] CDB=
:
> Jun 26 20:47:27 wiggum kernel: [156032.938241] Write(10): 2a 08 1d 04=
 00 3f 00 00 08 00
>
> Does somebody have a hint to debug this?

I'd guess the device lies about supporting FUA. There seems to be
another report on the Debian lists of the same problem with a similar
JMicron enclosure:

  https://lists.debian.org/debian-user/2014/05/msg02066.html

Regards,
Bryn.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
