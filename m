Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE71339393
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 16:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787674337; cv=none; b=sr0My0IT6ekFMa3yLoNOlwMSbh/lj5qRREue2yFG2yXP9RvYlWwjM/0qf2fEu0zJ3slHLUXGyvk/ieiY5ohIhBQHH1wY8J9ExFogC8QpUNHd0IEWFpyV4TDfFkTmlEkiBZlW0kQrd7vJP5NrqfxgaqCp7YKn5ArUwCBVw9G9Wdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787674337; c=relaxed/simple;
	bh=pLm2ZjqQxst7DePqhIAj80sAqqZ9K1RjHIutntHNxnI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=a5ymmzSEd0xuHl9ysLUVKWGx0pwRycIoIKHiNBdfk4JGY4sMmQvCBc99zaVsWSWjM8xRaWqiB0C2u3ZzXxMSTSFdQKWWzAgeYvBsgOU+2JPBxLLy593T9WGqoeBGQHzMygQgRZix8WatYn93GDa2BnH7g/7aIrgiE675kzQiNvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JwKQPUEn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JwKQPUEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38ECA1F000E9;
	Tue, 25 Aug 2026 16:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787674334;
	bh=1DGw87PCSOICOo2Sk+Zz4MSYDgcmMExr9irdbtL9Als=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JwKQPUEn8TwDkAhgd9qlrKi7m3OWtNaLIQlRJecbR1RU6D8LcqBUydF9Ub45hbXqR
	 +nzwkgk3IWPFqWMgCwRLrv7YJrYyejw/vHfS8fH0RYH3xwrrTWvhCKFqqvcO2ARIoD
	 LTrSMoElXTOpN8RiqXKP9V6M9go6/oP26s18LUmPmMzuxpixc9r+k9qgavoX79JWQs
	 mENEmStd6+QSvWLEnIqZqI5yNaNjtNZNzgd0FwHzWbgk3gVKS4flKily/3OvxfTQIP
	 ET/QSQkkBgoFlzTVe4j4QSeLQloiBhvfqJE0MFHauLuYRYpxfvuBnRMqL54KcIn76M
	 gudEWOT/KDWyA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/17] mpi3mr: Fix buffer overflow when caching log
 data
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260825210411.301535-6-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
 <20260825210411.301535-6-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 16:12:13 +0000
Message-Id: <20260825161214.38ECA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unvalidated firmware input allows a small `reply_frame_size`, lead=
ing to `logdata_entry_sz =3D=3D 0`, which causes a ZERO_SIZE_PTR dereferenc=
e and Division by Zero.
- [High] Integer overflow in `sz` calculation in `mpi3mr_get_logdata` leads=
 to silent data truncation.
- [High] Missing locking and memory barriers for `logdata_buf` between BSG =
ioctl handlers and interrupt context causes torn reads and potential uninit=
ialized memory access.
- [High] MPI3_EVENT_DEVICE_INFO_CHANGED falls through to MPI3_EVENT_LOG_DAT=
A, ignoring device info changes and polluting log data.
- [High] Copying into a 1-element trailing array will trigger a FORTIFY_SOU=
RCE panic under -fstrict-flex-arrays=3D3.
--

commit 64e5ca8eae679f9947b56b20427a7ee194af1d35
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix buffer overflow when caching log data

