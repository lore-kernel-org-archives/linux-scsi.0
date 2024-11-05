Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3B32003AA;
	Tue,  5 Nov 2024 19:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730835044; cv=none; b=k1XiPRSyoWnKaQp5TaUPUxewEhkpPJ5ZMco8En3sZVX7DrjpMZ3mXIEKqs78c3TnOE6LtFLPhF79Y5kIKbQf+oQqQR258zxGnCp2BNjU4JCKgOS92Y1AZS/6qAbAaIthiPckZHp4nIvnI1mGQA4X6D9sPweBRpm99C+uK/38sOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730835044; c=relaxed/simple;
	bh=F77iKaVuO5nNNAk/6vtbbfjGmlEkJUbjj4pE1aNyn0o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V/aCK2HBHY9KYoEwrhpCut7LQqrqp0GOTHgfpEHjIaXr5xEfMP6x9kozv/RYpVapu2oR//6B2AITcaOOGHgCFcEOVofT5Ycd1on20QiP+mqBygLdcxmMOiB3UN2F/JQCB2TXGQhR9o/LIu6+lLAEXLWWDd+BCnEBZKEwkqL/chI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NK7tZEGx; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NK7tZEGx"
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e30eca40c44so5284086276.2;
        Tue, 05 Nov 2024 11:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730835042; x=1731439842; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KJuzFWUnz/k8ziEBqxWrk8940BKVfarTKUWT5e1s4Vs=;
        b=NK7tZEGxUsU7bv02XZvhNxa7UAbvacb3+HCFlNX6SP9mZLtDmYOLWzaXsrmEbAtBdg
         puTpUb3j7ND+3sIj3xK/nuRxgbPR+g+glvJGiuzyWvHEjkLXWzu/jJn7ZnBY1HBB5ntg
         IbhXRITxEUZ86wp8mZ4PyEcjc3E8gNyUbOteofB2begXuxGvaZAS6R46kPIYL5UE5v9X
         Q9xSlZobya7rDtU81tQIxJGzAHGx1iynQMHiU00edJN48e7RhD1xnQbq12VlUbRAjLuw
         SiGf7hBFL7nsU7/SnyMUEXg4iw7smNQyznOTl5O6i/BoX3TNp+c9hYNKCMq0RomylPzd
         OENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730835042; x=1731439842;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KJuzFWUnz/k8ziEBqxWrk8940BKVfarTKUWT5e1s4Vs=;
        b=dRXUXzwRjG9oDjLzRtnJjG6OeRkJtLvPcYTBrsVbRNbqwEjdds5nHXD9hpkhzzc+wr
         qFmvoPCns5b8siGYISdVI4GbFj1iZtOZe2uHiSyml9gM/3paFKAf/HTddSLUOuxyIejc
         ESdqRbgXHA/5qE77l9b4e55yBZRdsRxZFs3gtmPUJMZEQFF+1lJetCqGnXfbyg6cwY/r
         2/r0aaQPTHrhGpRescFrPicIDChrHTt54Dae9Z4EpgGYxogNVGXWGf9/x99sjvclcAqV
         HtMbFqSpGM79x0gYGwI+tkiVD91zHvXqYMOcb1vuKsg/74wHgYy3qMwsyTe5K1UVKNV2
         Od6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUD9EXgFSOONIC7s7toc0wHMDBv7LQIZXg7rieDAHgQ5JzU3xRe52+/bdFhJZEWvahZXdKjSDqy@vger.kernel.org, AJvYcCWzpkrAY/VjAWUti9TfPcgQHRgV6ZOWyS5UC2oEp2nskJd41OjcMURU9hxiw3B62rgoVWdzg2o88CGphQ==@vger.kernel.org, AJvYcCXlluCoguLIrXIwY9OX3lf4ULKYK0TAZJ7ucg63znmxYP0DeYSnWGICUofJKE/dZm5hURey36NHLrlX0s8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzL4rutCD/fjO7WzjNITjfPkNAa3dHmO66IZ+Csmiu+vvcJwAy7
	MkppxY8KyEpwaWTsa05U5QpQDbrUO3Zf7txfplDaq8b58smCWMI20rx0uLn4+7v2/dQIlxU7cMY
	iYEFtgSonEwTyNzTwfX6qZiwg700N8jlbYlw=
X-Google-Smtp-Source: AGHT+IGRt9PgOs6K9THyHzaclLBzLxdT2/CqUGYDDBGtGkTOFWcuRTzs0pyzEmB42IH2+xVMWGqqG64zERi9yQsOHqQ=
X-Received: by 2002:a05:690c:7207:b0:6ea:90b6:ab48 with SMTP id
 00721157ae682-6ea90b6ae95mr85072517b3.18.1730835042304; Tue, 05 Nov 2024
 11:30:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105130835.4447-1-chenqiuji666@gmail.com>
In-Reply-To: <20241105130835.4447-1-chenqiuji666@gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Tue, 5 Nov 2024 11:30:36 -0800
Message-ID: <CABPRKS-UAnhSFB5z-LhrQqgXtenyLqVCByaME12LvMNmjVQ4ig@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Fix improper handling of refcount in lpfc_bsg_hba_set_event()
To: Qiu-ji Chen <chenqiuji666@gmail.com>
Cc: Justin Tee <justin.tee@broadcom.com>, james.smart@broadcom.com, 
	dick.kennedy@broadcom.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Qiu-ji,

This patch does not look logically correct.  if (&evt->node =3D=3D
&phba->ct_ev_waiters) evaluates to true, then it is not possible that
(evt->reg_id =3D=3D event_req->ev_reg_id) is also true.

Because if (evt->reg_id =3D=3D event_req->ev_reg_id) evaluates to true, it
means we have found an lpfc_bsg_event of event_req specified interest
and therefore (&evt->node !=3D &phba->ct_ev_waiters) must be true.

Also, following this suggested patch=E2=80=99s logic, if after attempting t=
o
go through the phba->ct_ev_waiters list and the evt->node iterator is
pointing at exactly the phba->ct_ev_waiters head, then this patch=E2=80=99s
kref_put will be for the phba->ct_ev_waiters head which is not a
preallocated lpfc_bsg_event object.  So, this patch would be calling
kref_put on an uninitialized memory region.

Sorry, I cannot acknowledge this patch.

Regards,
Justin
