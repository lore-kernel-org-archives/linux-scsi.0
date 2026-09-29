Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590463E6DEB
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 13:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790688661; cv=none; b=Gv//HHZt8PdkCebdx/ePD/yxp2TaAlPHHibQy/TDPVhCnkzeVIWRJ1VBG4R0KLdAru+mmZEkBDEG6aGRA8DmzLc9SRxfvcvHjRm7Af+SrzMvlNJTNz1FWzCDTvQGJdpxhml0fo4YzX6k7StDuZcEdIuinjeVkyi1WW5qD6UERH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790688661; c=relaxed/simple;
	bh=AnzUnYR/qMCgCNr/tWqwiQjDdru9gycMqAfO6IslOEU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gUQyhaTWyDBkFTr9iRbTWyWurIPghozj8I9h6kwUtz2Oi0hxTjKwWxDlSBxuMuXPSvj4cGa7sGUjh//zyN9xCM8/NcvA8jyx4KAmiTXqsnwyywW4c9wVvQzzhWivsMTUuZXve1VFB6WZfgQhrtpdqyJa3f7U9yvWN1ZmR7d0kpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xfw22oa5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UKqdFiGa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xfw22oa5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UKqdFiGa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790688659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AnzUnYR/qMCgCNr/tWqwiQjDdru9gycMqAfO6IslOEU=;
	b=Xfw22oa5Hoo4qylQUrzVX/wwK0GU3H1UAkcHQu5DGFEizx1XnooPT9zSKWyW65viBH915A
	/3H/QKdMGglJ0FbhsOaw8oRpHvyfElWR/myPS9CmGq02nT/GN53tGH6EnsF2SsOKYy2Xlz
	LXC/W52zlTC5z8++xZyQGXZGULHf2zU=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-B3o59DOvOumduhnCRuVXXQ-1; Tue, 29 Sep 2026 09:30:57 -0400
X-MC-Unique: B3o59DOvOumduhnCRuVXXQ-1
X-Mimecast-MFC-AGG-ID: B3o59DOvOumduhnCRuVXXQ_1790688657
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-67453dc23afso4436184d50.0
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 06:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790688657; x=1791293457; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=AnzUnYR/qMCgCNr/tWqwiQjDdru9gycMqAfO6IslOEU=;
        b=UKqdFiGa4ZKeNhDWm0uS1tAU62tLlFdbfX9qkTc6xM/HyGDb2xZKfcV21RFgAB2IVc
         gnH5vx14vePQ6VBf4oJcfFtwlo3wOyW8bXbELy4eS11aoqIuCbJIrO1CBgZQ4BhIOp3d
         BsXmmMfnV8Aa5nwbSnTaEHU4JQ+84N86px4cfUTWQnX0M/OilzQ6ylh9FfknOQ6DMh1G
         AwfC8siaVmUeT5yY/bx20FLAtLPncPgetHcFGrQQWZC2qZ9CrUXqOWzObRAR4xbDVPQU
         LfQQox/dI6jPS9jlBffRxtY2d0BB5gxlLLJ4ayRPxY3Sp2AM0YicoiJV+4GmgKGcy//j
         B+6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790688657; x=1791293457;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AnzUnYR/qMCgCNr/tWqwiQjDdru9gycMqAfO6IslOEU=;
        b=ucjvcNAcqtHmOLZupPPF92+7PFRd29/GKKRqOwc22j2R9972DVe6xSoYpQJy4zdXq6
         U0e86biOYHaMGKqADfq93EudXn2VDyIfl+6jgZ5Ls2uqS6dAkLe5rOXc2jDuHEloJGhM
         20eHOOUuyHb+7Nrcdpeo+C9bM7zJmXOo5+8TN1OExgjH7RQ9FC/+/vWhsjl5bo0nM8VS
         5FcijgLm3W3Gs8dJNKC5GE/9ve3PMmJwV0nWr7yPhB+eDTfa2aUlR1/NVNVP9Nxrja8u
         A8h6ogKUo1njaTUaE50JmLnzGF3DMzfboujsngb1PYRC+dHpsrytCLoF1SbUxsfunt6Z
         1E6Q==
X-Gm-Message-State: AFuF++n2kM2yl3sYl9P7ISTiLY7+RHks2pcy+pSIdpPXnD1rv5qkf0gE
	4RWC3SJXExMwsvy+GIxz8Haz+xk4ibWY4wm5CJhFB9myjiyyZjkEPZJOuX2eS5kE9v0j+XoSbnk
	CnIamktXmV+kKYAH+4q4LgBs4atCFa4B4gdgfYWT0pFCZ7T2MWdO18glPTEspWQc=
X-Gm-Gg: AYBFou2jQnGJvsj6cpPpc663jaReWJd3yKrGywBuVQQ4kXsCbKJj76TJb33fy1mJKvf
	jwoGpe0AHYwPRe18Skp6uFVht/6uh7yS0nAiRPC3eO4yks0GaKNwpKtHYE7/eK/1F6TcwXt1f4Y
	uxHikyAh6KItWvi1dnR1kBS3k1uCzfCwSVfaFUf3b0EdbGQRCHruOX3UJbHxBYjMM7eBAz29HW6
	AVGAIHWqaZW7Gp2+HnDWp3YhIOYHsJ5ZcvtRpGCOW7q3pCIJeu4JZ3bLXPwugMDvK+qv3IJuwJD
	hEfZunaqB2KZa0oVs2aV//2cBvSdB9LgOGUqxU7cBGSoq5MWCGyq5d5gR/+t07938MieAfrBnSv
	Rx18UPX1zmqKe7SDFjED7CcSHJruEVzi4dDln
