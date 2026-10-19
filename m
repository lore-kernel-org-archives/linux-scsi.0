Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792449684;
	b=kWtgqlCM9eamaOeGSemkLStZ5h5jMeX1cATPzXRNEXg7WyFZQJpaCp2b3QoTrbnLOzkK
	 2it+EEbLF+CufcjRKT6iCXgkOtuQqmHg9XR3Idq3AsekyA4vZs0iERbbbnwZ5uj1pHSq+
	 IgVrTeT+53pupXrvxq4rtGlGGbaTFYWLEfwNu92adW36A9q5snuNAAot4qvdSmYXS33iW
	 yjDev7Dk6OHMaOZuMz6Ntnou0yhghRGj7facnaKZvOlOSulQHn7vpV582tAoei1IxF5e/
	 KXfOmWfMMYVmNiQS2DORZ93HICB6Hm1jhlvEjcrObc5GCUoplUHOQeTAlLxn+AQO0lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792449684;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=5I8Uj73gyoRR432Rub/bpIlQeSSKMwrrPYFOf+07yDw=;
	b=DZs1c/atX9PH7g2KW9jpKXcmnJepAbwy04kT10i90oqNqsJ5j+OoB8/UpJgdzCtIFZbU
	 a3WEbkiO+0613phA7UFwDmosUTa9u8BpfRoW+wnIBUPs9e+WUtTt6z+k3E+kUYyyOXzyl
	 8pc9IwFXC31Dntld6eK5tYdXfTQly6cJG9NB44X+F3as7aJ4oi5BsRMbCoCBw5gxeyyey
	 FegDPjC8RUpoqnbSUSRSsgEeTJkQPsbywGD8veS9D/Lq058audAV4skKM1G/vpFuvaGnv
	 PQ2vZUASmUdLmVR5xhpA8q7FdtE1Sbhx6sLdTzcH7e6pQt6GeJiOPTyoRColVUsOxsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b="kr6CFL/u";
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0B8606A319
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 22:41:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA0B8606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=kr6CFL/u
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j7rBC0VnDz1XM4Tn;
	Mon, 19 Oct 2026 22:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792449671; x=1795041672; bh=5I8Uj73gyoRR432Rub/bpIlQ
	eSSKMwrrPYFOf+07yDw=; b=kr6CFL/uJ5WPO1BNlemcDiiovUPNsHe8PW79jnZ8
	wyLG2kR6crv7anug3lwsMFxzrGRXhYF0X1lm2eHvCq4fy0/hg9n0t115n3zT8Zv8
	vKxXz0NdQ618hFIeBoKPGcXfh/AxKvV9vs2DOYkq4CeJ+nXp83GR4bavyTdYc/R2
	YtsKuxfBDyMnQwZuU2lBn9ixw36NkGP2jgIxYxTaNLXWPJA49oW/WtY29LrqbzCV
	OKkueHxDLKmKnFE0qJ8r2rjcrPkQZzV2+ufPF3qOKGFvJCPNPo05746hfuY6704W
	rHea+hRb145XRx02ftaFpYkkEwKfA9R4A+PHw7f7szTyMA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6i4r1K7nljBV; Mon, 19 Oct 2026 22:41:11 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j7r9y5NlXz1XM4Tl;
	Mon, 19 Oct 2026 22:41:10 +0000 (UTC)
Message-ID: <120fc95e-432a-4f05-aa87-54873363ed9f@acm.org>
Date: Mon, 19 Oct 2026 15:41:09 -0700
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] scsi: Refresh INQUIRY data and reprobe on rescan
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 James.Bottomley@HansenPartnership.com, Hannes Reinecke <hare@suse.de>,
 krishna.kant@purestorage.com
References: <20261019221405.40614-1-brian@purestorage.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261019221405.40614-1-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/19/26 3:13 PM, Brian Bunker wrote:
> This series teaches the SCSI rescan path to refetch standard INQUIRY da=
ta
> and reprobe the device when the peripheral qualifier or device type has
> changed.  The motivating case is an ALUA target that transitions throug=
h
> the "unavailable" state and afterwards reports a different peripheral
> qualifier; today the kernel keeps the stale INQUIRY data and the device=
's
> sysfs attributes diverge from what the target reports.

Some feedback from an experimental LLM can be found below. Please take a
look.

Thanks,

Bart.
------------------------------------------------------------------------
I reviewed the v8 series and wrote it up in=20
review-v8-inquiry-reprobe.md. 4/5 and 5/5 have real bugs, and the design=20
has one open question for you. The series applies cleanly to=20
db8b4d2bf2d3, and each patch built with no W=3D1 warnings for scsi.o,=20
scsi_scan.o and scsi_sysfs.o. checkpatch --strict only reported nits.

