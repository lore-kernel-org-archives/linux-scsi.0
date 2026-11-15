Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794772249;
	b=mmEvqtxwmL/JMZmkcB3PKzoj2cpUi1QQ6aJbm/tBjH9VB3Ecp4N5GbuW2SDEla1fO3Sa
	 814oiLFgEqiJzwWwVjAUDZLdVgDfH2poTXPHJgtlipKIG9G//EwdAULVXYNL4MzbgD8ev
	 h+k2fiIwbFggpZwjiSyIwKKPzJRzu8HaGLpH3mSGmAdgKnndn9SjuacovWtl3Te6gOvVH
	 JPaeTkQ2TA6R+5Ebv68IZ49Z+AhYvzV41MkPOZ5ERrn/BUxFvAY4e9HF7zsAaFa/uKbSN
	 dNfNJeci9Pvn10PJanfr4YYXXRLWpYc50BU8WKIg6eGIKpVGs1fRmpNJYwMB7YhPlLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794772249;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=XgpkxvsJVh8BJS3GLG5yN1xAKQOXcg9vlC9AO3bmWD0=;
	b=q9kBfegloymNwQgNrlur2cnTV6SQ3QvmjU52YQHFN0E2rWnFVq+mbSlvveYLD83+QpEA
	 3/1je2N0G+fXjNRmTttCBPodGASCYNmWkzyelDyiwPl5n11tph0TEdSuL9gBtKv7GzVNM
	 zZk/Naz1f6a9ny52NI/CjOywifXAxW2is0ymAfVJ00u2j9XrBfzfSxk84oYMU0z1Pojve
	 fQfvCb6xLsWSfTeyeOdbzCj8K4/PRLD8gPHRyAtbTk1WV3wDDcOeOfl4ZttYVGpyuqoQ3
	 TRQsqsPwzpE4rwgiLXoc58oK57PLt9FVAgvvMquPSnqK0UxdmSuEjU6JT43C0t7VtFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=T8X2StGh;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=lRLtAgGV;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE71B606A32F
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 19:50:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE71B606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=T8X2StGh;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=lRLtAgGV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794772248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XgpkxvsJVh8BJS3GLG5yN1xAKQOXcg9vlC9AO3bmWD0=;
	b=T8X2StGhkNKX1VLeaUOUSBJIoqiZYnhYmtwWnCn+aiQwaBqKqmK1BGjQ3MDOcC4EDpDT5Z
	+HrTnDxHHKrBY9NP20EKWqDtuKGv25yr88dyL/vdSn1b4c1JzD/iLeKcATxBW9jR3Z1FxJ
	XvbyJkQZeDlObHYTWDz4LXprfvkCUYM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-9HFIFXZ1NxGWBYmPYiD6cQ-1; Sun, 15 Nov 2026 14:50:46 -0500
X-MC-Unique: 9HFIFXZ1NxGWBYmPYiD6cQ-1
X-Mimecast-MFC-AGG-ID: 9HFIFXZ1NxGWBYmPYiD6cQ_1794772246
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-55c826e557fso28939991cf.1
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 11:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794772246; x=1795377046; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=XgpkxvsJVh8BJS3GLG5yN1xAKQOXcg9vlC9AO3bmWD0=;
        b=lRLtAgGVe11UGJwAZRU0JTi3Uq7ZDO6urUJ5/OVyRykkp2kg/fn/9fzlhYxHXvPGIJ
         2gnmEDCMfo8hR47Y4/TK4o7KbpVosMGZsC9pFysu9ZO1gMhuzipKoGLGSQmo/RmQN5jV
         0+ERFcSZtXBGuHSJAOVzIi0TFfyb8mM+EeMMAhlc0fReJYmaZikNxWm4Y1bJe1/4iypm
         LFJ+cArzlueD6GjJLAz1l1vIzw1l+64QOO1mod9mPvZOkMgMb+4YxEdDN219AiN6j0Px
         Ad8fVwJhyWTuKQgTAE9PedbgnJYMuEkNerJoVFzQToWuPM1Yn+Mxs/lEmZYKUdRqPcSa
         k34w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794772246; x=1795377046;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XgpkxvsJVh8BJS3GLG5yN1xAKQOXcg9vlC9AO3bmWD0=;
        b=OhrV0baQ8Gt9FZNKIJ6YYltPhJSgaE8XDFdZ8VWMQzANj+sWxnDLq5B12nehe6yPDF
         s2CIO1ZkBEwM0kMWfCj2GFC9nMwfLbvlpFtOivp2G2PxjXJZfxaNAFRAky0Bbum3AFxM
         hSYe5insMBSn/WBoCdcb1SRhSss/vmwr8ggLFN9adUrMxfUGmZ9d+Fur5zeI2rb6+9eP
         2MhbQ2KL+2KtnzuK4rUQe6RKzSWfZYyyqc1uF4ylBgtJ/6TM5bkLkFObEu9qwyK6Xv83
         khKKEs7uL2+cPGVTijqBuI6X3E6cgevuiZQ1sx0Ifw9zKAoKfAzI3kqB8UX+7dXtCFHq
         5KIg==
