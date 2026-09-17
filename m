Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0544EB87A
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 16:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661414; cv=none; b=MesUnRCfQayuFsVRWGb9SysIwbdzwbpJV8Q82D7sTmMo68IFNhRMgHk+izYi6w3EZ4n7oMzIF6E545VlMZtOLXfBq6QD6OvIcJM5ERsFGRVT+z226fV/u/VUd+CX7ZSinuzp6tLBCH+MhgRkfcJFRgpMCSsEMbJlT6Zj9x5xTfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661414; c=relaxed/simple;
	bh=owbv1hLluLgQU+qnuH7tTEN5FlGQriokZexetjGrX7s=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=ZXFU5Tc5CbbYa485S/XfGOI1/5PMsIMmCt4J552CrOTXM/N2GgeBoWY6qzwSFg3mjX84Id2IvubdKAv5xrviMLJm9tgdZiLtRYALVZnUJLSmU8EHfLHewPziEdaCjY0ugfXFigndzoQ95CmyquUNN7nipuAUSBnBkZ2WzWY7HvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cKhjxcGl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cKhjxcGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B711F000FF;
	Thu, 17 Sep 2026 16:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789661413;
	bh=owbv1hLluLgQU+qnuH7tTEN5FlGQriokZexetjGrX7s=;
	h=Date:From:To:CC:Subject:In-Reply-To:References;
	b=cKhjxcGlBvLALsntglX/hKl8870f8qmFwADt5u6gefdm0XEeT9c3rCY02rP7iBACT
	 o3wY9Mxcd/LG2FcS37eq9tNIyo42h9qYSXx25sy3AW4xb/zTBY8jJksQ5LRCG6L17k
	 gVvqFNEaCJSm/WOnIuOX5CLaeIRXIGSTnBc54tQ2u7X9+InYHKZilRvozvbW5+OYCb
	 6bQsTIfn4nb/5mYNwBfXcmEXLmiTfaWZDx7Bzx0zmBkrp9Hv67kUgK4tEpeQBViMo5
	 LI0v7IrNFvi6TBfgOamd7gpXO5XlQJ9SvL+qM5STqWmSrFkHZqJOMIQepMgZLfC+rI
	 D1Aq7Kyq3wVCA==
Date: Thu, 17 Sep 2026 18:10:11 +0200
From: Niklas Cassel <cassel@kernel.org>
To: John Garry <john.garry@linux.dev>
CC: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_2/2=5D_scsi=3A_scsi=5Fdebug=3A_Vali?=
 =?US-ASCII?Q?date_zone_access_for_WRITE_ATOMIC_=2816=29?=
User-Agent: Thunderbird for Android
In-Reply-To: <35ad0b9c-06bb-4ccd-8e58-fde4d859b85e@linux.dev>
References: <20260917084553.559765-4-cassel@kernel.org> <20260917084553.559765-6-cassel@kernel.org> <f1c5db8b-2c99-4c5f-bb1a-3da8f2c5413b@linux.dev> <aqu5Q_6EvfY7iRmk@ryzen> <0acc0a4d-b532-4f69-8fcc-1d4eef7549c0@linux.dev> <aqvCeq9IsbjSJIEx@ryzen> <35ad0b9c-06bb-4ccd-8e58-fde4d859b85e@linux.dev>
Message-ID: <3709D24B-4D27-44CC-92C5-59DC66309931@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello John,

On 17 September 2026 17:42:28 CEST, John Garry <john=2Egarry@linux=2Edev> =
wrote:
>On 9/17/26 11:35, Niklas Cassel wrote:
>> On Thu, Sep 17, 2026 at 11:26:45AM +0100, John Garry wrote:
>>> On 9/17/26 10:56, Niklas Cassel wrote:
>>>> On Thu, Sep 17, 2026 at 10:38:30AM +0100, John Garry wrote:
>>>>> On 9/17/26 09:45, Niklas Cassel wrote:
>>>>>=20
>>>>> So far we have not considered atomic writes for zoned devices
>>>>> - do devices which support both technologies exist? Or is
>>>>> this just hypothetical?
>>>> If the specs allow it, someone might build it=2E
>>>=20
>>> Sure, but do they (allow it)? atomic writes have specific
>>> alignment and granularity rules - how does that play with
>>> zoned devices?
>>>=20
>>> I would need to check the specs more on this=2E=2E
>>=20
>> I haven't been able to find anything that disallows it=2E
>>=20
>> Trying to parse the specs with the help of LLM:
>>=20
>> ""
>> WRITE ATOMIC (16) is a write command as far as ZBC is concerned, so on =
a
>> zoned device it is subject to the access requirements of the zone that =
it
>> addresses, and it advances the write pointer of a sequential write
>> required zone=2E
>> Neither standard says so directly, but the definitions leave no room fo=
r
>> anything else=2E SBC-6 r02 defines an atomic write operation as a "proc=
ess
>> by which a device server performs a write operation that is either
>> completed in its entirety or has no effects on stored logical block
>> data" (3=2E1=2E9), and an atomic write command as a "command that perfo=
rms
>> one or more atomic write operations" (3=2E1=2E8)=2E ZBC-3 r06 in turn d=
efines
>> a write operation as a "write operation as described in SBC-5 with the
>> additional requirements described in this standard" (3=2E1=2E62), and a
>> write command as a "command that requests write operations" (3=2E1=2E61=
)=2E
>> WRITE ATOMIC (16) therefore falls under 4=2E5=2E3=2E3=2E2 Write access =
pattern
>> requirements for sequential write required zones, exactly as WRITE (16)
>> does=2E
>> ""
>>=20
>> Right now, I don't see why WRITE ATOMIC should not be allowed on a ZBC
>> drive=2E
>>=20
>>=20
>So what happens when the write pointer is not aligned with Atomic alignme=
nt? Are atomic writes just not permitted in that scenario?


You are the expert when it comes to atomic writes=2E

But I would imagine that a device that implements both WRITE ATOMIC and ZB=
C
would set the atomic alignment to the physical block size=2E

That way the write pointer in sequential write required zones would always=
 be aligned to both=2E

I/Os too larger than MAXIMUM ATOMIC TRANSFER LENGTH could be invalid for W=
RITE ATOMIC, but could be valid for regular writes=2E

Anyway, I will probably just drop this patch when I respin, since Damien d=
id not fancy it=2E

I will keep the fix that ensures that we mark the blocks written by WRITE =
ATOMIC are marked as mapped:
https://lore=2Ekernel=2Eorg/linux-scsi/12d01f4b-4d9f-4079-908d-ede50f7a28b=
4@kernel=2Eorg/


Kind regards,
Niklas



