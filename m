From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 14/24] libsas: prevent double completion of scmds from eh
Date: Sun, 18 Dec 2011 11:24:02 -0800
Message-ID: <CAA9_cmcvScFf9nxAmne3SC8w-55AAjyckPb85Sk=PM53_+GUNA@mail.gmail.com>
References: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
	<20111217023420.15036.51486.stgit@localhost6.localdomain6>
	<4EEC956A.2080308@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41883 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab1LRTYD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Dec 2011 14:24:03 -0500
In-Reply-To: <4EEC956A.2080308@mvista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Sat, Dec 17, 2011 at 5:13 AM, Sergei Shtylyov <sshtylyov@mvista.com>=
 wrote:
> =A0 Perhaps this a material for a separate patch...

If it changed behavior maybe we'd want it as a separate bisection
point, or if this approach for silencing this type of warnings gets
nak'd.

[..]
>> =A0enum exec_status {
>> - =A0 =A0 =A0 /* The SAM_STAT_.. codes fit in the lower 6 bits */
>> + =A0 =A0 =A0 /* The SAM_STAT_.. codes fit in the lower 6 bits, alia=
s some of
>> + =A0 =A0 =A0 =A0* them here to silence 'case value not in enumerate=
d type'
>> warnings
>> + =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 __SAM_STAT_CHECK_CONDITION =3D SAM_STAT_CHECK_CONDITIO=
N,
>
>
> =A0 Looks like you forgot to change the problematic *case* itself...

It was deliberate.  This is just an alias to get the 'value' in the
enum, but I think the real definition should be used in all cases.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
