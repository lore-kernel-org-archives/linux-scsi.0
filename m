Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B2731F9A7
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 17:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784051643; cv=none; b=sB/+FEYBeFMwvNwbLcCtehXexxYdnj0zcqwcX9yLmAygTEATd1+LseloG6GwNbnLQ5BZ14nFVAXsGXlQLgpWp2TwwPs359WqmClwyboh3U/seHlmjmQ6N/e0PsRWjKm4ptAkx3Spn0tASrlcxzstba08NVJHlESdbPg1Jcj3VT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784051643; c=relaxed/simple;
	bh=13q8ou6rb9UAIjz5RbpuCeGs2uJQ0hpAHwujkJm+vfc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lmwfqJAx+hh4K5qonScH/5p7oAkpiTaJy3kV0jpEDBfGYCxNdRVWOkvgimcm4Vt7KPb5yaxE91t3xDShNpNGCbduT5igsVVAgv9UMQt3Fg9Ct8/khGNho3GOWjfcbifh71o0AfTJSuFUrqfuE700qToGBYrjneJCnAHdlmkNb1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kseTQGAC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kseTQGAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84B31F000E9;
	Tue, 14 Jul 2026 17:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784051640;
	bh=EM37H+25vCWjv0y9uUzTksn8smRii3zH6W2tVVc/Qcg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kseTQGACH9NcCmL3IqkXK51NyLZC5NZPt2ZPYPvsfXePo4p9VX/D6Hln08hLvGqBU
	 UIjUW/oKBTVa+WVeZWP4V8obAgx+IPBeTw9HRUfO+tGpAlRUkgE3l/71kknFOdgbD6
	 yUxzbzFtquvW2+ktRxHUJoT4G10nfhkr90244KVEuaKcSnlkOMj+3eGX48vI2UbG8r
	 COL7hbsIrcWSXD0FnxNa8mGjhxdbOorDTGBeYRavnlHSla2E++9LEJxemNdXGgSRD3
	 pwKYdSJpzum/bg/5Y6CQorIQO7n7T5SEBD2wTjamJEnOPipktvrf+pONgYfwJAqY2/
	 hFVlz6BPPXxow==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 50/56] scsi: qla2xxx: Hold vport reference in
 qla24xx_report_id_acquisition()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-51-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-51-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 17:54:00 +0000
Message-Id: <20260714175400.B84B31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Taking a reference on a vport that is in the process of being dele=
ted leads to a deferred Use-After-Free because the doomed vport gets re-ins=
erted into the global `host_map` btree.
- [High] The reference counting mechanism in `qla24xx_deallocate_vp_id` has=
 a 10-second timeout that forcefully unlinks and frees the vport, which lea=
ds to a direct Use-After-Free in delayed reference holders.

Pre-existing issues:
- [Critical] Dropping `vport_slock` inside `list_for_each_entry_safe` loops=
 leaves the cached next entry (`tvp`) unprotected, leading to a poisoned po=
inter dereference if the next entry is concurrently deleted.
--

--- Patch [50]: [PATCH v4 50/56] scsi: qla2xxx: Hold vport reference in qla=
24xx_report_id_acquisition() ---
commit 7d10ec381e305993987569ba72583ef4c2b344ab
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition()

This commit addresses a use-after-free issue in the format 1 path. It takes
a vport reference under vport_slock during vp_list traversal to prevent
concurrent teardown.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 59023492c5a98..ba4a4764de1fb 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4267,6 +4267,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,=
 void *pkt)
>  			list_for_each_entry(vp, &ha->vp_list, list) {
>  				if (vp_idx =3D=3D vp->vp_idx) {
>  					found =3D 1;
> +					atomic_inc(&vp->vref_count);
>  					break;
>  				}
>  			}

[Severity: High]
Since there is no check for a deletion state (such as the VPORT_DELETE flag)
before taking this reference, could we end up rescuing a vport that is
already in the process of being deleted?

If a concurrent qla24xx_vport_delete() clears vha->d_id and removes the
vport from the host_map, wouldn't the subsequent call to
qla_update_host_map() re-insert this dying vport back into the btree?

If so, does this result in a dangling pointer when the vport is finally
freed shortly after?

[ ... ]

> @@ -4284,6 +4285,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,=
 void *pkt)
>  			set_bit(VP_IDX_ACQUIRED, &vp->vp_flags);
>  			set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
>  			set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);
> +
> +			atomic_dec(&vp->vref_count);
>  		}

[Severity: High]
Does the 10-second timeout mechanism in qla24xx_deallocate_vp_id() make this
decrement vulnerable to a use-after-free?

If qla24xx_deallocate_vp_id() polls for vref_count to reach 0 but times out,
it forcefully unlinks and frees the vport. If this thread is delayed for
longer than 10 seconds (e.g., due to system load or VM scheduling) after
taking the reference, won't this atomic_dec() and the set_bit() operations
above it end up modifying freed memory?

[Severity: Critical]
This is a pre-existing issue, but the commit message mentions matching the
reference idiom already used by other ha->vp_list traversals. Are those
other traversals safe from poisoned pointer dereferences?

Looking at qla2x00_do_dpc_all_vps() in drivers/scsi/qla2xxx/qla_mid.c:

	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
		if (vp->vp_idx) {
			atomic_inc(&vp->vref_count);
			spin_unlock_irqrestore(&ha->vport_slock, flags);
			...

Because vport_slock is dropped inside the list_for_each_entry_safe loop, the
cached next entry (tvp) is left unprotected.

If a concurrent operation like qla24xx_deallocate_vp_id() hits its timeout
or sees a 0 refcount on tvp and deletes it, its next and prev pointers
become poisoned.

When the loop resumes and tries to advance, won't it dereference LIST_POISO=
N1?
This same pattern appears to exist in qla2x00_abort_isp() and
qla_pci_error_cleanup().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D50
