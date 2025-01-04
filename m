Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6411BDCF
	for <linux-scsi@vger.kernel.org>; Sat,  4 Jan 2025 03:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735962645; cv=none; b=F+hmEiN45bdvLYKZ02/r4XVf72MEE2nE0IKAG9H8QJyKmF23ZJC/jixC4Q0IhX6jS3BXPoZYl8XNke7lwP5sDLpRkrWZCyUIlSdJnf1OtLo1WBQKV8MAqJqRYyv5C+HEgJYvThQ4XsM/Xo0sYSUHzbc/NifbSM/dqWbDgAAp+CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735962645; c=relaxed/simple;
	bh=hYVynAK7OQsAFbM/Aj3XmhYPAoRCyvdtGqkk3uemBXY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Pw4U1ibhcZhD56zgdtboYebD/t9dXlnWz1/b77v6nKGbUY50hD1wogPT0F8lS3t3fqTk40U01xry+rk15Ut66BIKdV+jSM8ew7EfdKoQVrdCWjbFWU6sWHgJnFIzQvIFIXNRmW6mb9RPKXvk9PmKjIAsYYI6G3GSR/T145Lp74A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C11q0dBW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C11q0dBW"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C2EC3C4CEDF
	for <linux-scsi@vger.kernel.org>; Sat,  4 Jan 2025 03:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735962644;
	bh=hYVynAK7OQsAFbM/Aj3XmhYPAoRCyvdtGqkk3uemBXY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=C11q0dBWfXY7krydn9rImBoGp/nXqlHK8ixfCaEswW+N106n9Z8PtBw/TQ6aooZPh
	 gkc2ZlbZ0lsjiEoRpLCN+dPDDvORWiYiOvTFtgbZXw+o46an1u5AXHkftC1jwvxj2B
	 SH/ujSJ5vsDyHhVyppEEOZWuQdy4TOMSFhgEFR2tlMwDpDGrT6vXTDlrle3EnUF7P2
	 pngq3Eic3cz4MP0r1IaRBjo+IDFqgfE0WQJxpskOSNN8HDolclDKxlRrbWvIzrwj8T
	 CLFiI/ThBOgltFfYt+DqbJs9J2J9ZfHdAof3rW0p7vee+yt5oJVEx006AwpDV0VL+q
	 /3YjdJGHXzfKw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B55B9C41615; Sat,  4 Jan 2025 03:50:44 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219652] READ CAPACITY(16) not used on large USB-attached drive
 in recent kernels
Date: Sat, 04 Jan 2025 03:50:44 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: michael.christie@oracle.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219652-11613-qkBgLYF280@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219652-11613@https.bugzilla.kernel.org/>
References: <bug-219652-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D219652

--- Comment #12 from michael.christie@oracle.com ---
On 1/2/25 9:30 PM, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D219652
>=20
> --- Comment #10 from Alan Stern (stern@rowland.harvard.edu) ---
> Re comment #8: I would like to know the answers to the questions asked in
> comment #4 about the bad kernel:
>=20
>    In sd_read_capacity(), does sd_try_rc16_first() return true?
>=20
>    And why doesn't the "Very big device. Trying to use READ CAPACITY(16)"
>    line,> along with the subsequent call to read_capacity_16(), get execu=
ted
>    in the bad
> kernel?

I see it.

With the new code we think the command is failing. We then retry the comman=
d 3
times
like you described you saw in the trace. Then because on the 3rd retry we g=
et
0xfffffffe instead of 0xffffffff, we don't hit the check below like I menti=
oned
before:

                sector_size =3D read_capacity_10(sdkp, sdp, buffer);
                if (sector_size =3D=3D -EOVERFLOW)
                        goto got_data;
                if (sector_size < 0)
                        return;
                if ((sizeof(sdkp->capacity) > 4) &&
                    (sdkp->capacity > 0xffffffffULL)) {
                        int old_sector_size =3D sector_size;
                        sd_printk(KERN_NOTICE, sdkp, "Very big device. "
                                        "Trying to use READ CAPACITY(16).\n=
");
                        sector_size =3D read_capacity_16(sdkp, sdp, lim, bu=
ffer);

With the old kernel, we saw the first try succeed. We then saw the 0xffffff=
ff
and then tried read_capacity_16 above.

And the reason for the difference was that with the new code, I forgot to
add a check for if there was even an error. We ended up always retrying
3 times and that lead us to get the 0xfffffffe value on that last retry.

so we need:

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index adee6f60c966..2dcf225c7017 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -210,6 +210,9 @@ static int scsi_check_passthrough(struct scsi_cmnd *scm=
d,
        struct scsi_sense_hdr sshdr;
        enum sam_status status;

+       if (!scmd->result)
+               return 0;
+
        if (!failures)
                return 0;

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
