Received: from sonic307-20.consmr.mail.sg3.yahoo.com (sonic307-20.consmr.mail.sg3.yahoo.com [106.10.241.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0B7364A4
	for <linux-scsi@vger.kernel.org>; Mon, 18 Mar 2024 12:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=106.10.241.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710765925; cv=none; b=BfzJscp/2XR3Th01OFVKJI5tQNiL34mvdyjaruaTgcA0a7Mrpdr8LIQYU4E++2F+wL0pVmyLGwWJY2EUuo8R8+f8HSkMoIYfr9f4ktr6ZDQOIiBWyzGGH0JtK80uDCTGdVIGohV4bvujHvNhodmv887p3BrNNyIidDPiiPv+MbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710765925; c=relaxed/simple;
	bh=8i0UMoxhR5Oxtp8gO9mOuSjKqMhZ8L9nJmXrNEAA6ms=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=DoHjzE8GrjaNgaaqUZfQwmwMsWK3NKgxt7trRxyVDvt6etH8mlZjwGTHSzZtuUsH0h4BhhwtGxGMSDf1MY82GIBx53P4pq9IFt/S4jLrP4EY3Gf/LY0/ghDU0zih6SFxS0UySnTENFQpRfpvpk2OZfgItJQbNQtWlqupF0dB0IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=fail smtp.mailfrom=fedoraproject.org; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=t8M5YzWb; arc=none smtp.client-ip=106.10.241.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="t8M5YzWb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1710765920; bh=8i0UMoxhR5Oxtp8gO9mOuSjKqMhZ8L9nJmXrNEAA6ms=; h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From:Subject:Reply-To; b=t8M5YzWbDa5x5x3h6mXkrhZFLOyfFIZK2QLGKZWBsuzybkfPDrMXb7AqeG7GO/7F2Zz3EuYaUVefyt69QwD4FpBMPgFKNdQhbALTvq/uR0mUSfFZ+yHxJjNAyEiv9rU80MDUrJFINBSB2zrv9/6enVte0cnYJE7qrcLHK9KnEk6Ndf+y+zI9y2k3btL+U6fm4Kt+iPRrY8HcGkORL3DaRMsfG/l+SYbTJZwvWKZ+PxxcKADxX+Szk7xuIxmcrsF8seg/BZrmw30hXG4/R44YkdJ0+Kk1wwqyzjXjpa2goXsKmh56PwL+LwD82mPM4ov8d8XHfCqW62hRrDg3csG4bQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1710765920; bh=6jlHJ91EADcXJA8dkS6SNytspX6dotovr7ouWGn8mDO=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=r5ixoxz4HCm7ZD0/N3ev2aXM+1HRAn3IsIMotAyHp3SzeJ2K9Ll2g/jCnNXTOZYgvdGHHtkuLvE5AxD4orGvZ16D53Gn5UOZdzKvIwpIYm6h1hhWXpEI5FtspbdMZ6iuqasjoq4wTHLNOQ06lb5sCUb63lXTj0MTmd8+fwvvfoBGkjDtOREVq9nrvAk/O68n7hDQIgGXG4VriLu8bifbfkHhoGZyAh+DJsiayj5pEjLh0/5LsBYsJuerKFWpU3kTEm/j5TEkUE8fq2GH7qnrYRZyEziTvPx6UQ92FSGKJS1ZSiE9tlyt5GMPiQa36p1E0V49eYhBw85E7pDqChLjOQ==
X-YMail-OSG: c1kxXvEVM1kofzyPsY5nqjxdM_eYCWGlQ0rcLFncK7vRyu.rXiO0g7LX5hWPDkr
 pOwHLskD0VoVlvcV_c88d_0iFcq3jlgNDp7S4lQTc1rXD4j4mLiEQe1vFt6H8EMCC5uuo35oSjec
 4ysnoiddvusa3IASKrG.KMpMt8RnMmGdp0a8h4Jc1yXO1MVApJq76PAtZbEQn.fuZzO6557Zxn30
 8RehXIoK7lt25JYzxlmrsedhAqAkKoYjhCh2ktWILzIJ_MN2EH56l5d0MmaSh_l3a8iJonMfkHoQ
 WzTnLmcyo7v_7fXZZr0Q0x3UuB7p6PMuyFsqHe4qY0PYwk2YF6laUddFcc6ofZ2urY2Ri7Oc_3N8
 qkMURxnhJyJrggeKylcO9_lB6qlswYWgcV3tUcM04ARsIhoet4uZAUqMyLN.DG4c8dh1X9vtHNxq
 gDeJKhtvOm5sWaSpVdm4sB9xm74vrF6a2Tft2sEb3qKZrQCOCQ5Sfu4QBt0JnQTc4ruhmidkpdWU
 BOwbVChLE_FcFev48NKBy2iJki5NkYuuINQCnUaxJmL2ObjS9DyRkIAGeKJ5_LrW65X.vEPx7BWT
 RqO8uHw222VLCP2HILNj0wZiSPArTE.fBnsgydzuAxN.n08RdhG8IzfN.JF8QBOwq17vtYjMMVEW
 ffXIFMh8Q7cqaOhCG.TDuPTvlZLHo.mwqqhW1cAOxLtNDvR6Ac4fJeVqMXDas3MtaLl7szez7Kqi
 XnFJqntfrXmxuJONHaR3bkM8nfHv6sPrRlbYlHbshPwXQrmeQ8rw1ELxmEAr9dpSqNcGllSrdUKW
 wK_I6x5Ykkzq82HRQPH5ka4pme1FQ5CecXG45cXKNG_U8GeozAFjVlSxJ72TLyWyWvybNVuquJfc
 DM9nkB1w9p4FdsjOlIdL6.PZ1P0TIKUR2f8G00l.UxErTwxIW1XWbF8yNXuTj_1suVSaprn6Ffz1
 pT3zMfeTgaqyFrvVSMa0DYCXMRmu4E6W3b1KsXrUIf9KSeBNf6LAjhi.4fmzCkktvnaqDeKGWlxu
 W0Hi2j0aBLQe9ytiBJ.w9BjS_pP4QmC39Ru.kNuN2m4iR7JRqI9eUcuZUMh_TV819YuS7vMIXhmb
 R2Dn6.5BfrRPfgyCDFNPsRj.qfG7xUnAradk5UFuMzHEsPL5xe5mSZkAXtPSHKe63d6PIG7oaE3.
 L7ToO9N8FhSA4cg3zCxtKH60CEgSOnla6QB.cEVwdMyT18.2Vb3EZfw4L2g0mTDNQGIgX4vZBONv
 s4ht8KRvm5YZjdxKIjKpqL5BJu4s7Oc9BuI0yOs4UogTF0CExhA6cetN4bmQPagGQzM_TE3aSKU2
 7nsdVVoEk_i_p9_OxMkp4yKDC0sPdpnxV0nInsT2bNPCKEfLlhUvpjqNtxVcKPdjDZ_.oerSQeoC
 ZDCqrKmiWcZwUWQEAMp.Lewy6n7aR6LLFqzvt4DUcyOy4zDgUbeZwtnGr7TmZGAsL4tdT3SYN9pH
 0k7hOKAE3nbqjtOLYgCA8UWM.79vb.JQWDfWV9AFAYwfENz272WIhzDViMyQrFfXnXxOerXZDFvG
 aO.jxzp7XOWkDG3oFrdvK21k26rwunMnwlUWZsgWibsjyzdPhpy5K.Z9SfnBMpFw9QiIyCaSUnIU
 n2H7pGVPCLsktDIQVdZOd_CzOI9EHZlqDkDNOIG97IsWFurrSyUFUR0PNys4DhN6lQyo5MWICwm4
 axG.WlC7LQGKm3.ScFKK_ZYrQa2Sh_ujKSmIuqtQKF14aVw9.YIUxsjTGW0jW7PRU__Uz.oWtf0R
 7wRS8.um3mPJw6efFrzzF8TYm150QQTc4ourZzageEOrfYdC7kss1hPb6PPrYHLK9ipkhH0FTOZJ
 XIs_RfwD.P5xjiqD6wR37JRKIZ6_g2cRSD0L_eMvOmQb36S6r.q60d8Zayd5EEJkN8e1.RkEG1jw
 6REEi3jPuslVYwjjgjDOJ5QMnBxtedwMbA7ooaML_pO6Lb5rCUHuvilLLjsk.ZaMMcPbJTusBv3g
 o47vKxth_rnlS.tyLMAG6R785TbPhVHM5zWSG72wrCJ20YrqAMqJfrpKd2H9LptIvj2QOehAqg8R
 YMbRjXdcYJDKGnYbmOwyvBMcvM7f_GS8JR9CFzdrvgVLFSZ5HAHWkCrSDXJ_Qku7PcjN1cDHxs__
 XzvR3hPcPU6N_TXTRFYIeecP_K6oJnj_3JKHK6t9NJbnamkMiiVP90Gb6SKYibZATlkKSb4ptGgN
 ppxbYCjwph3zfpqwWKBvWix.sPJXZIpQeV8adzZLSWa7GtLeBzF8tmBXJ9lx7ac0-
X-Sonic-MF: <pjp@fedoraproject.org>
X-Sonic-ID: 2c6e9371-a9bd-4899-9c4a-34913094445c
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.sg3.yahoo.com with HTTP; Mon, 18 Mar 2024 12:45:20 +0000
Date: Mon, 18 Mar 2024 12:24:58 +0000 (UTC)
From: P J P <pjp@fedoraproject.org>
Reply-To: P J P <pj.pandit@yahoo.in>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, 
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
	Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
	"megaraidlinux.pdl@broadcom.com" <megaraidlinux.pdl@broadcom.com>
Message-ID: <1981046737.3660465.1710764698242@mail.yahoo.com>
In-Reply-To: <20240311121127.1281159-1-ppandit@redhat.com>
References: <20240311121127.1281159-1-ppandit@redhat.com>
Subject: Re: [PATCH v1] scsi: megaraid: indent Kconfig option help text
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.22129 YMailNorrin

>From: Prasad Pandit <pjp@fedoraproject.org>
>Fix indentation of megaraid options help text by adding
>leading spaces. Generally help text is indented by couple
>of spaces more beyond the leading tab <\t> character.

Ping..! (just checking)
---
=C2=A0 - Prasad
