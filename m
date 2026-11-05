Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793850768;
	b=AK0hBboXdaaLBssUcvprx3jYcBtpRAsWVEKl7gUVGL2A4b0GfYUghYxJkkPubZwGJMch
	 qZa4N+kJm021XQTnf/Bz1vzvD656iDqeJiVb2Wx+HmP4EqN236yMQoTZ/Hgv69dI/VPSI
	 c/W2rQuyZQITwsF+ovSR97nPmknGpd70o7P5W3cEQR32gy5vyGZBDVWzIJjMq3xsAeycc
	 gxA1Xm+nRGGl5CcCcOpL7HVEyQzlAiXyHbBYHMdWtVvV5RzlG5eDUcs07WS5537kpBlHT
	 9sJtRI/p1QjpDjuHiFlKeH1rax3AT7VrKjeCMiWDIg4/vM5uZildfhkcS1ZjMI4HmRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793850768;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=6bdNkQDjGlIQCQFekmGTbct/uYcQnh6+aY3rXTFb1Wo=;
	b=k+f6rS6Q8gASfBdwFbZ85791SJSCJ3ZHn+Q3nZxQZveB8VdwVe5y9g492zbSNQgyCVPo
	 xRrFWyor1VrpYD+qfqZQqk9XhV97sWY9AnGl/QD5SvIVz8pXEYrBm42hulqzJ+iK84ewT
	 Er97Nbwp4960mqiS0QsEnG34W0ygreEIkN6pyiJkLCguehlIQ3ZLzAvQWRVk55Va5NZsD
	 ypZ3IHKzwN2a/ZJp8k4j0lQ4lAQyE5GMvdvm5NF0qRMCm5XJRSDumDBfgPXD7wchrHbVA
	 IMqGy4UxSbyJIS1FFU1np8/+B19wn0HUS7QltSvGkZcoh2+s1jWLoATHz7uryVAZsZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q4tXb1x6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F94606A31B;
	Thu,  5 Nov 2026 03:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q4tXb1x6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1361F000C1;
	Thu,  5 Nov 2026 03:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793850767;
	bh=6bdNkQDjGlIQCQFekmGTbct/uYcQnh6+aY3rXTFb1Wo=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=Q4tXb1x61oMdBxzIXLfiJIaOsBuDwwcKPOBYp9IneQWrl13rT7tyiWIh3AT/e2vAr
	 oLkGg4OSMiX6eLdXBO6xBIjkcewQxuo+7nW1Sp6XSCY3oTxDkYRvelrMk1p0P09aj6
	 r16u4vRK38AW/ApZPb42Qdvcy5vFZTr8sygMkOF3hA8bcwRqtxz2tM5WCDaXVjTWfT
	 hUnE7RPJ5PScGNNabnriNdG8/EeYtEgT1Z3MViiOGwLkYv8u0vL9yoDuFi/vDqjkId
	 vkYhh1P9CWr8ihSozQqE6IJIKenwy9PJWW0a4OSknuQigltStuU3BLiER6UWa4i1hH
	 L1kQUQ8fbxe9Q==
To: davemarq@linux.ibm.com
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,  Michael Ellerman
 <mpe@ellerman.id.au>,  Nicholas Piggin <npiggin@gmail.com>,  "Christophe
 Leroy (CS GROUP)" <chleroy@kernel.org>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,  "Martin K. Petersen"
 <mkp@kernel.org>,  Tyrel Datwyler <tyreld@linux.ibm.com>,
  linux-scsi@vger.kernel.org,  linuxppc-dev@lists.ozlabs.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v17 00/13] scsi: ibmvfc: make ibmvfc support FPIN messages
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261102-ibmvfc-fpin-support-v17-0-9ee5f195ac91@linux.ibm.com>
Message-ID: <yq18q38ym3n.fsf@mail.kernel.org>
References: <20261102-ibmvfc-fpin-support-v17-0-9ee5f195ac91@linux.ibm.com>
Date: Wed, 04 Nov 2026 22:52:46 -0500
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


Dave,

A malformed patch 12 in this series meant Sashiko failed to apply it and
therefore could not provide feedback.

We are getting close. However, a manually triggered analysis identifies
lingering issues in patches 6, 9, and 13.

-- 
Martin K. Petersen