X-Forwarded-Encrypted: i=1; AL+hErE5Er8hb7A32fdxWZvJkPY2vgfHsQQ1mLEiNJ3rHOZQknGLJ/jnlQL6+6hW9cPxUQmzvKdcFxzDc2Hp@vger.kernel.org
X-Gm-Message-State: APuU4Z+NnfFkzimBWCDKc3zIOJVVE/kj5Oj/Ci38dbu3XSMtM4ILQtfz
	9mW2mYzBmHC1xIA/PVZNTiP1zKC51NRGrq4RvYA+CZvLu4CzXGn2i4GoMUKFQp59GGZcGnAktxI
	h5qsLr8nHRudFKjolY/RAwmejMGz8Yz6qOJCbpWnqCX27/P1f0BVCXhYGxHzrhnY=
X-Gm-Gg: AYBFou3adqQl6xMj1qe4I6cqG8EAndjs/2CsdLZFI2W30t0M/0bkq5KatYUgYFAxhkp
	Bhm1KYQUMp9wkydl79pdDrbiY/H1r7HHyuWWf2Hlmkc2ZEISEWXRMZbeSf90PnG5+CNLjI81uUd
	xdXkWtkhvRJXtHMB7u+A3TVDcZcB5kaJ7r6Kxtk9AArIBPIMirYzt3KD+Zz8AqkV6qMYdhs9OeX
	KX+cLZLxSIeJ7SDNmwMlTpLFqFA3RiWGbcrqA0I/7jth0NzFy4OdfeWEBcYShqXicaODQbar2U7
	1AUX9Vro8pJ44XYb65vqXtEu+JX9uvg99lvF2/0ar4ZETQqUPHow2dOWMBFwq9DLZHGNlKrmc2w
	iGukYxOUE7ywdkvgvHTSDaw8h1ljAYzOXGigd05PXS88FDuUOJDBN8MlA0W1nm8vKrE6HtV9vEo
	KsmUwXN9TKB+kxqg6NAxxgdbRhhT6R46vL6jNbKb/LWRINxuokZJSDzBGaVUqj0fu5pQ28cA==
X-Received: by 2002:ac8:5a0f:0:b0:533:2ef6:d98a with SMTP id d75a77b69052e-55ac7b5ad89mr149141011cf.29.1794772245923;
        Sun, 15 Nov 2026 11:50:45 -0800 (PST)
X-Received: by 2002:ac8:5a0f:0:b0:533:2ef6:d98a with SMTP id d75a77b69052e-55ac7b5ad89mr149140871cf.29.1794772245494;
        Sun, 15 Nov 2026 11:50:45 -0800 (PST)
Received: from loberman-thinkpadp1gen5.rmtusma.csb ([2600:6c65:2440:d8c:929c:b769:6def:faa3])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55c3b7a4adbsm42557101cf.19.2026.11.15.11.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 11:50:44 -0800 (PST)
Message-ID: <fdda7a0e1caab6dda5177bdcf2ccaed4f4f63a24.camel@redhat.com>
Subject: Re: [PATCH v9 00/29] Native SCSI Multipath support
From: Laurence Oberman <loberman@redhat.com>
To: John Garry <john.garry@linux.dev>,
 james.bottomley@hansenpartnership.com, 	mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, 	snitzer@kernel.org, jmeneghi@redhat.com,
 bmarzins@redhat.com, 	dm-devel@lists.linux.dev, hch@lst.de,
 michael.christie@oracle.com
Date: Sun, 15 Nov 2026 14:50:43 -0500
In-Reply-To: <01eac6bf-8df7-4e7a-8cc6-93e013750bce@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
	 <9b90edc29d5b3be49f5bd0e0ecec5f1701e089bf.camel@redhat.com>
	 <01eac6bf-8df7-4e7a-8cc6-93e013750bce@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Sun, 2026-11-15 at 18:59 +0000, John Garry wrote:
