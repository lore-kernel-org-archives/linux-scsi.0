From: NeilBrown <neilb@suse.com>
Subject: Re: [LSF/MM TOPIC] do we really need PG_error at all?
Date: Mon, 27 Feb 2017 08:03:51 +1100
Message-ID: <877f4cr7ew.fsf@notabene.neil.brown.name>
References: <1488120164.2948.4.camel@redhat.com> <1488129033.4157.8.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1488129033.4157.8.camel@HansenPartnership.com>
Sender: owner-linux-mm@kvack.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Layton <jlayton@redhat.com>, linux-mm <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: lsf-pc <lsf-pc@lists.linuxfoundation.org>, Neil Brown <neilb@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 26 2017, James Bottomley wrote:

> [added linux-scsi and linux-block because this is part of our error
> handling as well]
> On Sun, 2017-02-26 at 09:42 -0500, Jeff Layton wrote:
>> Proposing this as a LSF/MM TOPIC, but it may turn out to be me just=20
>> not understanding the semantics here.
>>=20
>> As I was looking into -ENOSPC handling in cephfs, I noticed that
>> PG_error is only ever tested in one place [1]=20
>> __filemap_fdatawait_range, which does this:
>>=20
>> 	if (TestClearPageError(page))
>> 		ret =3D -EIO;
>>=20
>> This error code will override any AS_* error that was set in the
>> mapping. Which makes me wonder...why don't we just set this error in=20
>> the mapping and not bother with a per-page flag? Could we potentially
>> free up a page flag by eliminating this?
>
> Note that currently the AS_* codes are only set for write errors not
> for reads and we have no mapping error handling at all for swap pages,
> but I'm sure this is fixable.

How is a read error different from a failure to set PG_uptodate?
Does PG_error suppress retries?

>
> From the I/O layer point of view we take great pains to try to pinpoint
> the error exactly to the sector.  We reflect this up by setting the
> PG_error flag on the page where the error occurred.  If we only set the
> error on the mapping, we lose that granularity, because the mapping is
> mostly at the file level (or VMA level for anon pages).

Are you saying that the IO layer finds the page in the bi_io_vec and
explicitly sets PG_error, rather than just passing an error indication
to bi_end_io ??  That would seem to be wrong as the page may not be in
the page cache. So I guess I misunderstand you.

>
> So I think the question for filesystem people from us would be do you
> care about this accuracy?  If it's OK just to know an error occurred
> somewhere in this file, then perhaps we don't need it.

I had always assumed that a bio would either succeed or fail, and that
no finer granularity could be available.

I think the question here is: Do filesystems need the pagecache to
record which pages have seen an IO error?
I think that for write errors, there is no value in recording
block-oriented error status - only file-oriented status.
For read errors, it might if help to avoid indefinite read retries, but
I don't know the code well enough to be sure if this is an issue.

NeilBrown


>
> James
>
>> The main argument I could see for keeping it is that removing it=20
>> might subtly change the behavior of sync_file_range if you have tasks
>> syncing different ranges in a file concurrently. I'm not sure if that=20
>> would break any guarantees though.
>>=20
>> Even if we do need it, I think we might need some cleanup here=20
>> anyway. A lot of readpage operations end up setting that flag when=20
>> they hit an error. Isn't it wrong to return an error on fsync, just=20
>> because we had a read error somewhere in the file in a range that was
>> never dirtied?
>>=20
>> --
>> [1]: there is another place in f2fs, but it's more or less equivalent=20
>> to the call site in __filemap_fdatawait_range.
>>=20

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlizQrcACgkQOeye3VZi
gbnJBQ//X+H1BAE9cC1V24BQ+Xn4aLAmkspAnwRuKvOqbFIkUp+PIodvRlO/2oVi
YI+MqlDclDn9IVMiySSHbMZ+f5Zg+iSpcX0eQkQ6JMQKJWFAj+bWvXdSEslfAbon
BvYJEiHBRFiGxBgihpBczb/GMU+2g9HrIHg9fWh3cL7eFtQ8h2THfclWVEmQcSYf
loesYK/q7Q0NJ7MfTAxv6I2fOxP/Fdea5Mp8l3ttoyzwIsHkxHYudPQ2xRPB762N
ShPr4cAefsOTfh1Tyzk0VffVM/kW9icgliE4sxjIa2pCORZidFzEV0jTDMpvCJGB
9YqBtNZiwc4OD0n3ItR4VvsvBl+F3V7BM/mzKkq7POlZhEsE66mTNEhF6l27Y2Rg
/5pA0cgepQoqgPP3BlbclHlT75PIQIbIAMsGM+MMtC1yglsPgPuqRxAm+fYH0cko
pVtRkL0u4JDSABINRxhMuI3qwHqWP9JfQaZFoHXo11iIgI9wPr9Ym5+QTHjU/sDi
cjz8PnZ+oL//1GT3hdu/iBLao3cX4LCcOdTaII6stZub6r0CLRKtd5T27t68qwTp
7GaRvdeLuVDo/2bSYW0nudHSyTJicbO8YUVFXp69KgYppSfmdWxEUL5ibaSRfLfc
EwnTM24697cseThxlZA/ItAwo9/kc31A79VGO/gDTgTJ+g+L8Uw=
=Ajz+
-----END PGP SIGNATURE-----
--=-=-=--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
