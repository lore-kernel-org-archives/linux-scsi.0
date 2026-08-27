Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C8F347FCD
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 21:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787867072; cv=pass; b=YVmMyMMXz5x9KzgGgzfDX255HE8x3sHsqcy28yETlukm/64C+v5+MMf6saSb6EmR4ZPM0xSUkTYy8DkMEJQwjYb901H8ShnQ6cx5A5kKGjYc4Pb1uunIU5iMYZGFHrOapWkrCqxsenFmafEjEmd98GZKRSbD4eao2oZFZ9eIcSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787867072; c=relaxed/simple;
	bh=0sBuqucNWMJ3PQ7mkm0GStLfwt7hAbIgMaO5tBFyaUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E23NQOYbajELZfTsc0EzNWutOHGqDiRfOPoO8W/6XuJw0lRL8/Jm/k1ID2eQA+ksKgixrWCYBj8TSlO72yN9wvhgBKGlWLfaKddtaxS5M1+v5dLEKdI+giIsv+klgGaHkqS1eKu25/NUH/wLo6n5yGCLxBc8LzMcp6HG9WsGcT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ZTrSBDI+; arc=pass smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ZTrSBDI+"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-43ce24c4978so45768fac.1
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 14:44:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787867069; cv=none;
        d=google.com; s=arc-20260327;
        b=BEUs9072hWLEGoh/TdMuRtXrxcVHrGvaNOdX+KSFOd4DRwp0SP95g0JqzfgCYNMv7y
         bD2M5kH3UJqnlujQ/eQC5t8pOHlzXFC7iCndoucrbFA9Wcgd266u4k3+7misnulHR8gL
         K7iubpRrxYVuSKlRxfNSJ4h4vepmWFQbJN6YwFmaMTqj5Hk/jvkswF10iPlrbjsQYGLg
         8emeKJ1BolLyp9Xf9S7dd1rPlWPnMqtHUS3h4Kmy4dl6ncDySAtKoGcAQumNo6zgnC5G
         optfFCpCsQidsMKkHqnU662ZlWiM4inul3wA833eceLgqC4ofDOjFlYYPGFV9Pk40dWI
         MR0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kqBamkmhnxpQu01OYVCgjjVqjgGXsL5/W693jooZv34=;
        fh=okqodYan5/CP1lxuKkFzcd2+ACaJMzbo5FBx9VdCqMQ=;
        b=DXHzu+RQ6RBXqLW04/4hulFgS1bOAt0vO//piuP6NOV0AbFdQGyiJP/RD+ZafdGmzj
         ZUuOsMWNyx09DZrQ1YoETK13RNLGTEtYgHmgUTJLvG7mpaKf98d5ikayK1fc4XVP/5S1
         1ZkrmEA0y6up0qd5gYqlBZK4MJglZ44pHA20/R60ncWOaNcLsFbqR++URzlpvMB+PpXu
         7NoIxBx+v9VizrF8Lh7pgkPqiOTzRWAMB4N8VyolpHh422hMNRCT53rK7Bimj0UUhi4b
         a4oQyBOvTLzt7uUL01g4ENc9mo9V1SigUgJWvYdR4JvF6vEPKn2iI7++/wOVC38dvxle
         Wt9Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1787867069; x=1788471869; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kqBamkmhnxpQu01OYVCgjjVqjgGXsL5/W693jooZv34=;
        b=ZTrSBDI+mPv6N+9HPOoOcSbhmUkUBhPzXdGsbf4IcAnGI0Glqh1gi6UK5sJn1/UOuI
         5WmYrDNdNGftOFB6sL0MsoG/GkrMAQOqk/tokMVid4ixJn1zODd/o8mkwRCF+4s5Mx7n
         hzC5Rcnw9GFjAl5mx4JAznYgPZlfoPtUtQefmpUgYVySl+64X0J9WDaZpDg1K40kLxFw
         dRzkW1d/qKFjpgUkbllKjyQtj5tGs943l6r+mg6H+DoHnElbM1F3AcDi9+ZLC8pX+3hg
         PbdqhPbq9qlvZ9qS4MO7t8+5PpUTFYv7xwC7k48XRi0qLhUD2tMajDDlzIUqlsjJ9Bdx
         NVJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787867069; x=1788471869;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kqBamkmhnxpQu01OYVCgjjVqjgGXsL5/W693jooZv34=;
        b=QTFwvJ3CCrjidDUUKsCEIFxumqNZdacE/XEGyn0PglWNA0rofRDGR/NnG6yDMeAnNM
         UhSLVIBdmIAaa2Hp7YiD8qhd8oajhWPa69vX8keB/ZYcSrk6hwsTxOFBKaKEmPYHSvoR
         k7y7tAGk/98PQIyl8Vog2YzTnWeS9MFGBypyCmuvv4WxNkolQZNWIp7Y4ZrFwiTVW6On
         XAz62LDD7w1WTX1D+GBcRiqZ5CqNv2S+EpPU9dHRlYTErfiJylgikoViV2vcWReDirS9
         gKMVnzg45W1YGDdxa2C5eP1JJlfWlGgJ6ZNrxLv6CfROlEVi+TPa5UJVkf4nMi6C/LJ+
         Kjjw==
