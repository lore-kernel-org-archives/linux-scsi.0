Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CACE2DCF55
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 06:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776407372; cv=pass; b=C+K+VXom2OT7IR4uSAJf754DM47m56KdnE88Ruo+e/hhciBpjk9+wr5YzpJBZP7hrD0KxOrmUkH7id4rUWZxD6rnS+832ULiGV4eqrhhQhyIXfblJBGvejI0Je8RD2JfMqBX7+Y+FgzYLtoSHcDOcjUXS1vx6UwOIU7+M90pvAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776407372; c=relaxed/simple;
	bh=14+xQ1a1G1nEReDxZ/dXNTCYJEzLvvv8MSN6K/ZJ5yE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NeU5vpYVu+oLFgsDDcMaBBQdWcYjHcxnzds62MIkqOZQJaViCq36hhFtPuoBgv5dtMtMuT+hUuXclXTqlZ+q7kKq7D+2AC//ZBi+hn763T8s2HARvGr/qGPkLBWhTmv/GHq9F1JZGNA/TMY5vLHkxnsMsYUSAESy2XP2RIfw4Eo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dRL0InEE; arc=pass smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dRL0InEE"
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-651c366f7efso366131d50.1
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 23:29:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776407370; cv=none;
        d=google.com; s=arc-20240605;
        b=LQaBSBSBICiFzQq0v5irhBXmS3p1zaGAmAzpJSZI8Ekrwb88fCXqHQWra1DYW+h6iz
         pu8vSWssBtM72dTL+1eHe7/X4UdGwHPWmwq6F/K9/ozkBUEyCp/u6YVNiyy07jNwBNJJ
         39NH+rPsu8g4X11NZJljBjaCPuKqOFKs4EDejfZFVQeycpNy55meXem1nCy27v6q6rJb
         sLbfFDOoQpwpTPexN3d5p+Xvj/3goAwafV020UJJk7UTDFB4R0Se12Jxxp+ym7MRngTR
         0MeUjQTSJKjQMOdk8f9u7CSyaCAsKQknE8Rl2jgFspziwlCIovtfWj5M2slhp6aHj6gx
         ShCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=14+xQ1a1G1nEReDxZ/dXNTCYJEzLvvv8MSN6K/ZJ5yE=;
        fh=VKVxYU/CDIcXI6o2mCEIkz15C5KNzV8GEY1aZqtXUhU=;
        b=U/t2YjF2ccRH/AH/vyjq92mcs3iU7rYlc2Vxofk2v/y/+vgLeR9z++AwNUkjwr3oeO
         gnkNT69/1WCuzZk6G87TXZD/qA+KLqPJh0W/BZtsnURDeAT259TEygrx97bAvUgtOf96
         2O2LObPEBLSEnXD/r6x118s+4duc2N7RamxYgR87FeuLsBWfu8X1ZwBlTwJUgN1HIMLO
         jU823TKAfZp+Qcmp69nWommvGawCC1ti8YGAotjv2QBAp7IS8jf91Gisox4bwcQIz6WV
         5AguGEeZuUmsQurPVWnQTTs1jX5sowihwbzWzganN4+v8HeNNsjMQdNSo9uGuinMAg6c
         srPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776407370; x=1777012170; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=14+xQ1a1G1nEReDxZ/dXNTCYJEzLvvv8MSN6K/ZJ5yE=;
        b=dRL0InEEgFE8OsBi+RX1369T8RPHDBJVDlVRMP3N7XDecGfKlhFPWYzrUrQQ455O9V
         8MSFZnTzDAZ4SnJUlXRt1++ncGvRdcRB3jjBCQpiNl+doR3m4Q9i1fmdvPVA4lnRIHML
         5+uWpKDWSj+Y83qMk577S+U/qdzEwgV9zzaN2oXdxIKtXCI0FflPpC5mI9CHDQ4Y2cbk
         oapOtW8GQZikO0xISXJ9YHhl/Tk2hPWLByVMvxwgCR6r5OF5ysMYvHyqd24hMOLs6md/
         kabRS5Tre7qVZp/7+TyP2rg5OR4nP656muzT3CrfWqpnQ5WyddYMpT0Wfz9Z/IdnLMUg
         VEDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776407370; x=1777012170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=14+xQ1a1G1nEReDxZ/dXNTCYJEzLvvv8MSN6K/ZJ5yE=;
        b=oLVQthdDxVTM0fQwdbQ1p9/mwagLbRU0EJg9BnzVMiLTJ0EmNfkMJ6JQfFZ5bdutKy
         o8e3hxB9q8XXoPo4FsQqus9RY3PY3O9moR+2t0WNEH7cIkSplaPKdfOrLzCC1eVhwiAG
         1LutTEgweJmuH3m+qrUyLgOzb1WNY3bx7uPk2lWIQOSHvjTTpMvM+lWycg7snY63awxW
         d+PyxRbXafx4kQK7/HdXwlbkW9zvVrLmjy1IO+8z59I3aPQHOUJ65DAJoK3YwOeZe4Vv
         g/0KhsNGRBiGi955fbCfg1Mm8SwLamjqRNXC/3NvPoTDXE/Z36+TMjjn3o3tvRuA7XzK
         XeKQ==
