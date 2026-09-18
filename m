Received: from usb-smtp-delivery-121.mimecast.com (usb-smtp-delivery-121.mimecast.com [170.10.153.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F286B54706C
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 09:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.153.121
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789723863; cv=none; b=jQhP0ZlEmbHo+tDctH3krSmTMGupxfH1ar2H2hD779xgWqp1cIJw7ibroMOyI8/l1NThat9APZLOthCYY7NZJHDydCJiE/4RlUKqAho6Q4rifOBISdjl11JZIybWcXtLBVXjAT3MbyTBH9EJasVrSqnUKT5dIKeCme5IzH9+3kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789723863; c=relaxed/simple;
	bh=I5kQbkpzOmjRWgC1uYQXYPU4zK2J+/6Y3l313P8ns2c=;
	h=Mime-Version:Subject:From:In-Reply-To:Date:Cc:Message-Id:
	 References:To:Content-Type; b=AJJfR2UHpUDc7qV1UMQFfNMeIN3QVkpY0V4n8fpMJsqVztxjC8g0q4jJovoWPEa/h9UnURRg+p0Yh//yFFYkV0fCRjDbhHacitfSTWXLMJddJwmj6GIPQtPNGVJ3+0I0q3JJ75RH+D/7D0kBHmwehVPyFlg9/a3q1JvFy2KGftI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=extrahop.com; spf=pass smtp.mailfrom=extrahop.com; dkim=pass (2048-bit key) header.d=extrahop.com header.i=@extrahop.com header.b=W1HgRzN8; arc=none smtp.client-ip=170.10.153.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=extrahop.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=extrahop.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=extrahop.com header.i=@extrahop.com header.b="W1HgRzN8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=extrahop.com;
	s=mimecast20251212; t=1789723861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uUjNwMyj6+AfB598MkM3JQBHC0Vp9o6AUejtzZaowKE=;
	b=W1HgRzN8RfvBzz7Hy+3KN2s9N1fMMNaC2eWJYQ4AnRVJnteyVl3W6l+mrgPjkgS9ysna2P
	Gt43SwRnIFFZL43J9jIXi5Xt6JazAvhZKZsp69avOLkyd7l1uWtFtOPjpNPEIngLMDpwwa
	n0BcO+ByTNT6bMu0WzHgrXXUj1yo3GTKEVVT5s+vH1g4N9YwFrz7MzPpOKIrM4IVnYLN/s
	CqjAnHhnfPk1CNod1xb08r65UmpEun1S7U9QstbeDr3YduXBdugFTwbDzIcLwMscpUB0Xa
	EZDD8YY0EmW8jNtrMGR33TITPgJEL/bIAdV5ZAosXLdK9410xQc2E9uib3jCcw==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 usb-mta-68-Odl-7eHuOuyo-2TiRewwjg-1; Fri, 18 Sep 2026 02:29:34 -0700
X-MC-Unique: Odl-7eHuOuyo-2TiRewwjg-1
X-Mimecast-MFC-AGG-ID: Odl-7eHuOuyo-2TiRewwjg_1789723773
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-869b8d63e28so903971b3a.0
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 02:29:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789723773; x=1790328573;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8sM7hsw5uUj+BFqxk4qLUIgOpBJlZOorF2HAPHPAveI=;
        b=u+sjKVy3oOz2njRtpAxvZ/c3hnM4k2lXU7xnC0ihzGNI92UhfyvZWnt6Im+BEwklw2
         Pnz1XWI4471rRIAanFbwRrA+LrLCfGzevmvU1sKc1OLogyxoSElcl1WA5tj8mVUR63JD
         pGf/0a5wM0iuf5Ix08BZhNAqPuw8vU7yBlN98ezu5fOs0sUWLf4fGQekL2zipS4oNAQG
         RNLGuf0GEVFUbmQOHr0ix5dzT+ZGztJhJTv/Es2wrd4d6l0B2XuEUqT1zr6ZAHdbKDiJ
         WnIfUyxh2GIpJwu7bvnYSo70jxjsJzEJ0ZSSqUUECZc38K7wk/b3Qd35BzwJLhx1Ihjp
         tXvw==
X-Gm-Message-State: AFuF++lNmck94sAB3Xz3pzvDy4gOYOc7f54ftLc3taQZxKJifmO3IuU1
	n2HE/IXt4JvkH0k1QvCxmQNFKULQ0XRuJHBIpAZ8v3apmh8iboKTObKmNR+aLNNu4Wv61JRLKEM
	JYKaM0jQbm1eIUGdOwY+TenfVQ3J2fREunap6xBgYuA3x5ncsXGm5L1JDdTDCVbIdObkP3FR5Do
	7kYrreCjn07AtzestmGREbaWkxTc0dpysFqiDejWnUz5yD327/ef+BthDImg4=
X-Gm-Gg: AYBFou0scCcHR1PrOFpsaaZdhScJ2UFS6ojd4Rvmtqbcu7TGWRLlRuy/uxmFJZOqesN
	MlqxdyFSNMen7hYv5G+QOpmvEqNsxX+NVXfWYtrOw6bDb3mxrJhtO7go9A03Vtm8oJmjW2UOOpN
	Fwb2e51vU4OGjH5o/M9mXrr0v5vKqISBazvKLtPiyzcohFcogvJ9nqYsP+qa3T2wz666JXIew2D
	TasDPq7tmrULhj3UYlPVscDAdfanErAZbsZmD79LAGHAnVhhNACJ9JsedSDSGQ7ebmOSwRWyvFC
	zZEurvk/Uw+LSnqL6VWXCa7ISuSbyWyptd4C03RH0rIl3wor+6TuEjBVDQGKzPkVpMI4Oeu6E2+
	RgOW7lD/t8uxlSQq3KQ==
X-Received: by 2002:a05:6a00:3e22:b0:85b:635e:7814 with SMTP id d2e1a72fcca58-874dbfee6b0mr3640824b3a.12.1789723773167;
        Fri, 18 Sep 2026 02:29:33 -0700 (PDT)
X-Received: by 2002:a05:6a00:3e22:b0:85b:635e:7814 with SMTP id d2e1a72fcca58-874dbfee6b0mr3640755b3a.12.1789723772485;
        Fri, 18 Sep 2026 02:29:32 -0700 (PDT)
Received: from smtpclient.apple ([152.44.247.61])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-875cf0349cdsm540080b3a.4.2026.09.18.02.29.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Sep 2026 02:29:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.10\))
Subject: [BUG] scsi: mpi3mr: deadlock when throttling changes queue depth
From: Will Mortensen <will@extrahop.com>
In-Reply-To: <13b7b8a4c0d7a3a80df295f312519d3a5cce87e6.camel@redhat.com>
Date: Fri, 18 Sep 2026 02:29:20 -0700
Cc: linux-scsi@vger.kernel.org,
 mpi3mr-linuxdrv.pdl@broadcom.com,
 martin.petersen@oracle.com,
 chandrakanth.patil@broadcom.com,
 albertdu@uw.edu,
 albertdu@extrahop.com,
 erice@extrahop.com,
 jeremyr@extrahop.com,
 sreekanth.reddy@broadcom.com
