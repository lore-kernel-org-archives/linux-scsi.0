Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBFA30C60F
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 03:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789096032; cv=pass; b=K2qrAvYUMs6e+bbDz1xcuCaLVfvpMvIuq7+UrRuwo9gBOlXi6fyqLq4yLprFN7ghklfofOiE4nVzxu74mAKnVhggxJRg0ELbDLRq/LZYwhyKn1DvpdIgbxLsatVyIsCzPBAXM6arbPpndkDbAetv+46cIxtIF4TkgJKHgYjdwf4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789096032; c=relaxed/simple;
	bh=7YpjTMZ2QI0IbVGmdUp2u8RAmsfuAu6AIfCkQhbsxOI=;
	h=In-Reply-To:References:MIME-Version:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XNc7v/MWMAE/5ferhEGJKxMGN0zkMDww5X8AIRzcUxKmTmbP0CDd7gV/hNZmCy6+oWoDhNUfsKcVq/iFDf/IHrX5Sw/J+157nVUMsMx8AAO5pMbOuPUef8eHXqkW4JngGgf9Q9DhMSG5r79CxFClgEABpIenyD8uzEDGgs4bgVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i9/4D5Ln; arc=pass smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i9/4D5Ln"
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-5306706e89dso96491cf.1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 20:07:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789096029; cv=none;
        d=google.com; s=arc-20260327;
        b=pRAq5MTF7LXoHZ4mNitfCLWrXuC4ppbO9YyWB50zBL9CtCqb9A8VCThisRJSxsZ67H
         VU+9vXfW1F8C9SkEEgFhufFZ4CnI3C5XL+NjlmciHir0w3ZyCGdLhl/vTW/2sReMXrmt
         4D389ebzLdPyBAmIKQb9SNJlRIp3l/Hat7+le6/4GmrH6I5/EMINcpfYPUuIU7W7bLRB
         +JAwc99PVjwEuQTuWO7KZh6nxS0SRtkb4BX8C7xuo18yLVTEVUnrGqdDgrzLTigB8fY8
         aFQ2DC7uQAGBs2sZIlirgbti78qcbAXmp4ZTZ4dWYcl14SuD2GZlZg+GIzeUp/S6Fajy
         tN/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:dkim-signature;
        bh=bDh5ONxXoLGgcC48Bw6+gTgGOoDGbpRlA0yd2r0cnZ8=;
        fh=pktdCiyIxDkgL91HwpEWFAUFZz9wLyUctUcJ/zYSJtU=;
        b=HURCH5U5l8na9Ns4MnIJDeZsBxu6A4WxFvM/mgLPOv0s3vmsgj10BA73iEzz6efA4I
         Grx0tAd2j9E74KYiYFbrJL3QLQvzoUgTZMXMog5wtlAw9Z/BJVgaMb3AK3+zmeiYgzgM
         p5DdAgJDZ7JqoT2x3bn59ZRS7DBjRUm54ZJik0INbDeevttEd3Y2Bh9WAZtjcMpAZRsM
         xM2FVlczD7c46nMh92IeN/OOgRAgY7bJkMVYz7KX0d1KI51hIoiD2C+Kwleih/AfAk+z
         6Z3B6R7sHaV8vowXRK7cVfrb4pLC5OypJlLudo3klt8Rz6zz7UnVOZco4UJ1Pi87jAMs
         QCPQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789096029; x=1789700829; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bDh5ONxXoLGgcC48Bw6+gTgGOoDGbpRlA0yd2r0cnZ8=;
        b=i9/4D5LncpBs+ZpZkWeItUido0GTOXffyYgn3MfN/BvwS5TAfAmwmiYbejUcJaUG/u
         /o2ZuB+8AbEBDu/PeBqPewx9O5U6sR0cdERT0R4NcJD86QpbKuYLRQfrOW0w4dxHevgU
         0YJqVriUN4PuJNXsukueKEjvKDyJs6rctKdIti/ayFQfqVyyszMKLLuFpaIWlRJK4ywY
         nYB1W9MBS19vmb+aXsaBPjvzV58YZZD506IuvDrMQ/9cJJnXBj8gvwRqxMl1S+1e1ZpY
         tFUzJ47WgnWtCknw7TGJFhMweT7NltajipLbxIxIaRoZM98GWwpBBYhh4ATlinuOfjAr
         NbRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789096029; x=1789700829;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bDh5ONxXoLGgcC48Bw6+gTgGOoDGbpRlA0yd2r0cnZ8=;
        b=JIb2+k6cHxRfXPoLLU9F0tP02A3hA32L25CQTrGzJi2rk/GvaQRYNGTZvSiqhvONxr
         KXGsyRe9ECYKtjLpjXhB/vDBwTCRQzFjXfvM/OtWu7t/g8VB9EWmw0Li5Ky9TpBmFxaT
         BtPQ30qQyu0CjJPFd62MXal3r0hJPBsUY2pZK2GlGARh8O2juWBNTWQWH4JxkKZEwcSl
         GxnSRbWpvMZ312bFRO4lqNBU/BOA6YYMS5SP2MnxtFJzhQ1IU8xQTg0rlLytsH5vj9Ui
         +TO5seRITyxO8Dg6Jva6+zqI0/UUeW+qhffyt5YGRktM7kY1m7/MRv7G28uiMfbyjOQi
         O+mw==
