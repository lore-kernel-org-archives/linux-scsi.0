Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4893B27EE
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2026 21:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781126114; cv=pass; b=b4mbwiRYjmK+OlQpaCbjYeKoyOR/0kNf1fO9xVA8FjakuPlotZkWru3i/gwvdSu5vyXepcWuy0cSGd0gwEweVdGzCcruDIgdSnkJSVYJtkF4Sel6maGfdrOIuZeyokRtK148oro+Hn2qmy1Vh0yFSqlnTSQCoaIoX3YvAK78gSg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781126114; c=relaxed/simple;
	bh=EGpQzpJjEGw4p/nsDBsR+Z3CTFBHxeyJAhSw1nUgaVA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nDj/BRxlPi1b57n/QqB40CYOMJYhBJHf0WaKZ/NqFrS3wa7V6iqRKHBkbGbKWgU3BG9Ul5qOAwC6SgYaf2cZZYXg4x1PB876ewRyxTAJZScCr8b26AGQfx9Xv8Y1EEFS4hWjoG8HHTMDfSBzdd0G+iUbDQipN/BW9sFwmB7yWDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iMj2x0GM; arc=pass smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iMj2x0GM"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8ce9df31130so108224556d6.1
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2026 14:15:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781126112; cv=none;
        d=google.com; s=arc-20240605;
        b=e/Fxwd9au1S7ubiV7jo1bbHHr1996eDyOLPuwUDzzcT/ySTTDg3TxmDdVwAjJyvRNv
         wZEdFz/oAJNLO8/qTqt6n09YNNW3FvUClmFiIky4qPcZxhW7JuDXWovKnA3FDFvojPxn
         SVAAbpKiqHQwb3x/it5sA4yRE8ykv0rIWepo3RWfQtIUPzrYDJm5Ibv04HfS0aV3h7cJ
         ILhkL4+5tv/TgEqMNAUb3itzZcAC1iKOmhYKgxNoCtkiIhZzo41YddPVjAsXIqWiH0J7
         uxMUZOjr//peOAwE8vg5b2SP1DM9jGCIgSClISc9BT54XWKaVTYEdlnxc35Mrgiye2eS
         dbuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=CnEP+eDU+Z47vl3ZUVZxc4v1rI2pyGOwLoRS96m3ZO8=;
        fh=FFd41/wgVcQGJ9LWV+0lFMjKf8oLHeWh1AS5aa023SE=;
        b=DUB3zq2Iwr1ksxDJ+PDcTl7kWRSkt6UTcK5awxShpAfJQ1X0bda7bDvbEhvzi7AgDB
         cRiCI3iClcc3UKhGoqErDyNzp2UwwapJYqVsvoj42hFqr15IckmYA1ciRj57wldd3UCn
         kHUKJwE6ZmiHlrULqNoUJysHh8BuZ8AS21ZSx4Jg52Xz6uVdSRWAwmSy8g2+uM5drbST
         G+ZsfUXi52L6HdMWSn7uayjp3cLp5B7P3Fz9B7FNFFkVN2q2MOAWLGK0R1H6XB5pIa91
         kseN5WVszk2rjftar1YA1/h6XuXPGCpLkTr+iZiXrnZLb7FmOOwSi/4zYKIq16GJsX2w
         ECow==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781126112; x=1781730912; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CnEP+eDU+Z47vl3ZUVZxc4v1rI2pyGOwLoRS96m3ZO8=;
        b=iMj2x0GMpjqB04Le1FF9HrUcGJY5ah+5BxzqP48I4vHqAC603ZqHnX/ZFcarSvusbv
         wlDQwmz/ZAG5uWPZmOsLe/s3LVz2YJ7/QlX9HfMHQKedo5TsoVZrRi3fUnjFNyVlDEE6
         FhxLwVxP78Y5Cn3tMKpBnG7Jr/VrdaKsXlgkrMtMisMJPrMw85nFvSis37rIleP+IHOS
         43xArgMH+8ImhnST6/+d05+Cl13NrE9JaOWsCOlPEfkC2To+UYW6RPvDIT18EFywN2aQ
         BubS/r3+Rit2qCpqVYkO51xFPyQfWqZBbhKG/irlQ+dUcnrhftcYqVLqKfaqyLz2x9Aq
         piIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781126112; x=1781730912;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CnEP+eDU+Z47vl3ZUVZxc4v1rI2pyGOwLoRS96m3ZO8=;
        b=e4+MUoiaOGjd1aKIPVkbqRyjud4VwtNqQWctxPaHD4y0SJmEiwlwcsMeLuYQbh4nE8
         HxkjYjrjeLrdPlgnaDW95kr+CnS1gFi2VLzqMxS/Jvk+/LxCzRJ2klYU/X6BN8oHpgpv
         48xfAHZMAOG60PQgDly8cYfoxwcMMqMV7y3HGh2zL/b48Gqn7TYyczSJ7gBNpZqrR+3x
         M4o6n68V/iJLUFfc/GilWR7jdur5nVNRI0fW7Jt/DWxdGECwa7svYT8rqnc27YqUQ/dd
         FKQwEEVi5Fwmxc1/vO2YrF6Day1wAHs3EkBEAy+NdCgmg2q9Q7pzDmRxv5NobD6d/fn0
         azCw==
