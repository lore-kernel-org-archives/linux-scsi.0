Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD47F34EF15
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 23:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761693399; cv=none; b=ZTr0NmMVZOn3zVczUtk6lUF56mpA+v+CQewOUqxvvpT1Kba5khght+ukRIZn5pBxeKds3plbdS8jM39S8rvtfiAGOS1+bcNbFRNpdZzY5qQctITDAvHnCn3muaQ6X0juY+h76qMSmjT2HrlctBQ9IXX+TzaGbpL7+oJq/VFfsc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761693399; c=relaxed/simple;
	bh=EnR/TaaGxn9w+4F1+fRM9SSGt78ralDdsQPgAI33+24=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AlA+L9u53p3NxuWSB71SpSz0kIxbIQi4Unk8b1EhdBCxQGMj24/ygCPPzWFts3EVr857Gn+58MwFlsPnqK582QyHw/Uj7SEUTX3FeJZ5eFdRerzBIl93NUoRg3Ire5PLPBCdHJCupbj2VwagFobTIihTrqyoZn40fPNUQKCiilU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QgM5X2H4; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QgM5X2H4"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7832691f86cso90817207b3.1
        for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 16:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761693396; x=1762298196; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cTGE8Nk+NYr3HIPUwFKN0QH0BMMQkYXmtt5nXiUqbRQ=;
        b=QgM5X2H49TX616Xb+cjETE1NoyY31paDcsFMuFWUdTt/NRJoWC0/1//n3XuD+4MJzg
         brnTDTE9/pexbpbb9NYCiLdJwcXf9rqmMi3kImUPcSihla8WWqmTXrMwXFWkb1GYSNWU
         3YCnP2Ryq6kMwIhzqt6SEXHsCs5IuEwzO7d7/sw6W8hKLMu+oWWC8GLkwL9EI9CbYv/j
         GhsbqptVtJVl9/+jOml6lprfCAjkoIlPEZaIIjFxsC3aWFsl1bkTbW2fD17aJlNovhs2
         3R7bVT1j/aoevGF9/A2rydDj7Weocp/4RkjzhMa7LXiEWnVtZbfxRZ21rFQjn6GLIcoa
         6mTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761693396; x=1762298196;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cTGE8Nk+NYr3HIPUwFKN0QH0BMMQkYXmtt5nXiUqbRQ=;
        b=d2LFsnYGXcktgdxZrGfSien5iOjM10tg8uuKPGdQSBAZKMo1yAgFLQRVRSUcyzqx2k
         QEQ0tN5cl6SZ96fou4OXab3YV1IBWzdKrzQ1pYmdB37qV1VRfGQN64E/WkMFhVLvQQTM
         z61L5YyLjfBpQy/aREDbeIzQ+gln9/Gwmj+oimXbhqZMTb36WqECwwEE7RfFY+1x7v7D
         /iQRdoWjel3vjqX8ZGgjiLmo9hp6z0hLlDhW9Ngzcx2PcuvB4d040BrfZvhJe4P2fabD
         jQJXlgYnCwuWsNY36NpRXzz/pOzVSh+4uBafrCOSl3WBnWIfdfUsXfanKUS8HF1NF+kj
         QzJg==
X-Gm-Message-State: AOJu0Yw01ENdgMNx2e5Y8EnbgGj1xUMTqcKZhro/1h3JTnOpSyYDU3CA
	z1ETmYBW0Fm0BxLwZJDHFZRdrX+0VNJFrxOxK6efj0gQtQxwrqovx15Bcf/UYHatRkVTgGaJ1/P
	J/JEGj4Ri/50S+1dy8XsC7UOvo60eHng=
X-Gm-Gg: ASbGncvmMuITBHsSVGw9gPzyr+oivlQOfzkU0wOGbuiEK3uMKcEHk29hEl2e+wEqQU1
	BBB2ofxGvQw7WkFNgr1jMQ0tMmP55cYqJrIXXdf3aGR+EQx3xfGhkdnwXYY0+Gfuo9JFzeIMsfQ
	iyHJnGsodZUkoodbm/sihDXQ3RCy9rSADr/PSPFezQiR4xWN/zfxg4SmAtiPMXYZDHRH3Jw0yDS
	DlbDxzZaHhdTXnJ4Ky6yF3cj531R6SZ8dkvRtDQTtEvdjo7TkXa4E/BKEPTIw==
X-Google-Smtp-Source: AGHT+IGr5UqYJQR3XSvCeTjlzStQkWjjSO0lsevFyetEI5VkvBPJlTr5fSYLoBLKIkudH3+13ZfvV8u2Snxy15UHMC4=
X-Received: by 2002:a05:690c:9c0d:b0:725:39d:a31a with SMTP id
 00721157ae682-78628e84c71mr8965267b3.27.1761693396637; Tue, 28 Oct 2025
 16:16:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027235446.77200-1-justintee8345@gmail.com>
 <20251027235446.77200-10-justintee8345@gmail.com> <921bd950-4e62-4140-a015-c41ea7f07989@kernel.org>
In-Reply-To: <921bd950-4e62-4140-a015-c41ea7f07989@kernel.org>
From: Justin Tee <justintee8345@gmail.com>
Date: Tue, 28 Oct 2025 16:16:09 -0700
X-Gm-Features: AWmQ_bnspf0r08rRX59iRQpOd5XQDRi0-sw3oyJNnzNxJ6sAWWXRnvGJgIienV8
Message-ID: <CABPRKS9qL-vNbLeE=bqtk=wodVpA2fz8WR_n_iFXS3Yey_bbmg@mail.gmail.com>
Subject: Re: [PATCH 09/11] lpfc: Add capability to register Platform Name ID
 to fabric
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> > +#define PATH_UUID_IBM "ibm,partition-uuid"
>
> Where did you document the ABI?
So, if of_get_property does not find anything, then our driver will
simply not register a UUID with the fabric.  We=E2=80=99re aiming for
best-effort on platforms that don=E2=80=99t implement SMBIOS, is this handl=
ing
acceptable?

Regards,
Justin
