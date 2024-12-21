Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA82828366
	for <linux-scsi@vger.kernel.org>; Sat, 21 Dec 2024 07:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734767852; cv=none; b=LjNMrCc9qFejziBZ9Sc45N8ZOR8fDBu0LfMcLZvCULtqOgM2lmjKWulaSOG4yoMu/YF5/j46ekaTGq6dm+MoGDBR1CO/QWHcvaHGzuOT/dSrdIGIq5mUaSrp/tMlB8+LR9PAc7rQTmvMr2vKFx+UKfXn3dr0fn3yhsm2SXe9AZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734767852; c=relaxed/simple;
	bh=DnCJWIKB5g38Lf5bpt9CWZoC4hXxpxXr75uuKO85ZYk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=cn9obv3F30Ff45e5EQ/NWdLWUSfJq7c4FSNliyfC8wfjT6JErYx2gobt/f7Azrx/CTKd+Kvf9qkov1Q9eBRorXjOD4jIBu+KGVLKPf6yJELCJrfwDocvl2PnBvq8VzK8bjeQfyXxtYrxhB4kGgbZdjhJnRfF1rvuwO08HBq+FMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=bcAgqDdu; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="bcAgqDdu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=wzsDt+Rlq9HjdDac+OJk8WSLLQJwIzIrPym1xy8rSyY=;
	b=bcAgqDdu1/CSum68rqL60CDl9ObNWw+uFaJHb8awDgzkvGCa1fv41BbJLVA7KEslHc2Ww1nBUAWyF
	 g5o9G+5BH+NgSaxbUTyw6FZy81Tzazsn0VbqTumgKMBtdGEmhK0kCFZXuKCmBSRigZc4QkPcPXDObZ
	 T+ArXni67Njm3009qScpC1+e06b669nN8SEMHShvy4CrlK8pQgZP5lLXMYl960nQPt/b/DBhUSZmQ1
	 QMkVZ6mtoZ4RRXmbwTVWaFNIAjVgmgQ5YIkJy9ZnHCWET6bSF4LI/CeUp22E0kPtDD5oNRtgJoxroO
	 DOe3BmPEcwz1I7sYqdtxCPDAqLrJFtg==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw23.mail.saunalahti.fi (Halon) with ESMTPSA
	id 3798584e-bf71-11ef-a155-005056bdfda7;
	Sat, 21 Dec 2024 09:57:26 +0200 (EET)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.300.87.4.3\))
Subject: Re: [PATCH v2 0/4] scsi: st: scsi_error: More reset patches
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <b8af1fd1-6f19-4d93-95bf-034baaf4cbec@redhat.com>
Date: Sat, 21 Dec 2024 09:57:15 +0200
Cc: linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com,
 "James.Bottomley@hansenpartnership.com" <James.Bottomley@HansenPartnership.com>,
 loberman@redhat.com,
 Bryan Gurney <bgurney@redhat.com>,
 Ewan Milne <emilne@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C0258658-F026-4B8E-B073-9B403273FB06@kolumbus.fi>
References: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
 <0c6e699b-8f77-411f-b73d-e6762c6ad286@redhat.com>
 <8B3169CC-BD8A-46B5-B9B0-140047A44661@kolumbus.fi>
 <964CF609-B7DB-44CF-80A2-2955E73561EF@kolumbus.fi>
 <ad401bf6-e4a6-4372-8205-22e923900e5e@redhat.com>
 <2201CF73-4795-4D3B-9A79-6EE5215CF58D@kolumbus.fi>
 <b8af1fd1-6f19-4d93-95bf-034baaf4cbec@redhat.com>
To: John Meneghini <jmeneghi@redhat.com>
X-Mailer: Apple Mail (2.3826.300.87.4.3)

