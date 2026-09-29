Received: from fgw21-4.mail.saunalahti.fi (fgw21-4.mail.saunalahti.fi [62.142.5.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07F65218B9
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 12:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790685577; cv=none; b=QGUfkPADNNdER6lnUOJgajdEBt2Xdqg+IuqjqQg/XdN/b7ShJ7Ji3gaWK9r0JvaXGjJpPmX5GE7W8ezKu8aoyx+qSc2xZWM5PgXLGbbTlq1OGYChVuWRMiXh0H+Q7YVBUpnyBdr+SrAkzd2IFYmhlGACi9c/I0AW3gcGN9L6Vrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790685577; c=relaxed/simple;
	bh=JXh3UxCUENjzB9RcziP/cip1YB5dAdzSfmswftXO1DM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=WOoFgD8Wag/9QXyoz1DLW9/1pQVStTQzqsMIWtmfEZ82BD36YupNNwSQIuyVdfxlCMZ0X+eUKSAzhwtKFyWu4EDfU/x15NlHa/QABTn+fb+kcpF3LzgoeKaFZ+liyirNguO0BTh8ArAetWsQJvOf70nWX6yx971EIY/gD+50Vj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=AyjrtImp; arc=none smtp.client-ip=62.142.5.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="AyjrtImp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=u7HU19h5lbzGtU1iqNIQFKdGJ7qlUITz6hmAwOpJCWo=;
	b=AyjrtImpoZbG4CAH30k9YRvnEGTjn4LRs5jt8klL4Vz03cOyaeFwxQqJLeJLS8iBwHaEpeU7UAVWE
	 Kg8Wr5JMi3LMDUI8aMwqjKNZ50uRlGkoa/xp3BO28p+YyF275f59c9AYlLB1suCRaoqElXUu0AN53C
	 S7Vyrmld72lSTCJUvZQICBc5cHlDQfsUfEow8TmxtQhzLkHt0KImk7AJAiuvWtmv1LF1f1y55CwIKc
	 r0HBR699lUKYcFjhVV5lsNHRZbQr+5SGbvKOAfHQUhRQWbG+5lmNGJSIeNh0f4uM2q1vIJ+ec/ibCo
	 aEgAghHI1gpBbjHyJzx+Kob64gnzZWw==
Received: from smtpclient.apple (91-158-174-119.elisa-laajakaista.fi [91.158.174.119])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTPSA
	id d02b89fd-bc02-11f1-8e9b-005056bdf889;
	Tue, 29 Sep 2026 15:39:30 +0300 (EEST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 2/2] scsi: st: Record the tape position after a
 successful MTLOAD
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <20260928132539.56876-3-loberman@redhat.com>
Date: Tue, 29 Sep 2026 15:39:19 +0300
Cc: linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <mkp@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 John Meneghini <jmeneghi@redhat.com>,
 emilne@redhat.com,
 bgurney@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <DACF75C2-73E1-4906-AAAA-A0C21CC0B859@kolumbus.fi>
References: <20260928132539.56876-1-loberman@redhat.com>
 <20260928132539.56876-3-loberman@redhat.com>
To: Laurence Oberman <loberman@redhat.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)


> On 28. Sep 2026, at 16.25, Laurence Oberman <loberman@redhat.com> =
wrote:
>=20
> Commit 0b120edb37dc ("scsi: st: Add MTIOCGET and MTLOAD to ioctls =
allowed
> after device reset") allows MTLOAD to clear the reset condition =
because
> the tape location is known after MTLOAD.  But the driver does not =
record
> it: reset_state() sets the file and block numbers to -1, and
> do_load_unload() leaves them there.  check_tape() sets them to 0 only =
for
> a new session, which requires a new-medium unit attention.  Drives =
that
> do not report one when the medium was already loaded (seen with IBM =
LTO
> drives) keep reporting file/block -1 in MTIOCGET and no BOT, although =
the
> tape is at the beginning.
>=20
> Set the file and block numbers to 0 after a successful load when the
> current partition is 0, where LOAD positions the medium, and reset the
> EOF state as MTREW does; otherwise a read after loading at EOD fails
> with EIO.
>=20
> Fixes: 0b120edb37dc ("scsi: st: Add MTIOCGET and MTLOAD to ioctls =
allowed after device reset")
> Assisted-by: Claude sashiko
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> ---
> drivers/scsi/st.c | 14 ++++++++++++++
> 1 file changed, 14 insertions(+)
>=20
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 0a4263bef9cb..f4393a8e8fb1 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -2686,6 +2686,20 @@ static int do_load_unload(struct scsi_tape =
*STp, struct file *filp, int load_cod
> else {
> STp->rew_at_close =3D STp->autorew_dev;
> retval =3D check_tape(STp, filp);
> + /*
> + * LOAD leaves the medium at the beginning of partition
> + * 0.  check_tape() records that only for a new session;
> + * without a new-medium unit attention (the medium was
> + * already loaded) the position and the EOF state would
> + * be left as before the load.  Set them as MTREW does.
> + */

Should the following be done for all values of STp->partition?
And the code should set STp->partition =3D STp->new_partition =3D 0
to match the LOAD behaviour. (Usually
STp->partition =3D=3D STp-> new_partition
and the partition would not be changed even if STp->partition
is not correct. But if later the partition is changed to the wrong =
value,
the change does not occur.)

> + if (retval =3D=3D CHKRES_READY && STp->partition =3D=3D 0) {
> + STps =3D &(STp->ps[0]);
> + STps->drv_file =3D STps->drv_block =3D 0;
> + STps->eof =3D ST_NOEOF;
> + STps->at_sm =3D 0;
> + STps->last_block_valid =3D 0;
> + }
> if (retval > 0)
> retval =3D 0;
> }
> --=20
> 2.55.0
>=20

Thanks, Kai=