This patch modifies mpi3mr_app_save_logdata_th to calculate the payload
room first and clamp the copy to it. It prevents a buffer overflow when
the entry size is derived from the controller reply size and is smaller
than the header.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
> index 94b992acb2330..cd772b2cb98ae 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -2947,7 +2947,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_=
job *job)
>  void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_da=
ta,
>  	u16 event_data_size)
>  {
> -	u32 index =3D mrioc->logdata_buf_idx, sz;
> +	u32 index =3D mrioc->logdata_buf_idx;
> +	size_t entry_payload_len, sz;
>  	struct mpi3mr_logdata_entry *entry;
> =20
>  	if (!(mrioc->logdata_buf))
>  		return;

[Severity: High]
This is a pre-existing issue, but are there missing memory barriers or lock=
ing
when accessing mrioc->logdata_buf?

mpi3mr_enable_logdata() allocates and initializes mrioc->logdata_buf,
mrioc->logdata_entry_sz, and mrioc->logdata_buf_idx from a user-space
BSG ioctl context without any serialization against the interrupt handler.

If firmware events trigger mpi3mr_app_save_logdata_th() via the hardware
interrupt handler concurrently, the lack of memory barriers might allow the
interrupt handler to observe a non-NULL buffer but an uninitialized size/in=
dex,
leading to corrupt calculations or out-of-bounds writes.

Additionally, user space copies the log buffer without serialization:

drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_get_logdata() {
    ...
    sg_copy_from_buffer(job->request_payload.sg_list,
                        job->request_payload.sg_cnt,
                        mrioc->logdata_buf, sz);
    ...
}

Could this lead to torn reads or corrupted logs if the interrupt handler
overwrites the ring buffer entries during the user-space copy operation?

> =20
>  	entry =3D (struct mpi3mr_logdata_entry *)
>  		(mrioc->logdata_buf + (index * mrioc->logdata_entry_sz));
>  	entry->valid_entry =3D 1;

[Severity: High]
This is a pre-existing issue, but might this dereference a ZERO_SIZE_PTR and
cause a kernel panic?

If the device firmware sets reply_frame_size to 5 (or less),
mrioc->reply_sz becomes 20 (or less). In mpi3mr_enable_logdata():

drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_enable_logdata() {
    ...
    mrioc->logdata_entry_sz =3D
        (mrioc->reply_sz - (sizeof(struct mpi3_event_notification_reply) - =
4))
        + MPI3MR_BSG_LOGDATA_ENTRY_HEADER_SZ;
    ...
}

Since the sizeof expression evaluates as a size_t, 20 - 24 underflows. The
result plus 4 wraps around to exactly 0 when assigned to the u16
logdata_entry_sz.

This causes kcalloc to return ZERO_SIZE_PTR (0x10). The check
if (!mrioc->logdata_buf) earlier in this function fails to catch this, lead=
ing
to a panic when writing to the unmapped address 0x10.

Additionally, could this cause a division by zero in mpi3mr_get_logdata()
when calculating num_entries?

drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_get_logdata() {
    ...
    num_entries =3D job->request_payload.payload_len / entry_sz;
    ...
}

> -	sz =3D min(mrioc->logdata_entry_sz, event_data_size);
> +	if (mrioc->logdata_entry_sz > MPI3MR_BSG_LOGDATA_ENTRY_HEADER_SZ)
> +		entry_payload_len =3D (size_t)mrioc->logdata_entry_sz -
> +		    MPI3MR_BSG_LOGDATA_ENTRY_HEADER_SZ;
> +	else
> +		entry_payload_len =3D 0;
> +	sz =3D min_t(size_t, entry_payload_len, event_data_size);
>  	memcpy(entry->data, event_data, sz);

[Severity: High]
This isn't a bug introduced by this patch, but will this memcpy trigger a
FORTIFY_SOURCE panic under -fstrict-flex-arrays=3D3?

The log data payload is copied into entry->data, which is defined as
__u8 data[1]; in the UAPI header struct mpi3mr_logdata_entry.

When compiled with -fstrict-flex-arrays=3D3, the compiler treats data stric=
tly
as a 1-byte array. The fortified memcpy() will evaluate __member_size() as =
1,
and since log events typically have a size > 1, this will deterministically
trigger a kernel panic upon receiving a log data event due to the detected
buffer overflow.

>  	mrioc->logdata_buf_idx =3D
>  		((++index) % MPI3MR_BSG_LOGDATA_MAX_ENTRIES);

[Severity: High]
This isn't a bug introduced by this patch, but could the size calculation in
mpi3mr_get_logdata() overflow and lead to silent data truncation?

drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_get_logdata() {
    u16 num_entries, sz, entry_sz =3D mrioc->logdata_entry_sz;
    ...
    sz =3D num_entries * entry_sz;
    ...
}

num_entries can be up to 400 (MPI3MR_BSG_LOGDATA_MAX_ENTRIES), and entry_sz=
 is
typically 236 bytes. The product 400 * 236 equals 94400, which exceeds the
maximum value of a 16-bit unsigned integer (65535).=20

Might this silently truncate/wrap around to 28864, causing
sg_copy_from_buffer() to return incomplete or corrupted log data back to
user space without generating an error?

[Severity: High]
This is a pre-existing issue, but is there an unintentional fall-through fr=
om
MPI3_EVENT_DEVICE_INFO_CHANGED to MPI3_EVENT_LOG_DATA?

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_os_handle_events() {
    ...
    case MPI3_EVENT_DEVICE_INFO_CHANGED:
    case MPI3_EVENT_LOG_DATA:

        if (mrioc->reply_sz > offsetof(struct mpi3_event_notification_reply,
                                       event_data))
            avail_reply_room =3D mrioc->reply_sz -
                offsetof(struct mpi3_event_notification_reply, event_data);
    ...
}

The switch case for MPI3_EVENT_DEVICE_INFO_CHANGED lacks the required
process_evt_bh =3D 1; assignment and a break; statement.=20

Will this cause device information changes to be permanently ignored (since
they are never queued to the fwevt_worker_thread), while erroneously passin=
g the
device page0 data payload to mpi3mr_app_save_logdata_th(), polluting the
log data ring buffer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825210411.3015=
35-1-chandrakanth.patil@broadcom.com?part=3D5
