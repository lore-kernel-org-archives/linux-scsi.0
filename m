Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C37F1859
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jul 2024 00:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721174476; cv=none; b=exZs9meaCOUoTArRbfUq3orCO4rHxdNI3Bf0TMmE4Sxoc3GayXcG5c0LPdWsoCih9XVLnflJl/VzN0yRM9FXDPgB7BDvydAqcaJQrXf1smEYFnJpUbYKKSpuCdiYM65xbzCbOP6lYKtCQHfpFYxf9LNSj1WpNRW2tO6MIbi6W1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721174476; c=relaxed/simple;
	bh=SNnEsZWmZlGkSfqaytZBr3Hwi61qUEPt1WQznWmepU0=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=usRuim0FFOVgTVcpC9ZX1p9ozOurOuC2RR4CHjBqJcaGH7N0CJoTEm8gorFHkqo/UuraJU6m6tO5Bn6SzS7w3ZwoCUN7IA6bLnL4q6kY37lkl3bvumjQFOBtIPhyzyREMl6C6bSe3Q1hct61973UQM6KcdlZps9a5wxoTP6Y4hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E456eNoi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E456eNoi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721174474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e2HxlCztm27D4/QuFouF/qrX2OtpM4NidtaypUlcz4A=;
	b=E456eNoindWfI3vlOTWRTnE3AtwJ7ADfochE5fCTyiazhUr1W1tjenFpUvSXyKaUz2a2qL
	4ZzxdfJ/1BdP1+nGs/WVDDEBbCPVywhpFmD0tBa9VGQSML4tpuc59gf7QL0jfAEG2xfPkF
	zCTSaC5dsBVMUr/i+di3QN3uBgtURrM=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-49-Uc4sPFjKOGSPMdx3ixphjQ-1; Tue,
 16 Jul 2024 20:01:12 -0400
X-MC-Unique: Uc4sPFjKOGSPMdx3ixphjQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6DE1A19560A2;
	Wed, 17 Jul 2024 00:01:11 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.216])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B7AC41955F40;
	Wed, 17 Jul 2024 00:01:09 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <b69d54af-2ac2-406a-ab32-9bad9d8a3000@kernel.org>
References: <b69d54af-2ac2-406a-ab32-9bad9d8a3000@kernel.org> <483247.1721159741@warthog.procyon.org.uk>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: dhowells@redhat.com,
    "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
    linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: SCSI error indicating misalignment on part of Linux scsi or block layer?
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <981263.1721174468.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 17 Jul 2024 01:01:08 +0100
Message-ID: <981264.1721174468@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Damien Le Moal <dlemoal@kernel.org> wrote:

> That is very low... Old hardware ?

I got the cpu and motherboard in 2016, I think:

	model name      : Intel(R) Core(TM) i3-4170 CPU @ 3.70GHz

	Base Board Information
		Manufacturer: ASUSTeK COMPUTER INC.
		Product Name: H97-PLUS

> What is the adapter model you are using ?

This:

00:1f.2 SATA controller: Intel Corporation 9 Series Chipset Family SATA Co=
ntroller [AHCI Mode] (prog-if 01 [AHCI 1.0])
        Subsystem: ASUSTeK Computer Inc. Device 8534
        Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 30
        I/O ports at f0b0 [size=3D8]
        I/O ports at f0a0 [size=3D4]
        I/O ports at f090 [size=3D8]
        I/O ports at f080 [size=3D4]
        I/O ports at f060 [size=3D32]
        Memory at f7d19000 (32-bit, non-prefetchable) [size=3D2K]
        Capabilities: [80] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
        Capabilities: [70] Power Management version 3
        Capabilities: [a8] SATA HBA v1.0
        Kernel driver in use: ahci

It's whatever is on the motherboard.

David

