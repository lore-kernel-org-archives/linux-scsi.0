Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793018671;
	b=ILarAwW8fq14bTWS/6DT10NuV1qA6dwn2TNQMj3Pk59aUBKw7YnygWurSCaZbZOUxCct
	 r3u9zzZhsYNuQFKrEKw1dchHD1NkjMRiUjAdQLp3cm+RRa3AnBL88MpwSxycef9W9GOtr
	 FDYegDXHCAZPy6e+M8r8OBTKJhzB1V/eYMDr8UjF/9wUCywoYt0T0jPS2eDXykogFPsT5
	 yq/bZG4veG1/l8/X7plw0+kki7FIH2ho/JCipmzqZci7WPW2mfnDulnwSY30Zntj+rh/g
	 MbCXgskuIbRH06veMrCa7YKdtJEZ5FwbTWHc+WsFmGbEkxiVUDocKqHlvhmSHdZJykg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793018671;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Subject:From:To:Cc:Date:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=+Wq76IOoqC9Xs53xPZFbGa8lUXZBI88ZO79pfXsG86A=;
	b=k1EAmBWlyjKgOEGXBxuKbixeL6dCq+fWFXs6qALn3LFlOjloOgVaQO3ZANXFrmsVT9HP
	 U4F6uRRr4DO4IJHkOXjQfRbL44NPTbnLH/L5eFec/mhmwTezkn6OLN62hI0+wjhsaI6mY
	 vNwIQmRATPkDlwwE3oSspRPxvCDG9Y8nQ4cfHBW2CWvZrcf+3Ta4ZTynwJ2Z+w4VQgAPi
	 zfIWfAsc5udG0Urch7KEoItxjkXci4zEzcd37PBBT/k4/FztY9Gf520MDtNccpdnurXZH
	 ffID3ZiIo0RErWCvzRs6yavBWXPWu2/4CiiXU5pVRl5VPvk/KdrudazzA4K6UbsZvOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ACusb6YH;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=VMavnsB+;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93309606A337
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 12:44:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93309606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ACusb6YH;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=VMavnsB+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793018669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Wq76IOoqC9Xs53xPZFbGa8lUXZBI88ZO79pfXsG86A=;
	b=ACusb6YHOThZkdYx+RetvujwyPBcx1J5c4xlLDcuFszLIksLJuybkGZaSHc42cAenUEgJq
	VU+Rg86+13e1F8mceitU4hDs5CPNmS8z4R8pOVSTLZmontyxdROjzY3E8I/nE1YZgF29OU
	m+0JlqM/Es3BaVAaEIfaE1MlKio1M20=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-apyfsyCINoqGwdB2sVIFuw-1; Mon, 26 Oct 2026 08:44:28 -0400
X-MC-Unique: apyfsyCINoqGwdB2sVIFuw-1
X-Mimecast-MFC-AGG-ID: apyfsyCINoqGwdB2sVIFuw_1793018668
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-535066512b0so89041571cf.0
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 05:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793018668; x=1793623468; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=+Wq76IOoqC9Xs53xPZFbGa8lUXZBI88ZO79pfXsG86A=;
        b=VMavnsB+OeORIts+JD48lmCdM3XTWmqY3B+48kZVq6GqW8wiWgmmaA2KyYlgoJSRXR
         +QSEtnh++OPHLAZn9K5MmlDPnVp/CF+bulubpMHa2ESN57DNMvSlv1OQfOTRwVTlCuRw
         Pqnc3g/wGw/KPOJaE7VSUDZYT2cmfEKDTUu3JfJ4Jq0DMZwJeDQPnN/iSChDGP1RB6uQ
         oA3QhBmn/QYBdKSeHDxw2posAg1nFqvNcNxuDmFOK6wGayo0N0AcGqGFIzosjAyRe/Uc
         or/U+4wxVaVfbpQzmlNrKVl9jJJb18FNPtwzWVBkk9UGmtbRCBhxc1sY2HkhSPCtU0th
         Cl3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793018668; x=1793623468;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+Wq76IOoqC9Xs53xPZFbGa8lUXZBI88ZO79pfXsG86A=;
        b=QMuDPg5FoJ9EOez8/VFtpm7hQfENke3YjIRqTCT9Dk7fIRCHp4xcHrAttUXtvLGEzK
         Q7MZgu+OV+nRDi3//Dx4PP8uzFBfA/ZMgMafqX8XQ7lB5Vz5oazQg74WiMzf2671758k
         aAgQrRp+OA+OgvJ5gll6HnKhBP7XIJ1n6f/QsFs/U3TyS9ICr+hlFo88EFV0+JgU5A01
         uxco3WGwQb5At7hLQoNvo8e2+grkBzLk/RyYAj3ApRQhTG3OkxnQNLMmZXe8zYtoiRPc
         qWwXNNlzKwzZUi7vEsASo0ozMcZ04Yq/c9TB+oiRzSU+wT18RmKpecar/wXpIPGBSJMS
         FTjw==
