From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v3 13/13] scsi: ufs: Add exynos ufs platform data
Date: Thu, 01 Oct 2015 13:29:10 +0200
Message-ID: <1790578.NZeHVGuJeN@wuerfel>
References: <201510011845.GN7Kisc4%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201510011845.GN7Kisc4%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, JBottomley-wo1vFcy6AUs@public.gmane.org, vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, amit.daniel-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thursday 01 October 2015 18:46:34 kbuild test robot wrote:
> [auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]
> 
> config: x86_64-allmodconfig (attached as .config)
> reproduce:
>         git checkout 6e153e3bf7c68b019e987c5a0ffadebd9c7d4fbb
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All error/warnings (new ones prefixed by >>):
> 
> >> ERROR: "ufs_hba_exynos_ops" [drivers/scsi/ufs/ufshcd-pltfrm.ko] undefined!
> 
> 

Ah, this seems to be a case of layering violation. It would be best to
restructure the code so that the exynos driver registers a platform_driver
by itself for the respective DT compatible string, and then calls
into the common code from its probe function, rather than having the
generic driver know about the specific backends.

That approach will also make the generic driver more scalable as we
add further chip-specific variations, and matches what we do in other
drivers.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
