From: Hannes Reinecke <hare@suse.de>
Subject: Re: st: Fixup -ENOMEDIUM
Date: Fri, 06 Oct 2006 11:19:17 +0200
Message-ID: <45261F95.90301@suse.de>
References: <4524CFAA.3010309@suse.de> <Pine.LNX.4.64.0610052216180.7808@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54414 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1751001AbWJFJTU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Oct 2006 05:19:20 -0400
In-Reply-To: <Pine.LNX.4.64.0610052216180.7808@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Kai Makisara wrote:
> On Thu, 5 Oct 2006, Hannes Reinecke wrote:
>=20
>> Hi all,
>>
>> currently the tape driver doesn't believe in ENOMEDIUM. Even if the =
sense code
>> from TUR indicates that no tape is present the command will be retri=
ed; maybe
>> the user is fast enough to slip a medium in in the meantime ...
>> And even if not, it will return 'EIO' in any case.
>>
> The driver implements (up to a point) the Single Unix Specification: =
if=20
> O_NONBLOCK is clear, open() shall wait until the device is ready or=20
> available. It does not wait indefinitely but implements a timeout. Th=
is is=20
> the behaviour I found experimentally in some other Unices.
>=20
Ah. Ok; you're the maintainer, you get to decide.

>> This patch fixes the ENOMEDIUM handling: TUR will _not_ be retried i=
f no
>> medium is present and the correct error number ENOMEDIUM will be set=
 on exit.
>>
> It is true that st_open() does not currently return ENOMEDIUM and you=
r fix=20
> for this is correct.
>=20
>> Please apply.
>>
> I don't think that the first and second parts should be applied. The =
third=20
> part fixes a bug and it should be applied. I include at the end a dif=
f=20
> containing only that part.
>=20
Right. Thanks.

> -----------8<--------------------
>=20
> Fix st_open() to return -ENOMEDIUM instead of -EIO if no medium is=20
> found.
>=20
> Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
>=20
Signed-off-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