The open question: a target can now remove a disk that is bound and in=20
use. scsi_bus_match() only matches devices whose peripheral qualifier=20
(PQ) is 0. So if a LUN changes PQ from 0 to 1, device_reprobe() detaches=20
sd and the disk disappears. That can be triggered by a unit attention, a=20
sysfs rescan, or (after 5/5) any scan. My suggestion is to only reprobe=20
when no driver is bound (PQ 1 =E2=86=92 0), but the author should say whi=
ch=20
direction the ALUA case actually needs.

Bugs in 4/5:

device_reprobe() error check: it returns 0 when sd_probe() fails, and a=20
negative value for -EPROBE_DEFER. So the check misses real failures and=20
marks the device offline when probing is merely deferred.
Offlining can't be undone: scsi_rescan_device() gives up unless the=20
device is SDEV_RUNNING, so an offlined device never comes back through a=20
later rescan. I'd drop the offline step.
sdev->inquiry_len changes meaning: on a live device it holds the=20
previous response length, not the LLD limit, which breaks=20
scsi_probe_lun()'s retry passes.
NULL dev->p dereference: possible when a reprobe happens before=20
scsi_sysfs_add_sdev() has run, e.g. during async scans. 4/5 and 5/5=20
should check is_visible.

Problems in 5/5:

Every scan now does a full rescan of every existing LUN while holding=20
scan_mutex. One hung LUN stalls the whole scan.
LUN 0 gets rescanned twice per scan, or right after it is created.

Other points:

In 1/5, cdl_supported doesn't come from INQUIRY, so the mutex doesn't=20
protect it.
2/5 and 3/5 should be merged into one patch, and=20
scsi_update_inquiry_data() should stay internal to the SCSI core rather=20
than go in the public scsi_device.h.
3/5 deletes a still-useful comment explaining why PQ=3D1 devices are crea=
ted.
The rescan path skips the scan path's checks for PQ=3D3 and PQ=3D1/PDT=3D=
0x1f=20
("no LUN" responses).
A change of vendor or model (a different LU behind the same LUN) is=20
accepted silently, leaving the device flags and handler stale.

Sashiko had already flagged the device_reprobe() error check,=20
inquiry_len, the NULL dereference and the double LUN 0 rescan. I checked=20
each against the code and they hold up. The review file says which=20
findings came from it.
------------------------------------------------------------------------
# Review: [PATCH v8 0/5] scsi: Refresh INQUIRY data and reprobe on rescan

Series:=20
<https://lore.kernel.org/linux-scsi/20261019221405.40614-1-brian@purestor=
age.com/>
Base: `db8b4d2bf2d3` (7.4/scsi-staging). Applies cleanly.

**Build/checkpatch:** each patch builds without warnings with gcc W=3D1=20
(`scsi.o`, `scsi_scan.o`, `scsi_sysfs.o`, x86_64 defconfig). `checkpatch=20
--strict` reports only nits (1/5: `S_IRUGO`; 2/5: parenthesis alignment=20
at `scsi.c:736`; 4/5: quoted string split across lines, which was=20
already there).

Sashiko has already replied to 4/5 and 5/5. I checked its findings=20
against the code and note below which ones hold up.

---

## Design-level concerns (cover letter / 4/5 / 5/5)

1. **A target can now unbind sd from a live disk.** `scsi_bus_match()`=20
only matches `inq_periph_qual =3D=3D 0`. If a bound LUN changes PQ from 0=
 to=20
1, `device_reprobe()` detaches sd and the gendisk goes away. The trigger=20
can be a UNIT ATTENTION "INQUIRY DATA HAS CHANGED"=20
(`scsi_evt_thread()`), a sysfs `rescan`, or, after 5/5, any host or=20
transport scan. With dm-multipath that means a path is torn down for=20
something that may be a short ALUA transition. Without multipath, a=20
mounted filesystem loses its block device. When PQ returns to 0, the=20
disk comes back under a new `sdX` name, and only if someone rescans again=
.
    - Please describe the exact direction the motivating case needs. My=20
guess is a LUN found while PQ=3D1 that later reports PQ=3D0, so no ULD is=
=20
bound yet. If so, only reprobe when `!dev->driver` (or only for PQ 1 =E2=86=
=92=20
0) and leave bound devices alone.
    - Cite the SPC text that requires a PQ change across the ALUA=20
