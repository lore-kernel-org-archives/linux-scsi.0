Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6615C282F2A
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 10:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786530845; cv=none; b=tgvpAG//6RFrLlvcITqQAMXWs39PEZ0Mgw5aElh2XbptjRL5Ah+T4JSc5NYjhmle9FW8btPOzA7K3+7tkUHtBft6f2WBBmcvKUtsKYEPG3W2EcSfcb7WqXf+saKnernq49tWs74STAaf9Vsd4oS0BPa5G1uotyzh3jmZPrMuabE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786530845; c=relaxed/simple;
	bh=OrJ80CPuFbnrahBwaYh2vDlCN0mdyMJnlS90x7JVRcw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bo7IVisMtBRie5y4aAwKu558m9zlv24cUsG0gAUPyBlKy1dPFaBFrIiIRELdFW7sdAMoT/W7i6YLB242gyMWvrOFyg4mFrSsRJg3kqMML7Mj5/Qq1PdHmeNawSowSlq4GP+Q8oh6UNsdhktTLdr9vtVMdKx37T6wrDQuBJmGhek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fzvbdFjK; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EA5zCUwC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fzvbdFjK";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EA5zCUwC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786530841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=C9/SbfCuud7YYe27YxIeb0jc72ejQ/OYb3vI7cOH/RM=;
	b=fzvbdFjK7rup3ooDeLr9B07ammoQP4m2AtpUrOH38sTBQ63ro9i9WuVYB9qjs31XN07pFn
	bB0ql8MnK0q/CJwUWOanLfenTszYrtlsdrXSxbJSMjgjEcGYe3+bmTVy0/kjR+A8QdVef9
	VnaAF/EHtRJOs/6KiC2oq/wxsL8sl7A=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-lraqKy-qNuOG1D9MoLdEJw-1; Wed, 12 Aug 2026 06:34:00 -0400
X-MC-Unique: lraqKy-qNuOG1D9MoLdEJw-1
X-Mimecast-MFC-AGG-ID: lraqKy-qNuOG1D9MoLdEJw_1786530839
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38ea32e57e2so1490874a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 03:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786530839; x=1787135639; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=C9/SbfCuud7YYe27YxIeb0jc72ejQ/OYb3vI7cOH/RM=;
        b=EA5zCUwCQ7Bm3HzreNMUyhVo7CXevrj/RRyXALnjmM0bTkaB1G6+pO3tfvRSb4Fsrz
         X758qavt3z8tenbdtnGaMbaYfEgAD/Vbe18a5Ic1ZARgbzp80svFjPWw7MZ+edy0hbpm
         E3AP7hud1eBfE2b8uT4N6Ew8h1EktkuM95lr2A/A/kQyhArttXXpYI1CUB6f6ydv086d
         pfVHFJMSndAerK3GRStm8TVzJpFKwIIYmitHJkXE1PuGfza0xV9Kcswre3zwAxmM5kz4
         lyC7mi6aqEJqEychZuENk5FZSwVFlCRmatxgtEKe9PBXXyLKJ1lHIjCi1hHv7cMwQNDC
         w9cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786530839; x=1787135639;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C9/SbfCuud7YYe27YxIeb0jc72ejQ/OYb3vI7cOH/RM=;
        b=IePaRDuVAzoLWpkaPc4kOhG72wr8BsWBB2Nlm16QwhoKiwOxG70ic/SFm5+lh/8Cw8
         DusDinbu8L00lFRWMpEG+AGDQD31KKGaNk1CeQ93DSgoA60pIvDWhLb9dX+S+BfQXs39
         Kib4iqbbgq7Dp0Q5zeoX0W2Sv57idhPMhjZ3b/jDSyM2SPddi9LDVJkox/P3+BzorTpf
         zaszVIPgdrlYebjCvKTw/7OXTsiQXr4COMppD80va3fWQkR1+rFC22zqZOqup286e9ea
         UDmCTA8qER/Styw55hj7xZ7POKYZ6yWcn8dg6+EAEuUBKdsOQ6rDFIcs3nop2m8djZWz
         H6WQ==
