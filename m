Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EC9E566
	for <linux-scsi@vger.kernel.org>; Fri, 22 Dec 2023 08:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="CjwC8jxO"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2cc99fc1858so17313331fa.2
        for <linux-scsi@vger.kernel.org>; Fri, 22 Dec 2023 00:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1703233409; x=1703838209; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NFPcAgqpMDjUyOI46eez858frmAfzDRXlIM6U59hUac=;
        b=CjwC8jxODd/oy52Cd5ZzFqsJuuTQ40BLgVo4n86fdTt5KOtehuzmcm54c4CSCPG678
         MggwyZaHYhUwqGX27uLuhT2yx2HmlOTWB4KFb+c7VavP8xJH0Tc2i2R2qFikhCBTg9dq
         LjnRY9543mg0dDpQ2b6+AONXSsNADHYaKCY80+O+uSunxhoMKHS4vjPGxlQEhRRz6T6q
         oPskJi7zk38uedYb2ia4EQuU/8IyPVnV4tUTHeNCk60dc1S84DnrKNUhHqofl3j7297B
         OJHK4DhGdEInhL6/yXBwfMvMZIuVCN7xV5Dl3K+C/BAjqSnys5xoqJN+rez+KpVKhc5M
         v8DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703233409; x=1703838209;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NFPcAgqpMDjUyOI46eez858frmAfzDRXlIM6U59hUac=;
        b=EwoRn/tjoKFbtdsfMSrx0giAYLmCAMiWiDqoz9MCwFdwxJK6k0vP0w/FqPu5cHOHa1
         g1hUj94N8OJ8VKjXvWPFkmnjfa3XNzeckNaKo/l/o8exN68mr2zfZI+8rzD9jVFwZ3cI
         CBurLqOTIWypN7uYda+PxPgOG2inzz5pBtanw/xard236AyueHBbHWO8cIGjkCZhEy/S
         58n41NnzRDivkeKwaTsfdNis7mub8qai5EjQYiBOuN2LB52WFQ5l/1W4y4lxIKl8icPl
         dPLFY++WJujrXQDmUjHLsaTi9t93MafgwfLGTEgdyXb1zratiMTv14tynQjJ/B1KY+gO
         Qtpw==
X-Gm-Message-State: AOJu0YzVnlRdH190tFStneKvgzQGBmYGbhzFzI3EPh5T/2PyfHShppjB
	mKTuPKpjaT5D4N/HpB12VF5MOa4BzMxkYA==
X-Google-Smtp-Source: AGHT+IFkscMU1YqM9TeOxdQwwPdMY0LVyQ1RQr8PJCjzUZLPSRsA6j10f2Q7drwwodCNnYizhoi1VA==
X-Received: by 2002:a05:651c:119a:b0:2cc:7147:c8d8 with SMTP id w26-20020a05651c119a00b002cc7147c8d8mr222602ljo.65.1703233408967;
        Fri, 22 Dec 2023 00:23:28 -0800 (PST)
Received: from smtpclient.apple ([2a00:1370:81a4:169c:118e:db44:e99d:a2b])
        by smtp.gmail.com with ESMTPSA id r10-20020a2e994a000000b002c9ef016247sm533540ljj.132.2023.12.22.00.23.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Dec 2023 00:23:28 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.4\))
Subject: Re: [LSF/MM/BPF TOPIC] Large block for I/O
From: Viacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>
Date: Fri, 22 Dec 2023 11:23:26 +0300
Cc: Hannes Reinecke <hare@suse.de>,
 lsf-pc@lists.linuxfoundation.org,
 linux-mm@kvack.org,
 linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BB694C7D-0000-4E2F-B26C-F0E719119B0C@dubeyko.com>
References: <7970ad75-ca6a-34b9-43ea-c6f67fe6eae6@iogearbox.net>
 <4343d07b-b1b2-d43b-c201-a48e89145e5c@iogearbox.net>
 <03ebbc5f-2ff5-4f3c-8c5b-544413c55257@suse.de>
 <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>
To: Bart Van Assche <bvanassche@acm.org>
X-Mailer: Apple Mail (2.3696.120.41.1.4)



> On Dec 21, 2023, at 11:33 PM, Bart Van Assche <bvanassche@acm.org> =
wrote:
>=20

<skipped>

>> .
>=20
> Hi Hannes,
>=20
> I'm interested in this topic. But I'm wondering whether the =
disadvantages of
> large blocks will be covered? Some NAND storage vendors are less than
> enthusiast about increasing the logical block size beyond 4 KiB =
because it
> increases the size of many writes to the device and hence increases =
write
> amplification.
>=20

I  am also interested in this discussion. Every SSD manufacturer =
carefully hides
the details of architecture and FTL=E2=80=99s behavior. I believe that =
switching on bigger
logical size (like 8KB, 16KB, etc) could be even better for SSD's =
internal mapping
scheme and erase blocks management. I assume that it could require =
significant
reworking the firmware and, potentially, ASIC logic. This could be the =
main pain
for SSD manufactures. Frankly speaking, I don=E2=80=99t see the direct =
relation between
increasing logical block size and increasing write amplification. If you =
have 16KB
logical block size on SSD side and file system will continue to use 4KB =
logical
block size, then, yes, I can see the problem. But if file system manages =
the space
in 16KB logical blocks and carefully issue the I/O requests of proper =
size, then
everything should be good. Again, FTL is simply trying to write logical =
blocks into
erase block. And we have, for example, 8MB erase block, then mapping and =
writing
16KB logical blocks looks like more beneficial operation compared with =
4KB logical
block.

So, I see more troubles on file systems side to support bigger logical =
size. For example,
we discussed the 8KB folio size support recently. Matthew already shared =
the patch
for supporting 8KB folio size, but everything should be carefully =
tested. Also, I experienced
the issue with read ahead logic. For example, if I format my file system =
volume with 32KB
logical block, then read ahead logic returns to me 16KB folios that was =
slightly surprising
to me. So, I assume we can find a lot of potential issues on file =
systems side for bigger
logical size from the point of view of efficiency of metadata and user =
data operations.
Also, high-loaded systems could have fragmented memory that could make =
the memory
allocation more tricky operation. I mean here that it could be not easy =
to allocate one big
folio. Log-structured file systems can easily aligned write I/O requests =
for bigger logical
size. But in-place update file systems can increase write amplification =
for bigger logical
size because of necessity to flush bigger portion of data for small =
modification. However,
FTL can use delta-encoding and smart logic of compaction several logical =
blocks into
one NAND flash page. And, by the way, NAND flash page usually is bigger =
than 4KB.

Thanks,
Slava.