X-Gm-Message-State: AFq9FYJzggWnHKIyTR3CumK8HClPxIib7Itf6FipnifHiWCVuJ1BPZVy
	xs2A9ePPsjFaLAJEOlOtf1zkNsJkuZRcogj1HOC79y7esNU+FsdWLF5SQNn9tvo2pQMtFN/dy7C
	euSLaT47S96DopQZ8AfGOffiQxG9/1FvlKuwAe7UdzOHFfgLOJbf/vKylX/MaZoU=
X-Gm-Gg: AYBFou3Rc9AlPsZAIlRQTu6LV71fAAjQzs1d/VgMzLmR9Pwjv7NQ/4WBuIV95Kukt6t
	VX86Em9WVSVVQDOttwljuPYy9jsjAfZQfBbs7gM8JQoGYx49odD6W4vxEBB8j5oiUTlawZgqPgr
	fF595yJk8LjyoWMRfN1TYOqcq6zA891DpdIjFmWDTtuOFXJmiuctRBGXSGK1xU5YP6mMgf7/rcD
	VpW9e65sxblZO9936BqRCezW5m9je1H23LfX3/mF26ThPOdczL/ECCr/sJv9OFNfJ8LBFypaYp0
	W0RZFVYI8FLhmaHHtTBpAPoPfOP/klDNy+DvJzVqWoezdFQhQwYICv3pj8aQ8kl+7TfbSn8SEEN
	PtOvZGSBOwxVDlFxeNFYSf2uyDFwy+XE3hZkKN7r4DFupyWGoVvDMDgGbMP/ikeNvDndn39hlm9
	kSseD3As3WrROXuP3fPWb4yQ==
X-Received: by 2002:a05:622a:578e:b0:537:d4b4:3617 with SMTP id d75a77b69052e-5383b36f9c1mr95685831cf.6.1793018666234;
        Mon, 26 Oct 2026 05:44:26 -0700 (PDT)
X-Received: by 2002:a05:622a:578e:b0:537:d4b4:3617 with SMTP id d75a77b69052e-5383b36f9c1mr95685281cf.6.1793018665567;
        Mon, 26 Oct 2026 05:44:25 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-538394f82cfsm53606071cf.13.2026.10.26.05.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 05:44:24 -0700 (PDT)
Message-ID: <bcf0cd314f3c4f061a02c802f0ea9ec4b6e25cff.camel@redhat.com>
Subject: Re: [PATCH v2 0/2] scsi: target: iscsi: fix stalled aborted WRITE
 commands
From: Laurence Oberman <loberman@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>, mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	mlombard@redhat.com, michael.christie@oracle.com,
 linux-kernel@vger.kernel.org
Date: Mon, 26 Oct 2026 08:44:23 -0400
In-Reply-To: <8a702a89-ad21-425e-9850-d9771fcf7c31@acm.org>
References: <20261016175351.126373-1-loberman@redhat.com>
	 <60cf407142a0663a811a2ccd64cf387cb71808ab.camel@redhat.com>
	 <8a702a89-ad21-425e-9850-d9771fcf7c31@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Sun, 2026-10-25 at 09:40 -0700, Bart Van Assche wrote:
> On 10/25/26 7:43 AM, Laurence Oberman wrote:
> > Gentle ping:
> Please take a look at the attached review report. The report has been
> generated by an LLM. As known LLMs may make mistakes.
>=20
> Bart.

Hello Bart,
Thank you very much for using your LLM review this. I am following up
with a v3.

The report was right about the one thing: the claim in v2 did not cover
every site that completes an aborted WRITE_PENDING command, and my
answer to the Sashiko review wrongly assumed=20
iscsit_check_dataout_hdr() checked it. The upcoming v3 adds patch 3 for
that site and patch 4 for the DATAOUT_SEND_TO_TRANSPORT path, and the
cover letter corrects the Sashiko answer. The comment reword and the
patch 2 commit-message cleanup are in there too.

Two things in the report are not correct, in case the same tool is used
again:

d5869dae5080 is not confined to 7.3/scsi-staging:

  $ git tag --contains d5869dae5080
  mkp-scsi-fixes
  mkp-scsi-staging
  v7.3
  v7.3-rc2
  ... v7.3-rc7

It went in via mkp-scsi-fixes during the 7.3 cycle, it is in released
v7.3, it carries CVE-2026-97951, and it is in 5.10.y, 5.15.y, 6.1.y,
6.6.y, 6.12.y, 6.18.y and 7.2.y. That does not change the conclusion
that the gap belongs in this series, but it is why patch 3 has Cc:
stable, and why it may be better taken standalone for those branches,
none of which carry patch 1's helper.

It seems aaa00cc93c1d is yours from git history.

  $ git show --no-patch --format=3D'%an <%ae> %ad' aaa00cc93c1d
  Bart Van Assche <bvanassche@acm.org> Tue Nov 27 15:52:02 2018 -0800

It is the right Fixes: for patch 1, though, and patch 1 now carries it.
git log -L on that hunk shows your commit replaced a
transport_check_aborted_status() call -- which sent the delayed
TASK_ABORTED status -- with a bare CMD_T_ABORTED test and a return.
That works where the core can finish the command itself, but a WRITE
still in TRANSPORT_WRITE_PENDING has never reached the backend, so the
core's abort path is itself waiting in target_put_cmd_and_wait() for
the fabric. The other three commits touching that hunk since 2011 are
cosmetic.

Thank you
Laurence