X-Received: by 2002:a05:690e:4108:b0:671:2eed:f6e2 with SMTP id 956f58d0204a3-674113adfdbmr4126017d50.89.1790688656634;
        Tue, 29 Sep 2026 06:30:56 -0700 (PDT)
X-Received: by 2002:a05:690e:4108:b0:671:2eed:f6e2 with SMTP id 956f58d0204a3-674113adfdbmr4125977d50.89.1790688656056;
        Tue, 29 Sep 2026 06:30:56 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9178d3af14dsm10178926d6.49.2026.09.29.06.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 06:30:53 -0700 (PDT)
Message-ID: <6997757cf93d863719622971c11e997e78063927.camel@redhat.com>
Subject: Re: [PATCH v2 2/2] scsi: st: Record the tape position after a
 successful MTLOAD
From: Laurence Oberman <loberman@redhat.com>
To: "\"Kai" =?ISO-8859-1?Q?M=E4kisara?= "(Kolumbus)\""
	 <kai.makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <mkp@kernel.org>, 
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, John
 Meneghini <jmeneghi@redhat.com>, emilne@redhat.com, 	bgurney@redhat.com
Date: Tue, 29 Sep 2026 09:30:52 -0400
In-Reply-To: <DACF75C2-73E1-4906-AAAA-A0C21CC0B859@kolumbus.fi>
References: <20260928132539.56876-1-loberman@redhat.com>
	 <20260928132539.56876-3-loberman@redhat.com>
	 <DACF75C2-73E1-4906-AAAA-A0C21CC0B859@kolumbus.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-09-29 at 15:39 +0300, Kai M=C3=A4kisara (Kolumbus) wrote:
>=20
> > On 28. Sep 2026, at 16.25, Laurence Oberman <loberman@redhat.com>
> > wrote:
> >=20
> > Commit 0b120edb37dc ("scsi: st: Add MTIOCGET and MTLOAD to ioctls
> > allowed
> > after device reset") allows MTLOAD to clear the reset condition
> > because
> > the tape location is known after MTLOAD.=C2=A0 But the driver does not
> > record
> > it: reset_state() sets the file and block numbers to -1, and
> > do_load_unload() leaves them there.=C2=A0 check_tape() sets them to 0
> > only for
> > a new session, which requires a new-medium unit attention.=C2=A0 Drives
> > that
> > do not report one when the medium was already loaded (seen with IBM
> > LTO
> > drives) keep reporting file/block -1 in MTIOCGET and no BOT,
> > although the
> > tape is at the beginning.
> >=20
> > Set the file and block numbers to 0 after a successful load when
> > the
> > current partition is 0, where LOAD positions the medium, and reset
> > the
> > EOF state as MTREW does; otherwise a read after loading at EOD
> > fails
> > with EIO.
> >=20
> > Fixes: 0b120edb37dc ("scsi: st: Add MTIOCGET and MTLOAD to ioctls
> > allowed after device reset")
> > Assisted-by: Claude sashiko
> > Signed-off-by: Laurence Oberman <loberman@redhat.com>
> > ---
> > drivers/scsi/st.c | 14 ++++++++++++++
> > 1 file changed, 14 insertions(+)
> >=20
> > diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> > index 0a4263bef9cb..f4393a8e8fb1 100644
> > --- a/drivers/scsi/st.c
> > +++ b/drivers/scsi/st.c
> > @@ -2686,6 +2686,20 @@ static int do_load_unload(struct scsi_tape
> > *STp, struct file *filp, int load_cod
> > else {
> > STp->rew_at_close =3D STp->autorew_dev;
> > retval =3D check_tape(STp, filp);
> > + /*
> > + * LOAD leaves the medium at the beginning of partition
> > + * 0.=C2=A0 check_tape() records that only for a new session;
> > + * without a new-medium unit attention (the medium was
> > + * already loaded) the position and the EOF state would
> > + * be left as before the load.=C2=A0 Set them as MTREW does.
> > + */
>=20
> Should the following be done for all values of STp->partition?
> And the code should set STp->partition =3D STp->new_partition =3D 0
> to match the LOAD behaviour. (Usually
> STp->partition =3D=3D STp-> new_partition
> and the partition would not be changed even if STp->partition
> is not correct. But if later the partition is changed to the wrong
> value,
> the change does not occur.)
>=20
> > + if (retval =3D=3D CHKRES_READY && STp->partition =3D=3D 0) {
> > + STps =3D &(STp->ps[0]);
> > + STps->drv_file =3D STps->drv_block =3D 0;
> > + STps->eof =3D ST_NOEOF;
> > + STps->at_sm =3D 0;
> > + STps->last_block_valid =3D 0;
> > + }
> > if (retval > 0)
> > retval =3D 0;
> > }
> > --=20
> > 2.55.0
> >=20
>=20
> Thanks, Kai
>=20
Hello Kai, thank you very much for the review. Let me look into
these points and make necessary changes and send a V3.

Regards
Laurence