Message-Id: <01AA8EE7-A209-4340-8B0A-B42141B18267@extrahop.com>
References: <20260831120047.14690-1-loberman@redhat.com>
 <13b7b8a4c0d7a3a80df295f312519d3a5cce87e6.camel@redhat.com>
To: Laurence Oberman <loberman@redhat.com>
X-Mailer: Apple Mail (2.3826.700.81.1.10)
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8zMQM3nEEj97dQKYnO9AW5ajA2HAAW3mDUM6TjoOz6k_1789723773
X-Mimecast-Originator: extrahop.com
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi there,

On Aug 31, 2026, at 5:18=E2=80=AFAM, sashiko-bot@kernel.org wrote:
>> @@ -1127,15 +1131,25 @@ static void mpi3mr_refresh_tgtdevs(struct mpi3mr=
_ioc *mrioc)
>> tgtdev =3D NULL;
>> list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list) {
>> if ((tgtdev->dev_handle !=3D MPI3MR_INVALID_DEV_HANDLE) &&
>> -     !tgtdev->is_hidden) {
>> - if (!tgtdev->host_exposed)
>> + !tgtdev->is_hidden) {
>> + if (!tgtdev->host_exposed) {
>> mpi3mr_report_tgtdev_to_host(mrioc,
>> -      tgtdev->perst_id);
>> - else if (tgtdev->starget)
>> - starget_for_each_device(tgtdev->starget,
>> - (void *)tgtdev, mpi3mr_update_sdev);
>> - }
>> +      tgtdev->perst_id);
>> + continue;
>> + }
>> + spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
>
> [Severity: High]
> This is a pre-existing issue, but does acquiring tgtdev_lock here
> create a lock inversion against shost->host_lock?
>
> In mpi3mr_set_qd_for_all_vd_in_tg(), the driver acquires
> mrioc->tgtdev_lock and then calls starget_for_each_device(), which
> acquires shost->host_lock via __scsi_iterate_devices().
>
> Concurrently, a target teardown (e.g., via sysfs or EH) acquires
> shost->host_lock before calling the driver's ->target_destroy callback
> (mpi3mr_target_destroy()). That callback then attempts to acquire
> mrioc->tgtdev_lock, creating a potential AB-BA deadlock.
>
>> + starget =3D tgtdev->starget;
>> + if (starget)
>> + get_device(&starget->dev);
>> + spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831120047.14=
690-1-loberman@redhat.com?part=3D1

