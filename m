Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80DC2EC0AA
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 18:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769537037; cv=none; b=VjyFqitXCkaYqKkNEC2EDQ+Oa91iQ1WgX9+71mS/eZ8gryInsLeAHcw2MaR+MK2tX+EDbjwo76aiUMPTV/QtADIYGWckshigM0VppPKqyPh1GGEzwpjaSb1c5on5TV6ftinNmruUJYJdsb3IGYVW4vYWCPbZx25kgZZirl1Xx0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769537037; c=relaxed/simple;
	bh=PaYS45mgcByiPEFKsFUr7GpvQrXjsdkBjJYrXKyAauc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dAOhVdnbjsrx43OF4Ggczp3GSHqeu5fvsG59uXx/xTMn4x1l4JSDFX/gIp+y8aTt9SnKdo8CDU5hKmQxogPqkpBSKiozAbhbJhiNhBtJXJOLcgqH1nJtRVGyxr1KNZHPlq75BgNcMIbxqHBvEFyBAUVfeP5eg6dMgMem8OavMXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=WYZwojb1; arc=none smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="WYZwojb1"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-649523de905so147579d50.1
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 10:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1769537034; x=1770141834; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PaYS45mgcByiPEFKsFUr7GpvQrXjsdkBjJYrXKyAauc=;
        b=WYZwojb1GRGHLjgA80J99/Eafib/dgVxKDW3UbVQskFwMf8BPxUmHf9IO1YdTB5NLR
         u3SriWq5SBaGHbY5Q4M7OdfX0B0S6E4eEaBuO2Fa62Qej1E3TgBiVRZSvLmdh+AphKCT
         m70itLb7N4kzFk73d8uEleLJGgg+8Iqi5PidROrLh+DMIP+j4R8a8DOCOcdUJEt68xiD
         0M84s5UpcGN/gEaANUPcK3x0Tg9ZYQ+y6RdF8ageZePFYIUesyr9uuqAlRKhRlzmE56i
         BAfkyaFzYMHoH1DGzjnrRO9VWxdPUeJ1Yd2EKPX0FE6biy0fSWoUenHQkI0P/l2vhMZH
         URVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769537034; x=1770141834;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PaYS45mgcByiPEFKsFUr7GpvQrXjsdkBjJYrXKyAauc=;
        b=bjLaFbdBN5gNiXSr2mTTYvug6PzdKQO3NGzDr3ktAaTKyyaZPKKjdRvDkt0Nsmb9v6
         jvdRL2v4y+usRZFyQjtbPp246/Vqqs21L7TQf6+Jfs79kRZTMPkMfvj+3eVJ74AQFy0T
         /SXjXJ4s0Q562WDru7JoD/sBwdB+OPH01BBROOZATL1RjDLmzrFTAhCUBXVhEItUbq6z
         /ApxefIlSdoTIQQSJsI19SEdz6zw6BUOms2UItGQFW6xGTJOZLKgZOsjQsMMPIzYXkq3
         3ri0ry90qYLseflhPKv26htn4uOVZK5uIZDxeTg8JlfgJooDNUo2sckEVPcZ0PNdv0Mq
         OKgg==
X-Forwarded-Encrypted: i=1; AJvYcCWN9jej8FYsa7ucjTKOcWytVQjRWK1GjGwW5nPOt4vIILwxbuieLxpmA86wyG/T+Y8z6f9urlmm/DKb@vger.kernel.org
X-Gm-Message-State: AOJu0YzUnTJAJUpfNKxMPrBsinxZhHbJ0wXs2XgP9967pZN7zFq/Nv3X
	rWAlNOjOJr3eHOxlxWVY36f9YA8E6jm9YGvcQyflrAfqv81srzXdFsZ++LvekA7BFOfQOcltt3b
	QPRyY0uc=
