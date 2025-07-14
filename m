Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29EFDDC5;
	Mon, 14 Jul 2025 02:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752461457; cv=none; b=V4qrgj9YLkFO5vrm1aMs1RrdS/Ak99i3fbdUKcralXlu5gn2aQKD+9s4gCGuc4+JWFKuheqcLNTa7pOhaNEU2VI1kEQAGKW5CAWm/zb+Io9Y1LGIWsc6/rBmuYLAqr9c/ZUzMw/JZXnRM/syT4Wqg82CVGc49L4QbPAWTzbd+hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752461457; c=relaxed/simple;
	bh=MTiQu2gCfuCkj0Da/Vt0SXpxQqJ4UedMVOpHMm7iJvo=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=UdWDdXe58NC5dOYCziDtOKr1Ro8uUnnqAtjoWm7vWRNf+P/clJa0OPEM2kfRBmg++mRHi7mJ6cAevBO+B5EH4C4inoae7gXh+X8A3gCQkGcQM9fLsQ8fyzJYc4iB3URAiJ29tidhXaf6dI/8nwmBzlUeazGrit4gnItYhp+8KTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WnbAVoh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WnbAVoh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47805C4CEE3;
	Mon, 14 Jul 2025 02:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752461456;
	bh=MTiQu2gCfuCkj0Da/Vt0SXpxQqJ4UedMVOpHMm7iJvo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WnbAVoh1Onl2jy3PPITHMbzn5/kCl8PQhoknjagTDs/b2XunG4mCEwxUvI4YPJyzk
	 XWukX32jkePJXE8j6vLe0WY4k7ElbAnYU6I98TPV8fbqnSJeH48f7zsIR/oY7sDPfv
	 xJCoIWvi2FqxF39posxk0HS3Fd0YMKaDpB0F2JchRI7G4+6QWiGkgxAxtMs6IM4wVJ
	 Hi5Z4gW3c+VDgCrD+JD0sCZGskAkXctBwPROxolPvR0q/VzCYVjmGCG8SE+ioj+9iN
	 344lPUuYi/+UpTUE70IN3Wp/lbHrHF2eXemz9t0PGDaLXI2xDEXaiXAgD8H17f/zSR
	 3Aw3Tj6JALfnw==
Content-Type: multipart/mixed; boundary="------------GSF3WdoAO5xjtfrRGnJ0BjBS"
Message-ID: <3b2a6cfe-5bf3-4818-8633-c200d8e6f122@kernel.org>
Date: Mon, 14 Jul 2025 11:48:36 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/19] scsi: detect support for command duration limits
To: Friedrich Weber <f.weber@proxmox.com>,
 Mira Limbeck <m.limbeck@proxmox.com>, Niklas Cassel <nks@flawful.org>,
 Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com
Cc: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>,
 Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-block@vger.kernel.org,
 Niklas Cassel <niklas.cassel@wdc.com>
References: <20230511011356.227789-1-nks@flawful.org>
 <20230511011356.227789-9-nks@flawful.org>
 <3dee186c-285e-4c1c-b879-6445eb2f3edf@proxmox.com>
 <6fb8499a-b5bc-4d41-bf37-32ebdea43e9a@kernel.org>
 <2e7d6a7e-4a82-4da5-ab39-267a7400ca49@proxmox.com>
 <b1d9e928-a7f3-4555-9c0a-5b83ba87a698@kernel.org>
 <a927b51b-1b34-4d4f-9447-d8c559127707@proxmox.com>
 <54e0a717-e9fc-4534-bc27-8bc1ee745048@kernel.org>
 <72bf0fd7-f646-46f7-a2aa-ef815dbfa4e2@proxmox.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <72bf0fd7-f646-46f7-a2aa-ef815dbfa4e2@proxmox.com>

This is a multi-part message in MIME format.
--------------GSF3WdoAO5xjtfrRGnJ0BjBS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/10/25 5:41 PM, Friedrich Weber wrote:
> Thanks for looking into this, it is definitely a strange problem.
> 
> Considering these drives don't support CDL anyway: Do you think it would
> be possible to provide an "escape hatch" to disable only the CDL checks
> (a module parameter?) so hotplug can work for the user again for their
> device? If I see correctly, disabling just the CDL checks is not
> possible (without recompiling the kernel) -- scsi_mod.dev_flags can be
> used to disable RSOC, but I guess that has other unintended consequences
> too, so a more "targeted" escape hatch would be nice.

