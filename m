Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CC23002A4
	for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2025 20:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763498679; cv=none; b=LCA5wA+HGRFySeexJpBgznND9OLQJEdybXTfktTPSVVimmAtDM5ed4jtm9qZ2Nn9+GMOe6VjRIkNHYyXxhMfh2+s5/vx1ke1sXLTHO5N6tBI08OuMtO+ETdG2m7UjO2PI+R5ciu4BF6TB/6pnHo/W4DtsbiNZoGEOS/yZq5buDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763498679; c=relaxed/simple;
	bh=K9fDY6NMyJz2tMJaejTPM0fHnQQgqyXhWuXx9OSlsjU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=CGnRKCZuIL5tY55ff5BDuJbsT0HJLpGr8U9vMwTo3DepWutm2f749aML9L7zWbeCt54PSt40y9GoVxSsXmrn6kYI7VUZghdI9F8vx1uBfno1HrJJejjmaj6XGj8JcMC5KvgC6VjPZUVQrUmBl84T3qpEX61LIkkUFGXflLU8nrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KXbYeAe6; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KXbYeAe6"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-bc0d7255434so3573086a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2025 12:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763498677; x=1764103477; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K9fDY6NMyJz2tMJaejTPM0fHnQQgqyXhWuXx9OSlsjU=;
        b=KXbYeAe6WCoJtBDqjIw+zOxrbJCa2f78RId0at1ZpN4oMqgxO66bR903Ej+6UFXk6H
         lKMIvkOFDuNHIORkRzB7Z05Gm6a+1rur8QKDSWXWa/iWBNPYYjmKcB3OlYZOiE2tTPWu
         332Lkf/XbPlaj+cRzVEQi7NRFaT0msCgGzs6WxhJ9br6rC7gRRPiQBVCfr1XpkvRRcxG
         o/TctE22/H+W+I0CJORLxJmQ6CI0zxP0+MsQEXXZQCE9ae7UkWZdPSb898CobPtD1/lb
         wTxzmVJwsfk8PpLENJZaEY+ssUgsL0v81xclrJgo/BAJocTqR0q7QuVPzfmHqOCuIi7h
         AmNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763498677; x=1764103477;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K9fDY6NMyJz2tMJaejTPM0fHnQQgqyXhWuXx9OSlsjU=;
        b=TXnzo6B/B/4b6aZBYiGqEn7DWovN1FDb2TTjJD19A7DoYd8a36c57utczi+9EV16cx
         mYgrVcNG25Gu6xWuBUoCXKvXp3eqvDBOJcrWzZxkermQ9QjRVbSCQFfMZAFg4B+4VukK
         R2ldUJOe6vxspWQe3yryu3fJG6i+G/jZ5NkZ3+WOJyWrXWjQZXzGSsOsSMuRGxAcxHll
         N1vuje8NFFfmfH5OAa3AGZ+ppU7yFNodkaolBpWpsvc2jmVpTr42LaU19WXTDDcys/v4
         mN4RdLqTSX91bPl0aKa2x22wcQt7PQJ58dG8CO2ag15Wg6p//cgcNcnE8V01sGrhqTXE
         Tybw==
X-Forwarded-Encrypted: i=1; AJvYcCV8F/mD4yUflwE87I3J9Uyf8OOhuYZUYb/MTq0NL0Hvrx3gYlrTXNyJ8U5qNqjfuQrdYPlzNd2FwR8p@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf6m9IKxNqgmG0Yp08fZCfqNxs8z2xtJupMzRHkOgRA7O/K8xu
	goTplLQB5UHYxEZtDM9D7jNA+bj0qocTl956ER8XSJL7H3H/yWJAdaBU