X-Gm-Gg: AZuq6aKvgyHOnZ21APYRcr+w9BEpD0i4X9kV/CpJrLBQb36+iBzNv6q++1Vxfez5IQr
	Utgv+DHZ9DdMPqVYpU33ngQsaWVGJalBldHoBIYxbhxogQvCTLvbWWz0a5l95SzlAAoTgmC20H1
	6J23izmGJENiPjYDf/rDRh4M39YXBKjK54BMX9rWYPG48qSqZvddaskra2P7QIbaVAlPCO9eSrO
	LNi9eh6tXUEqPrx+6aiTsMtGDABOn0Rq3oy9D4+lGdUC0Zxid8B9OX+wxv49Xyn7SZ0D7IUjWqO
	Sx78QjSCt6bw9yUOQTmM22+z78A6aRe0A2/tJ3vMqEul1q6JXB9P0KCYFIXy6DdSL22CDQiqjYQ
	JIW+E1Ix7+u9MddhxGDk7dx26/s9ssFSJN+Pd2k2GJSapgzYlfUvLZ56hmVlXsrANViERermHGQ
	Ql9ygqCj0CrtsvLle7u8iouhb6o31TDRcpxALhJmFijyojEJC0/+2elHFFyspmE31DPN9/pjlbz
	SrVw17mhDZwpdWwwy9+XASm11ORbA==
X-Received: by 2002:a05:690e:d08:b0:649:5789:ded with SMTP id 956f58d0204a3-6498fb06c9fmr1668118d50.29.1769537034520;
        Tue, 27 Jan 2026 10:03:54 -0800 (PST)
Received: from unknown207bd2cf251a.attlocal.net ([2600:1700:6476:1430:99d0:666f:c9ab:3bf0])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79482762dfdsm473777b3.9.2026.01.27.10.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 10:03:53 -0800 (PST)
Message-ID: <fcd8fae5950ea5888eab5279fa3ebcad1d27bfa4.camel@dubeyko.com>
Subject: Re: [LSF/MM/BPF TOPIC] Block storage copy offloading
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Bart Van Assche <bvanassche@acm.org>, "linux-block@vger.kernel.org"
	 <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org"
	 <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	 <linux-nvme@lists.infradead.org>
Cc: lsf-pc@lists.linux-foundation.org, Jaegeuk Kim <jaegeuk@kernel.org>
Date: Tue, 27 Jan 2026 10:03:52 -0800
In-Reply-To: <5273400e-5cf8-4d70-a85d-accfb2977d8e@acm.org>
References: <0cfe6fe2-3865-4dc2-92a7-74b1240f7b63@acm.org>
	 <eab078c99e17e45632c6b35e2fe1145e9459ff2f.camel@dubeyko.com>
	 <5273400e-5cf8-4d70-a85d-accfb2977d8e@acm.org>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-01-26 at 11:12 -0800, Bart Van Assche wrote:
> On 1/26/26 10:18 AM, Viacheslav Dubeyko wrote:
> > I am not completely sure that copy offloading to the storage device
> > can
> > reduce energy consumption. The storage device needs to spend energy
> > for
> > executing this operation, anyway. Do you have any numbers that can
> > prove your point?
>=20
> Yes, we have measurements that prove this point but unfortunately the
> vendor that collected this data does not allow us to publish that
> data.

I see.

>=20
> Reducing energy consumption matters for mobile devices. There are
> other
> applications for copy offloading, e.g. in data centers and in
> enterprise
> applications. I don't think that these other users care as much about
> reducing energy consumption as we do.
>=20
> > Which file system have you considered as working model of your
> > approach?
> Every LFS for zoned storage has to perform garbage collection, isn't
> it?
> I think that we can discuss copy offloading without having to discuss
> filesystem implementation details.
>=20
>=20

It is not exactly correct. :) Unfortunately, we have to discuss the
file system implementation details.

First of all, not every LFS file system needs GC. Because, SSDFS uses
migration scheme instead of classical GC. And migration scheme is not
GC based technique because the regular file system operations moves
valid blocks from exhausted erase block (segment) into clean one.

Even if GC must to be used, then (1) valid blocks needs to be taken
from the logs of exhausted segment (victim segment in GC terminology),
(2) log needs to be prepared and (3) stored into clean or current
segment. And log starts from metadata header and describes location of
other metadata structures in the log, and user data portions. For
example, NILFS2 contains b-tree + other metadata + user data in the
log. SSDFS's log starts from header that describes locations in the log
of block bitmap, offsets translation table. Finally, offsets
translation table contains offsets to compressed portions of logical
blocks with user data or other metadata (like inodes b-tree, etc).

And even if we are talking about F2FS, then offloaded copy operations
needs to be accounted in metadata portion of the file system.

So, frankly speaking, currently, I don't see the generic technique that
can work for all LFS file systems. But, maybe, I simply don't see your
point. :) And this is why I am asking explanation of details how this
suggested technique can work for LFS file systems. Because, GC is
integrated subsystem of any LFS file system.

Thanks,
Slava.