> On 11/9/26 20:19, Laurence Oberman wrote:
> > 2. ANO paths are ranked the same as AO paths
> >=20
> > With the ALUA state corrected (by writing "activate" to dh_state,
> > or
> > with the fix above), I/O still went to active/non-optimized paths.
> > scsi_multipath_sdev_init() sets mpath_device->access_state to
> > MPATH_STATE_OPTIMIZED and nothing updates it, while
> > __mpath_find_path(), mpath_round_robin_path() and
> > mpath_queue_depth_path() rank paths by that field. Only
> > scsi_mpath_is_optimized()/is_disabled() read sdev->access_state.
> >=20
> > With numa, the first path in dev_list wins for every node, and
> > dev_list order follows sd probe completion, so for about a third of
> > the LUNs the current path was an ANO path. Example, LUN sdn, reads
> > completed per path for a 2000 x 1M O_DIRECT dd (:0/:3 AO, :1/:2 ANO
> > at the time):
> >=20
> > =C2=A0=C2=A0 sdn:0 0sdn:1 2000sdn:2 0sdn:3 0
> >=20
> > Every read went through the non-owning controller. From the code,
> > for
> > these LUNs the numa recheck of is_optimized() fails on every I/O
> > and
> > __mpath_find_path() picks the same ANO path again.
> >=20
> > With the change below (a template callback so the selectors use the
> > live state), plus the scsi_dh_alua fix, all 30 LUNs pick an AO
> > current path at boot, and on LUN sdl (:0/:2 AO, :1/:3 ANO):
> >=20
> > =C2=A0=C2=A0 numa=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2000=
=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=
=A0 0
> > =C2=A0=C2=A0 round-robin=C2=A0 1000=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0 100=
0=C2=A0=C2=A0=C2=A0=C2=A0 0
> > =C2=A0=C2=A0 queue-depth 18039=C2=A0=C2=A0=C2=A0=C2=A0 0 13961=C2=A0=C2=
=A0=C2=A0=C2=A0 0=C2=A0=C2=A0 (8 parallel dd, 64k)
> >=20
> > No I/O reached the ANO paths under any policy. This is a test patch
> > to
> > show the problem, not a polished change - feel free to fold it in
> > or
> > do it differently.
>=20
>=20
> JFYI, the work which I did for ALUA support a while ago is here:
> #
> https://github.com/johnpgarry/linux/commits/scsi-multipath-v7.3-v7-alu
> a/
>=20
> I don't think that I shared this previously.
>=20
> I do notice that it would conflict with your work to do some=20
> centralising of the ALUA RTPG support.
>=20
> About the NUMA iopolicy - apart from issues in this series with not=20
> checking optimised/access_state properly - it does seem less than=20
> optimal to we only favour one device per NUMA node (when all in same=20
> optimized + enabled state). NVMe multipath support does the same. I=20
> suppose that this iopolicy relies on us having one device/path per
> NUMA=20
> node.
>=20
> Thanks,
> John
>=20
Hi John,

Thanks for the pointer, I had a look. Keeping mpath_device.access_state
in sync from the RTPG result in scsi_mpath_update_access_state() is a
cleaner way to address the ranking problem I reported, so I'm fine to
go with your approach and drop my test patch.

> I do notice that it would conflict with your work to do some
> centralising of the ALUA RTPG support.

Understood. My scsi_dh_alua patch is only the handler_data ordering
fix in alua_bus_attach(), so I'm happy to rebase or rework it on top of
your core ALUA changes if that helps.

When you have the ALUA support rebased onto v9 or v10, I'm happy to
test it on the P2000 G3 setup (dual controller, 30 LUNs, 4 paths each)
and confirm the AO/ANO path selection.

> About the NUMA iopolicy - apart from issues in this series with not
> checking optimised/access_state properly - it does seem less than
> optimal to we only favour one device per NUMA node (when all in same
> optimized + enabled state). NVMe multipath support does the same. I
> suppose that this iopolicy relies on us having one device/path per
> NUMA node.

Agreed. On FC/iSCSI hosts it's common to have several AO paths per LUN
at the same NUMA distance (all paths here report numa_nodes=3D0-1), so
round-robin or queue-depth may be the better default for SCSI. Your
call.

Thanks,
Laurence

