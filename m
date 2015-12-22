From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2 0/3] scsi: reduce CONFIG_SCSI_CONSTANTS=y impact by 8k
Date: Tue, 22 Dec 2015 15:25:14 -0500
Message-ID: <5679B1AA.3040304@interlog.com>
References: <1448358147-23663-1-git-send-email-linux@rasmusvillemoes.dk>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448358147-23663-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "James E.J. Bottomley" <JBottomley@odin.com>, Julian Calaby <julian.calaby@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 15-11-24 04:42 AM, Rasmus Villemoes wrote:
> This reduces the impact of choosing by about 8KB.
>
> 2dd951ecd511 ("scsi: Conditionally compile in constants.c") updated
> the Kconfig help text from 12KB to 75KB. The 12K predated git so was
> certainly outdated. But I'm not sure where the 75K comes from; using
> size(1) on a defconfig (with/without this config option) vmlinux shows
> a difference of about 47K, and 39K after these patches are applied. In
> any case, I've left the Kconfig text alone, since I'm not sure I'm
> counting the same way the 75K was computed (I'm fairly certain of the
> 8K delta, however).
>
> Tested with a trivial module calling scsi_extd_sense_format with a few
> random known codes and comparing the result to the expected value.
>
> v2: prepend patch to unsplit a few string literals for greppability,
> leave the NULL sentinel in the .c file in 2/3 (it's removed in 3/3
> either way).
>
> Rasmus Villemoes (3):
>    scsi: make some Additional Sense strings more grep'able
>    scsi: move Additional Sense Codes to separate file
>    scsi: reduce CONFIG_SCSI_CONSTANTS=y impact by 8k


I have been asked by Martin to look at this series of patches.
The 75 KB win when CONFIG_SCSI_CONSTANTS ("constants") is not
given, looks like an exaggeration. This from dmesg on my x64
lk 4.3.3 kernel before any changes (constants selected):
   Memory: 3708576K/3874608K available (6217K kernel code, 888K rwdata,
           2624K rodata, 1164K init, 13736K bss, 166032K reserved ...

With these changes (constants selected):
   Memory: 3708592K/3874608K available (6217K kernel code, 880K rwdata,
           2616K rodata, 1164K init, 13736K bss, 166016K reserved ...

With these changes (constants not selected):
   Memory: 3708628K/3874608K available (6216K kernel code, 884K rwdata,
           2580K rodata, 1160K init, 13736K bss, 165980K reserved ...

The significant change is with the rodata. So there is an 8 KB win
with this patch set, constants selected, as Rasmus said. But with this
patch the win for constants deselected shrinks to 36 KB (from 44 KB).


As for the patch, I don't see the sense of putting all the array
elements in a header file since it is only reasonable to include
that header file one or zero times in the kernel. Also that header
file include must be embedded inside an array definition (while
most headers are included at file scope and contain guards against
multiple inclusion). Perhaps that header file may be useful for
user space tools to include?

Anyway, with light testing my kernels above properly reported
SCSI status/sense_data with these patches both with constants
selected/de-selected.

Doug Gilbert
