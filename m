From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Debugging scsi abort handling ?
Date: Sat, 23 Aug 2014 11:42:44 -0400
Message-ID: <53F8B674.2090103@interlog.com>
References: <53F8AAA8.8040407@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:56134 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbaHWPms (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Aug 2014 11:42:48 -0400
In-Reply-To: <53F8AAA8.8040407@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 14-08-23 10:52 AM, Hans de Goede wrote:
> Hi All,
>
> Now that the UAS driver is no longer marked as CONFIG_BROKEN,
> I'm getting quite a few bug reports about issues with UAS drives.
>
> One if the issues is that there might be a number of bugs in the
> abort handling path, as I don't think that was ever tested properly.
>
> So I'm wondering is there a way to test the abort path with a real
> drive? E.G. submit some command which is known to take a significant
> amount of time, and then abort it right after submitting ?

Hi,
You might experiment with starting a streaming read
from one shell (e.g. with dd or ddpt) and while that
is underway, from another shell issue a
'sg_reset --device' and see what happens. If nothing then
try 'sg_reset --target'.

Aborting a single, long duration command from the user
space (and only that command, assuming other processes might
be using that disk) is not easy to do.

Doug Gilbert