On 21. Dec 2024, at 0.14, John Meneghini <jmeneghi@redhat.com> wrote:
>=20
...
> Yes, I signed-off on a patch that introduced a regression.  Of course, =
I was unaware of this at the time.
>=20
> Laurence and I worked on commit 9604eea5bd3a (scsi: st: Add third =
party poweron reset handling) and tested it extensively with a scsi =
gateway using third party resets. The patch fixed the problem. The =
customer tested it. We told the customer they needed to =
reposition/rewind the tape with mt rewind following any third party =
poweron/reset event - which apparently happens not infrequently in their =
environment. This worked for the customer so we thought it was good. The =
st driver had never correctly handled a POR UA before so we didn't think =
the fact that MTIOGET returned EIO following a third party reset was a =
problem.
>=20
> However, the part that we were not aware of was: tape drives set a =
poweron/reset UA when the machine reboots. So we started getting =
complaints from different customers about the fact that MTIOCGET =
suddenly fails with EIO after upgrade. The work around was simple (issue =
an 'mt rewind') but customers did not like this, and when more than one =
or two customers started calling and complaining about this, we reverted =
the patch to avoid generating more calls. This is when I opened Bug =
219419 - Can not query tape status - MTIOCGET fails with EIO.
>=20
>  https://bugzilla.kernel.org/show_bug.cgi?id=3D219419
>=20
> We have fixed that problem now and the fix, including commit =
9604eea5bd3a, is being disseminated in rhel-8 and rhel-9.
>=20
> I see now that stinit and dd, and possibly other IOCTLS, are =
unexpectedly failing too. I'm not sure if we can call these regressions =
or not. =46rom what I can see the st driver never really handled POR =
UA's correctly. It only worked with sg_reset (first party reset)... but =
I agree that customers probably will not like this.

It is a regression because it breaks user space.

First, I want to emphasise that your patch was correctly fixing the =
problem it was supposed
to fix. And I acked it. The problems after boot were far-fetched and not =
easy to see. This
happens.

My mild complaint is that there were no reports on linux-scsi about the =
problems after
boot. Someone might have seen these problems earlier if there were those =
reports.
(With hindsight, Rafal Rocha's patch dealt with this problem.)

But now we know where the problem is. Let'f concentrate on fixing it.

...
>> The test uses modprobe to load scsi_debug (and this loads also st). =
After that
>> the tools mentioned above were tried:
>=20
> If you want to share the details of exactly what your tests are doing =
(privately if you'd like) I will try to reproduce your results.  =
Obviously, one problem here is that our tape tests here at RH (and =
everywhere) are inadequate - at least w.r.t. resets. I'm working to =
improve this.

I was experimenting with different things using (slightly enhanced) =
csi_debug and scripts
using snippets from your testing scripts. When I set scsi_level to 6 in =
scsi_debug, I noticed
that after modprobe, stinit and also dd failed. This lead me to think =
that this was because
now st caught the initial POR UA. The distribution I used for testing =
also had an udev rule
to run stinit when a drive was detected. The current stinit does return =
0 also when setting
options fails, but I could see that the options did not get set.

You should see these things with a real tape drive, too.

...
> I really don't want to revert commit 9604eea5bd3ae1. It actually fixes =
a real problem where the tape drive behind a gateway device crashes and =
resets itself.  Then, because the st driver ignores the POR/UA, it =
writes a file mark at the BOT.  This destroys the customer's backup.  It =
is a serious problem and a day-one bug.

I agree that the patch is useful. That is why it is better to fix the =
negative consequencies.

>> Modifying st to accept what stinit uses even is pos_unknown is true =
fixes the stinit problem,
>> but dd still fails.
>=20
> OK, shouldn't dd fail if the pos_unknown is true?  Basically, anytime =
the tape device reports that it has been reset the application NEEDS to =
reposition the tape.  And, for that matter, the application should also =
check and set any options that might be wanted.  The application can't =
just ignore these POR Unit Attentions.

Yes. But I don't think pos_unknown should be set for the initial POR UA. =
 I think it
is reasonable to assume that the user does not trust knowing the tape =
location
right after the device is added.

>=20
>> Not setting pos_unknown after the initial POR UA fixes both problems.
>=20
> That's fine with me... I just don't understand how you can distinguish =
"the initial POR UA" from any POR UA.  If you have a patch that can =
figure out how to do this... that's great... let's try.

I sent the patch ([PATCH] scsi: st: Regression fix: Don't set =
pos_unknown just after device recognition) to linux-scsi on
Dec 16.

