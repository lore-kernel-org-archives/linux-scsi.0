From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH 2/2] [SCSI] ufs: calculate read/write xfer len from cdb
Date: Sun, 8 Apr 2012 16:34:01 +0530
Message-ID: <CALMYJDsLNssLdqZ4Ci=TPfn57XzQeMO6-MX6deDJ3jUDLe9Gjw@mail.gmail.com>
References: <1333715241-32346-1-git-send-email-santoshsy@gmail.com>
 <1333715241-32346-2-git-send-email-santoshsy@gmail.com> <1333874647.2914.12.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45305 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2DHLEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Apr 2012 07:04:22 -0400
Received: by eekc41 with SMTP id c41so944725eek.19
        for <linux-scsi@vger.kernel.org>; Sun, 08 Apr 2012 04:04:21 -0700 (PDT)
In-Reply-To: <1333874647.2914.12.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, yoshitake.kobayashi@toshiba.co.jp, vinholikatti@gmail.com

On Sun, Apr 8, 2012 at 2:14 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2012-04-06 at 17:57 +0530, Santosh Y wrote:
>> Currently the Expected data transfer length field in
>> command UPIU is being updated with "transfersize" from
>> the scsi_cmnd struct. But, if the read/write data
>> transfer size exceeds the sector size, the "transfersize"
>> will be truncated to the sector size. Thanks to KOBAYASHI
>> Yoshitake for pointing it out.
>
> I'm a bit confused by this changelog, but I think it's saying you're
> using the cmd->transfersize field for the length of data to transfer?

Yes, I'll update the comment to make it clear. It might be confusing, i=
f one
is not familiar with the UFS spec.

> In which case, that's wrong cmd->transfersize is the minimum transfer
> size (usually a sector) ... badly named field, sorry.
>
> Based on the calculation below, the actual length you're looking for =
is
>
> scsi_cmnd->sdb->length
>
> Which is the total size of the entire transfer in bytes.

Thanks, don't know how did I overlook it. Ended up calculating the
same thing again. :-)
I'll resend the patch, which updates Expected data transfer length fiel=
d in
command UPIU with scsi_cmnd->sdb->length.

>> + */
>> +static inline u32 ufshcd_get_transfer_len(struct scsi_cmnd *cmdp)
>> +{
>> + =A0 =A0 u32 transfer_len;
>> +
>> + =A0 =A0 switch (cmdp->cmnd[0]) {
>> + =A0 =A0 case READ_6:
>> + =A0 =A0 case WRITE_6:
>> + =A0 =A0 =A0 =A0 =A0 =A0 transfer_len =3D cmdp->device->sector_size=
 *
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cmdp->cmnd[=
4];
>
> Just an efficiency not here, even though the code won't be written th=
is
> way, you don't want to multiply by sector_size ... it's always a powe=
r
> of two, so you do shift or binary log tricks to avoid the expensive
> multiply.
>

It looks like sdb.length is being calculated the same way in sd_prep_fn=
(),

SCpnt->sdb.length =3D this_count * sdp->sector_size;

Does it need to be updated?

--=20
~Santosh
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
