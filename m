From: Kees Cook <keescook@chromium.org>
Subject: Re: Buffer overflow in the mptctl_replace_fw() function in linux
 kernel MPT ioctl driver
Date: Thu, 31 Aug 2017 23:44:37 -0700
Message-ID: <CAGXu5j+kg8WXMwW-Sd5GYWxpmwhtRfUnHEVyrNTim2PfKoD67w@mail.gmail.com>
References: <CAJsXRPFEOoZjHKhJ=1rfXpmFqEdaORtxYUkm3bRJ_v+_oENt3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJsXRPFEOoZjHKhJ=1rfXpmFqEdaORtxYUkm3bRJ_v+_oENt3Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dison River <pwn2river@gmail.com>
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "security@kernel.org" <security@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 31, 2017 at 11:00 PM, Dison River <pwn2river@gmail.com> wrote:
> Hi:
> Buffer overflow in the mptctl_replace_fw() function in linux kernel
> MPT ioctl driver.
>
> In mptctl_replace_fw function, kernel didn't check the size of
> "newFwSize" variable allows attackers to cause a denial of service via
> unspecified vectors that trigger copy_from_user function calls with
> improper length arguments.

Is there a specific path you see to trigger this?

>
>
> static int
> mptctl_replace_fw (unsigned long arg)
> {
> ......
>     if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_replace_fw))) {
>         printk(KERN_ERR MYNAM "%s@%d::mptctl_replace_fw - "
>             "Unable to read in mpt_ioctl_replace_fw struct @ %p\n",
>                 __FILE__, __LINE__, uarg);
>         return -EFAULT;
>     }
>
> ......
>
>     mpt_free_fw_memory(ioc);

This frees ioc->cached_fw.

>
>     /* Allocate memory for the new FW image
>      */
>     newFwSize = ALIGN(karg.newImageSize, 4);
>
>     mpt_alloc_fw_memory(ioc, newFwSize);

This allocates ioc->cached_fw to newFwSize.

> ......
>
>     if (copy_from_user(ioc->cached_fw, uarg->newImage, newFwSize)) {

This copies newFwSize bytes into a buffer that is allocated to newFwSize bytes.

What am I missing? I see some games getting played in
mpt_alloc_fw_memory(), but they seem to be covered due to the earlier
call to mpt_free_fw_memory()...

-Kees

> ///------->newFwSize can control in userspace
>         printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_replace_fw - "
>                 "Unable to read in mpt_ioctl_replace_fw image "
>                 "@ %p\n", ioc->name, __FILE__, __LINE__, uarg);
>         mpt_free_fw_memory(ioc);
>         return -EFAULT;
>     }
>
> ......
>
>     return 0;
> }

-Kees

-- 
Kees Cook
Pixel Security