X-Gm-Gg: ASbGncsgzlZs2kpcwQ9wzp7yRdsPXenc6KInVeQ4+tqJcG9g/Z8u3ourcyGAs9OcVfT
	IRr2LrHsfaGCOVYjMSBmPqsP/UfVZrG9U0KXwyEjQK4V5Tiisv7CeSGH2yPqzDfwecJhcutqZYP
	VK8WZdVB+VM0KLOv49dvLM8UZbTDZtX9qyYZfMJrhrZHPlmQkvHHdKeG3m8jviahbsHCI45FdWN
	0V/aGoqf3zrUM4OqlXcP8d8JxQADv6+x98vdK7M7KvcpbwvuXumKqBfnEFeazBI3Ox0EetIW0jM
	3WOnr/Ie+dBtj8p22/J4phDgGwi3p7AlvP6h10qfa7kHP1/zcTkIZFU5Ii8a55kE6mLpwGh5cRw
	oOo26xzTKBtqO4gUoggdS8eU4lRf88I41gXtdLuLGz8c9fcr94JM/OLQ2+mnb0DUySt/N0tHp+I
	6Q8bNSexb1p92bd3zFJar0CWJobH0mBa0CATVpcZKMCBu02gcS3ilv87YfIZjZdpMIgA6c
X-Google-Smtp-Source: AGHT+IH6NXrQRTAgMf2HddEUXn+z5kCzkV+fHB+mI/O4pw1ibW1tSK7SJqGLrmjc/rmo/4swJL7fzQ==
X-Received: by 2002:a05:7022:4414:b0:11b:c0db:a5ea with SMTP id a92af1059eb24-11bc0dba69fmr5632646c88.26.1763498676692;
        Tue, 18 Nov 2025 12:44:36 -0800 (PST)
Received: from smtpclient.apple (c-24-5-244-16.hsd1.ca.comcast.net. [24.5.244.16])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a49d9ead79sm79567854eec.1.2025.11.18.12.44.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Nov 2025 12:44:35 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH] scsi: qla2xxx: Fix improper freeing of purex item
From: himanshu Madhani <hmadhani2024@gmail.com>
In-Reply-To: <20251113151246.762510-1-zilin@seu.edu.cn>
Date: Tue, 18 Nov 2025 12:44:24 -0800
Cc: njavali@marvell.com,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James.Bottomley@hansenpartnership.com" <James.Bottomley@HansenPartnership.com>,
 martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 jianhao.xu@seu.edu.cn
Content-Transfer-Encoding: quoted-printable
Message-Id: <45878638-8A5A-46E0-9223-BDDAD0C89362@gmail.com>
References: <20251113151246.762510-1-zilin@seu.edu.cn>
To: Zilin Guan <zilin@seu.edu.cn>
X-Mailer: Apple Mail (2.3864.200.81.1.6)



> On Nov 13, 2025, at 7:12=E2=80=AFAM, Zilin Guan <zilin@seu.edu.cn> =
wrote:
>=20
> In qla2xxx_process_purls_iocb(), an item is allocated via
> qla27xx_copy_multiple_pkt(), which internally calls
> qla24xx_alloc_purex_item().
>=20
> The qla24xx_alloc_purex_item() function may return a pre-allocated =
item
> from a per-adapter pool for small allocations, instead of dynamically
> allocating memory with kzalloc().
>=20
> An error handling path in qla2xxx_process_purls_iocb() incorrectly =
uses
> kfree() to release the item. If the item was from the pre-allocated =
pool,
> calling kfree() on it is a bug that can lead to memory corruption.
>=20
> Fix this by using the correct deallocation function,
> qla24xx_free_purex_item(), which properly handles both dynamically
> allocated and pre-allocated items.
>=20
> Fixes: 875386b988578 ("scsi: qla2xxx: Add Unsolicited LS Request and =
Response Support for NVMe")
> Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
> ---
> drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c =
b/drivers/scsi/qla2xxx/qla_nvme.c
> index 316594aa40cc..42eb65a62f1f 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -1292,7 +1292,7 @@ void qla2xxx_process_purls_iocb(void **pkt, =
struct rsp_que **rsp)
> a.reason =3D FCNVME_RJT_RC_LOGIC;
> a.explanation =3D FCNVME_RJT_EXP_NONE;
> xmt_reject =3D true;
> - kfree(item);
> + qla24xx_free_purex_item(item);
> goto out;
> }
>=20
> --=20
> 2.34.1
>=20
>=20
Looks Good.=20

Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com =
<mailto:hmadhani2024@gmail.com>>=
