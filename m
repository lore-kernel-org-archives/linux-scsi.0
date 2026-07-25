Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7810732B135;
	Sat, 25 Jul 2026 15:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784994052; cv=none; b=R1N/yV6AiAiTbuXRE7g9+RBwEXEoz5o+R1ktiBXE8Kj5cYeyDqsaReSWFL20qYDF2/nII96tmkq5Ato3uhA16sZlg8ofswM7xb2kR2IsED/oU9KVmuVkrTgkPhz1tQ5jYrCD504o5Vq2BfUMKcldNN8oqj+zfCFPq86btVyf0RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784994052; c=relaxed/simple;
	bh=rbI7JfzH8/Z3rTxnubhC5UNZdAt9heHgiDgx8XRhTuE=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Subject:Cc:To:
	 References:In-Reply-To; b=RCca/ML5h0OtN9LYtD01CYTm9KG7kt8ges9c/yFRiwvzxzTko2LDvIwmbLTjzLNldeddBpmDnZiznxWY5229CLu4gfDfxaNswFURLLQ+Rw1Rn+SiSsvdyiVNB16sCoi1Er5A4EN1YfOd5sd3zz0Z4e4Q00K0gDXZVlTJFsqQYfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WJcyKBAm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WJcyKBAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32731F000E9;
	Sat, 25 Jul 2026 15:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784994047;
	bh=AVKIqDLaRJbWnwleOfdrA62Ss8E5oUijw4SSgsugB30=;
	h=Date:From:Subject:Cc:To:References:In-Reply-To;
	b=WJcyKBAmndl0QTaMHgQzStmh2LqdjdYH5aHzLFotx1+w63A678Lq11jVOtTjr3Tyh
	 CisBSahLmQ1zuxxBSee6AnUeOapTVkgILUhAB8mBrCEifApcKUVj34WRHVEYk/nksv
	 Wek70ZJDAdkmqYol+w7lZigtGxUv4uy4TtKoE3LFBiZL2+KH0yyN7VRI8FgiByuq/V
	 j/ngHgk/3+si8L4KyMos8lhTskEHhuhjWjGtAq2OijlFodWHmCgvosiaCqMSmBIOme
	 PdEnAnb6KPBKHHCfBh96ODVo36Tf0JNT6ev9C475g7+3W4V/Ml8dUNcBotREqDS84P
	 oEvdnYre7X4RA==
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 25 Jul 2026 17:40:40 +0200
Message-Id: <DK7RKTMA6TVC.11YQWH2H4VB74@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v4 7/9] PCI: Make pci_match_one_device() match on ID
 instead of device
Cc: "Bjorn Helgaas" <helgaas@kernel.org>, "Bjorn Helgaas"
 <bhelgaas@google.com>, "Zhenzhong Duan" <zhenzhong.duan@gmail.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J. Wysocki"
 <rafael@kernel.org>, "Damien Le Moal" <dlemoal@kernel.org>, "Niklas Cassel"
 <cassel@kernel.org>, "GOTO Masanori" <gotom@debian.or.jp>, "YOKOTA Hiroshi"
 <yokota@netlab.is.tsukuba.ac.jp>, "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, "Vaibhav Gupta" <vaibhavgupta40@gmail.com>,
 "Jens Taprogge" <jens.taprogge@taprogge.org>, "Ido Schimmel"
 <idosch@nvidia.com>, "Petr Machata" <petrm@nvidia.com>, "Andrew Lunn"
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, "David Airlie" <airlied@redhat.com>,
 <linux-pci@vger.kernel.org>, <driver-core@lists.linux.dev>,
 <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
 <linux-scsi@vger.kernel.org>, <industrypack-devel@lists.sourceforge.net>,
 <netdev@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
To: "Gary Guo" <gary@garyguo.net>
References: <20260723-pci_id_fix-v4-7-3580726844e1@garyguo.net>
 <20260724222939.GA1065077@bhelgaas>
 <DK7N9IZPWPIT.2AKSZR5CU1H9L@garyguo.net>
In-Reply-To: <DK7N9IZPWPIT.2AKSZR5CU1H9L@garyguo.net>

On Sat Jul 25, 2026 at 2:17 PM CEST, Gary Guo wrote:
> On Fri Jul 24, 2026 at 11:29 PM BST, Bjorn Helgaas wrote:
>> On Thu, Jul 23, 2026 at 11:00:46PM +0100, Gary Guo wrote:
>>> PCI dynamic ID needs to match IDs against a new ID to see if it already
>>> exists. Existing APIs can only match IDs against devices, causing the
>>> dynamic ID insertion code to create a temporary device only for matchin=
g
>>> purpose. Rename pci_match_one_device() to pci_match_one_id() so it can =
be
>>> used for this purpose instead; add a pci_id_from_device() helper to mak=
e it
>>> easy to convert users.
>>
>> s/causing the ... code to create/so the ... code creates/
>> s/purpose/purposes/
>>
>>> Similarly, convert pci_match_id() to do_pci_match_id(). But keep the
>>> existing API because there are many users.
>>>=20
>>> Reviewed-by: Danilo Krummrich <dakr@kernel.org>
>>> Signed-off-by: Gary Guo <gary@garyguo.net>
>>
>> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
>> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
>>
>> What's the merge strategy?  If these all need to be merged together,
>> feel free to include the PCI patches whereever you merge the series.
>
> I think the series should be merged together, as I consider the driver ch=
anges
> included in this series being "fixing the users".
>
> The series should probably be taken via the PCI tree. I suppose one can a=
lso
> argue that the lifetime issue with device IDs isn't unique to PCI bus so =
this
> can also be considered driver-core material, but given that Greg has alre=
ady
> taken the USB fixes via the USB tree the only unfixed bus left is PCI.
>
> So unless Danilo thinks otherwise I'd suggest the series be taken as a wh=
ole via
> PCI.

I'm happy to take it through driver-core if it helps, but the PCI tree seem=
s to
be the natural fit. :)
