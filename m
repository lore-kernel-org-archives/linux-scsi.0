Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793238146;
	b=Uv6g49EYMSMIC78ZDo08PQIEn3fYLcrUuf4FZkgmK/0XeI1dLEM9yFVTEky+3ZJTHbrQ
	 j+9RiD+nsG3mu+9jipNCB4DG6tDr/XQzVk8wLMqI1kOqgBfRctqKbFwVb5TLEawv2lN40
	 9yc2HGTv4At+Wt44jchzBmKEt1DeAlhCinNClRjKQDMk0KvcasVPDtlQ5gwGQyUSTnnvF
	 U5Npj/YHMEfBuMK37ACsTu5yss25OBBWtEPH6ASDHKPRgw3REuwRs3RLZmGhvXQ6rFxJb
	 Ad82FY6FiymYNCw4sbx/WpHrWnoPbFJtzRhUXwASVG1XO2VZBBxCjtLS91TS8a8TXyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793238146;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=cSGJzZiXCj798GkI10LTKETldsERRDK+xDXKBEXm4a0=;
	b=yIQeNDwPS4m8uCvPxsBecnUrTgYjtn1BzhXBYyMfPeeyqgMh2Urmp7AliEn4cdGtCyF4
	 m+KrrSW0KQSUnCJo9gdcvJw2Aqn9Au7IQwKjduO3ONAWHllwFXgEvHVSbrYirX+B08ZSv
	 BHH4Bxgfg3PfwaUDw0yN1GSAW/EYQR8mzrzTzraUAZ3DFdqE41iaX2TwyFGH++J2PeU6n
	 NMWFkbERNPWBoD/i9N4153ROlzzz4lNu2Bcx0VdPdYhGj7B84v9ytEi4GJFeM66eiuSfN
	 80CFB6COVHto7FscjJ9aJU4WAYdmZSWeai2WdNJP/mG9db+0Sxr9LCodKfWQk/OIO2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZY6ccAh3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1201D606A31E;
	Thu, 29 Oct 2026 01:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZY6ccAh3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EC31F01825;
	Thu, 29 Oct 2026 01:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793238145;
	bh=cSGJzZiXCj798GkI10LTKETldsERRDK+xDXKBEXm4a0=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=ZY6ccAh3ZhtgL7SqJxAlpVRWXzarAV9lXOZKzhhRP0Q+qeDkGKrdpJ1jfat6br3K3
	 0RXk5s991sRoJN6RbinnCx+VdW5vHpir2s/YA+j5jXFw+5RjwRO8/e/FZ57bckxzoe
	 80PGCN3gizm0YFfPyZC3y+Uv/vx+mxKOwKPJRTW8g4BW/D9qzE9ya6mJlEI35ebZKi
	 N05ED56bPm/G9O092tSFEglYG5tj8sod3hTA/NawwZqRYfttnGw5OxdJgApocMg1cq
	 A/Iq9aQakOesS+9HOuUeC9rN24RX6QVkE/0Q1lhObol5UpE6ZF0FypMJ8dOmFvNInX
	 gDX+1cILmqZQw==
To: Yu Zhang <yuz08559@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
  linux-scsi@vger.kernel.org,  target-devel@vger.kernel.org,
  linux-kernel@vger.kernel.org,  Mike Christie
 <michael.christie@oracle.com>,  Dmitry Bogdanov <d.bogdanov@yadro.com>,
  stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: target: fix demo-mode dynamic ACL dev-entry
 UAF vs LUN teardown
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261014013746.46705-1-yuz08559@gmail.com>
Message-ID: <yq1a4nx470r.fsf@mail.kernel.org>
References: <20261013120528.37749-1-yuz08559@gmail.com>
	<20261014013746.46705-1-yuz08559@gmail.com>
Date: Wed, 28 Oct 2026 21:42:24 -0400
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Yu,

> A demo-mode (generate_node_acls=1) login that allocates a dynamic
> NodeACL populates that ACL's per-LUN dev entries in
> core_tpg_add_node_to_devs() *before* the ACL is linked onto
> tpg->acl_node_list by target_add_node_acl():

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
