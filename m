Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C8F3D8916
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 08:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789460423; cv=none; b=AlKVYnBVgWT1MG0aF/OhsR8PaHrTTAZAxSQ9l9xp6Vbrv3zDu2deP0xCdfejXgFiHgBLqFLGPd4RIHa5F7+T1XygkOVqTMT1JA+BzMLhiYM8TgrAM0tUV7z5WZaKlPo1LCutPyrmVCmI+288YZ7E1Jk/p8caz6v3I0Z+2MDLvcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789460423; c=relaxed/simple;
	bh=AdZQZFBZ+Sq+Xs3+ioKoxuNwDqkD/CEsMpiPWsVgYCg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ic7Qd/U8XX54xk5Ae+ljMQvxJ8UqavBIY2wqjtvpNXQWhkf1QMnzdU3FB0+AREMe96V8/2zN+AeLFOLemzTPVbkwvci1kU2Yvv2IL+zxpEP790YQVCERai2VbFOYpXHLsSE6adD00Rai4V//toF+hBnbpmDJXvVOXki0kBCzM60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--morbo.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e7zvsQ58; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--morbo.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e7zvsQ58"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cec4226c70so55721885ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 01:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789460391; x=1790065191; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=i189Z1372pvpafDRMVnLFn5IBf8O4Z3ONLFW1RCweBo=;
        b=e7zvsQ58BkKTiZW4t1dlacydlPXAyV5l7nrlXWGuEnl8ITedm+WZqimRu2Ntz065t4
         I00TgGLvLcai1VOpDqY0l/EmyYeA0dDc4gRltA0iwoBuD923CtGSmNfi9u9sahP1oR+K
         +PaHxh0VGG2vE2cFpXvFEfHpfHHTARCVZhCjplJ0URdGB5zttT3AV1tLmrrSgbBz7J2/
         Xgv6ZWPZW4F0K1qnOdSxXmsxvR33uIEkdKSrtfzlnQjv/HtRWJdOf7qBTgXuMM7+1MAI
         tuPOpJAlqeiQhLvD6+3+vnZBbW8J5frLP8RFZPhZ9ByDYqh23hwk1njZ31sP7KgvAB5R
         +hqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789460391; x=1790065191;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i189Z1372pvpafDRMVnLFn5IBf8O4Z3ONLFW1RCweBo=;
        b=JaR6gJi3erxWxKiXSkJv0mqKBpmMzP83Looe7ihbF3/Zn2sZw9Co6QC2Swit8Q9ulC
         /zSAq1tIY16YV9lwQSjf7dvcizCPpx90psIm62tJjnJpf1H9hHDN66u5fUc/3+il4OYL
         UEo8bDBRdCVQK1IE4+PW8elfp01RbkW3EkxLjFV3uVLwHOHEX+10YgsPQeQtwIp/+ndB
         1ejYYFQnA1YVPJ5dGQNK/p4du0rzHaanTXfSrfGKs/mvx+s9J7Is0BXXeYHkbAtWlcQ2
         IAPOT+1yqOW9BZ6BezQHW/Au2nfzEWnOU89dlbQPoOMMZ5+HT2mhshYemVbi62UDiAof
         QBiw==
X-Forwarded-Encrypted: i=1; AKwUvBxAqtQZNoQAv3PN4GzBnLUdDdkWkvm4YsHdO566OjLDTs1KZYUqq6ZK3jwDlUmYmL2u8ox6yjYbKaKZ@vger.kernel.org
X-Gm-Message-State: AFuF++lkpzgPf+tkt0RxGW8pNJ9twUIFZkRc4PW1A+EDqiorEDc5NvAS
	L91suHYKPy4Z04LbdOpPga6Qt+O9EY9Ztloti9lsH4YhMKWhCQDOqePcba5NpvDhB2oJeBjTFfI
	i