Could you test the attached patch ? That should solve the issue.

> 
> Best,
> 
> Friedrich
> 


-- 
Damien Le Moal
Western Digital Research
--------------GSF3WdoAO5xjtfrRGnJ0BjBS
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-scsi-mpt3sas-Disable-CDL-probing.patch"
Content-Disposition: attachment;
 filename="0001-scsi-mpt3sas-Disable-CDL-probing.patch"
Content-Transfer-Encoding: base64

RnJvbSBjOGVjNWNmNzk1NzY5MDQxOGI3ZTg4ODhlNzI5ZjAwMmY5YmM3ZDZlIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBEYW1pZW4gTGUgTW9hbCA8ZGxlbW9hbEBrZXJuZWwu
b3JnPgpEYXRlOiBNb24sIDE0IEp1bCAyMDI1IDExOjQ3OjEyICswOTAwClN1YmplY3Q6IFtQ
QVRDSF0gc2NzaTogbXB0M3NhczogRGlzYWJsZSBDREwgcHJvYmluZwoKU2lnbmVkLW9mZi1i
eTogRGFtaWVuIExlIE1vYWwgPGRsZW1vYWxAa2VybmVsLm9yZz4KLS0tCiBkcml2ZXJzL3Nj
c2kvbXB0M3Nhcy9tcHQzc2FzX3Njc2loLmMgfCAyICsrCiBkcml2ZXJzL3Njc2kvc2NzaS5j
ICAgICAgICAgICAgICAgICAgfCA0ICsrKy0KIGluY2x1ZGUvc2NzaS9zY3NpX2hvc3QuaCAg
ICAgICAgICAgICB8IDMgKysrCiAzIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9tcHQzc2FzL21wdDNz
YXNfc2NzaWguYyBiL2RyaXZlcnMvc2NzaS9tcHQzc2FzL21wdDNzYXNfc2NzaWguYwppbmRl
eCBkN2Q4MjQ0ZGZlZGMuLjYyNmM2NjUyOGJiMSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3Np
L21wdDNzYXMvbXB0M3Nhc19zY3NpaC5jCisrKyBiL2RyaXZlcnMvc2NzaS9tcHQzc2FzL21w
dDNzYXNfc2NzaWguYwpAQCAtMTE5NDMsNiArMTE5NDMsNyBAQCBzdGF0aWMgY29uc3Qgc3Ry
dWN0IHNjc2lfaG9zdF90ZW1wbGF0ZSBtcHQyc2FzX2RyaXZlcl90ZW1wbGF0ZSA9IHsKIAku
c2hvc3RfZ3JvdXBzCQkJPSBtcHQzc2FzX2hvc3RfZ3JvdXBzLAogCS5zZGV2X2dyb3VwcwkJ
CT0gbXB0M3Nhc19kZXZfZ3JvdXBzLAogCS50cmFja19xdWV1ZV9kZXB0aAkJPSAxLAorCS5u
b19jZGwJCQkJPSAxLAogCS5jbWRfc2l6ZQkJCT0gc2l6ZW9mKHN0cnVjdCBzY3NpaW9fdHJh
Y2tlciksCiB9OwogCkBAIC0xMTk4Miw2ICsxMTk4Myw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1
Y3Qgc2NzaV9ob3N0X3RlbXBsYXRlIG1wdDNzYXNfZHJpdmVyX3RlbXBsYXRlID0gewogCS5z
aG9zdF9ncm91cHMJCQk9IG1wdDNzYXNfaG9zdF9ncm91cHMsCiAJLnNkZXZfZ3JvdXBzCQkJ
PSBtcHQzc2FzX2Rldl9ncm91cHMsCiAJLnRyYWNrX3F1ZXVlX2RlcHRoCQk9IDEsCisJLm5v
X2NkbAkJCQk9IDEsCiAJLmNtZF9zaXplCQkJPSBzaXplb2Yoc3RydWN0IHNjc2lpb190cmFj
a2VyKSwKIAkubWFwX3F1ZXVlcwkJCT0gc2NzaWhfbWFwX3F1ZXVlcywKIAkubXFfcG9sbAkJ
CT0gbXB0M3Nhc19ibGtfbXFfcG9sbCwKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3Np
LmMgYi9kcml2ZXJzL3Njc2kvc2NzaS5jCmluZGV4IDUzNDMxMDIyNGU4Zi4uZTEzZDE4NmJk
MzNjIDEwMDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvc2NzaS5jCisrKyBiL2RyaXZlcnMvc2Nz
aS9zY3NpLmMKQEAgLTY0OSw2ICs2NDksNyBAQCBzdGF0aWMgYm9vbCBzY3NpX2NkbF9jaGVj
a19jbWQoc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2LCB1OCBvcGNvZGUsIHUxNiBzYSwKICAq
Lwogdm9pZCBzY3NpX2NkbF9jaGVjayhzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYpCiB7CisJ
Y29uc3Qgc3RydWN0IHNjc2lfaG9zdF90ZW1wbGF0ZSAqaG9zdHQgPSBzZGV2LT5ob3N0LT5o
b3N0dDsKIAlib29sIGNkbF9zdXBwb3J0ZWQ7CiAJdW5zaWduZWQgY2hhciAqYnVmOwogCkBA
IC02NTcsOCArNjU4LDkgQEAgdm9pZCBzY3NpX2NkbF9jaGVjayhzdHJ1Y3Qgc2NzaV9kZXZp
Y2UgKnNkZXYpCiAJICogbG93ZXIgU1BDIHZlcnNpb24uIFRoaXMgYWxzbyBhdm9pZHMgcHJv
YmxlbXMgd2l0aCBvbGQgZHJpdmVzIGNob2tpbmcKIAkgKiBvbiBNQUlOVEVOQU5DRV9JTiAv
IE1JX1JFUE9SVF9TVVBQT1JURURfT1BFUkFUSU9OX0NPREVTIHdpdGggYQogCSAqIHNlcnZp
Y2UgYWN0aW9uIHNwZWNpZmllZCwgYXMgZG9uZSBpbiBzY3NpX2NkbF9jaGVja19jbWQoKS4K
KwkgKiBBbHNvIGlnbm9yZSBDREwgZm9yIGFueSBob3N0IGRlY2xhcmluZyBsYWNraW5nIHN1
cHBvcnQgZm9yIENETC4KIAkgKi8KLQlpZiAoc2Rldi0+c2NzaV9sZXZlbCA8IFNDU0lfU1BD
XzUpIHsKKwlpZiAoc2Rldi0+c2NzaV9sZXZlbCA8IFNDU0lfU1BDXzUgfHwgaG9zdHQtPm5v
X2NkbCkgewogCQlzZGV2LT5jZGxfc3VwcG9ydGVkID0gMDsKIAkJcmV0dXJuOwogCX0KZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvc2NzaS9zY3NpX2hvc3QuaCBiL2luY2x1ZGUvc2NzaS9zY3Np
X2hvc3QuaAppbmRleCBjNTM4MTJiOTAyNmYuLjVjNTllNjRmNzZiOCAxMDA2NDQKLS0tIGEv
aW5jbHVkZS9zY3NpL3Njc2lfaG9zdC5oCisrKyBiL2luY2x1ZGUvc2NzaS9zY3NpX2hvc3Qu
aApAQCAtNDYyLDYgKzQ2Miw5IEBAIHN0cnVjdCBzY3NpX2hvc3RfdGVtcGxhdGUgewogCS8q
IFRydWUgaWYgdGhlIGNvbnRyb2xsZXIgZG9lcyBub3Qgc3VwcG9ydCBXUklURSBTQU1FICov
CiAJdW5zaWduZWQgbm9fd3JpdGVfc2FtZToxOwogCisJLyogVHJ1ZSBpZiB0aGUgY29udHJv
bGxlciBkb2VzIG5vdCBzdXBwb3J0IENvbW1hbmQgRHVyYXRpb24gTGltaXRzLiAqLworCXVu
c2lnbmVkIG5vX2NkbDoxOworCiAJLyogVHJ1ZSBpZiB0aGUgaG9zdCB1c2VzIGhvc3Qtd2lk
ZSB0YWdzcGFjZSAqLwogCXVuc2lnbmVkIGhvc3RfdGFnc2V0OjE7CiAKLS0gCjIuNTAuMQoK


--------------GSF3WdoAO5xjtfrRGnJ0BjBS--
