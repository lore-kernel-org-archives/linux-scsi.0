Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948224BEE32;
	Sat, 12 Sep 2026 11:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212066; cv=none; b=ABFIAGJV7cK3Sdj/BkmW2r/y/xizlFqdp5nH53Kl8JbZMs9fm1bFy5Am7MtvYEbGHXOZHo4sv2eiO0WfUUASifdqlhknWjqfwone1WHknlvD5iy8/CNXXq8JRNB+PZFfHNNmZSRLToYVB/Ao2g5/Gq23bE2dE5luTBnOfWHcCVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212066; c=relaxed/simple;
	bh=C+Am4wWyRZWkCJzSxMTfxEVDuvTMtFNGm5gvUiXFpTY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=d2hRu5uSUdCTCgRvAPAfrlqa3U6mAiCAP7wToUuEEJXYzmftir0QsKIVn7Xyl+vEccEVUAQazWyCRwJAzOe7QR+pUL3qH1lzlGQYwyc/rEheiSEnKz9Gn47Ie7iRqOpkqJHCiMjQrcu2qt8jWTjtAC97tgbJnr4/sgJh9iz1Nyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iV09A33W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iV09A33W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E4A1F00899;
	Sat, 12 Sep 2026 11:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789212064;
	bh=C+Am4wWyRZWkCJzSxMTfxEVDuvTMtFNGm5gvUiXFpTY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=iV09A33WC7aStPTKmzQvLa5iXwGtPWw8W0q4zNblm5kDIZIiIHbjUwqaYPu932UMP
	 +KUdbxLOduuBadcQUDacJi8PxlVP2Ybtf24eGWEpYSYLNxgGg76NIoQtFKfVIIRalL
	 m6p+eWyVqyQA5S5HKvjRPOjgI/1o6XImcdX/pDssr0X5Kwlt/KnKCi/NcNPp0JdlUS
	 65Hs84AjKXmlL10GPF29BOvuzeCAAwsP28Mzsy/Wvvl1vIQVC67EuI/ohYy80pBO1b
	 E/j+dDd+QfKUsfN9/qISObcdxzzl2tDWZzvZOUNHKkr0CCFFIg+ZvsjrL/i7YSavRF
	 pICK3nTBbFQBg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Bean Huo <beanhuo@iokpp.de>, jaemyung.lee@samsung.com, Miguel Ojeda
 <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary
 Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>,
 Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot
 <acourbot@nvidia.com>, Onur =?utf-8?Q?=C3=96zkan?= <work@onurozkan.dev>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH RFC] drivers/rufs: add Rust UFS host controller driver
In-Reply-To: <4c38f13af8f75020fefc35827463e9bc643b99f4.camel@iokpp.de>
References: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
 <8mLXEMDMxh8mZQqVywUYUeOiZPZIPmrVGRlOkDbHptW0NEJeszKVpff5h39MjUvD5yyivwY3Z7kCXIH5VlGoiw==@protonmail.internalid>
 <4c38f13af8f75020fefc35827463e9bc643b99f4.camel@iokpp.de>
Date: Sat, 12 Sep 2026 13:20:53 +0200
Message-ID: <87jyoqvhpm.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

"Bean Huo" <beanhuo@iokpp.de> writes:

