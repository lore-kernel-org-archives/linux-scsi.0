Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794918372;
	b=eVPboY87WER3fAs43QnxxMfX805b3rM/D+H2fsyyZsMZ7NALs3kBLRXcBY0+FX5Nf5zs
	 /Qc92yGYicAvvD4XdfwAimI3Qy0SgiRl2b+5HO0zVhp3yZEblmLCdCEFWu4jVyq8JO4oQ
	 cYeXmb5NenSNZxKWa9mk4J8dXslU9tR6eyazrirU78TmELe9A63AIMUbi7ydDyB1/kDwd
	 +mUogZarr1HTEkIS6BM959pDgy7TffEHEYWGZ4/F02XuK+K/8Mmkrepi1A+n0GGNyHmKB
	 RUIkHJHDFnB/Vbl160U1gGsWzRWDrUU0FU6Q8iiRS85b4K9nhVBhOOaqcSjddUrSoCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794918372;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=IxmyzYA+9luc/wDXbCQmmtp6FwQZD6abU4fHt1J+Ma0=;
	b=EonoKmVBiXVTOwlMV7eY+8OuI/UJ08IdAo5K81rdIdcmwgSXxOrIP5rfYcoynqJziqAY
	 +XCFnxBKFe0y039jNs7/eRpUWrBzKa3vHnKiSccvxInsUMiSFr87jeg4HRG/1XJRQdulv
	 aPJP4bnVRnqTVtQsfd1iPuvsWCdoMAdp8BybrFP4dL7CDY8ULYBlkqAi7cZHOQGE8CiHY
	 7zvp8fCHqJX1f4+fgSsyvsijPc/nMQpyyuxd7V+Nc6kjNfnNraN26hr7tSfm8lDPQoZMY
	 JluPTD9RQLRJ7chBrV5KtBKFNJh0pRMErDFbQMsbfhihG6yQV6NEYmnyg2Jd+PKHeUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UxlWymt8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFBB606A337;
	Tue, 17 Nov 2026 12:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UxlWymt8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9071F000C4;
	Tue, 17 Nov 2026 12:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794918371;
	bh=IxmyzYA+9luc/wDXbCQmmtp6FwQZD6abU4fHt1J+Ma0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UxlWymt8Cci2GQ+NGdG2E5BFy6GiLd/JCkjS40M/LAPfRnbfAzVdkpweI1ZVXHyyN
	 GgsyNqdq67Bj0RdIqNobJ4vZOAuaDMxmnnySaO2409W9dlHWMXkPOFK2TMJ3V2B4nJ
	 63I7gI4Ditlr9cz/pqrVyXHcKSqDPGYayHWqBcUGPJItMkuJt+sNLPLPM3J8mC6kIN
	 BstaiBzR/w2qEqaAuYqFvYC9YBBDFo0eRgaUKuwg1S7WqmhDhMPYCFu1vUTIhqojwB
	 myHKpPvLgggvL7qVAHzIkxe9hb5Z+G0zspQk8yzv1Swjsfafa/2QKk4FsbikiVpd/N
	 qat+5az0KWEnA==
Date: Tue, 17 Nov 2026 13:26:07 +0100
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, stable@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_ioctl: require write access for the
 depopulation commands
Message-ID: <avxH3yik-Dmu5TmP@ryzen>
References: <20261116183139.2878673-2-cassel@kernel.org>
 <037b2eab-65a0-439a-814b-cc653e8cc629@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <037b2eab-65a0-439a-814b-cc653e8cc629@kernel.org>

On Mon, Nov 16, 2026 at 12:40:36PM -0800, Damien Le Moal wrote:
> On 11/16/26 10:31, Niklas Cassel wrote:
> > scsi_cmd_allowed() lets anybody who can open a SCSI device, even
> > read-only, send any SERVICE ACTION IN(16) command. Besides READ
> > CAPACITY(16) and the other read-only service actions, that opcode also
> > carries the storage element depopulation commands of SBC-4: REMOVE
> > ELEMENT AND TRUNCATE, RESTORE ELEMENTS AND REBUILD and REMOVE ELEMENT
> > AND MODIFY ZONES. These change the capacity of the device, and after
> > REMOVE ELEMENT AND TRUNCATE the contents of the user data area may have
> > no relation to what they were before.
> 
> Since that is basically reformatting the drive, I thing we can say that the
> content is likely gone...
> 
> > SCSI devices that support depopulation execute these commands directly,
> > and libata translates them to the equivalent ATA commands, so a user
> > with read-only access to the device node can truncate the device through
> > SG_IO, SCSI_IOCTL_SEND_COMMAND or bsg.
> > 
> > Treat these service actions like FORMAT UNIT and ERASE, which also
> > destroy data, and only allow them if the device is opened for writing.
> > The other SERVICE ACTION IN(16) service actions remain allowed for
> > everybody who can open the device.
> > 
> > Cc: stable@vger.kernel.org
> 
> Hmmm... SAI_REMOVE_ELEMENT_AND_TRUNCATE and friends was defined with
> 2a0adbb80a2f ("scsi: define depopulation capabilities related service actions"),
> which is in 7.3 only.
> 
> So maybe make that
> 
> Cc: stable@vger.kernel.org #7.3
> 
> ?

I will add:

Cc: <stable@vger.kernel.org> # 2a0adbb80a2f: scsi: define depopulation capabilities related service actions

to show the dependency as per Documentation/process/stable-kernel-rules.rst

because, while for SATA devices, this problem only exists since v7.3,
for SAS, this problem is much older.

REMOVE ELEMENT AND TRUNCATE was introduced in SBC-4 (r10) - released on
January 21, 2016.

REMOVE ELEMENT AND MODIFY ZONES command was introduced in ZBC-2 (r07),
around 2020.


Kind regards,
Niklas
