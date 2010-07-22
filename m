From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] BISECTED x86: avoid qword access in memcpy_*io
Date: Wed, 21 Jul 2010 20:59:48 -0700
Message-ID: <4C47C234.7040400@zytor.com>
References: <4C464BA0.20609@jp.fujitsu.com> <4C465FF0.1030407@zytor.com> <4C479D7F.2070204@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:57783 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab0GVEAQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jul 2010 00:00:16 -0400
In-Reply-To: <4C479D7F.2070204@jp.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Brian Gerst <brgerst@gmail.com>

On 07/21/2010 06:23 PM, Hidetoshi Seto wrote:
> 
> It seems that lpfc already implemented lpfc_memcpy_{to,from}_slim()
> as such memcpy_*io32, but limited use of it to on big endian platforms
> only.  Now lpfc can move to use it always, right?
> 

What it probably should do is instead of open-coding this stuff use
__iowrite32_copy and we probably should have a version without double
underscores which byteswaps on bigendian.

Personally I would not object to seeing a patch renaming
__iowrite32_copy() to memcpy_toio32()... especially since it doesn't
have the "memory or I/O space" property of iowrite and friends.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

