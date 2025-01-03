Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BD51DFCB
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jan 2025 00:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735865600; cv=none; b=vAX2Q9B8KJvvi9RD1wH1x8hZ+jsikbs3QLE0hDzP+wnZM/plamNCmEFUOm4pQ5ZHu+RT2KhVmUSx+o5JSHNCkvpXJrGETPXZHkCg4V0sO3YMqNJ+uiMTZpfPBf3qIF0ksnaYLMm0haZooZIXKUNMPnHrkJ3naMtus1skK3jEut4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735865600; c=relaxed/simple;
	bh=4UDwjfk1Ts7ZNLFM/VquWZqkE9Gd90fi75++iYqozmw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dbEC3WfRm76EoEiQe043aUhs1RRRBFoeLaLYATMwLSBCjGV2MPPl0OHp6/B4LVgZd9bkUha9mB+r0Q9sdacOZzQAqdSeheIyKhmIyplDpBF4U+RMocfEHpL8JxKitQ25OV0RuDJKtnemE/rqOLldi6f53HUDzv6upcb4zZkt2gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GTzqIYHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GTzqIYHr"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3CFE5C4CED0
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jan 2025 00:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735865599;
	bh=4UDwjfk1Ts7ZNLFM/VquWZqkE9Gd90fi75++iYqozmw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=GTzqIYHr02/7lTH5Y8JJxxvVMTpudncblXCKELsKH9/4jZ8x2ORqHGWU2uB8lF6j0
	 DDdn5yTMzr9xQPHFMfa3a8yO1EFq/mXit/2z+3U0g7Fw+lE0ilpRwyqqnyFI9aDXMS
	 hCJwWsNfpPjyBjC4Zb3wh3ykqN3VSGXD0AAvnVU7YpzVOWWEUh4e/PNLZqNX6o6mQK
	 iRPhGWruPRX5shLErnpdtM1J/tGtu3IV3urDOZj7L9ytR64jotvPlERKXaOzh5rvJu
	 JI6RLF+pKsRIhhBb6APvyV4YyIIEuP7bWpioDKrzYotvHvwYIvsYG1MvfzjbPeT8qu
	 obtldVBRSyTQA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 315F5C41613; Fri,  3 Jan 2025 00:53:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219652] READ CAPACITY(16) not used on large USB-attached drive
 in recent kernels
Date: Fri, 03 Jan 2025 00:53:18 +0000
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
Message-ID: <bug-219652-11613-213Ju5Ap5L@https.bugzilla.kernel.org/>
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

--- Comment #6 from michael.christie@oracle.com ---
On 1/1/25 6:57 PM, bugzilla-daemon@kernel.org wrote:
> * When booting into kernel 6.12.7, the external drive capacity
>   is mis-reported.  Booting /back/ into 6.6.68, the capacity
>   continues to be mis-reported.  One must now yank the USB
>   cable (or power-cycle) to get the correct size detection again.

That part is really strange. I wonder if the new code is not
resetting the device and the old code was somehow.
>=20
> Here is a diff of the dmesg output when plugging in the drive.
> From (-) is kernel 6.1.122
> To   (+) is kernel 6.12.7:
>  scsi host12: usb-storage 1-13:1.0
>  scsi 12:0:0:0: Direct-Access     TOSHIBA  DT01ACA300       3.00 PQ: 0 AN=
SI:
>  4
>  sd 12:0:0:0: Attached scsi generic sg1 type 0
> -sd 12:0:0:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
> -sd 12:0:0:0: [sdb] 5860533167 512-byte logical blocks: (3.00 TB/2.73 TiB)
> +sd 12:0:0:0: [sdb] 4294967295 512-byte logical blocks: (2.20 TB/2.00 TiB)
>  sd 12:0:0:0: [sdb] Write Protect is off
>  sd 12:0:0:0: [sdb] Mode Sense: 23 00 00 00
>  sd 12:0:0:0: [sdb] No Caching mode page found
>  sd 12:0:0:0: [sdb] Assuming drive cache: write through
> -sd 12:0:0:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
> - sdb: sdb1
>  sd 12:0:0:0: [sdb] Attached SCSI disk
>=20
> I am attaching a diff of the usbmon output for the earlier kernel (good) =
and
> current kernel (bad),

Just to start can you tell me what the device is returning?

We hit that "Very big device" code path if the device returns a size
of 0xffffffff or larger so with the old code we at some point returned
a large size. With the new code the device returns only 0xfffffffe
(4294967294) (read_capacity_10 does a lba that we got from the device + 1
so you see 4294967295 in the log message) so we never hit that very
bit device code path and try READ CAPACITY(16).

I might have changed some behavior during the retries that causes us
to not get the right size now.  However, I couldn't fully understand
the output of the usbmon traces. Can you tell me when we do the READ
CAPACITY (10) what the device is returning? Is it returning a sense
error like UNIT_ATTENTION a couple times and when it returns success
what's in the data buffer?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