> On Sat, 2026-09-12 at 00:52 +0900, Jaemyung Lee via B4 Relay wrote:
>> From: Jaemyung Lee <jaemyung.lee@samsung.com>
>>
>> Add a Rust UFS host controller driver that exposes UFS logical units as
>> native blk-mq block devices without depending on the SCSI midlayer.
>>
>> Implement host controller setup, UIC link startup and power-mode
>> configuration, device and unit descriptor discovery, query operations, a=
nd
>> SCSI protocol command construction. Support normal read, write, flush, a=
nd
>> discard I/O with coherent UTP descriptors and owned streaming DMA mappin=
gs.
>>
>> Provide both single-doorbell and multi-circular-queue transfer backends.
>> Map shared blk-mq tags directly to UFS task tags, retain request ownersh=
ip
>> while commands are in flight, dispatch completion per MCQ completion que=
ue,
>> and return polled completions through the blk-mq completion batch.
>>
>> Add PCI and Qualcomm platform frontends. The PCI frontend supports the Q=
EMU
>> UFS controller and existing Intel and Samsung IDs. The Qualcomm frontend
>> provides the clocks, PHY, reset, interconnect, power-domain, OPP, GPIO, =
and
>> controller-specific initialization needed by supported SoCs.
>>
>> This establishes normal-I/O support for UFSHCI single-doorbell and MCQ
>> controllers. Full timeout recovery, error handling, and power management
>> are left for follow-up work.
>>
>> Signed-off-by: Jaemyung Lee <jaemyung.lee@samsung.com>
>> ---
>> This RFC introduces RUFS, a UFS host controller driver that sits directly
>> on the block layer and does not use the SCSI midlayer. UFS logical units
>> are exposed as native blk-mq block devices, the same way NVMe namespaces
>> are. The driver is written in Rust.
>>
>> Why decouple UFS from SCSI
>> --------------------------
>>
>> The existing UFS driver is built on the SCSI subsystem. That made sense
>> historically: UFS adopted the SCSI Architecture Model as its application
>> layer, so reusing the SCSI midlayer's command queuing, error handling,
>> power management, and logical-unit addressing let UFS reach Linux quickly
>> and reliably. ufshcd bridges the SCSI midlayer to UFS Protocol Informati=
on
>> Units.
>>
>> That foundation has become a source of friction. The evolution of UFS is
>> governed by JEDEC and increasingly includes UFS-specific features outside
>> the SCSI command set standardized by T10. These features must still be
>> expressed through, and constrained by, a SCSI-shaped driver. Features th=
at
>> are meaningful only to UFS are difficult to land in a subsystem whose
>> maintainers reasonably want to keep SCSI focused on SCSI, and block layer
>> or shared infrastructure changes that UFS needs end up mediated through
>> SCSI's priorities. In practice UFS is treated as an add-on to SCSI rather
>> than as a first-class storage interface, and a significant amount of UFS
>> functionality lives off-tree as a result, with the back- and forward-
>> porting cost that implies.
>>
>> We propose to decouple UFS from SCSI with a standalone driver that sits
>> directly on the block layer, alongside drivers like NVMe. This lets
>> JEDEC-specific features evolve independently of T10, gives UFS
>> its own dedicated review surface, and removes the impedance mismatch
>> between the UFS data model and the SCSI command model. UFS uses a subset=
 of
>> the SCSI command set within command UPIUs, so the driver can construct t=
he
>> required CDBs directly without depending on the SCSI midlayer.
>>
>> The driver is designed around the UFS and UFSHCI specifications rather t=
han
>> as a line-by-line translation of ufshcd. Its target is JEDEC UFS 4.1 and
>> UFSHCI 4.1.
>>
>> Why Rust
>> --------
>>
>> The architectural question above would be the same for a C driver. We ch=
ose
>> Rust because UFS features arrive at a high pace, and turning new
>> specification features into stable, validated code on tight timelines is
>> where memory- and concurrency-safety guarantees pay off: fewer classes of
>> bugs reach production, and iteration is faster. Rust's growing acceptance
>> in the kernel makes a block-layer-native UFS driver a realistic
>> architecture to evaluate.
>>
>> Initial feature set
>> --------------------
>>
>> The new driver supports single-doorbell and multi-circular-queue operati=
on,
>> PCI and Qualcomm platform frontends, logical-unit discovery, and normal
>> read, write, flush, and discard I/O. It uses shared blk-mq tags as UFS t=
ask
>> tags, keeps request ownership through completion, and uses owned DMA
>> mappings for the complete I/O lifetime.
>>
>> Full timeout recovery, error handling, and power management remain
>> follow-up work.
>>
>> Patch layout and dependencies
>> -----------------------------
>>
>> The single patch contains the complete driver. This keeps review focused=
 on
