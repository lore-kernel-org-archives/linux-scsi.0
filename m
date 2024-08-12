Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C16C134AC;
	Mon, 12 Aug 2024 16:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479866; cv=none; b=Jri1iz6nuukdfKvQ6viXt6fjwyLEWc6PRW1Swt32qzY/ff2x+aE79KwmWhgCxk4Um5FxTmnwVP2P8cm4csd4apRHl1nc8ZoYSuvlKlftREFPCg2wOFn3e4kIKnDRA7Gn6qXD6JDxTqEHECyF7rL6zKWy1Eg34yj/KHhC281prKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479866; c=relaxed/simple;
	bh=Xb8NKU5ZkzC22+LAMYn3KWK3B7FtrDPWAeLxD550pFI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oC81hDcVRMa00udK781+8ydmZIyKbYJ18I1kk1UEgfa1LOvIcdBuuWUMAM0wHCiTVNWK/D6CP+wCrM7egp2G3RGDdMgFH80oDPDxIw9oDnT0ExcUZpNz5H9pSum0B3NAktspvtF8OTP33vhZi+JbU+I7wkRUD1xyioJx/eX020g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GUzD7k2T; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GUzD7k2T"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e01a6e5da1fso760299276.0;
        Mon, 12 Aug 2024 09:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723479864; x=1724084664; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m2ut7bEWUwzYOwruzGQ3u23dJf0ifAFUWb+wcbI3n14=;
        b=GUzD7k2TUOF67BS55RzlOmO1OKbWU+RyfxH/+QjrUn48CN86kQnqGMwj2eaQRolo58
         cVCRpI/YEI0TokI1/JxcBQw6y3ZIyzYlnuK8+XsdhPyP9tyY+espgwNtgZXkCE/aVvBa
         6RZPl2Or9K2oO7sCCJ8EUF/rtpDxmo56Qy8ikh2c1mZo7lxYE4ne+or0Ci08ZVe/cYUV
         aJvSSDFCkfTg7IoPptS3/oiFfTNZ713buUG7+klEwjYlgLD7QsMjDJdpaXRKM0OiPc9B
         VYSdEJf815iDpQaEs7wK6v0HYbddKZDPQlMQUal+is1mZMUEfPsnqA+1pUKK8YmiX1MG
         W79A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723479864; x=1724084664;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m2ut7bEWUwzYOwruzGQ3u23dJf0ifAFUWb+wcbI3n14=;
        b=RlsHI8DYcH9kF93B2piMLAZYhsvMzC9RO8+gOCcPDPy6Ka4xjdzbQ7PDuYnOe6xrTR
         VKP86rc4/a7AXoROoBinotDxW8uQ2qtRPdraMHuznEkdXmO8qMXZfDophMR4HZ7laPQ1
         1+Gw+gHaYaWkE/Nter13Dh6Ijlo63VP5pTBOqRbn6/W5F0tAXfeSnV6lPbfojcUpKabb
         kM2o/nNZyDRGbZ1r7e4x24K2JCtmt6kl+wbcQetaSHOTuNSQZt8F6sdQWlz+LQGYv+8P
         SaJDYMb1cAZ+PWYsMOX/uIyNthJFEXdefreT17h23LYF2NggGRLcx0S+TQxrcTAAssQi
         QHaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOAfR/a73kE8KudLHPqloeo/uOtQmYMyxf92qfz1uJePG9C/f1B/vAQKhRJ52GgjQVHF1LWYsTpqgv/fo=@vger.kernel.org, AJvYcCVw8SyalQi0RRzXvZ4m6RzJziFEBsUj8D0tHkRjd1NTsnCxizIxQmmLvcgRNNdPiw8geWvQCuhNBJmdXw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLFu2ZsFeiYMfWKIDlLfTZ+H4K0YErvko5f1eLGDmQhtSqGaZH
	iQ9NpH3C6NkX2rKuspuOxUjsKCN7UiTa19RiGuuug68IfEfJQSieBErLDP5dn7zCvMM5BzzFTDC
	G87+qS1U4EpHogfL3rAZTEpPoR6gHJWAA
X-Google-Smtp-Source: AGHT+IGlUO6df2magGL4Skd5fMDLo8MTD0PlHJ+eAK/NLhxpw9cvZS3pSySJ9AS8IIQitOb1hy3wQFerEAymGHhDfPA=
X-Received: by 2002:a05:6902:1b0f:b0:e0b:3a7d:928d with SMTP id
 3f1490d57ef6-e113ce79b87mr546665276.1.1723479864290; Mon, 12 Aug 2024
 09:24:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240810112307.175333-1-kdipendra88@gmail.com>
In-Reply-To: <20240810112307.175333-1-kdipendra88@gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Mon, 12 Aug 2024 09:24:12 -0700
Message-ID: <CABPRKS9qUmWgTcg3vXEb7JxFCx1n5O7MeeU73LJZAZ0DhGRTaw@mail.gmail.com>
Subject: Re: [PATCH] staging: drivers: scsi: lpfc: Fix warning: Using plain
 integer as NULL pointer in lpfc_init.c
To: Dipendra Khadka <kdipendra88@gmail.com>
Cc: Justin Tee <justin.tee@broadcom.com>, james.smart@broadcom.com, 
	dick.kennedy@broadcom.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dipendra,

Perhaps the branch being referred to is out of date?

This has already been addressed in the following commit.

commit 5860d9fb5622ecd79913ac981403c612f6c8a2d8
Author: Colin Ian King <colin.i.king@gmail.com>
Date:   Sat Sep 25 23:41:13 2021 +0100

    scsi: lpfc: Return NULL rather than a plain 0 integer

    Function lpfc_sli4_perform_vport_cvl() returns a pointer to struct
    lpfc_nodelist so returning a plain 0 integer isn't good practice.  Fix =
this
    by returning a NULL instead.

    Link: https://lore.kernel.org/r/20210925224113.183040-1-colin.king@cano=
nical.com
    Signed-off-by: Colin Ian King <colin.king@canonical.com>
    Signed-off-by: Martin K. Petersen martin.petersen@oracle.com


And, the routine called lpfc_enable_node doesn=E2=80=99t exist anymore.

Regards,
Justin Tee