unavailable state. SPC-4 5.15.2.4.4 (cited in 4/5) describes which=20
commands an unavailable LU must support. It isn't obvious that it=20
requires the PQ to change.

2. **5/5 widens rescan behaviour a lot.** Today a scan (`echo - - - >=20
scan`, FC RSCN =E2=86=92 `fc_scsi_scan_rport()`, iSCSI session rescan, ..=
.) does=20
nothing for LUNs that already exist. After 5/5, every existing LUN gets=20
a full `scsi_rescan_device()`: an INQUIRY of up to 3 passes =C3=97 3 retr=
ies,=20
VPD re-read, CDL check, `handler->rescan` and `sd_rescan()` =E2=86=92=20
revalidate. All of this runs with `shost->scan_mutex` held. On hosts=20
with many LUNs this costs a lot. One unresponsive LUN now stalls the=20
whole scan, and every other scanner waits on `scan_mutex`. The commit=20
message should say this explicitly. Better still, limit the scan path to=20
the INQUIRY refresh / PQ check.

3. **The rescan path doesn't apply the scan path's "no LUN" filters.**=20
`scsi_probe_and_add_lun()` drops PQ=3D3 and PQ=3D1/PDT=3D0x1f responses. =
The=20
refresh path accepts them as-is: `sdev->type =3D 0x1f`, `inq_periph_qual =
=3D=20
3`, the ULD is unbound, and the `scsi_device` lives on in a state the=20
scan path would never create. Decide how these responses should be=20
handled, for example leave them to the REPORTED LUNS DATA HAS CHANGED /=20
removal logic.

4. **Identity changes are silently accepted.** If vendor/model change, a=20
different LU now sits behind this LUN. `sdev_bflags`, the device handler=20
(attached once in `scsi_sysfs_add_sdev()`), TPGS-based decisions, etc.=20
are all stale. `scsi_probe_lun()` computes fresh `bflags` on a rescan=20
and then discards them. Either reject or warn on a vendor/model change,=20
or don't refresh these strings at all.

---

## 1/5 scsi: core: Protect INQUIRY sysfs attributes with mutex

- `cdl_supported` is not derived from INQUIRY. `scsi_cdl_check()` sets=20
it from RSOC data without `inquiry_mutex`, so the lock protects nothing=20
for it. The commit message also lists it as INQUIRY-derived.
- The `vendor`/`model`/`rev` strings and `sdev->inquiry` are also read=20
without a lock by in-kernel users (`scsi_transport_spi.c:217`,=20
`scsi_dh_emc.c:355`, `mpt3sas`, `sdev_printk` callers, the=20
`scsi_device_tpgs()`-style helpers). The mutex only makes sysfs=20
consistent. Please don't claim more than that, and consider=20
`data_race()` annotations or a note about KCSAN.
- `sdev->type` is written with `WRITE_ONCE()` (2/5) but read with=20
`READ_ONCE()` only in `scsi_bus_uevent()`. The many plain readers (sd,=20
st, sr, `scsi_lib`) are still unannotated.
- Moving `cdl_supported` to a different position in the list is=20
unrelated churn. Nit: use `0444` instead of `S_IRUGO` in the new macro bo=
dy.

## 2/5 scsi: core: Add scsi_update_inquiry_data()

- **Placement:** this is SCSI-core-internal and only `scsi_scan.c` calls=20
it, yet it lives in `scsi.c` and is declared, together with `enum=20
scsi_inq_update_result`, in the public `include/scsi/scsi_device.h`=20
without an export. Move it to `scsi_scan.c` (static) or at least declare=20
it in `scsi_priv.h`.
- **Patch split:** 2/5 adds a copy of the `scsi_add_lun()` logic with no=20
caller, and 3/5 deletes the original. Merging 2/5 and 3/5 into one patch=20
would make the move reviewable as a move.
- "First call" is inferred from `refresh =3D !new_inquiry`, i.e. from=20
whether a buffer was allocated. An explicit `bool initial` argument=20
would be clearer and less fragile.
- `int` return mixes negative errnos with enum values. That works, but=20
returning the enum and passing errors back separately, or using `bool=20
*reprobe`, would be cleaner.
- `memcpy()` into the live `sdev->inquiry` while other code reads it=20
without a lock (see 1/5) is a data race. It's byte-granular, so probably=20
harmless, but it should be documented or annotated.
- On a refresh, `sdev->scsi_level` is updated but `starget->scsi_level`=20
and `lun_in_cdb` deliberately aren't (4/5). After a level change they=20
disagree. Consider not refreshing `scsi_level` either.
- Nit: with a zeroed 256-byte buffer, the=20
`memcpy()`-instead-of-`strscpy()` comment for `rev` is no longer=20
accurate. The `__func__` in the W-LUN warning now prints=20
`scsi_update_inquiry_data` instead of `scsi_add_lun`.

