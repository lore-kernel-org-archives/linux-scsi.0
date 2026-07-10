Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B2725B0B6
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 02:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783651431; cv=none; b=OHYJij6UyhixEkhbLV8Mj6ekkJ4V1rcWD31C7HTQ0/HuqFXMkK4Yy+rGm/x7R0CPeerzVxn0MGfc0G39GolHAXjXr90Nuw3zHCdkoHKvqFj2wwPDxe6NOjUROSHOilsQmoEdQq9VMHFyww9a65brz1THhv+YYZvioF8INSa2bLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783651431; c=relaxed/simple;
	bh=XMuR5U5EBxNsCW3SvMVkoAKkaUYKLtNRsD5S4WR5eRA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sIxqlYBWqcQYlbNgj20bDDLZv4PqpXFkGaFrKlhsrhTupXTxW8eEQ+Ds5bz9TIvLZWAjJnWJJTSNsIa9dKAUV4h+6cOiiuCXsUvFRk1DswxlGosUBbBTujaF+G7jojxgDq08565fsvEuuqyb7MiyAwInvqZbxFZpCUPglV76iIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XTC5lGn2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XTC5lGn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACECB1F000E9;
	Fri, 10 Jul 2026 02:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783651429;
	bh=1qH3VHClzGZEceAVrlr+3DluwzfS2ApKRsGhaHAUqeQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XTC5lGn2FeceBOf7isBCaHZlIuBNImR2usnZSraYZNbnq7Uapm/VpRUL3ebNV8hEy
	 E03gSqDYIpz4YRrw4Wz7wBiJTlR3IQaq0Umicoq0NNOHPHVFR/Lld6f4l41Gu0el4L
	 lgmztGhYhvV6VUJMOVfMZ/9d7nawU0ezdEnIUbg99HCOndzNJGwZubUwKqzaG69wPh
	 W3mrypnvs+oQGJopsbMeoP0MOWyFrO/piMrqSSowVXLjPuSWDpRMiN7W6Hn5xF5WNP
	 eXUbJcx3zmKWyZJGal0ieQriTqlgjJejCXjZXv1lSq41BHKZvaCWWoAUBl4e+ukLu4
	 yuYG2gH15FcIA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: lpfc: add KUnit coverage for EDC descriptor
 bounds
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Bommarito" <michael.bommarito@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260710022932.3741311-3-michael.bommarito@gmail.com>
References: <20260710022932.3741311-1-michael.bommarito@gmail.com>
 <20260710022932.3741311-3-michael.bommarito@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 02:43:49 +0000
Message-Id: <20260710024349.ACECB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Medium] The KUnit test leaks memory pools if an assertion fails because =
cleanup is deferred instead of registered with KUnit.
- [Medium] The KUnit test uses an uninitialized `ndlp` node, causing the te=
st to silently abort early and mask a missing mock function crash.

Pre-existing issues:
- [High] Missing bounds check for unknown EDC diagnostic descriptors allows=
 an underflow of `bytes_remain`, leading to an out-of-bounds memory read or=
 infinite loop.
--

--- Patch [2]: [PATCH 2/2] scsi: lpfc: add KUnit coverage for EDC descripto=
r bounds ---
commit dd6d0b3cfc06c72b1e47a15c2af79c7992a6552f
Author: Michael Bommarito <michael.bommarito@gmail.com>

scsi: lpfc: add KUnit coverage for EDC descriptor bounds

