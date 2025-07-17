Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29097262D
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2025 21:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752787788; cv=none; b=b4435J/w8aBvtI12BgKGN9bNizn1X6DvMyyg8elfz+cRBMxYXU2dWGHQCqi91jTmmlX+BjQknnGuUlwsyxdfQ6DAjDGO+VgyhdTmZz/g+Qy4cam4oCgO9FMRq8uMClW3MHMx47wZCLB5KtNtE7xy1ygCqODdYwq1jKkctzHBc4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752787788; c=relaxed/simple;
	bh=SKQN69A+rX0upVdihRH/sbw47tK/e71NSvMMIRIRETM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=lx+X69hnSDukJkxQSlp6Ei/2z/NPraSLpT0dk41COLe4DucojRYjGgqELVSJr03tW4/qKjT4iQ74kWUUdFg+FOTdCMhtNTHa6+6jlXyga2Uizd4m/O+x2YOBtLWshdUJhdW/0zBC5TnxCCRCg2lR4CuXKWwpmlYZdB3qi4wqAHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pdnpw2H1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pdnpw2H1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A189C4CEE3;
	Thu, 17 Jul 2025 21:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752787788;
	bh=SKQN69A+rX0upVdihRH/sbw47tK/e71NSvMMIRIRETM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=Pdnpw2H1oqvnp97bOmBJVragg0XPMxAkw5zUTpucykLZ15EaWRa2e+grt6WHdNphY
	 fUSuEdU2TbVKbP4ebgx7MhbrOpi4GhMy8uCufrvS1YXoYZL/Jr/Dd/c7BU7jM2/SCS
	 tVhc5W/wta3KOSwka8gZ/Ba38T/rNBCEk3cNonPuI4iSyUWHJBW1QmkZ7I+6WDwVtn
	 k7wwZZfTZnLHKxddWYpShHHj0uDvFG2P5nP5kQ+8vknb5Y6Ah/UGV7oo4XklUaPBUJ
	 VrC6Dj0SXP1E1PxAsZjZM4RkA/8cv1//Q8XjP7fM7TP+Ya+4bF3UE9naP0OHE+piZ3
	 YE911a6rOWG2A==
Date: Thu, 17 Jul 2025 23:29:47 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Igor Pylypiv <ipylypiv@google.com>
CC: Jack Wang <jinpu.wang@cloud.ionos.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Terrence Adams <tadamsjr@google.com>, Damien Le Moal <dlemoal@kernel.org>,
 linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Revert "scsi: pm80xx: Do not use libsas port ID"
User-Agent: Thunderbird for Android
In-Reply-To: <aHlpNRsPbmrTgv0O@google.com>
References: <20250717165606.3099208-2-cassel@kernel.org> <aHlpNRsPbmrTgv0O@google.com>
Message-ID: <C0AF6A34-23E3-46D0-BDA6-D6EE9F864E83@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello Igor,

On 17 July 2025 23:20:53 CEST, Igor Pylypiv <ipylypiv@google=2Ecom> wrote:
>On Thu, Jul 17, 2025 at 06:56:07PM +0200, Niklas Cassel wrote:
>> This reverts commit 0f630c58e31afb3dc2373bc1126b555f4b480bb2=2E
>>=20
>> Commit 0f630c58e31a ("scsi: pm80xx: Do not use libsas port ID") causes
>> drives behind a SAS enclosure (which is connected to one of the ports
>> on the HBA) to no longer be detected=2E
>>=20
>> Connecting the drives directly to the HBA still works=2E Thus, the comm=
it
>> only broke the detection of drives behind a SAS enclosure=2E
>>=20
>> Reverting the commit makes the drives behind the SAS enclosure to be
>> detected once again=2E
>>=20
>> The commit log of the offending commit is quite vague, but mentions tha=
t:
>> "Remove sas_find_local_port_id()=2E We can use pm8001_ha->phy[phy_id]=
=2Eport
>> to get the port ID=2E"
>>=20
>> This assumption appears false, thus revert the offending commit=2E
>
>Thanks for bisecting and reverting the commit, Niklas!
>
>Let me review the changes and send a proper fix that takes into account
>drives behind a SAS enclosure=2E I would appretiate if you could test tha=
t
>new fix since I don't have a setup with a SAS enclosure=2E

Of course, I would gladly help with testing :)


Kind regards,
Niklas


