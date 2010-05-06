From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH] scsi: relax PAGE LENGTH check for thin provisioning UNMAP
	support
Date: Thu, 6 May 2010 07:24:29 -0400
Message-ID: <w2o170fa0d21005060424j912e21bev8dba13536d49ba41@mail.gmail.com>
References: <1273096203-3164-1-git-send-email-snitzer@redhat.com>
	 <yq1sk65ejs5.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:60272 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab0EFLYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2010 07:24:31 -0400
Received: by wwb39 with SMTP id 39so104950wwb.19
        for <linux-scsi@vger.kernel.org>; Thu, 06 May 2010 04:24:29 -0700 (PDT)
In-Reply-To: <yq1sk65ejs5.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, knight@netapp.com

On Thu, May 6, 2010 at 12:28 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Mike" =3D=3D Mike Snitzer <snitzer@redhat.com> writes:
>
> Mike> Thin Provisioning fields are assumed available in the BLOCK LIM=
ITS
> Mike> VPD page if PAGE LENGTH is 0x3c. =A0The BLOCK LIMITS VPD page m=
ay be
> Mike> extended over time. =A0Allow for the possibility that the PAGE
> Mike> LENGTH exceeds 0x3c.
>
> SBC3 states that:
>
> "If the device server supports thin provisioning, then the device ser=
ver
> shall set the PAGE LENGTH field to 3Ch."
>
> That's a "shall". =A0That's a non-negotiable requirement in standards
> speak. =A0And besides, only half of that mandated page length is curr=
ently
> spoken for. =A0So I wonder what motivated your change? =A0Do you have=
 any
> examples of devices with a bigger page length?

I forgot to cc Fred Knight on my patch, but Fred was/is attending the
most recent T10.  Based on the discussions there, and me having shared
with him the PAGE LENGTH =3D=3D 0x3c constraint before, he sent me priv=
ate
mail sharing that SBC3 is not yet final nor approved.  And that at
this recent T10 meeting they were talking of extending the BLOCK
LIMITS VPD.  If not for SBC3 then for SBC4.

So coming full circle: why impose a precise PAGE LENGTH of 0x3c?
It'll only cause compatibility problems for us down the road when new
devices do come to market.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