X-Forwarded-Encrypted: i=1; AHgh+Rpjwo3uY+5Ard1JMdG8YbGwdo/KGE0bqBHBoCIVKmX4CNs/jmqHTZxI+uCJ2nAbpUoOY/FMLtb3KMU5@vger.kernel.org
X-Gm-Message-State: AFuF++nkCfomTh70kyPomeQB/VdzO+ZYLvCtsuM2WJRw5OyHKCQ+qWaQ
	lI/Pv0IpLasQ8R96Jw5Ri2Qxe4kfqfc+gvXPMTCvPm8INZ/XH+SX79v6iMqYPPBM1h2qJMZ0N9G
	qC6Bg/z5vEVOdoYsXuW7eNZ3ucBoR5yKQjnc3+yJFsg==
X-Gm-Gg: AR+sD10Cy/cSyUr0/EVhWHEoC16cRvABisHwwD3WjEkX+0/ZlLoaERREEZ1b+F2Pkq0
	DSPhu4kyXI8I2ib2P2DrI1bIlLxzloit9SL6+wM4NlDed+DIe8QMKr1r5IqMTgani1Jlo3uka/l
	MxDVhajQCjcRwZ8i+Baa90HtRMkqJFOnojRVq7ekQ+B/cAP5X5SnnTXZ6fpPmCw4cxmQC/srdbo
	Esf/l+jIGauA08hCkawHt9dvdrFZVnHRRhiDnG+aUvjgYwHz2qISNMonb+tcyYtBsrLHpgf2gMd
	z+jqxw99xThqUgavFUQ3ZV2pBiAPeerRVpKhUM6V5QuTuA==
X-Received: by 2002:a05:6870:45a0:b0:42e:7e04:e9ce with SMTP id
 586e51a60fabf-468328882d8mr1702119fac.0.1787867069273; Thu, 27 Aug 2026
 14:44:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260827185722.3234622-1-csander@purestorage.com>
 <20260827185722.3234622-2-csander@purestorage.com> <CAJnrk1YfTg-Lz+TmM+c=Asc8N4QGuY9_g8zUXtaNr4O7hG1Djw@mail.gmail.com>
In-Reply-To: <CAJnrk1YfTg-Lz+TmM+c=Asc8N4QGuY9_g8zUXtaNr4O7hG1Djw@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 27 Aug 2026 14:44:18 -0700
X-Gm-Features: AcwNN1UylVUquZ8opNqZqu3tNIHriO6d1S55vB3s5Iygu5DbEGaADAEUlDBXhJo
Message-ID: <CADUfDZoEosgMMQ47BDWBskTOZrYZpg6VUT5c4kwczDLRLXYk=Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] io_uring/cmd: split io_uring_cmd_set_res() from io_uring_cmd_done()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <tom.leiming@gmail.com>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Bernd Schubert <bernd@bsbernd.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, fuse-devel@lists.linux.dev, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2026 at 1:05=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Hi Caleb,
>
> On Thu, Aug 27, 2026 at 11:57=E2=80=AFAM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
> >
> > In preparation for setting the io_uring NVMe passthru CQE results from
> > the blk-mq request completion rather than the task work callback, split
> > out functions io_uring_cmd_set_res{,32}() from io_uring_cmd_done{,32}()=
.
> > This allows io_uring_cmd_done{,32}() and __io_uring_cmd_done() to be
> > consolidated into a single CQE-size-agnostic function with 3 fewer
> > arguments than __io_uring_cmd_done().
> >
>
> The conversion looks logically correct to me but the interface feels a
> bit annoying / fragile on the caller side.
>
> Is there a way nvme can get what it needs without changing the other
> callers? Would it work to just keep the existing
> io_uring_cmd_done{,32}() as is and add a separate API for special
> callers like nvme, eg:
>
>   void io_uring_cmd_set_res32(struct io_uring_cmd *cmd, s32 ret, u64 res2=
);
>   void __io_uring_cmd_done(struct io_uring_cmd *cmd, unsigned issue_flags=
);
>
> where io_uring_cmd_done{,32} would then just be inline wrappers over
> those? afaict, then only the nvme callsite would have to change and
> fuse, btrfs, block, ublk, and scsi_bsg could just stay as is. Do you
> think something like that makes sense to do?

Sure, sounds fine to me. Thanks for taking a look.

Best,
Caleb