On Aug 31, 2026, at 5:51=E2=80=AFAM, Laurence Oberman <loberman@redhat.com>=
 wrote:
> sashiko found Pre-existing issues:
> [...]
> - [High] An AB-BA lock inversion exists between `mrioc->tgtdev_lock`
> and the SCSI host lock (`shost->host_lock`).
>
> The sashiko reviews were all for pre-existing issues and won't be fixed
> in the specific patch submission here.
>
> I will make an attempt to deal with those in a seperate submission as
> already agreed with Chandrekanth
>
> Thanks
> Laurence

Some of our production servers have been deadlocking due to the pre-existin=
g lock inversion that Sashiko pointed out here, which was introduced in cf1=
ce8b71524 ("scsi: mpi3mr: Reduce VD queue depth on detecting throttling"). =
Has anyone followed up on this?

Our quick fix was to change mpi3mr_set_qd_for_all_vd_in_tg() to take shost-=
>host_lock first, and use __starget_for_each_device() instead of starget_fo=
r_each_device(). We also changed mpi3mr_update_sdev_qd() to filter out devi=
ces in the SDEV_CANCEL or SDEV_DEL state, since that was previously done by=
 scsi_device_get() in starget_for_each_device(), but we're not sure if that=
's strictly necessary.

But our LLMs pointed out another issue in this code path: mpi3mr_update_sde=
v_qd() runs with interrupts disabled by these spinlocks, but it calls scsi_=
change_queue_depth(), which seemingly isn't meant to be called in that cont=
ext. In particular, if blk-iocost is attached, ioc_rqos_queue_depth_changed=
() will call spin_unlock_irq() and re-enable interrupts prematurely. The LL=
Ms proposed a more involved patch to avoid holding any locks when calling s=
csi_change_queue_depth(), but we weren't sure if it was correct. But we can=
 send it along if it would be useful.

(Thanks to our summer intern Albert Du (CC'ed) for all his great work on th=
is issue!)