>> the RUFS architecture and the SCSI-independent blk-mq model.
>>
>> The driver depends on Rust block, DMA, IRQ, and platform abstractions th=
at
>> are intentionally excluded from this posting. Some of these abstractions
>> have already been posted to the list, most notably in the Rust null block
>> driver v2 series, the Ownable/OwnableRefCounted page series, and the
>> impl_flags extensions. The remaining abstractions are new and will be
>> posted as separate series before the first non-RFC version of this drive=
r.
>>
>> A buildable tree based on v7.3-rc2 with all dependencies and this patch =
is
>> at:
>>
>> https://github.com/SamsungDS/rufs/tree/rfc/rufs-public
>>
>> Testing
>> -------
>>
>> The v7.2 development version has been exercised with SDB and MCQ on the
>> QEMU UFS model, including ext4 fio workloads and module load/unload cycl=
es.
>> SDB probe and normal I/O have also been exercised on Intel PCI and Qualc=
omm
>> UFS hardware. The current port has been compile-tested independently with
>> PCI-only and Qualcomm-platform-only configurations.
>>
>> The exact v7.2 tree used for the hardware measurements is available at:
>>
>> https://github.com/SamsungDS/rufs/tree/rufs-7.2
>>
>> On Intel UFS 2.1 hardware, 4 KiB direct io_uring at QD32/job gave
>> these optimized-mode ranges over 1/2/4 jobs (three samples):
>>
>> =C2=A0 Workload=C2=A0 Op=C2=A0=C2=A0=C2=A0=C2=A0 RUFS kIOPS=C2=A0=C2=A0 =
C kIOPS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Difference
>> =C2=A0 --------=C2=A0 -----=C2=A0 -----------=C2=A0 -----------=C2=A0 --=
-------------
>> =C2=A0 randread=C2=A0 read=C2=A0=C2=A0 48.91-61.26=C2=A0 41.56-41.60=C2=
=A0 +17.6% to +47.4%
>> =C2=A0 randwrite write=C2=A0 8.19-8.30=C2=A0=C2=A0=C2=A0 8.21-8.22=C2=A0=
=C2=A0=C2=A0 -0.4% to +1.1%
>> =C2=A0 randrw=C2=A0=C2=A0=C2=A0 read=C2=A0=C2=A0 5.26-5.34=C2=A0=C2=A0=
=C2=A0 5.28-5.38=C2=A0=C2=A0=C2=A0 -0.9% to -0.4%
>> =C2=A0 randrw=C2=A0=C2=A0=C2=A0 write=C2=A0 5.27-5.34=C2=A0=C2=A0=C2=A0 =
5.29-5.37=C2=A0=C2=A0=C2=A0 -0.8% to -0.5%
>>
>> The coefficient of variation (CV), calculated as the sample standard
>> deviation divided by the sample mean, measures run-to-run variability
>> relative to the mean. CV is a descriptive statistic; no normal or other
>> distribution was fitted to model the variation. The accompanying
>> two-sided 95% confidence intervals for the mean used Student's
>> t-distribution because each point contains only three samples. Those
>> intervals assume independent, approximately normally distributed sample
>> means and should be interpreted cautiously at this sample count.
>>
>> RUFS randread had a CV of 28-57%, versus below 0.8% for C. Its apparent
>> gain therefore has low confidence and should be treated as preliminary.
>> Both drivers also logged platform UIC errors. Stable write and mixed
>> points differed by no more than 1.1%.
>>
>> Feedback
>> --------
>>
>> Comments on the decision to bypass the SCSI midlayer, the blk-mq model u=
sed
>> in its place, and the proposed prerequisite API boundaries would be
>> especially welcome.
>
> Jaemyung,
>
> thanks sharing.
>
> You still use scsi everywhere in your implementation protocol/scsi.rs bui=
lds
> READ_10/16, WRITE_10/16, SYNCHRONIZE_CACHE and UNMAP CDB, so "decouple UF=
S from
> SCSI" really means "copy a small part of sd and the SCSI error handling i=
nto a
> UFS driver." while JEDEC defines the UFS application layer as SCSI, the S=
CSI
> work doesn't go away, you just move somewhere else, and it has to be writ=
ten
> again.

See my response to Greg. The SCSI specific code in this driver is very
minimal.

>
> The "friction" claim is weak. SCSI has already been changed to fit UFS. T=
wo
> examples: UFS now uses SCSI simple copy, group number in scsi write comma=
nd.
>
> I doubt how far this can go. do we really need to pay effort for a new RU=
ST UFS
> driver, I am not very confident, unless SCSI is removed from the UFS spec=
 and
> JEDEC defines native UFS commands, or we talk to the device directly with=
 UPIU.
> please name the JEDEC feature that the SCSI midlayer really blocked, or t=
hat was
> historial issue which has been fixed.

I am sure the UFS experts will be able to answer this better than me.

> I would also like to see the heavy and hard parts, because they are the p=
arts
> that decide if this design worrks:
>
> 1, error handling: abort, LU reset, retries with limits, sense decoding, =
this is
> the very hard part of UFS driver.

I agree. However, we decided to get the discussion going with a smaller
feature set. We can build an efficient feature complete driver, but we
would really like to talk to the community about it first.

> 2, user-space tools interface: SG_IO and bsg (sg3_utils, ufs-utils, FFU w=
ith
> WRITE BUFFER), and the UFS sysfs tree..

On the account of this not being a scsi driver, some changes would have
to be made. But we should be able support
/sys/bus/platform/drivers/ufshcd/* just fine.

> Did any AI tool help write this code? If so, please add the Assisted-by: =
tag.

We use AI for code review and spell checking, so I guess the tag is warrant=
ed.

Best regards,
Andreas Hindborg