X-Forwarded-Encrypted: i=1; AFNElJ94AzMjz9riIU1zxX5IkEMmtueSsCl2LfC68WvHePnMKO0rHN/akxT2S5UrT/ixGLHxy3/SNQ+3Cfeo@vger.kernel.org
X-Gm-Message-State: AOJu0YxJZnSwhrzQ01SmFU04twHA57/nfo1EocSftNPFNN1eu6D0JYFX
	WTCE6RCvusmaHYpdA3TgrvDnLgx4k6ORdbn9JduBI+aj3WnowRJc8h+AU3cTTvUJ/Vs0QvwUcPR
	WX+33Il3xsPW0QJ5eekbqPGUfqiQ8D4I=
X-Gm-Gg: AeBDiesAbcE5Oqfe8eLJI2iijRCJx4ITnrc0diGXwvZ9YKb4/8sFOlH+er/UQ4uuLV2
	j1DT58228iHVHARdZSUgbMpV7e0O/6GpH8yFI8NRVu0zDqPh0us9sluUxG2HcxR1wgl5eQnSpQH
	ki5OrpUMkoafos9bNv1qvi8bRBL8ZXEeAdBODd60/0evHJfSpmcE2NzzEtKVqX5Nin4mUpLaVPr
	fJ8Iz3I1DF8pJkuI+F79ueaSEO8vpd0Jn6Q88mBt2/L+bX/x1NFAdu7YANWu7H805+1qq/o1Rwz
	banivP2X8F1Z163eyoIp
X-Received: by 2002:a05:690e:4319:b0:651:cf23:6612 with SMTP id
 956f58d0204a3-65310a12bb9mr1045818d50.34.1776407370491; Thu, 16 Apr 2026
 23:29:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416165935.3958686-1-lgs201920130244@gmail.com> <b1a6b96d-07d2-4a19-b9db-2cd8d878895c@suse.com>
In-Reply-To: <b1a6b96d-07d2-4a19-b9db-2cd8d878895c@suse.com>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Fri, 17 Apr 2026 14:29:20 +0800
X-Gm-Features: AQROBzBxiJ9VZU2-aWBk9HO70GvYytY3hQ-cUOKrLjdfj36nQ9VfZ_4L5Zu0VDA
Message-ID: <CANUHTR_qm94JQn-FKa9BfRgxadXKbXJmJEof6ZdE070=Xi4mGw@mail.gmail.com>
Subject: Re: [PATCH] [SCSI] advansys: fix host resource leak in EISA probe
 error path
To: Hannes Reinecke <hare@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@steeleye.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Hannes,

Thanks for the feedback.

On Fri, 17 Apr 2026 at 13:56, Hannes Reinecke <hare@suse.com> wrote:
>
>
> You must be kidding ... EISA is died over a decade ago.
>
> If you _really_ are concerned about this please remove EISA support
> completely from the driver.
>

I agree that EISA is obsolete, and I understand that this path is
unlikely to matter on modern systems. My intent was simply to clean up
an inconsistency I noticed while reviewing the existing error handling
code.

If maintaining the EISA path is not worthwhile, I=E2=80=99m fine with dropp=
ing
this patch. I can also take a look at what removing the EISA support
would involve.

Thanks,
Guangshuo