X-Forwarded-Encrypted: i=1; AFNElJ/HyQgmugM14gFk0iAUStkJQWaBtUZCOl/Z75VQU1G1/t8Sv+06NP+JernYsK2VssPGZG5CNdxHt3SG@vger.kernel.org
X-Gm-Message-State: AOJu0YwlUte3nm/4JllOvjErd+8MgDLsTTHM9LvHGRUdpCni2MWuv/Zg
	MdS9fA3a7ycrEQw9sTBt//bkLMdl5seMuhHN0PKq+71uvGvmguqwOVWu6+rCQA+S8Ry2bb4/yyY
	S4kmdjiTBv7dKvtors+nUCFnQcRkOYuM=
X-Gm-Gg: Acq92OHd1G/w4C9uru1s3MYKxJ9sAninIDvfGo5JwGwzs0sKgPgHhiZsoByQnIuCCCk
	370vMyzBxhZAfl1YYGuhsy1ZutwT/5fTgCIgVqZGuZJPYozSdc1jvL+ysv7FXwuy1qMIisNvr0a
	Q0v9T0FEt+Yns0LbMs+qun39vU1hi39oFrBG8tktWIptGZYXHiOnt82ce1VFE/NrcpvP5xcujWS
	hrj4po8YReslpK3yP8d4DjJbEwrHCAYA1/6yxtEwXsrI/0zKqbZsTWLpX7ltTlinenu32KSDxi2
	HuFeoTb8VlyHODMaygi2gbmLDTh+YAWqpXMpt0b0ntADBEtvLR0=
X-Received: by 2002:a05:6214:2f93:b0:8be:3da0:bba3 with SMTP id
 6a1803df08f44-8cee625bb2amr449999006d6.34.1781126112468; Wed, 10 Jun 2026
 14:15:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260610114120.3748526-1-michael.bommarito@gmail.com>
 <CABPRKS_HbtV5vWx5nHT9rwJV4TGmOPj670yUuLK-Hd-r6TBF1g@mail.gmail.com> <CAJJ9bXxMvSfzttjiRATN1vkVP9-RyyH-P6O4yMwVJGcpZVOCFg@mail.gmail.com>
In-Reply-To: <CAJJ9bXxMvSfzttjiRATN1vkVP9-RyyH-P6O4yMwVJGcpZVOCFg@mail.gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Wed, 10 Jun 2026 14:13:24 -0700
X-Gm-Features: AVVi8Cf-VVmXHd4G4dVcNeo3e5QSfEMnGy5UCy4Mcsge7c2VQHC5_vNz6ydOU3E
Message-ID: <CABPRKS8FJMHSsitLA6CmS=jyJYur9tKd-pG5mLxrbj9B2aQj5A@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: bound RPL ACC payload size to the response structure
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Justin Tee <justin.tee@broadcom.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Paul Ely <paul.ely@broadcom.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Mike,

We work with operating system vendors and notify them of specific
patches to cherry pick into their distributions.  It will be through
this typical method that our partnered vendors will be explicitly
notified on how to address the reported issue.

During the next lpfc version update, I will CC the stable tree on the
planned patch and the stable maintainers are free to backport at their
discretion.

Regards,
Justin
