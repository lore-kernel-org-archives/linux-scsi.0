From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13311] mptsas: ioc0: removing ssp device, kernel oops
Date: Thu, 28 May 2009 11:54:23 GMT
Message-ID: <200905281154.n4SBsNmh007953@demeter.kernel.org>
References: <bug-13311-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59423 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbZE1LyV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2009 07:54:21 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4SBsNhQ007954
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 11:54:23 GMT
In-Reply-To: <bug-13311-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D13311





--- Comment #2 from Kay Sievers <kay.sievers@vrfy.org>  2009-05-28 11:5=
4:23 ---
On Thu, May 28, 2009 at 10:00, Andrew Morton <akpm@linux-foundation.org=
> wrote:

>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Product: SCSI Drivers
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Version: 2.5
>> =C2=A0 =C2=A0 Kernel Version: 2.6.27.21
>
> Is it reproducible? =C2=A0If so, is there any change that it can be r=
etested
> under a 2.6.29-based kernel?

This driver version:
  MPT_LINUX_VERSION_COMMON       "4.00.43.00suse"
seems not in the upstream kernel:
  MPT_LINUX_VERSION_COMMON       "3.04.07"

The failing code is only in the new driver. This bug should move to
the Novell bugzilla, so the people who added the driver to the SUSE
kernel can check with LSI directly.

> OK, I assume that the scsi driver did something bad to sysfs and
> that sysfs then fell on its face.
>
> Really, given the frequency and imaginativeness with which drivers
> abuse sysfs, the driver-core should be more robust.
>
> Kay, would you have time to plunk through this and see if we can
> strengthen the sysfs code a bit so it doesn't crash?

Might be a missing lock/wrong refcounting issue in the caller, where
two threads try to remove the same thing. With Eric's upcoming changes
to the cleanup logic in sysfs, this should be handled better.

Thanks,
Kay

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