X-Gm-Message-State: AOJu0Yw/XLC+161Vj+zRkASAJvljoLnrUtOebl1QOkAfGkIRGU1WJa0J
	2HXCGr1L+Ky6aZPdT2DabZWbtZmHFyozAIkHu2WzOWZrSFAzP/GkqHNNMtClo/sxwD0q279WvzL
	9i1hNDwvTkJwsVln8W++nlA5dpeye1an9Tg68zIUCPdb5e8E5D/eps3JAOg7vGJzq8psWegBm0b
	qBiS7faKUkQi/OncqlUI+owEnCXVs5yBalHY/2MH2ZqTTgOA==
X-Gm-Gg: AR+sD13lIHPjCksv3tlixasJ0fcgLunS5ENXKxyAUhKQclATtARH/ffMb/iNZpjvvmp
	Lv6RgOxRGG5KmEWjqL/orm4m8QdHIGTzDaQBf4YWpBXuwdSLKeYXEyJkxTR8CiuW4IPzoSIMq0L
	SNt27yHhynimuLWNs4MTPJOAyTVzeMo7BFqvg2cvnsCpl7slaOs55geyDPCxLXzBDbcfhTO1DJP
	3Eor7pi2oScQzTqTDfSgt1bLfzUmsbFxUCfOx8c9A0VO7yc4+DwmBby/IWgQ+lX+sXB2t8ZAwoh
	f5NVUfOMqkqmAOOtZJ+vB5cJzlSrxDB9XguVIT/QBKWtzziSB3qvh0s9taKfBDNMbz9OSBwniN2
	jSjY06wjFwKtQ5mj2oh7bBXO3vPzsS6R5tNiRMLFA3tWRjW+jEtvewRSSSSPFXy26wCEV
X-Received: by 2002:a17:90b:4e84:b0:38e:7268:220d with SMTP id 98e67ed59e1d1-39301620ce0mr4829247a91.20.1786530839216;
        Wed, 12 Aug 2026 03:33:59 -0700 (PDT)
X-Received: by 2002:a17:90b:4e84:b0:38e:7268:220d with SMTP id 98e67ed59e1d1-39301620ce0mr4829173a91.20.1786530838593;
        Wed, 12 Aug 2026 03:33:58 -0700 (PDT)
Received: from mgandhi-thinkpadp16vgen1.punetw6.csb ([2401:4900:88fa:3d3d:2349:1310:a2eb:9912])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392f9675e32sm1031413a91.0.2026.08.12.03.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 03:33:57 -0700 (PDT)
From: "Milan P. Gandhi" <mgandhi@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: "Milan P. Gandhi" <mgandhi@redhat.com>
Subject: [PATCH 0/2] scsi: mpi3mr: Fix error handling and resource leak in mpi3mr_sas_port_add()
Date: Wed, 12 Aug 2026 16:03:42 +0530
Message-ID: <20260812103344.174247-1-mgandhi@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes resource leaks and potential crashes in the
mpi3mr_sas_port_add() error path:

- Patch 1 adds a missing NULL check on sas_port_alloc_num() failure
  and ensures allocated ports are released via sas_port_free() if
  sas_port_add() fails.
- Patch 2 releases the target device reference acquired via
  mpi3mr_get_tgtdev_by_addr() if subsequent allocation errors occur.

Milan P. Gandhi (2):
  scsi: mpi3mr: Fix NULL pointer dereference in mpi3mr_sas_port_add()
  scsi: mpi3mr: Fix target device refcount leak in mpi3mr_sas_port_add()

 drivers/scsi/mpi3mr/mpi3mr_transport.c | 8 ++++++++
 1 file changed, 8 insertions(+)

-- 
2.55.0

