Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794730808;
	b=oH3qibC9WExXgPCUn36c+B0w+BiqywCrXRwMcroT02JRlhGucVDvTNbECNLrkLlDo2Z3
	 IpGdjyXE6LjbB7Hwqh1QmbLUu/dWoBTEvlZaBxaHtijt+nLzogwEU3dPV114XUHGljDuY
	 OnDgKxo18h1O9RWfsWIxLMIFwefTxH5fmw4jiUbmG5CCCdBCFyuC4+XSVMN7SE8+IWBCq
	 HYtNlytXY7yA7BNOunuAye0DLCkdiYJv3bitvmERs9BN9h5usE/2bcw1avIj8ntWwEJOn
	 o0gDkfrDdvUk6HPULDzQt4RPahMJaCPORj61/jkRGEkU0shrvpibeQahAIBWHel25QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794730808;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:In-Reply-To:Mime-Version:References:
	 Message-ID:Date:Subject:From:To:Cc:Content-Type;
	bh=cvkRQ9vTEHp2sTanBdWux8S9LLOQ1dWCdfqy76FCS9s=;
	b=CT4CK7XtLy9jFbX0recbHZ0PYGaJVo2AuRXSeK9XBYA0Zc/1Ag2T7we1PlrDSzSBWukZ
	 hAEroQF+FHauVTggqOnt9l5E20cS0ilW2u5EF8aLuy4sVN7McWsdzsYeq6dnjLJ2uh90/
	 TyenaXP9/q2an/pdApAtbYWc85vVm69C3wgJsbrm4kqnOYgk8I0a2Ft5tLz7D8RELnm7n
	 rf9B2hxFgthLUtN8nmCOnazuHRBPuDajaD/RmNn4rbNfy7vegZYaTcvjPiTvYDZnzg/Op
	 D+H9HFCjhZ23hlwQIFitEdcQ8N5cn/hGKbkLCiowhH5egNjcpRtG1AzyB6diARoNq6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=C0LwxZF6;
	arc=none smtp.remote-ip=209.85.214.198
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6BA606A327
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 08:20:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A6BA606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=C0LwxZF6
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ed08be1c84so38341205ad.3
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 00:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794730807; x=1795335607; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:date:message-id:references
         :mime-version:in-reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cvkRQ9vTEHp2sTanBdWux8S9LLOQ1dWCdfqy76FCS9s=;
        b=C0LwxZF6+BFl6wgUmpOceGqyxcXU3fj+WC5/Cgs6h9OMxjU5KJcHmONuMZv7DiZX5Z
         7ouvr9YUsPYgzxkRzA4mIrwal94AZW2LseWerMZqopLEsTqxJzI1UcZB+T9yluKFSTPm
         UEEy8X68/7sEeMFquUJJm96w1//g2IJMsevD+D+aZdmp+7KT/om3YmAI7ZOYWW7CagS4
         bRb+DkO7jzmcyMQmeL0KlKD5HBmRDBaf5Ebid8numYxRfknjg6YjPuOKNUY9sQNBMb+n
         hxcLz9/8jxxWvwXJ/40Mp+TsPK1oQ1QoZkCToeA3YpNdmyNot8c1LKjDn5nUgsEFsssG
         CkqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794730807; x=1795335607;
        h=content-type:cc:to:from:subject:date:message-id:references
         :mime-version:in-reply-to:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cvkRQ9vTEHp2sTanBdWux8S9LLOQ1dWCdfqy76FCS9s=;
        b=BfBCXjr5qY/68vSVbvZob+KTOHOk4IXccP48zs6dVs21TGvVv4lFArEdCs8Fxkc+yb
         tn37UnJCGpNHYRuLvZrRSkP2jM3xblMo8w4YLXDdulpfmHFjwL4sJc6NKbm/FAf7b26p
         Fce4ontON0MoJKUEjXRW98eXiO6LQduT6I52K1caUogkBWhv70iKxIQMbxKkAfUargeY
         yvqVyVANmT9Lfe+Tm84766dqnt7xNxfx2nmIknOpzBsFh9P9O1pgjkiXZQGp+k9OwbM0
         BMSfU8mhgTyOiePD2pVkCEbiTo02Kkf4RWsqQy00u66hAop2LY8bOeZ/o+j7Y7FIAVP5
         xxIQ==
X-Gm-Message-State: APuU4Z+voZe/coVdRclyE1c9abLDtVBRaDvcFbNVT5DygiXYe/Ww509Q
	keWBHx3wCq8KWRB1gLjU1Y8xPefseN2xRNRUcaDuxclGgety256OUuplmO0k5n2nksjWoI+aU2e
	PBcoK+DEQFsjWr3vxLxLP7g==
X-Received: from plhn3.prod.google.com ([2002:a17:903:1103:b0:2ee:20a7:da27])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2281:b0:2e9:55fc:ded2 with SMTP id d9443c01a7336-2ee0dec63demr78859485ad.52.1794730807271;
 Sun, 15 Nov 2026 00:20:07 -0800 (PST)
In-Reply-To: <99108d6b-ce90-4008-85bf-fef12204faef@acm.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261113111202.3551341-1-stanleyjhu@google.com>
 <20261113111202.3551341-2-stanleyjhu@google.com> <99108d6b-ce90-4008-85bf-fef12204faef@acm.org>
Message-ID: <18e82a2906bde9db.3137322e31362e3131332e313435.7ae79.0000sendgmr@google.com>
Date: Sun, 15 Nov 2026 08:20:07 +0000
Subject: Re: [PATCH v2 1/2] scsi: ufs: core: Recover link in
 ufshcd_set_dev_pwr_mode() on timeout
From: Stanley Jhu <stanleyjhu@google.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>, 
	Peter Wang <peter.wang@mediatek.com>, Brian Kao <powenkao@google.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	Hongjie Fang <hongjiefang@asrmicro.com>, Praveen Talari <praveen.talari@oss.qualcomm.com>, 
	Hoyoung Seo <hy50.seo@samsung.com>, John Garry <john.garry@linux.dev>, 
	Hyeoncheol Jeong <hyenc.jeong@samsung.com>, Jens Axboe <axboe@kernel.dk>, 
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

On 11/13/26 12:37 PM, Bart Van Assche wrote:
> One change per patch please.

Agreed. I tried to fix too much in one go. I will split this up
and address it step by step. Please drop this version for now.

Thanks,
Stanley
