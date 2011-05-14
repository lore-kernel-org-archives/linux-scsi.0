From: Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org>
Subject: Re: aacraid adaptec 6805 support?
Date: Sat, 14 May 2011 08:25:33 +0200
Message-ID: <20110514062533.GA13324@apartia.fr>
References: <20110513141242.GA1048@apartia.fr>
 <20110513164922.5167ea53@harpe.intellique.com>
 <20110513145420.GA2797@apartia.fr>
 <20110513172457.0db50c93@harpe.intellique.com>
 <20110513153922.GA5041@apartia.fr>
 <20110513183356.64937c6d@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zenon.apartia.fr ([82.66.93.83]:55929 "EHLO zenon.apartia.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab1ENGZf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 May 2011 02:25:35 -0400
Content-Disposition: inline
In-Reply-To: <20110513183356.64937c6d@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, May 13, 2011 at 06:33:56PM +0200, Emmanuel Florac wrote:
> Le Fri, 13 May 2011 17:39:22 +0200
> Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org> =E9criva=
it:
>=20
> > On each disk the third partition /dev/sdX3 is the last and largest =
but
> > it seems the Adaptec controller doesn't "see" the end of the disk
> > where the md superblock is? Does that make sense?
>=20
> Not to me, but I've seen weirder things from Adaptec firmwares :)
> Are the drives configured as JBOD, or something else? You may segment
> the drives (for instance if their sizes differ slightly), so maybe so=
me
> of them appear as volume segments instead of JBOD?

Actually I didn't configure the Adaptec controller at all, just let it
boot with disks transfered from the LSI controller. So the disks are no=
t
JBOD, in the adaptec sense at least, which requires "initializing"
(meaning wiping) disks. I thought JBOD meant "just use the disks as the=
y
are" but that is in fact what adaptec calls "legacy" mode:

	May 13 17:09:57 zenon kernel: scsi 0:0:0:0: Direct-Access     Adaptec =
 6805 Legacy      V1.0 PQ: 0 ANSI: 2

And in that "legacy" mode the disk geometry appears slightly smaller to
the OS than with the LSI controller, hence my problem with /dev/md2. An=
d
/dev/md2 is a huge backup partition that would be very inconvenient to
wipe and re-create (xfs doesn't support shrinking alas, so I can' shrin=
k
the partition).

Anyway thanks for your input,
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
