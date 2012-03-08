From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: add LBPRZ support
Date: Wed, 07 Mar 2012 20:00:12 -0500
Message-ID: <4F58049C.5010505@interlog.com>
References: <4F57C061.9020807@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:57042 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab2CHBAV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Mar 2012 20:00:21 -0500
In-Reply-To: <4F57C061.9020807@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, mkp@mkp.net, =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>

On 12-03-07 03:09 PM, Eric Sandeen wrote:
> Add LBPRZ support to scsi_debug; i.e. return zero for
> unmapped blocks.
>
> Rather than checking for unmapped blocks at
> read time, this just zeroes them on the backing store
> at unmap time so it behaves the same way.
>
> This also adds a module parameter to disable it, since
> some SSDs have this behavior.
>
> unmap_zeroes, "unmapped blocks return 0 on read (def=1)"
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>
> Note: This was sent long ago as "TPRZ" support, but lost, I guess.
>
> Note2: dgilbert preferred "zeros" to "zeroes" at the time,
> but since we have "discard_zeroes_data" in sysfs it seems like
> we should be consistent with the kernel precedent, rather than
> the spec spelling.

Eric,
I checked the latest drafts of SPC-4 and SBC-3 and they
contain both "zeros" and "zeroes". Take your pick!

More seriously the LBPRZ flag now appears in the Logical
Block Provisioning VPD page and the READ CAPACITY (16)
response. Your patch sets the latter, could you add the
LBPRZ flag setting in the inquiry_evpd_b2() function as
well. Perhaps:
   if (scsi_debug_unmap_zeroes)
     arr[1] |= 1 << 2;

And if your are editing that function in the comment introducing
that function:
    s/Thin/Logical block/
to reflect the renaming done by t10.org .

Ah, and inquiry_evpd_b2() should return 4 (not 8).

Otherwise it looks good.

Doug Gilbert

