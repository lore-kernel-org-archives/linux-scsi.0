Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6BD4F4CE7;
	Thu, 17 Sep 2026 16:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663487; cv=none; b=tzq9neaWwVdVFc7pFYcySqScrze2l26aq9hPk96uwjwWhyohj7R5c0AGDfw1dId4klpNnXBoq9Vnhs5lopiUEZF5GNjn4bVpzdWWsNwqYzxopVcFT9opFOzYEbVf9C182PXXBvyO71pNXRlF+CA4P7ISyvGX0nK58BR0peyeXmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663487; c=relaxed/simple;
	bh=j35S9BqjED3DXK80YNuG2xcjHjQkfgWTqarprSit8bs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lKzpJ0WkM6wcEUwZPgPRcaGerI0qeMWi6L0fkqwplqGLaEPBhxwes9hYymhz0+0xfb6o8jw7VytuMTbR/6aVmXNyljuZmTrhW9ikbeVTCFIfnsbrx3QCmWV1/m9ddsMfWAtyHZwl7uGydY/Z2pE5JmkIfyQIMG8r9O5PWMBYUhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DEgVBFWj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DEgVBFWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74B31F000FF;
	Thu, 17 Sep 2026 16:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663485;
	bh=j35S9BqjED3DXK80YNuG2xcjHjQkfgWTqarprSit8bs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DEgVBFWjGVZOuLmeBpsF64cigsQnYZicpnGPLYOtmGhG5RViws6klzpRD6+GxaFlv
	 o7gvGsbSDyCHUNMNN4oB/RRWEW10DKtDX906ysd3WYqCUuWYmFCwUY0UwErGsZOs22
	 ztLnQgueG4omPERZB+NC2z3k/uur2NPCvwY5D8z9h01gm86r9YReC99Nox7g/4ksVu
	 Jv8spXAwPNiRnuZyStNONeOsDXVonnsHLl7Gbp0kZPI12pXtwheSSmEo6Im0wl18N6
	 rWW7OLjnWL2gI4JlzEmuHGKMmM74grpPQ7QpljD919D9pXYiU2qgipBYbkzvy6DgO3
	 sxku3oVoVVuAg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 7/9] PCI: Link a virtual function to its physical
 function
Reply-To: sashiko-reviews@lists.linux.dev
To: driver-core@lists.linux.dev, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "David
 Jeffery" <djeffery@redhat.com>, "Danilo Krummrich" <dakr@kernel.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>
Cc: "Bjorn Helgaas" <helgaas@kernel.org>, Maurizio <mlombard@redhat.com>, kexec@lists.infradead.org, "Ewan
 Milne" <emilne@redhat.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "John
 Meneghini" <jmeneghi@redhat.com>, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, "Bjorn
 Helgaas" <bhelgaas@google.com>, "John Garry" <john.g.garry@oracle.com>, linux-kernel@vger.kernel.org, "Bart
 Van Assche" <bvanassche@acm.org>, "Tarun Sahu" <tarunsahu@google.com>, "Jeremy
 Allison" <jallison@ciq.com>, "Stuart Hayes" <stuart.w.hayes@gmail.com>, "Laurence
 Oberman" <loberman@redhat.com>, "Pasha Tatashin" <tatashin@google.com>
In-Reply-To: <20260917163744.191748-8-djeffery@redhat.com>
References: <20260917163744.191748-1-djeffery@redhat.com>
 <20260917163744.191748-8-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 16:44:44 +0000
Message-Id: <20260917164444.B74B31F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> With a PCI virtual function having the same bus for its parent
> as the physical function it is associated with, there is no
> explicit dependency between the two in the device tree. With
> async shutdown, this can result in the PF being shutdown before the
> VF has an opportunity to shutdown.
>=20
> Link the VF as a consumer of the PF to note its dependency and
> ensure clean shutdown ordering.
>=20
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> Signed-off-by: David Jeffery <djeffery@redhat.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917163744.1917=
48-1-djeffery@redhat.com?part=3D7