X-Gm-Message-State: AFuF++mdfBPk48uJOxP/wgpCKZ7Gko5f28DB7tg7u4SQpEkTd4TOq/4M
	sNi5V/+Ud5AgLFp5ySIiwm3M5Qy0UVm1kaAzHu/g47vphy0+xfRuq2uSxjAge51MyE0ijGv7ENX
	lODEKcN8S6nX1k5FEYElHTI3J7lTi0Fc1h15JAWMi
X-Gm-Gg: AYBFou3mIYxGscdTKRCMNkT93w17xO5UeNUC57J9oYbX3C9T1e8xQ63iSgmv4NN2yv0
	bTVCjX2I9hOV4+wbxTewi5AHtrqyjI9mV83uFvLu6Uj6RvQOfsa+edkN49Tu88EajtUyERc6E0F
	yX06GdqDAAQTj1yQ33wObLqvOzI01oNe5yKhHjKy3sLlo2KLShwZEI7d1LYDcCl3hsoTTMg+vuK
	8PHTDk7zBra9HmLlYLX/zcScxP9ilrM9+hlb8cCiH+trKqG/1769OOTjLGWRvudU1SlR4rcPsOd
	p6MsFljf0pybk6WgahYI8KGvdun5dNdwJWBqjVhJizD6zfbfCTlTjRrH72mBvXzZL0+Fjku8AW9
	JDiHVHoY=
X-Received: by 2002:a05:622a:418f:b0:530:4cc8:b0b8 with SMTP id
 d75a77b69052e-530c90b0c54mr13121281cf.0.1789096028923; Thu, 10 Sep 2026
 20:07:08 -0700 (PDT)
Received: from 913411032810 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 10 Sep 2026 22:07:08 -0500
Received: from 913411032810 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 10 Sep 2026 22:05:27 -0500
In-Reply-To: <20260910-kioxia-ufs4-fix-v1-1-ac796423057a@radxa.com>
References: <20260910-kioxia-ufs4-fix-v1-1-ac796423057a@radxa.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Stanley Jhu <stanleyjhu@google.com>
Date: Thu, 10 Sep 2026 22:07:08 -0500
X-Gm-Features: AcwNN1XbLyOMi557vjzoWiN2OPWNa_S2KFjozFqou_AOT6NoGdyvMlpGzBQWBTE
Message-ID: <CAE14pddvwycWnGNd_VNTzphsDTk+XbYwf6BDFkBnQFaw9hm7+w@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Disable timestamp for Kioxia THGJFJT2T85BAT0A
To: Xilin Wu <sophon@radxa.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Stanley Jhu <stanleyjhu@google.com>

> ufshcd_dev_cmd_completion: unexpected response in Query RSP: fd

0xFD is QUERY_RESULT_INVALID_IDN. JESD220F has a device answer that
when an optional IDN is not implemented, so the device is declining
qTimestamp rather than failing on it, and the condition can be
recognised at runtime instead of by model. This is the third model
needing an entry for the quirk.

I have sent a series that decodes 0xFD as -EOPNOTSUPP and disables the
timestamp write on that basis:

  https://lore.kernel.org/linux-scsi/20260911024319.1346706-1-stanleyjhu@google.com/

It does not conflict with this patch; the quirk still skips the first
query. If the part is handy, could you try the series without your
quirk entry and check whether the errors stop? I have no such device
here.

Thanks,
Stanley
