From: Dison River <pwn2river@gmail.com>
Subject: Buffer overflow in the mptctl_replace_fw() function in linux kernel
 MPT ioctl driver
Date: Fri, 1 Sep 2017 14:00:48 +0800
Message-ID: <CAJsXRPFEOoZjHKhJ=1rfXpmFqEdaORtxYUkm3bRJ_v+_oENt3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, security@kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi:
Buffer overflow in the mptctl_replace_fw() function in linux kernel
MPT ioctl driver.

In mptctl_replace_fw function, kernel didn't check the size of
"newFwSize" variable allows attackers to cause a denial of service via
unspecified vectors that trigger copy_from_user function calls with
improper length arguments.


static int
mptctl_replace_fw (unsigned long arg)
{
......
    if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_replace_fw))) {
        printk(KERN_ERR MYNAM "%s@%d::mptctl_replace_fw - "
            "Unable to read in mpt_ioctl_replace_fw struct @ %p\n",
                __FILE__, __LINE__, uarg);
        return -EFAULT;
    }

......

    mpt_free_fw_memory(ioc);

    /* Allocate memory for the new FW image
     */
    newFwSize = ALIGN(karg.newImageSize, 4);

    mpt_alloc_fw_memory(ioc, newFwSize);
......

    if (copy_from_user(ioc->cached_fw, uarg->newImage, newFwSize)) {
///------->newFwSize can control in userspace
        printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_replace_fw - "
                "Unable to read in mpt_ioctl_replace_fw image "
                "@ %p\n", ioc->name, __FILE__, __LINE__, uarg);
        mpt_free_fw_memory(ioc);
        return -EFAULT;
    }

......

    return 0;
}