## 3/5 scsi: core: Refactor scsi_add_lun()

- This deletes the comment explaining why a `scsi_device` is still=20
created for PQ=3D1 and why the ULD decides whether to attach. That=20
rationale still applies and becomes more relevant with this series, so=20
please keep it next to the PQ handling.
- "This patch maintains identical behavior": not quite. `sdev->inquiry`=20
is now 256 bytes instead of `max(inquiry_len, 36)`, and=20
`sdev->scsi_level` stays 0 between `scsi_probe_lun()` and=20
`scsi_add_lun()`. Both are harmless, but the claim should be softened.

## 4/5 scsi: core: Add device reprobe support to scsi_rescan_device()

- **The `device_reprobe()` error check is broken (Sashiko is right).**=20
`really_probe()` turns probe errors into positive values, and=20
`bus_rescan_devices_helper()` returns `ret < 0 ? ret : 0`. So a failing=20
`sd_probe()` gives 0 and the device stays RUNNING without a driver.=20
Meanwhile `-EPROBE_DEFER` (e.g. `defer_all_probes` during suspend) gives=20
a negative value and marks the device offline.
- **Offlining on reprobe failure can't be undone.**=20
`scsi_rescan_device()` bails out with `-EWOULDBLOCK` unless the device=20
is `SDEV_RUNNING`, so an offlined device can never recover through a=20
later rescan. Not finding or binding a ULD is not an I/O error. I'd drop=20
the `SDEV_OFFLINE` transition completely and just log.
- **`sdev->inquiry_len` changes meaning (Sashiko is right).** In=20
`scsi_probe_lun()`, `sdev->inquiry_len` is the LLD-provided maximum /=20
first-pass length. On a live device it now holds the previous response=20
length. Pass 1 then starts at that length, with no fallback to 36 if it=20
fails, and pass 2 is capped at the old length. Keep the LLD limit in a=20
separate field, or pass the initial length in explicitly.
- **NULL `dev->p` dereference before `device_add()`.** `scsi_add_lun()`=20
sets `SDEV_RUNNING` before `scsi_sysfs_add_sdev()`, and async scans=20
defer that call. A rescan in that window, from a UA event or from 5/5,=20
that decides to reprobe calls `__device_attach()` with `dev->p =3D=3D NUL=
L`.=20
Check `sdev->is_visible` / `device_is_registered()` before reprobing.
- The device lock is dropped around `device_reprobe()`, so the state may=20
change in between. Anything assumed before the unlock should be=20
rechecked afterwards (the `CANCEL`/`DEL` check partly does this).
- Nit: `kmalloc(256, ...)` / `256` are magic numbers. Share a constant=20
with 2/5.
- Every existing `scsi_rescan_device()` caller (libata resume,=20
virtio_scsi, storvsc, smartpqi, aacraid, mvumi, the UA event) now sends=20
an extra INQUIRY. Fragile USB/ATA bridges have a history of disliking=20
extra INQUIRYs, so call this out in the commit message.

## 5/5 scsi: core: Handle reprobe for existing devices during SCSI scan

- `!scsi_device_created(sdev)` doesn't imply the device is registered.=20
During async scans, `scsi_sysfs_add_sdev()` is deferred (same issue as=20
above). Add an `sdev->is_visible` check.
- `__scsi_scan_target()` probes LUN 0 and then `scsi_report_lun_scan()`=20
visits LUN 0 again with the same `rescan` value. A newly added LUN 0 is=20
therefore "rescanned" right after creation, which blocks on=20
`device_lock()` while async `sd_probe()` runs with `scan_mutex` held. An=20
existing LUN 0 is rescanned twice per scan.
- See design concern 2 on the cost and `scan_mutex` hold time.

---

## Summary

1/5 is close, apart from the `cdl_supported` and scope points. 2/5 and=20
3/5 should be merged and kept inside the SCSI core. 4/5 and 5/5 have=20
real correctness bugs: the reprobe error handling, the irreversible=20
offlining, the changed meaning of `inquiry_len`, and a NULL `dev->p`=20
dereference during async scans. The bigger open question is whether=20
unbinding sd from a bound, in-use disk because the target says so is=20
acceptable at all. I'd ask for it to be limited to binding a ULD when=20
none is bound.

