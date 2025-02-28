Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7057F182;
	Fri, 28 Feb 2025 00:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740701284; cv=none; b=L75UdoCCPKxN8hcgDEu6oFEXWH7C4JZMpjUn6gGbzbqiJTcaottS9cD4njw8kr1Zp0oitqz3oQUG4Y3InlWkpb+DevIgfQXnmN8GwpZVrl26LZkkqzXqShVPvvk0oDeQy9PrddEeAMbqRMxtel7jUz7s7eSC7BUSi+DWDRbB20Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740701284; c=relaxed/simple;
	bh=jUEZoOE+I/HL6qmkqpRxBAW840EWU6rM2MCD09k8aQI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J9BXJStMwgOTaExmYCIkHVnrSwdQjv0U8LSGnK5103yK4fl2k6PIKGshwC03r712ieCRUzWr2pqXp6AM+iMKVHUY+LGgbR1leLkjwdJeN41kU90HpfWQ2yjJETs4F6Szn/bv0Mg7Od/THbnmRU5o4FAYemrLvaUISiOc/h9nJ5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fS9KUTfS; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fS9KUTfS"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e53c9035003so1201620276.2;
        Thu, 27 Feb 2025 16:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740701282; x=1741306082; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jUEZoOE+I/HL6qmkqpRxBAW840EWU6rM2MCD09k8aQI=;
        b=fS9KUTfS5FoJ6QY9Gpjw/Bjf2dXuC8UPlucAmaNgEO10HCmi07RS+n6qunPmJIRsNn
         ZXYgYMz9LKob5oA1CZgk1yKj2jCZVXoksOyrccaYHhmAcGymTwQ26UYbhtaXN0Je+BpY
         5EJUDR8LS9+k5Q7YID6cq6Qj672weyoeSHWq2JPr90ozo/c2lKs2GuNuaFvQaJpAIw6R
         MTgfE30qDFft7wXJIuvvhfbuAiIxAYKe7avPkmFaXJSJ1/xY1YkH17z56YGfyM6BptHM
         6okSKXssVkDQRKFPmAaFfKIOr0oahFYR9K5c7HQv+jzFhrUCTnpkb/716uex5GgInWWG
         M4Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740701282; x=1741306082;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jUEZoOE+I/HL6qmkqpRxBAW840EWU6rM2MCD09k8aQI=;
        b=MW0VJMO+X8IWGqMNQBFEiU1wJTelKWyyy0rUEQ8t5G11AN7FcqDtifndqfmH0mSor1
         nG2hU1QDu6zG4SqH/Ypn5rQYTyAqx86y6VABS3HP673AT5SLpo+kpnVdHJwi4gYXLRtT
         JTrhYsq8rq3FnyZNXPrYJLg/Y5d0c06KxQnIhWqtdtJkKmOfzNSiGO92kHu01O5Per/d
         zBMGKvnzAhSk6eIf0iVJ8Hz/R+S4a87Qcg1QApQb2NfFKEcrFd/KZ96oZ3Aazgk51Qhm
         iTHSArIcvRWeVgw57j0B2b9P1IFkzX6z0yqipUByG6mc2fN2b5wwtq+9JehVE5f3AoEd
         soEg==
X-Forwarded-Encrypted: i=1; AJvYcCWCL7jV5lWjDKmt01ZFVvFZQpsaN9xMeehVbg2AL0UDT8JbOIK0HI3LqXoDQipMDHqSrTO4hyNMtVY9csykgJg=@vger.kernel.org, AJvYcCWLcwo17Q+mcFofW4rysfGMb1faG0Tt37AJPxLOhB8EfBa5OqQJjxz7swK8eA0xrFBcgSWSbh9/k620XQ==@vger.kernel.org, AJvYcCXRZvKuTxv0EDCECikTuPJyhcZd4etiKOC9j1YLTa5oiKGGW7SgXa5Myu03otGB7mPiF9qvCLQVJ0lFDKp2@vger.kernel.org
X-Gm-Message-State: AOJu0YyFYxIRyLdZGzA18zcdJlZTZaZhB9rCS03Jfh+dLe3g5kdtwcwE
	hElUdGrzO2MT31XSVDbUg2E6FcYfS+P0txQGBlHgu1D1CVpR6lrZG+uvrFtW0tNg+VuOS3lYbIp
	LwOki8zTvlJ9Y9fQQ2N0thy1ZTvfdAU68
X-Gm-Gg: ASbGncs83AWGWz4ic5p16yAlUbYpUNamavmeAl4mTJ9mGpHXR7AXX3Shcyl1WJmRS0W
	XnC63zzyphTNrtypiBu4g1MOvhXKvt9fB7cZtnIc0uJrWJLPzb1r3B5hL9OrQrg0EYJuuDnYx2S
	6iN2Z4iCzG
X-Google-Smtp-Source: AGHT+IGEhr/ZHicSGTtEZuhJ6N3SlIjOb86zqjKxfzWPrTvqCQ+fJHYyCtXANdyhaVHo3KkaXMpGjOTZqO4d64PrQNs=
X-Received: by 2002:a05:6902:2745:b0:e60:b17c:4252 with SMTP id
 3f1490d57ef6-e60b2f2ec28mr1572454276.44.1740701282378; Thu, 27 Feb 2025
 16:08:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250227225046.660865-1-colin.i.king@gmail.com>
In-Reply-To: <20250227225046.660865-1-colin.i.king@gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Thu, 27 Feb 2025 16:06:58 -0800
X-Gm-Features: AQ5f1JqUtukwNG-_koyH808F6r_s3Zf95w-09IXYBwR0i-b82eV5Oszn61Fuqls
Message-ID: <CABPRKS_WubBn_1wN+bKi+xEHw02ankvzx3FBzpbafmxPb8AGAA@mail.gmail.com>
Subject: Re: [PATCH][next] scsi: lpfc: Fix spelling mistake "Toplogy" -> "Topology"
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Justin Tee <justin.tee@broadcom.com>, James Smart <james.smart@broadcom.com>, 
	Dick Kennedy <dick.kennedy@broadcom.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, 
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Thanks looks fine.

Regards,
Justin
