From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: Re: [PATCH v4] scsi/ata: Use unsigned int for cmd's type in ioctls in
 scsi_host_template
Date: Thu, 7 Feb 2019 11:52:58 +0100
Message-ID: <97d4ab84-f64b-9276-b7a9-3b3be5f5d527@free.fr>
References: <20190114044206.6351-1-natechancellor@gmail.com>
 <20190126075256.29608-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190126075256.29608-1-natechancellor@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 26/01/2019 08:52, Nathan Chancellor wrote:

> Clang warns several times in the scsi subsystem (trimmed for brevity):
> 
> drivers/scsi/hpsa.c:6209:7: warning: overflow converting case value to
> switch condition type (2147762695 to 18446744071562347015) [-Wswitch]
>         case CCISS_GETBUSTYPES:
>              ^
> drivers/scsi/hpsa.c:6208:7: warning: overflow converting case value to
> switch condition type (2147762694 to 18446744071562347014) [-Wswitch]
>         case CCISS_GETHEARTBEAT:
>              ^
> 
> The root cause is that the _IOC macro can generate really large numbers,
> which don't find into type 'int', which is used for the cmd paremeter in
              ^^^^                                            ^^^^^^^^^

"which don't fit"
"the cmd parameter"

Regards.

> the ioctls in scsi_host_template. My research into how GCC and Clang are
> handling this at a low level didn't prove fruitful. However, looking at
> the rest of the kernel tree, all ioctls use an 'unsigned int' for the
> cmd parameter, which will fit all of the _IOC values in the scsi/ata
> subsystems.
> 
> Make that change because none of the ioctls expect to take a negative
> value, it brings the ioctls inline with the reset of the kernel, and it
> removes ambiguity, which is never good when dealing with compilers.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/85
> Link: https://github.com/ClangBuiltLinux/linux/issues/154
> Link: https://github.com/ClangBuiltLinux/linux/issues/157
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
> 
> v3 -> v4:
> 
> * Repost with Bart's suggested change and his reviewed by (mainly as an
>   excuse to repost with the below comment).
> 
> v2 -> v3:
> 
> * Fix another -Wswitch warning from drivers/scsi/cxlflash/main.c, coming
>   from decode_hioctl (uncovered via a powernv_defconfig build).
> 
> v1 -> v2:
> 
> * Fix build breakage in cxlflash driver from forgetting to update
>   prototype (thanks to 0day for catching it).
> 
> I apologize for resending this so soon after v3 but it has been three
> months since I sent this patch and I have yet to receive a single
> comment from ANY of the maintainers that './scripts/get_maintainer.pl'
> spits out for this patch so it feels like I am sending it into the void.
> 
> I understand you all are busy people and such and maybe I am being
> impatient but these warnings are rather spammy and we're trying to get
> that category cleaned up as quick as possible so that new warnings are
> easier to spot. I'd appreciate any and all reviews/acks/testing that I
> can get on this patch (especially since it is so simple) so it can be
> accepted and merged into mainline.