This patch adds KUnit coverage for lpfc_els_rcv_edc() descriptor-list bound=
s.
The tests live in lpfc_els.c so they can drive the real static EDC parser
without exporting test-only symbols.

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 0023524528d93..3193a2aaac2f1 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -12592,3 +12592,157 @@ lpfc_cmpl_els_uvem(struct lpfc_hba *phba, struc=
t lpfc_iocbq *icmdiocb,

[ ... ]

> +static void lpfc_edc_kunit_setup_hba(struct kunit *test,
> +				     struct lpfc_hba *phba,
> +				     struct lpfc_vport *vport)
> +{

[ ... ]

> +	phba->lpfc_mbuf_pool =3D dma_pool_create("lpfc_edc_mbuf", kdev,
> +					       LPFC_BPL_SIZE, 8, 0);
> +	KUNIT_ASSERT_NOT_NULL(test, phba->lpfc_mbuf_pool);
> +	phba->mbox_mem_pool =3D mempool_create_kmalloc_pool(1,
> +							  sizeof(LPFC_MBOXQ_t));
> +	KUNIT_ASSERT_NOT_NULL(test, phba->mbox_mem_pool);
> +}

[Severity: Medium]
If any KUnit assertion fails later in lpfc_edc_kunit_run() (such as the
allocation check for cmd_dmabuf->virt), the test will abort immediately=20
without executing lpfc_edc_kunit_teardown_hba(). Will this leak the dma
and memory pools created here? Should these be registered for automatic
cleanup with KUnit instead?

[ ... ]

> +static void lpfc_edc_kunit_run(struct kunit *test, bool malformed)
> +{
> +	struct lpfc_hba *phba;
> +	struct lpfc_vport *vport;
> +	struct lpfc_nodelist *ndlp;
> +	struct lpfc_iocbq *cmdiocb;
> +	struct lpfc_dmabuf *cmd_dmabuf;
> +	struct fc_els_edc *edc;
> +	struct fc_tlv_desc *tlv;
> +	size_t payload_len;
> +
> +	phba =3D kunit_kzalloc(test, sizeof(*phba), GFP_KERNEL);
> +	vport =3D kunit_kzalloc(test, sizeof(*vport), GFP_KERNEL);
> +	ndlp =3D kunit_kzalloc(test, sizeof(*ndlp), GFP_KERNEL);

[Severity: Medium]
Is the kref for this node list left as zero by the zero-allocation?

When lpfc_els_rcv_edc() calls lpfc_issue_els_edc_rsp() later in this path,
it attempts to take a reference via lpfc_nlp_get(ndlp). Because kref is
zero, won't this fail and return NULL, causing the function to silently abo=
rt
and skip sending the response?=20

This early abort would mask a potential crash, as phba->__lpfc_sli_issue_io=
cb
does not appear to be stubbed in the lpfc_edc_kunit_setup_hba() mock setup.

> +	cmdiocb =3D kunit_kzalloc(test, sizeof(*cmdiocb), GFP_KERNEL);
> +	cmd_dmabuf =3D kunit_kzalloc(test, sizeof(*cmd_dmabuf), GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_NULL(test, phba);
> +	KUNIT_ASSERT_NOT_NULL(test, vport);
> +	KUNIT_ASSERT_NOT_NULL(test, ndlp);
> +	KUNIT_ASSERT_NOT_NULL(test, cmdiocb);
> +	KUNIT_ASSERT_NOT_NULL(test, cmd_dmabuf);

[ ... ]

> +	cmdiocb->cmd_dmabuf =3D cmd_dmabuf;
> +	lpfc_els_rcv_edc(vport, cmdiocb, ndlp, payload_len);

[Severity: High]
This is a pre-existing issue, but missing bounds checks for unknown EDC
diagnostic descriptors in lpfc_els_rcv_edc() could allow an underflow of
bytes_remain.

In the target function:

lpfc_els.c:lpfc_els_rcv_edc() {
    ...
    while (bytes_remain) {
        ...
        switch (dtag) {
        ...
        default:
            dtag_nm =3D lpfc_get_tlv_dtag_nm(dtag);
            lpfc_printf_log(phba, KERN_WARNING, ...);
        }
        bytes_remain -=3D FC_TLV_DESC_SZ_FROM_LENGTH(tlv);
        tlv =3D fc_tlv_next_desc(tlv);
    ...
}

If a remote FC node sends an unknown descriptor tag whose length is malicio=
usly
crafted to be larger than the remaining payload, won't bytes_remain underfl=
ow
to a huge value since there is no bounds check in the default switch case?
This could bypass the loop termination and allow an out-of-bounds read on t=
he
next iteration.

> +
> +	KUNIT_EXPECT_TRUE(test, true);
> +	lpfc_edc_kunit_teardown_hba(phba);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710022932.3741=
311-1-michael.bommarito@gmail.com?part=3D2
