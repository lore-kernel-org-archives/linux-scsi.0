From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v2] scsi: introduce short_inquiry flag for broken host adapters
Date: Tue, 15 Sep 2015 16:27:03 +0200
Message-ID: <87k2rryczs.fsf@vitty.brq.redhat.com>
References: <1441296673-14315-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441296673-14315-1-git-send-email-vkuznets@redhat.com> (Vitaly
	Kuznetsov's message of "Thu, 3 Sep 2015 18:11:13 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>, Long Li <longli@microsoft.com>, Dexuan Cui <decui@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Some host adapters (e.g. Hyper-V storvsc) are known for not respecting the
> SPC-2/3/4 requirement for 'INQUIRY data (see table ...) shall contain at
> least 36 bytes'. As a result we get tons on 'scsi 0:7:1:1: scsi scan:
> INQUIRY result too short (5), using 36' messages on console. This can be
> problematic for slow consoles. Introduce short_inquiry host template flag
> to avoid printing error messages for such adapters.
>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> Changes since v1:
> - This is a successor of previously sent "scsi_scan: move 'INQUIRY result
>   too short' message to debug level" patch. Instead of moving the message
>   to debug level for all adapters introduce a special 'short_inquiry' flag
>   for host template [inspired by James Bottomley].

James,

sorry for the ping but can you please let me know your opinion? This is
not a 'cosmetic fix', serial port on Hyper-V is extremely slow and users
get softlockups just because we output too much. Here is a freshly
booted guest with SCSI and FC adapters connected:

# dmesg | grep -c INQUIRY
2076

(my other pernding '[PATCH] scsi_scan: don't dump trace when
scsi_prep_async_scan() is called twice' is related to the same issue).

See also: https://lkml.org/lkml/2015/9/6/119

Thanks,

[...]

-- 
  Vitaly