X-Received: from plrd12.prod.google.com ([2002:a17:902:aa8c:b0:2db:8b6a:31a7])
 (user=morbo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:388d:b0:2dd:143:d5
 with SMTP id d9443c01a7336-2dd6c75a396mr155065525ad.22.1789460390543; Tue, 15
 Sep 2026 01:19:50 -0700 (PDT)
Date: Tue, 15 Sep 2026 08:18:19 +0000
In-Reply-To: <20260915081910.4142719-1-morbo@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260915081910.4142719-1-morbo@google.com>
X-Mailer: git-send-email 2.55.0.1032.g73a4cd73de-goog
Message-ID: <20260915081910.4142719-3-morbo@google.com>
Subject: [PATCH 02/28] sunrpc: Refactor rpc_sockaddr2uaddr() to use snprintf()
 instead of strlcat()
From: Bill Wendling <morbo@google.com>
To: linux-kernel@vger.kernel.org
Cc: Bill Wendling <morbo@google.com>, codemender-patching+linux@google.com, 
	Russell King <linux@armlinux.org.uk>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Helge Deller <deller@gmx.de>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Tony Luck <tony.luck@intel.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Matthew Brost <matthew.brost@intel.com>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Dmitry Torokhov <dmitry.torokhov@gmail.com>, Matthias Schwarzott <zzam@gentoo.org>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Tony Nguyen <anthony.l.nguyen@intel.com>, 
	Przemek Kitszel <przemyslaw.kitszel@intel.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Arend van Spriel <arend.vanspriel@broadcom.com>, Rob Herring <robh@kernel.org>, 
	Saravana Kannan <saravanak@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, 
	Sylwester Nawrocki <s.nawrocki@samsung.com>, Peter Griffin <peter.griffin@linaro.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Linus Walleij <linusw@kernel.org>, 
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>, 
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, Kees Cook <kees@kernel.org>, 
	Jiri Pirko <jiri@resnulli.us>, Simon Horman <horms@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Kanglong Wang <wangkanglong@loongson.cn>, Tiezhu Yang <yangtiezhu@loongson.cn>, 
	Qiang Ma <maqianga@uniontech.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Pengpeng Hou <pengpeng@iscas.ac.cn>, Ard Biesheuvel <ardb@kernel.org>, Breno Leitao <leitao@debian.org>, 
	Thorsten Blum <blum@kernel.org>, Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Lyude Paul <lyude@redhat.com>, 
	Ashutosh Desai <ashutoshdesai993@gmail.com>, Imre Deak <imre.deak@intel.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, Johan Hovold <johan@kernel.org>, 
	Johannes Berg <johannes.berg@intel.com>, 
	Miri Korenblit <miriam.rachel.korenblit@intel.com>, 
	Alexander Stein <alexander.stein@ew.tq-group.com>, 
	Cryolitia PukNgae <cryolitia@uniontech.com>, Jiaming Zhang <r772577952@gmail.com>, 
	Will Porter <mrwillporter@gmail.com>, Cen Zhang <zzzccc427@gmail.com>, 
	"=?UTF-8?q?C=C3=A1ssio=20Gabriel?=" <cassiogabrielcontato@gmail.com>, Rong Zhang <i@rong.moe>, 
	Arun Raghavan <arunr@valvesoftware.com>, linux-arm-kernel@lists.infradead.org, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linux-edac@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
	linux-input@vger.kernel.org, linux-media@vger.kernel.org, 
	intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev, 
	brcm80211-dev-list.pdl@broadcom.com, devicetree@vger.kernel.org, 
	linux-samsung-soc@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-nfs@vger.kernel.org, 
	devel@lists.orangefs.org, linux-hardening@vger.kernel.org, 
	linux-sound@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

rpc_sockaddr2uaddr() formats the IP address into "addrbuf", formats the
port into a temporary "portbuf" buffer with snprintf(), and then appends
"portbuf" to "addrbuf" using strlcat().

In preparation for removing the deprecated strlcat() API[1], capture the
length returned by rpc_ntop4() and rpc_ntop6_noscopeid() and format the
port directly onto the end of "addrbuf" with snprintf(). This eliminates
the strlcat() call and the temporary "portbuf" buffer.

Link: https://github.com/KSPP/linux/issues/370 [1]
Cc: codemender-patching+linux@google.com
Assisted-by: CoPilot:3.5-sonnet [editor_update_file, shell_command_run]
Signed-off-by: Bill Wendling <morbo@google.com>
---
Cc: Russell King <linux@armlinux.org.uk>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: "Thomas Hellstr=C3=B6m" <thomas.hellstrom@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Matthias Schwarzott <zzam@gentoo.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Saravana Kannan <saravanak@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Peter Griffin <peter.griffin@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Linus Walleij <linusw@kernel.org>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: "Martin K. Petersen" <mkp@kernel.org>
Cc: Trond Myklebust <trondmy@kernel.org>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Mike Marshall <hubcap@omnibond.com>
Cc: Martin Brandenburg <martin@omnibond.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Simon Horman <horms@kernel.org>
Cc: Chuck Lever <cel@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: NeilBrown <neil@brown.name>
Cc: Olga Kornievskaia <okorniev@redhat.com>
Cc: Dai Ngo <Dai.Ngo@oracle.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Kanglong Wang <wangkanglong@loongson.cn>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Qiang Ma <maqianga@uniontech.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Breno Leitao <leitao@debian.org>
Cc: Thorsten Blum <blum@kernel.org>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Ashutosh Desai <ashutoshdesai993@gmail.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Johan Hovold <johan@kernel.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: Alexander Stein <alexander.stein@ew.tq-group.com>
Cc: Cryolitia PukNgae <cryolitia@uniontech.com>
Cc: Jiaming Zhang <r772577952@gmail.com>
Cc: Will Porter <mrwillporter@gmail.com>
Cc: Cen Zhang <zzzccc427@gmail.com>
Cc: "C=C3=A1ssio Gabriel" <cassiogabrielcontato@gmail.com>
Cc: Rong Zhang <i@rong.moe>
Cc: Arun Raghavan <arunr@valvesoftware.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: loongarch@lists.linux.dev
Cc: linux-mips@vger.kernel.org
Cc: linux-parisc@vger.kernel.org
Cc: linux-edac@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: intel-xe@lists.freedesktop.org
Cc: linux-input@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211@lists.linux.dev
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: devicetree@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-gpio@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: linux-nfs@vger.kernel.org
Cc: devel@lists.orangefs.org
Cc: linux-hardening@vger.kernel.org
Cc: linux-sound@vger.kernel.org
---
 net/sunrpc/addr.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/sunrpc/addr.c b/net/sunrpc/addr.c
index 97ff11973c49..a1e4173e5a53 100644
--- a/net/sunrpc/addr.c
+++ b/net/sunrpc/addr.c
@@ -264,18 +264,20 @@ EXPORT_SYMBOL_GPL(rpc_pton);
  */
 char *rpc_sockaddr2uaddr(const struct sockaddr *sap, gfp_t gfp_flags)
 {
-	char portbuf[RPCBIND_MAXUADDRPLEN];
 	char addrbuf[RPCBIND_MAXUADDRLEN];
 	unsigned short port;
+	size_t len;
=20
 	switch (sap->sa_family) {
 	case AF_INET:
-		if (rpc_ntop4(sap, addrbuf, sizeof(addrbuf)) =3D=3D 0)
+		len =3D rpc_ntop4(sap, addrbuf, sizeof(addrbuf));
+		if (len =3D=3D 0 || len >=3D sizeof(addrbuf))
 			return NULL;
 		port =3D ntohs(((struct sockaddr_in *)sap)->sin_port);
 		break;
 	case AF_INET6:
-		if (rpc_ntop6_noscopeid(sap, addrbuf, sizeof(addrbuf)) =3D=3D 0)
+		len =3D rpc_ntop6_noscopeid(sap, addrbuf, sizeof(addrbuf));
+		if (len =3D=3D 0 || len >=3D sizeof(addrbuf))
 			return NULL;
 		port =3D ntohs(((struct sockaddr_in6 *)sap)->sin6_port);
 		break;
@@ -283,11 +285,8 @@ char *rpc_sockaddr2uaddr(const struct sockaddr *sap, g=
fp_t gfp_flags)
 		return NULL;
 	}
=20
-	if (snprintf(portbuf, sizeof(portbuf),
-		     ".%u.%u", port >> 8, port & 0xff) >=3D (int)sizeof(portbuf))
-		return NULL;
-
-	if (strlcat(addrbuf, portbuf, sizeof(addrbuf)) >=3D sizeof(addrbuf))
+	if (snprintf(addrbuf + len, sizeof(addrbuf) - len,
+		     ".%u.%u", port >> 8, port & 0xff) >=3D sizeof(addrbuf) - len)
 		return NULL;
=20
 	return kstrdup(addrbuf, gfp_flags);
@@ -352,3 +351,4 @@ size_t rpc_uaddr2sockaddr(struct net *net, const char *=
uaddr,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rpc_uaddr2sockaddr);
+
--=20
2.55.0.1032.g73a4cd73de-goog

