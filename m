Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759AD36A61C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 17:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761845675; cv=none; b=G4Zy2UhcN9Ii2Vs+0LIHoZmeWVagFnn0Gmwz1VM72APyWTaJ+5RbTKoNSfP4zKLmlgfbkcTaGPiCCYanKAHF8ZhEx7so/H49JHrFWRWdGDlrJ20XZf6YXHqUHYtXMPoZlNxsJk2oKC6Dh9BZjTTQh4flU15CUZ947Fa1cmEZ4sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761845675; c=relaxed/simple;
	bh=PSFGvayo8MFkE5I7GOQ/KFSqASXyJkXWeASGjZAnylk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z65fYa/StSrp4OhyMMjkc2QnlA2slTgEIBcGO3S4hK292+gDOuV3VFM0oJRL+t8Mneji8sEm4UACpIacP/xGsbRV6ogz0vPtZqEj56DCN40jGPQ/NaVQjnEtHFD39HIHcd/N5NwLJoEE9yVzQh98NnTOzIAJmuBsQw2HHUeFJOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J717SL48; arc=none smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J717SL48"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-63f533fbff7so1329989d50.0
        for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 10:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761845673; x=1762450473; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PSFGvayo8MFkE5I7GOQ/KFSqASXyJkXWeASGjZAnylk=;
        b=J717SL48P76j8FInfHmzgOmWj26OZmQnUCojGxaphQlW/2nxoAYP/i5NnzOIVfJVPX
         7LVJeefNk9qrak4E2gcf8Pk+ALFm3aWTj2JhAgIkPLvBsziQbxajoeBGtH2x+iZK1ERt
         vjsTCT9FhXl1v/K+YsnMyhM7gzdcjTigXbpejsYvc+iZHEHwjisKcoXO8ukcjF9lu1lX
         f6PjyKn4n+obsmeMeSedtSupb9ybBi85Ur3WlgFSYRH1AKxKeFiymAKGF5Wbw7AkhbQH
         hsJQYC4iLvD4k9Cwk+xAlBgeOl2PiocLrncgAsI8wHv0xq7DZoeSmfIp+Rk3Y2PWXMk6
         GFSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761845673; x=1762450473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PSFGvayo8MFkE5I7GOQ/KFSqASXyJkXWeASGjZAnylk=;
        b=xIpn4B2DLDQk0BcIx3cZL6pRr/DC1G4bdbuldXs87wEAqRAYTgWFy1tmM6h/6cYlAA
         FlrxKfVh7ZevO5N9WS5yps5xn4w6mZG5wbxmg+ULDZpY88dhA2TZUSGk7sV7GRlVTg5D
         VovS4kZktivyV/o9nvAQ484t4dysGsonS7OQC1bW3PH+ZV3JzgcKv1W86j8e2ZxhOhKF
         CQNojd1M+qSMXe2zHyoVOpTY2juZWIG95hqYUMFoBKde+t4iOIP1CHEU1JYtx9rRREM7
         Wd6v3x8tCWDTZqIRQeUVIw0rgkq/eqvVY3fx/dDRceISNdlwvpikU0B8gR/0YMGnMQQi
         Anqw==
X-Forwarded-Encrypted: i=1; AJvYcCU6USELJWXBLpsTUg+sCpnKWSM68KWmTZML4EzheveSxR4pkIhefK2zjCejSHjvo3Tz9wQ9x5kjR5LN@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf0eECxIVAnZaisXMorrFxeuPmdI90GwN4MKAaD6K7P2HVfmne
	Kd5EqhFIJm31Y2ixnxXaN1pYMwuSIsKqEqJ0pN86XVkXY9bMfm/JNJKhevgKs/bk8m9TXG8R6C5
	JUQjbylz0lzH9vmSh2U6dzutJQ4xbsMI=
X-Gm-Gg: ASbGncsTQgDlneqqwM2NiUIe38reoyA83WMctDqdEOPXWDbg33GIoa5OEenaOevCzNR
	0vEP/cDr347VC3XqbK1NjDpn7DX6sk4lckVF0hLo/zyG6Rw95mC+Kkl2Gyn9KP2TQ6AMZ+Ah0UY
	CxSgC7k5PBDcHqiB35Bd5Hp5yMR2g7yVVZW9Q2IoCezINvJ3AGdD7kJFas47iZo8GcFGGMQ+4xi
	MmaAClCjmwMHxr64hoD0x29MS/DbabhKY008vxX0wRMNW5rjuvV1GFLlLgva84HZMvQNvNA
X-Google-Smtp-Source: AGHT+IGW1RR/EK1HGe7H5IXgE73oT/yC28TqN9jnfCAlufzP7adDfCJClhp+yAiK8uN5SBuKdbep8wLzCTX2sCxL1bQ=
X-Received: by 2002:a05:690c:e0d:b0:786:379a:51ec with SMTP id
 00721157ae682-78648577be3mr2395567b3.46.1761845673285; Thu, 30 Oct 2025
 10:34:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027235446.77200-1-justintee8345@gmail.com>
 <20251027235446.77200-10-justintee8345@gmail.com> <921bd950-4e62-4140-a015-c41ea7f07989@kernel.org>
 <CABPRKS9qL-vNbLeE=bqtk=wodVpA2fz8WR_n_iFXS3Yey_bbmg@mail.gmail.com>
 <a4cfc9db-3c41-4b92-ab2b-17b0ed7f1955@kernel.org> <CABPRKS-uBAzvCN6nRLy0bteG7AKAbeMUPfOsc85_ww7=OjrWpA@mail.gmail.com>
 <3d435d9d-cfdb-4221-839b-ca6bd671ebc5@kernel.org>
In-Reply-To: <3d435d9d-cfdb-4221-839b-ca6bd671ebc5@kernel.org>
From: Justin Tee <justintee8345@gmail.com>
Date: Thu, 30 Oct 2025 10:34:04 -0700
X-Gm-Features: AWmQ_bnN8eJ9SDbdPqzHixP7hAOF1j-E_oS2cfEShXZkwf1wZ7FNpk5nnN0J7Ys
Message-ID: <CABPRKS-6Z3kD9OxxPYqc6KN5JO-Qag976C_xzZBd8GxGap7zkQ@mail.gmail.com>
Subject: Re: [PATCH 09/11] lpfc: Add capability to register Platform Name ID
 to fabric
To: brking@linux.vnet.ibm.com
Cc: Krzysztof Kozlowski <krzk@kernel.org>, wenxiong@linux.vnet.ibm.com, 
	linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Brian,

Was wondering if it was possible to help point to any documentation
that the =E2=80=9C/proc/device-tree/ibm,partition-uuid=E2=80=9D property wo=
uld always
be available on IBM PowerPC platforms?

Essentially, does there exist ABI documentation that this property can
reliably be used for lshw, libnvme, and the lpfc driver?

Regards,
Justin
