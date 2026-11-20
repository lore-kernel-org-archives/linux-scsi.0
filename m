Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175088;
	b=l7zUWcsPr4x4W5f04fU2HLllys/t42zNkGgeQRDq0MOUEpNW2pB8Md2dPER+emPspCNf
	 9ZCAcKJ42TXWA320QzbuB7np+JsqgrlehagwSldnnPKiYdCdFc35Lr6s71VLRP9LRQ8W+
	 QtgYWqJk9lwzq86ZAhIiuS324BjdLDs4bNkPcUDaFnHb3Z4EOUde9wbqk9m89yab1+ujW
	 u1Zngq3WRcZdEtW5MWCs8ipTiof47xDXz+RkQuzpCR/gvedkYL+sef/vXS5phh0xgq8TB
	 O8AKBjMo0V+SRa8T8ZQ+jaZHJzkXU/WyFCFhyfMlNm5JahwUVZ7eZOtVmu4fC/RmA8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175088;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=aQRBgX2VgkOHD0W+Pmya6gBX/CjSVN896aNxZV8p6ww=;
	b=ewFYA2207gXsTBtCl4514kI88nfML8JhYdnlFj1VdlCdo5K36t4BKe2yblJ/P/fHJBcl
	 8rRugAmBpPrF5WvI/RErjPPhi4EYtR3+6cYQFuYVzYULbT5vnxY49FfeyDsGmIO9S5rDw
	 kBohO4WIhzB9qruRzvbadJzQiTkCi+OlWv0k3LbR/iAifV3aKHBVeqf+VZAYMqV/3Flmq
	 6BjZzP9/5RGJuyyHETSL+f52az/tFspV85wG++a8fOCffjWdhPMdANxAzYS/0v+X/WBEx
	 DGAVZIPFCO+L7oBEXoAa8pwZPBgzYmo95C5WKWy0fRmjlTdebIi4OZfIxSGtw+nu4KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VYKf2gRz;
	arc=none smtp.remote-ip=209.85.215.174
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947FC60A6F71
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:44:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 947FC60A6F71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VYKf2gRz
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cdb75699c7cso323956a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795175088; x=1795779888; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aQRBgX2VgkOHD0W+Pmya6gBX/CjSVN896aNxZV8p6ww=;
        b=VYKf2gRzQFEWflJPgPiv4oGKQy18k742M+SyPxTjDcV1YzA2HpH+tEith8h3cUYCqS
         ZuHsPGAEFJaEVdHlTn0+7wfNhRpy17x7VUcLO7RcgDKbxaVa8SVFVULOAARCdUgo8MIB
         auec3S/dXTxxBV41FBH7CIdgKi0Pfrtc3PkRXLAM3G3p8FMhi/36apeiTVqxX4b1DT6c
         Z9da1CHxLqdbPb+a/beQVSqOLTW+HbN1Hp3BIYimCZ1zTas5XxTzLR6JZcXyU4+ifSwa
         mDV3bu5Ex5uNRWhErkpkUfWzDPh4/BdFYDj79RFFWOkJPySppnsX4GlX45k1d+ABtV0l
         t5AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795175088; x=1795779888;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aQRBgX2VgkOHD0W+Pmya6gBX/CjSVN896aNxZV8p6ww=;
        b=Hk/PA/dpbdqOpoFFUYdWckmuZCSP73ds8QN98cVvThXuQi+9UhLD63mxAldOiUIIv3
         CPHNsZShyvfWSN3R13+OTk0qnd/4uQr9J/8Cn6F/z2gvfWdO11I09hCVUYKjcZhtkqtj
         /0aifIyQL3oy1A5hYOS0UFcb1UJOym2aZd/+E/+CkH901PH2fpGvvYlLqBL2ltlwZ1FD
         j8GghsUbgRgck2mggaqNKTgBVX2yXgt28IrCFEUstZTsxGwAMaLbOMTN8KxiKzXpYXPJ
         0cdO1RcQW+eRxup+8NLcxuB3FovZN2LCv21ddat8Ye4iAGMLTbtPjqYB/N4MdhfbVYlP
         RjBg==
X-Forwarded-Encrypted: i=1; AL+hErHK8xt1HLTVOn9MJiFMrgpRhkkmEGK/20TkQyn1H1OdI6RDlo5U7u1pODWYRQLOdhQyNrqs1VNMfnsU@vger.kernel.org
X-Gm-Message-State: APuU4Z/uJyjreFzSEcYndvxDi16grTeSxMHY+COUlbO4agHzox9iNIwh
	fCnJ7RZ4eScO4FXpVzn1Ni7IF6iQBbVDTf2pcavd5eSAG99xQXxI0G77rr1GX6AVSR0=
X-Gm-Gg: AYBFou0pclNr8ML7s4qH25gGkCIMRBVOe7PYGJMCJbq3ZHm1IyTOf4U1+8jvOPczWaC
	6PVFmBnoqhsHzQ+pHS2cY/wdjYluO0RKT+0jte+V7rhvUt98oUQlF8h5ApS1jYUTXzYxT5pNMYi
	p9aw1xytSZtJcjx4LVKVNof/Y7HnU6pWFqZDdQj7S9dIqn7j/F/yWBeXh4mC0UoV5BexVVzbZC8
	5Ne6sZ52PzSIyE7tUQzlbjR22Qf656xfcdsUSWJStJYLxYDldStPiQxy425ii4ipbb0/htkKf6g
	lU92UWwwV6fwQrjawGB4hLtvoq0ut6L6ZNVlYgeEheUzKSBIQejz35CbyHWrxfb8gOpk1MWL127
	5unLZ1BbEGInyr+cFBIzrP/IS1EJK40oLpawR8PAqbogVmXKnmnyN3aP3Lpi4bHnaWC1TQSSzld
	/xaj/B61PWRSXBM0cktdz5st4O34VqZ9BanNk6nSZQvJawxT32D6toXvG+6T+6i1jvnjIoWaFay
	McaaaZIiGM/ztbD6YBOkWuwiX0GzXxFTQg61P/AoeGOLpAfptJKU13tAHHv4TNq6dTa4G+R7CX4
	fi+gu36qrCeuUmWyU47j0F1ldOoVBZnnA7eIalFKu7fPH5yQAmn44sztmXiW/XgW6zSppOWvpnM
	DYDCszYRC0yHYdgaOLuq5a3gupzipFXmS2jLnuuizOtS+Dx2AesvBRl/G8g==
X-Received: by 2002:a05:6a20:db97:b0:3f8:e0d0:1de3 with SMTP id adf61e73a8af0-4014bc51612mr2765718637.46.1795175087893;
        Fri, 20 Nov 2026 03:44:47 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cea7c38sm1228138a12.2.2026.11.20.03.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:44:47 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ram.vegesna@broadcom.com
Cc: dwagner@suse.de,
	mkp@kernel.org,
	jsmart2021@gmail.com,
	hare@suse.de,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: elx: efct: fix target session lifetime against node teardown
Date: Fri, 20 Nov 2026 20:44:42 +0900
Message-ID: <20261120114442.3072652-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021130802.2691833-1-yhlee@isslab.korea.ac.kr>
References: <20261021130802.2691833-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is superseded by v3:
  https://lore.kernel.org/all/20261021142818.2782104-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
