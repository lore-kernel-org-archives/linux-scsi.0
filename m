Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0734D5172DD;
	Thu, 17 Sep 2026 16:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664287; cv=none; b=QPQ6r0VybFl/OsT8Zb5mwRTlEJO1pWexhVbiHWVrnB5J+UC5yqvPuIp0hZoBzpEA3AcUv5OY+b947sThAHbvmTKYp+jQkom1uZU+hWx0by/HnAeYRLo4TNziZmGDCnjWysv1ogO+rP3JVRX2BwYAL9hzhKl9lJ+Lp3eM8pvHvgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664287; c=relaxed/simple;
	bh=n/b+TkHJhF+tCoFn9I9g+htfnz1uHmfohwh9wRCjPDU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=I4RMA4zfiJ9JQ1hfCzkLyi4BJhyBzL6HX3WUl98Jt2JnJhUhQqwApg4jtZmM1JVrtUBKd6bf0317bBDZA+wCJktgBANlcqTtPmeyfyCmjNcC5cdxbkFCIIvXgzst0Qqbh0ndGZLu9GJ5OLuNnJmYdZN0lnPa2MTNtp6d5I6IT5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LL3uY252; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LL3uY252"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6C01F000FF;
	Thu, 17 Sep 2026 16:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789664285;
	bh=n/b+TkHJhF+tCoFn9I9g+htfnz1uHmfohwh9wRCjPDU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LL3uY2524Sa23BQKAZLTNnfnFot4uLjZ4uvBbirjVjjGk6jvoEslDoe90Zfl2Z4oz
	 r3HoF8YbbXcYyZcXZKR+YK4LzaCjxIe7dVMGSFw37/fHX4JBnKm7P8DPHoSpiOpsvo
	 isPW2pwpOmiJbXT/QCPUmNgKs8fjWnlGFeru8TF3k2J49KiGaOn3Lzdcr2xEundrs8
	 PgxomivVexSRDZKME60JtVvbTZklN4Q8RQ9KcBQ1N94zA/V8KMc9C1BIiK7fjSX/tO
	 qoHVwMcO2KdJJGjU0OQOOnOZ8TMSSi9ELp0vqg0FOFnghhPH4BME9lFeOjE5KNYHIx
	 PPVKDB/J8eo5Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 9/9] scsi: Enable async shutdown support
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Danilo Krummrich" <dakr@kernel.org>, driver-core@lists.linux.dev
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "John Garry" <john.g.garry@oracle.com>, linux-kernel@vger.kernel.org, "John
 Meneghini" <jmeneghi@redhat.com>, Maurizio <mlombard@redhat.com>, "Bjorn
 Helgaas" <helgaas@kernel.org>, "Jeremy Allison" <jallison@ciq.com>, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, "Laurence
 Oberman" <loberman@redhat.com>, "Stuart Hayes" <stuart.w.hayes@gmail.com>, "Bart
 Van Assche" <bvanassche@acm.org>, "Pasha Tatashin" <tatashin@google.com>, kexec@lists.infradead.org, "Ewan
 Milne" <emilne@redhat.com>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Tarun
 Sahu" <tarunsahu@google.com>
In-Reply-To: <20260917163744.191748-10-djeffery@redhat.com>
References: <20260917163744.191748-1-djeffery@redhat.com>
 <20260917163744.191748-10-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 16:58:04 +0000
Message-Id: <20260917165804.AF6C01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Like scsi's async suspend support, allow scsi devices to be shut down
> asynchronously to reduce system shutdown time.
>=20
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917163744.1917=
48-1-djeffery@redhat.com?part=3D9

